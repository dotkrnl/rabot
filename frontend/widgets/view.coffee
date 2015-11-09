Emitter = require('../commons/logic/emitter.coffee')
class View extends Emitter
  constructor: (@topDom) ->
    super()

  getDOMElement: (className) ->
    if typeof className != 'string'
      throw new Error('CSS class name must be a string.')
    if className.length <= 0
      throw new Error('CSS class name cannot be empty.')
    if className[0] != '.'
      className = '.' + className
    domObjects = $(@topDom).find(className)
    if domObjects.length <= 0
      throw new Error(
        "No element with class #{className} found in #{@topDom}"
      )
    if domObjects.length >= 2
      throw new Error(
        "Multiple element with class #{className} found in #{@topDom}"
      )
    return domObjects[0]

  getJQueryObject: (className) ->
    $(@getDOMElement(className))

  createViewFromElement: (cssClassName, classObject) ->
    new classObject(@getDOMElement(cssClassName))

  getAssetPath: () ->
    return '/public/'

  getImageAssetPath: () ->
    return @getAssetPath() + 'images/'

  getAudioAssetPath: () ->
    return @getAssetPath() + 'audios/'

module.exports = View
