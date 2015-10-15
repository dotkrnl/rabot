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

    @carrotElem = @canvas.circle(0, 0, 20)
    @carrotElem.attr
      fill: '#ff5555'
      stroke: '#000'
      strokeWidth: 5
      display: 'none'

    @rabbitElem = @canvas.polygon(0, -70, 30, 30, -30, 30)
    @rabbitElem.attr
      fill: '#aaaaff'
      stroke: '#000'
      strokeWidth : 5
      display: 'none'

  # Bind the game scene with a model. Note that all elements in the scene will
  # become visible and synchronized with the model immediately.
  # @param game The game model to bind.
  _register: (game) ->
    @game = game
    # update with game
    @update 0, =>
      # items in place, display them
      @rabbitElem.attr 'display', ''
      @carrotElem.attr 'display', ''
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

      # There are currently only 2 objects in the scene, A helper function to record
      # how many objects finished animation is necessary. The callback will only be
      # called when 2 animations are all finished.

      finished_one = () ->
        done_count += 1
        if done_count == 2
          callback() if callback?

      @rabbitElem.animate
        transform: @tStrFor(@game.rabbit)
        scaleToTime(scale), mina.linear, finished_one
      @carrotElem.animate
        transform: @tStrFor(@game.carrot)
        scaleToTime(scale), mina.linear, finished_one
    else
      callback() if callback?
    return

  # Collision detection by judging whether the carrot's and the rabbit's
  # bounding box have overlapped.
  # This function is implemented in view because to get the bounding box,
  # access to Snap.svg objects is required.
  collided: () ->
    carbox = @carrotElem.getBBox()
    rabbox = @rabbitElem.getBBox()
    not (rabbox.x  > carbox.x2 or
         rabbox.x2 < carbox.x  or
         rabbox.y  > carbox.y2 or
         rabbox.y2 < carbox.y)

  # Generate a Snap.svg transform string from an object.
  tStrFor: (info) ->
    "t#{info.x},#{info.y}r#{info.angle},0,0"


module.exports = GameScene
