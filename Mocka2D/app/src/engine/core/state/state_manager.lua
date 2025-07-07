-- app/src/engine/core/state/state_manager.lua
local StateCache  = require("app.src.engine.core.state.state_cache")
local StateFlow   = require("app.src.engine.core.state.state_flow")
local StateLoader = require("app.src.engine.core.state.state_loader")

local StateManager = {}
StateManager.__index = StateManager

function StateManager.new(event_router, kernel, paths)
    local cache  = StateCache.new(5)
    local flow   = StateFlow.new()
    local loader = StateLoader.new(paths, kernel)
    
    loader:scan_directory()
    
    return setmetatable({
        current      = nil,
        previous     = nil,
        loader       = loader,
        cache        = cache,
        flow         = flow,
        event_router = event_router,
        kernel       = kernel
    }, StateManager)
end

function StateManager:switch(name, ...)
    local state = self.cache:get(name) or self.loader:load(name, ...)
    if not state then return false end
    if self.current and self.current.exit then
        self.current:exit()
    end
    
    self.previous = self.current
    self.current = state
    
    local config = self.flow:get_config(name)
    if config.keep_previous and self.previous then
        self.cache:set(self.previous.name, self.previous)
    end
    if self.current.register_events then
        self.current:register_events(self.event_router)
    end
    
    if self.current.load  then self.current:load(...)  end
    if self.current.enter then self.current:enter(...) end
    
    local eventBus = self.kernel.resolve("event_bus")
    eventBus:publish("state_changed", {
        previous = self.previous and self.previous.name,
        current = name
    })
    
    return true
end

function StateManager:update(dt) if self.current and self.current.update then self.current:update(dt) end end
function StateManager:draw()     if self.current and self.current.draw   then self.current:draw()     end end

function StateManager:handle_event(event, ...)
    if not self.current then return false end
    
    local next_state = self.flow:handle_event(event, self.current.name, ...)
    if next_state then return self:switch(next_state, ...)
    else               self.event_router:dispatch("state:" .. event, ...) end

    return false
end

function StateManager:back()
    local previous = self.flow:back()
    if previous then
        return self:switch(previous)
    end
    return false
end

function StateManager:configure_flow(config_func) config_func(self.flow) end

return StateManager