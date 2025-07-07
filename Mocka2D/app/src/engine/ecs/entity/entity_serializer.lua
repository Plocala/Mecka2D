-- app/src/engine/ecs/entity/entity_serializer.lua
local utils = require "app.src.engine.core.utils"

local EntitySerializer = {}

function EntitySerializer.serialize(entity)
    local components = {}
    for name, comp in pairs(entity.components) do
        components[name] = comp
    end
    return {id = entity.id, components = components}
end

function EntitySerializer.clone(entity)
    local clone = require("app.src.engine.ecs.entity_core").new()
    for comp_type, comp in pairs(entity.components) do
        clone:addComponent(comp_type, utils.deepCopy(comp))
    end
    return clone
end

return EntitySerializer