-- app/src/engine/ecs/component/component_cache.lua
local ComponentCache = {}
ComponentCache.__index = ComponentCache

function ComponentCache.new()
    return setmetatable({
        cache = {}
    }, ComponentCache)
end

function ComponentCache:get(version)          return self.cache[version]    end
function ComponentCache:set(version, factory) self.cache[version] = factory end

return ComponentCache