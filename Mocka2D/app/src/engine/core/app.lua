-- app/src/engine/core/app.lua
local AssetLoader      = require "app.src.engine.subsystems.asset_loader.init"
local ComponentFactory = require "app.src.engine.ecs.component.component_factory"
local Config           = require "config"
local EventBus         = require "app.src.engine.core.event.event_bus"
local EventRouter      = require "app.src.engine.core.event.event_router"
local Kernel           = require "app.src.engine.core.kernel.kernel"
local Logger           = require "app.src.engine.core.logger"
local NetworkService   = require "app.src.engine.subsystems.update_checker.core.network_service"
local StateManager     = require "app.src.engine.core.state.state_manager"
local Viewport         = require "app.src.engine.subsystems.viewport.init"

local App = {
    config       = Config,
    eventBus     = EventBus.new(),
    eventRouter  = EventRouter.new(),
    stateManager = nil
}

function App.bootstrap()
    Logger.setLevel("INFO")
    local win = Config:getWindowSettings()
    love.window.setTitle(win.title)
    love.window.setMode(win.width, win.height, { fullscreen = win.fullscreen, resizable = win.resizable })

    local iconPath = Config:getIconPath()
    local success, iconData = pcall(love.image.newImageData, iconPath)
    if success then love.window.setIcon(iconData) end

    -- Cria instância da ComponentFactory
    local componentFactory = ComponentFactory.new()
    
    Kernel.provide("world",             function() return require("app.src.engine.ecs.world").new() end)
    Kernel.provide("asset_loader",      function() return AssetLoader      end)
    Kernel.provide("viewport",          function() return Viewport         end)
    Kernel.provide("event_bus",         function() return App.eventBus     end)
    Kernel.provide("event_router",      function() return App.eventRouter  end)
    Kernel.provide("component_factory", function() return componentFactory end)

    Viewport.init(Config:getViewportSettings())
    componentFactory:setEventBus(App.eventBus)

    App.stateManager = StateManager.new(
        App.eventRouter, 
        Kernel, 
        Config:getPaths()
    )
    
    local flowConfig = require("app.data.state_flow")
    flowConfig.configure(App.stateManager.flow)
    App.stateManager.loader:scan_directory()
end

function App.start(stateName, ...)
    App.stateManager:switch(stateName, ...)
end

function App.load()
    Kernel.init(App.eventBus)
    Kernel.load()
end

function App.update(dt)
    NetworkService.update()
    Kernel.update(dt)
    App.stateManager:update(dt)
end

function App.draw()
    Viewport.apply()
    Kernel.draw()
    App.stateManager:draw()
    Viewport.finish()
end

function App.handleInput(eventName, ...)
    local handled = App.stateManager:handle_event(eventName, ...)
    if handled then return end
    handled = App.eventRouter:dispatch("kernel:" .. eventName, ...)
    if handled then return end
    App.eventRouter:dispatch("panel:" .. eventName, ...)
end

return App