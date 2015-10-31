# This function asyncifies user's code.
# That means to add "await", "defer to" before/after certain key functions,
# and user-defined functions.
# Plus, it adds callback param & callback to user-defined functions.

addPrefix = (afterCode, buffer, ch) ->
  afterCode += "await "
  afterCode += buffer
  afterCode += ch
  return afterCode

inFunctionList = (word, functionList) ->
  for str in functionList
    if word == str
      return true
  return false

isIdentifier = (char) ->
  return (char >= 'a' && char <= 'z')||(char >= 'A' && char <= 'Z')\
  || (char == '_') || (char >= '0' && char <= '9')

inBranchOrLoop = (word) ->
  return (word == "for") || (word == "if") || (word == "while")

getIndent = (pos, code) ->
  if code[pos] != '\n'
    return ""
  indent = ""
  pos++
  while pos < code.length - 1 && (code[pos] == '\t' || code[pos] == ' ')
    indent += code[pos]
    pos++
  return indent

module.exports = (code) ->
  code += '\n'
  
  # @val functionList: stores functions needed to be done
  functionList = new Array()
  functionList.push("move")
  functionList.push("turn")
  
  # Fisrt scan, to process user-defined functions
  # Add callback param to param list
  code = code.replace(/\)\s*->/, ", __rabot_cb_) ->")
  code = code.replace(/\(\s*,/, "(")
  
  i = 0
  while i < code.length - 1
    if code[i] == '-' && code[i+1] == '>'
      # Find & add function name to functionList
      j = i
      nameFound = false
      functionName = ""
      while j >= 0
        if nameFound
          if isIdentifier(code[j])
            functionName = code[j] + functionName
          else
            if functionName == ""
            
            else
              break
        else
          if code[j] == '='
            nameFound = true
          else
        
        j--
      
      if functionName.length > 0
        functionList.push(functionName)

      # Add callback to end of the function
      indent = ""
      j = i
      while code[j] != '\n'
        j++
      indent = getIndent(j, code)
      if indent.length > 0
        while j < code.length - 1
          if code[j] == '\n'
            if indent.length > getIndent(j, code).length
              code2 = code.substr(0, j+1) + indent + "__rabot_cb_()\n"\
              + code.substr(j+1, code.length)
              code = code2
              i += indent.length
              i += 14
              break
          j++
    
    i++
    
  
  
  # Second scan
  
  # @val detected: true when a key function is found and not done with.
  # @val buffer: code buffer.
  # @val afterCode: return value.
  # @val bracketCounter: used to match brackets. When met '()' +1,
  # when met ')' -1.
  detected = false
  buffer = ""
  afterCode = ""

  # scan thorough the code (by char).
  # if-elseif structure.
  for ch in code

    # When a word is not finished
    if isIdentifier(ch)
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
    else if inFunctionList(buffer, functionList)
      afterCode = addPrefix(afterCode, buffer, ch)
      buffer = ""
      detected = true
    # and it is "for" or "if"
    else if inBranchOrLoop(buffer) && detected
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
