Game = require('../../models/game.coffee')
Stage = require('../../models/stage.coffee')
UserWorker = require('../../commons/logic/worker.coffee')
UserProgress = require('../../models/userprogress.coffee')

CodeEditor = require('../code-editor/view.coffee')
GameScene = require('../game-scene/view.coffee')
LevelSelector = require('../level-selector/view.coffee')
GameOverDialog = require('../game-over-dialog/view.coffee')
GameControlBar = require('../game-control-bar/view.coffee')
View = require('../view.coffee')

# a class to setup view for user to play
class GameView extends View

  # Construct the game view
  # @param topDom: the mixin dom provided by template.jade
  constructor: (topDom) ->
    super(topDom)
    createjs.Sound.on("fileload", (->
      instance = createjs.Sound.play("ambient", {loop: -1})
      instance.on("complete", this.handleComplete, this)
      instance.volume = 0.5)
     , @)
    createjs.Sound.registerSound \
      @getAudioAssetPath() + "ambient-forest.mp3", "ambient"
    createjs.Sound.registerSound \
      @getAudioAssetPath() + "item-get.mp3", "item-get"
    @game = new Game
    @stage = new Stage
    @userWorker = null
    @gameScene = null
    @codeEditor = null
    @levelSelector = null
    @gameOverDialog = null
    @currentSid = -1

    @gameScene = @createViewFromElement("gv-game-scene", GameScene)
    @codeEditor = @createViewFromElement("gv-code-editor", CodeEditor)
    @levelSelector = @createViewFromElement("gv-level-selector", LevelSelector)
    @gameOverDialog = @createViewFromElement(
      "gv-game-over-dialog", GameOverDialog
    )
    @gameControlBar = @createViewFromElement(
      "gv-game-control-bar", GameControlBar
    )

    @gameControlBar.on 'runcode', =>
      code = @codeEditor.getCode()
      @userWorker = new UserWorker @game, code

    @gameControlBar.on 'stopcode', =>
      @stopGame()
      stageData = @game.stageData
      @game.unregister()
      console.log 'New Game!!'
      @bindGame(new Game)
      @game.loadStage(stageData)

    @gameControlBar.on 'resetcode',
      @codeEditor.clearCode.bind(@codeEditor)

    @bindGame(new Game)

    @levelSelector.on "levelselected", (packageId, stageIndex) =>
      @currentPackage = packageId
      packageData = @stage.getStagePackage(packageId).stages
      @currentStageIndex = stageIndex
      @currentSid = parseInt(packageData[stageIndex])
      @stage.getStage @currentSid, (stageData) =>
        @game.loadStage stageData.info

    @levelSelector.show()

    @gameOverDialog.on "replaystage", =>
      @game.restartStage()
    @gameOverDialog.on "nextstage", =>
      packageData = @stage.getStagePackage(@currentPackage).stages
      if @currentStageIndex < packageData.length - 1
        @currentStageIndex++
      @currentSid = parseInt(packageData[@currentStageIndex])
      @stage.getStage @currentSid, (stageData) =>
        @game.loadStage stageData.info

    @gameScene.on 'spriteclicked', (sprite, label) =>
      @codeEditor.insertCode(label)

    $('html').find('.nav-level-selector').click =>
      @levelSelector.show()

    @codeAssistanceDom = $(topDom).find(".gv-code-assistance")
    availableFunctions =
      move : "move <distance>"
      turn : "turn <angle|left|right>"
      turnTo : "turnTo <object>"
      distance : "distance <(obj1, obj2)|obj>"

    codeAssistanceHTML = ''
    for userAPI of availableFunctions
      codeAssistanceHTML += """
        <button class=\"btn-code-assistance-#{userAPI} btn btn-success\"
        type=\"button\">
          #{userAPI}
        </button>
      """

    @codeAssistanceDom.html(codeAssistanceHTML)
    for userAPI, code of availableFunctions
      do(userAPI, code) =>
        $(".btn-code-assistance-" + userAPI).click =>
          event.preventDefault()
          @codeEditor.insertCode(code)
          @codeEditor.focus()

  bindGame: (game) ->
    @game = game
    @game.register @gameScene
    @game.on 'win', =>
      userProgress = new UserProgress
      userProgress.updateUserProgress(
        @currentPackage, @currentStageIndex, @game.carrotGot
      )
      @gameOverDialog.show(@game.carrotGot, @currentSid)
    @game.on 'lost', =>
      @gameOverDialog.show(-1, @currentSid)
    @game.on 'finish', =>
      @stopGame()
      @gameControlBar.setGameRunning(false)
      @codeEditor.clearHighlightLine()

    @codeEditor.clearHighlightLine()
    @game.on 'workerhighlight', (lineNumber) =>
      @codeEditor.pushHighlightLine(lineNumber - 1)
    @game.on 'workerunhighlight', (lineNumber) =>
      @codeEditor.popHighlightLine(lineNumber - 1)

  stopGame: ->
    @userWorker.terminate() if @userWorker?
    @userWorker = null

module.exports = GameView
