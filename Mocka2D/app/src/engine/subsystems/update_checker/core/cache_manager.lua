-- app/src/engine/subsystems/update_checker/core/cache_manager.lua
local CacheManager = {}

function CacheManager.setCacheFile(path)
    CacheManager.cacheFile = path
end

function CacheManager.load()
    if not love.filesystem.getInfo(CacheManager.cacheFile) then
        return {
            love2d = {current = love._version, latest = love._version},
            lua = {current = _VERSION:match("Lua (%d+%.%d+)"), latest = "0.0"},
            lastCheck = 0
        }
    end
    
    local success, data = pcall(love.filesystem.load, CacheManager.cacheFile)
    return success and data() or {
        love2d = {current = love._version, latest = love._version},
        lua = {current = _VERSION:match("Lua (%d+%.%d+)"), latest = "0.0"},
        lastCheck = 0
    }
end

function CacheManager.save(data)
    local content = string.format(
        "return {\n"..
        "    love2d = { current = %q, latest = %q },\n"..
        "    lua = { current = %q, latest = %q },\n"..
        "    lastCheck = %d\n"..
        "}",
        data.love2d.current, data.love2d.latest,
        data.lua.current, data.lua.latest,
        data.lastCheck
    )
    love.filesystem.write(CacheManager.cacheFile, content)
end

return CacheManager