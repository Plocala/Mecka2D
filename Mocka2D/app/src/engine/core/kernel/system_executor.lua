-- app/src/engine/core/kernel/system_executor.lua
local SystemExecutor = {}
SystemExecutor.__index = SystemExecutor

function SystemExecutor.new()
    return setmetatable({}, SystemExecutor)
end

function SystemExecutor:load(systems)
    for _, instance in pairs(systems) do
        if instance and instance.load then
            pcall(instance.load, instance)
        end
    end
end

function SystemExecutor:update(orderedSystems, systems, dt)
    for _, name in ipairs(orderedSystems) do
        local instance = systems[name]
        if instance and instance.update then
            pcall(instance.update, instance, dt)
        end
    end
end

function SystemExecutor:draw(orderedSystems, systems)
    for _, name in ipairs(orderedSystems) do
        local instance = systems[name]
        if instance and instance.draw then
            pcall(instance.draw, instance)
        end
    end
end

return SystemExecutor