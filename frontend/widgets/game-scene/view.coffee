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
    @shadowFilter = @canvas.filter(Snap.filter.shadow(0, 2, 3))
    @canvasDom = @getJQueryObject("gs-svg")
    @initRuler()
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
        @elems[uid].imageElem.attr filter: @shadowFilter

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
        @rulerLine.attr
          x1: @rulerObject1.x
          x2: @rulerObject1.x
          y1: @rulerObject1.y
          y2: @rulerObject1.y
      else
        @rulerObject1 = null # Line remained
    else
      @trigger('spriteclicked', sprite, label)

  activeRuler: () ->
    @rulerObject1 = null
    @rulerObject2 = null
    @rulerActivated = true
    @ruler.attr({opacity: 0.5})
    @ruler.appendTo(@ruler.paper)

  deactiveRuler: () ->
    @rulerObject1 = null
    @rulerObject2 = null
    @rulerActivated = false
    @ruler.attr({opacity: 1.0})
    @rulerCursor.attr
      x: -100
      y: -100

    @rulerLine.attr
      x1: -100
      x2: -100
      y1: -100
      y2: -100

    @rulerLabel.attr
      x: -100
      y: -100

  initRuler: () ->
    @ruler = @canvas.image(
      @getImageAssetPath() + 'game-scene/ruler.svg',
      30, 30, 80, 80
    )
    @ruler.attr
      cursor: 'pointer'
    $(@ruler.node).on 'click', =>
      if @rulerActivated
        @deactiveRuler()
      else
        @activeRuler()
    @ruler.attr filter: @shadowFilter

    @rulerCursor = @canvas.image(
      @getImageAssetPath() + 'game-scene/ruler.svg',
      -100, -100, 80, 80
    )
    @rulerCursor.attr filter: @shadowFilter

    @rulerLine = @canvas.line(0,0,500,500)
    @rulerLine.attr
      stroke: '#000'
      strokeWidth: 5
      strokeLinecap: 'round'
      'stroke-dasharray':'40,20'

    @rulerLabel = @canvas.text(-100, -100, '')
    @rulerLabel.attr
      'text-anchor': 'middle'
      'font-size': "36pt"
      fill: "#224"

    @deactiveRuler()

    @canvasDom.on 'mousemove', (event) =>
      return if not @rulerActivated

      pt = @canvasDom[0].createSVGPoint()
      [pt.x, pt.y] = [event.clientX, event.clientY]
      pt = pt.matrixTransform(@canvasDom[0].getScreenCTM().inverse())
      [x, y] = [pt.x, pt.y]

      @rulerCursor.attr x: x, y: y

      return if not @rulerObject1
      for elem in @game.filterSprites('defunct': false)
        continue if not elem.x? or not elem.y?
        continue if elem.type == 'staticimage' or elem.type == 'river'
        if Math.abs(x - elem.x) < 75 and Math.abs(y - elem.y) < 75
          x = elem.x
          y = elem.y
          break
      distance = Math.sqrt \
        (x - @rulerObject1.x) * (x - @rulerObject1.x) +
        (y - @rulerObject1.y) * (y - @rulerObject1.y)
      @rulerLine.attr x2: x, y2: y
      @rulerLabel.attr x: x + 100, y: y, text: '' + Math.ceil(distance)
      @rulerLabel.appendTo(@rulerLabel.paper) # bring to front


module.exports = GameScene
