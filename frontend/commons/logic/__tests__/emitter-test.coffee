jest.dontMock '../emitter.coffee'
Emitter = require '../emitter.coffee'

window.$ =
  Callbacks: () ->
    return {
      add: jest.genMockFunction()
      remove: jest.genMockFunction()
      fire: jest.genMockFunction()
    }

describe 'Emitter.constructor', ->
  it 'constructs with no callbacks', ->
    emitter = new Emitter
    expect(emitter.cbs).toBeDefined()

describe 'Emitter.on', ->
  it 'stacks callbacks', ->
    emitter = new Emitter
    emitter.on 'test1', ->
    expect(emitter.cbs['test1']).toBeDefined()
    expect(emitter.cbs['test1'].add.mock.calls.length).toBe 1
    emitter.on 'test1', ->
    expect(emitter.cbs['test1'].add.mock.calls.length).toBe 2

  it 'add mutiple callbacks with space', ->
    emitter = new Emitter
    emitter.on 'test1 test2', ->
    expect(emitter.cbs['test1']).toBeDefined()
    expect(emitter.cbs['test2']).toBeDefined()
    expect(emitter.cbs['test1'].add).toBeCalled()
    expect(emitter.cbs['test2'].add).toBeCalled()

describe 'Emitter.off', ->
  it 'remove nothing if nothing', ->
    emitter = new Emitter
    tester = ->
    emitter.off 'test1', tester
    expect(emitter.cbs['test1']).toBeUndefined()

  it 'remove callbacks', ->
    emitter = new Emitter
    tester = ->
    emitter.on 'test1', tester
    emitter.off 'test1', tester
    expect(emitter.cbs['test1'].remove).toBeCalledWith tester

  it 'remove mutiple callbacks', ->
    emitter = new Emitter
    tester = ->
    emitter.on 'test1', tester
    emitter.on 'test2', tester
    emitter.off 'test1 test2', tester
    expect(emitter.cbs['test1'].remove).toBeCalledWith tester
    expect(emitter.cbs['test2'].remove).toBeCalledWith tester

describe 'Emitter.trigger', ->
  it 'do nothing if nothing', ->
    emitter = new Emitter
    emitter.trigger 'nothing'
    expect(emitter.cbs['nothing']).toBeUndefined()

  it 'trigger callbacks and pass args', ->
    emitter = new Emitter
    tester = ->
    emitter.on 'test1', tester
    emitter.trigger 'test1', 1234
    expect(emitter.cbs['test1'].fire).toBeCalledWith 1234

  it 'trigger multiple callbacks', ->
    emitter = new Emitter
    tester = ->
    emitter.on 'test1', tester
    emitter.on 'test2', tester
    emitter.trigger 'test1 test2', 1234
    expect(emitter.cbs['test1'].fire).toBeCalled()
    expect(emitter.cbs['test1'].fire).toBeCalled()
