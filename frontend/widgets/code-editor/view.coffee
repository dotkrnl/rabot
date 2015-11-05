# enable rabot iced highlight
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
        tabSize: 2
      @codebox.setOption \
        'extraKeys',
        Tab: (cm) ->
          spaces = Array(cm.getOption('indentUnit') + 1).join(' ')
          cm.replaceSelection(spaces)
    else
      throw new Error('no textArea inside CodeEditor')

  # Get code from text area
  getCode: ->
    @codebox.getValue()

  insertCode: (code) ->
    @codebox.replaceSelection code

  focus: (code) ->
    @codebox.focus()

module.exports = CodeEditor
