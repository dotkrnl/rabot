Emitter = require('../../commons/logic/emitter.coffee')

# a class to setup user friendly code editor
class GameControlBar extends Emitter

  # Construct the level selector
  # @param topDom: the mixin dom provided by template.jade
  constructor: (topDom) ->
    super()

module.exports = GameControlBar
