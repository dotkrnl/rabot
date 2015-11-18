# enable rabot iced highlight
require('./logic/rabot-iced.coffee')()

# a class to setup user friendly code editor
class CodeEditor

  # Construct the code editor with CodeMirror
  # @param topDom: the mixin dom provided by template.jade
  constructor: (topDom) ->
    textAreaDom = $(topDom).find('.ce-code-mirror')[0]
    @highlightStack = []

    #This is reserved for automatically generating multiple highlight classes
    @dynamicCss = $("<style>").prop("type", "text/css").appendTo("head")

    # setup code mirror
    if textAreaDom?
      @codebox = CodeMirror.fromTextArea \
        textAreaDom,
        lineNumbers: true
        mode: 'rabot-iced'
        indentWithTabs: false
        styleActiveLine: false
        tabSize: 2
        matchBrackets: true
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

  setCode: (code) ->
    @codebox.setValue(code)

  insertCode: (code) ->
    @codebox.replaceSelection(code)

  focus: (code) ->
    @codebox.focus()

  pushHighlightLine: (lineNumber) ->
    @highlightStack.push(lineNumber)
    @updateHighlightLine()

  popHighlightLine: (lineNumber) ->
    @highlightStack.pop(lineNumber)
    @updateHighlightLine()

  clearHighlightLine: () ->
    @highlightStack = []
    @updateHighlightLine()

  updateHighlightLine: () ->
    rgbBase = [255, 145, 5]
    @dynamicCss.html('')
    cssHtml = ''
    for i in [0..@highlightStack.length-1]
      rgbForLine = []
      for j in [0..2]
        rgbForLine.push(
          Math.round((255 - rgbBase[j])/@highlightStack.length * i + rgbBase[j])
        )
      cssHtml += """
        .__codemirror_highlight_#{i}{
          background: rgb(#{rgbForLine[0]},#{rgbForLine[1]},#{rgbForLine[2]});
        }

      """
    @dynamicCss.html(cssHtml)
    for i in [0..@codebox.lineCount() - 1]
      @codebox.removeLineClass(i, "background")
    for i in [0..@highlightStack.length - 1]
      @codebox.addLineClass(
        @highlightStack[i],
        "background",
        "__codemirror_highlight_" + i
      )


module.exports = CodeEditor
