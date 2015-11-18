User = require('../../models/user.coffee')
bootstrap = require('../../commons/logic/bootstrap.coffee')

# a class to setup user registration app
class RegisterApp

  @AUTO_CONFIGURE_SELECTOR = '.register-app'

  # Construct the registration app
  # @param topDom: the mixin dom provided by template.jade
  constructor: (topDom) ->
    @user = new User
    @username = $(topDom).find('.ra-username')
    @password = $(topDom).find('.ra-password')
    @comfirm = $(topDom).find('.ra-confirm')
    @email = $(topDom).find('.ra-email')
    @submit = $(topDom).find('.ra-submit')
    @submitting = $(topDom).find('.ra-submitting')

    $(topDom).find('.ra-form').on 'submit', =>
      event.preventDefault()
      @register()

  register: () ->
    return if not @validate()

    username = @username.val().trim()
    password = @password.val()
    email = @email.val().trim()

    @submit.addClass('hidden')
    @submitting.removeClass('hidden')
    @user.register username, password, email, (err) =>
      if err?
        @submitting.addClass('hidden')
        @submit.removeClass('hidden')
        alert(err)
      else
        alert('Registration succeeded. Please check your email and confirm \
        your registration.')
        window.location.href = '/'

  validate: () ->
    has_err = false

    err = @username.val().trim() == ''
    @showError(@username, err)
    has_err |= err

    err = @password.val() == ''
    @showError(@password, err)
    has_err |= err

    err = @email.val().trim() == ''
    @showError(@email, err)
    has_err |= err

    err = not /^\w+([\.-]?\w+)*@\w+([\.-]?\w+)*(\.\w{2,10})+$/
      .test(@email.val().trim())
    @showError(@email, err)
    has_err |= err

    err = @password.val() != @comfirm.val()
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
bootstrap(RegisterApp)
module.exports = RegisterApp
