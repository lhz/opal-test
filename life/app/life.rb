require 'opal'
require 'canvas'
require 'pp'

class Grid
  attr_reader :max_x, :max_y

  CELL_HEIGHT = 15
  CELL_WIDTH  = 15

  def initialize(canvas_id)
    @canvas_id = canvas_id
    @max_x = (width / CELL_WIDTH).floor
    @max_y = (height / CELL_HEIGHT).floor
  end
 
  def draw
    canvas.resize(width, height)

    0.5.step(width, CELL_WIDTH) do |x|
      canvas.line x, 0, x, height
    end

    0.5.step(height, CELL_HEIGHT) do |y|
      canvas.line 0, y, width, y
    end
 
    canvas.stroke_style('#eee').stroke

    1000.times do
      fill_cell rand(max_x), rand(max_y)
    end
  end

  def fill_cell(x, y)
    x *= CELL_WIDTH;
    y *= CELL_HEIGHT;
    canvas.fill_style('#000').fill_rect(x.floor + 1, y.floor + 1, CELL_WIDTH - 1, CELL_HEIGHT - 1)
  end
 
  def clear_cell(x, y)
    x *= CELL_WIDTH;
    y *= CELL_HEIGHT;
    canvas.clear(x.floor + 1, y.floor + 1, CELL_WIDTH - 1, CELL_HEIGHT - 1)
  end

  def width
    `window.innerWidth` # $window.size.width
  end
  
  def height
    `window.innerHeight` # $window.size.height
  end

  private

  def canvas
    @canvas ||= Canvas.new($document[@canvas_id])
  end
end
 
grid = Grid.new('lifeCanvas')
grid.draw
