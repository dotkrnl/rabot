jest.dontMock '../md5.coffee'
md5 = require '../md5.coffee'

describe 'md5', ->
  it 'generates correct md5 value for empty', ->
    expect(md5('')).toBe 'd41d8cd98f00b204e9800998ecf8427e'

  it 'generates correct md5 value', ->
    expect(md5('1217')).toBe '6a61d423d02a1c56250dc23ae7ff12f3'
