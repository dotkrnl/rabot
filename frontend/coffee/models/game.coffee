Emitter = require('../utils/emitter.coffee')

toRad = (degrees) ->
  degrees * Math.PI / 180.0

class Game extends Emitter
  constructor: ->
    @carrot =
      x: 300, y: 50
      angle: 0
    @rabbit =
      x: 300, y: 370
      angle: 0
    @scene = null
    super()

  register: (gameScene) ->
    @scene = gameScene
    @scene._register(@)

  update: (scale, callback) ->
    @trigger('update')
    if @scene?
      @scene.update(scale, callback)
    else
      callback() if callback?
    return

  move: (step, callback) ->
    @rabbit.x += step * Math.sin(toRad(@rabbit.angle))
    @rabbit.y -= step * Math.cos(toRad(@rabbit.angle))
    @update(step, callback)
    return

  turn: (angle, callback) ->
    @rabbit.angle += angle
    @update(angle, callback)
    return

  finish: ->
    if @scene.collided()
      @trigger('win')
    else
      @trigger('lost')
    @trigger('finish')
    return


module.exports = Game
