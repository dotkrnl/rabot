Game = require('../../models/game.coffee')
Stage = require('../../models/stage.coffee')
UserWorker = require('../../commons/logic/worker.coffee')

CodeEditor = require('../code-editor/view.coffee')
GameScene = require('../game-scene/view.coffee')
LevelSelector = require('../level-selector/view.coffee')

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

    @game.register @gameScene

    @game.on 'win', =>
      alert "win #{@game.carrotGot} (not implemented)"
    @game.on 'lost', =>
      alert "lost #{@game.carrotGot} (not implemented)"
    @game.on 'finish', @stopGame.bind(@)

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

  stopGame: ->
    @userWorker.terminate() if @userWorker?
    @userWorker = null
    @game.restartStage()


module.exports = GameView
