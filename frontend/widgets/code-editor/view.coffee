require('./logic/rabot-iced.coffee')()

# a class to setup user friendly code editor
class CodeEditor
  
  # Construct the code editor with CodeMirror
  # @param topDom: the mixin dom provided by template.jade
  constructor: (topDom) ->
    textAreaDom = $(topDom).find('.ce-code-mirror')[0]

    # setup code mirror
    if textAreaDom?
      @codebox = CodeMirror.fromTextArea \
        textAreaDom,
        lineNumbers: true
        mode: 'rabot-iced'
        indentWithTabs: false
    else
      throw new Error('no textArea inside CodeEditor')

  # Get code from text area
  getCode: ->
    @codebox.getValue()


module.exports = CodeEditor
