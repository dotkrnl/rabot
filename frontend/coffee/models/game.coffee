Emitter = require('../utils/emitter.coffee')

# A helper function to coverent angle in degree to rad.
toRad = (degrees) ->
  degrees * Math.PI / 180.0

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

  # Add a sprite with the format defined in stage_data/exampleStage.json
  addSprite: (sprite) ->
    console.error('no sprite type') unless sprite.type?
    sprite.x = 0 unless sprite.x?
    sprite.y = 0 unless sprite.y?
    sprite.angle = 0 unless sprite.angle?
    sprite.lethal = false unless sprite.lethal?
    sprite.passabel = true unless sprite.passabel?
    sprite.defunct = false unless sprite.defunct?
    sprite.uid = @sprites.length
    @sprites.push(sprite)
    @update(0)
    return

  # Remove a sprite in the game scene
  removeSprite: (toRemove) ->
    for sprite in @sprites
      if sprite == toRemove
        toRemove.defunct = true
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
  # @param type: the type of sprites to get
  getSprites: (type) ->
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
    @scene.clear()
    data = JSON.parse(@stageData)
    @addSprite(sprite) for sprite in data
    return

  # Resatrt the current stage.
  restartStage:  ->
    @loadStage(@stageData)

  # Associate with game scene and register the game model to it
  # @param gameScene the game scene to register to.
  register: (gameScene) ->
    @scene = gameScene
    @scene._register(@)

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

  # Move the rabbit along the direction of its current orientation.
  # This function will call @update, producing animation in the game scene.
  # @param step to move, currently in pixels.
  # @param callback, function to call when animation is finished.
  move: (step, callback) ->
    rabbit = @getRabbit()
    rabbit.x += step * Math.sin(toRad(rabbit.angle))
    rabbit.y -= step * Math.cos(toRad(rabbit.angle))
    @update step, =>
      @stepFinished()
      callback()
    return

  # Turn the orientation of the rabbit by angle, in degree, clockwisely.
  # This function will call @update, producing animation in the game scene.
  # @param angle to turn, in degree
  # @param callback, function to call when animation is finished.
  turn: (angle, callback) ->
    rabbit = @getRabbit()
    rabbit.angle += angle
    @stepFinished()
    @update angle, =>
      @stepFinished()
      callback()
    return

  # This function is called when each step (i.e user interface call),
  # to perform collision detection and add update the number of
  # carrots that player has got.
  stepFinished: ->
    rabbit = @getRabbit()
    for carrot in @filterSprites(type: 'carrot', defunct: false)
      if @scene.collided(rabbit, carrot)
        @removeSprite(carrot)
        @carrotGot++

  # This function is called when the game is finished.
  # This function will perform win / lost check,
  # triggering the corresponding event, as well as the finish event
  # TODO: the check shouldn't be just a collision detection
  finish: ->
    victory = @carrotGot > 0
    if victory
      @trigger('win')
    else
      @trigger('lost')
    @trigger('finish')
    return


module.exports = Game
