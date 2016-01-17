Emitter = require('../commons/logic/emitter.coffee')

# A helper function to coverent angle in degree to rad.
toRad = (degrees) ->
  degrees * Math.PI / 180.0

toDeg = (rad) ->
  rad / Math.PI * 180.0

normalizeAngle = (degrees) ->
  while degrees > 180
    degrees -= 360
  while degrees < -180
    degrees += 360
  return degrees

# A helper function to clone object
cloned = (obj) ->
  if not obj? or typeof obj != 'object'
    return obj;
  copy = {}
  for key, value of obj
    copy[key] = cloned(value)
  return copy;

# The Game class defines the model for the Rabot game
class Game extends Emitter

  # Construct the game model.
  # No game scene is related with the game model when it's constructed.
  constructor: ->
    @sprites = []
    @scene = null
    @carrotGot = 0
    @stageData = ''
    super()

  # Clone and add a sprite with the format defined in exampleStage.json
  # updateNow is a work-around for game element label initialization.
  addSprite: (sprite, updateNow) ->
    sprite = cloned(sprite)
    throw new Error('no sprite type') unless sprite.type?
    sprite.x = 0 unless sprite.x?
    sprite.y = 0 unless sprite.y?
    sprite.angle = 0 unless sprite.angle?
    sprite.defunct = false unless sprite.defunct?
    sprite.uid = @sprites.length
    @sprites.push(sprite)
    @update(0) if updateNow?
    return

  # Remove a sprite in the game scene
  removeSprite: (uid) ->
    @sprites[uid].defunct = true
    @update(0)
    return

  # Get sprites that satisfied 'filter'
  # @param filter: e.g. {x: 300, y: 370}
  filterSprites: (filter) ->
    results = []
    for sprite in @sprites
      satisfied = true
      for name, attr of filter
        if sprite[name] != attr
          satisfied = false
          break
      results.push sprite if satisfied
    return results

  # Get sprites which are 'type'
  # @param type: the type of sprites to get (optional)
  getSprites: (type) ->
    if not type?
      @filterSprites()
    else
      @filterSprites(type: type)

  # Get rabit sprite
  getRabbit: ->
    @getSprites('rabbit')[0]

  # Load an stage with json.
  # format specified in stage_data/exampleStage.json
  loadStage: (json) ->
    @stageData = json
    @carrotGot = 0
    @sprites = []
    @gameOverFlag = false
    @keysObtained = []
    @scene.clear() if @scene
    data = JSON.parse(@stageData)
    @addSprite(sprite) for sprite in data
    @update(0)
    return

  # Resatrt the current stage.
  restartStage:  ->
    @loadStage(@stageData)

  # Associate with game scene and register the game model to it
  # @param gameScene the game scene to register to.
  register: (gameScene) ->
    @scene = gameScene
    @scene._register(@)

  # Cancel the association of the game with the game scene. This will also
  # clear the game scene.
  unregister: ->
    @scene._unregister()
    @scene = null

  # Should be called whenever a change is made to the model, to notify the
  # game scene to keep synchronized with the model (with an animation).
  # It will also triggers "update" event.
  update: (scale, callback) ->
    @trigger('update')
    if @scene?
      @scene.update(scale, callback)
    else
      callback() if callback?
    return

  movePredict: (stepRemaining) ->
    SCAN_STEP = 0.1
    rabbit = @getRabbit()
    origX = rabbit.x
    origY = rabbit.y
    stepScanned = 0
    ret = {}
    lastCollision = []
    while true
      rabbit.x += SCAN_STEP * Math.sin(toRad(rabbit.angle))
      rabbit.y -= SCAN_STEP * Math.cos(toRad(rabbit.angle))
      stepScanned += SCAN_STEP

      currentCollision = []
      for elem in @filterSprites(defunct: false)
        continue if elem == rabbit or not elem.region?
        if elem.region.radius? and
        (rabbit.x - elem.x) * (rabbit.x - elem.x) +
        (rabbit.y - elem.y) * (rabbit.y - elem.y) <
        elem.region.radius * elem.region.radius
          currentCollision.push(elem)
          if elem.type not in lastCollision and stepScanned > SCAN_STEP * 1.5
            collisionFlag = true
            ret =
              collision: elem
              step: stepScanned
            currentCollision.append
            break
        else if elem.region.width? and
        rabbit.x > elem.x - elem.region.width / 2 and
        rabbit.x < elem.x + elem.region.width / 2 and
        rabbit.y > elem.y - elem.region.height / 2 and
        rabbit.y < elem.y + elem.region.height / 2
          currentCollision.push(elem)
          collisionFlag = true
          ret =
            collision: elem
            step: stepScanned
          break

      lastCollision = currentCollision
      break if currentCollision.length > 0

      if stepScanned >= stepRemaining
        ret =
          collision: null
          step: stepRemaining
        break

    rabbit.x = origX
    rabbit.y = origY
    return ret

  collisionHandler: (collision, continueCallback, cancelCallback) ->
    if collision.type == "carrot"
      createjs.Sound.play("item-get", {loop: 0})
      @removeSprite(collision.uid)
      @carrotGot++
      continueCallback() if continueCallback?
    if collision.type == "river"
      @gameOverFlag = true
      continueCallback() if continueCallback?
    if collision.type == "key"
      createjs.Sound.play("item-get", {loop: 0})
      @keysObtained.push(collision.keyId)
      @removeSprite(collision.uid)
      continueCallback() if continueCallback?
    if collision.type == "door"
      if @keysObtained.indexOf(collision.keyId) == -1
        cancelCallback() if cancelCallback?
      else
        @removeSprite(collision.uid)
        continueCallback() if continueCallback?
    if collision.type == "rotator"
      @turn(collision.rotation, continueCallback)

  # Move the rabbit along the direction of its current orientation.
  # This function will call @update, producing animation in the game scene.
  # @param step to move, currently in pixels.
  # @param callback, function to call when animation is finished.
  move: (step, callback) ->
    if @gameOverFlag
      callback() if callback?
      return
    rabbit = @getRabbit()
    prediction = @movePredict(step)
    if not prediction.collision?
      rabbit.x += step * Math.sin(toRad(rabbit.angle))
      rabbit.y -= step * Math.cos(toRad(rabbit.angle))
      @update step, =>
        callback() if callback?
    else
      rabbit.x += prediction.step * Math.sin(toRad(rabbit.angle))
      rabbit.y -= prediction.step * Math.cos(toRad(rabbit.angle))
      @update prediction.step, =>
        @collisionHandler prediction.collision, (=>
          @move(step - prediction.step, callback)), (=>
          callback() if callback)

  # Turn the orientation of the rabbit by angle, in degree, clockwisely.
  # This function will call @update, producing animation in the game scene.
  # @param angle to turn, in degree
  # @param callback, function to call when animation is finished.
  turn: (angle, callback) ->
    if @gameOverFlag
      callback() if callback?
      return
    # avoid stupid action of users
    angle -= 360 while angle > 1080
    angle += 360 while angle < -1080
    rabbit = @getRabbit()
    rabbit.angle += angle
    @update angle, =>
      callback() if callback?
    return

  # Turn the orientation of the rabbit by choosing an object.
  # This function will call @update, producing animation in the game scene.
  # @param objectName object to turn to
  # @param callback, function to call when animation is finished.
  # TODO: currently object name is not fully supported, type will be used.
  turnTo: (uid, callback) ->
    rabbit = @getRabbit()
    objects = @filterSprites(uid: uid, defunct: false)
    if objects.length <= 0
      callback() if callback?
      return
    object = objects[0]
    dx = object.x - rabbit.x
    dy = object.y - rabbit.y
    angle = normalizeAngle(toDeg(Math.atan2(dx, -dy)) - rabbit.angle)
    @turn angle, callback

  # This function is called when the game is finished.
  # This function will perform win / lost check,
  # triggering the corresponding event, as well as the finish event
  finish: ->
    victory = @carrotGot > 0 and not @gameOverFlag
    if victory
      @trigger('win')
    else
      @trigger('lost')
    @trigger('finish')
    return

  onWorkerHighlight: (lineNumber) ->
    @trigger('workerhighlight', lineNumber)

  onWorkerUnhighlight: (lineNumber) ->
    @trigger('workerunhighlight', lineNumber)


module.exports = Game
