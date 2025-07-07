-- main.lua
local App = require("app.src.engine.core.app")

function love.load()
    print("Starting bootstrap...")
    App.bootstrap()

    print("Loading resources...")
    App.load()
    
    print("Starting state state_zero...")
    App.start("state_zero")
    
    print("Execution started successfully!")
end

function love.update(dt)
    App.update(dt)
end

function love.draw()
    App.draw()
end

-- Callbacks
local loveEvents = {
    -- Input
    "keypressed", "keyreleased",
    "mousepressed", "mousereleased",
    "mousemoved", "wheelmoved",
    "touchpressed", "touchreleased",
    "textinput",

    -- Window / focus
    "focus", "visible",
    "resize",

    -- Joystick / gamepad
    "joystickadded", "joystickremoved",
    "joystickaxis", "joystickhat", "joystickpressed", "joystickreleased",

    -- Misc
    "lowmemory", "threaderror"
}

for _, ev in ipairs(loveEvents) do
    love[ev] = function(...)
        App.handleInput(ev, ...)
    end
end