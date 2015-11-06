(function() {
  this.preprocessUserCode = function(code) {
    var afterCode, beginning, buffer, ch, detected, i, len;
    code += '\n';
    beginning = true;
    detected = false;
    buffer = "";
    afterCode = "";
    for (i = 0, len = code.length; i < len; i++) {
      ch = code[i];
      if ((ch >= 'a' && ch <= 'z') || (ch >= 'A' && ch <= 'Z')) {
        buffer += ch;
      } else if (ch === '\n') {
        afterCode += buffer;
        if (detected) {
          afterCode += ", defer param";
        } else {

        }
        afterCode += ch;
        buffer = "";
        beginning = true;
        detected = false;
      } else if (buffer === "") {
        afterCode += ch;
      } else if (beginning && ((buffer === "move") || (buffer === "turn"))) {
        afterCode += "await ";
        afterCode += buffer;
        afterCode += ch;
        buffer = "";
        beginning = false;
        detected = true;
      } else {
        afterCode += "await ";
        afterCode += ch;
        buffer = "";
      }
    }
    afterCode += "\nuserCodeFinished()\n";
    return afterCode;
  };

}).call(this);
