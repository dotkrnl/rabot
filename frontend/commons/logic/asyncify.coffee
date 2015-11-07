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

  
# Add new line after "->" if there's something
ensureLineEnd = (pos, code) ->
  if !(code[pos] == '-' && code[pos+1] == '>')
    return code
    
  j = pos + 2
  flag = false
  while j <= code.length
    if code[j] == '\n'
      break
    if code[j] != ' '
      flag = true
      break
    j++
  if flag
    j = pos
    while j >= 0
      if code[j] = '\n' || j == 0
        break
      j--
    indent = getIndent(j, code) + "  "
    code = code.substr(0, pos+3) + '\n' + indent + \
    code.substr(pos+3, code.length)
  return code


# Find function name
findFunctionName = (pos, code) ->
  if !(code[pos] == '-' && code[pos+1] == '>')
    return ""
    
  j = pos
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
  return functionName
  

# Check if the function is asyncable
isAsyncable = (pos, code, functionList) ->
  if !(code[pos] == '-' && code[pos+1] == '>')
    return false
  indent = ""
  buffer = ""
  j = pos
  while code[j] != '\n'
    j++
  indent = getIndent(j, code)
  if indent.length > 0
    while j < code.length - 1
      if isIdentifier(code[j])
        buffer += code[j]
      else
        if inFunctionList(buffer, functionList)
          return true
        buffer = ""
      if code[j] == '\n'
        if indent.length > getIndent(j, code).length
          break
      j++
  return false


scanAsyncableFunction = (code, functionList) ->
  i = 0
  while i < code.length
    if code[i] == '-' && code[i+1] == '>'
      if !inFunctionList(findFunctionName(i, code), functionList)
        if isAsyncable(i, code, functionList)
          functionList.push(findFunctionName(i, code))
          i = 0
          continue
    i++
  return functionList

# Add callback to end of the function
addCallbackAtEnd = (pos, code) ->
  if !(code[pos] == '-' && code[pos+1] == '>')
    return code
  indent = ""
  j = pos
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
          break
      j++
  return code

# Add highlight/unhighlight function calls
processHighlight = (code) ->
  lineNumber = 0
  afterCode = ""
  buffer = ""
  for ch in code
    buffer += ch
    if ch == '\n'
      lineNumber++
      afterCode += processHighlightLine(buffer, lineNumber)
      buffer = ""
  if buffer != ""
    buffer += '\n'
    lineNumber++
    afterCode += processHighlightLine(buffer, lineNumber)
    buffer = ""
  return afterCode

# Add highlight/unhighlight function call for a single line
# Incomplete
processHighlightLine = (code, lineNumber) ->
  indent = ""
  for ch in code
    if ch == ' ' || ch == '\t'
      indent += ch
    else
      break
  return indent + "Highlight(" + lineNumber + ")\n" + code\
  + "Unhighlight(" + lineNumber + ")\n"

# Second scan, to process user-defined functions
processCallback = (code, functionList) ->
  # Add callback param to param list
  code = code.replace(/\)\s*->/g, ", __rabot_cb_) ->")
  code = code.replace(/\(\s*,/g, "(")
  # Scan
  i = 0
  while i < code.length - 1
    if code[i] == '-' && code[i+1] == '>'
      # Add new line after "->" if there's something
      code = ensureLineEnd(i, code)
      # Add callback to end of the function if needed
      if inFunctionList(findFunctionName(i, code), functionList)
        code = addCallbackAtEnd(i, code)
    i++
  return code


# Third scan, add "await" & "defer param"
processAwaitDefer = (code, functionList) ->
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
    # and it is "for" or "if" or "while"
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
  
module.exports = (code) ->
  # Add highlight/unhighlight function calls
  code = processHighlight(code)

  code += '\n'
  
  # @val functionList: stores functions needed to be done
  functionList = ["move", "turn", "turnTo"]
  
  # First scan, find functions to asyncify
  functionList = scanAsyncableFunction(code,functionList)
  
  # Second scan, to process user-defined functions
  code = processCallback(code, functionList)
  
  # Third scan, add "await" & "defer param"
  code = processAwaitDefer(code, functionList)

  return code
