module.exports =
  move: (step, callback) ->
    stepX = step * Math.sin(gameScene.rabbit.angle / 180.0 * Math.PI)
    stepY = step * Math.cos(gameScene.rabbit.angle / 180.0 * Math.PI)
    window.gameScene.moveRabbit stepX, -stepY, Math.abs(5 * step), callback

  turn: (angle, callback) ->
    window.gameScene.rotateRabbit angle, Math.abs(5 * angle), callback

  finished: ->
    if window.gameScene.isWin()
      alert "You win!"
    else
      alert "You lose"
    window.userWorker.terminate()
    window.userWorker = null
