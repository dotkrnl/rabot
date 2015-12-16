jest.dontMock '../user.coffee'
User = require '../user.coffee'

describe 'User.constructs', ->
  it 'constructs with no error and calling sync and is a singleton', ->
    User.prototype.sync = jest.genMockFunction()
    user1 = new User
    user2 = new User
    expect(user1).toBeDefined()
    expect(user1 == user2).toBe(true)
    expect(user1.sync.mock.calls.length).toBe 1

describe 'User.login', ->
  it 'calls serverAction with correct parameters', ->
    User.prototype.sync = jest.genMockFunction()
    User.prototype.serverAction = jest.genMockFunction()
    testingCb = jest.genMockFunction()
    userManager = new User
    userManager.login('someuser', 'somepasswd', testingCb)
    expect(userManager.serverAction.mock.calls.length).toBe 1
    serverActionCall = userManager.serverAction.mock.calls[0]
    expect(serverActionCall[0].url).toBe('/backend/login/')
    expect(serverActionCall[0].type).toBe('POST')
    expect(serverActionCall[0].data).toBe \
      JSON.stringify
        username : 'someuser'
        password : 'somepasswd'
    expect(serverActionCall[1]).toBe(testingCb)

describe 'User.logout', ->
  it 'calls serverAction with correct parameters', ->
    User.prototype.sync = jest.genMockFunction()
    User.prototype.serverAction = jest.genMockFunction()
    testingCb = jest.genMockFunction()
    userManager = new User
    userManager.logout(testingCb)
    expect(userManager.serverAction.mock.calls.length).toBe 1
    serverActionCall = userManager.serverAction.mock.calls[0]
    expect(serverActionCall[0].url).toBe('/backend/logout/')
    expect(serverActionCall[0].type).toBe('GET')
    expect(serverActionCall[1]).toBe(testingCb)

describe 'User.register', ->
  it 'calls serverAction with correct parameters', ->
    User.prototype.sync = jest.genMockFunction()
    User.prototype.serverAction = jest.genMockFunction()
    testingCb = jest.genMockFunction()
    userManager = new User
    userManager.register(
      'someuser', 'somepasswd', 'example@example.com', testingCb
    )
    expect(userManager.serverAction.mock.calls.length).toBe 1
    serverActionCall = userManager.serverAction.mock.calls[0]
    expect(serverActionCall[0].url).toBe('/backend/registration/')
    expect(serverActionCall[0].type).toBe('POST')
    expect(serverActionCall[0].data).toBe \
      JSON.stringify
        username : 'someuser'
        password : 'somepasswd'
        email : 'example@example.com'
    expect(serverActionCall[1]).toBe(testingCb)

describe 'User.updateinfo', ->
  it 'calls serverAction with correct parameters', ->
    User.prototype.sync = jest.genMockFunction()
    User.prototype.serverAction = jest.genMockFunction()
    testingCb = jest.genMockFunction()
    userManager = new User
    userManager.updateinfo(
      'oldpasswd', 'newpasswd', 'example@example.com', testingCb
    )
    expect(userManager.serverAction.mock.calls.length).toBe 1
    serverActionCall = userManager.serverAction.mock.calls[0]
    expect(serverActionCall[0].url).toBe('/backend/updateinfo/')
    expect(serverActionCall[0].type).toBe('POST')
    expect(serverActionCall[0].data).toBe \
      JSON.stringify
        oldPassword : 'oldpasswd'
        newPassword : 'newpasswd'
        new_email : 'example@example.com'
    expect(serverActionCall[1]).toBe(testingCb)
