class View
  constructor: (@topDom) ->

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
        "No element with class #{className} found in #{topDOM}"
      )
    if domObjects.length >= 2
      throw new Error(
        "Multiple element with class #{className} found in #{topDOM}"
      )
    return domObjects[0]

  getJQueryObject: (className) ->
    $(@getDOMElement(className))

  createViewFromElement: (cssClassName, classObject) ->
    new classObject(@getDOMElement(cssClassName))

module.exports = View
