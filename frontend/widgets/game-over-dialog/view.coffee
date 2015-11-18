View = require('../view.coffee')
UserProgress = require('../../models/userprogress.coffee')
Stage = require('../../models/stage.coffee')

# a class to setup user friendly code editor
class GameOverDialog extends View

  # Construct the level selector
  # @param topDom: the mixin dom provided by template.jade
  constructor: (topDom) ->
    super()
    @stage = new Stage
    @userProgress = new UserProgress
    @topDom = $(topDom)

    @contentDom = @getJQueryObject('content')
    @maskDom = @getJQueryObject('mask')
    @canvas = @createViewFromElement('canvas', Snap)

    @backgroundImage = @canvas.image(
      @getImageAssetPath() + 'game-over-dialog/background-victory.svg',
      0, 0, 700, 400
    )

    @replayButton = @canvas.image(
      @getImageAssetPath() + 'game-over-dialog/button-replay.svg',
      500, 240, 180, 60
    )

    @nextButton = @canvas.image(
      @getImageAssetPath() + 'game-over-dialog/button-next.svg',
      500, 320, 180, 60
    )

    @nextButton.attr(cursor: 'pointer')
    @replayButton.attr(cursor: 'pointer')

    $(@nextButton.node).click =>
      @hide()
      @trigger("nextstage")

    $(@replayButton.node).click =>
      @hide()
      @trigger("replaystage")

    @stageNameText = @canvas.text(350, 36, '')
    @stageNameText.attr
      'text-anchor': 'middle'
      'font-size': '20pt'
    @variantElementGroup = @canvas.group()
    # Rank is how many stars you've got.
    @rank = -2


  update: (rank) ->
    @variantElementGroup.clear()
    @rank = rank
    #@canvas.clear()
    centers = [
      {x: 270 - 30, y: 200},
      {x: 350 - 30, y: 250},
      {x: 430 - 30, y: 200}
    ]
    if rank >= 0 and rank <= 3
      for j in [0..2]
        center = centers[j]
        star = null
        if j < rank
          star = @canvas.image \
            @getImageAssetPath() + 'game-over-dialog/star-gold.svg',
            center.x, center.y, 60, 60
          @variantElementGroup.add star
        else
          star = @canvas.image \
            @getImageAssetPath() + 'game-over-dialog/star-grey.svg',
            center.x, center.y, 60, 60
          @variantElementGroup.add star

      @replayButton.attr
        x: 250 - 90
        y: 300

      @nextButton.attr
        x: 450 - 90
        y: 300

    else
      text = @canvas.text(350, 270, t('game-over-dialog.tryagain'))
      text.attr
        fill: "#181830",
        "font-size": "40px"
        'text-anchor': 'middle'
        'font-weight': 'bold'
      @variantElementGroup.add text
      @replayButton.attr
        x: 350 - 90
        y: 300

      @nextButton.attr
        x: -1000
        y: -1000

  hide: ->
    @contentDom.fadeOut()
    @maskDom.fadeOut()

  show: (rank, stageId) ->
    @stageNameText.attr
      text: @stage.getLocalStage(stageId).name
    @contentDom.fadeIn()
    @maskDom.fadeIn()
    @update(rank)

module.exports = GameOverDialog
