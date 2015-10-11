scaleToTime = (scale) ->
  Math.abs(scale * 5)

class GameScene
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

  _register: (game) ->
    @game = game
    # update with game
    @update 0, =>
      # items in place, display them
      @rabbitElem.attr 'display', ''
      @carrotElem.attr 'display', ''
    return

  update: (scale, callback) ->
    if @game?
      done_count = 0
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

  collided: () ->
    carbox = @carrotElem.getBBox()
    rabbox = @rabbitElem.getBBox()
    not (rabbox.x  > carbox.x2 or
         rabbox.x2 < carbox.x  or
         rabbox.y  > carbox.y2 or
         rabbox.y2 < carbox.y)

  tStrFor: (info) ->
    "t#{info.x},#{info.y}r#{info.angle},0,0"


module.exports = GameScene
