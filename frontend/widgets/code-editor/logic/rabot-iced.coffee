# CodeMirror, copyright (c) by Marijn Haverbeke and others
# Distributed under an MIT license: http://codemirror.net/LICENSE
# Edited by Rabot project

module.exports = () ->
  "use strict"

  CodeMirror.defineMode "rabot-iced", (conf, parserConf) ->
    wordRegexp = (words) ->
      new RegExp("^((" + words.join(")|(") + "))\\b")

    # Tokenizers
    tokenBase = (stream, state) ->

      # Handle scope changes
      if stream.sol()
        state.scope.align = false  if state.scope.align is null
        scopeOffset = state.scope.offset
        if stream.eatSpace()
          lineOffset = stream.indentation()
          if lineOffset > scopeOffset and state.scope.type is "rabot-iced"
            return "indent"
          else return "dedent"  if lineOffset < scopeOffset
          return null
        else
          dedent stream, state  if scopeOffset > 0
      return null  if stream.eatSpace()
      ch = stream.peek()

      # Handle docco title comment (single line)
      if stream.match("####")
        stream.skipToEnd()
        return "comment"

      # Handle multi line comments
      if stream.match("###")
        state.tokenize = longComment
        return state.tokenize(stream, state)

      # Single line comment
      if ch is "#"
        stream.skipToEnd()
        return "comment"

      # Handle number literals
      if stream.match(/^-?[0-9\.]/, false)
        floatLiteral = false

        # Floats
        floatLiteral = true  if stream.match(/^-?\d*\.\d+(e[\+\-]?\d+)?/i)
        floatLiteral = true  if stream.match(/^-?\d+\.\d*/)
        floatLiteral = true  if stream.match(/^-?\.\d+/)
        if floatLiteral

          # prevent from getting extra . on 1..
          stream.backUp 1  if stream.peek() is "."
          return "number"

        # Integers
        intLiteral = false

        # Hex
        intLiteral = true  if stream.match(/^-?0x[0-9a-f]+/i)

        # Decimal
        intLiteral = true  if stream.match(/^-?[1-9]\d*(e[\+\-]?\d+)?/)

        # Zero by itself with no other piece of number.
        intLiteral = true  if stream.match(/^-?0(?![\dx])/i)
        return "number"  if intLiteral

      # Handle strings
      if stream.match(stringPrefixes)
        state.tokenize = tokenFactory(stream.current(), false, "string")
        return state.tokenize(stream, state)

      # Handle regex literals
      if stream.match(regexPrefixes)
        if stream.current() isnt "/" or stream.match(/^.*\//, false) # prevent highlight of division
          state.tokenize = tokenFactory(stream.current(), true, "string-2")
          return state.tokenize(stream, state)
        else
          stream.backUp 1

      # Handle operators and delimiters
      return "operator"  if stream.match(operators) or stream.match(wordOperators)
      return "punctuation"  if stream.match(delimiters)
      return "atom"  if stream.match(constants)
      return "property"  if stream.match(atProp) or state.prop and stream.match(identifiers)
      return "keyword"  if stream.match(keywords)
      return "variable"  if stream.match(identifiers)

      # Handle non-detected items
      stream.next()
      ERRORCLASS
    tokenFactory = (delimiter, singleline, outclass) ->
      (stream, state) ->
        until stream.eol()
          stream.eatWhile /[^'"\/\\]/
          if stream.eat("\\")
            stream.next()
            return outclass  if singleline and stream.eol()
          else if stream.match(delimiter)
            state.tokenize = tokenBase
            return outclass
          else
            stream.eat /['"\/]/
        if singleline
          if parserConf.singleLineStringErrors
            outclass = ERRORCLASS
          else
            state.tokenize = tokenBase
        outclass
    longComment = (stream, state) ->
      until stream.eol()
        stream.eatWhile /[^#]/
        if stream.match("###")
          state.tokenize = tokenBase
          break
        stream.eatWhile "#"
      "comment"
    indent = (stream, state, type) ->
      type = type or "rabot-iced"
      offset = 0
      align = false
      alignOffset = null
      scope = state.scope

      while scope
        if scope.type is "rabot-iced" or scope.type is "}"
          offset = scope.offset + conf.indentUnit
          break
        scope = scope.prev
      if type isnt "rabot-iced"
        align = null
        alignOffset = stream.column() + stream.current().length
      else state.scope.align = false  if state.scope.align
      state.scope =
        offset: offset
        type: type
        prev: state.scope
        align: align
        alignOffset: alignOffset
    dedent = (stream, state) ->
      return  unless state.scope.prev
      if state.scope.type is "rabot-iced"
        _indent = stream.indentation()
        matched = false
        scope = state.scope

        while scope
          if _indent is scope.offset
            matched = true
            break
          scope = scope.prev
        return true  unless matched
        state.scope = state.scope.prev  while state.scope.prev and state.scope.offset isnt _indent
        false
      else
        state.scope = state.scope.prev
        false
    tokenLexer = (stream, state) ->
      style = state.tokenize(stream, state)
      current = stream.current()

      # Handle "." connected identifiers
      if false and current is "."
        style = state.tokenize(stream, state)
        current = stream.current()
        if /^\.[\w$]+$/.test(current)
          return "variable"
        else
          return ERRORCLASS

      # Handle scope changes.
      state.dedent = true  if current is "return"
      indent stream, state  if ((current is "->" or current is "=>") and stream.eol()) or style is "indent"
      delimiter_index = "[({".indexOf(current)
      indent stream, state, "])}".slice(delimiter_index, delimiter_index + 1)  if delimiter_index isnt -1
      indent stream, state  if indentKeywords.exec(current)
      dedent stream, state  if current is "then"
      return ERRORCLASS  if dedent(stream, state)  if style is "dedent"
      delimiter_index = "])}".indexOf(current)
      if delimiter_index isnt -1
        state.scope = state.scope.prev  while state.scope.type is "rabot-iced" and state.scope.prev
        state.scope = state.scope.prev  if state.scope.type is current
      if state.dedent and stream.eol()
        state.scope = state.scope.prev  if state.scope.type is "rabot-iced" and state.scope.prev
        state.dedent = false
      style
    ERRORCLASS = "error"
    operators = /^(?:->|=>|\+[+=]?|-[\-=]?|\*[\*=]?|\/[\/=]?|[=!]=|<[><]?=?|>>?=?|%=?|&=?|\|=?|\^=?|\~|!|\?|(or|and|\|\||&&|\?)=)/
    delimiters = /^(?:[()\[\]{},:`=;]|\.\.?\.?)/
    identifiers = /^[_A-Za-z$][_A-Za-z$0-9]*/
    atProp = /^@[_A-Za-z$][_A-Za-z$0-9]*/
    wordOperators = wordRegexp([ "and", "or", "not", "is", "isnt", "in", "instanceof", "typeof" ])
    indentKeywords = [ "for", "while", "loop", "if", "unless", "else", "switch", "try", "catch", "finally", "class" ]
    commonKeywords = [ "break", "by", "continue", "debugger", "delete", "do", "in", "of", "new", "return", "then", "this", "@", "throw", "when", "until", "extends", "await", "defer", "move", "turn", "turnTo", "distance" ]
    keywords = wordRegexp(indentKeywords.concat(commonKeywords))
    indentKeywords = wordRegexp(indentKeywords)
    stringPrefixes = /^('{3}|\"{3}|['\"])/
    regexPrefixes = /^(\/{3}|\/)/
    commonConstants = [ "Infinity", "NaN", "undefined", "null", "true", "false", "on", "off", "yes", "no", "left", "right" ]
    constants = wordRegexp(commonConstants)
    external =
      startState: (basecolumn) ->
        tokenize: tokenBase
        scope:
          offset: basecolumn or 0
          type: "rabot-iced"
          prev: null
          align: false

        prop: false
        dedent: 0

      token: (stream, state) ->
        fillAlign = state.scope.align is null and state.scope
        fillAlign.align = false  if fillAlign and stream.sol()
        style = tokenLexer(stream, state)
        if style and style isnt "comment"
          fillAlign.align = true  if fillAlign
          state.prop = style is "punctuation" and stream.current() is "."
        style

      indent: (state, text) ->
        return 0  unless state.tokenize is tokenBase
        scope = state.scope
        closer = text and "])}".indexOf(text.charAt(0)) > -1
        scope = scope.prev  while scope.type is "rabot-iced" and scope.prev  if closer
        closes = closer and scope.type is text.charAt(0)
        if scope.align
          scope.alignOffset - ((if closes then 1 else 0))
        else
          ((if closes then scope.prev else scope)).offset

      lineComment: "#"
      fold: "indent"

    external

  CodeMirror.defineMIME "text/x-rabot-iced", "rabot-iced"
  CodeMirror.defineMIME "text/rabot-iced", "rabot-iced"
