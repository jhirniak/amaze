reset = ->
  if (window.mazeTimeout)
    clearInterval window.mazeTimeout

  controller = new MazeController()

  width = Math.floor(this.window.innerWidth / 2 / Constant.SQUARE) - 1
  height = Math.floor(this.window.innerHeight / 2 / Constant.SQUARE) - 1

  this.maze = this.generateMaze(width, height)
  this.window.controller = controller

  controller.init(maze)
  controller.run()

$(document).ready( ->
  reset()
)

$(window).resize( ->
  reset()
)

window.resetMaze = reset