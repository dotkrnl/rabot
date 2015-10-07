class @GameScene
  constructor: (dom) ->
    @canvas = Snap(dom)
    @carrot = @canvas.circle(300, 50, 20)
    @carrot.attr
      fill: '#ff5555'
      stroke: '#000'
      strokeWidth: 5

    @rabbit = @canvas.polygon(0, -70, 30, 30, -30, 30)
    @rabbit.attr
      fill: '#aaaaff'
      stroke: '#000'
      strokeWidth : 5

    @rabbitCenter =
      x: 300
      y: 370
    @rabbitAngle = 0
    @updateRabbitTransform 0

  isVictory: ->
    rabbitBoundingBox = @rabbit.getBBox()
    return true

  rabbitTStr: () ->
    "t#{@rabbitCenter.x},#{@rabbitCenter.y}r#{@rabbitAngle},0,0"

  updateRabbitTransform: (duration, callback) ->
    @rabbit.animate
      transform: @rabbitTStr()
      duration,
      mina.linear
      ->
        callback() if callback?

  rotateRabbit: (angle, duration, callback) ->
    @rabbitAngle += angle
    @updateRabbitTransform(duration, callback)

  moveRabbit: (x, y, duration, callback) ->
    @rabbitCenter.x += x
    @rabbitCenter.y += y
    @updateRabbitTransform(duration, callback)

  isWin: () ->
    carrotBBox = @carrot.getBBox()
    if @rabbitCenter.x > carrotBBox.x && \
        @rabbitCenter.x < carrotBBox.x2 && \
        @rabbitCenter.y > carrotBBox.y && \
        @rabbitCenter.y < carrotBBox.y2
      return true
    else
      return false
