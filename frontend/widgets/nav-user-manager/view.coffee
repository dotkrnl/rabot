User = require('../../models/user.coffee')
md5 = require('../../commons/logic/md5.coffee')

# a class to setup user manage interface on navbar
class NavUserManager

  AVATAR_BASE: "https://secure.gravatar.com/avatar/"

  # Construct the navbar login / logout interface
  constructor: (topDom) ->
    @user = new User
    @user.on('update', @update.bind(@))
    @user.sync()

    $(topDom).find('.num-gv-login').click(@login.bind(@))
    $(topDom).find('.num-uv-logout').click(@logout.bind(@))

    @topView = $(topDom)
    @guestView = $(topDom).find('.num-guest-view')
    @guestViewUsername = $(topDom).find('.num-gv-username')
    @guestViewPassword = $(topDom).find('.num-gv-password')
    @userView = $(topDom).find('.num-user-view')
    @userViewUsername = $(topDom).find('.num-uv-username')
    @userImg = $(topDom).find('.num-userinfo')
    @guestViewLogin = $(topDom).find('.num-gv-login')
    @guestViewLoggingin = $(topDom).find('.num-gv-loggingin')

    @disabled = false

    @guestViewUsername.add(@guestViewPassword).keyup (e) =>
      @login() if e.keyCode == 13 # is enter key

  login: ->
    return if @disabled
    return if not @validate()

    username = @guestViewUsername.val().trim()
    password = @guestViewPassword.val()
    @disable()
    @user.login username, password, (err) =>
      @enable()
      @showError(@guestViewUsername.add(@guestViewPassword), err?)
      if err?
        alert(err)
      else
        @guestViewPassword.val('')
        @topView.removeClass('open');

    return

  logout: ->
    @user.logout =>
      @topView.removeClass('open');

  update: ->
    if @user.loggedin
      @userView.removeClass('hidden')
      @guestView.addClass('hidden')
      @userViewUsername.text(@user.user.username)
      userhash = md5(@user.user.email)
      @userImg.attr('src', "#{@AVATAR_BASE}#{userhash}?d=identicon")

    else
      @userView.addClass('hidden')
      @guestView.removeClass('hidden')
      @userImg.attr('src', "#{@AVATAR_BASE}nobody?d=mm")

    return

  validate: () ->
    has_err = false

    err = @guestViewUsername.val().trim() == ''
    @showError(@guestViewUsername, err)
    has_err |= err

    err = @guestViewPassword.val() == ''
    @showError(@guestViewPassword, err)
    has_err |= err

    return not has_err

  showError: (dom, isError) ->
    if isError
      dom.parent().addClass('has-error')
    else
      dom.parent().removeClass('has-error')

  disable: () ->
    @disabled = true
    @guestViewLogin.addClass('hidden')
    @guestViewLoggingin.removeClass('hidden')

  enable: () ->
    @disabled = false
    @guestViewLoggingin.addClass('hidden')
    @guestViewLogin.removeClass('hidden')


module.exports = NavUserManager
