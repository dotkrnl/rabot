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

  hide: () ->
    @contentDom.fadeOut();
    @maskDom.fadeOut();

module.exports = LevelSelector
