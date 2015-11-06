(function() {
  $(function() {
    var editorCodeMirror, gameScene;
    editorCodeMirror = CodeMirror.fromTextArea(document.getElementById('code-editor'), {
      lineNumbers: true
    });
    editorCodeMirror.setSize($('#container-code-editor').width(), $('#container-code-editor').height());
    $('#play-canvas').width($('#container-play').width());
    $('#play-canvas').height($('#container-play').height());
    $(window).resize(function() {
      editorCodeMirror.setSize($('#container-code-editor').width(), $('#container-code-editor').height());
      $('#play-canvas').width($('#container-play').width());
      return $('#play-canvas').height($('#container-play').height());
    });
    gameScene = new GameScene("#play-canvas");
    $('#button-run-code').click(function() {
      var coffeeCode, jsCode, preprocessedCode;
      enableUserInterface(gameScene);
      coffeeCode = editorCodeMirror.getValue();
      preprocessedCode = preprocessUserCode(coffeeCode);
      jsCode = CoffeeScript.compile(preprocessedCode, {
        runtime: "none"
      });
      return executeUserCode(jsCode);
    });
    return $('#button-stop-code').click(function() {
      return gameScene.rotateRabbit(90, 1000);
    });
  });

}).call(this);
