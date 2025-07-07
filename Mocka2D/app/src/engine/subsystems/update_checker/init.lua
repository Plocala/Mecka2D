-- app/src/engine/subsystems/update_checker/init.lua
local CacheManager        = require "app.src.engine.subsystems.update_checker.core.cache_manager"
local NetworkService      = require "app.src.engine.subsystems.update_checker.core.network_service"
local VersionAnalyzer     = require "app.src.engine.subsystems.update_checker.core.version_analyzer"
local NotificationService = require "app.src.engine.subsystems.update_checker.core.notification_service"

local UpdateChecker = {
    checkInterval = 86400,
    isChecking = false
}

function UpdateChecker.init(config)
    UpdateChecker.config = config
    CacheManager.setCacheFile(config.cacheFile)
    UpdateChecker.results = CacheManager.load()
end

function UpdateChecker.checkForUpdates(callback)
    if UpdateChecker.isChecking then return end
    if os.time() - UpdateChecker.results.lastCheck < UpdateChecker.checkInterval then
        if callback then callback(UpdateChecker.results) end
        return
    end
    
    UpdateChecker.isChecking = true
    NetworkService.fetchUpdates(UpdateChecker.config.urls, function(results)
        UpdateChecker.results = results
        UpdateChecker.results.lastCheck = os.time()
        CacheManager.save(UpdateChecker.results)
        UpdateChecker.isChecking = false
        if callback then callback(results) end
    end)
end

function UpdateChecker.showNotifications()
    return NotificationService.generate(UpdateChecker.results)
end

return UpdateChecker