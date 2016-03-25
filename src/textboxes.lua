local Signal = require 'lib.hump.signal'
local love = love
local boxes = {}
local fadeOutTime = 2
local fadeInTime = .2

local show = function(msg, x, y)
  table.insert(boxes, {text = msg, x=x or 10, y=y or 800})
end

Signal.register('char_say', function(char, message) show(char.name..": "..message) end)
Signal.register('object-collected', function(char, obj) show(char.name.." collected "..obj.name) end)
Signal.register('door-locked', function(door, char) show("It's locked") end)

return {
  update = function(self, dt)
    for _,box in ipairs(boxes) do
      if box.time and box.time > 0 then box.time = box.time - dt end
      -- TODO remove not active boxes

      if box.text ~= box.lastText and box.text ~= "" then
        box.lastText = box.text
        box.duration = box.text:len() * 0.2 -- time to read
        box.time = box.duration
      end
    end
  end,

  draw = function(self)
    for _,box in ipairs(boxes) do
      if box.time and box.time > 0 then
        local alphaOut = math.min(box.time, fadeOutTime) / fadeOutTime
        local alphaIn =(1-math.max(box.time, box.duration - fadeInTime)) / ( box.duration -fadeInTime)
        local alpha = 1--math.min(alphaIn, alphaOut) TODO

          print(box.time, box.duration,alpha, alphaIn, alphaOut)
        love.graphics.setColor(255,255,255, 128*alpha)
        --local x = box.x + self.width*0.2
        --local y = box.y - font.talk:getHeight() -7
        love.graphics.rectangle("fill", box.x, box.y, font.talk:getWidth(box.text)+7, font.talk:getHeight()+3)
        love.graphics.setColor(0,0,0, 255*alpha)
        love.graphics.setFont(font.talk);
        love.graphics.print(box.text, box.x+3, box.y+3)
      end
    end
  end,
}
