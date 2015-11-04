# The class LoginManager contacts with the backend via Ajax requests
# to perform user log in/out and login status check.
class LoginManager
  constructor: ->
    @view = null
    @uid = 0
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
        @uid = result.uid
        @username = username
      else
        alert result.errorMessage
      @update()

  logout: (handler) ->
    $.ajax
      url : '/backend/logout/'
      type : 'POST'
      data :
        JSON.stringify
          uid : @uid
      contentType: "application/json"
      dataType: 'json'
    .done (result) =>
      if result.result == 'succeeded'
        @uid = 0
        @username = ''
      else
        alert result.errorMessage
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
