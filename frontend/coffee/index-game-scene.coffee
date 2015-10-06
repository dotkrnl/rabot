class @GameScene
  constructor: (dom) ->
    @canvas = Snap(dom)
    @carrot = @canvas.circle(300, 50, 20)
    @carrot.attr
      fill: '#ff5555'
      stroke: '#000'
      strokeWidth: 5
    @rabbit = @canvas.polygon(300,300,330,400,270,400)
    @rabbit.attr
      fill: '#aaaaff'
      stroke: '#000'
      strokeWidth : 5
    @rabbitCenter =
      x: 300
      y: 380
    @rabbitOffset =
      x: 0
      y: 0
    @rabbitAngle = 0

  isVictory: ->
    rabbitBoundingBox = @rabbit.getBBox()
    return true

  rabbitTStr: () ->
    "r" + @rabbitAngle + "," + @rabbitCenter.x + "," + @rabbitCenter.y + " t" + @rabbitOffset.x + "," + @rabbitOffset.y

  updateRabbitTransform: (duration, callback) ->
    @rabbit.animate
      transform: @rabbitTStr()
      1000
      mina.linear
      ->
        callback() if callback?
  rotateRabbit: (angle, duration, callback) ->
    #This is a important work-around to prevent SnapSvg performing point-to-point linear transform.
    @rabbit.transform @rabbitTStr()
    @rabbitAngle += angle
    @updateRabbitTransform(duration, callback)

  moveRabbit: (x, y, duration, callback) ->
    #This is a important work-around to prevent SnapSvg performing point-to-point linear transform.
    @rabbit.transform @rabbitTStr()
    @rabbitOffset.x += x
    @rabbitOffset.y += y
    @rabbitCenter.x += x
    @rabbitCenter.y += y
    @updateRabbitTransform(duration, callback)
