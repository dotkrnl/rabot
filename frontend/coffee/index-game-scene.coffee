class @GameScene
  constructor: (dom) ->
    # Setup model
    @carrot =
      x: 300, y: 50
      angle: 0

    @rabbit =
      x: 300, y: 370
      angle: 0

    # Setup view
    @canvas = Snap(dom)

    @carrotElem = @canvas.circle(0, 0, 20)
    @carrotElem.attr
      fill: '#ff5555'
      stroke: '#000'
      strokeWidth: 5
      display: 'none'
    @updateTransform @carrotElem, @carrot, 0, =>
      # carrot in place, display it
      @carrotElem.attr 'display', ''

    @rabbitElem = @canvas.polygon(0, -70, 30, 30, -30, 30)
    @rabbitElem.attr
      fill: '#aaaaff'
      stroke: '#000'
      strokeWidth : 5
      display: 'none'
    @updateTransform @rabbitElem, @rabbit, 0, =>
      # rabbit in place, display it
      @rabbitElem.attr 'display', ''

  getTStr: (info) ->
    "t#{info.x},#{info.y}r#{info.angle},0,0"

  updateTransform: (elem, info, duration, callback) ->
    elem.animate
      transform: @getTStr(info)
      duration, mina.linear, callback

  rotateRabbit: (angle, duration, callback) ->
    @rabbit.angle += angle
    @updateTransform(@rabbitElem, @rabbit, duration, callback)

  moveRabbit: (x, y, duration, callback) ->
    @rabbit.x += x
    @rabbit.y += y
    @updateTransform(@rabbitElem, @rabbit, duration, callback)

  isWin: () ->
    carbox = @carrotElem.getBBox()
    rabbox = @rabbitElem.getBBox()
    return !(rabbox.x  > carbox.x2 ||
             rabbox.x2 < carbox.x  ||
             rabbox.y  > carbox.y2 ||
             rabbox.y2 < carbox.y)
