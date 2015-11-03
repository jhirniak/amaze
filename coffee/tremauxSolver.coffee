Solver = (walker) ->
  this.walker = walker
  this.direction = 0
  this.end = walker.maze.end

  this

Solver.prototype.step = ->
  startingDirection = this.direction

  while !this.walker.move(this.direction)
    # Hit a wall. Turn to the right.
    this.direction++

    this.direction = 0 if this.direction > 3

    if this.direction == startingDirection
      # We've turned in a complete circle with no new path available. Time to backtrack.
      while (!this.walker.move(this.direction, true))
        # Hit a wall. Turn to the right.
        this.direction++

        this.direction = 0 if this.direction > 3

      break

  this.walker.draw()

Solver.prototype.isDone = ->
  this.walker.x == this.walker.maze.end.x && this.walker.y == this.walker.maze.end.y

Solver.prototype.solve = ->
  for x in [0..this.walker.maze.width-1]
    for y in [0..this.walker.maze.height-1]
      if this.walker.visited[x][y] == 1
        # Draw solution path square.
        this.walker.context.fillStyle = Constant.SOLUTION_COLOR
        this.walker.context.fillRect(x * Constant.SQUARE, y * Constant.SQUARE, Constant.SQUARE, Constant.SQUARE)
      else if this.walker.visited[x][y] > 1
        # Draw dead end path square.
        this.walker.context.fillStyle = Constant.BACKTRACK_COLOR
        this.walker.context.fillRect(x * Constant.SQUARE, y * Constant.SQUARE, Constant.SQUARE, Constant.SQUARE)

this.window.Solver = Solver