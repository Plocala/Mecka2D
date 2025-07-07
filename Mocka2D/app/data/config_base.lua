-- app/data/config_base.lua
return {
    app = {
        name    = "Mocka2D",
        version = "0.0.1",
        author  = "Plocala",
        window = {
            width      = 1280,
            height     = 720,
            title      = "Mocka",
            fullscreen = false,
            resizable  = true,
        }
    },
    paths = {
        assets    = "app/assets/",
        cacheData = "app/data",
        entities  = "app/src/modules/entities",
        panels    = "app/src/modules/panels",
        states    = "app/src/modules/states",
        systems   = "app/src/modules/systems",
    },
    updateChecker = {
        interval  = 86400,
        cacheFile = "app/data/update_cache.lua",
        urls = {
            love2d = "https://api.github.com/repos/love2d/love/git/refs/tags",
            lua    = "https://www.lua.org/versions.html"
        }
    },
    assetManifest = {
        images  = {},
        sounds  = {},
        fonts   = {},
        shaders = {},
        states  = {"state_zero"},
    },
    viewport = {
        virtualW = 1280,
        virtualH = 720,
        mode     = "auto",
        safeArea = {
            left   = 0.05,
            right  = 0.05,
            top    = 0.05,
            bottom = 0.05,
        },
    }
}