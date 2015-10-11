asyncify = require './asyncify.coffee'

class UserCodeWorker
  constructor: (@game, @code) ->
    asyncCode = asyncify(@code)
    jsCode = CoffeeScript.compile \
      @USERSPACE_API + asyncCode + @USERSPACE_END,
      runtime: "inline"

    blob = new Blob([jsCode], { type: "text/javascript" })
    @worker = new Worker(window.URL.createObjectURL(blob))
    @worker.onmessage = @onmessage.bind(@)

  onmessage: (m) ->
    m = m.data if m?
    if not m? or not m.action?
      return

    switch m.action
      when "move"
        @game.move m.step, @resume.bind(@)
      when "turn"
        @game.turn m.angle, @resume.bind(@)
      when "finish"
        @game.finish()

  resume: ->
    @worker.postMessage
      action: 'resume'

  terminate: ->
    @worker.terminate()

  USERSPACE_API: """
    left = -90
    right = 90

    __rabot_nop = ->

    __rabot_resume = __rabot_nop

    move = (step, callback) ->
      __rabot_resume = ->
        __rabot_resume = __rabot_nop
        callback()
      @postMessage
        action: 'move'
        step: step

    turn = (angle, callback) ->
      __rabot_resume = ->
        __rabot_resume = __rabot_nop
        callback()
      @postMessage
        action: 'turn'
        angle: angle

    __rabot_finished = ->
      @postMessage
        action: 'finish'

    @onmessage = (e) ->
      e = e.data if e?
      if e? and e.action? and \
          e.action == 'resume'
        __rabot_resume()

    """

  USERSPACE_END: "\n__rabot_finished()\n"

module.exports = UserCodeWorker
