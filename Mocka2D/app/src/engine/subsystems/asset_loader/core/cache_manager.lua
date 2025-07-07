-- app/src/engine/subsystems/asset_loader/core/cache_manager.lua
local CacheManager = {
    byType = {},
    byName = {}
}

function CacheManager:add(assetType, name, asset)
    if self.byName[name] then error("Duplicate asset name: " .. name) end
    
    self.byType[assetType] = self.byType[assetType] or {}
    self.byType[assetType][name] = asset
    self.byName[name] = asset
end

function CacheManager:getByType(assetType) return self.byType[assetType] or {} end
function CacheManager:getByName(name)      return self.byName[name]            end

function CacheManager:clear()
    self.byType = {}
    self.byName = {}
end

return CacheManager