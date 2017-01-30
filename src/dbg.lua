local love=love
local res = require "resources"

local drawVector = function(r,g,b, w, x, y, v)
love.graphics.setLineWidth(w)
love.graphics.setColor(r,g,b)
love.graphics.line(x, y, x+v.x*10, y+v.y*10)
end

local r = {}
r = {
enabled = false,
draw = function(level)
  if not r.enabled then return end
  love.graphics.setColor(0,255,0, 255)
  love.graphics.setFont(res.font.debug);
  love.graphics.print("FPS: "..tostring(love.timer.getFPS( )), 10, 10)
  level.cam:attach()

  for _, v in ipairs(level.world:getItems()) do
    local b = v.layer and v.layer.name == "objects" and 255 or 0;
    love.graphics.setColor(255, 0, b, 20)
    love.graphics.rectangle("fill", level.world:getRect(v))
    love.graphics.setColor(255, 0, b)
    love.graphics.rectangle("line", level.world:getRect(v))
  end
  for _, ch in ipairs(level.map.layers.objects.objects) do
    if ch.speed then drawVector(0,255,0, 2, ch.x, ch.y, ch.speed) end

    love.graphics.setColor(0,0,255, 255)
    if ch.name then love.graphics.print(ch.name, ch.x, ch.y+ch.height) end

    if ch.inventory then
      local li=1
      for item, amount in pairs(ch.inventory) do
        love.graphics.print(item .. " x"..amount, ch.x, ch.y+ch.height+li*10)
        li = li + 1
      end
    end
  end
  level.cam:detach()

end
}

return r
