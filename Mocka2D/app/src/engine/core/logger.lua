-- app/src/engine/core/logger.lua
local Logger = {}

local levels = { DEBUG = 1, INFO = 2, WARN = 3, ERROR = 4, NONE = 5 }
Logger.level = "INFO"

function Logger.setLevel(lvl)
    assert(levels[lvl], "Logger.setLevel: invalid level '" .. tostring(lvl) .. "'")
    Logger.level = lvl
end

local function _shouldLog(lvl)
    return levels[lvl] >= levels[Logger.level]
end

local function _log(lvl, ...)
    if _shouldLog(lvl) then
        local msg = table.concat({ ... }, " ")
        print(string.format("[%s] %s", lvl, msg))
    end
end

for lvl in pairs(levels) do
    Logger[lvl:lower()] = function(...)
        _log(lvl, ...)
    end
end

return Logger