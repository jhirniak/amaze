controller = new MazeController()

$(document).ready( ->
  controller.init(maze)
  controller.run()
)

this.window.controller = controller