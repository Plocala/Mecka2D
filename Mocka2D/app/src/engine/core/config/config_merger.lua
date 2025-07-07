-- app/src/engine/core/config/config_merger.lua
local utils = require("app.src.engine.core.utils")

local ConfigMerger = {}

function ConfigMerger.merge(configs)
    local merged = {}
    for _, config in ipairs(configs) do
        merged = utils.mergeTables(merged, config)
    end
    return merged
end

return ConfigMerger