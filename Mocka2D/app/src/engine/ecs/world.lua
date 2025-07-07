-- app/src/engine/ecs/world.lua
local Entity = require "app.src.engine.ecs.entity"

local World = {}
World.__index = World

function World.new()
    local self = setmetatable({}, World)
    self._entities = {}
    self._tags     = {}
    self._systems  = {}
    return self
end

function World:addSystem(system)
    table.insert(self._systems, system)
end

function World:update(dt)
    for _, system in ipairs(self._systems) do
        if system.update then system:update(dt) end
    end
end

function World:draw()
    for _, system in ipairs(self._systems) do
        if system.draw then system:draw() end
    end
end

function World.add(entity, tag)
    World._entities[entity.id] = entity
    if tag then
        World._tags[tag] = World._tags[tag] or {}
        World._tags[tag][entity.id] = entity
    end
end

function World.remove(entity)
    World._entities[entity.id] = nil
    for _, entities in pairs(World._tags) do
        entities[entity.id] = nil
    end
end

function World.getByTag(tag)
    return World._tags[tag] or {}
end

function World:spawnEntity(parent_panel)
    local entity = Entity.new()
    entity.panel = parent_panel
    self._entities[entity.id] = entity
end

function World:broadcast(message, data)
    for _, entity in pairs(self._entities) do
        if entity.onMessage then entity.onMessage(message, data) end
    end
end

return World