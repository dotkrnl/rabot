
@userInterface =
  left: -90
  right: 90
  move: (step, callback) ->
    stepX = step * Math.sin(gameScene.rabbitAngle / 180.0 * Math.PI)
    stepY = step * Math.cos(gameScene.rabbitAngle / 180.0 * Math.PI)
    gameScene.moveRabbit stepX, -stepY, 100 * step, callback
  turn: (angle, callback) ->
    gameScene.rotateRabbit angle, 10 * angle, callback

@enableUserInterface = (gameScene) ->
  @gameScene = gameScene
  for key, value of @userInterface
    this[key] = value
  return undefined

@executeUserCode = (jsCode) ->
  eval jsCode

@disableUerInterface = ->
  for key, value of @userInterface
    this[key] = undefined
  @gameScene = undefined
  return undefined

@userCodeFinished = ->
  if @gameScene.isWin()
    alert "You win!"
  else
    alert "You lose"
  disableUerInterface()
