-- app/src/engine/core/utils.lua
local utils = {}

function utils.deepCopy(orig, copies)
    copies = copies or {}
    if type(orig) ~= "table" then return orig end
    if copies[orig] then return copies[orig] end

    local copy = {}
    copies[orig] = copy
    setmetatable(copy, utils.deepCopy(getmetatable(orig), copies))

    for k, v in pairs(orig) do
        copy[utils.deepCopy(k, copies)] = utils.deepCopy(v, copies)
    end
    return copy
end

function utils.mergeTables(t1, t2)
    if type(t1) ~= "table" or type(t2) ~= "table" then
        return utils.deepCopy(t2)
    end
    
    local merged = utils.deepCopy(t1)
    for k, v in pairs(t2) do
        if type(v) == "table" and type(merged[k]) == "table" then
            merged[k] = utils.mergeTables(merged[k], v)
        else
            merged[k] = v
        end
    end
    return merged
end

function utils.validateType(value, expected_type, var_name, allow_nil)
    if allow_nil and value == nil then return end
    
    local valid = false
    
    if type(expected_type) == "string" then
        valid = type(value) == expected_type
    elseif type(expected_type) == "function" then
        valid = expected_type(value)
    end

    if type(expected_type) == "table" and expected_type.__is_interface then
        local Interfaces = require "app.src.engine.core.interfaces"
        Interfaces.validate(value, expected_type)
        return
    end
    
    if not valid then
        error(("Bad type for '%s' (expected %s, got %s)")
            :format(var_name, tostring(expected_type), type(value)), 3)
    end
end

function utils.generateId()
    return tostring({}):sub(8)
end

function utils.safeCall(fn, ...)
    if type(fn) ~= "function" then return nil end
    local ok, result = pcall(fn, ...)
    if ok then return result end
    return nil
end

function utils.safeCallMulti(fn, ...)
    if type(fn) ~= "function" then return nil end
    local ok, a, b, c, d, e = pcall(fn, ...)
    if not ok then return nil end
    return a, b, c, d, e
end

return utils
