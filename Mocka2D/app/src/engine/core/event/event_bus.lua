-- app/src/engine/core/event/event_bus.lua
local EventBus = {}
EventBus.__index = EventBus

function EventBus.new()
    return setmetatable({
        _subscribers = {}
    }, EventBus)
end

function EventBus:subscribe(event, callback, priority)
    priority = priority or 0
    self._subscribers[event] = self._subscribers[event] or {}
    table.insert(self._subscribers[event], {
        callback = callback,
        priority = priority
    })
    table.sort(self._subscribers[event], function(a, b)
        return a.priority > b.priority
    end)
end

function EventBus:publish(event, ...)
    local subs = self._subscribers[event]
    if not subs then return end
    for _, sub in ipairs(subs) do
        sub.callback(...)
    end
end

return EventBus