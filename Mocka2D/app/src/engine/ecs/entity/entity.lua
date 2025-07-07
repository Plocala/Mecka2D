-- app/src/engine/ecs/entity/entity.lua
local EntityCore       = require "app.src.engine.ecs.entity.entity_core"
local EntityLifecycle  = require "app.src.engine.ecs.entity.entity_lifecycle"
local EntitySerializer = require "app.src.engine.ecs.entity.entity_serializer"
local Kernel           = require "app.src.engine.core.kernel.kernel"

local Entity = {}
Entity.__index = setmetatable(Entity, {__index = EntityCore})

function Entity.new()
    return EntityCore.new()
end

function Entity:addComponent(component_type, ...)
    local componentFactory = Kernel.resolve("component_factory")
    local component        = componentFactory:create(component_type, ...)
    EntityCore.addComponent(self, component_type, component)
    EntityLifecycle.publishComponentAdded(self, component_type)
    return component
end

function Entity:removeComponent(component_type)
    EntityLifecycle.publishComponentRemoved(self, component_type)
    EntityCore.removeComponent(self, component_type)
end

function Entity:serialize() return EntitySerializer.serialize(self) end
function Entity:clone()     return EntitySerializer.clone(self) end

function Entity:destroy()
    EntityLifecycle.publishEntityDestroyed(self)
    for component_type in pairs(self.components) do
        self:removeComponent(component_type)
    end
end

return Entity