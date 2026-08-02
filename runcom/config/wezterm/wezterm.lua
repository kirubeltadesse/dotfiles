local wezterm = require("wezterm")

local config = wezterm.config_builder()

config.color_scheme = "rose-pine-moon"
config.use_dead_keys = false
config.font = wezterm.font_with_fallback({
	"Hibur Mono Nerd Font",
	"JetBrainsMono NFM",
})
config.default_cursor_style = "BlinkingBlock"
config.colors = {
	cursor_bg = "#ff51d0",
	cursor_border = "#ff51d0",
}
config.cursor_blink_rate = 500
config.font_size = 19.0
config.window_background_opacity = 0.9
config.macos_window_background_blur = 10
config.hide_tab_bar_if_only_one_tab = true
config.window_decorations = "RESIZE"

return config
