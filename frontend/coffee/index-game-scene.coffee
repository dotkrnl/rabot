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
      # display after prepared properly
      display: 'none'

    @rabbitCenter =
      x: 300
      y: 370
    @rabbitAngle = 0
    @updateRabbitTransform 0, =>
      # rabit in place, display it
      @rabbit.attr 'display', ''

  rabbitTStr: () ->
    "t#{@rabbitCenter.x},#{@rabbitCenter.y}r#{@rabbitAngle},0,0"

  updateRabbitTransform: (duration, callback) ->
    @rabbit.animate
      transform: @rabbitTStr()
      duration,
      mina.linear,
      callback

  rotateRabbit: (angle, duration, callback) ->
    @rabbitAngle += angle
    @updateRabbitTransform(duration, callback)

  moveRabbit: (x, y, duration, callback) ->
    @rabbitCenter.x += x
    @rabbitCenter.y += y
    @updateRabbitTransform(duration, callback)

  isWin: () ->
    carbox = @carrot.getBBox()
    rabbox = @rabbit.getBBox()
    return !(rabbox.x  > carbox.x2 ||
             rabbox.x2 < carbox.x  ||
             rabbox.y  > carbox.y2 ||
             rabbox.y2 < carbox.y)
