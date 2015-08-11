require 'opal'
require 'canvas'
require 'pp'
require 'ostruct'

class Cell < OpenStruct; end

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
      fill_cell Cell.new(x: rand(max_x), y: rand(max_y))
    end
  end

  def fill_cell(cell)
    x = cell.x * CELL_WIDTH;
    y = cell.y * CELL_HEIGHT;
    canvas.fill_style('#000').fill_rect(x + 1, y + 1, CELL_WIDTH - 1, CELL_HEIGHT - 1)
  end
 
  def clear_cell(cell)
    x = cell.x * CELL_WIDTH;
    y = cell.y * CELL_HEIGHT;
    canvas.clear(x + 1, y + 1, CELL_WIDTH - 1, CELL_HEIGHT - 1)
  end

  def width
    $window.view.width
  end
  
  def height
    $window.view.height
  end

  def get_cursor_cell(event)
    x = (event.page.x / CELL_WIDTH).to_i
    y = (event.page.y / CELL_HEIGHT).to_i
    Cell.new(x: x, y: y)
  end

  def add_mouse_event_listener
    canvas.element.on :click do |event|
      cell = get_cursor_cell(event)
      fill_cell cell
    end
    
    canvas.element.on :dblclick do |event|
      cell = get_cursor_cell(event)
      clear_cell cell
    end
  end

  private

  def canvas
    @canvas ||= Canvas.new($document[@canvas_id])
  end
end
 
grid = Grid.new('lifeCanvas')
grid.draw
grid.add_mouse_event_listener
