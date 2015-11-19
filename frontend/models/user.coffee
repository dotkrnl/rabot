Emitter = require('../commons/logic/emitter.coffee')

# The class User contacts with the backend via Ajax requests
# to perform user log in/out and login status check.
class User extends Emitter
  # Make user to be singleton
  instance = null

  # Construct the User model
  constructor: ->
    if instance
      return instance
    else
      instance = this
    super()
    @loggedin = false
    @user = {}
    @sync()

  # Login to user
  # @param username: username of the user
  # @param password: password of the user
  # @param cb: cb(err), to call after logged in
  login: (username, password, cb) ->
    @serverAction
      url : '/backend/login/'
      type : 'POST'
      data :
        JSON.stringify
          username : username
          password : password
      cb

  # Logout from user
  # @param cb: cb(err), to call after logged out
  logout: (cb) ->
    @serverAction
      url : '/backend/logout/'
      type : 'GET'
      cb

  # Register a new user
  # @param username: username of the user
  # @param password: password of the user
  # @param email: email address of the user
  # @param cb: cb(err), to call after registered
  register: (username, password, email, cb) ->
    @serverAction
      url : '/backend/registration/'
      type : 'POST'
      data :
        JSON.stringify
          username : username
          password : password
          email : email
      cb

  # Update user info
  # @param oldPassword: old password of the user
  # @param newPassword: new password of the user
  # @param newEmail: new email address of the user
  # @param cb: cb(err), to call after updated
  updateinfo: (oldPassword, newPassword, newEmail, cb) ->
    @serverAction
      url : '/backend/updateinfo/'
      type : 'POST'
      data :
        JSON.stringify
          oldPassword : oldPassword
          newPassword : newPassword
          new_email : newEmail
      cb

  # Do a server action, json is forced
  # @param param: the param pass to $.ajax
  # @param cb: callback to call after action finished
  # see jQuery documentation for details
  serverAction: (param, cb) ->
    param['contentType'] = 'application/json'
    param['dataType'] = 'json'
    $.ajax param
    .done (result) =>
      syncCb = \
        if result.result != 'succeeded'
          -> cb(result.errorMessage) if cb?
        else cb
      @sync(syncCb)

  # Do a sync with server
  # @param cb: callback to call after syncing finished
  sync: (cb) ->
    $.ajax
      url : '/backend/login/'
      type : 'GET'
      dataType: 'json'
    .done (result) =>
      if result.result == 'succeeded'
        @loggedin = result.loggedin
        @user = result.user
        cb() if cb?
      else
        @loggedin = false
        @user = {}
        cb(result.errorMessage) if cb?
      @update()

  # Trigger event after user updated
  update: ->
    @trigger('update')

  # Activation
  activateAccount: (uid, token, cb) ->
    $.ajax
      url : '/backend/authentication/' + uid + '/' + token
      type : 'GET'
      dataType: 'json'
    .done (result) =>
      if result.result == 'succeeded'
        cb() if cb?
      else
        cb(result.errorMessage) if cb?
      @update()

module.exports = User
