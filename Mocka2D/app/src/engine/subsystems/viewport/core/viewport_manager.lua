-- app/src/engine/subsystems/viewport/viewport_manager.lua
local Device          = require("app.src.engine.subsystems.device_info.init")
local ScalingStrategy = require("app.src.engine.subsystems.viewport.core.scaling_strategy")
local ViewportCanvas  = require("app.src.engine.subsystems.viewport.core.viewport_canvas")

local ViewportManager = {}
ViewportManager.__index = ViewportManager

function ViewportManager.new()
    local self = setmetatable({}, ViewportManager)
    
    self.virtualW    = 1280
    self.virtualH    = 720
    self.scale       = 1
    self.offsetX     = 0
    self.offsetY     = 0
    self.currentMode = "auto"
    self.safeArea    = { left = 0.05, right = 0.05, top = 0.05, bottom = 0.05 }
    self.canvasManager = nil
    self.initialized = false
    
    return self
end

function ViewportManager:init(opts)
    opts = opts or {}
    self.virtualW    = opts.virtualW or self.virtualW
    self.virtualH    = opts.virtualH or self.virtualH
    self.currentMode = opts.mode     or self.currentMode
    self.safeArea    = opts.safeArea or self.safeArea

    if self.currentMode == "auto" then
        self.currentMode = Device.is_mobile() and "crop" or "letterbox"
    end

    if Device.is_mobile() and not love.window.getFullscreen() then
        love.window.setFullscreen(true)
    end

    local useCanvas = opts.useCanvas ~= false and Device.get_info().supportsCanvas
    self.canvasManager = ViewportCanvas.new(
        self.virtualW, self.virtualH, useCanvas
    )

    self:resize(love.graphics.getDimensions())
    self.initialized = true
end

function ViewportManager:resize(w, h)
    if Device.is_mobile() then
        w, h = love.graphics.getDimensions()
    end

    local strategy = ScalingStrategy[self.currentMode]
    if strategy then
        self.scale, self.offsetX, self.offsetY = strategy(w, h, self.virtualW, self.virtualH, self.safeArea)
    else
        self.scale, self.offsetX, self.offsetY = ScalingStrategy.letterbox(w, h, self.virtualW, self.virtualH)
    end
end

function ViewportManager:setSafeArea(left, right, top, bottom)
    self.safeArea = {
        left = left or self.safeArea.left,
        right = right or self.safeArea.right,
        top = top or self.safeArea.top,
        bottom = bottom or self.safeArea.bottom
    }
    self:resize(love.graphics.getDimensions())
end

function ViewportManager:getScale(w, h)         return math.min(w / self.virtualW, h / self.virtualH) end
function ViewportManager:getOffset()            return self.offsetX, self.offsetY                     end
function ViewportManager:getVirtualDimensions() return self.virtualW, self.virtualH                   end
function ViewportManager:getScaleValue()        return self.scale                                     end

function ViewportManager:apply()
    if not self.canvasManager then error("canvasManager not initialized. Call init() first.") end
    self.canvasManager.apply(self.offsetX, self.offsetY, self.scale)
end
function ViewportManager:finish()
    if not self.canvasManager then error("canvasManager not initialized. Call init() first.") end
    self.canvasManager.finish(self.offsetX, self.offsetY, self.scale)
end

return ViewportManager