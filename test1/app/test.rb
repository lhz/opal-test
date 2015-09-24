require 'opal'
require 'browser'
require 'browser/canvas'
require 'browser/animation_frame'
require 'browser/interval'
require 'pp'
require 'math'

class Test

  NUM_BALLS = 256
  BALL_RADIUS = 12
  TAU = 2 * Math::PI
  DEBUG = true

  def initialize(canvas_id)
    @canvas_id = canvas_id
    @sxpos = NUM_BALLS.times.map {|i| i * 1.54 * TAU / NUM_BALLS }
    @sypos = NUM_BALLS.times.map {|i| i * 2.23 * TAU / NUM_BALLS }
    @frame_number = 0
    @frame_time   = 0
  end

  def run
    animation_frame { animate }
  rescue NotImplementedError
    pp "requestAnimationFrame() not available, falling back to setInterval()."
    every(1.0 / 60) { update }
  end

  private

  def animate
    @frame_number += 1
    t0 = `performance.now()`
    update
    t1 = `performance.now()`
    if DEBUG && @frame_number % 50 == 0
      pp "Update took #{'%.3f' % (t1 - t0)} ms, running at #{(50000 / (t0 - @frame_time)).round} fps"
      @frame_time = t0
    end
    animation_frame { animate }
  end
  
  def update
    @sxpos = @sxpos.map { |sp| sp + 0.047 }
    @sypos = @sypos.map { |sp| sp + 0.079 }
    draw
  end

  def draw
    clear
    style.line.width = 2
    style.stroke = '#465'
    style.fill   = '#8CA'
    r = BALL_RADIUS
    NUM_BALLS.times do |i|
      x = center_x + sine_radius * Math.cos(@sxpos[i])
      y = center_y + sine_radius * Math.sin(@sypos[i])
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

  def sine_radius
    @radius ||= ([width, height].min - 2 * BALL_RADIUS) / 2 - 2
  end

  def center_x
    (width - 2 * BALL_RADIUS) / 2
  end
  
  def center_y
    (height - 2 * BALL_RADIUS) / 2
  end

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
 
test = Test.new('canvas')
test.run
