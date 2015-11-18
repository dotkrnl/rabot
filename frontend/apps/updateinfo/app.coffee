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
    @submit = $(topDom).find('.ua-submit')
    @submitting = $(topDom).find('.ua-submitting')

    $(topDom).find('.ua-form').on 'submit', =>
      event.preventDefault()
      @updateinfo()

  updateinfo: ->
    return if not @validate()

    password = @password.val()
    newpwd = @newpwd.val()
    email = @email.val().trim()

    @submit.addClass('hidden')
    @submitting.removeClass('hidden')
    @user.updateinfo password, newpwd, email, (err) =>
      if err?
        @submitting.addClass('hidden')
        @submit.removeClass('hidden')
        alert(err)
      else
        alert('Login updated.')
        window.location.href = '/'

  validate: () ->
    has_err = false

    err = @password.val() == ''
    @showError(@password, err)
    has_err |= err

    if @email.val().trim() != ''
      err = not /^\w+([\.-]?\w+)*@\w+([\.-]?\w+)*(\.\w{2,10})+$/
        .test(@email.val().trim())
      @showError(@email, err)
      has_err |= err

    err = @newpwd.val() != @comfirm.val()
    @showError(@comfirm, err)
    if err
      alert('Please confirm you have entered your password correctly.')
    has_err |= err

    return not has_err

  showError: (dom, isError) ->
    if isError
      dom.parent().addClass('has-error')
    else
      dom.parent().removeClass('has-error')


# setup app on the page
bootstrap(UpdateApp)
module.exports = UpdateApp
