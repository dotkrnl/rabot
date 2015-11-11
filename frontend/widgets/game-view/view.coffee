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
      instance = createjs.Sound.play("sound", "none", 0, 0, -1)
      instance.on("complete", this.handleComplete, this)
      instance.volume = 0.5)
     , @);
    createjs.Sound.registerSound("/public/audios/ambient-forest.mp3", "sound");
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
      @bindGame(new Game)
      @game.loadStage(stageData)

    @bindGame(new Game)

    @levelSelector.on "levelselected", (stageId) =>
      @currentSid = parseInt(stageId)
      @stage.getStage stageId, (stageData) =>
        @game.loadStage stageData.info

    @levelSelector.show()

    @gameOverDialog.on "replaystage", =>
      @game.restartStage()
    @gameOverDialog.on "nextstage", =>
      @currentSid++
      @stage.getStage @currentSid, (stageData) =>
        @game.loadStage stageData.info

    $(topDom).find('.select-level.btn').click =>
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
        <button class=\"btn-code-assistance-#{userAPI} btn btn-primary\"
        type=\"submit\">
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
      userProgress.updateUserProgress(101, @currentSid, @game.carrotGot)
      @gameOverDialog.show(@game.carrotGot)
    @game.on 'lost', =>
      @gameOverDialog.show(-1)
    @game.on 'finish', =>
      @stopGame()
      @gameControlBar.setGameRunning(false)

  stopGame: ->
    @userWorker.terminate() if @userWorker?
    @userWorker = null

module.exports = GameView
