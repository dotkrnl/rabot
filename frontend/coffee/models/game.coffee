Emitter = require('../utils/emitter.coffee')

# A helper function to coverent angle in degree to rad.
toRad = (degrees) ->
  degrees * Math.PI / 180.0

# The Game class defines the model for the Rabot game
class Game extends Emitter

  # Construct the game model. Currently the position of all objects are hard-coded.
  # No game scene is related with the game model when it's constructed.
  constructor: ->
    @sprites = []
    @scene = null
    # TODO: load stage from server/local storage
    @loadStage("""[
      {"type":"carrot","x":300,"y":50},
      {"type":"rabbit","x":300,"y":370,"angle":0}
    ]""")
    super()

  # Add a sprite with the format defined in stage_data/exampleStage.json
  addSprite: (sprite) ->
    console.error('no sprite type') if not sprite.type?
    sprite.x = 0 if not sprite.x?
    sprite.y = 0 if not sprite.y?
    sprite.angle = 0 if not sprite.angle?
    sprite.lethal = false if not sprite.lethal?
    sprite.passabel = true if not sprite.passabel?
    sprite.uid = @sprites.length
    @sprites.push(sprite)

  # Get sprites that satisfied 'filter'
  # @param filter: e.g. {position: [300,370]}
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
    @filterSprites
      type: type

  # Get rabit sprite
  getRabbit: ->
    return @getSprites('rabbit')[0]

  # Load an stage with json. the format is defined in stage_data/exampleStage.json
  loadStage: (json) ->
    data = JSON.parse(json)
    for sprite in data
      @addSprite(sprite)

  # Register the model to a game scene by calling the _register function of the
  # game scene.
  # @param gameScene the game scene to register to.
  register: (gameScene) ->
    @scene = gameScene
    @scene._register(@)

  # This function is called whenever a change is made to the model, to notify the
  # game scene to keep synchronized with the model (with an animation), by calling
  # GameScene.update. It will also triggers "update" event.
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
    @update(step, callback)
    return

  # Turn the orientation of the rabbit by angle, in degree, clockwisely.
  # This function will call @update, producing animation in the game scene.
  # @param step to move, currently in pixels.
  # @param callback, function to call when animation is finished.
  turn: (angle, callback) ->
    rabbit = @getRabbit()
    rabbit.angle += angle
    @update(angle, callback)
    return

  # This function is called when the game is finished. This function will perform
  # win / lost check, triggering the corresponding event, as well as the finish
  # event. Currently the check is just a collision detection at the end of the game.
  finish: ->
    victory = false
    rabbit = @getRabbit()

    for carrot in @getSprites('carrot')
      if @scene.collided(rabbit, carrot)
        victory = true
        break

    if victory
      @trigger('win')
    else
      @trigger('lost')

    @trigger('finish')
    return


module.exports = Game
