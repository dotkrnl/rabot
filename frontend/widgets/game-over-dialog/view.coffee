Emitter = require('../../commons/logic/emitter.coffee')
UserProgress = require('../../models/userprogress.coffee')

# a class to setup user friendly code editor
class GameOverDialog extends Emitter

  # Construct the level selector
  # @param topDom: the mixin dom provided by template.jade
  constructor: (topDom) ->
    super()
    @userProgress = new UserProgress
    @topDom = $(topDom)
    @topDom.find(".btn-next").click =>
      @hide()
      @trigger("nextstage")

    @topDom.find(".btn-replay").click =>
      @hide()
      @trigger("replaystage")

    @contentDom = $(topDom).find(".god-content")
    @maskDom = $(topDom).find(".god-mask")

    @canvas = Snap(@topDom.find(".god-canvas")[0])
    # Rank is how many stars you've got.
    @rank = -2


  update: (rank) ->
    @rank = rank
    @canvas.clear()
    if rank < 0 or rank > 3
      @topDom.find(".btn-next").hide()
      circle = @canvas.circle(100, 200, 50)
      circle.attr
        fill: "#ba5555",
        stroke: "#000",
        strokeWidth: 5
      text = @canvas.text(100, 100, "You failed.")
      text.attr
        fill: "#ba5555",
        "font-size": "40px"
    else
      @topDom.find(".btn-next").show()
      for i in [1..rank]
        circle = @canvas.circle(100 + 200 * i, 200, 50)
        circle.attr
          fill: "#5555ba",
          stroke: "#000",
          strokeWidth: 5
      text = @canvas.text(100, 100, "Victory!")
      text.attr
        fill: "#5555ba",
        "font-size": "40px"

  hide: ->
    @contentDom.fadeOut()
    @maskDom.fadeOut()

  show: (rank) ->
    @contentDom.fadeIn()
    @maskDom.fadeIn()
    @update(rank)

module.exports = GameOverDialog
