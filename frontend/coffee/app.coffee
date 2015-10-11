Game = require './models/game.coffee'
GameScene = require './views/gamescene.coffee'
UserWorker = require './worker/worker.coffee'

$ ->
  editorCodeMirror = CodeMirror.fromTextArea(document.getElementById('code-editor'), lineNumbers: true)
  editorCodeMirror.setSize $('#container-code-editor').width(), $('#container-code-editor').height()
  $('#play-canvas').width $('#container-play').width()
  $('#play-canvas').height $('#container-play').height()
  $(window).resize ->
    editorCodeMirror.setSize $('#container-code-editor').width(), $('#container-code-editor').height()
    $('#play-canvas').width $('#container-play').width()
    $('#play-canvas').height $('#container-play').height()

  game = new Game
  gameScene = new GameScene "#play-canvas"
  game.register gameScene
  userWorker = null

  game.on 'win', ->
    $('#status').text('Win')
  game.on 'lost', ->
    $('#status').text('Lost')

  game.on 'finish', ->
    userWorker.terminate() if userWorker?
    userWorker = null

  $('#button-run-code').click ->
    code = editorCodeMirror.getValue()
    userWorker = new UserWorker game, code

  $('#button-stop-code').click ->
    game.finish()
