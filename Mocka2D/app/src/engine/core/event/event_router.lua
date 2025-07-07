-- app/src/engine/core/event/event_router.lua
local EventRouter = {}
EventRouter.__index = EventRouter

function EventRouter.new()
    return setmetatable({
        handlers = {}
    }, EventRouter)
end

function EventRouter:register(event, handler, priority, module)
    self.handlers[event] = self.handlers[event] or {}
    table.insert(self.handlers[event], {
        handler = handler,
        priority = priority or 0,
        module = module
    })
    table.sort(self.handlers[event], function(a, b)
        return a.priority > b.priority
    end)
end

function EventRouter:dispatch(event, ...)
    if not self.handlers[event] then return false end
    for _, h in ipairs(self.handlers[event]) do
        local handled = h.handler(...)
        if handled then return true end
    end
    return false
end

return EventRouter