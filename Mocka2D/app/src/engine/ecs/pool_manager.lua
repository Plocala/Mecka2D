-- app/src/engine/ecs/pool_manager.lua
local PoolManager = {}
PoolManager._pools = {}

function PoolManager.register(key, createFn, resetFn)
    assert(type(key)      == "string", "Pool key deve ser string")
    assert(type(createFn) == "function", "Factory deve ser function")
    PoolManager._pools[key] = {
        create = createFn,
        reset  = resetFn,
        items  = {}
    }
end

function PoolManager.acquire(key, ...)
    local p = PoolManager._pools[key]
    assert(p, "Pool não registrado para key: "..key)
    local inst = table.remove(p.items)
    if inst then
        if p.reset then p.reset(inst) end
        return inst
    else
        return p.create(...)
    end
end

function PoolManager.release(key, inst)
    local p = PoolManager._pools[key]
    assert(p, "Pool não registrado para key: "..key)
    if p.reset then p.reset(inst) end
    table.insert(p.items, inst)
end

return PoolManager
