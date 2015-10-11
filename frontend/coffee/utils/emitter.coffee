class Emitter
  constructor: ->
    @cbs = {}

  on: (names, cb) ->
    names = names.split(' ')
    for name in names
      @cbs[name] = $.Callbacks('memory unique') if not @cbs[name]?
      @cbs[name].add(cb)
    return

  off: (names, cb) ->
    names = names.split(' ')
    for name in names
      @cbs[name].remove(cb) if @cbs[name]?
    return

  trigger: (names) ->
    names = names.split(' ')
    for name in names
      @cbs[name].fire(
        Array.prototype.slice.call(arguments, 1)
      ) if @cbs[name]?
    return

module.exports = Emitter
