Emitter = require('../../commons/logic/emitter.coffee')
# a class to setup user friendly code editor
class GameOverDialog extends Emitter

  # Construct the level selector
  # @param topDom: the mixin dom provided by template.jade
  constructor: (topDom) ->
    super()
    @topDom = $(topDom)
    @topDom.find(".btn-next").click =>
      @hide()

    @topDom.find(".btn-relay").click =>
      @hide()

    @contentDom = $(topDom).find(".god-content")
    @maskDom = $(topDom).find(".god-mask")

    #@levelElems = []
    @canvas = Snap(@topDom.find(".god-canvas")[0]);
    #@stageManager = new Stage();


  updateCanvas: (rank) ->
    if rank == -1
      @canvas.clear()

  hide: ->
    @contentDom.fadeOut();
    @maskDom.fadeOut();

  show: ->
    @contentDom.fadeIn();
    @maskDom.fadeIn();
    #@stageManager.queryStageList @updateLevelElems.bind(@)

module.exports = GameOverDialog
