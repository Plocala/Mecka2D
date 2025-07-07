-- app/src/engine/core/state/state_loader.lua
local StateLoader = {}
StateLoader.__index = StateLoader

function StateLoader.new(paths, kernel)
    return setmetatable({
        paths = paths,
        kernel = kernel,
        registry = {}
    }, StateLoader)
end

function StateLoader:register(name, path)
    self.registry[name] = path
end

function StateLoader:scan_directory()
    local base_path = self.paths.states:gsub('%.', '/')
    
    if not love.filesystem.getInfo(base_path) then
        print("WARNING: States directory not found:", base_path)
        return
    end

    for _, filename in ipairs(love.filesystem.getDirectoryItems(base_path)) do
        if filename:match("%.lua$") then
            local name = filename:gsub("%.lua$", "")
            local path = self.paths.states .. "." .. name
            self:register(name, path)
            print("Registered state:", name, "->", path)
        end
    end
end

function StateLoader:load(name, ...)
    local path = self.registry[name]
    if not path then return nil, "State not registered" end
    
    package.loaded[path] = nil
    local success, state = pcall(require, path)
    
    if not success then return nil, state end
    if not state.name then state.name = name end
    
    state.kernel = self.kernel
    
    if state.pre_load then
        local ok, err = pcall(state.pre_load, state, ...)
        if not ok then return nil, err end
    end
    
    if state.post_load then
        pcall(state.post_load, state, ...)
    end
    
    return state
end

return StateLoader