-- app/src/engine/subsystems/device_info/core/cache.lua
local Cache = {
    data = nil,
    ttl  = 10,
    last_update = 0
}

function Cache.has()
    if not Cache.data then return false end
    return os.time() - Cache.last_update < Cache.ttl
end

function Cache.get()
    return Cache.data
end

function Cache.set(info)
    Cache.data = info
    Cache.last_update = os.time()
end

function Cache.clear()
    Cache.data = nil
end

return Cache