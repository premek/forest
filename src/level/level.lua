local love = love
local sti = require "lib.sti"
local bump = require "lib.bump"
local maputils = require "maputils"
local vector = require "lib.hump.vector" -- maybe use vector_light for better performance?

return require 'lib.hump.class' {
  -- XXX do I need classes? or just level data + level controller?
  gravity = vector(0,.1),

  -- new() and load() (call from load())
  init = function(self)
    print("Creating & loading level", self.mapfile)

    if not love.filesystem.exists(self.mapfile) then
      error("File not found: ".. self.mapfile)
    end

    self.world = bump.newWorld()

    self.map = sti.new(self.mapfile, { "bump" })
    self.map:bump_init(self.world) 	--- Adds each collidable tile to the Bump world.

    self.chars = {}
    self.movables = {}
    local controlled
    for _, item in ipairs(self.world:getItems()) do
      if item.type == "char" then
        maputils.removeObjectByItem(self.map, item)
        self.world:remove(item)
        local ch = require ("char."..item.name)(item.x, item.y)
        if item.properties and item.properties.controlled then controlled = ch end
        table.insert(self.chars, ch)
        table.insert(self.movables, ch)
      end
      if item.type == "move" then
        item.speed = vector(0,0)
        table.insert(self.movables, item)
      end
    end
    if controlled then controlled.isControlled = true
    elseif #self.chars > 0 then self.chars[1].isControlled = true
    end

    self:load()

    for _,ch in ipairs(self.chars) do
      ch:load()
      self.world:add(ch, ch.x, ch.y, ch.width, ch.height)
    end
  end,

  load = function(_) end, -- to be implemented in subclasses or left empty

  update = function(self, dt)
    self.map:update(dt)

    for _,o in ipairs(self.movables) do

      if o.speed:len() < 0.1 then o.speed = vector(0,0) end
      o.speed = o.speed + self.gravity
      -- TODO 0 friction in air, else other objects friction - implement mud, ice, ...
      o.speed.x = o.speed.x * .9

      if o.update then o:update(dt) end

      if o.speed:len() ~= 0 then
        local original = {
          grounded = o.grounded,
          speed = o.speed:clone(),
        }
        local cols
        o.x, o.y, cols, _ =
          self.world:move(o, o.x + o.speed.x, o.y + o.speed.y,
            function (o1, o2) return self:getCollisionType(o1, o2) end)

        -- map objects has .id, chars dont
        if o.id then maputils.moveObjectByItem(self.map, o) end

        o.grounded = false

        for _, col in ipairs(cols) do
          self:collision(o, col.other, col)
        end

        -- TODO some tollerance
        -- to be able to jump up between 2 tiles
        -- or to fall down into a hole of size of 1 tile

        if o.grounded and not original.grounded then
          -- FIXME store somewhere else than in "world"
          self.world.shake = original.speed.y * .07 - .2 -- FIXME only for long jumps
        end
      end
    end
  end,


  getCollisionType = function(self, moving, other)
    local levelColType = self.getLevelCollisionType and self:getLevelCollisionType(moving, other)
    if levelColType then return levelColType end
    if other.type == "action"
    or other.type == "collect" then
      return 'cross'
    else return "slide"
    end
    --if     other.isCoin   then return 'cross'
    --elseif other.isWall   then return 'slide'
    --elseif other.isExit   then return 'touch'
    --elseif other.isSpring then return 'bounce'
    --end
    -- else return nil
  end,

  -- resolve collision of the moving object only.
  -- if the other one moves too, it will be called for it too
  collision = function(self, moving, other, collision)
    -- general actions on objects
    if other.layer and other.layer.name == "objects" then
      --print("Object collision", moving.name, moving.type, other.name, other.type)
      if other.type == "collect" and moving.collect and moving:collect(other.name) then
        self.world:remove(other)
        maputils.removeObjectByItem(self.map, other)
      elseif other.type == "move" then
        other.speed.x = other.speed.x - collision.normal.x * 0.5
        other.speed.y = other.speed.y - collision.normal.y *  0.5 -- dt? moving.speed?
        --moving.speed.x = moving.speed.x * 0.5
        --moving.speed.y = moving.speed.y * 0.5
      elseif other.type == "action" then
        -- level specific actions
        if self.action then self:action(moving, other) end
      end
    end

    if other.type ~= "collect" and other.type ~= "action" then
      self:physics(moving, collision)
    end
    -- object specific actions
    if moving.collision then moving:collision(other, collision) end
    if other.collision then other:collision(moving, collision) end
  end,

  -- resolve physics (speed, grounding) for the object that just moved and colided
  physics = function(self, obj, col)
    if col.normal.y < 0 then
      -- feet touched
      if obj.speed == nil then obj.speed = {} end
      obj.speed.y = 0
      obj.grounded = true
    end
    if col.normal.y > 0 then
      -- head touched
      if obj.speed == nil then obj.speed = {} end
      obj.speed.y = -.1
       -- this is to allow jumping in a space of size of 1 tile
       -- increase to implement 'hold/stick to ceiling'
       -- FIXME what is a good value in relation to gravity and jump speed
    end
    if col.normal.x ~= 0 then
      -- left or right touched
      if obj.speed == nil then obj.speed = {} end
      obj.speed.x = 0
    end
  end,

  draw = function(self)
    self.map:draw()
    for _,char in ipairs(self.chars) do char:draw() end
  end

}
