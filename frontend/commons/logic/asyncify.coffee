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
  word = peelFunctionName(word)
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
      if code[j] = '\n'
        break
      j--
    indent = getIndent(j, code) + "  "
    code = code.substr(0, pos+3) + '\n' + indent + \
    code.substr(pos+3, code.length-pos-3)
  return code

# Peels the real function name
peelFunctionName = (word) ->
  realName = ""
  for ch in word
    if ch == '.'
      realName = ""
    else
      realName += ch
  return realName

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
  functionName = peelFunctionName(functionName)
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

# Find functions
scanFunction = (code, functionList) ->
  i = 0
  while i < code.length
    if code[i] == '-' && code[i+1] == '>'
      if !inFunctionList(findFunctionName(i, code), functionList)
        functionList.push(findFunctionName(i, code))
        i = 0
        continue
    i++
  return functionList

# Find functions to asyncify
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

# Add brankets to function calls
addBranketsToFunctions = (code, functionList) ->
  i = 0
  while i < code.length
    if code[i] == '='
      j = i + 1
      while code[j] == ' '
        if code[j+1] == '-' && code[j+2] == '>'
          code = code.substr(0,i+1) + '()' + code.substr(i+1, code.length-i-1)
          break
        j++
    i++

  i = 0
  afterCode = ""
  buffer = ""
  bracketCount = 0
  while i < code.length
    if code[i] == '\n' || code[i] == ';'
      afterCode += buffer
      while bracketCount > 0
        afterCode += ')'
        bracketCount--
      afterCode += code[i]
      buffer = ""
    else if code[i] == '('
      bracketCount++
      buffer += code[i]
    else if code[i] == ')'
      bracketCount--
      buffer += code[i]
    else if isIdentifier(code[i])
      buffer += code[i]
    else if code[i] == ' '
      if inFunctionList(buffer, functionList)
        j = i
        notDefineOrParam = true
        while j < code.length-1 && code[j] != '\n' && code[j] != ';'
          if (code[j] == '-' && code[j+1] == '>') || code[j] == ','
            notDefineOrParam = false
            break
          j++
        if notDefineOrParam
          afterCode += buffer
          afterCode += '('
          bracketCount++
          buffer = ""
        else
          afterCode += buffer
          afterCode += code[i]
          buffer = ""
      else
        afterCode += buffer
        afterCode += code[i]
        buffer = ""
    else
      afterCode += buffer
      afterCode += code[i]
      buffer = ""
    
    i++
  return afterCode

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
processHighlightLine = (code, lineNumber) ->
  firstWord = ""
  for ch in code
    if ch == ' ' || ch == '\t'
      if firstWord != ""
        break
    else
      firstWord += ch
  if inBranchOrLoop(firstWord)
    return code
  indent = getIndent(-1, code)
  i = 0
  while i < code.length
    if code[i] == '-' && code[i+1] == '>'
      j = i + 2
      while j < code.length
        if code[j] == '\n'
          return code
        if code[j] != ' '
          code = ensureLineEnd(i, code)
          break
        j++
      break
    i++
  return indent + "highlight(" + lineNumber + ")\n" + code\
  + indent + "unhighlight(" + lineNumber + ")\n"

processSubfixBranchLoop = (code) ->
  afterCode = ""
  buffer = ""
  for ch in code
    buffer += ch
    if ch == '\n'
      afterCode += processSubfixBranchLoopLine(buffer)
      buffer = ""
  if buffer != ""
    buffer += '\n'
    afterCode += processSubfixBranchLoopLine(buffer)
    buffer = ""
  return afterCode

processSubfixBranchLoopLine = (code) ->
  cutFlag = false
  indent = getIndent(-1,code)
  i = indent.length
  buffer = ""
  while i < code.length
    if code[i] == ' '
      if buffer != ""
        if inBranchOrLoop(buffer) 
          if cutFlag
            i -= buffer.length
            return indent + code.substr(i, code.length - i) + indent + "  " + \
            code.substr(0, i) + '\n'
            break
        else
          cutFlag = true
        buffer = ""
    else
      buffer += code[i]
    i++
  return code
  
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

# Work as main function
# @param code: code to be asyncified
# @param functionList: stores functions needed to be done  
module.exports = (code, asyncFunctionList, functionList) ->
  # Add highlight/unhighlight function calls
  code = processHighlight(code)

  code += '\n'
  
  # add new line to for/while/if subfixes
  code = processSubfixBranchLoop(code)
  
  # Find functions
  functionList = scanFunction(code, functionList)
  
  # Find functions to asyncify, add to functionList
  asyncFunctionList = scanAsyncableFunction(code, asyncFunctionList)
  
  # Add brankets to function calls
  code = addBranketsToFunctions(code, functionList)
  
  # Process user-defined functions
  code = processCallback(code, asyncFunctionList)
  
  # Add "await" & "defer param"
  code = processAwaitDefer(code, asyncFunctionList)

  return code
