jest.dontMock '../worker.coffee'
Worker = require '../worker.coffee'

window.URL = {
  createObjectURL: (blob) ->
    return blob
}

class W
  constructor: (blob) ->
  @test_post = jest.genMockFunction()
  @test_term = jest.genMockFunction()
  postMessage: (message) ->
    W.test_post(message)
  terminate: () ->
    W.test_term()
window.Worker = W

window.CoffeeScript = {
  compile: (code) ->
    return code
}


describe 'UserCodeWorker.constructor', ->
  it 'constructs with worker', ->
    prepare = Worker.prototype.prepareWorkerGameObject
    Worker.prototype.prepareWorkerGameObject = jest.genMockFunction()
    worker = new Worker('game1', 'move 1')
    expect(worker.game).toBe 'game1'
    expect(worker.code).toBe 'move 1'
    expect(worker.worker).toBeDefined()
    expect(worker.worker.onmessage).toBeDefined()
    Worker.prototype.prepareWorkerGameObject = prepare

describe 'UserCodeWorker.onmessage', ->
  it 'does nothing if nothing', ->
    prepare = Worker.prototype.prepareWorkerGameObject
    Worker.prototype.prepareWorkerGameObject = jest.genMockFunction()
    worker = new Worker('game1', 'move 1')
    worker.onmessage()
    # expect not faults
    Worker.prototype.prepareWorkerGameObject = prepare

  it 'calls correct game function', ->
    prepare = Worker.prototype.prepareWorkerGameObject
    Worker.prototype.prepareWorkerGameObject = jest.genMockFunction()
    game =
      move: jest.genMockFunction()
      turn: jest.genMockFunction()
      turnTo: jest.genMockFunction()
      onWorkerHighlight: jest.genMockFunction()
      onWorkerUnhighlight: jest.genMockFunction()
      finish: jest.genMockFunction()
    worker = new Worker(game, 'move 1')
    worker.onmessage { data: { action: 'move', step: 1 } }
    expect(game.move.mock.calls[0][0]).toBe(1)
    worker.onmessage { data: { action: 'turn', angle: 90 } }
    expect(game.turn.mock.calls[0][0]).toBe(90)
    worker.onmessage { data: { action: 'turnTo', uid: 17 } }
    expect(game.turnTo.mock.calls[0][0]).toBe(17)
    worker.onmessage { data: { action: 'highlight', lineNumber: 2 }}
    expect(game.onWorkerHighlight.mock.calls[0][0]).toBe(2)
    worker.onmessage { data: { action: 'unhighlight', lineNumber: 3 }}
    expect(game.onWorkerUnhighlight.mock.calls[0][0]).toBe(3)
    worker.onmessage { data: { action: 'finish' }}
    expect(game.finish).toBeCalled()
    Worker.prototype.prepareWorkerGameObject = prepare

describe 'UserCodeWorker.prepareWorkerGameObject', ->
  it 'filters types', ->
    game =
      filterSprites: (dict) ->
        if dict['type'] == 'rabbit'
          return ['item']
        else
          return []
    worker = new Worker(game, 'move 1')
    expect(worker.prepareWorkerGameObject()['rabbit']).toBe 'item'

describe 'UserCodeWorker.resume', ->
  it 'posts message to worker', ->
    prepare = Worker.prototype.prepareWorkerGameObject
    Worker.prototype.prepareWorkerGameObject = jest.genMockFunction()
    worker = new Worker('game', 'move 1')
    worker.resume()
    expect(W.test_post.mock
      .calls[W.test_post.mock.calls.length-1][0].action)
      .toBe 'resume'
    Worker.prototype.prepareWorkerGameObject = prepare

describe 'UserCodeWorker.terminate', ->
  it 'posts terminate to worker', ->
    prepare = Worker.prototype.prepareWorkerGameObject
    Worker.prototype.prepareWorkerGameObject = jest.genMockFunction()
    worker = new Worker('game', 'move 1')
    worker.terminate()
    expect(W.test_term).toBeCalled()
    Worker.prototype.prepareWorkerGameObject = prepare
