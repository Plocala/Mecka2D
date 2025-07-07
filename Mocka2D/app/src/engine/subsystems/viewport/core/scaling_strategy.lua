-- app/src/engine/subsystems/viewport/scaling_strategy.lua
local ScalingStrategy = {}

ScalingStrategy.letterbox = function(realW, realH, virtualW, virtualH)
    local scale = math.min(realW / virtualW, realH / virtualH)
    local newWidth  = virtualW * scale
    local newHeight = virtualH * scale
    return scale, (realW - newWidth) * 0.5, (realH - newHeight) * 0.5
end

ScalingStrategy.crop = function(realW, realH, virtualW, virtualH)
    local scale = math.max(realW / virtualW, realH / virtualH)
    local newWidth  = virtualW * scale
    local newHeight = virtualH * scale
    return scale, (realW - newWidth) * 0.5, (realH - newHeight) * 0.5
end

ScalingStrategy.safe = function(realW, realH, virtualW, virtualH, safeArea)
    local safeW = realW * (1 - safeArea.left - safeArea.right)
    local safeH = realH * (1 - safeArea.top - safeArea.bottom)
    local scale = math.min(safeW / virtualW, safeH / virtualH)
    return scale, realW * safeArea.left, realH * safeArea.top
end

return ScalingStrategy