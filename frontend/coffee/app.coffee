GameScene = require './game-scene.coffee'
UserCodeWorker = require './usercode-worker.coffee'
userLib = require './usercode-lib.coffee'

$ ->
  editorCodeMirror = CodeMirror.fromTextArea(document.getElementById('code-editor'), lineNumbers: true)
  editorCodeMirror.setSize $('#container-code-editor').width(), $('#container-code-editor').height()
  $('#play-canvas').width $('#container-play').width()
  $('#play-canvas').height $('#container-play').height()
  $(window).resize ->
    editorCodeMirror.setSize $('#container-code-editor').width(), $('#container-code-editor').height()
    $('#play-canvas').width $('#container-play').width()
    $('#play-canvas').height $('#container-play').height()

  window.gameScene = new GameScene "#play-canvas"

  $('#button-run-code').click ->
    code = editorCodeMirror.getValue()
    window.userWorker = new UserCodeWorker code \
      if not window.userWorkerk

  $('#button-stop-code').click ->
    userLib.finished()
