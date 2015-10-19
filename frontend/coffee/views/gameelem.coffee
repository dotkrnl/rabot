# A helper function to determine the duration of transform according to
# its metric (i.e. length, angles, etc)
scaleToTime = (scale) ->
  Math.abs(scale * 5)

# Generate a Snap.svg transform string from an sprite
tStrFor = (sprite) ->
  "t#{sprite.x},#{sprite.y}r#{sprite.angle},0,0"

# The class GameElem defines a game sprite displaying element
class GameElem

  # Construct the element on Snap.svg canvas with sprite
  # This element will immediately update with sprite
  constructor: (@canvas, @sprite) ->
    @elem = null
    switch @sprite.type
      when 'rabbit'
        @elem = @canvas.polygon(0, -70, 30, 30, -30, 30)
        @elem.attr
          fill: '#aaaaff'
          stroke: '#000'
          strokeWidth : 5
      when 'carrot'
        @elem = @canvas.circle(0, 0, 20)
        @elem.attr
          fill: '#ff5555'
          stroke: '#000'
          strokeWidth: 5
    @update(0)

  # Update the element with animation (if scale)
  # @param scale: This function will update the game scene with animation
  # according to scale. The time used will be a linear function of scale
  # @param callback: The function to call when transform is finished
  # This parameter is optional. If the elem is not exist, callback
  # will be called immediately
  # Note: use scale 0 to synchronize scene with the model immediately
  update: (scale, callback) ->
    if @elem? and @sprite
      if scale
        @elem.animate
          transform: tStrFor(@sprite)
          scaleToTime(scale), mina.linear, callback
      else
        @elem.transform tStrFor(@sprite)
        callback() if callback?

    else
      callback() if callback?

  # Remove the element from canvas
  # If elem not exist, nothing will be done
  # It's safe to be called mutiple times
  remove: ->
    @elem.remove() if @elem?
    @elem = null

  # Collision detection by judging whether the bounding box of 2
  # GameElem have overlapped
  collided: (other) ->
    unless @elem? and other.elem?
      return false
    box1 = @elem.getBBox()
    box2 = other.elem.getBBox()
    not (box1.x  > box2.x2 or
         box1.x2 < box2.x  or
         box1.y  > box2.y2 or
         box1.y2 < box2.y)


module.exports = GameElem
