(function() {
  this.GameScene = (function() {
    function GameScene(dom) {
      this.canvas = Snap(dom);
      this.carrot = this.canvas.circle(300, 50, 20);
      this.carrot.attr({
        fill: '#ff5555',
        stroke: '#000',
        strokeWidth: 5
      });
      this.rabbit = this.canvas.polygon(300, 300, 330, 400, 270, 400);
      this.rabbit.attr({
        fill: '#aaaaff',
        stroke: '#000',
        strokeWidth: 5
      });
      this.rabbitCenter = {
        x: 300,
        y: 370
      };
      this.rabbitOffset = {
        x: 0,
        y: 0
      };
      this.rabbitAngle = 0;
    }

    GameScene.prototype.isVictory = function() {
      var rabbitBoundingBox;
      rabbitBoundingBox = this.rabbit.getBBox();
      return true;
    };

    GameScene.prototype.rabbitTStr = function() {
      return "r" + this.rabbitAngle + "," + this.rabbitCenter.x + "," + this.rabbitCenter.y + " t" + (this.rabbitOffset.x + 0.01) + "," + (this.rabbitOffset.y + 0.01);
    };

    GameScene.prototype.updateRabbitTransform = function(duration, callback) {
      return this.rabbit.animate({
        transform: this.rabbitTStr()
      }, 1000, mina.linear, function() {
        if (callback != null) {
          return callback();
        }
      });
    };

    GameScene.prototype.rotateRabbit = function(angle, duration, callback) {
      this.rabbit.transform(this.rabbitTStr());
      this.rabbitAngle += angle;
      return this.updateRabbitTransform(duration, callback);
    };

    GameScene.prototype.moveRabbit = function(x, y, duration, callback) {
      this.rabbit.transform(this.rabbitTStr());
      this.rabbitOffset.x += x;
      this.rabbitOffset.y += y;
      this.rabbitCenter.x += x;
      this.rabbitCenter.y += y;
      return this.updateRabbitTransform(duration, callback);
    };

    GameScene.prototype.isWin = function() {
      var carrotBBox;
      carrotBBox = this.carrot.getBBox();
      if (this.rabbitCenter.x > carrotBBox.x && this.rabbitCenter.x < carrotBBox.x2 && this.rabbitCenter.y > carrotBBox.y && this.rabbitCenter.y < carrotBBox.y2) {
        return true;
      } else {
        return false;
      }
    };

    return GameScene;

  })();

}).call(this);
