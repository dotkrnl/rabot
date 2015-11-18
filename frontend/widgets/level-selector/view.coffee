Emitter = require('../../commons/logic/emitter.coffee')
Stage = require('../../models/stage.coffee')
UserProgress = require('../../models/userprogress.coffee')
View = require('../view.coffee')

# a class to setup user friendly code editor
class LevelSelector extends View

  # Construct the level selector
  # @param topDom: the mixin dom provided by template.jade
  constructor: (topDom) ->
    super(topDom)
    @contentDom = @getJQueryObject('ls-content')
    @maskDom = @getJQueryObject('ls-mask')
    @canvas = @createViewFromElement('ls-canvas', Snap)
    @userProgress = new UserProgress
    @stage = new Stage()
    @stagePackageBackground = @canvas.image(
      @getImageAssetPath() + 'level-selector/grassland.svg', 0, 0, 700, 400
    )
    @prevButton = @canvas.image(
      @getImageAssetPath() + 'level-selector/button-previous.svg',
      25, 175, 75, 75
    )
    @nextButton = @canvas.image(
      @getImageAssetPath() + 'level-selector/button-next.svg',
      600, 175, 75, 75
    )
    @closeButton = @canvas.image(
      @getImageAssetPath() + '/level-selector/button-close.svg',
      625, 25, 50, 50
    )

    for elem in [@prevButton, @nextButton, @closeButton]
      do(elem) ->
        $(elem.node).on "mouseover", ->
          elem.animate(transform:'t0,0s1.3', 200, mina.linear, ->)
        $(elem.node).on "mouseout", ->
          elem.animate(transform:'t0,0s1.0', 200, mina.linear, ->)

    $(@closeButton.node).on 'click', => @hide()
    $(@nextButton.node).on 'click', => @switchToNextStagePackage()
    $(@prevButton.node).on 'click', => @switchToPreviousStagePackage()

    @stagePackageNameText = @canvas.text(350, 50, "AAAAAAAA")

    @canvasLevelElemGroup = @canvas.group()
    @stagePackageNameText.attr
      'text-anchor': 'middle'
      'font-size': "24pt"
      stroke: "#DDD"
      fill: "#DDD"

    @levelElems = []
    @stageManager = new Stage()

  updateLevelElems: (packageId) ->
    stageData = @stage.getStagePackage(packageId).stages
    userProgress = @userProgress.getUserProgress(packageId)
    levelElems = []
    @canvasLevelElemGroup.clear()

    # TODO: replace i with stage_id.
    centers = []
    for i in [1..stageData.length]
      centers.push
        x : (i - 1) % 4 * 120 + 170,
        y : Math.floor((i - 1) / 4 + 0.01) * 90 + 135

    maxAvailStage = -1
    for i in [0..stageData.length - 1]
      if userProgress[i] >= 0
        maxAvailStage = i
      else break
    maxAvailStage += 2

    i = 1
    for stageId in stageData
      stage = @stage.getLocalStage(stageId)
      center = centers[i - 1]
      if i <= maxAvailStage
        circle = @canvas.image \
          @getImageAssetPath() + 'level-selector/circle-blue.svg',
          center.x - 35, center.y - 35, 70, 70
      else
        circle = @canvas.image \
          @getImageAssetPath() + 'level-selector/circle-grey.svg',
          center.x - 35, center.y - 35, 70, 70
      circle.attr
        fill: "#daba55",
        stroke: "#000",
        strokeWidth: 2
      text = @canvas.text(center.x, center.y, "" + i)
      text.attr
        fill: '#222',
        'font-size': '20px'
        'text-anchor': 'middle'

      levelText = @canvas.text(center.x, center.y + 50, stage.name)
      levelText.attr
        'font-size': '20px'
        'text-anchor': 'middle'
        fill: "#DAA"

      levelElems.push(elem)
      elem = @canvas.group(circle, text)
      elem.attr(cursor: 'pointer')
      @canvasLevelElemGroup.add(elem, levelText)

      for j in [0..2]
        star = null
        if j < userProgress[i - 1]
          star = @canvas.image \
            @getImageAssetPath() + 'level-selector/star-gold.svg',
            center.x - 10 + (j - 1) * 20, center.y + 5, 20, 20
        else
          star = @canvas.image \
            @getImageAssetPath() + 'level-selector/star-grey.svg',
            center.x - 10 + (j - 1) * 20, center.y + 5, 20, 20
        @canvasLevelElemGroup.add(star)
      do(i, elem, stage) =>
        if i <= maxAvailStage
          $(elem.node).on "mouseover", ->
            elem.animate(transform:'t0,0s1.3', 200, mina.linear, ->)
          $(elem.node).on "mouseout", ->
            elem.animate(transform:'t0,0s1.0', 200, mina.linear, ->)
          $(elem.node).on "click", =>
            @hide()
            @trigger("levelselected", packageId, i - 1)
      i++

  hide: ->
    @contentDom.fadeOut()
    @maskDom.fadeOut()

  show: ->
    @contentDom.fadeIn()
    @maskDom.fadeIn()

    # This is a workaround due to unfinished and unstable stage API
    @stageManager.queryStageList "", =>
      @stagePackageList = @stageManager.queryStagePackageList()
      @stageManager.queryStageList @stagePackageList[0], (stageData) =>
        @switchToStagePackage(0)

  switchToStagePackage: (stagePackageIndex) ->
    @currentPackageIndex = stagePackageIndex
    @prevButton.attr visibility: "hidden"
    @nextButton.attr visibility: "hidden"
    if stagePackageIndex > 0
      @prevButton.attr visibility: "visible"
    if stagePackageIndex < @stagePackageList.length - 1
      @nextButton.attr visibility: "visible"

    @stagePackageNameText.attr
      text: @stagePackageList[@currentPackageIndex].name

    @stagePackageBackground.attr
      "xlink:href":
        @getImageAssetPath() + 'level-selector/' +
        @stagePackageList[@currentPackageIndex].background

    @updateLevelElems(@stagePackageList[@currentPackageIndex].id)

  switchToNextStagePackage : () ->
    if @currentPackageIndex < @stagePackageList.length - 1
      @switchToStagePackage(@currentPackageIndex + 1)

  switchToPreviousStagePackage : () ->
    if @currentPackageIndex > 0
      @switchToStagePackage(@currentPackageIndex - 1)

module.exports = LevelSelector
