-- app/src/engine/ecs/component/component_loader.lua
local Logger = require "app.src.engine.core.logger"
local lfs = love.filesystem

local ComponentLoader = {}
ComponentLoader.__index = ComponentLoader

function ComponentLoader.new(registry, cache, eventBus)
    return setmetatable({
        registry = registry,
        cache = cache,
        eventBus = eventBus
    }, ComponentLoader)
end

function ComponentLoader:calculate_file_hash(path)
    if not lfs.getInfo(path) then return nil end
    local content = lfs.read(path)
    local hash = 0
    for i = 1, #content do
        hash = (hash + string.byte(content, i) * 31) % 0x7FFFFFFF
    end
    return string.format("%x", hash)
end

function ComponentLoader:update_component(system_name, component_name)
    local key = system_name .. ":" .. component_name
    local file_path = self.registry.hashes[key]
    if not file_path then return false end

    local new_hash = self:calculate_file_hash(file_path)
    if not new_hash then return false end

    local current_version = self.registry:get_version(key)
    if new_hash == current_version then return false end

    package.loaded[file_path:gsub(".lua$", "")] = nil
    local success, new_factory = pcall(require, file_path:gsub(".lua$", ""))

    if success then
        self.registry:update_factory(key, new_factory, new_hash)
        self.cache:set(new_hash, new_factory)
        
        if self.eventBus then
            self.eventBus:publish("component_reloaded", {
                system = system_name,
                component = component_name,
                version = new_hash
            })
        end
        
        return true
    else
        Logger.error("Failed to reload component: " .. key, new_factory)
        return false
    end
end

function ComponentLoader:check_for_updates()
    local updated = false
    for key in pairs(self.registry.hashes) do
        local system, component = key:match("([^:]+):([^:]+)")
        if system and component then
            if self:update_component(system, component) then
                updated = true
            end
        end
    end
    return updated
end

return ComponentLoader