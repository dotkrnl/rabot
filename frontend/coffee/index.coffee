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
    gameScene.moveRabbit 0, -100, 1000, ->
      gameScene.rotateRabbit 90, 1000, ->
        gameScene.moveRabbit 100, 0, 1000, ->
          gameScene.rotateRabbit 90, 1000, ->
            gameScene.moveRabbit 0, 100, 1000, ->
              gameScene.rotateRabbit 90, 1000, ->
                gameScene.moveRabbit -100, 0, 1000, ->
                  gameScene.rotateRabbit 90, 1000
    jsCode = CoffeeScript.compile(editorCodeMirror.getValue())
    eval jsCode
  $('#button-stop-code').click ->
    gameScene.rotateRabbit 90, 1000
