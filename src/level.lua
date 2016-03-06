local love = love
local sti = require "lib.sti"
local bump = require "lib.bump"
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

    for _,obj in ipairs(self.map.layers.objects.objects) do
      local tile = self.map.tiles[obj.gid]
      local tileI
      if tile ~= nil then -- else it is just a shape object without image
        for _, tileInst in ipairs(self.map.tileInstances[tile.gid]) do
          if tileInst.gid == tile.gid then tileI = tileInst; break end
        end
      end

      obj._tile = tile
      obj._tileInst = tileI
      if tile then obj._currentQuad = tile.quad end -- for animations, see update()
      if obj.gid then obj.y = obj.y - obj.height end
    end

    local objects = self.map.layers.objects.objects
    local objLayer = self.map:convertToCustomLayer("objects")
    self.map.layers.objects.objects = objects

    local level = self

    objLayer.update = function(layer, dt)
      for _, o in pairs(layer.objects) do
        if o._tile and o._tile.animation then
          o._currentQuad = level.map.tiles[tonumber(o._tile.animation[o._tile.frame].tileid) + level.map.tilesets[o._tile.tileset].firstgid].quad
        end
      end
    end

    objLayer.draw = function(layer)
        for _, o in pairs(layer.objects) do
          if o._tile then
            love.graphics.draw(level.map.tilesets[o._tile.tileset].image, o._currentQuad, o.x, o.y)
          end
        end
    end


    self.map:bump_init(self.world) 	--- Adds each collidable tile to the Bump world.

    self.chars = {}
    local controlled
    for k, o in ipairs(self.map.layers.objects.objects) do
      if o.type == "char" then
        local CH = require ("char."..o.name)
        local ch = CH(o.x, o.y, o.width, o.height, o.name)
        ch:load()
        self.map.layers.objects.objects[k] = ch -- FIXME
        table.insert(self.chars, ch)
        if o.properties and o.properties.controlled then controlled = ch end
      end

      if o.type == "collect" or o.type == "move" then
        o.speed = vector(0,0)
      end
    end

    for _, o in ipairs(self.map.layers.objects.objects) do
      self.world:add(o, o.x, o.y, o.width, o.height)
    end

    if controlled then controlled.isControlled = true
    elseif #self.chars > 0 then self.chars[1].isControlled = true
    end
  end,

  update = function(self, dt)
    self.map:update(dt)
    for _,o in ipairs(self.map.layers.objects.objects) do
    if o.speed and self.world:hasItem(o) then -- check if it was not removed in this same iteration by another item

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
    end
  end,

  getCollisionType = function(self, moving, other)
    local levelColType = (self.getLevelCollisionType and self:getLevelCollisionType(moving, other))

    if other.name == "door" then return 'slide' end

    if levelColType then return levelColType end
    if other.type == "action"
    or other.type == "collect"
    or other.type == "char" then
      return 'cross'
    else
      return "slide"
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
      --print("Object collision", moving.name, moving.type, ",", other.name, other.type)
      if other.type == "collect" and moving.collect and moving:collect(other) then
        self.world:remove(other)
        for k, obj in ipairs(self.map.layers.objects.objects) do
          if obj.id == other.id then table.remove(self.map.layers.objects.objects, k) end
        end
      elseif other.type == "move" then
        other.speed.x = other.speed.x - collision.normal.x * 0.5
        other.speed.y = other.speed.y - collision.normal.y *  0.5 -- dt? moving.speed?
        --moving.speed.x = moving.speed.x * 0.5
        --moving.speed.y = moving.speed.y * 0.5
      elseif other.type == "action" then
        -- level specific actions
        self:globalActions(moving, other)
        if self.action then self:action(moving, other) end
      end
    end

    if other.type ~= "collect"
      and other.type ~= "action"
      and other.type ~= "char" then
      self:physics(moving, collision)
    end
    -- object specific actions
    if moving.collision then moving:collision(other, collision) end
    if other.collision then other:collision(moving, collision) end
  end,

  globalActions = function(self, moving, other)
    if moving.type=="char" and moving.name=="shaman" and other.name == "finish" then
      self.finished = true
    end
    if moving.type=="char" and other.name == "lava" then
      print("died")
      self.dead = true
    end
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

  switchPlayer = function(self)
    if #self.chars > 1 then
      for k, ch in ipairs(self.chars) do
        if ch.isControlled then
          ch.isControlled = false
          self.chars[(k%#self.chars)+1].isControlled = true
          break
        end
      end
    end
  end,

  keypressed = function(self, key)
    if key=='tab' then self:switchPlayer() end
  end,

  draw = function(self)
    self.map:draw()
    for _,char in ipairs(self.chars) do char:draw() end
  end

}
