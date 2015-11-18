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

    @guestViewUsername.add(@guestViewPassword).keyup (e) =>
      @login() if e.keyCode == 13 # is enter key

  login: ->
    username = @guestViewUsername.val().trim()
    password = @guestViewPassword.val()
    @validate(username, password)

    if username != '' and password != ''
      @user.login username, password, (err) =>
        if err?
          @guestViewUsername.add(@guestViewPassword).parent()
            .addClass('has-error')
          alert(err)
        else
          @guestViewUsername.add(@guestViewPassword).parent()
            .removeClass('has-error')
          @topView.removeClass('open');

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

  validate: (username, password) ->
    if username == ''
      @guestViewUsername.parent().addClass('has-error')
    else
      @guestViewUsername.parent().removeClass('has-error')

    if password == ''
      @guestViewPassword.parent().addClass('has-error')
    else
      @guestViewPassword.parent().removeClass('has-error')


module.exports = NavUserManager
