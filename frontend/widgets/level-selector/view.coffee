Emitter = require('../../commons/logic/emitter.coffee')
Stage = require('../../models/stage.coffee')
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
    @stagePackageBackground = @canvas.image(
      @getImageAssetPath() + 'level-selector/grassland.svg', 0, 0, 700, 400
    )
    @prevButton = @canvas.image(
      @getImageAssetPath() + 'level-selector/button-previous.svg', 25, 175, 75, 75
    )
    @nextButton = @canvas.image(
      @getImageAssetPath() + 'level-selector/button-next.svg', 600, 175, 75, 75
    )
    @closeButton = @canvas.image(
      @getImageAssetPath() + '/level-selector/button-close.svg', 625, 25, 50, 50
    )

    for elem in [@prevButton, @nextButton, @closeButton]
      do(elem) =>
        $(elem.node).on "mouseover", =>
          elem.animate(transform:'t0,0s1.3', 200, mina.linear, ->)
        $(elem.node).on "mouseout", =>
          elem.animate(transform:'t0,0s1.0', 200, mina.linear, ->)

    $(@closeButton.node).on 'click', => @hide()
    $(@nextButton.node).on 'click', => @switchToNextStagePackage()
    $(@prevButton.node).on 'click', => @switchToPreviousStagePackage()

    @stagePackageNameText = @canvas.text(350, 50, "AAAAAAAA")

    @canvasLevelElemGroup = @canvas.group()
    @stagePackageNameText.attr
      'text-anchor': 'middle'
      'font-size': "14pt"
      stroke: "#000"

    @levelElems = []
    @stageManager = new Stage()

  updateLevelElems: (stageData) ->
    levelElems = []
    @canvasLevelElemGroup.clear();
    console.log stageData

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
      @canvasLevelElemGroup.add(line)
    i = 1
    for stage in stageData
      center = centers[i-1]
      circle = @canvas.circle(center.x, center.y, 20)
      circle.attr
        fill: "#daba55",
        stroke: "#000",
        strokeWidth: 2
      text = @canvas.text(center.x - 5, center.y + 5, "" + i)
      text.attr
          fill: "#222",
          "font-size": "20px"
      levelText = @canvas.text(center.x - 30, center.y + 30, stage.name)
      levelText.attr
          fill: "#222",
          "font-size": "12px"
      elem = @canvas.group(circle, text)
      @canvasLevelElemGroup.add(elem, levelText)
      levelElems.push(elem)
      do(elem, stage) =>
        $(elem.node).on "mouseover", =>
          elem.animate(transform:'t0,0s1.3', 200, mina.linear, ->)
        $(elem.node).on "mouseout", =>
          elem.animate(transform:'t0,0s1.0', 200, mina.linear, ->)
        $(elem.node).on "click", =>
          @hide()
          @trigger("levelselected", stage.sid)
      i++

  hide: ->
    @contentDom.fadeOut()
    @maskDom.fadeOut()

  show: ->
    @contentDom.fadeIn()
    @maskDom.fadeIn()
    @stageManager.queryStagePackageList (result) =>
      @stagePackageList = result
      @stageManager.queryStageList @stagePackageList[0], (stageData) =>
        @switchToStagePackage(0)
        @updateLevelElems(stageData)

  switchToStagePackage: (stagePackageIndex) ->
    @currentPackageIndex = stagePackageIndex;
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

  switchToNextStagePackage : () ->
    if @currentPackageIndex < @stagePackageList.length - 1
      @switchToStagePackage(@currentPackageIndex + 1)

  switchToPreviousStagePackage : () ->
    if @currentPackageIndex > 0
      @switchToStagePackage(@currentPackageIndex - 1)

module.exports = LevelSelector
