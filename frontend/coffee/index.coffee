$ ->
  editorCodeMirror = CodeMirror.fromTextArea(document.getElementById('code-editor'), lineNumbers: true)
  editorCodeMirror.setSize $('#container-code-editor').width(), $('#container-code-editor').height()
  $('#play-canvas').width $('#container-play').width()
  $('#play-canvas').height $('#container-play').height()
  $(window).resize ->
    editorCodeMirror.setSize $('#container-code-editor').width(), $('#container-code-editor').height()
    $('#play-canvas').width $('#container-play').width()
    $('#play-canvas').height $('#container-play').height()
  gameScene = new GameScene "#play-canvas"
  $('#button-run-code').click ->
    enableUserInterface(gameScene)
    jsCode = CoffeeScript.compile(editorCodeMirror.getValue(), {runtime:"none"})
    executeUserCode(jsCode)
  $('#button-stop-code').click ->
    gameScene.rotateRabbit 90, 1000
