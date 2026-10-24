
-- themes/rick.lua
local theme = {}

theme.font = "JetBrainsMono Nerd Font 10"
theme.bg_normal = "#101410"
theme.bg_focus = "#202B20"
theme.bg_urgent = "#F87171"
theme.bg_minimize = "#151B15"

theme.fg_normal = "#B9CCB4"
theme.fg_focus = "#F3FFF0"
theme.fg_urgent = "#FFFFFF"
theme.fg_minimize = "#758571"

theme.accent = "#A3E635"
theme.cyan = "#5EEAD4"
theme.green = "#A3E635"
theme.yellow = "#FACC15"
theme.red = "#FB7185"

theme.useless_gap = 8
theme.border_width = 2
theme.border_normal = "#2B3B2B"
theme.border_focus = theme.accent
theme.border_marked = theme.cyan

theme.bar_bg = "#101410DD"
theme.bar_fg = "#F3FFF0"
theme.bar_height = 38
theme.bar_margin = 12
theme.bar_radius = 12

theme.tag_active = theme.accent
theme.tag_occupied = "#50694B"
theme.tag_empty = "#283528"
theme.tag_fg = "#101410"

theme.task_bg = "#151B15"
theme.task_bg_focus = "#2A3B28"
theme.task_fg = "#E6F4E1"

theme.menu_height = 28
theme.menu_width = 220
theme.menu_bg_normal = "#151B15"
theme.menu_fg_normal = "#E6F4E1"
theme.menu_bg_focus = "#2A3B28"
theme.menu_fg_focus = "#FFFFFF"
theme.menu_border_width = 1
theme.menu_border_color = "#50694B"

theme.awesome_icon = nil
theme.wallpaper = os.getenv("HOME")
    .. "/.config/awesome/wallpaper/rick.jpg"

return theme
