-- app/src/engine/subsystems/device_info/init.lua
local Hardware = require "app.src.engine.subsystems.device_info.core.hardware"
local Graphics = require "app.src.engine.subsystems.device_info.core.graphics"
local System   = require "app.src.engine.subsystems.device_info.core.system"
local Power    = require "app.src.engine.subsystems.device_info.core.power"
local Cache    = require "app.src.engine.subsystems.device_info.core.cache"

local DeviceInfo = {}

function DeviceInfo.get_info()
    if Cache.has() then return Cache.get() end
    
    local info = {
        hardware  = Hardware.get_info(),
        graphics  = Graphics.get_info(),
        system    = System.get_info(),
        power     = Power.get_info(),
        timestamp = os.time()
    }
    
    Cache.set(info)
    return info
end

DeviceInfo.is_mobile       = Hardware.is_mobile
DeviceInfo.has_touch       = Hardware.has_touch
DeviceInfo.get_orientation = System.get_orientation
DeviceInfo.get_locale      = System.get_locale
DeviceInfo.get_power_info  = Power.get_info

return DeviceInfo