GameElem = require('./gameelem.coffee')

# The class GameScene defines a game scene
class GameScene

  # Construct the scene with Snap.svg on canvasOom
  # After constructed, the game scene is not related to any game models
  #   therefore no element will be visible nor existed
  # Call game.register(gamescene) to bind scene to a game
  # @param canvasDom Specify the svg element used to init the scene
  constructor: (canvasDom) ->
    @canvas = Snap(canvasDom)
    @game = null
    @elems = []

  # Bind the game scene with a model.
  # The scene will be synchronized with the model
  # This function should only be called by register of Game
  # See game.register(gamescene) for details
  # @param game The game model to bind.
  _register: (game) ->
    @game = game
    @update(0)
    return

  # Update the game view according to the game model.
  # @param scale: This function will update the game scene with animation
  # according to scale. The time used will be a linear function of scale
  # @param callback: The function to call when transform is finished
  # This parameter is optional. If the view is not bound with a model,
  # callback will be called immediately
  # Note: use scale 0 to synchronize scene with the model immediately
  update: (scale, callback) ->

    # no game registered
    unless @game?
      callback() if callback?
      return

    # Sprites could not be deleted nor replaced but defunct.
    # So @elems array can only be increased
    if @game.sprites.length > @elems.length
      for uid in [@elems.length..@game.sprites.length-1]
        # create elem associated with new sprite
        @elems[uid] = new GameElem(@canvas, @game.sprites[uid])

    remaining = @elems.length
    # A helper function to record how many objects finished animation
    # The callback will be called when all animations are all finished.
    finishedOne = () ->
      remaining -= 1
      if remaining == 0
        callback() if callback?

    for elem, uid in @elems
      unless @game.sprites[uid].defunct
        # sprite not deleted then update
        elem.update(scale, finishedOne)
      else
        # or also delete elem
        elem.remove()
        finishedOne()

    # When the scene is empty the callback should also be called.
    callback() if callback? and @elems.length == 0
    return

  # Sprites could not be deleted nor replaced but defunct.
  # But sprites may be cleared to be reloaded, that means scene
  # should initialize all sprites to get into the correct sharp.
  # This function should be called after sprites cleared
  clear: ->
    elem.remove() for elem in @elems
    @elems = []
    return

  # Collision detection by judging whether the bounding box of 2 sprite
  # have overlapped.
  # This function is implemented in view because to get the bounding box,
  # access to Snap.svg objects is required.
  collided: (sprite1, sprite2) ->
    @elems[sprite1.uid]? and @elems[sprite2.uid]? and
    @elems[sprite1.uid].collided(@elems[sprite2.uid])


module.exports = GameScene
