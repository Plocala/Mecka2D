-- app/src/engine/core/config/config_loader.lua
local ConfigLoader = {}

function ConfigLoader.load(path)
    if love.filesystem.getInfo(path) then
        local success, config = pcall(require, path:gsub(".lua", ""))
        return success and config or {}
    end
    return {}
end

return ConfigLoader