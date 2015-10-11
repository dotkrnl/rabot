Game = require './models/game.coffee'
GameScene = require './views/gamescene.coffee'
UserWorker = require './worker/worker.coffee'

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
