-- app/src/engine/subsystems/viewport/viewport_canvas.lua
local ViewportCanvas = {}

function ViewportCanvas.new(virtualW, virtualH, useCanvas)
    local self = {}
    local canvas = useCanvas and love.graphics.newCanvas(virtualW, virtualH) or nil

    if canvas then
        canvas:setFilter("nearest", "nearest")
    end

    function self.apply(offsetX, offsetY, scale)
        if canvas then
            love.graphics.setCanvas(canvas)
            love.graphics.clear()
        else
            love.graphics.push()
            love.graphics.translate(offsetX, offsetY)
            love.graphics.scale(scale, scale)
        end
    end

    function self.finish(offsetX, offsetY, scale)
        if canvas then
            love.graphics.setCanvas()
            love.graphics.draw(canvas, offsetX, offsetY, 0, scale, scale)
        else
            love.graphics.pop()
        end
    end

    return self
end

return ViewportCanvas