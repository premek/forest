return {
  moveObjectByItem = function(map, item)
    for k, obj in ipairs(map.layers.objects.objects) do
      if obj.id == item.id then
        map.layers.objects.objects[k].x = item.x
        map.layers.objects.objects[k].y = item.y+item.height
      end
    end
    map.objects[item.id].x = item.x
    map.objects[item.id].y = item.y+item.height
    map:setObjectSpriteBatches(map.layers.objects)
  end,

  removeObjectByItem = function(map, item)
    for k, obj in ipairs(map.layers.objects.objects) do
      if obj.id == item.id then
        table.remove(map.layers.objects.objects, k)
      end
    end
    table.remove(map.objects, item.id)
    map:setObjectSpriteBatches(map.layers.objects)
  end,

  removeObjectsByName = function(map, world, name)
    local kept = {}
    for _, obj in ipairs(map.layers.objects.objects) do
      if obj.name == name then
        table.remove(map.objects, obj.id)
      else
        table.insert(kept, obj)
      end
    end
    map.layers.objects.objects = kept
    map:setObjectSpriteBatches(map.layers.objects)

    for _, v in ipairs(world:getItems()) do
      if v.name == name then world:remove(v) end
    end
  end
}
