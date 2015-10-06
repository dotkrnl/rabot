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
    coffeeCode = editorCodeMirror.getValue()
    preprocessedCode = preprocessUserCode(coffeeCode)
    jsCode = CoffeeScript.compile(preprocessedCode, {runtime:"none"})
    #console.log preprocessedCode
    executeUserCode jsCode
  $('#button-stop-code').click ->
    gameScene.rotateRabbit 90, 1000
