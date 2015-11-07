Emitter = require('../../commons/logic/emitter.coffee')

# a class to setup user friendly code editor
class GameControlBar extends Emitter

  # Construct the level selector
  # @param topDom: the mixin dom provided by template.jade
  constructor: (topDom) ->
    super()
    console.log 'aaa'
    @buttonRunDom = $(topDom).find('.button-run')
    @buttonStopDom = $(topDom).find('.button-stop')
    @buttonResetDom = $(topDom).find('.button-reset')

    @buttonRunDom.on 'click', =>
      @trigger 'runcode'
      @setGameRunning(true)

    @buttonStopDom.on 'click', =>
      @trigger 'stopcode'
      @setGameRunning(false)

    @buttonResetDom.on 'click', =>
      @trigger 'resetcode'

    @setGameRunning(false)

  setGameRunning: (isRunning) ->
    @isRunning = isRunning
    if @isRunning
      @buttonRunDom.hide()
      @buttonStopDom.show()
    else
      @buttonRunDom.show()
      @buttonStopDom.hide()

module.exports = GameControlBar
