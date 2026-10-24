
-- themes/ruka.lua
local theme = {}

theme.font = "JetBrainsMono Nerd Font 10"
theme.bg_normal = "#111722"
theme.bg_focus = "#25374F"
theme.bg_urgent = "#E879A9"
theme.bg_minimize = "#17202D"

theme.fg_normal = "#C6D6E8"
theme.fg_focus = "#FFFFFF"
theme.fg_urgent = "#FFFFFF"
theme.fg_minimize = "#7C8DA5"

theme.accent = "#83C5F7"
theme.cyan = "#A5E5F5"
theme.green = "#9ADBC5"
theme.yellow = "#F7D9A5"
theme.red = "#E879A9"

theme.useless_gap = 8
theme.border_width = 2
theme.border_normal = "#26364A"
theme.border_focus = theme.accent
theme.border_marked = theme.cyan

theme.bar_bg = "#111722DD"
theme.bar_fg = "#F1F7FF"
theme.bar_height = 38
theme.bar_margin = 12
theme.bar_radius = 12

theme.tag_active = theme.accent
theme.tag_occupied = "#526A86"
theme.tag_empty = "#2C394B"
theme.tag_fg = "#FFFFFF"

theme.task_bg = "#17202D"
theme.task_bg_focus = "#2C4059"
theme.task_fg = "#E4F0FF"

theme.menu_height = 28
theme.menu_width = 220
theme.menu_bg_normal = "#17202D"
theme.menu_fg_normal = "#E4F0FF"
theme.menu_bg_focus = "#2C4059"
theme.menu_fg_focus = "#FFFFFF"
theme.menu_border_width = 1
theme.menu_border_color = "#526A86"

theme.awesome_icon = nil
theme.wallpaper = os.getenv("HOME")
    .. "/.config/awesome/wallpaper/ruka.jpg"

return theme
