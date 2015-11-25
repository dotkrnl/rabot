Emitter = require('../commons/logic/emitter.coffee')

# The class View is the base class for HTML views, providing some convience for
# child view lookup / creation.
class View extends Emitter

  # Construct the view by providing top-level DOM object. This also initialize
  # the base class Emitter.
  # @param topDom: the mixin dom provided by template.jade
  constructor: (@topDom) ->
    super()

  # Get a child DOM object identified by its class name. Note that while using
  # this method, the class name must exist and be unique, otherwise it will
  # throw an error.
  # @param className: The class name of the DOM element.
  # @return the DOM object identified by className.
  getDOMElement: (className) ->

    # Check the parameter type.
    if typeof className != 'string'
      throw new Error('CSS class name must be a string.')
    if className.length <= 0
      throw new Error('CSS class name cannot be empty.')

    # Convert the class name to a selector.
    if className[0] != '.'
      className = '.' + className

    # Get the object and check if it's unique.
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

  # Similar to getDOMElement, but returns an jQuery object identified by
  # className.
  # @param className: The class name of the element.
  # @return the jQuery object identified by className.
  getJQueryObject: (className) ->
    $(@getDOMElement(className))

  # Similar to getDOMElement, but returns an child view object constructed by
  # the class object classObject.
  # @param cssClassName: The class name of the element.
  # @param classObject: The child view class, it needs to accept a DOM element
  # as its param.
  # @return the child view object.
  createViewFromElement: (cssClassName, classObject) ->
    new classObject(@getDOMElement(cssClassName))

  # Get the asset directory for this project.
  # @return the directory, ends with separator '/'.
  getAssetPath: () ->
    return '/public/'

  # Get the image asset directory for this project.
  # @return the directory, ends with separator '/'.
  getImageAssetPath: () ->
    return @getAssetPath() + 'images/'

  # Get the audio directory for this project.
  # @return the directory, ends with separator '/'.
  getAudioAssetPath: () ->
    return @getAssetPath() + 'audios/'

module.exports = View
