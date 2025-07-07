-- app/src/engine/core/event/event_utils.lua
local EventUtils = {}

function EventUtils.create_context(bus, router)
    return {
        subscribe = function(event, callback, priority)
            bus:subscribe(event, callback, priority)
        end,
        publish = function(event, ...)
            bus:publish(event, ...)
        end,
        register = function(event, handler, priority, module)
            router:register(event, handler, priority, module)
        end,
        dispatch = function(event, ...)
            return router:dispatch(event, ...)
        end
    }
end

return EventUtils