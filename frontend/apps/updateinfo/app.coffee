User = require('../../models/user.coffee')
bootstrap = require('../../commons/logic/bootstrap.coffee')

# a class to setup user registration app
class UpdateApp

  @AUTO_CONFIGURE_SELECTOR = '.update-app'

  # Construct the registration app
  # @param topDom: the mixin dom provided by template.jade
  constructor: (topDom) ->
    @user = new User
    @password = $(topDom).find('.ua-password')
    @newpwd = $(topDom).find('.ua-newpwd')
    @comfirm = $(topDom).find('.ua-confirm')
    @email = $(topDom).find('.ua-email')

    $(topDom).find('.ua-submit').click(@updateinfo.bind(@))

  updateinfo: ->
    if @newpwd.val() != @comfirm.val()
      alert('Different password')
    else
      @user.updateinfo @password.val(), @newpwd.val(),
        @email.val(), (err) =>
          if err?
            alert(err)
          else
            window.location.href = '/'


# setup app on the page
bootstrap(UpdateApp)
module.exports = UpdateApp
