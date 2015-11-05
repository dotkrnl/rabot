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
  functionList.push("turnTo")
  
  # Fisrt scan, to process user-defined functions
  # Add callback param to param list
  code = code.replace(/\)\s*->/g, ", __rabot_cb_) ->")
  code = code.replace(/\(\s*,/g, "(")
  
  i = 0
  while i < code.length - 1
    if code[i] == '-' && code[i+1] == '>'
      # Add new line after "->" if there's something
      j = i + 2
      flag = false
      while j <= code.length
        if code[j] == '\n'
          break
        if code[j] != ' '
          flag = true
          break
        j++
      if flag
        j = i
        while j >= 0
          if code[j] = '\n' || j == 0
            break
          j--
        indent = getIndent(j, code) + "  "
        code = code.substr(0, i+3) + '\n' + indent + \
        code.substr(i+3, code.length)
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
  
  # @val detected: counter of key function that is found and not done with.
  # @val buffer: code buffer.
  # @val afterCode: return value.
  # @val bracketFlag: true when bracketCount is activated
  # @val bracketCount: used to match brackets. When met '()' +1,
  # when met ')' -1.
  detected = 0
  buffer = ""
  afterCode = ""
  bracketFlag = false
  bracketCount = 0

  # scan thorough the code (by char).
  # if-elseif structure.
  i = 0
  while i < code.length
    # Count brackets
    if detected > 0 && bracketFlag
      if code[i] == '('
        bracketCount++
      if code[i] == ')'
        bracketCount--
        
    #When bracketCount is 0 again
    if detected > 0 && bracketFlag && bracketCount == 0
      bracketFlag = false
      detected--
      emptyParamFlag = true
      j = i
      while j >= 0
        j--
        if code[j] == '('
          break
        if code[j] != ' '
          emptyParamFlag = false
          break
      if emptyParamFlag
        afterCode = afterCode + buffer + "defer param)"    
      else
        afterCode = afterCode + buffer + ", defer param)"    
      buffer = ""
    # When a word is not finished
    else if isIdentifier(code[i])
      buffer += code[i]
    # When \n or ';' is scanned
    else if code[i] == '\n' || code[i] == ';'
      afterCode += buffer
      while detected > 0
        afterCode += ", defer param"
        detected--
      afterCode += code[i]
      buffer = ""
    # When a word has not yet begun
    else if buffer == ""
      afterCode += code[i]
    # When a word is finished...
    # and it is a key function and not announcement
    else if inFunctionList(buffer, functionList)
      j = i
      defineFlag = false
      while j < code.length
        if code[j] == ' ' || code[j] == '\t'
          j++
          continue
        if code[j] != '='
          afterCode = addPrefix(afterCode, buffer, code[i])
          buffer = ""
          detected++
          defineFlag = false
        if code[j] == '='
          afterCode += buffer
          buffer = ""
          defineFlag = true
        break
      if detected > 0 && code[i]=='(' && !defineFlag
        bracketFlag = true
        bracketCount = 1
    # and it is "for" or "if"
    else if inBranchOrLoop(buffer) && detected > 0
      afterCode += ", defer param "
      afterCode += buffer
      afterCode += code[i]
      buffer = ""
      detected--
    # and it is some other word.
    else
      afterCode += buffer
      afterCode += code[i]
      buffer = ""
    
    i++

  return afterCode
