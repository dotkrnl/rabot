class LoginUI
  constructor: ->
    @loginManager = null
    @update()

  _register: (loginManager) ->
    @loginManager = loginManager
    @update()
    return

  update: () ->
    $("#navbar_before_login").hide()
    $("#navbar_after_login").hide()
    if @loginManager? and @loginManager.username
      $("#navbar_after_login").show()
      $("#navbar_message").text("Welcome, " + @loginManager.username)
    else
      $("#navbar_before_login").show()

module.exports = LoginUI
