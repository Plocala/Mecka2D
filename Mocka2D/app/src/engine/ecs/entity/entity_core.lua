-- app/src/engine/ecs/entity/entity_core.lua
local utils = require "app.src.engine.core.utils"

local EntityCore = {}
EntityCore.__index = EntityCore

function EntityCore.new()
    local self = setmetatable({}, EntityCore)
    self.id = utils.generateId()
    self.components = {}
    return self
end

function EntityCore:addComponent(component_type, component) self.components[component_type] = component   end
function EntityCore:removeComponent(component_type)         self.components[component_type] = nil         end
function EntityCore:getComponent(component_type)            return self.components[component_type]        end
function EntityCore:hasComponent(component_type)            return self.components[component_type] ~= nil end

return EntityCore