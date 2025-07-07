-- app/src/engine/core/kernel/system_initializer.lua
local DependencySorter = require "app.src.engine.core.kernel.dependency_sorter"
local Logger           = require "app.src.engine.core.logger"

local SystemInitializer = {}
SystemInitializer.__index = SystemInitializer

function SystemInitializer.new()
    return setmetatable({
        _orderedSystems     = {},
        _initializedSystems = {},
        _registry = nil,
        _services = nil,
        _eventBus = nil
    }, SystemInitializer)
end

function SystemInitializer:initialize(registry, services, eventBus)
    self._registry = registry
    self._services = services
    self._eventBus = eventBus

    self._orderedSystems = DependencySorter.topologicalSort(registry:getAll())
    
    for _, name in ipairs(self._orderedSystems) do
        self:initializeSystem(name)
    end
end

function SystemInitializer:initializeSystem(name)
    local system = self._registry:get(name)
    if not system then return end
    
    local context = {}
    for _, dep in ipairs(system.dependencies) do
        if self._services:has(dep) then
            context[dep] = self._services:resolve(dep)
        else
            Logger.warn(("Dependency '%s' not available for system '%s'"):format(dep, name))
            return nil
        end
    end
    
    local success, instance = pcall(system.definition.newSystem, context, self._eventBus)
    if not success then
        Logger.error(("Failed to create system '%s': %s"):format(name, instance))
        return nil
    end
    
    self._initializedSystems[name] = instance
    
    if instance.registerEvents then
        pcall(function()
            local router = self._services:resolve("event_router")
            instance:registerEvents(router)
        end)
    end
    
    return instance
end

function SystemInitializer:getOrderedSystems()     return self._orderedSystems           end
function SystemInitializer:getInitializedSystems() return self._initializedSystems       end
function SystemInitializer:getSystem(name)         return self._initializedSystems[name] end

return SystemInitializer