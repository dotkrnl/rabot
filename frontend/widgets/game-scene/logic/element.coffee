# A helper function to determine the duration of transform according to
# its metric (i.e. length, angles, etc)
scaleToTime = (scale) ->
  Math.abs(scale * 3)

# Generate a Snap.svg transform string from an sprite
tStrFor = (sprite) ->
  "t#{sprite.x},#{sprite.y}r#{sprite.angle},0,0"

# The class GameElem defines a game sprite displaying element
class GameElem

  # Construct the element on Snap.svg canvas with sprite
  # This element will immediately update with sprite
  constructor: (@scene, @canvas, @sprite, @label) ->
    knownSpriteTypes =
      ['staticimage','rabbit', 'carrot', 'key', 'river', 'door', 'rotator']

    interactiveSpriteType =
      ['rabbit', 'carrot', 'key', 'door', 'rotator']

    if @sprite.type not in knownSpriteTypes
      throw new Error("Unsupported sprite type #{@sprite.type}")

    @elem = @canvas.group()
    @elem.attr
      cursor: 'pointer'
    @imageElem = null

    @initLabelElement()

    if @sprite.type != "staticimage" and @sprite.image
      @imageElem = @canvas.image(
        "/public/images/game-scene/" + @sprite.image.name,
        -@sprite.image.width/2,
        -@sprite.image.height/2,
        @sprite.image.width,
        @sprite.image.height
      )

    else if @sprite.type == "staticimage"
      @imageElem = @canvas.image(
        "/public/images/game-scene/" + @sprite.image.name,
        @sprite.image.x,
        @sprite.image.y,
        @sprite.image.width,
        @sprite.image.height
      )
    @elem.add(@imageElem) if @imageElem?
    @elem.add(@labelElem)

    $(@elem.node).on 'mouseover', =>
      @labelElem.animate({opacity: 1.0}, 300, mina.linear)
      @scene.onMouseEnterSprite(@sprite, @label)

    $(@elem.node).on 'mouseout', =>
      @labelElem.animate({opacity: 0.0}, 300, mina.linear)
      @scene.onMouseLeaveSprite(@sprite, @label)

    $(@elem.node).on 'click', =>
      @scene.onMouseClickSprite(@sprite, @label)

    @update(0)


  initLabelElement: () ->
    @labelBackgroundElem = @canvas.rect(
      -60, -30, 120, 40, 10
    )
    @labelBackgroundElem.attr
      fill: '#fff',
      'fill-opacity': 0.5,
      stroke: '#222',
      strokeWidth: 3

    @labelTextElem = @canvas.text(0, 0, @label)
    @labelTextElem.attr
      background: '#ddd',
      fill: '#222',
      'font-size': '30px'
      'text-anchor': 'middle'

    @labelElem = @canvas.group(@labelBackgroundElem, @labelTextElem)
    @labelElem.attr {opacity: 0.0}

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
