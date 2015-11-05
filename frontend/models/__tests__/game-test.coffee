jest.dontMock '../game.coffee'
Game = require '../game.coffee'


describe 'Game.constructs', ->
  it 'constructs with no scene nor error', ->
    game = new Game
    expect(game).toBeDefined()
    expect(game.scene).toBeNull()


describe 'Game.addSprite', ->
  it 'adds cloned sprites', ->
    game = new Game
    sprite =
      type: 'rabbit'
      x: 1, y: 2, angle: null
      lethal: true, passable: false
      defunct: true

    for i in [0..9]
      sprite.angle = i + 1
      game.addSprite sprite
      sprites = game.filterSprites()
      expect(game.filterSprites().length).toBe i + 1
    sprites = game.filterSprites()
    for i in [0..9]
      expect(sprites[i].type).toBe 'rabbit'
      expect(sprites[i].x).toBe 1
      expect(sprites[i].y).toBe 2
      expect(sprites[i].angle).toBe i + 1
      expect(sprites[i].lethal).toBe true
      expect(sprites[i].passable).toBe false
      expect(sprites[i].defunct).toBe true
      expect(sprites[i].uid).toBe i

  it 'adds default values when not provided', ->
    game = new Game

    game.addSprite type: 'carrot'
    sprites = game.filterSprites()
    expect(sprites[0].type).toBe 'carrot'
    expect(sprites[0].x).toBe 0
    expect(sprites[0].y).toBe 0
    expect(sprites[0].angle).toBe 0
    expect(sprites[0].lethal).toBe false
    expect(sprites[0].passable).toBe true
    expect(sprites[0].defunct).toBe false
    expect(sprites[0].uid).toBe 0

  it 'throws error when adding sprite without type', ->
    game = new Game
    expect ->
      game.addSprite {}
    .toThrow()

  it 'calls update once pre adding', ->
    game = new Game

    game.update = jest.genMockFunction()

    game.addSprite type: 'rabbit'
    expect(game.update.mock.calls.length).toBe 1
    game.addSprite type: 'carrot'
    expect(game.update.mock.calls.length).toBe 2


describe 'Game.removeSprite', ->
  it 'removes correct sprite by set defunct to true', ->
    game = new Game
    game.addSprite type: 'carrot'
    game.addSprite type: 'rabbit'

    game.removeSprite 1
    expect(game.filterSprites()[1].defunct).toBe true
    expect(game.filterSprites()[0].defunct).toBe false

  it 'calls update once', ->
    game = new Game
    game.addSprite type: 'carrot'

    game.update = jest.genMockFunction()

    game.removeSprite 0
    expect(game.update.mock.calls.length).toBe 1


describe 'Game.filterSprites', ->
  it 'filter sprites correctly and ordered', ->
    game = new Game
    game.addSprite type: 'carrot', x: 1, y: 1
    game.addSprite type: 'rabbit', x: 1, y: 2
    game.addSprite type: 'carrot', x: 2, y: 3
    game.addSprite type: 'carrot', x: 2, y: 3, defunct: true

    carrots = game.filterSprites type: 'carrot'
    expect(carrots.length).toBe 3
    expect(carrots[0].uid).toBe 0
    expect(carrots[1].uid).toBe 2
    expect(carrots[2].uid).toBe 3

    x1 = game.filterSprites x: 1
    expect(x1.length).toBe 2
    expect(x1[0].uid).toBe 0
    expect(x1[1].uid).toBe 1

    available = game.filterSprites defunct: false
    expect(available.length).toBe 3
    expect(available[0].uid).toBe 0
    expect(available[1].uid).toBe 1
    expect(available[2].uid).toBe 2


describe 'Game.getSprites', ->
  it 'gets correct specified type of sprites', ->
    game = new Game
    game.addSprite type: 'carrot', x: 1, y: 1
    game.addSprite type: 'rabbit', x: 1, y: 2
    game.addSprite type: 'carrot', x: 2, y: 3

    carrots = game.getSprites 'carrot'
    expect(carrots.length).toBe 2
    expect(carrots[0].uid).toBe 0
    expect(carrots[1].uid).toBe 2
    rabbits = game.getSprites 'rabbit'
    expect(rabbits.length).toBe 1
    expect(rabbits[0].uid).toBe 1

  it 'gets all sprites when no type specified', ->
    game = new Game
    game.addSprite type: 'carrot', x: 1, y: 1
    game.addSprite type: 'rabbit', x: 1, y: 2
    game.addSprite type: 'carrot', x: 2, y: 3

    expect(game.getSprites().length).toBe 3


describe 'Game.getRabbit', ->
  it 'gets correct controllable rabbit', ->
    game = new Game
    game.addSprite type: 'carrot', x: 1, y: 1
    game.addSprite type: 'rabbit', x: 1, y: 2
    game.addSprite type: 'carrot', x: 2, y: 3

    rabbit = game.getRabbit()
    expect(rabbit.uid).toBe 1


describe 'Game.loadStage', ->
  it 'loads stages with json and calls addSprite correctly', ->
    game = new Game

    game.addSprite = jest.genMockFunction()

    game.loadStage """[
      {"type": "carrot", "x": 1, "y": 2},
      {"lethal": true}]"""
    spritesToAdd = game.addSprite.mock.calls
    expect(spritesToAdd.length).toBe 2
    expect(spritesToAdd[0][0].type).toBe "carrot"
    expect(spritesToAdd[0][0].x).toBe 1
    expect(spritesToAdd[0][0].y).toBe 2
    expect(spritesToAdd[1][0].type).toBeUndefined()
    expect(spritesToAdd[1][0].lethal).toBe true

  it 'resets carrotGot and scene', ->
    game = new Game
    game.carrotGot = 1234

    game.scene = clear: jest.genMockFunction()

    game.loadStage "[]"
    expect(game.carrotGot).toBe 0
    expect(game.scene.clear).toBeCalled()

  it 'stores current json in stageData', ->
    game = new Game

    json = """[{"type": "rabbit", "_comment": "for_test"}]"""

    game.loadStage json
    expect(game.stageData).toBe json


describe 'Game.restartStage', ->
  it 'calls loadStage to reload stage from stageData', ->
    game = new Game
    json = """[{"type": "rabbit", "_comment": "for_test"}]"""
    game.stageData = json

    game.loadStage = jest.genMockFunction()

    game.restartStage()
    expect(game.loadStage).lastCalledWith json


describe 'Game.register', ->
  it 'store scene in @scene', ->
    game = new Game

    scene = _register: jest.genMockFunction()

    game.register(scene)
    expect(game.scene).toBe scene

  it '_register game to it', ->
    game = new Game

    scene = _register: jest.genMockFunction()

    game.register(scene)
    expect(scene._register).lastCalledWith game


describe 'Game.update', ->
  it 'triggers one update event', ->
    game = new Game

    game.trigger.mockClear()

    game.update 0
    expect(game.trigger.mock.calls.length).toBe 1
    expect(game.trigger).lastCalledWith 'update'

  it 'notifies scene to update with scale and callback', ->
    game = new Game

    game.scene = update: jest.genMockFunction()
    dummyCallback = ->
    game.scene.update.mockImplementation (scale, callback) ->
      expect(scale).toBe 1234
      expect(callback).toBe dummyCallback

    game.update 1234, dummyCallback
    expect(game.scene.update.mock.calls.length).toBe 1

  it 'calls callback when scene not registered', ->
    game = new Game

    dummyCallback = jest.genMockFunction()

    game.update 1234, dummyCallback
    expect(dummyCallback.mock.calls.length).toBe 1


describe 'Game.move', ->
  it 'changes rabbit location based on step', ->
    game = new Game
    game.addSprite type: 'rabbit', x: 0, y: 0, angle: 0

    game.move 1234
    expect(game.getRabbit().x).toBe 0
    expect(game.getRabbit().y).toBe -1234

  it 'changes rabbit location based on step and angle', ->
    game = new Game
    game.addSprite type: 'rabbit', x: 0, y: 0, angle: 45

    game.move 1414.213
    expect(game.getRabbit().x).toBeCloseTo 1000, 0.01
    expect(game.getRabbit().y).toBeCloseTo -1000, 0.01

  it 'calls update once with step', ->
    game = new Game
    game.addSprite type: 'rabbit', x: 0, y: 0, angle: 0

    game.update = jest.genMockFunction()

    for i in [1..2]
      game.move i
      expect(game.update.mock.calls.length).toBe i
      expect(game.update.mock.calls[i-1][0]).toBe i


describe 'Game.turn', ->
  it 'changes rabbit angle based on argument', ->
    game = new Game
    game.addSprite type: 'rabbit', x: 0, y: 0, angle: 0

    game.turn 1000
    expect(game.getRabbit().angle).toBeCloseTo(1000)

  it 'calls update once with angle reduced to be less than 1080', ->
    game = new Game
    game.addSprite type: 'rabbit', x: 0, y: 0, angle: 0

    game.update = jest.genMockFunction()

    checkRange = [-3..3]
    for i in checkRange
      game.turn 1234 * i
      expectedAngle = 1234 * i
      expectedAngle += 360 while expectedAngle < -1080
      expectedAngle -= 360 while expectedAngle > 1080
      expectedTimes = i - checkRange[0] + 1
      expect(game.update.mock.calls.length).toBe expectedTimes
      expect(game.update.mock.calls[expectedTimes-1][0]).toBe expectedAngle


describe 'Game.*actions*', ->
  for action in ['move', 'turn']
    do (action) ->
      it "(#{action}) calls callback after update", ->
        game = new Game
        game.addSprite type: 'rabbit', x: 0, y: 0, angle: 0

        game.update = jest.genMockFunction()
        game.update.mockImplementation (scale, callback) ->
          callback() if callback()?
        callback = jest.genMockFunction()

        game[action] 100, callback
        expect(callback.mock.calls.length).toBe 1


describe 'Game.finish', ->
  it 'triggers one finish event', ->
    game = new Game

    game.trigger.mockClear()

    game.finish()
    expect(game.trigger).toBeCalledWith 'finish'

  it 'triggers one win event but not lost when carrotGot > 0', ->
    game = new Game
    game.carrotGot = 1

    game.trigger.mockClear()

    game.finish()
    expect(game.trigger).toBeCalledWith 'win'
    expect(game.trigger).not.toBeCalledWith 'lost'

  it 'triggers one lost event but not win when carrotGot == 0', ->
    game = new Game
    game.carrotGot = 0

    game.trigger.mockClear()

    game.finish()
    expect(game.trigger).toBeCalledWith 'lost'
    expect(game.trigger).not.toBeCalledWith 'win'
