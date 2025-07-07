-- app/src/engine/subsystems/asset_loader/init.lua
local CacheManager   = require "app.src.engine.subsystems.asset_loader.core.cache_manager"
local LoaderRegistry = require "app.src.engine.subsystems.asset_loader.core.loader_registry"
local TypeHandlers   = require "app.src.engine.subsystems.asset_loader.core.type_handlers"

local AssetLoader = {
    registry     = LoaderRegistry,
    cache        = CacheManager,
    typeHandlers = TypeHandlers
}

TypeHandlers:register("images", function(path)
    local img = love.graphics.newImage(path)
    img:setFilter("nearest", "nearest")
    return img
end)

TypeHandlers:register("sounds",  function(path) return love.audio.newSource(path, "static") end)
TypeHandlers:register("fonts",   function(path) return love.graphics.newFont(path)          end)
TypeHandlers:register("shaders", function(path) return love.graphics.newShader(path)        end)

function AssetLoader:preload(manifest)
    for assetType, assets in pairs(manifest) do
        local handler = self.typeHandlers:get(assetType) or self.registry:get(assetType)
        if not handler then error("No handler for asset type: " .. assetType) end
        
        for name, path in pairs(assets) do
            local asset = handler(path)
            self.cache:add(assetType, name, asset)
        end
    end
end

function AssetLoader:registerLoader(assetType, loaderFn)
    self.registry:register(assetType, loaderFn)
end

function AssetLoader:load(path)
    local ext = path:match("%.(%w+)$"):lower()
    local loader = self.registry:get(ext)
    
    if loader then return loader(path) else error("No loader for extension: " .. ext) end
end

function AssetLoader:get(assetType, name)
    if name then
        return self.cache:getByType(assetType)[name] or error("Missing asset: " .. name)
    end
    return self.cache:getByType(assetType) or {}
end

function AssetLoader:image(name)  return self.get("images", name)  end
function AssetLoader:sound(name)  return self.get("sounds", name)  end
function AssetLoader:font(name)   return self.get("fonts", name)   end
function AssetLoader:shader(name) return self.get("shaders", name) end

setmetatable(AssetLoader, {
    __call = function(_, name)
        return self.cache:getByName(name) or error("Asset not found: " .. name)
    end
})

return AssetLoader