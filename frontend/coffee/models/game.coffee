Emitter = require('../utils/emitter.coffee')

# A helper function to coverent angle in degree to rad.
toRad = (degrees) ->
  degrees * Math.PI / 180.0

# The Game class defines the model for the Rabot game
class Game extends Emitter

  # Construct the game model. Currently the position of all objects are hard-coded.
  # No game scene is related with the game model when it's constructed.
  constructor: ->
    @carrot =
      x: 300, y: 50
      angle: 0
    @rabbit =
      x: 300, y: 370
      angle: 0
    @scene = null
    super()

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
    @rabbit.x += step * Math.sin(toRad(@rabbit.angle))
    @rabbit.y -= step * Math.cos(toRad(@rabbit.angle))
    @update(step, callback)
    return

  # Turn the orientation of the rabbit by angle, in degree, clockwisely.
  # This function will call @update, producing animation in the game scene.
  # @param step to move, currently in pixels.
  # @param callback, function to call when animation is finished.
  turn: (angle, callback) ->
    @rabbit.angle += angle
    @update(angle, callback)
    return

  # This function is called when the game is finished. This function will perform
  # win / lost check, triggering the corresponding event, as well as the finish
  # event. Currently the check is just a collision detection at the end of the game.
  finish: ->
    if @scene.collided()
      @trigger('win')
    else
      @trigger('lost')
    @trigger('finish')
    return


module.exports = Game
