-- app/src/engine/core/state/state_base.lua
local StateBase = {}
StateBase.__index = StateBase

function StateBase.new(name)
    return setmetatable({
        name = name,
        active = false
    }, StateBase)
end

function StateBase:pre_load()                    end
function StateBase:post_load()                   end
function StateBase:load()                        end
function StateBase:enter()                       end
function StateBase:exit()                        end
function StateBase:update(dt)                    end
function StateBase:draw()                        end
function StateBase:handle_event(event, ...)      end
function StateBase:register_events(event_router) end

return StateBase