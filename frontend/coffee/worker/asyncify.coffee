module.exports = (code) ->
	code += '\n'

	beginning = true
	detected = false
	buffer = ""
	afterCode = ""

	for ch in code
		# 单词未结束
		if (ch >= 'a' && ch <= 'z')||(ch >= 'A' && ch <= 'Z')
			buffer += ch
		else if detected && (ch == ')')
			afterCode += buffer
			buffer = ""
			afterCode += ", defer param"
			afterCode +=  ch
			detected = false
		# 换行
		else if ch == '\n'
			afterCode += buffer
			if detected
				afterCode += ", defer param"
			afterCode += ch
			buffer = ""
			beginning = true
			detected = false
		# 单词未开始
		else if buffer == ""
			afterCode += ch
		# 以下全部为单词结束
		# 检测到保留函数
		else if (buffer == "move") || (buffer == "turn")
			afterCode += "await "
			afterCode += buffer
			afterCode += ch
			buffer = ""
			detected = true
		# 检测到for, if
		else if ((buffer == "for") || (buffer == "if")) && detected
			afterCode += ", defer param "
			afterCode += buffer
			afterCode += ch
			buffer = ""
			detected = false
		# 其他的单词
		else
			afterCode += buffer
			afterCode += ch
			buffer = ""

	return afterCode
