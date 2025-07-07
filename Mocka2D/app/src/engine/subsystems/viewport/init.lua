-- app/src/engine/subsystems/viewport/init.lua
local CoordinateMapper = require "app.src.engine.subsystems.viewport.core.coordinate_mapper"
local ViewportManager  = require "app.src.engine.subsystems.viewport.core.viewport_manager"

local manager = ViewportManager.new()

local Viewport = {
    initialized = false
}

function Viewport.init(opts)
    manager:init(opts)
    Viewport.initialized = true
    return Viewport
end

Viewport.toScreen = function(x, y) return CoordinateMapper.toScreen(x, y, manager.scale, manager.offsetX, manager.offsetY) end
Viewport.toWorld  = function(x, y) return CoordinateMapper.toWorld(x, y, manager.scale, manager.offsetX, manager.offsetY)  end
function Viewport.isInitialized()  return Viewport.initialized end
function Viewport.setSafeArea(left, right, top, bottom) manager:setSafeArea(left, right, top, bottom) end
function Viewport.resize(w, h)                          manager:resize(w, h)                          end
function Viewport.apply()                               manager:apply()                               end
function Viewport.finish()                              manager:finish()                              end

local scaleCache = {}
function Viewport.getScale(w, h)
    local key = w.."x"..h
    if not scaleCache[key] then 
        scaleCache[key] = manager:getScale(w, h) 
    end
    return scaleCache[key]
end

Viewport.getOffset            = function() return manager:getOffset()            end
Viewport.getVirtualDimensions = function() return manager:getVirtualDimensions() end

return Viewport