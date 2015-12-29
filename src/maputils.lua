return {
  removeObjectByItem = function(map, item)
    for k, obj in ipairs(map.layers.objects.objects) do
      if obj.id == item.id then
        table.remove(map.layers.objects.objects, k)
      end
    end
    table.remove(map.objects, item.id)
    map:setObjectSpriteBatches(map.layers.objects)
  end,

  removeObjectByType = function(map, world, type)
    local kept = {}
    for k, obj in ipairs(map.layers.objects.objects) do
      if obj.type == type then
        table.remove(map.objects, obj.id)
      else
        table.insert(kept, obj)
      end
    end
    map.layers.objects.objects = kept
    map:setObjectSpriteBatches(map.layers.objects)

    for _, v in ipairs(world:getItems()) do
      if v.type == type then world:remove(v) end
    end
  end
}
