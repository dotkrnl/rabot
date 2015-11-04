CodeEditor = require('../code-editor/view.coffee')

# a class to setup view for user to play
class GameView

  # Construct the game view
  # @param topDom: the mixin dom provided by template.jade
  constructor: (topDom) ->
    gameSceneDom = $(topDom).find(".gv-game-scene")[0]
    codeEditerDom = $(topDom).find(".gv-code-editor")[0]

    if codeEditerDom?
      @codeEditor = new CodeEditor(codeEditerDom)
    else
      throw new Error('no code editor inside GameView')


module.exports = GameView
