asyncify = require './asyncify.coffee'

class UserCodeWorker

  # Build a new worker to execute user code with userspace API.
  # When the object is constructed, the user @code will be executing.
  # All userspace API calling will be redirected to @game
  # By calling userspace API, the worker will be paused until
  # resume, as an callback of @game, called.
  # @param @game the game model
  # @param @code the user code
  constructor: (@game, @code) ->
    userAPIList = ['move', 'turn', 'turnTo']
    asyncCode = asyncify(@code, userAPIList)

    workerSpriteInitCode = """

    __rabot_add_game_sprites(#{JSON.stringify(@prepareWorkerGameObject())})

    """

    # set "runtime" to be inlined instead of node
    jsCode = CoffeeScript.compile \
      @USERSPACE_API + workerSpriteInitCode + asyncCode + @USERSPACE_END,
      runtime: "inline"

    blob = new Blob([jsCode], { type: "text/javascript" })
    @worker = new Worker(window.URL.createObjectURL(blob))

    # The message handler for user worker
    @worker.onmessage = @onmessage.bind(@)

  # The user code worker message handler. It will call the @game to update
  # When the @resume callback called (game scene animation is finished),
  # the execution of user code will be resumed.
  # @param m the message object
  onmessage: (m) ->
    m = m.data if m?
    if not m? or not m.action?
      return

    # @resume needs to be in the context of the UserCodeWorker object.
    switch m.action
      when "move"
        @game.move(m.step, @resume.bind(@))
      when "turn"
        @game.turn(m.angle, @resume.bind(@))
      when "turnTo"
        @game.turnTo(m.uid, @resume.bind(@))
      when "finish"
        @game.finish()

  prepareWorkerGameObject: () ->
    ret = {}
    availableSpriteTypes = ["rabbit", "carrot", "key", "door"]
    for type in availableSpriteTypes
      ret[type] = @game.filterSprites({"type":type})
      if ret[type]? and ret[type].length == 1
        ret[type] = ret[type][0]
    return ret

  # The callback to resume user code by post a message to user worker.
  # see @onmessage for more information.
  resume: ->
    @worker.postMessage
      action: 'resume'
      gameSprites: @prepareWorkerGameObject()

  # Terminate the user worker.
  terminate: ->
    @worker.terminate()

  # This is the API for user code in the worker userspace.
  # They have to be stored in a string to inline to the user code.
  # They post message to the main thread, then pass to the game model.
  # @onmessage method to receive the resume signal from the main thread.
  # See @onmessage, and @resume for further information.
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

    highlight = (lineNumber) ->
      #TODO : Stub, this function is reserved for callstack display.

    unhighlight = (lineNumber) ->
      #TODO : Stub, this function is reserved for callstack display.

    turn = (angle, callback) ->
      __rabot_resume = ->
        __rabot_resume = __rabot_nop
        callback()
      @postMessage
        action: 'turn'
        angle: angle

    turnTo = (obj, callback) ->
      __rabot_resume = ->
        __rabot_resume = __rabot_nop
        callback()
      @postMessage
        action: 'turnTo'
        uid: obj.uid

    distance = (obj1, obj2) ->
      if not obj2?
        return distance(rabbit, obj1)
      return Math.sqrt(
        (obj1.x - obj2.x) * (obj1.x - obj2.x) +
        (obj1.y - obj2.y) * (obj1.y - obj2.y)
      )

    __rabot_finished = ->
      @postMessage
        action: 'finish'

    __rabot_add_game_sprites = (gameSprites) ->
      for type, elems of gameSprites
        @[type] = elems

    @onmessage = (e) ->
      e = e.data if e?
      if e? and e.action? and \
          e.action == 'resume'
        __rabot_add_game_sprites(e.gameSprites)
        __rabot_resume()

    """

  # notify main thread that the execution of user code is finished.
  USERSPACE_END: "\n__rabot_finished()\n"

module.exports = UserCodeWorker
