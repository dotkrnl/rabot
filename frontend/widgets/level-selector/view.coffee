Stage = require('../../models/stage.coffee')
# a class to setup user friendly code editor
class LevelSelector

  # Construct the level selector
  # @param topDom: the mixin dom provided by template.jade
  constructor: (topDom) ->
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
    @updateLevelElems();


  updateLevelElems: ->
    levelElems = []
    @canvas.clear();
    for i in [0..5]
      center =
        x : i * 70 + 25,
        y : Math.random() * 200 + 100
      circle = @canvas.circle(center.x, center.y, 20);
      circle.attr
        fill: "#daba55",
        stroke: "#000",
        strokeWidth: 2
      text = @canvas.text(center.x - 5, center.y + 5, "" + i);
      text.attr
          fill: "#222",
          "font-size": "20px"
      levelElem = @canvas.group(circle, text)
      levelElems.push(levelElem)
    for elem in levelElems
      do(elem) ->
        $(elem.node).on "mouseover", =>
          elem.animate(transform:'t0,0s1.3', 200, mina.linear, ->)
        $(elem.node).on "mouseout", =>
          elem.animate(transform:'t0,0s1.0', 200, mina.linear, ->)

  hide: ->
    @contentDom.fadeOut();
    @maskDom.fadeOut();

  show: ->
    @contentDom.fadeIn();
    @maskDom.fadeIn();

module.exports = LevelSelector
