# A helper function to determine the duration of transform according to
# its metric (i.e. length, angles, etc)
scaleToTime = (scale) ->
  Math.abs(scale * 5)

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
    @update 0
    return

  # Update the game view according to the game model.
  # @param scale: This function will update the game scene with animation
  # according to scale. The time used will be a linear function of scale
  # @param callback: The function to call when transform is finished
  # This parameter is optional. If the view is not bound with a model,
  # callback will be called immediately
  # Note: use scale 0 to synchronize scene with the model immediately
  update: (scale, callback) ->

    scanLength =  Math.max(@elems.length, @game.sprites.length)
    
    # When the scene is empty the callback should also be called.
    if scanLength == 0
      callback() if callback?
      return

    if @game?
      remaining = scanLength

      # A helper function to record how many objects finished animation
      # The callback will be called when all animations are all finished.
      finishedOne = () ->
        remaining -= 1
        if remaining == 0
          callback() if callback?

      uid = 0
      for uid in [0..scanLength-1]
        if @game.sprites[uid]? and @elems[uid]?
          @elems[uid].animate
            transform: @tStrFor(@game.sprites[uid])
            scaleToTime(scale), mina.linear, finishedOne
        else if @game.sprites[uid]? and not @elems[uid]?
          sprite = @game.sprites[uid]
          elem = null
          switch sprite.type
            # TODO: specify in another individual file
            when 'rabbit'
              elem = @canvas.polygon(0, -70, 30, 30, -30, 30)
              elem.attr
                fill: '#aaaaff'
                stroke: '#000'
                strokeWidth : 5
            when 'carrot'
              elem = @canvas.circle(0, 0, 20)
              elem.attr
                fill: '#ff5555'
                stroke: '#000'
                strokeWidth: 5

          if elem?
            @elems[uid] = elem
            elem.transform @tStrFor(@game.sprites[uid])
          finishedOne()

        else if not @game.sprites[uid]? and @elems[uid]?
          @elems[uid].remove()
          @elems[uid] = null
          finishedOne()

        else finishedOne()

    else
      callback() if callback?
    return

  # Collision detection by judging whether the bounding box of 2 sprite
  # have overlapped.
  # This function is implemented in view because to get the bounding box,
  # access to Snap.svg objects is required.
  collided: (sprite1, sprite2) ->
    box1 = @elems[sprite1.uid].getBBox()
    box2 = @elems[sprite2.uid].getBBox()
    not (box1.x  > box2.x2 or
         box1.x2 < box2.x  or
         box1.y  > box2.y2 or
         box1.y2 < box2.y)

  # Generate a Snap.svg transform string from an object.
  tStrFor: (info) ->
    "t#{info.x},#{info.y}r#{info.angle},0,0"

module.exports = GameScene
