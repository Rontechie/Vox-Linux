-- Vox Hyprland Lua config adapted from RonTech local settings.
-----------------------------------
--    __              __         --
--   / /_  __  ______/ /________ --
--  / __ \/ / / / __  / ___/ __ \--
-- / / / / /_/ / /_/ / /  / /_/ /--
--/_/ /_/\__, /\__,_/_/   \____/ --
--      /____/                   --
-----------------------------------
--1.10--

--If you want your custom configurations to be used, use the "custom" folder as provided. Then add require("whatever your custom config is") to here."

--your require("") goes down here :)

--require("keybinds")
--require("config")

hl.monitor({
	output = "",
	mode = "preferred",
	position = "auto",
	scale = "1.0", -- neutral default; remove or change per display
})

--programs

local terminal = "kitty"
local fileManager = "xdg-open \"$HOME\"" -- open the home folder with the installed default file manager.
local menu = "qs -c ~/.local/share/hydro ipc call launcher toggle" --required for launcher later.
local wallpaper = "qs -c ~/.local/share/hydro/ ipc call wallpaperSelector toggle"
local settings = "qs -p ~/.local/share/hydro/nexus.qml"

--autostart

hl.on("hyprland.start", function()
	hl.exec_cmd("qs -c ~/.local/share/hydro")
end)

--ENVs or cursor management.

hl.env("XCURSOR_SIZE", "24")
hl.env("HYPRCURSOR_SIZE", "24")

--permissions (if you want)

hl.config({
	ecosystem = {
		enforce_permissions = true,
	},
})

hl.permission("/usr/(bin|local/bin)/grim", "screencopy", "allow")
hl.permission("/usr/(lib|libexec|lib64)/xdg-desktop-portal-hyprland", "screencopy", "allow")
hl.permission("/usr/(bin|local/bin)/hyprpm", "plugin", "allow")

--animations and looks

-- speed is in deciseconds (5 = 500ms). Preset: mac, speed x1

-- bezier curves
hl.curve("macOut", { type = "bezier", points = { { 0.16, 1.00 }, { 0.30, 1.00 } } }) -- fast start, very soft landing
hl.curve("macIn", { type = "bezier", points = { { 0.40, 0.00 }, { 0.60, 1.00 } } }) -- smooth exit
hl.curve("macFade", { type = "bezier", points = { { 0.25, 0.10 }, { 0.25, 1.00 } } })
hl.curve("linear", { type = "bezier", points = { { 0, 0 }, { 1, 1 } } })

-- springs (lower damping = more bounce)
hl.curve("macOpen", { type = "spring", mass = 1, stiffness = 260, damping = 20 }) -- windows pop open
hl.curve("macMove", { type = "spring", mass = 1, stiffness = 320, damping = 30 }) -- move / resize / reflow
hl.curve("macSpace", { type = "spring", mass = 1, stiffness = 200, damping = 22 }) -- workspace slide

-- windows
hl.animation({ leaf = "global", enabled = true, speed = 10, bezier = "default" })
hl.animation({ leaf = "windows", enabled = true, speed = 5, spring = "macMove" })
hl.animation({ leaf = "windowsIn", enabled = true, speed = 5, spring = "macOpen", style = "popin 80%" })
hl.animation({ leaf = "windowsOut", enabled = true, speed = 2.4, bezier = "macIn", style = "popin 82%" })
hl.animation({ leaf = "windowsMove", enabled = true, speed = 4.5, spring = "macMove" })

-- fades and borders
hl.animation({ leaf = "fadeIn", enabled = true, speed = 3.5, bezier = "macOut" })
hl.animation({ leaf = "fadeOut", enabled = true, speed = 2.4, bezier = "macIn" })
hl.animation({ leaf = "fadeSwitch", enabled = true, speed = 3, bezier = "macFade" })
hl.animation({ leaf = "fadeDim", enabled = true, speed = 4, bezier = "macFade" })
hl.animation({ leaf = "fade", enabled = true, speed = 3, bezier = "macFade" })
hl.animation({ leaf = "border", enabled = true, speed = 6, bezier = "macFade" })

-- popups and menus
hl.animation({ leaf = "layers", enabled = true, speed = 3.5, bezier = "macOut" })
hl.animation({ leaf = "layersIn", enabled = true, speed = 3.5, bezier = "macOut", style = "popin 94%" })
hl.animation({ leaf = "layersOut", enabled = true, speed = 2.2, bezier = "macIn", style = "popin 97%" })
hl.animation({ leaf = "fadeLayersIn", enabled = true, speed = 3, bezier = "macOut" })
hl.animation({ leaf = "fadeLayersOut", enabled = true, speed = 2.2, bezier = "macIn" })

-- workspaces: slide like Spaces
hl.animation({ leaf = "workspaces", enabled = true, speed = 3.5, spring = "macSpace", style = "slide" })
hl.animation({ leaf = "workspacesIn", enabled = true, speed = 3.5, spring = "macSpace", style = "slide" })
hl.animation({ leaf = "workspacesOut", enabled = true, speed = 3.5, spring = "macSpace", style = "slide" })
hl.animation({
	leaf = "specialWorkspace",
	enabled = true,
	speed = 3.5,
	spring = "macSpace",
	style = "slidefadevert 20%",
})
hl.animation({
	leaf = "specialWorkspaceIn",
	enabled = true,
	speed = 3.5,
	spring = "macSpace",
	style = "slidefadevert 20%",
})
hl.animation({
	leaf = "specialWorkspaceOut",
	enabled = true,
	speed = 3.5,
	spring = "macSpace",
	style = "slidefadevert 20%",
})
hl.animation({ leaf = "zoomFactor", enabled = true, speed = 7, bezier = "macFade" })
-- <<< hydro macOS animations

hl.config({
	dwindle = {
		preserve_split = true,
	}, -- <-- missing this } causes the exact error at line 110
})

hl.config({
	master = {
		new_status = "master",
	},
})

hl.config({
	scrolling = {
		fullscreen_on_one_column = true,
	},
})

--miscellaneous

hl.config({
	misc = {
		force_default_wallpaper = -1,
		disable_hyprland_logo = true,
	},
})

hl.config({
	layers = {
		allow_new_top_layers_over_existing_fullscreen = true,
	},
})

--inputs

hl.config({
	input = {
		kb_layout = "us",
		kb_variant = "",
		kb_model = "",
		kb_options = "",
		kb_rules = "",

		follow_mouse = 1,

		sensitivity = 0, -- -1.0 - 1.0,

		touchpad = {
			natural_scroll = false,
		},
	},
})

hl.gesture({
	fingers = 3,
	direction = "horizontal",
	action = "workspace",
})

hl.device({
	name = "epic-mouse-v1",
	sensitivity = -0.5,
})

-- binds

local mainMod = "SUPER"

hl.bind(mainMod .. " + Return", hl.dsp.exec_cmd(terminal))
hl.bind(mainMod .. " + Q", hl.dsp.window.close())
hl.bind(
	mainMod .. " + M",
	hl.dsp.exec_cmd("command -v hyprshutdown >/dev/null 2>&1 && hyprshutdown || hyprctl dispatch exit")
)
hl.bind(mainMod .. " + E", hl.dsp.exec_cmd(fileManager))
hl.bind(mainMod .. " + P", hl.dsp.window.pseudo())
hl.bind(mainMod .. " + J", hl.dsp.layout("togglesplit")) -- dwindle only
hl.bind(mainMod .. " + D", hl.dsp.exec_cmd(menu))
hl.bind(mainMod .. " + W", hl.dsp.exec_cmd(wallpaper))
hl.bind(mainMod .. " + S", hl.dsp.exec_cmd(settings))

hl.bind(mainMod .. " + left", hl.dsp.focus({ direction = "left" }))
hl.bind(mainMod .. " + right", hl.dsp.focus({ direction = "right" }))
hl.bind(mainMod .. " + up", hl.dsp.focus({ direction = "up" }))
hl.bind(mainMod .. " + down", hl.dsp.focus({ direction = "down" }))

for i = 1, 10 do
	local key = i % 10 -- 10 maps to key 0
	hl.bind(mainMod .. " + " .. key, hl.dsp.focus({ workspace = i }))
	hl.bind(mainMod .. " + SHIFT + " .. key, hl.dsp.window.move({ workspace = i }))
end

hl.bind(mainMod .. " + SHIFT + S", hl.dsp.window.move({ workspace = "special:magic" }))

hl.bind(mainMod .. " + mouse_down", hl.dsp.focus({ workspace = "e+1" }))
hl.bind(mainMod .. " + mouse_up", hl.dsp.focus({ workspace = "e-1" }))

hl.bind(mainMod .. " + mouse:272", hl.dsp.window.drag(), { mouse = true })
hl.bind(mainMod .. " + mouse:273", hl.dsp.window.resize(), { mouse = true })

hl.bind(
	"XF86AudioRaiseVolume",
	hl.dsp.exec_cmd("wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 5%+"),
	{ locked = true, repeating = true }
)
hl.bind(
	"XF86AudioLowerVolume",
	hl.dsp.exec_cmd("wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"),
	{ locked = true, repeating = true }
)
hl.bind(
	"XF86AudioMute",
	hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"),
	{ locked = true, repeating = true }
)
hl.bind(
	"XF86AudioMicMute",
	hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"),
	{ locked = true, repeating = true }
)
hl.bind("XF86MonBrightnessUp", hl.dsp.exec_cmd("brightnessctl -e4 -n2 set 5%+"), { locked = true, repeating = true })
hl.bind("XF86MonBrightnessDown", hl.dsp.exec_cmd("brightnessctl -e4 -n2 set 5%-"), { locked = true, repeating = true })

hl.bind("XF86AudioNext", hl.dsp.exec_cmd("playerctl next"), { locked = true })
hl.bind("XF86AudioPause", hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioPlay", hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioPrev", hl.dsp.exec_cmd("playerctl previous"), { locked = true })

local suppressMaximizeRule = hl.window_rule({
	-- Ignore maximize requests from all apps. You'll probably like this.
	name = "suppress-maximize-events",
	match = { class = ".*" },

	suppress_event = "maximize",
})
suppressMaximizeRule:set_enabled(false)

hl.window_rule({
	-- Fix some dragging issues with XWayland
	name = "fix-xwayland-drags",
	match = {
		class = "^$",
		title = "^$",
		xwayland = true,
		float = true,
		fullscreen = false,
		pin = false,
	},

	no_focus = true,
})

local overlayLayerRule = hl.layer_rule({
	name = "no-anim-overlay",
	match = { namespace = "^my-overlay$" },
	no_anim = true,
})
overlayLayerRule:set_enabled(false)

-- Hyprland-run windowrule
hl.window_rule({
	name = "move-hyprland-run",
	match = { class = "hyprland-run" },

	move = "20 monitor_h-120",
	float = true,
})

--inifnite desktops! Thanks Sarods2D :D

hl.on("hyprland.start", function()
	hl.exec_cmd("python3 ~/scripts/infinite_desktop_core.py 1.6 > /tmp/infinite-desktop.log 2>&1")
end)

hl.bind("SUPER" .. " + Z", hl.dsp.focus({ workspace = "-1" }))
hl.bind("SUPER" .. " + X", hl.dsp.focus({ workspace = "+1" }))
hl.bind("SUPER" .. " + SHIFT + Z", hl.dsp.window.move({ workspace = "-1" }))
hl.bind("SUPER" .. " + SHIFT + X", hl.dsp.window.move({ workspace = "+1" }))
hl.bind("SUPER" .. " + V", hl.dsp.exec_cmd("python3 ~/scripts/floating_tile_toggle.py"))
hl.bind("SUPER" .. " + H", hl.dsp.exec_cmd("python3 ~/scripts/navigate_windows.py left"))
hl.bind("SUPER" .. " + ALT + left", hl.dsp.exec_cmd("python3 ~/scripts/move_window_tiled.py left"))
hl.bind("SUPER" .. " + SHIFT + left", hl.dsp.exec_cmd("python3 ~/scripts/move_window.py left"), { repeating = true })
hl.bind("SUPER" .. " + CTRL + left", hl.dsp.exec_cmd("python3 ~/scripts/resize_window.py left"), { repeating = true })
hl.bind("SUPER" .. " + L", hl.dsp.exec_cmd("python3 ~/scripts/navigate_windows.py right"))
hl.bind("SUPER" .. " + ALT + right", hl.dsp.exec_cmd("python3 ~/scripts/move_window_tiled.py right"))
hl.bind("SUPER" .. " + SHIFT + right", hl.dsp.exec_cmd("python3 ~/scripts/move_window.py right"), { repeating = true })
hl.bind("SUPER" .. " + CTRL + right", hl.dsp.exec_cmd("python3 ~/scripts/resize_window.py right"), { repeating = true })
hl.bind("SUPER" .. " + K", hl.dsp.exec_cmd("python3 ~/scripts/navigate_windows.py up"))
hl.bind("SUPER" .. " + ALT + up", hl.dsp.exec_cmd("python3 ~/scripts/move_window_tiled.py up"))
hl.bind("SUPER" .. " + SHIFT + up", hl.dsp.exec_cmd("python3 ~/scripts/move_window.py up"), { repeating = true })
hl.bind("SUPER" .. " + CTRL + up", hl.dsp.exec_cmd("python3 ~/scripts/resize_window.py up"), { repeating = true })
hl.bind("SUPER" .. " + down", hl.dsp.exec_cmd("python3 ~/scripts/navigate_windows.py down"))
hl.bind("SUPER" .. " + ALT + J", hl.dsp.exec_cmd("python3 ~/scripts/move_window_tiled.py down"))
hl.bind("SUPER" .. " + SHIFT + down", hl.dsp.exec_cmd("python3 ~/scripts/move_window.py down"), { repeating = true })
hl.bind("SUPER" .. " + CTRL + down", hl.dsp.exec_cmd("python3 ~/scripts/resize_window.py down"), { repeating = true })

require("appearance")

hl.env("XCURSOR_THEME", "Bibata-Modern-Classic")
hl.env("XCURSOR_SIZE", "24")
hl.env("HYPRCURSOR_THEME", "Bibata-Modern-Classic")
hl.env("HYPRCURSOR_SIZE", "24")

hl.on("hyprland.start", function()
	hl.exec_cmd("hyprctl setcursor Bibata-Modern-Classic 24")
end)

hl.window_rule({
	name = "nexus-window",
	match = {
		class = "nexus",
	},
	float = true,
	size = "1257 764",
	center = true,
})

hl.window_rule({
	name = "nexus-window",
	match = { title = "^Nexus$" },
	float = true,
	size = "1257 764",
	center = true,
})

hl.window_rule({
	name = "hydro-nexus",
	match = { title = "^(Nexus)$" },
	float = true,
	center = true,
})

hl.window_rule({
	name = "hydro-settings",
	match = { title = "^(Hydro Settings)$" },
	float = true,
	center = true,
})

-- Load Vox appearance and animation settings.
dofile((os.getenv("HOME") or "") .. "/.config/hypr/appearance.lua")
