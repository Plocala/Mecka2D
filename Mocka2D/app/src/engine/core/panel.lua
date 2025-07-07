-- app/src/engine/core/panel.lua
local utils = require "app.src.engine.core.utils"
local World = require "app.src.engine.ecs.world"

local Panel = {}
Panel.__index = Panel

function Panel.new(name, worldFactory, eventRouter)
    local self = setmetatable({}, Panel)
    self.id = utils.generateId()
    self.name = name
    self.world = worldFactory()
    self.eventRouter = eventRouter
    return self
end

function Panel:onEnable()  end
function Panel:onDisable() end
function Panel:onShow()    end
function Panel:onHide()    end

function Panel:setEnabled(enabled)
    if self.enabled ~= enabled then
        self.enabled = enabled
        if enabled then self:onEnable() else self:onDisable() end
    end
end

function Panel:setVisible(visible)
    if self.visible ~= visible then
        self.visible = visible
        if visible then self:onShow() else self:onHide() end
    end
end

function Panel:addSystem(system) table.insert(self.systems, system) end
function Panel:addChild(panel)   table.insert(self.children, panel); panel.parent = self end

function Panel:registerEvents()
    for event, handler in pairs(self.eventHandlers or {}) do
        self.eventRouter:register("panel:" .. event, handler)
    end
end

function Panel:destroy()
    self.world:destroyAllEntities()
    for _, child in ipairs(self.children) do child:destroy() end
end

function Panel:sendMessage(message, data)
    for _, system in ipairs(self.systems) do
        if system.onMessage then system.onMessage(message, data) end
    end
    self.world:broadcast(message, data)
    for _, child in ipairs(self.children) do
        child:sendMessage(message, data)
    end
end

function Panel:update(dt)
    if not self.enabled then return end    
    for _, system in ipairs(self.systems) do
        if system.update then
            system:update(dt)
        end
    end
    self.world:update(dt)
    for _, child in ipairs(self.children) do
        child:update(dt)
    end
end

function Panel:draw()
    if not self.visible then return end
    self.world:draw()
    for _, child in ipairs(self.children) do child:draw() end
end

function Panel:handleEvent(event, handler)
    self.eventHandlers = self.eventHandlers or {}
    self.eventHandlers[event] = handler
end

return Panel