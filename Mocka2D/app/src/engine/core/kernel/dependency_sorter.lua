-- app/src/engine/core/kernel/dependency_sorter.lua
local function topologicalSort(systems)
    local sorted = {}
    local visited = {}
    local temp = {}
    local names = {}
    
    for name in pairs(systems) do
        table.insert(names, name)
    end

    local function _visit(n)
        if temp[n] then
            error("Dependency cycle detected involving: " .. n)
        end
        
        if not visited[n] then
            temp[n] = true
            local deps = systems[n].dependencies or {}
            for _, dep in ipairs(deps) do
                if systems[dep] then
                    _visit(dep)
                end
            end
            temp[n] = nil
            visited[n] = true
            table.insert(sorted, n)
        end
    end

    for _, n in ipairs(names) do
        if not visited[n] then
            _visit(n)
        end
    end

    return sorted
end

return {
    topologicalSort = topologicalSort
}