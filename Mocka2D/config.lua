local ConfigManager = require("app.src.engine.core.config.config_manager")

local config = ConfigManager.new()
config:load()

return config