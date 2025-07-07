-- app/src/engine/ecs/entity_lifecycle.lua
local EventBus = require "app.src.engine.core.event.event_bus"

local EntityLifecycle = {}

function EntityLifecycle.publishComponentAdded(entity, component_type)
    EventBus.publish("component_added", entity, component_type)
end

function EntityLifecycle.publishComponentRemoved(entity, component_type)
    EventBus.publish("component_removed", entity, component_type)
end

function EntityLifecycle.publishEntityDestroyed(entity)
    EventBus.publish("entity_destroyed", entity)
end

return EntityLifecycle