# a class to setup user friendly code editor
class CodeEditor
  
  # Construct the code editor with CodeMirror
  # @param topDom: the mixin dom provided by template.jade
  constructor: (topDom) ->
    textAreaDom = $(topDom).find(".ce-code-mirror")[0]

    # setup code mirror
    if textAreaDom?
      CodeMirror.fromTextArea textAreaDom, lineNumbers: true
    else
      throw new Error('no textArea inside CodeEditor')


module.exports = CodeEditor
