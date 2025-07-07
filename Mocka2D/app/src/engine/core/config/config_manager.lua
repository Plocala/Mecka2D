-- app/src/engine/core/config/config_manager.lua
local ConfigLoader    = require("app.src.engine.core.config.config_loader")
local ConfigMerger    = require("app.src.engine.core.config.config_merger")
local ConfigValidator = require("app.src.engine.core.config.config_validator")

local ConfigManager = {}
ConfigManager.__index = ConfigManager

function ConfigManager.new()
    local instance = {
        config = {},
        layers = {"base", "override", "user"}
    }
    return setmetatable(instance, ConfigManager)
end

function ConfigManager:load()
    local configs = {}
    for _, layer in ipairs(self.layers) do
        table.insert(configs, ConfigLoader.load("app/data/config_" .. layer .. ".lua"))
    end
    self.config = ConfigMerger.merge(configs)
    ConfigValidator.validate(self.config)
end

function ConfigManager:getAppName()          return self.config.app.name          end
function ConfigManager:getVersion()          return self.config.app.version       end
function ConfigManager:getWindowSettings()   return self.config.app.window        end
function ConfigManager:getPaths()            return self.config.paths             end
function ConfigManager:getAssetManifest()    return self.config.assetManifest     end
function ConfigManager:getIconPath()         return "app/assets/favicon/icon.png" end
function ConfigManager:getUpdateSettings()   return self.config.updateChecker     end
function ConfigManager:getViewportSettings() return self.config.viewport          end

return ConfigManager