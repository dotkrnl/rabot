NavUserManager = require('../widgets/nav-user-manager/view.coffee')

module.exports = () ->
  $ ->
    window.commons = [] if not window.commons?
    $('.nav-user-manager').each (index, dom) ->
      window.commons.push(new NavUserManager(dom))
