-- app/src/engine/subsystems/update_checker/core/notification_service.lua
local NotificationService = {}

function NotificationService.generate(results)
    local notifications = {}
    
    if results.love2d.updateAvailable then
        table.insert(notifications, {
            text = string.format("New version of LÖVE: %s (atual: %s)", 
                results.love2d.latest, 
                results.love2d.current),
            color = {0.2, 0.6, 1}
        })
    end
    
    if results.lua.updateAvailable then
        table.insert(notifications, {
            text = string.format("New version of Lua: %s (atual: %s)", 
                results.lua.latest, 
                results.lua.current),
            color = {0.8, 0.4, 0.1}
        })
    end
    
    return notifications
end

return NotificationService