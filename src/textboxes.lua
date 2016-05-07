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
        box.duration = math.max(1, box.text:len() * 0.2) -- time to read
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
        local font = font.talk
        local alphaIn = math.min(box.duration - box.time, fadeInTime) / fadeInTime
        local alphaOut = math.min(box.time, fadeOutTime) / fadeOutTime -- time is decreasing value
        local alpha = 255 * math.min(alphaOut, alphaIn)

        -- TODO this can be done with a closure in the box
        local w = font:getWidth(box.text)+22
        local h = font:getHeight()+8
        local x = box.pos.x - 2
        local y = box.pos.y - h - 4


          print(box.time, box.duration,alpha, alphaIn, alphaOut)
          love.graphics.setColor(palette[4][1], palette[4][2], palette[4][3], alpha)
          love.graphics.setLineWidth(2)
          --local x = box.x + self.width*0.2
          --local y = box.y - font.talk:getHeight() -7
          love.graphics.rectangle("line", x, y, w, h)
          love.graphics.setColor(palette[1][1], palette[1][2], palette[1][3], alpha)
          --local x = box.x + self.width*0.2
          --local y = box.y - font.talk:getHeight() -7
          love.graphics.rectangle("fill", x, y, w, h)
        love.graphics.setColor(palette[4][1], palette[4][2], palette[4][3], alpha)
        love.graphics.setFont(font);
        love.graphics.print(box.text, x+11, y+5)
      end
    end
  end,
}
