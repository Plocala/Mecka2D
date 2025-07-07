-- app/src/engine/core/kernel/kernel.lua
local SystemRegistry    = require "app.src.engine.core.kernel.system_registry"
local ServiceProvider   = require "app.src.engine.core.kernel.service_provider"
local SystemExecutor    = require "app.src.engine.core.kernel.system_executor"
local SystemInitializer = require "app.src.engine.core.kernel.system_initializer"
local Logger            = require "app.src.engine.core.logger"

local Kernel = {
    registry    = SystemRegistry.new(),
    services    = ServiceProvider.new(),
    executor    = SystemExecutor.new(),
    initializer = SystemInitializer.new(),
    _eventBus   = nil,
    _failedSystems   = {},
    _dependencyQueue = {}
}

function Kernel.provide(name, factory)
    Kernel.services:register(name, factory)

    for systemName, _ in pairs(Kernel._dependencyQueue) do
        if Kernel._dependencyQueue[systemName] == name then
            Kernel:_tryInitializeSystem(systemName)
        end
    end
end

function Kernel.resolve(name, ...)               return Kernel.services:resolve(name, ...)         end
function Kernel.registerSystem(name, definition) Kernel.registry:add(name, definition)             end
function Kernel.onSystemRegistered(callback)     Kernel.registry:addRegistrationListener(callback) end
function Kernel.autoRegisterSystems(path)        Kernel.registry:scanDirectory(path)               end

function Kernel.init(eventBus)
    Kernel._eventBus = eventBus
    Kernel.initializer:initialize(Kernel.registry, Kernel.services, eventBus)
end

function Kernel:_tryInitializeSystem(name)
    local success, err = pcall(function()
        local system = Kernel.registry:get(name)
        if not system then return end
        
        for _, dep in ipairs(system.dependencies) do
            if not Kernel.services:has(dep) then
                Kernel._dependencyQueue[name] = dep
                Logger.warn(("System '%s' waiting for dependency: %s"):format(name, dep))
                return
            end
        end
        
        Kernel.initializer:initializeSystem(name)
        Kernel._dependencyQueue[name] = nil
    end)
    
    if not success then
        Kernel._failedSystems[name] = true
        Logger.error(("Failed to initialize system '%s': %s"):format(name, err))
    end
end

function Kernel.load()
    for name, _ in pairs(Kernel.initializer:getInitializedSystems()) do
        local system = Kernel.initializer:getSystem(name)
        if system and system.load then
            pcall(system.load, system)
        end
    end
end

function Kernel.update(dt)
    for _, name in ipairs(Kernel.initializer:getOrderedSystems()) do
        if not Kernel._failedSystems[name] then
            local system = Kernel.initializer:getSystem(name)
            if system and system.update then
                pcall(system.update, system, dt)
            end
        end
    end
end

function Kernel.draw()
    for _, name in ipairs(Kernel.initializer:getOrderedSystems()) do
        if not Kernel._failedSystems[name] then
            local system = Kernel.initializer:getSystem(name)
            if system and system.draw then
                pcall(system.draw, system)
            end
        end
    end
end

function Kernel.handleEvent(eventName, ...)
    if Kernel._eventBus then
        pcall(Kernel._eventBus.publish, Kernel._eventBus, eventName, ...)
    end
end

return Kernel