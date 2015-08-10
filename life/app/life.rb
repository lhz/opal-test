require 'opal'
require 'opal-jquery'
require 'browser'
require 'browser/canvas'

class Canvas < Browser::Canvas
  def stroke_style(value)
    `#@native.strokeStyle = value`
    self
  end
end


class Grid
  attr_reader :height, :width, :canvas, :context, :max_x, :max_y

  CELL_HEIGHT = 15
  CELL_WIDTH  = 15

  def initialize(canvas_id)
    # @width   = $window.size.width  - 30
    # @height  = $window.size.height - 30
    @width  = 500
    @height = 400

    @canvas = Canvas.new($document[canvas_id])
    @canvas.element[:width]  = @width
    @canvas.element[:height] = @height

    @max_x   = (height / CELL_HEIGHT).floor
    @max_y   = (width / CELL_WIDTH).floor
  end
 
  def draw_canvas
    0.5.step(width, CELL_WIDTH) do |x|
      canvas.line x, 0, x, height
    end

    0.5.step(height, CELL_HEIGHT) do |y|
      canvas.line 0, y, width, y
    end
 
    canvas.stroke_style('#eee').stroke
  end
end
 
grid = Grid.new('lifeCanvas')
grid.draw_canvas
