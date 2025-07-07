-- app/src/engine/core/config/config_validator.lua
local Logger = require("app.src.engine.core.logger")
local utils  = require("app.src.engine.core.utils")

local ConfigValidator = {
    schemas = {
        app      = require("app.src.engine.core.config.schemas.app_schema"),
        viewport = require("app.src.engine.core.config.schemas.viewport_schema"),
    }
}

function ConfigValidator.validate_section(config, schema, path)
    for key, field_schema in pairs(schema) do
        local full_path = path .. "." .. key
        local value = config[key]
        
        if value == nil then
            if field_schema.default ~= nil then
                config[key] = utils.deepCopy(field_schema.default)
                Logger.warn("Missing config: " .. full_path .. " | Using default")
            end
        else
            if field_schema.validate then
                local valid, err = field_schema.validate(value)
                if not valid then
                    Logger.warn(full_path .. ": " .. (err or "invalid value"))
                end
            end
            
            if field_schema.schema and type(value) == "table" then
                ConfigValidator.validate_section(value, field_schema.schema, full_path)
            end
        end
    end
end

function ConfigValidator.validate(config)
    for section, schema in pairs(ConfigValidator.schemas) do
        if config[section] then
            ConfigValidator.validate_section(config[section], schema, section)
        else
            config[section] = utils.deepCopy(schema.default or {})
            Logger.warn("Missing config section: " .. section .. " | Created with defaults")
        end
    end
end

return ConfigValidator