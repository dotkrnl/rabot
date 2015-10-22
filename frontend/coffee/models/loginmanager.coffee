#This class is currently a stub
class LoginManager
  constructor: ->
    @username = ''
    @updateInterface()

  updateInterface: () ->
    $("#navbar_before_login").hide()
    $("#navbar_after_login").hide()
    if @username
      $("#navbar_after_login").show()
      $("#navbar_message").text("Welcome, " + @username)
    else
      $("#navbar_before_login").show()


  login: (username, password, handler) ->
    $.ajax
      url : '/backend/login/'
      type : 'POST'
      data :
        JSON.stringify
          username : username
          password : password
      contentType: "application/json"
      dataType: 'json'
    .done (result) =>
      if result.result == 'succeeded'
        @username = username
      else
        alert "Invalid username or password!"
        @username = ''
      @updateInterface()

  logout: () ->
    $.ajax
      url : '/backend/login/'
      type : 'POST'
      data :
        JSON.stringify
          username : ''
          password : ''
      contentType: "application/json"
      dataType: 'json'
    .done (result) =>
      @username = ''
      @updateInterface()
      $("#navbar_password").val('')

  loginCheck: () ->
    $.ajax
      url : '/backend/login/'
      type : 'GET'
      dataType: 'json'
    .done (result) =>
      if result.result == 'succeeded'
        @username = result.username
      else
        @username = ''
      @updateInterface()

module.exports = LoginManager
