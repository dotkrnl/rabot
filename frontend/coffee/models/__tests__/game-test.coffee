jest.dontMock '../game.coffee'

describe 'Game', ->
  Game = require '../game.coffee'

  it 'constructs with no scene nor error', ->
    game = new Game
    expect(game).toBeDefined()
    expect(game.scene).toBeNull()

  it 'adds cloned sprites using addSprite', ->
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

  it 'adds default values when not provided using addSprite', ->
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

  it 'triggers emitter update when adding sprite', ->
    game = new Game
    game.trigger.mockClear()
    game.addSprite type: 'rabbit'
    expect(game.trigger.mock.calls.length).toBe 1
    expect(game.trigger.mock.calls[0][0]).toBe 'update'
    game.addSprite type: 'carrot'
    expect(game.trigger.mock.calls.length).toBe 2
    expect(game.trigger.mock.calls[1][0]).toBe 'update'

  it 'removes correct sprite by set defunct to true', ->
    game = new Game
    game.addSprite type: 'carrot'
    game.addSprite type: 'rabbit'
    game.removeSprite 1
    expect(game.filterSprites()[1].defunct).toBe true
    expect(game.filterSprites()[0].defunct).toBe false

  it 'triggers emitter update when removing sprite', ->
    game = new Game
    game.addSprite type: 'carrot'
    game.trigger.mockClear()
    game.removeSprite 0
    expect(game.trigger.mock.calls.length).toBe 1
    expect(game.trigger.mock.calls[0][0]).toBe 'update'

  it 'filter sprites correctly and ordered', ->
    game = new Game
    game.addSprite type: 'carrot', x: 1, y: 1
    game.addSprite type: 'rabbit', x: 1, y: 2
    game.addSprite type: 'carrot', x: 2, y: 3

    rabbits = game.filterSprites(type: 'carrot')
    expect(rabbits.length).toBe 2
    expect(rabbits[0].uid).toBe 0
    expect(rabbits[1].uid).toBe 2

    x1 = game.filterSprites(x: 1)
    expect(x1.length).toBe 2
    expect(x1[0].uid).toBe 0
    expect(x1[1].uid).toBe 1

    game.removeSprite 0
    available = game.filterSprites(defunct: false)
    expect(available.length).toBe 2
    expect(available[0].uid).toBe 1
    expect(available[1].uid).toBe 2

