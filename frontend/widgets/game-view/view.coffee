Game = require('../../models/game.coffee')
Stage = require('../../models/stage.coffee')
UserWorker = require('../../commons/logic/worker.coffee')

CodeEditor = require('../code-editor/view.coffee')
GameScene = require('../game-scene/view.coffee')
LevelSelector = require('../level-selector/view.coffee')
GameOverDialog = require('../game-over-dialog/view.coffee')

# a class to setup view for user to play
class GameView

  # Construct the game view
  # @param topDom: the mixin dom provided by template.jade
  constructor: (topDom) ->
    @game = new Game
    @stage = new Stage
    @userWorker = null
    @gameScene = null
    @codeEditor = null
    @levelSelector = null
    @gameOverDialog = null
    @currentSid = -1

    gameSceneDom = $(topDom).find(".gv-game-scene")[0]
    if gameSceneDom?
      @gameScene = new GameScene(gameSceneDom)
    else
      throw new Error('no game scene inside GameView')

    codeEditerDom = $(topDom).find(".gv-code-editor")[0]
    if codeEditerDom?
      @codeEditor = new CodeEditor(codeEditerDom)
    else
      throw new Error('no code editor inside GameView')

    levelSelectorDom = $(topDom).find(".gv-level-selector")[0]
    if levelSelectorDom?
      @levelSelector = new LevelSelector(levelSelectorDom)
    else
      throw new Error('no level selector inside GameView')

    gameOverDialogDom = $(topDom).find(".gv-game-over-dialog")[0]
    if gameOverDialogDom?
      @gameOverDialog = new GameOverDialog(gameOverDialogDom)
    else
      throw new Error('no game over dialog inside GameView')

    @game.register @gameScene

    @game.on 'win', =>
      @gameOverDialog.show(@game.carrotGot)
    @game.on 'lost', =>
      @gameOverDialog.show(-1)
    @game.on 'finish', @stopGame.bind(@)

    @levelSelector.on "levelselected", (stageId) =>
      @currentSid = parseInt(stageId)
      @stage.getStage stageId, (stageData) =>
        @game.loadStage stageData.info

    @gameOverDialog.on "replaystage", =>
      @game.restartStage()
    @gameOverDialog.on "nextstage", =>
      @currentSid++
      @stage.getStage @currentSid, (stageData) =>
        @game.loadStage stageData.info
    # TODO: merge stage manager
    @game.loadStage """[
      {"type":"river","x":0,"y":150,"width":300,"height":75},
      {"type":"river","x":575,"y":150,"width":300,"height":75},
      {"type":"carrot","x":300,"y":50},
      {"type":"rabbit","x":300,"y":370,"angle":0}
    ]"""

    # TODO: split to new view
    $(topDom).find('.run-code.btn').click =>
      code = @codeEditor.getCode()
      @userWorker = new UserWorker @game, code
    $(topDom).find('.stop-code.btn').click ->
      stopGame()
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

  stopGame: ->
    @userWorker.terminate() if @userWorker?
    @userWorker = null
    @game.restartStage()


module.exports = GameView
