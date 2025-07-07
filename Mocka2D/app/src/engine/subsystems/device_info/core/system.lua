-- app/src/engine/subsystems/device_info/core/system.lua
local Utils = require "app.src.engine.core.utils"

local System = {}

function System.get_orientation()
    local w, h = Utils.safeCallMulti(love.graphics.getDimensions)
    return (w > h) and "landscape" or "portrait"
end

function System.get_locale()
    local lang, country = Utils.safeCallMulti(love.system.getLocale)
    return {
        language = lang    or "en",
        country  = country or ""
    }
end

function System.get_info()
    local w, h = Utils.safeCallMulti(love.graphics.getDimensions)
    local dpi  = Utils.safeCallMulti(love.window.getDPIScale) or Utils.safeCallMulti(love.graphics.getDPIScale) or 1
    
    return {
        os          = Utils.safeCall(love.system.getOS) or "Unknown",
        width       = w or 0,
        height      = h or 0,
        dpi_scale   = dpi,
        orientation = System.get_orientation(),
        locale      = System.get_locale()
    }
end

return System