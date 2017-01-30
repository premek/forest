local Signal = require 'lib.hump.signal'
local love = love
local boxes = {}
local fadeOutTime = .5
local fadeInTime = .1

local show = function(text, pos)
  table.insert(boxes, {text = text, pos = pos})
end

Signal.register('char_say', function(char, message) show(message, char) end)
Signal.register('object-collected', function(char, obj) show("A " .. obj.name..", nice!", char) end)
Signal.register('door-locked', function(door, char) show("It's locked", char) end)

return {
  update = function(self, dt)
    local newBoxes = {}
    for _,box in ipairs(boxes) do
      if box.text ~= box.lastText and box.text ~= "" then
        box.lastText = box.text
        box.duration = math.max(1, box.text:len() * 0.1+.5) -- time to read
        box.time = box.duration
      end
      if box.time and box.time > 0 then
        box.time = box.time - dt
        newBoxes[#newBoxes+1] = box
      end
    end
    boxes = newBoxes
  end,

  draw = function(self)
    for _,box in ipairs(boxes) do
      if box.time and box.time > 0 then
        local alphaIn = math.min(box.duration - box.time, fadeInTime) / fadeInTime
        local alphaOut = math.min(box.time, fadeOutTime) / fadeOutTime -- time is decreasing value
        local alpha = 255 * math.min(alphaOut, alphaIn)
        local font = font.talk
        love.graphics.setFont(font);
        local w = math.min(font:getWidth(box.text), 130)
        local _, lines = font:getWrap(box.text, w)
        local h = font:getHeight() * #lines
        local x = box.pos and (math.max(0, box.pos.x - w/2) + 10) or 10
        local y = box.pos and (box.pos.y - h - 5) or 10
        local bx, by = 4, 2
        love.graphics.setColor(palette[4][1], palette[4][2], palette[4][3], alpha)
        love.graphics.setLineWidth(2)
        love.graphics.rectangle("line", x-bx, y-by-1, w+2*bx, h+2*by)
        love.graphics.setColor(palette[1][1], palette[1][2], palette[1][3], alpha)
        love.graphics.rectangle("fill", x-bx, y-by-1, w+2*bx, h+2*by)
        love.graphics.setColor(palette[4][1], palette[4][2], palette[4][3], alpha)
        love.graphics.printf(box.text, x, y, w, 'left')
      end
    end
  end,
}
