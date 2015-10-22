returnMethod = jest.genMockFunction().mockImplementation () ->
  return 'test done'

callbackMethod = jest.genMockFunction().mockImplementation (cb) ->
  setTimeout( ->
    cb('test done')
  , 10000)

describe 'Jest', ->
  it 'adds 1 + 2 to equal 3', ->
    expect(1 + 2).toBe 3

  it 'mocks returning method', ->
    expect(returnMethod()).toBe 'test done'
    expect(returnMethod.mock.calls.length).toBe 1

  it 'calls setTimeout with the correct params', ->
    dummyCallback = ->
    callbackMethod(dummyCallback)
    expect(setTimeout.mock.calls.length).toBe 1
    expect(setTimeout.mock.calls[0][1]).toBe 10000

  it 'calls the callback when setTimeout are finished', ->
    callback = jest.genMockFunction()
    callbackMethod(callback)
    expect(callback).not.toBeCalled()
    jest.runAllTimers()
    expect(callback.mock.calls.length).toBe 1
    expect(callback).toBeCalledWith 'test done'
