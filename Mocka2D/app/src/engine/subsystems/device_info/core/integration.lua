-- app/src/engine/subsystems/update_checker/integration.lua
local ConfigLoader = require("app.src.engine.core.config_loader")
local UpdateChecker = require("app.src.engine.subsystems.update_checker.init")

local function bootstrap()
    local base     = ConfigLoader.load("app/data/config_base.lua")
    local override = ConfigLoader.load("app/data/config_override.lua")
    local user     = ConfigLoader.load("app/data/config_user.lua")
    
    local config = {
        updateChecker = utils.mergeTables(
            utils.mergeTables(base.updateChecker or {}, override.updateChecker or {}),
            user.updateChecker or {}
        )
    }
    
    UpdateChecker.init(config.updateChecker)
end

local function update(dt)
    UpdateChecker.process()
end

return {
    bootstrap   = bootstrap,
    update      = update,
    get_checker = function() return UpdateChecker end
}