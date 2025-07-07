-- app/src/engine/ecs/component_registry.lua
local ComponentRegistry = {}
ComponentRegistry.__index = ComponentRegistry

function ComponentRegistry.new()
    return setmetatable({
        factories = {},
        versions  = {},
        hashes    = {},
        fallbacks = {}
    }, ComponentRegistry)
end

function ComponentRegistry:register(system_name, component_name, factory_fn, version)
    local key = system_name .. ":" .. component_name
    self.factories[key] = factory_fn
    self.versions[key]  = version or "legacy"
    self.fallbacks[key] = factory_fn
end

function ComponentRegistry:get_factory(key)    return self.factories[key] end
function ComponentRegistry:get_version(key)    return self.versions[key]  end
function ComponentRegistry:set_hash(key, hash) self.hashes[key] = hash    end
function ComponentRegistry:get_hash(key)       return self.hashes[key]    end

function ComponentRegistry:update_factory(key, new_factory, new_version)
    self.factories[key] = new_factory
    self.versions[key]  = new_version
end

return ComponentRegistry