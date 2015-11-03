flipper = ->
  counter = 0
  index = 0

  flip = ->
    if !(++counter % Constant.TO_FLIP)
      counter = 0
      if !(++index % Constant.FLIP_COLORS.length)
        index = 0

    Constant.FLIP_COLORS[index]

  flip

walkerManager = (context, maze) ->
  this.context = context
  this.maze = maze
  this.x = maze.start.x
  this.y = maze.start.y
  this.lastX = -1
  this.lastY = -1
  this.visited = createArray(maze.width, maze.height)
  this.cursor_color = flipper()

  this.init = ->
    # Reset array
    for x in [0..this.maze.width-1]
      for y in [0..this.maze.height-1]
        this.visited[x][y] = 0

    # Set to and draw starting point
    this.visited[this.x][this.y] = 1
    this.draw()

  this.draw = ->
    this.context.fillStyle = this.cursor_color()
    this.context.fillRect(this.x * Constant.SQUARE, this.y * Constant.SQUARE, Constant.SQUARE, Constant.SQUARE)

  this.move = (direction, backtrack) ->
    changed = false
    oldX = this.x
    oldY = this.y

    if backtrack || !this.hasVisited(direction)
      point = this.getXYForDirection(direction)

      if this.canMove(point.x, point.y)
        this.x = point.x
        this.y = point.y
        changed = true

    if changed
      this.context.fillStyle = if backtrack then Constant.BACKTRACK_COLOR else Constant.PATH_COLOR
      this.context.fillRect(oldX * Constant.SQUARE, oldY * Constant.SQUARE, Constant.SQUARE, Constant.SQUARE)

      this.lastX = oldX
      this.lastY = oldY

      # Mark tile as visited (possibly twice)
      this.visited[this.x][this.y]++;

      if backtrack
        # We went back, so do not visit the last tile again
        this.visited[this.lastX][this.lastY] = 2

      if this.visited[oldX][oldY] == 2 && this.visited[this.x][this.y] == 1
        # Found unvisited tile while backtracking.
        # Mark the last tile back to 1, so it can be visited again
        # (i.e. to get back to the other ones).
        this.visited[oldX][oldY] = 1
        this.context.fillStyle = Constant.CROSSROAD_COLOR
        this.context.fillRect(oldX * Constant.SQUARE, oldY * Constant.SQUARE, Constant.SQUARE, Constant.SQUARE)

    changed

  this.canMove = (x, y) ->
    this.maze.isOpen(x, y) && this.visited[x][y] < 2

  this.hasVisited = (direction) ->
    point = this.getXYForDirection(direction)

    # Check if this tile has been visited
    this.visited[point.x][point.y] > 0

  this.getXYForDirection = (direction) ->
    point = {}

    switch (direction)
      when 0
        point.x = this.x
        point.y = this.y - 1
      when 1
        point.x = this.x + 1
        point.y = this.y
      when 2
        point.x = this.x
        point.y = this.y + 1
      when 3
        point.x = this.x - 1
        point.y = this.y

    point
  this

createArray = (length) ->
  arr = new Array(length || 0)
  i = length

  if arguments.length > 1
    args = Array.prototype.slice.call arguments, 1
    while i-- then arr[length-1 - i] = createArray.apply this, args

  arr

this.window.walkerManager = walkerManager