User = require('../../models/user.coffee')
md5 = require('../../commons/logic/md5.coffee')

# The class NavUserManager is the view class for the login manager
# user interface on the navigation bar
class NavUserManager

  AVATAR_BASE: "https://secure.gravatar.com/avatar/"

  # Construct the user interface of the login manager, it also perform startup
  # login status synchronization.
  constructor: (topDom) ->

    # Listen to user login status update event, perform startup synchronization.
    @user = new User
    @user.on('update', @update.bind(@))
    @user.sync()

    # Bind child element event.
    $(topDom).find('.num-gv-login').on 'click touch', @login.bind(@)
    $(topDom).find('.num-uv-logout').on 'click touch', @logout.bind(@)

    # Get child view jQuery objects.
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

  # This function handles the login button event, it will check the user input
  # and send it to server, then update user login status.
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
        @topView.removeClass('open')

    return

  # This function handles logout button event, and send logout request to
  # server.
  logout: ->
    @user.logout =>
      @topView.removeClass('open')

  # Updates the UI of the login manager, dependingon whether the user has
  # logged in.
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

  # This function checks whether user input has obvious error.
  # i.e An empty username/pssword.
  # @return returns true when user input has no obvious error. Returns false
  # when it has.
  validate: () ->
    has_err = false

    err = @guestViewUsername.val().trim() == ''
    @showError(@guestViewUsername, err)
    has_err |= err

    err = @guestViewPassword.val() == ''
    @showError(@guestViewPassword, err)
    has_err |= err

    return not has_err

  # Update visual indication for user input error.
  showError: (dom, isError) ->
    if isError
      dom.parent().addClass('has-error')
    else
      dom.parent().removeClass('has-error')

  # Hide the user login manager UI.
  disable: () ->
    @disabled = true
    @guestViewLogin.addClass('hidden')
    @guestViewLoggingin.removeClass('hidden')

  # Show the user login manager UI.
  enable: () ->
    @disabled = false
    @guestViewLoggingin.addClass('hidden')
    @guestViewLogin.removeClass('hidden')


module.exports = NavUserManager
