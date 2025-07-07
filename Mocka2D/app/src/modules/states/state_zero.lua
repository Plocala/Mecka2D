-- app/src/modules/states/state_zero.lua
local Panel = require("app.src.engine.core.panel")
local App   = require("app.src.engine.core.app")

local state = {
    name = "state_zero",
    rootPanel = Panel.new("state_zero"),
    timer = 0  -- Inicializa o timer aqui
}

function state:enter()
    -- Resetar o timer ao entrar no estado
    self.timer = 0
    print("Entrou no state_zero")
end

function state:update(dt)
end

function state:mousepressed(x, y, button)
    if button == 1 then
        App.eventRouter:dispatch("secret_found", "chave_secreta")
    end
end

function state:registerEvents(eventRouter)
    eventRouter:register("statemanager:mousepressed", 
        function(...) 
            self:mousepressed(...) 
        end,
        10, self
    )
end

return state