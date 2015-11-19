User = require('../../models/user.coffee')
bootstrap = require('../../commons/logic/bootstrap.coffee')

getQueryVariable = (variable) ->
  query = window.location.search.substring(1)
  vars = query.split('&')
  for i in [0..vars.length - 1]
    pair = vars[i].split('=')
    if decodeURIComponent(pair[0]) == variable
      return decodeURIComponent(pair[1])
  console.log('Query variable %s not found', variable)

# a class to setup user registration app
class AccountActivationApp

  @AUTO_CONFIGURE_SELECTOR = '.accountactivation-app'

  # Construct the accountactivation app
  # @param topDom: the mixin dom provided by template.jade
  constructor: (topDom) ->
    @user = new User
    @alertWaitingDom = $(topDom).find('.alert-info')
    @alertSuccessDom = $(topDom).find('.alert-success')
    @alertErrorDom = $(topDom).find('.alert-danger')

    console.log 'HHHH'
    @alertErrorDom.hide()
    @alertSuccessDom.hide()
    setTimeout(@activate.bind(@), 500)
    locationArr = window.location.search

    @uid = getQueryVariable('uid')
    @token = getQueryVariable('token')


  activate: () ->
    @user.activateAccount @uid, @token, (param) =>
      if not param?
        @alertWaitingDom.hide()
        @alertSuccessDom.show()
      else
        @alertWaitingDom.hide()
        @alertErrorDom.show()

# setup app on the page
bootstrap(AccountActivationApp)
module.exports = AccountActivationApp
