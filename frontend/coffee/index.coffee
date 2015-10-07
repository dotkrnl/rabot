move = (step, callback) ->
  stepX = step * Math.sin(gameScene.rabbit.angle / 180.0 * Math.PI)
  stepY = step * Math.cos(gameScene.rabbit.angle / 180.0 * Math.PI)
  gameScene.moveRabbit stepX, -stepY, Math.abs(5 * step), callback

turn = (angle, callback) ->
  gameScene.rotateRabbit angle, Math.abs(5 * angle), callback

userCodeFinished = ->
  if gameScene.isWin()
    alert "You win!"
  else
    alert "You lose"
  window.userWorker.terminate()
  window.userWorker = null

class @UserCodeWorker
  constructor: (@code) ->
    preprocessedCode = window.preprocessUserCode(@code)
    @jsCode = CoffeeScript.compile preprocessedCode,
      runtime: "inline"

    continueUserCode = =>
      @worker.postMessage
        action: 'continue'

    handleMessage = (m) =>
      m = m.data if m?
      if not m? or not m.action?
        return
      switch m.action
        when "move"
          move(m.step, continueUserCode)
        when "turn"
          turn(m.angle, continueUserCode)
        when "userCodeFinished"
          userCodeFinished()

    blob = new Blob([@jsCode], { type: "text/javascript" })
    @worker = new Worker(window.URL.createObjectURL(blob))
    @worker.onmessage = handleMessage

  terminate: ->
    @worker.terminate()


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
    userCodeFinished()
