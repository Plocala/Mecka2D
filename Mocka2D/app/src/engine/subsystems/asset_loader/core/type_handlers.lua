-- app/src/engine/subsystems/asset_loader/core/type_handlers.lua
local TypeHandlers = { default = {} }

function TypeHandlers:register(assetType, handler) self.default[assetType] = handler end
function TypeHandlers:get(assetType)               return self.default[assetType]    end

return TypeHandlers