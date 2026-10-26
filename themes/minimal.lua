
-- themes/minimal.lua
-- Minimal Developer: carbón, violeta y cian.

local theme = {}

theme.font = "JetBrainsMono Nerd Font 10"
theme.notification_font = "JetBrainsMono Nerd Font 10"

-- Paleta
theme.bg_normal   = "#11131B"
theme.bg_focus    = "#202436"
theme.bg_urgent   = "#F87171"
theme.bg_minimize = "#171A24"

theme.fg_normal   = "#A8B0C5"
theme.fg_focus    = "#F1F5F9"
theme.fg_urgent   = "#FFFFFF"
theme.fg_minimize = "#6B7280"

theme.accent      = "#A78BFA"
theme.cyan        = "#22D3EE"
theme.green       = "#34D399"
theme.yellow      = "#FBBF24"
theme.red         = "#F87171"

-- Bordes y espacios
theme.useless_gap = 8
theme.border_width = 2
theme.border_normal = "#292D3E"
theme.border_focus = theme.accent
theme.border_marked = theme.cyan

-- Barra flotante
theme.bar_bg = "#11131BDD"
theme.bar_fg = "#F1F5F9"
theme.bar_height = 38
theme.bar_margin = 12
theme.bar_radius = 12

-- Escritorios
theme.tag_active = theme.accent
theme.tag_occupied = "#475569"
theme.tag_empty = "#303548"
theme.tag_fg = "#F1F5F9"

-- Tareas
theme.task_bg = "#191D2A"
theme.task_bg_focus = "#30364B"
theme.task_fg = "#DCE3F2"

-- Menús
theme.menu_height = 28
theme.menu_width = 220
theme.menu_bg_normal = "#171A24"
theme.menu_fg_normal = "#DCE3F2"
theme.menu_bg_focus = "#30364B"
theme.menu_fg_focus = "#FFFFFF"
theme.menu_border_width = 1
theme.menu_border_color = "#34394D"

-- Icono del menú de Awesome
theme.awesome_icon = nil

-- Fondo
theme.wallpaper = os.getenv("HOME")
    .. "/.config/awesome/wallpaper/minimal.jpg"

return theme