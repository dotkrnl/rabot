# This function asyncifies user's code.
# That means to add "await", "defer to" before/after certain key functions.
module.exports = (code) ->
  code += '\n'

  # @val detected: true when a key function is found and not done with.
  # @val buffer: code buffer.
  # @val afterCode: return value.
  # @val bracketCounter: used to match brackets. When met '()' +1,
  # when met ')' -1.
  detected = false
  buffer = ""
  afterCode = ""
  bracketCounter = 0

  # scan thorough the code (by char).
  # if-elseif structure.
  for ch in code

    # When a word is not finished
    if (ch >= 'a' && ch <= 'z')||(ch >= 'A' && ch <= 'Z')
      buffer += ch
    # When \n is scanned
    else if ch == '\n'
      afterCode += buffer
      if detected
        afterCode += ", defer param"
      afterCode += ch
      buffer = ""
      detected = false
    # When a word has not yet begun
    else if buffer == ""
      afterCode += ch
    # When a word is finished...
    # and it is a key function
    else if (buffer == "move") || (buffer == "turn")
      afterCode += "await "
      afterCode += buffer
      afterCode += ch
      buffer = ""
      detected = true
    # and it is "for" or "if"
    else if ((buffer == "for") || (buffer == "if")) || (buffer == "while")) && detected
      afterCode += ", defer param "
      afterCode += buffer
      afterCode += ch
      buffer = ""
      detected = false
    # and it is some other word.
    else
      afterCode += buffer
      afterCode += ch
      buffer = ""

  return afterCode
