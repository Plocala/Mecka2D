-- app/src/engine/subsystems/device_info/core/hardware.lua
local Utils = require "app.src.engine.core.utils"

local Hardware = {}

function Hardware.is_mobile()
    local os = Utils.safeCall(love.system.getOS) or ""
    return os == "Android" or os == "iOS"
end

function Hardware.has_touch()
    if love.touch then return true end
    
    for _, joy in ipairs(Utils.safeCallMulti(love.joystick.getJoysticks) or {}) do
        if type(joy.isTouch) == "function" and joy:isTouch() then
            return true
        end
    end
    
    return false
end

function Hardware.get_info()
    return {
        mobile  = Hardware.is_mobile(),
        touch   = Hardware.has_touch(),
        desktop = not Hardware.is_mobile()
    }
end

return Hardware