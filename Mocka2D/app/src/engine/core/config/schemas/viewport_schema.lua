-- app/src/engine/core/config/schemas/viewport_schemas.lua
return {
    virtualW = {
        type = "number", 
        default = 1280,
        validate = function(v) return v > 0, "virtualW must be > 0" end
    },
    virtualH = {
        type = "number", 
        default = 720,
        validate = function(v) return v > 0, "virtualH must be > 0" end
    },
    mode = {
        type = "string", 
        default = "auto",
        validate = function(v)
            local valid_modes = { auto = true, letterbox = true, crop = true, safe = true }
            return valid_modes[v], "invalid mode: " .. v
        end
    },
    safeArea = {
        type = "table",
        schema = {
            left = {
                type = "number", 
                default = 0.05,
                validate = function(v) return v >= 0 and v <= 1, "left must be 0-1"               end
            },
            right = {
                type = "number", 
                default = 0.05,
                validate = function(v) return v >= 0 and v <= 1, "right must be between 0 e 1"    end
            },
            top = {
                type = "number", 
                default = 0.05,
                validate = function(v) return v >= 0 and v <= 1, "top must be between 0 e 1"      end
            },
            bottom = {
                type = "number", 
                default = 0.05,
                validate = function(v) return v >= 0 and v <= 1, "bottom must be between 0 and 1" end
            },
        }
    }
}