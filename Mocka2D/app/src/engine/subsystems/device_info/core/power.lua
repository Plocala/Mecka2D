-- app/src/engine/subsystems/device_info/core/power.lua
local Utils = require "app.src.engine.core.utils"

local Power = {}

function Power.get_info()
    local state, percent = Utils.safeCallMulti(love.system.getPowerInfo)
    return {
        state   = state   or "unknown",
        percent = percent or -1
    }
end

return Power