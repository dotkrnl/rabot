@preprocessUserCode = (code) ->
	code += '\n'

	beginning = true
	detected = false
	buffer = ""
	afterCode = ""
	for ch in code
		if (ch >= 'a' && ch <= 'z')||(ch >= 'A' && ch <= 'Z')
			buffer += ch
		else if ch == '\n'
			afterCode += buffer
			if detected
				afterCode += ", defer param"
			else

			afterCode += ch
			buffer = ""
			beginning = true
			detected = false
		else if buffer == ""
			afterCode += ch
		else if beginning && ((buffer == "move") || (buffer == "turn"))
			afterCode += "await "
			afterCode += buffer
			afterCode += ch
			buffer = ""
			beginning = false
			detected = true
		else
			afterCode += "await "
			afterCode += ch
			buffer = ""
	afterCode += "\nuserCodeFinished()\n"
	return afterCode
