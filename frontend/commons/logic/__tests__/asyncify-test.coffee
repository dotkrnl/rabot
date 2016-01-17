jest.dontMock '../asyncify.coffee'
asyncify = require '../asyncify.coffee'


describe 'asyncify', ->
  it 'does nothing if nothing', ->
    expect(asyncify('', [], []).trim()).toBe ''

  it 'compiles code', ->
    expect(asyncify('1 + 1', [], []).trim()).toContain '1 + 1'

  it 'asyncifies code', ->
    expect(asyncify('move 1', ['move'], []).trim()).toContain 'await'

  it 'does not asyncify sync code', ->
    expect(asyncify('move 1', [], []).trim()).not.toContain 'await'

  it 'asyncifies when inline if', ->
    expect(asyncify('move 1 if true', ['move'], []).trim())
      .toContain 'await'

  it 'asyncifies when inline for', ->
    expect(asyncify('move 1 for a in [1, 2]', ['move'], []).trim())
      .toContain 'await'

  it 'asyncifies when inline while', ->
    expect(asyncify('move 1 while True', ['move'], []).trim())
      .toContain 'await'

  it 'asyncifies when indented', ->
    expect(asyncify("""
while True
  move 1
  while True
    turn left
      """, ['move'], ['turn']).trim())
      .toContain 'await'

  it 'does not asyncify when user defined sync code', ->
    expect(asyncify("""
sum = (a, b) ->
  return a + b

move sum(1, 2)
      """, [], [])).not.toContain 'await'

  it 'asyncifies when user defined async code', ->
    expect(asyncify("""
forward = (a, b) ->
  move a
  move b

forward 1, 2
      """, ['move'], [])).toContain 'await'

  it 'compiles when inline function', ->
    expect(asyncify("""
sum = (a, b) -> a + b
sum 1, 2
      """, [''], [])).toContain 'sum'

  it 'compiles when there are classes', ->
    expect(asyncify("""
a.b.sum(1, 2)
      """, [''], [])).toContain 'sum'

  it 'compiles when apply equal to sync code', ->
    expect(asyncify("""
sum = (a, b) -> a + b
test = sum 1, 2
      """, [''], [])).toContain 'sum'
  it 'add highlight/unhilight calls', ->
    expect(asyncify("""
f = (a) ->
  move a
f 1
      """)).toContain'highlight'
    expect(asyncify("""
f = (a) ->
  move a
f 1
      """)).toContain'unhighlight'
