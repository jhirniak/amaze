Constant = ->
  this.BACKTRACK_COLOR = 'rgb(100, 0, 0)'
  this.PATH_COLOR = 'rgb(255, 69, 0)'
  this.CROSSROAD_COLOR = 'rgb(255, 255, 50)'
  this.SOLUTION_COLOR = 'green'
  this.WALL_COLOR = 'black'
  this.FLOOR_COLOR = 'white'
  this.TO_FLIP = 5 # how many moves before flip of cursor color
  this.FLIP_COLORS = ['rgb(173,255,47)', 'rgb(255,47,173)']
  this.SQUARE = 12 # size of square in px
  this.SPEED = 40

this.window.Constant = new Constant()