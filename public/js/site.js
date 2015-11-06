(function e(t,n,r){function s(o,u){if(!n[o]){if(!t[o]){var a=typeof require=="function"&&require;if(!u&&a)return a(o,!0);if(i)return i(o,!0);var f=new Error("Cannot find module '"+o+"'");throw f.code="MODULE_NOT_FOUND",f}var l=n[o]={exports:{}};t[o][0].call(l.exports,function(e){var n=t[o][1][e];return s(n?n:e)},l,l.exports,e,t,n,r)}return n[o].exports}var i=typeof require=="function"&&require;for(var o=0;o<r.length;o++)s(r[o]);return s})({1:[function(require,module,exports){
var Game, GameScene, UserWorker;

Game = require('./models/game.coffee');

GameScene = require('./views/gamescene.coffee');

UserWorker = require('./worker/worker.coffee');

$(function() {
  var editorCodeMirror, game, gameScene, updateLayout, userWorker;
  editorCodeMirror = CodeMirror.fromTextArea(document.getElementById('code-editor'), {
    lineNumbers: true
  });
  updateLayout = function() {
    editorCodeMirror.setSize($('#container-code-editor').width(), $('#container-code-editor').height());
    $('#play-canvas').width($('#container-play').width());
    return $('#play-canvas').height($('#container-play').height());
  };
  updateLayout();
  $(window).resize(updateLayout);
  game = new Game;
  gameScene = new GameScene("#play-canvas");
  game.register(gameScene);
  userWorker = null;
  game.on('win', function() {
    return $('#status').text('Win');
  });
  game.on('lost', function() {
    return $('#status').text('Lost');
  });
  game.on('finish', function() {
    if (userWorker != null) {
      userWorker.terminate();
    }
    return userWorker = null;
  });
  $('#button-run-code').click(function() {
    var code;
    code = editorCodeMirror.getValue();
    return userWorker = new UserWorker(game, code);
  });
  return $('#button-stop-code').click(function() {
    return game.finish();
  });
});


},{"./models/game.coffee":2,"./views/gamescene.coffee":4,"./worker/worker.coffee":6}],2:[function(require,module,exports){
var Emitter, Game, toRad,
  extend = function(child, parent) { for (var key in parent) { if (hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; },
  hasProp = {}.hasOwnProperty;

Emitter = require('../utils/emitter.coffee');

toRad = function(degrees) {
  return degrees * Math.PI / 180.0;
};

Game = (function(superClass) {
  extend(Game, superClass);

  function Game() {
    this.units = {};
    this.nextUnitId = 0;
    this.scene = null;
    this.loadStage();
    Game.__super__.constructor.call(this);
  }

  Game.prototype.addUnit = function(unit) {
    var parsedUnit;
    if (this.units[unit.Type] == null) {
      this.units[unit.Type] = [];
    }
    parsedUnit = {
      x: parseInt(unit.Position[0]),
      y: parseInt(unit.Position[1]),
      angle: unit.angle != null ? parseInt(unit.angle) : 0,
      id: this.nextUnitId
    };
    this.nextUnitId++;
    return this.units[unit.Type].push(parsedUnit);
  };

  Game.prototype.loadStage = function() {
    var i, len, results, sceneObj, unit;
    sceneObj = [
      {
        "Type": "Rabbit",
        "Position": ["300", "370"],
        "Angle": "0"
      }, {
        "Type": "Carrot",
        "Passable": "true",
        "Lethal": "false",
        "Position": ["300", "50"]
      }, {
        "Type": "Carrot",
        "Passable": "true",
        "Lethal": "false",
        "Position": ["300", "180"]
      }
    ];
    results = [];
    for (i = 0, len = sceneObj.length; i < len; i++) {
      unit = sceneObj[i];
      results.push(this.addUnit(unit));
    }
    return results;
  };

  Game.prototype.register = function(gameScene) {
    this.scene = gameScene;
    return this.scene._register(this);
  };

  Game.prototype.update = function(scale, callback) {
    this.trigger('update');
    if (this.scene != null) {
      this.scene.update(scale, callback);
    } else {
      if (callback != null) {
        callback();
      }
    }
  };

  Game.prototype.move = function(step, callback) {
    var rabbit;
    rabbit = this.units.Rabbit[0];
    rabbit.x += step * Math.sin(toRad(rabbit.angle));
    rabbit.y -= step * Math.cos(toRad(rabbit.angle));
    this.update(step, callback);
  };

  Game.prototype.turn = function(angle, callback) {
    var rabbit;
    rabbit = this.units.Rabbit[0];
    rabbit.angle += angle;
    this.update(angle, callback);
  };

  Game.prototype.finish = function() {
    var carrot, i, len, rabbit, ref, victory;
    victory = false;
    rabbit = this.units.Rabbit[0];
    ref = this.units.Carrot;
    for (i = 0, len = ref.length; i < len; i++) {
      carrot = ref[i];
      if (this.scene.collided(rabbit, carrot)) {
        victory = true;
        break;
      }
    }
    if (victory) {
      this.trigger('win');
    } else {
      this.trigger('lost');
    }
    this.trigger('finish');
  };

  return Game;

})(Emitter);

module.exports = Game;


},{"../utils/emitter.coffee":3}],3:[function(require,module,exports){
var Emitter;

Emitter = (function() {
  function Emitter() {
    this.cbs = {};
  }

  Emitter.prototype.on = function(names, cb) {
    var i, len, name;
    names = names.split(' ');
    for (i = 0, len = names.length; i < len; i++) {
      name = names[i];
      if (this.cbs[name] == null) {
        this.cbs[name] = $.Callbacks('memory unique');
      }
      this.cbs[name].add(cb);
    }
  };

  Emitter.prototype.off = function(names, cb) {
    var i, len, name;
    names = names.split(' ');
    for (i = 0, len = names.length; i < len; i++) {
      name = names[i];
      if (this.cbs[name] != null) {
        this.cbs[name].remove(cb);
      }
    }
  };

  Emitter.prototype.trigger = function(names) {
    var i, len, name;
    names = names.split(' ');
    for (i = 0, len = names.length; i < len; i++) {
      name = names[i];
      if (this.cbs[name] != null) {
        this.cbs[name].fire(Array.prototype.slice.call(arguments, 1));
      }
    }
  };

  return Emitter;

})();

module.exports = Emitter;


},{}],4:[function(require,module,exports){
var GameScene, scaleToTime;

scaleToTime = function(scale) {
  return Math.abs(scale * 5);
};

GameScene = (function() {
  function GameScene(canvas_dom) {
    this.canvas = Snap(canvas_dom);
    this.game = null;
    this.unitElems = [];
  }

  GameScene.prototype.getElementByUnit = function(unit) {
    var i, len, ref, unitElem;
    ref = this.unitElems;
    for (i = 0, len = ref.length; i < len; i++) {
      unitElem = ref[i];
      if (unitElem.unit === unit) {
        return unitElem.element;
      }
    }
    return void 0;
  };

  GameScene.prototype._register = function(game) {
    var carrot, carrotElem, i, j, len, len1, rabbit, rabbitElem, ref, ref1;
    this.game = game;
    ref = this.game.units.Rabbit;
    for (i = 0, len = ref.length; i < len; i++) {
      rabbit = ref[i];
      rabbitElem = this.canvas.polygon(0, -70, 30, 30, -30, 30);
      rabbitElem.attr({
        fill: '#aaaaff',
        stroke: '#000',
        strokeWidth: 5
      });
      this.unitElems.push({
        unit: rabbit,
        element: rabbitElem
      });
    }
    ref1 = this.game.units.Carrot;
    for (j = 0, len1 = ref1.length; j < len1; j++) {
      carrot = ref1[j];
      carrotElem = this.canvas.circle(0, 0, 20);
      carrotElem.attr({
        fill: '#ff5555',
        stroke: '#000',
        strokeWidth: 5
      });
      this.unitElems.push({
        unit: carrot,
        element: carrotElem
      });
    }
    this.update(0);
  };

  GameScene.prototype.update = function(scale, callback) {
    var done_count, finished_one, i, len, ref, unitElem;
    if (this.game != null) {
      done_count = 0;
      finished_one = function() {
        console.log(done_count);
        done_count += 1;
        if (done_count === this.unitElems.length) {
          if (callback != null) {
            return callback();
          }
        }
      };
      ref = this.unitElems;
      for (i = 0, len = ref.length; i < len; i++) {
        unitElem = ref[i];
        unitElem.element.animate({
          transform: this.tStrFor(unitElem.unit)
        }, scaleToTime(scale), mina.linear, finished_one.bind(this));
      }
    } else {
      if (callback != null) {
        callback();
      }
    }
  };

  GameScene.prototype.collided = function(unit1, unit2) {
    var box1, box2;
    box1 = this.getElementByUnit(unit1).getBBox();
    box2 = this.getElementByUnit(unit2).getBBox();
    return !(box1.x > box2.x2 || box1.x2 < box2.x || box1.y > box2.y2 || box1.y2 < box2.y);
  };

  GameScene.prototype.tStrFor = function(info) {
    return "t" + info.x + "," + info.y + "r" + info.angle + ",0,0";
  };

  return GameScene;

})();

module.exports = GameScene;


},{}],5:[function(require,module,exports){
module.exports = function(code) {
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
    } else if (detected && (ch === ')')) {
      afterCode += buffer;
      buffer = "";
      afterCode += ", defer param";
      afterCode += ch;
      detected = false;
    } else if (ch === '\n') {
      afterCode += buffer;
      if (detected) {
        afterCode += ", defer param";
      }
      afterCode += ch;
      buffer = "";
      beginning = true;
      detected = false;
    } else if (buffer === "") {
      afterCode += ch;
    } else if ((buffer === "move") || (buffer === "turn")) {
      afterCode += "await ";
      afterCode += buffer;
      afterCode += ch;
      buffer = "";
      detected = true;
    } else if (((buffer === "for") || (buffer === "if")) && detected) {
      afterCode += ", defer param ";
      afterCode += buffer;
      afterCode += ch;
      buffer = "";
      detected = false;
    } else {
      afterCode += buffer;
      afterCode += ch;
      buffer = "";
    }
  }
  return afterCode;
};


},{}],6:[function(require,module,exports){
var UserCodeWorker, asyncify;

asyncify = require('./asyncify.coffee');

UserCodeWorker = (function() {
  function UserCodeWorker(game, code) {
    var asyncCode, blob, jsCode;
    this.game = game;
    this.code = code;
    asyncCode = asyncify(this.code);
    jsCode = CoffeeScript.compile(this.USERSPACE_API + asyncCode + this.USERSPACE_END, {
      runtime: "inline"
    });
    blob = new Blob([jsCode], {
      type: "text/javascript"
    });
    this.worker = new Worker(window.URL.createObjectURL(blob));
    this.worker.onmessage = this.onmessage.bind(this);
  }

  UserCodeWorker.prototype.onmessage = function(m) {
    if (m != null) {
      m = m.data;
    }
    if ((m == null) || (m.action == null)) {
      return;
    }
    switch (m.action) {
      case "move":
        return this.game.move(m.step, this.resume.bind(this));
      case "turn":
        return this.game.turn(m.angle, this.resume.bind(this));
      case "finish":
        return this.game.finish();
    }
  };

  UserCodeWorker.prototype.resume = function() {
    return this.worker.postMessage({
      action: 'resume'
    });
  };

  UserCodeWorker.prototype.terminate = function() {
    return this.worker.terminate();
  };

  UserCodeWorker.prototype.USERSPACE_API = "left = -90\nright = 90\n\n__rabot_nop = ->\n\n__rabot_resume = __rabot_nop\n\nmove = (step, callback) ->\n  __rabot_resume = ->\n    __rabot_resume = __rabot_nop\n    callback()\n  @postMessage\n    action: 'move'\n    step: step\n\nturn = (angle, callback) ->\n  __rabot_resume = ->\n    __rabot_resume = __rabot_nop\n    callback()\n  @postMessage\n    action: 'turn'\n    angle: angle\n\n__rabot_finished = ->\n  @postMessage\n    action: 'finish'\n\n@onmessage = (e) ->\n  e = e.data if e?\n  if e? and e.action? and e.action == 'resume'\n    __rabot_resume()\n";

  UserCodeWorker.prototype.USERSPACE_END = "\n__rabot_finished()\n";

  return UserCodeWorker;

})();

module.exports = UserCodeWorker;


},{"./asyncify.coffee":5}]},{},[1]);
