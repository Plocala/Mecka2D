-- app/src/engine/core/state/state_cache.lua
local StateCache = {}
StateCache.__index = StateCache

function StateCache.new(max_size)
    return setmetatable({
        cache = {},
        max_size = max_size or 5,
        lru = {}
    }, StateCache)
end

function StateCache:has(name)
    return self.cache[name] ~= nil
end

function StateCache:get(name)
    if not self.cache[name] then return nil end
    
    for i, n in ipairs(self.lru) do
        if n == name then
            table.remove(self.lru, i)
            break
        end
    end
    table.insert(self.lru, name)
    
    return self.cache[name]
end

function StateCache:set(name, state)
    if self.cache[name] then return end
    
    if #self.lru >= self.max_size then
        local oldest = table.remove(self.lru, 1)
        self.cache[oldest] = nil
    end
    
    self.cache[name] = state
    table.insert(self.lru, name)
end

function StateCache:remove(name)
    if not self.cache[name] then return end
    
    self.cache[name] = nil
    for i, n in ipairs(self.lru) do
        if n == name then
            table.remove(self.lru, i)
            break
        end
    end
end

return StateCache