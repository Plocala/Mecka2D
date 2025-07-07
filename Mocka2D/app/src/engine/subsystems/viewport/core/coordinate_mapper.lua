-- app/src/engine/subsystems/viewport/coordinate_mapper.lua
local CoordinatMapper = {}

CoordinatMapper.toScreen = function(x, y, scale, offsetX, offsetY) return x * scale + offsetX, y * scale + offsetY     end
CoordinatMapper.toWorld  = function(x, y, scale, offsetX, offsetY) return (x - offsetX) / scale, (y - offsetY) / scale end

return CoordinatMapper