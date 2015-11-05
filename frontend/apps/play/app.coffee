bootstrap = require('../../commons/logic/bootstrap.coffee')
GameView = require('../../widgets/game-view/view.coffee')

# a class to setup user playing app
class PlayApp

  @AUTO_CONFIGURE_SELECTOR = '.play-app'

  # Construct the playing app
  # @param topDom: the mixin dom provided by template.jade
  constructor: (topDom) ->
    gameViewDom = $(topDom).find(".pa-game-view")[0]

    # setup game view
    if gameViewDom?
      @gameView = new GameView(gameViewDom)
    else
      throw new Error('no game view inside PlayApp')


# setup app on the page
bootstrap(PlayApp)
module.exports = PlayApp
