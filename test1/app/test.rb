require 'opal'
require 'pp'
require 'math'
require 'browser'
require 'browser/canvas'
require 'browser/interval'

class Grid

  NUM_BALLS = 512

  RADIUS = 12

  TAU = 2 * Math::PI

  def initialize(canvas_id)
    @canvas_id = canvas_id
    @sxpos = NUM_BALLS.times.map {|i| i * 3.54 * TAU / NUM_BALLS }
    @sypos = NUM_BALLS.times.map {|i| i * 4.23 * TAU / NUM_BALLS }
  end

  def run
    every(1.0/60) { update }
  end

  def update
    @sxpos = @sxpos.map { |sp| sp + 0.037 }
    @sypos = @sypos.map { |sp| sp + 0.059 }
    draw
  end

  def draw
    clear
    style.line.width = 2
    style.stroke = '#465'
    style.fill   = '#8CA'
    r = RADIUS
    NUM_BALLS.times do |i|
      x = center_x + radius * Math.cos(@sxpos[i])
      y = center_y + radius * Math.sin(@sypos[i])
      circle x + r, y + r, r, filled: true
      circle x + r, y + r, r
    end
  end

  def clear
    canvas.element[:width] = canvas.width # http://jsperf.com/canvasclear
  end

  def circle(x, y, radius, filled: false)
    arc = -> { arc x, y, radius, {start: 0, end: 2 * Math::PI} }
    filled ? canvas.fill(&arc) : canvas.stroke(&arc)
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
    @canvas ||= Browser::Canvas.new($document[@canvas_id])
  end

  def style
    @style ||= canvas.style
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
