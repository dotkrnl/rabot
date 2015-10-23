# The class LoginManager contacts with the backend via Ajax requests
# to perform user log in/out and login status check.
class LoginManager
  constructor: ->
    @view = null
    @username = ''
    @update()

  update: ->
    if @view?
      @view.update()

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
      @update()

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
      @update()
      $("#navbar_password").val('')

  register: (loginUI) ->
    @view = loginUI
    @view._register(@)

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
      @update()

module.exports = LoginManager
