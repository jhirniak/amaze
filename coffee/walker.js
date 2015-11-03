// Generated by CoffeeScript 1.10.0
(function() {
  var createArray, flipper, walkerManager;

  flipper = function() {
    var counter, flip, index;
    counter = 0;
    index = 0;
    flip = function() {
      if (!(++counter % Constant.TO_FLIP)) {
        counter = 0;
        if (!(++index % Constant.FLIP_COLORS.length)) {
          index = 0;
        }
      }
      return Constant.FLIP_COLORS[index];
    };
    return flip;
  };

  walkerManager = function(context, maze) {
    this.context = context;
    this.maze = maze;
    this.x = maze.start.x;
    this.y = maze.start.y;
    this.lastX = -1;
    this.lastY = -1;
    this.visited = createArray(maze.width, maze.height);
    this.cursor_color = flipper();
    this.init = function() {
      var j, k, ref, ref1, x, y;
      for (x = j = 0, ref = this.maze.width - 1; 0 <= ref ? j <= ref : j >= ref; x = 0 <= ref ? ++j : --j) {
        for (y = k = 0, ref1 = this.maze.height - 1; 0 <= ref1 ? k <= ref1 : k >= ref1; y = 0 <= ref1 ? ++k : --k) {
          this.visited[x][y] = 0;
        }
      }
      this.visited[this.x][this.y] = 1;
      return this.draw();
    };
    this.draw = function() {
      this.context.fillStyle = this.cursor_color();
      return this.context.fillRect(this.x * Constant.SQUARE, this.y * Constant.SQUARE, Constant.SQUARE, Constant.SQUARE);
    };
    this.move = function(direction, backtrack) {
      var changed, oldX, oldY, point;
      changed = false;
      oldX = this.x;
      oldY = this.y;
      if (backtrack || !this.hasVisited(direction)) {
        point = this.getXYForDirection(direction);
        if (this.canMove(point.x, point.y)) {
          this.x = point.x;
          this.y = point.y;
          changed = true;
        }
      }
      if (changed) {
        this.context.fillStyle = backtrack ? Constant.BACKTRACK_COLOR : Constant.PATH_COLOR;
        this.context.fillRect(oldX * Constant.SQUARE, oldY * Constant.SQUARE, Constant.SQUARE, Constant.SQUARE);
        this.lastX = oldX;
        this.lastY = oldY;
        this.visited[this.x][this.y]++;
        if (backtrack) {
          this.visited[this.lastX][this.lastY] = 2;
        }
        if (this.visited[oldX][oldY] === 2 && this.visited[this.x][this.y] === 1) {
          this.visited[oldX][oldY] = 1;
          this.context.fillStyle = Constant.CROSSROAD_COLOR;
          this.context.fillRect(oldX * Constant.SQUARE, oldY * Constant.SQUARE, Constant.SQUARE, Constant.SQUARE);
        }
      }
      return changed;
    };
    this.canMove = function(x, y) {
      return this.maze.isOpen(x, y) && this.visited[x][y] < 2;
    };
    this.hasVisited = function(direction) {
      var point;
      point = this.getXYForDirection(direction);
      return this.visited[point.x][point.y] > 0;
    };
    this.getXYForDirection = function(direction) {
      var point;
      point = {};
      switch (direction) {
        case 0:
          point.x = this.x;
          point.y = this.y - 1;
          break;
        case 1:
          point.x = this.x + 1;
          point.y = this.y;
          break;
        case 2:
          point.x = this.x;
          point.y = this.y + 1;
          break;
        case 3:
          point.x = this.x - 1;
          point.y = this.y;
      }
      return point;
    };
    return this;
  };

  createArray = function(length) {
    var args, arr, i;
    arr = new Array(length || 0);
    i = length;
    if (arguments.length > 1) {
      args = Array.prototype.slice.call(arguments, 1);
      while (i--) {
        arr[length - 1 - i] = createArray.apply(this, args);
      }
    }
    return arr;
  };

  this.window.walkerManager = walkerManager;

}).call(this);

//# sourceMappingURL=walker.js.map