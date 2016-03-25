local Signal = require 'lib.hump.signal'
local love = love
local boxes = {}
local fadeOutTime = 2
local fadeInTime = .2

local show = function(text, pos)
  table.insert(boxes, {text = text, pos = pos})
end

--Signal.register('char_say', function(char, message) show(char.name..": "..message) end)
Signal.register('object-collected', function(char, obj) show("A " .. obj.name..", nice!", char) end)
Signal.register('door-locked', function(door, char) show("It's locked", char) end)

return {
  update = function(self, dt)
    for _,box in ipairs(boxes) do
      if box.time and box.time > 0 then box.time = box.time - dt end
      -- TODO remove not active boxes

      if box.text ~= box.lastText and box.text ~= "" then
        box.lastText = box.text
        box.duration = math.max(0.2, box.text:len() * 0.1) -- time to read
        box.time = box.duration
      end
    end
  end,

  draw = function(self)
    for _,box in ipairs(boxes) do
      if box.time and box.time > 0 then
        local font = font.talk
        local alphaOut = math.min(box.time, fadeOutTime) / fadeOutTime
        local alphaIn =(1-math.max(box.time, box.duration - fadeInTime)) / ( box.duration -fadeInTime)
        local alpha = 1--math.min(alphaIn, alphaOut) TODO

        -- TODO this can be done with a closure in the box
        local w = font:getWidth(box.text)+22
        local h = font:getHeight()+8
        local x = box.pos.x - 2
        local y = box.pos.y - h - 4


          --print(box.time, box.duration,alpha, alphaIn, alphaOut)
          love.graphics.setColor(palette[4])
          love.graphics.setLineWidth(2)
          --local x = box.x + self.width*0.2
          --local y = box.y - font.talk:getHeight() -7
          love.graphics.rectangle("line", x, y, w, h)
          love.graphics.setColor(palette[1])
          --local x = box.x + self.width*0.2
          --local y = box.y - font.talk:getHeight() -7
          love.graphics.rectangle("fill", x, y, w, h)
        love.graphics.setColor(palette[4], 255*alpha)
        love.graphics.setFont(font);
        love.graphics.print(box.text, x+11, y+5)
      end
    end
  end,
}
