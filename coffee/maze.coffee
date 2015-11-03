MazeManager = (context, maze) ->
	this.context = context
	this.width = maze.width
	this.height = maze.height
	this.start = maze.start
	this.end = maze.end
	this.maze = maze.map

MazeManager.prototype.draw = ->
  for y in [0..this.height-1]
    for x in [0..this.width-1]
      if this.isWall(x, y)
        this.context.fillStyle = Constant.WALL_COLOR;
        this.context.fillRect(x * Constant.SQUARE, y * Constant.SQUARE, Constant.SQUARE, Constant.SQUARE)
      else if this.isInside(x, y)
        this.context.fillStyle = Constant.FLOOR_COLOR
        this.context.fillRect(x * Constant.SQUARE, y * Constant.SQUARE, Constant.SQUARE, Constant.SQUARE)

MazeManager.prototype.isWall = (x, y) ->
		x < 0 || y < 0 || this.maze[x + (y * this.width)] == '*'

MazeManager.prototype.isInside = (x, y) ->
		x > 0 && y > 0 && x < this.width - 1 && y < this.height - 1

MazeManager.prototype.isOpen = (x, y) ->
  !this.isWall(x,y)

this.window.MazeManager = MazeManager