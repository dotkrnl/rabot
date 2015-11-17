GameElem = require('./logic/element.coffee')
View = require('../view.coffee')

# The class GameScene defines a game scene
class GameScene extends View

  # Construct the scene with Snap.svg on canvasOom
  # After constructed, the game scene is not related to any game models
  #   therefore no element will be visible nor existed
  # Call game.register(gamescene) to bind scene to a game
  # @param topDom Specify the top dom element provided by template
  constructor: (topDom) ->
    super(topDom)
    @canvas = @createViewFromElement("gs-svg", Snap)
    @canvasDom = @getJQueryObject("gs-svg")
    @ruler = @canvas.image(
      @getImageAssetPath() + 'game-scene/ruler.svg',
      10, 10, 60, 60
    )
    @ruler.attr
      cursor: 'pointer'

    $(@ruler.node).on 'click', =>
      if @rulerActivated
        @deactiveRuler()
      else
        @activeRuler()


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

  # Cancel the association between the game and the scene. This will
  # clear the canvas.
  _unregister: () ->
    @canvas.clear()
    @game = null
    @elems = []

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
        sprite = @game.sprites[uid]
        # create elem associated with new sprite
        sameTypeSprites = @game.filterSprites
          type : @game.sprites[uid].type
        label = sprite.type
        if sameTypeSprites.length > 1
          label += "[#{sameTypeSprites.indexOf(sprite)}]"
        @elems[uid] = new GameElem(@, @canvas, sprite, label)

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

  getGameModel: () ->
    return @game

  onMouseEnterSprite: (sprite, label) ->
    #TODO: add handlers

  onMouseLeaveSprite: (sprite, label) ->
    #TODO: add handlers

  onMouseClickSprite: (sprite, label) ->
    if @rulerActivated
      if not @rulerObject1
        @rulerObject1 = sprite
      else if not @rulerObject2
        @rulerObject2 = sprite
        alert \
          '(' +
          (@rulerObject1.x - @rulerObject2.x) + ',' +
          (@rulerObject1.y - @rulerObject2.y) + ')'
        @deactiveRuler()
    else
      @trigger('spriteclicked', sprite, label)

  activeRuler: () ->
    @rulerObject1 = null
    @rulerObject2 = null
    @rulerActivated = true

  deactiveRuler: () ->
    @rulerObject1 = null
    @rulerObject2 = null
    @rulerActivated = false

module.exports = GameScene
