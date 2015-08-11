require 'browser'
require 'browser/canvas'

class Canvas < Browser::Canvas

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

  def resize(width, height)
    element[:width]  = width
    element[:height] = height
  end
end
