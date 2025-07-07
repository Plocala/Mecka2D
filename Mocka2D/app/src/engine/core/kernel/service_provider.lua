-- app/src/engine/core/kernel/service_provider.lua
local ServiceProvider = {}
ServiceProvider.__index = ServiceProvider

function ServiceProvider.new()
    return setmetatable({
        _providers = {},
        _instances = {}
    }, ServiceProvider)
end

function ServiceProvider:register(name, factory)
    self._providers[name] = factory
end

function ServiceProvider:resolve(name, ...)
    if self._instances[name] then return self._instances[name] end
    local factory = self._providers[name]
    if not factory then error("Service not registered: "..name) end
    local inst = factory(...)
    self._instances[name] = inst
    return inst
end

function ServiceProvider:has(name)
    return self._providers[name] ~= nil or self._instances[name] ~= nil
end

return ServiceProvider