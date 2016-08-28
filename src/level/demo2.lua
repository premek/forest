local maputils = require "maputils"
local Signal = require 'lib.hump.signal'

return require 'lib.hump.class' {
  __includes = {require "level"},

  mapfile = "map/demo2.lua",

    action = function(self, char, item)
      if char.name == "shaman" and item.name == "door" then
        if char.inventory.key then -- TODO inventory check
          char.inventory.key = nil
          maputils.removeObjectsByName(self.map, self.world, "door")
          Signal.emit("door-open", item, char)
        else
          Signal.emit("door-locked", item, char)

          self:cutscene(function(slf, say, wait)
            local bird = self.chars[2]
            wait(2)
            say(char, "How do I open this stupid door?")
            say(char, "I don't see a key anywhere")
            say(char, "I see a bird...")
            say(char, "Hey! Bird!")
            say(bird, "What?")
            say(char, "What?")
            say(bird, "What?")
            say(char, "Talking bird, find me a key")
            say(bird, "Sure")
            say(bird, "Just press\nTab to\ncontroll me")
            say(char, "What?")
          end)

--[[
          Signal.register('object-grabbed', function()
            self:cutscene(function(slf, say, wait)
            say(self.chars[2], "I can drop the key with space key")
            say(self.chars[1], "What is the bird talking about?")
            end)
          end)
]]


        end
      end
    end,

}
