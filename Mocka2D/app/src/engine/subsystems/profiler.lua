-- app/src/engine/subsystems/profiler.lua
local Profiler = {
    _timers = {},
    _history = {}
}

function Profiler.start(name)
    Profiler._timers[name] = love.timer.getTime()
end

function Profiler.stop(name)
    if Profiler._timers[name] then
        local duration = love.timer.getTime() - Profiler._timers[name]
        Profiler._history[name] = Profiler._history[name] or {}
        table.insert(Profiler._history[name], duration)
        return duration
    end
    return 0
end

function Profiler.report()
    print("\n=== Performance Report ===")
    for name, entries in pairs(Profiler._history) do
        local total = 0
        for _, v in ipairs(entries) do total = total + v end
        print(string.format("%s: avg %.4fms, max %.4fms, calls %d", name, (total/#entries)*1000, math.max(table.unpack(entries))*1000, #entries))
    end
end

return Profiler