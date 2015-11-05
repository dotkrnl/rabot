#LoginManager = require './models/loginmanager.coffee'
#LoginUI = require './views/loginui.coffee'

$ ->

  loginManager.loginCheck()

  $("#navbar_login_button").click ->
    loginManager.login($("#navbar_username").val(), $("#navbar_password").val())
    event.preventDefault()

  $("#navbar_logout_button").click ->
    loginManager.logout()
    event.preventDefault()
