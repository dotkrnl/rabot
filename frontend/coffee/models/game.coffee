Emitter = require('../utils/emitter.coffee')

# A helper function to coverent angle in degree to rad.
toRad = (degrees) ->
  degrees * Math.PI / 180.0

# The Game class defines the model for the Rabot game
class Game extends Emitter

  # Construct the game model. Currently the position of all objects are hard-coded.
  # No game scene is related with the game model when it's constructed.
  constructor: ->
    @units = {}
    @nextUnitId = 0
    @scene = null
    @loadStage()
    super()

  # Add a unit with the format defined in stage_data/exampleStage.json
  # the defined format is not compatible with the current interface of game model
  # so some conversion work is needed.
  # TODO: Reducing property conversion.
  addUnit: (unit) ->
    @units[unit.Type] = [] if not @units[unit.Type]?
    parsedUnit =
      x: parseInt(unit.Position[0])
      y: parseInt(unit.Position[1])
      angle: if unit.angle? then parseInt(unit.angle) else 0
      id: @nextUnitId
    @nextUnitId++
    @units[unit.Type].push(parsedUnit)

  # Load an stage defined by the format defined in stage_data/exampleStage.json
  # TODO: Currenly the object is hard-coded.
  loadStage: () ->
    sceneObj = [
      {"Type": "Rabbit", "Position" :["300","370"], "Angle" :"0"}
      {"Type": "Carrot", "Passable": "true", "Lethal": "false", "Position": ["300", "50"]}
      {"Type": "Carrot", "Passable": "true", "Lethal": "false", "Position": ["300", "90"]}
    ]
    for unit in sceneObj
      @addUnit(unit)

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
    rabbit = @units.Rabbit[0]
    rabbit.x += step * Math.sin(toRad(rabbit.angle))
    rabbit.y -= step * Math.cos(toRad(rabbit.angle))
    @update(step, callback)
    return

  # Turn the orientation of the rabbit by angle, in degree, clockwisely.
  # This function will call @update, producing animation in the game scene.
  # @param step to move, currently in pixels.
  # @param callback, function to call when animation is finished.
  turn: (angle, callback) ->
    rabbit = @units.Rabbit[0]
    rabbit.angle += angle
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
