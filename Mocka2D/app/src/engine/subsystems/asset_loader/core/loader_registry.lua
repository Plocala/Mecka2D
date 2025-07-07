-- app/src/engine/subsystems/asset_loader/core/loader_registry.lua
local LoaderRegistry = { loaders = {} }

function LoaderRegistry:register(assetType, loaderFn) self.loaders[assetType] = loaderFn end
function LoaderRegistry:get(assetType)                return self.loaders[assetType]     end

return LoaderRegistry