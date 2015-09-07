require 'opal'
require 'pp'
require 'math'

require 'canvas'
require 'interval'

class Grid

  NUM_BALLS = 64

  RADIUS = 12

  TAU = 2 * Math::PI

  def initialize(canvas_id)
    @canvas_id = canvas_id
    @sxpos = NUM_BALLS.times.map {|i| i * 0.84 * TAU / NUM_BALLS }
    @sypos = NUM_BALLS.times.map {|i| i * 0.73 * TAU / NUM_BALLS }
  end

  def run
    Interval.new(25) { update }
  end

  def update
    @sxpos = @sxpos.map { |sp| sp + 0.037 }
    @sypos = @sypos.map { |sp| sp + 0.059 }
    draw
  end

  def draw
    canvas.resize(width, height)
    canvas.stroke_width(2).stroke_style('#465').fill_style('#8CA')
    NUM_BALLS.times do |i|
      x = center_x + radius * Math.cos(@sxpos[i])
      y = center_y + radius * Math.sin(@sypos[i])
      canvas.fill_circle(x + RADIUS, y + RADIUS, RADIUS)
      canvas.circle(x + RADIUS, y + RADIUS, RADIUS)
    end
  end

  def radius
    @radius ||= ([width, height].min - 2 * RADIUS) / 2
  end

  def center_x
    (width - 2 * RADIUS) / 2
  end
  
  def center_y
    (height - 2 * RADIUS) / 2
  end
  
  private

  def canvas
    @canvas ||= Canvas.new($document[@canvas_id])
  end

  def width
    canvas.width # 500 # $window.view.width
  end
  
  def height
    canvas.height # 500 # $window.view.height
  end
end
 
grid = Grid.new('canvas')
grid.run
