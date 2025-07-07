-- app/src/engine/core/kernel/system_registry.lua
local lfs = love.filesystem

local SystemRegistry = {}
SystemRegistry.__index = SystemRegistry

function SystemRegistry.new()
    return setmetatable({
        _systems   = {},
        _callbacks = { onRegistration = {} }
    }, SystemRegistry)
end

function SystemRegistry:add(name, definition)
    self._systems[name] = {
        definition = definition,
        dependencies = definition.dependencies or {},
        priority = definition.priority or 0
    }
    
    for _, callback in ipairs(self._callbacks.onRegistration) do
        callback(name, definition)
    end
end

function SystemRegistry:addRegistrationListener(callback)
    table.insert(self._callbacks.onRegistration, callback)
end

function SystemRegistry:scanDirectory(path)
    for _, folder in ipairs(lfs.getDirectoryItems(path)) do
        local initFile = path.."/"..folder.."/init.lua"
        if lfs.getInfo(initFile) then
            local modpath = initFile:gsub("%.lua$", ""):gsub("/", ".")
            local sysDef  = require(modpath)
            self:add(sysDef.name, sysDef)
        end
    end
end

function SystemRegistry:get(name) return self._systems[name] end
function SystemRegistry:getAll()  return self._systems       end

return SystemRegistry