-- app/src/engine/core/config/schemas/app_schemas.lua
return {
    name    = { type = "string", default = "Mocka2D"   },
    version = { type = "string", default = "0.0.1"   },
    author  = { type = "string", default = "Unknown" },
    window = {
        type = "table",
        schema = {
            width = {
                type = "number", 
                default = 1280,
                validate = function(v) return v > 0, "width must be > 0" end
            },
            height = {
                type = "number", 
                default = 720,
                validate = function(v) return v > 0, "height must be > 0" end
            },
            title      = { type = "string", default = "Mocka" },
            fullscreen = { type = "boolean", default = false  },
            resizable  = { type = "boolean", default = true   },
        }
    }
}