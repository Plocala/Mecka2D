-- app/src/engine/ecs/component/component_factory.lua
local PoolManager = require "app.src.engine.ecs.pool_manager"
local Logger      = require "app.src.engine.core.logger"
local utils       = require "app.src.engine.core.utils"

local ComponentRegistry = require "app.src.engine.ecs.component.component_registry"
local ComponentCache    = require "app.src.engine.ecs.component.component_cache"
local ComponentLoader   = require "app.src.engine.ecs.component.component_loader"

local ComponentFactory = {}
ComponentFactory.__index = ComponentFactory

function ComponentFactory.new()
    return setmetatable({
        registry = ComponentRegistry.new(),
        cache    = ComponentCache.new(),
        loader   = nil
    }, ComponentFactory)
end

function ComponentFactory:setEventBus(bus)
    self.loader = ComponentLoader.new(
        self.registry,
        self.cache,
        bus
    )
end

function ComponentFactory:registerSystem(system, components)
    for _, comp in ipairs(components) do
        local file_path = comp.file_path
        local version   = "legacy"
        
        if file_path and love.filesystem.getInfo(file_path) then
            local hash = self.loader:calculate_file_hash(file_path)
            if hash then
                version = hash
                self.registry:set_hash(system .. ":" .. comp.type, file_path)
                self.cache:set(hash, comp.factory)
            end
        end
        
        self:registerComponent(
            system,
            comp.type,
            comp.factory,
            comp.pool and PoolManager.register,
            comp.reset,
            version
        )
    end
end

function ComponentFactory:registerComponent(system_name, component_name, factory_fn, pool_fn, reset_fn, version)
    local key = system_name .. ":" .. component_name
    self.registry:register(system_name, component_name, factory_fn, version)
    
    if pool_fn then
        pool_fn(key .. ":" .. version, factory_fn, reset_fn)
    end
end

function ComponentFactory:create(system_name, component_name, ...)
    local key = system_name .. ":" .. component_name
    local version = self.registry:get_version(key) or "legacy"
    
    if version ~= "legacy" and PoolManager._pools[key .. ":" .. version] then
        return PoolManager.acquire(key .. ":" .. version, ...)
    end
    
    local factory = self.registry:get_factory(key)
    if factory then return factory(...) end
    
    Logger.error("Component factory not found: " .. key)
    return setmetatable({
        _isFallback = true,
        _error = "Failed to load component: " .. component_name
    }, {
        __index = function(_, k)
            Logger.error("Accessing fallback component: " .. component_name)
            return nil
        end
    })
end

function ComponentFactory:release(system_name, component_name, comp)
    local key = system_name .. ":" .. component_name
    local version = self.registry:get_version(key) or "legacy"
    
    if version ~= "legacy" and PoolManager._pools[key .. ":" .. version] then
        PoolManager.release(key .. ":" .. version, comp)
    end
end

function ComponentFactory:checkForUpdates()
    if not self.loader then
        Logger.warn("Component loader not initialized. Call setEventBus first.")
        return false
    end
    return self.loader:check_for_updates()
end

return ComponentFactory