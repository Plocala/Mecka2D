local utils = require "app.src.engine.core.utils"

local Interfaces = {}

function Interfaces.validate(implementation, contract)
    for method, expected_type in pairs(contract) do
        utils.validateType(
            implementation[method],
            expected_type,
            "Interface method: " .. method,
            false
        )
    end
    return true
end

Interfaces.IComponentFactory = {
    setEventBus       = "function",
    registerSystem    = "function",
    registerComponent = "function",
    create            = "function",
    release           = "function",
    checkForUpdates   = "function"
}

Interfaces.IEventBus = {
    subscribe = "function",
    publish   = "function"
}

Interfaces.IWorld = {
    addSystem   = "function",
    update      = "function",
    draw        = "function",
    add         = "function",
    remove      = "function",
    getByTag    = "function",
    spawnEntity = "function",
    broadcast   = "function"
}

return Interfaces