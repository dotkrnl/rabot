jest.dontMock '../bootstrap.coffee'
bootstrap = require '../bootstrap.coffee'

window.$ = (fn) ->
  fn() if typeof fn == 'function'
  if fn == 'nothing'
    return []
  else
    return ['item1', 'item2']


describe 'bootstrap', ->
  it 'does nothing if nothing', ->
    class cl
      @AUTO_CONFIGURE_SELECTOR = 'nothing'
      @tester = jest.genMockFunction()
      constructor: (item) ->
        cl.tester(item)
    bootstrap(cl)
    expect(window.apps).toBeUndefined()

  it 'constructs apps', ->
    class cl
      @AUTO_CONFIGURE_SELECTOR = 'test'
      @tester = jest.genMockFunction()
      constructor: (item) ->
        cl.tester(item)
    bootstrap(cl)
    expect(window.apps).toBeDefined()
    expect(cl.tester).toBeCalledWith 'item1'
    expect(cl.tester).toBeCalledWith 'item2'
