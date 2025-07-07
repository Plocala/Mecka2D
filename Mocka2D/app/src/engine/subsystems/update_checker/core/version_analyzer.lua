-- app/src/engine/subsystems/update_checker/core/version_analyzer.lua
local VersionAnalyzer = {}

function VersionAnalyzer.parseLove(data)
    local latest = "0.0.0"
    for tag in data:gmatch('"refs/tags/(%d+%.%d+%.?%d*)"') do
        if tag > latest then latest = tag end
    end
    return latest
end

function VersionAnalyzer.parseLua(data)
    local major, minor = data:match('<h3>Lua (%d)%.(%d)</h3>')
    return major and minor and major.."."..minor or "0.0"
end

function VersionAnalyzer.compare(results)
    results.love2d.updateAvailable = VersionAnalyzer.isNewer(
        results.love2d.current, 
        results.love2d.latest
    )
    
    results.lua.updateAvailable = VersionAnalyzer.isNewer(
        results.lua.current, 
        results.lua.latest
    )
    
    return results
end

function VersionAnalyzer.isNewer(current, latest)
    local c_maj, c_min = current:match("(%d+)%.(%d+)")
    local l_maj, l_min = latest:match("(%d+)%.(%d+)")
    return tonumber(l_maj) > tonumber(c_maj) or (tonumber(l_maj) == tonumber(c_maj) and tonumber(l_min) > tonumber(c_min))
end

return VersionAnalyzer