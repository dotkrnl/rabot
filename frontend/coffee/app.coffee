Game = require './models/game.coffee'
GameScene = require './views/gamescene.coffee'
UserWorker = require './worker/worker.coffee'
StageManager = require './models/stagemanager.coffee'

$ ->

  # Init code editor object.
  editorCodeMirror = CodeMirror.fromTextArea(document.getElementById('code-editor'), lineNumbers: true)

  # Set size for some objects whose size may be not adjusted with CSS.
  updateLayout = ->
    editorCodeMirror.setSize $('#container-code-editor').width(), $('#container-code-editor').height()
    $('#play-canvas').width $('#container-play').width()
    $('#play-canvas').height $('#container-play').height()
  updateLayout()
  $(window).resize updateLayout

  # Init the game model, scene and all related objects.
  game = new Game
  gameScene = new GameScene "#play-canvas"
  game.register gameScene
  userWorker = null

  # Init the stage manager
  stageManager = new StageManager

  # TODO: currently an element with text is used to indicate win/lost status
  # after relative events. UI will be more friendly in future.
  game.on 'win', ->
    $('#status').text('Win')
  game.on 'lost', ->
    $('#status').text('Lost')

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

  stageManager.queryStageList (result) ->
    if result.status == 'succeeded'
      menuHtml = ''
      for stage in result.data
        menuHtml += "<li class=\"stage-dropdown-item\" id=\"stage-dropdow \
        n-item-#{stage}\"><a href=\"#\">#{stage}</a></li>"
      $('#stage-dropdown').html(menuHtml)
  $(".stage-dropdown-item").click ->
    arr = event.currentTarget.id.split('-')
    stageName = arr[arr.length - 1]
    console.log stageName
    stageManager.getStage stageName, (result) ->
      if result.status == 'succeeded'
        alert "Stub, succeeded!\n#{result.data}"
      else
        alert "Stub, failed!"
