local wezterm = require("wezterm")

local config = wezterm.config_builder()
local act = wezterm.action

config.color_scheme = "rose-pine-moon"
config.use_dead_keys = false
config.font = wezterm.font_with_fallback({
	"Hibur Mono Nerd Font",
	"JetBrainsMono NFM",
})

config.keys = {
	{ key = "c", mods = "CMD", action = act.CopyTo("Clipboard") },
	{ key = "v", mods = "CMD", action = act.PasteFrom("Clipboard") },
	{ key = "c", mods = "CTRL|SHIFT", action = act.CopyTo("Clipboard") },
	{ key = "v", mods = "CTRL|SHIFT", action = act.PasteFrom("Clipboard") },
}

config.key_tables = {
	copy_mode = {
		{ key = "c", mods = "CMD", action = act.CopyTo("Clipboard") },
		{ key = "v", mods = "CMD", action = act.PasteFrom("Clipboard") },
	},
}

config.default_cursor_style = "BlinkingBlock"
config.colors = {
	cursor_bg = "#ff51d0",
	cursor_border = "#ff51d0",
	background = "#191724",
}
config.cursor_blink_rate = 500
config.cursor_blink_ease_in = "Constant"
config.cursor_blink_ease_out = "Constant"
config.font_size = 19.0
config.window_background_opacity = 0.9
config.macos_window_background_blur = 10
config.hide_tab_bar_if_only_one_tab = true
config.window_decorations = "RESIZE"

return config
