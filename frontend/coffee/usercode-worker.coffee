preprocessUserCode = require './usercode-preprocessor.coffee'
userLib = require './usercode-lib.coffee'

class UserCodeWorker
  constructor: (@code) ->
    preprocessedCode = preprocessUserCode(@code)
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
          userLib.move(m.step, continueUserCode)
        when "turn"
          userLib.turn(m.angle, continueUserCode)
        when "userCodeFinished"
          userLib.finished()

    blob = new Blob([@jsCode], { type: "text/javascript" })
    @worker = new Worker(window.URL.createObjectURL(blob))
    @worker.onmessage = handleMessage

  terminate: ->
    @worker.terminate()

module.exports = UserCodeWorker
