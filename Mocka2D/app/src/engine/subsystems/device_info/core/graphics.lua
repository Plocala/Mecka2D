-- app/src/engine/subsystems/device_info/core/graphics.lua
local Utils = require "app.src.engine.core.utils"

local Graphics = {}

function Graphics.get_info()
    local max_texture = select(1, Utils.safeCallMulti(love.graphics.getSystemLimits)) or 0
    local canvas_fmt  = Utils.safeCall(love.graphics.getCanvasFormats)                or {}
    local supported   = Utils.safeCall(love.graphics.getSupported)                    or {}
    
    return {
        max_texture_size = max_texture,
        canvas_formats   = canvas_fmt,
        supports = {
            canvas  = supported.canvas                 or false,
            compute = supported.compute                or false,
            astc    = supported.textureCompressionASTC or false
        },
        renderer = Utils.safeCall(love.graphics.getRendererInfo) or {},
        device   = Utils.safeCall(love.graphics.getDeviceInfo)   or {}
    }
end

return Graphics