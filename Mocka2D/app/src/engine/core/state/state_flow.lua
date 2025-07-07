-- app/src/engine/core/state/state_flow.lua
local StateFlow = {}
StateFlow.__index = StateFlow

function StateFlow.new()
    return setmetatable({
        transitions = {},
        history = {},
        state_configs = {}
    }, StateFlow)
end

function StateFlow:add_transition(event, from, to, condition)
    self.transitions[event] = self.transitions[event] or {}
    table.insert(self.transitions[event], {
        from = from,
        to = to,
        condition = condition or function() return true end
    })
end

function StateFlow:configure_state(state, config)
    self.state_configs[state] = config
end

function StateFlow:get_config(state)
    return self.state_configs[state] or {}
end

function StateFlow:handle_event(event, current_state, ...)
    local transitions = self.transitions[event] or {}
    
    for _, t in ipairs(transitions) do
        if (t.from == "*" or t.from == current_state) and t.condition(...) then
            table.insert(self.history, current_state)
            return t.to
        end
    end
    
    return nil
end

function StateFlow:back()
    if #self.history == 0 then return nil end
    return table.remove(self.history)
end

return StateFlow