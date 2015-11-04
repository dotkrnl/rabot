Emitter = require('../../commons/logic/emitter.coffee')
Stage = require('../../models/stage.coffee')
# a class to setup user friendly code editor
class LevelSelector extends Emitter

  # Construct the level selector
  # @param topDom: the mixin dom provided by template.jade
  constructor: (topDom) ->
    super()
    @topDom = $(topDom)
    @topDom.find(".cancel-dialog").click =>
      @hide()

    @contentDom = $(topDom).find(".ls-content")
    @maskDom = $(topDom).find(".ls-mask")
    @contentDom.css
      left: (@maskDom.width() - @contentDom.width()) / 2,
      top: (@maskDom.height() - @contentDom.height()) / 2

    @levelElems = []
    @canvas = Snap(@topDom.find(".ls-canvas")[0]);
    @stageManager = new Stage();
    @stageManager.queryStageList @updateLevelElems.bind(@)

  updateLevelElems: (stageData) ->
    levelElems = []
    @canvas.clear();
    # TODO: replace i with stage_id.
    centers = []
    for i in [1..stageData.length]
      centers.push
        x : i * 70 + 25,
        y : Math.random() * 200 + 100
    for i in [0..centers.length-2]
      line =
        @canvas.line(centers[i].x, centers[i].y, centers[i+1].x, centers[i+1].y)
      line.attr
        stroke: "#000",
        strokeWidth: 5
    i = 1
    for stage in stageData
      center = centers[i-1]
      circle = @canvas.circle(center.x, center.y, 20);
      circle.attr
        fill: "#daba55",
        stroke: "#000",
        strokeWidth: 2
      text = @canvas.text(center.x - 5, center.y + 5, "" + i);
      text.attr
          fill: "#222",
          "font-size": "20px"
      elem = @canvas.group(circle, text)
      levelElems.push(elem)
      do(elem, stage) =>
        $(elem.node).on "mouseover", =>
          elem.animate(transform:'t0,0s1.3', 200, mina.linear, ->)
        $(elem.node).on "mouseout", =>
          elem.animate(transform:'t0,0s1.0', 200, mina.linear, ->)
        $(elem.node).on "click", =>
          @hide()
          @trigger("levelselected", stage.id);
      i++

  hide: ->
    @contentDom.fadeOut();
    @maskDom.fadeOut();

  show: ->
    @contentDom.fadeIn();
    @maskDom.fadeIn();

module.exports = LevelSelector
