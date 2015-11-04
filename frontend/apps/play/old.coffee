#Game = require './models/game.coffee'
#GameScene = require './views/gamescene.coffee'
#UserWorker = require './worker/worker.coffee'
#StageManager = require './models/stagemanager.coffee'
#LoginManager = require './models/loginmanager.coffee'
#LoginUI = require './views/loginui.coffee'

$ ->

  # Init the game model, scene and all related objects.
  game = new Game
  gameScene = new GameScene "#play-canvas"
  game.register gameScene
  userWorker = null

  # Init the stage manager
  stageManager = new StageManager
  loginManager = new LoginManager
  loginUI = new LoginUI
  loginManager.register loginUI

  # TODO: currently an element with text is used to indicate win/lost status
  # after relative events. UI will be more friendly in future.
  game.on 'win', ->
    $('#status').text('Win' + game.carrotGot)
    game.restartStage()
  game.on 'lost', ->
    $('#status').text('Lost')
    game.restartStage()

  # Terminate worker for user code after game finished.
  game.on 'finish', ->
    userWorker.terminate() if userWorker?
    userWorker = null

  # Handles the "Run" and "Stop" button events.
  $('#button-run-code').click ->
    code = editorCodeMirror.getValue()
    userWorker = new UserWorker game, code

  $('#button-stop-code').click ->
    game.finish()

  startUpStageLoad = true
  stageManager.queryStageList (result) ->
    menuHtml = ''
    for stage in result
      menuHtml += "<li class=\"stage-dropdown-item\" \
      id=\"stage-dropdown-item-#{stage.id}\"> \
      <a href=\"#\">#{stage.name}</a></li>"
    $('#stage-dropdown').html(menuHtml)

    if startUpStageLoad
      stageManager.getStage result[0].id, (result) ->
        if result.status == 'succeeded'
          game.loadStage(result.info)
      startUpStageLoad = false

    $(".stage-dropdown-item").unbind('click')
    $(".stage-dropdown-item").click ->
      arr = event.currentTarget.id.split('-')
      stageName = arr[arr.length - 1]

      stageManager.getStage stageName, (result) ->
        if result.status == 'succeeded'
          game.loadStage(result.info)
        else
          console.log("Stub, failed!")


  loginManager.loginCheck()

  $("#navbar_login_button").click ->
    loginManager.login($("#navbar_username").val(), $("#navbar_password").val())
    event.preventDefault()

  $("#navbar_logout_button").click ->
    loginManager.logout()
    event.preventDefault()
