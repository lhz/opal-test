require 'browser'
require 'browser/canvas'

class Canvas < Browser::Canvas

  def circle(x, y, radius)
    stroke do
      arc(x, y, radius, {start: 0, end: 2 * Math::PI})
    end
  end

  def stroke_width(value)
    `#@native.strokeWidth = value`
    self
  end

  def stroke_style(value)
    `#@native.strokeStyle = value`
    self
  end

  def fill_style(value)
    `#@native.fillStyle = value`
    self
  end

  def fill_rect(x, y, width, height)
    `#@native.fillRect(x, y, width, height)`
    self
  end

  def fill_circle(x, y, radius)
    path do
      arc(x, y, radius, {start: 0, end: 2 * Math::PI})
    end
    fill
  end

  def resize(width, height)
    element[:width]  = width
    element[:height] = height
  end
end
