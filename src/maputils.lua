return {


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
    --map:setObjectSpriteBatches(map.layers.objects)

    for _, v in ipairs(world:getItems()) do
      if v.name == name then world:remove(v) end
    end
  end
}
