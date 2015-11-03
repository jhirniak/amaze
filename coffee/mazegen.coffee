Cell = ->
  this.init = false
  this.walls = 0x1111

Cell.walls = {
  UP: 0x1000,
  DOWN: 0x0100,
  LEFT: 0x0010,
  RIGHT: 0x0001
}

Cell.dummy = new Cell()
Cell.dummy.init = true

this.Map = (width, height) ->
  this.width = width
  this.height = height
  this.cells = []

  this.entrance = { x: Math.floor(Math.random() * width), y: 0}
  this.exit = { x: Math.floor(Math.random() * width), y: this.height-1}

  console.log 'Entrance', this.entrance
  console.log 'Exit', this.exit

  this.init()

  this

Map.prototype.init = ->
  size = this.width * this.height
  for i in [0..size]
    this.cells.push(new Cell())

Map.prototype.getCell = (x, y) ->
  i = y * this.width + x
  this.cells[i];

Map.prototype.setWall = (x, y, wall) ->
  i = y * this.width + x
  this.cells[i].walls = wall

Map.prototype.clearWall = (x, y, wall) ->
  i = y * this.width + x
  this.cells[i].walls ^= wall

Map.prototype.getNeightbours = (x, y) ->
  return {
    up: if y > 0 then this.getCell(x, y - 1) else Cell.dummy,
    down: if y < this.height - 1 then this.getCell(x, y + 1) else Cell.dummy,
    left: if x > 0 then this.getCell(x - 1, y) else Cell.dummy,
    right: if x < this.width - 1 then this.getCell(x + 1, y) else Cell.dummy
  }

Map.prototype.generate = ->
  # Entrance and exit
  this.clearWall(this.entrance.x, this.entrance.y, Cell.walls.UP)
  this.clearWall(this.exit.x, this.exit.y, Cell.walls.DOWN)

  stack = [];
  self = this;
  keys = ['up', 'down', 'left', 'right'];

  shuffle = (arr) ->
    for i in [arr.length-1..0]
      j = Math.floor(Math.random() * i)
      [ arr[i] , arr[j] ] = [ arr[j] , arr[i] ]
    arr

  x = 0
  y = 0
  while true
    cell = self.getCell(x, y)

    if cell.init
      stack.pop()
      next = stack.pop()

      self.getCell(next.x, next.y).init = false

      # Back at starting cell?
      if stack.length > 0
        x = next.x
        y = next.y
        continue

      # All done
      return true

    cell.init = true
    stack.push({x: x, y: y})

    neighbours = self.getNeightbours(x, y)
    keys = shuffle(keys)
    check = 0
    rand = 0

    while (check++ < keys.length)
      rand = keys[check - 1];

      switch rand
        when 'up'
          if !neighbours.up.init
            self.clearWall(x, y, Cell.walls.UP)
            self.clearWall(x, y - 1, Cell.walls.DOWN)
            y--
            check = keys.length

        when 'down'
          if !neighbours.down.init
            self.clearWall(x, y, Cell.walls.DOWN)
            self.clearWall(x, y + 1, Cell.walls.UP)
            y++
            check = keys.length

        when 'left'
          if !neighbours.left.init
            self.clearWall(x, y, Cell.walls.LEFT)
            self.clearWall(x - 1, y, Cell.walls.RIGHT)
            x--
            check = keys.length

        when 'right'
          if !neighbours.right.init
            self.clearWall(x, y, Cell.walls.RIGHT)
            self.clearWall(x + 1, y, Cell.walls.LEFT)
            x++
            check = keys.length


Map.prototype.toString = ->
  width = this.width
  height = this.height

  steps = ->
    for y in [0..height]
      for x in [0..width]
        i = y * width + x
        yield {x: x, y: y, i: i}

    return

  getSteps = ->
    steps = []

    for y in [0..height-1]
      for x in [0..width-1]
        i = y * width + x
        p = {x: x, y: y, i: i}
        steps.push(p)

    return steps

  genToArr = (gen) ->
    arr = []
    for g in gen
      arr.push(g)
    return arr

  this.mysteps = getSteps()

  toGridCord = (p) ->
    x = 2*p.x + 1
    y = 2*p.y + 1
    i = y * (2 * width + 1) + x
    return {x: x, y: y, i: i}

  generateGrid = ->
    map = []

    for i in [0..(2 * width + 1) * (2 * height + 1) - 1]
      map.push('*')

    return map

  gridToString = (grid) ->
    i = 0
    txt = ''
    width = 2 * width + 1

    for ch in grid
      txt += ch
      txt += '\n' if !(++i % width)

    return txt

  grid = generateGrid()

  for cellCord in getSteps()
    gridCord = toGridCord(cellCord)
    cell = this.getCell(cellCord.x, cellCord.y)
    grid[gridCord.i] = ' '

    if !(cell.walls & Cell.walls.UP)
      i = (gridCord.y - 1)*(2 * width + 1) + gridCord.x
      grid[i] = ' '

    if !(cell.walls & Cell.walls.DOWN)
      i = (gridCord.y + 1)*(2 * width + 1) + gridCord.x
      grid[i] = ' '

    if !(cell.walls & Cell.walls.LEFT)
      i = gridCord.y * (2 * width + 1) + gridCord.x - 1
      grid[i] = ' '

    if !(cell.walls & Cell.walls.RIGHT)
      i = gridCord.y * (2 * width + 1) + gridCord.x + 1
      grid[i] = ' '

  this.txtMap = gridToString(grid)

  console.log 'map'
  console.log this.txtMap

  return this.txtMap

generateMaze = (width, height) ->
  map = new Map(width, height)
  map.generate()
  txtMap = map.toString()
  console.log 'Entrance', map.entrance

  entranceStar = { x: 2 * map.entrance.x + 1, y: 0}
  exitStar = { x: 2 * map.exit.x + 1, y: 2 * map.exit.y + 2}

  console.log 'Map entrance:', map.entrance
  console.log 'Grid entrance:', entranceStar
  console.log 'Map exit:', map.exit
  console.log 'Grid exit:', exitStar

  return {
    start: entranceStar,
    end: exitStar,
    width: 2 * width + 2,
    height: 2 * height + 2,
    map: txtMap
  }

this.window.generateMaze = generateMaze