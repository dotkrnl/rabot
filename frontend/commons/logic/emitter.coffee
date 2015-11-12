# The class Emitter provides the ability to trigger a event and register /
# unregister callbacks for a apecific event.
# The class is based on jQuery Callbacks objects.
# See https://api.jquery.com/jQuery.Callbacks for further informantion.

class Emitter

  # cbs is an object where its key is event name and
  # value is jQuery Callbacks objects.
  constructor: ->
    @cbs = {}

  # Register callback cb for events in "names". Multiple events
  # can be specific by separating with space.
  on: (names, cb) ->
    names = names.split(' ')
    for name in names
      @cbs[name] = $.Callbacks('memory unique') if not @cbs[name]?
      @cbs[name].add(cb)
    return

  # Unregister callback cb for events in "names". Multiple events
  # can be specific by separating with space.
  off: (names, cb) ->
    names = names.split(' ')
    for name in names
      @cbs[name].remove(cb) if @cbs[name]?
    return

  # Trigeer all events in names.
  # The arguments beginning from the second one
  # will be passed to the callback functions.
  trigger: (names) ->
    names = names.split(' ')
    for name in names
      @cbs[name].fire.apply(
        @, Array.prototype.slice.call(arguments, 1)
      ) if @cbs[name]?
    return

module.exports = Emitter
