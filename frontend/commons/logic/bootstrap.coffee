# autoconfig apps in a page
# @cl: the class object
module.exports = (cl) ->
  # when page ready
  $ ->
    # get autoconfigure class dom info
    domSelector = cl.AUTO_CONFIGURE_SELECTOR

    # get items on page
    items = $(domSelector)

    # add apps to window
    for item in items
      window.apps = [] unless window.apps?
      window.apps.push(new cl(item))
