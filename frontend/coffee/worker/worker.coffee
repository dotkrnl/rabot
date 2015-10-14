asyncify = require './asyncify.coffee'

class UserCodeWorker

  # Build a new worker to execute user code. The game model and user code is
  # required to be specified. when the object is constructed, the user code will
  # be asyncified, extended with API in worker, and compiled by IcedCoffeeScript
  # compiler.
  # @param @game the game model
  # @param @code the user code
  constructor: (@game, @code) ->
    asyncCode = asyncify(@code)

    # "runtime" have to be set for default implementation involves using node.js.
    jsCode = CoffeeScript.compile \
      @USERSPACE_API + asyncCode + @USERSPACE_END,
      runtime: "inline"

    blob = new Blob([jsCode], { type: "text/javascript" })
    @worker = new Worker(window.URL.createObjectURL(blob))

    # The message handler for user worker needs to be in the context of the
    # UserCodeWorker object. So .bind(@) is necessary.
    @worker.onmessage = @onmessage.bind(@)

  # The user code worker message handler. It will modify the scene corresponding
  # to the message, triggering the animation effect in the game scene. When the
  # game scene animation is finished. The @resume method will be called, recovering
  # the execution of user code.
  # @param m the message object
  onmessage: (m) ->
    m = m.data if m?
    if not m? or not m.action?
      return

    # Note, when adding new actions, use @resume.bind(@) instead of just @resume
    # @resume needs to be working in the context of the UserCodeWorker object.
    switch m.action
      when "move"
        @game.move m.step, @resume.bind(@)
      when "turn"
        @game.turn m.angle, @resume.bind(@)
      when "finish"
        @game.finish()

  # The callback to resume user code by post a message to user worker.
  # see @onmessage for more information.
  resume: ->
    @worker.postMessage
      action: 'resume'

  # Terminate the user worker.
  terminate: ->
    @worker.terminate()

  # This is the API for user code in the worker, they have to be stored in a
  # string due to the access limitation for user worker.
  # Those API's are mostly have the save name with those in the game model class.
  # They post message to the main thread, then the game model will be modified.
  # The user code API also have a @message method, to receive the resume signal
  # from the main thread.
  # See the message handler @onmessage, and @resume for further information.
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

  # This will notify main thread that the execution of user code is finished.
  USERSPACE_END: "\n__rabot_finished()\n"

module.exports = UserCodeWorker
