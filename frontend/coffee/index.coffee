$ ->
  editorCodeMirror = CodeMirror.fromTextArea(document.getElementById('code-editor'), lineNumbers: true)
  canvas = Snap('#play-canvas')
  editorCodeMirror.setSize $('#container-code-editor').width(), $('#container-code-editor').height()
  $('#play-canvas').width $('#container-play').width()
  $('#play-canvas').height $('#container-play').height()
  $(window).resize ->
    editorCodeMirror.setSize $('#container-code-editor').width(), $('#container-code-editor').height()
    $('#play-canvas').width $('#container-play').width()
    $('#play-canvas').height $('#container-play').height()
  bigCircle = canvas.circle(200, 200, 100)
  bigCircle.attr
    fill: '#bada55'
    stroke: '#000'
    strokeWidth: 5
  $('#button-run-code').click ->
    jsCode = CoffeeScript.compile(editorCodeMirror.getValue())
    eval jsCode
