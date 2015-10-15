# A helper function to determine the duration of transform according to
# its metric (i.e. length, angles, etc)
scaleToTime = (scale) ->
  Math.abs(scale * 5)

# The class GameScene defines a game scene
class GameScene

  # The scene need to be constructed with an svg element to use Snap.svg. When
  # created, the game scene is not related to any game models and all elements
  # will be invisible. To bind a game model, calling _register is required.
  # @param canvas_dom Specify the svg element used to init Snap.svg.
  constructor: (canvas_dom) ->
    @canvas = Snap(canvas_dom)
    @game = null
    @unitElems = []

  # Find an corresponding svg element by unit in game model.
  getElementByUnit: (unit) ->
    for unitElem in @unitElems
      return unitElem.element if unitElem.unit == unit
    return undefined

  # Bind the game scene with a model. Note that all elements in the scene will
  # become visible and synchronized with the model immediately.
  # @param game The game model to bind.
  _register: (game) ->
    @game = game

    for rabbit in @game.units.Rabbit
      rabbitElem = @canvas.polygon(0, -70, 30, 30, -30, 30)
      rabbitElem.attr
        fill: '#aaaaff'
        stroke: '#000'
        strokeWidth : 5
      @unitElems.push
        unit: rabbit
        element: rabbitElem

    for carrot in @game.units.Carrot
      carrotElem = @canvas.circle(0, 0, 20)
      carrotElem.attr
        fill: '#ff5555'
        stroke: '#000'
        strokeWidth: 5
      @unitElems.push
        unit: carrot
        element: carrotElem

    @update(0)
    return

  # Update the game view according to the game model.
  # @param scale This function will update the game scene with animation
  # according to scale. The longer the scale is, the slower the animation will be.
  # @param callback: When transform is finished, the callback will be called.
  # This parameter is optional. If the view is not bound with a model,
  # callback will be called immediately if exists.
  # Note: if you want the view be synchronized with the model immediately,
  # passing a scale of 0 will do the job.
  update: (scale, callback) ->
    if @game?
      done_count = 0

      # A helper function to record how many objects finished animation is necessary.
      # The callback will only be called when all animations are all finished.
      finished_one = () ->
        console.log(done_count)
        done_count += 1
        if done_count == @unitElems.length
          callback() if callback?

      for unitElem in @unitElems
        unitElem.element.animate
          transform: @tStrFor(unitElem.unit)
          scaleToTime(scale), mina.linear, finished_one.bind(@)

    else
      callback() if callback?
    return

  # Collision detection by judging whether the bounding box of 2 models in the
  # game unit have overlapped.
  # This function is implemented in view because to get the bounding box,
  # access to Snap.svg objects is required.
  collided: (unit1, unit2) ->
    box1 = @getElementByUnit(unit1).getBBox()
    box2 = @getElementByUnit(unit2).getBBox()
    not (box1.x  > box2.x2 or
         box1.x2 < box2.x  or
         box1.y  > box2.y2 or
         box1.y2 < box2.y)

  # Generate a Snap.svg transform string from an object.
  tStrFor: (info) ->
    "t#{info.x},#{info.y}r#{info.angle},0,0"

module.exports = GameScene
