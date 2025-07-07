-- -- app/src/engine/subsystems/update_checker/core/network_service.lua
local VersionAnalyzer = require "app.src.engine.subsystems.update_checker.core.version_analyzer"

local NetworkService = {}

function NetworkService.fetchUpdates(urls, callback)
    local pending = 2
    local results = {}
    
    -- Thread para LÖVE
    love.thread.newThread([[
        local request = love.http.newRequest("GET", ...)
        local success, response = pcall(request.perform, request)
        love.thread.getChannel("network"):push({
            type = "love2d",
            success = success,
            data = success and response:getString() or nil,
            error = not success and response or nil
        })
    ]]):start(urls.love2d)
    
    -- Thread para Lua
    love.thread.newThread([[
        local request = love.http.newRequest("GET", ...)
        local success, response = pcall(request.perform, request)
        love.thread.getChannel("network"):push({
            type = "lua",
            success = success,
            data = success and response:getString() or nil,
            error = not success and response or nil
        })
    ]]):start(urls.lua)
    
    local function process()
        while pending > 0 do
            local response = love.thread.getChannel("network"):pop()
            if not response then break end
            
            if response.success then
                if response.type == "love2d" then
                    results.love2d = {
                        current = love._version,
                        latest = VersionAnalyzer.parseLove(response.data)
                    }
                else
                    results.lua = {
                        current = _VERSION:match("Lua (%d+%.%d+)"),
                        latest = VersionAnalyzer.parseLua(response.data)
                    }
                end
            else
                results[response.type] = { error = response.error }
            end
            
            pending = pending - 1
            if pending == 0 then
                callback(VersionAnalyzer.compare(results))
            end
        end
    end
    
    NetworkService.updateHandler = process
end

function NetworkService.update()
    if NetworkService.updateHandler then
        NetworkService.updateHandler()
    end
end

return NetworkService