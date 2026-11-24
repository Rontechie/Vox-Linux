-- Vox appearance and animation settings adapted from RonTech local settings.
hl.config({
    general = {
        border_size = 2,
        col = {
            active_border = "rgba(000000ff)",
            inactive_border = "rgba(000000ff)",
        },
    },
    decoration = {
        rounding = 6,
        active_opacity = 1.0,
        inactive_opacity = 1.0,
        fullscreen_opacity = 1.0,
        blur = {
            enabled = false,
        },
        shadow = {
            enabled = false,
        },
    },
})

hl.curve("appearanceSpring", {
    type = "spring",
    mass = 1,
    stiffness = 280,
    damping = 26,
})

hl.curve("workspaceBounce", {
    type = "spring",
    mass = 1,
    stiffness = 180,
    damping = 15,
})

hl.animation({ leaf = "global",        enabled = true, speed = 1,    spring = "appearanceSpring" })
hl.animation({ leaf = "border",        enabled = true, speed = 1,    spring = "appearanceSpring" })
hl.animation({ leaf = "windows",       enabled = true, speed = 4.5,  spring = "appearanceSpring" })
hl.animation({ leaf = "windowsIn",     enabled = true, speed = 4.2,  spring = "appearanceSpring", style = "popin 87%" })
hl.animation({ leaf = "windowsOut",    enabled = true, speed = 3.2,  spring = "appearanceSpring", style = "popin 87%" })
hl.animation({ leaf = "fadeIn",        enabled = true, speed = 3.5,  spring = "appearanceSpring" })
hl.animation({ leaf = "fadeOut",       enabled = true, speed = 3.5,  spring = "appearanceSpring" })
hl.animation({ leaf = "fade",          enabled = true, speed = 3.5,  spring = "appearanceSpring" })
hl.animation({ leaf = "layers",        enabled = true, speed = 4,    spring = "appearanceSpring" })
hl.animation({ leaf = "layersIn",      enabled = true, speed = 4,    spring = "appearanceSpring", style = "fade" })
hl.animation({ leaf = "layersOut",     enabled = true, speed = 3.5,  spring = "appearanceSpring", style = "fade" })
hl.animation({ leaf = "fadeLayersIn",  enabled = true, speed = 3.5,  spring = "appearanceSpring" })
hl.animation({ leaf = "fadeLayersOut", enabled = true, speed = 3.5,  spring = "appearanceSpring" })
hl.animation({ leaf = "workspaces",          enabled = true, speed = 3, spring = "workspaceBounce", style = "slide" })
hl.animation({ leaf = "workspacesIn",        enabled = true, speed = 3, spring = "workspaceBounce", style = "slide" })
hl.animation({ leaf = "workspacesOut",       enabled = true, speed = 3, spring = "workspaceBounce", style = "slide" })
hl.animation({ leaf = "specialWorkspace",    enabled = true, speed = 3, spring = "workspaceBounce", style = "slide" })
hl.animation({ leaf = "specialWorkspaceIn",  enabled = true, speed = 3, spring = "workspaceBounce", style = "slide" })
hl.animation({ leaf = "specialWorkspaceOut", enabled = true, speed = 3, spring = "workspaceBounce", style = "slide" })
hl.animation({ leaf = "zoomFactor",    enabled = true, speed = 4.5,  spring = "appearanceSpring" })
