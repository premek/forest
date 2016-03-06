return {


  removeObjectsByName = function(map, world, name)
    local filtered = {}
    for _, obj in ipairs(map.layers.objects.objects) do
      if obj.name ~= name then
        table.insert(filtered, obj)
      end
    end
    map.layers.objects.objects = filtered

    --map:setObjectSpriteBatches(map.layers.objects)

    for _, v in ipairs(world:getItems()) do
      if v.name == name then world:remove(v) end
    end
  end
}
