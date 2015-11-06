(function() {
  this.userInterface = {
    left: -90,
    right: 90,
    move: function(step, callback) {
      var stepX, stepY;
      stepX = step * Math.sin(gameScene.rabbitAngle / 180.0 * Math.PI);
      stepY = step * Math.cos(gameScene.rabbitAngle / 180.0 * Math.PI);
      return gameScene.moveRabbit(stepX, -stepY, 100 * step, callback);
    },
    turn: function(angle, callback) {
      return gameScene.rotateRabbit(angle, 10 * angle, callback);
    }
  };

  this.enableUserInterface = function(gameScene) {
    var key, ref, value;
    this.gameScene = gameScene;
    ref = this.userInterface;
    for (key in ref) {
      value = ref[key];
      this[key] = value;
    }
    return void 0;
  };

  this.executeUserCode = function(jsCode) {
    return eval(jsCode);
  };

  this.disableUerInterface = function() {
    var key, ref, value;
    ref = this.userInterface;
    for (key in ref) {
      value = ref[key];
      this[key] = void 0;
    }
    this.gameScene = void 0;
    return void 0;
  };

  this.userCodeFinished = function() {
    if (this.gameScene.isWin()) {
      alert("You win!");
    } else {
      alert("You lose");
    }
    return disableUerInterface();
  };

}).call(this);
