# The class User contacts with the backend via Ajax requests
# to perform user log in/out and login status check.

class User
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

  registration: (username, password, password2, email, handler) ->
    $.ajax
      url : '/backend/registration/'
      type : 'POST'
      data :
        JSON.stringify
          username : username
          password : password
          repeatedPassword : password2
          email : email
      contentType: "application/json"
      dataType: 'json'
    .done (result) =>
      if result.result != 'succeeded'
        alert result.errorMessage
      @update()

  updateinfo: (old_password, new_password, new_password2, new_email, handler) ->
    $.ajax
      url : '/backend/updateinfo/'
      type : 'POST'
      data :
        JSON.stringify
          uid : @uid
          oldPassword : old_password
          newPassword : new_password
          repeatedPassword : new_password2
          new_email : new_email
      contentType: "application/json"
      dataType: 'json'
    .done (result) =>
      if result.result != 'succeeded'
        alert result.errorMessage
      @update()

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

module.exports = User
