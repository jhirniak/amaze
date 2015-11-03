MazeController = ->
  this.canvas = null
  this.context = null
  this.maze = null
  this.walker = null
  this.algorithm = null
  this.speed = null

  this

MazeController.prototype.init = (maze) ->
  this.canvas = $('#imageView').get(0)
  this.context = this.canvas.getContext('2d')

  # Auto-adjust canvas size to fit window.
  this.canvas.width  = maze.width * Constant.SQUARE
  this.canvas.height = maze.height * Constant.SQUARE

  # Initialize speed.
  this.speed = if maze.speed then maze.speed else Constant.SPEED

  # Create maze.
  this.maze = new MazeManager(this.
  context, maze);
  this.maze.draw();

  # Create walker at starting position.
  this.walker = new walkerManager(this.context, this.maze);
  this.walker.init();

  # Initialize the maze algorithm.
  this.algorithm = new Solver(this.walker)

MazeController.prototype.run = ->
		if !this.algorithm.isDone()
			this.algorithm.step()

			window.mazeTimeout = window.setTimeout (-> controller.run()), this.speed
		else
			# Clear map so we can draw the solution path.
      this.walker.maze.draw(true)

			# Draw the solution path.
      this.algorithm.solve()

      window.setTimeout (-> window.resetMaze() ), Constant.NEW_MAZE_TIMEOUT

this.window.MazeController = MazeController
