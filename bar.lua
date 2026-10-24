local power = require("widget-drymnz.power")
local info = require("widget-drymnz.informacion-sistema")

-- =========================================
-- NEXUS / CYBERPUNK MINIMAL
-- =========================================

local cyber = {
    bg       = "#0D141A",
    surface  = "#17232B",
    border   = "#29434A",
    mint     = "#70F0C0",
    text     = "#C2D5D9",
    muted    = "#68858D",
    occupied = "#22343B",
}

local font_name = "JetBrainsMono Nerd Font 10"

function throw_bar(
    awful,
    set_wallpaper,
    tasklist_buttons,
    wibox,
    gears,
    taglist_buttons
)
    awful.screen.connect_for_each_screen(function(s)
        -- Fondo de pantalla
        set_wallpaper(s)

        -- Escritorios
        awful.tag(
            {"1", "2", "3", "4", "5", "6", "7", "8", "9"},
            s,
            awful.layout.layouts[1]
        )

        -- ---------------------------------
        -- Layout box
        -- ---------------------------------
        s.mylayoutbox = awful.widget.layoutbox(s)

        s.mylayoutbox:buttons(gears.table.join(
            awful.button({}, 1, function()
                awful.layout.inc(1)
            end),
            awful.button({}, 3, function()
                awful.layout.inc(-1)
            end),
            awful.button({}, 4, function()
                awful.layout.inc(1)
            end),
            awful.button({}, 5, function()
                awful.layout.inc(-1)
            end)
        ))

        -- =========================================
        -- ESCRITORIOS / TAGLIST CYBERPUNK
        -- =========================================

        s.mytaglist = awful.widget.taglist {
            screen = s,
            filter = awful.widget.taglist.filter.all,
            buttons = taglist_buttons,
            layout = {
                spacing = 4,
                layout = wibox.layout.fixed.horizontal,
            },

            widget_template = {
                {
                    {
                        id = "text_role",
                        widget = wibox.widget.textbox,
                        align = "center",
                        valign = "center",
                        font = font_name,
                    },
                    left = 8,
                    right = 8,
                    top = 3,
                    bottom = 3,
                    widget = wibox.container.margin,
                },

                id = "background_role",
                widget = wibox.container.background,

                create_callback = function(self, tag, index, tags)
                    self.shape = gears.shape.rounded_rect
                    self.shape_border_width = 1
                    self.shape_border_color = cyber.border
                end,

                update_callback = function(self, tag, index, tags)
                    if tag.selected then
                        -- Escritorio actual
                        self.bg = cyber.mint
                        self.fg = cyber.bg

                    elseif #tag:clients() > 0 then
                        -- Escritorio con ventanas abiertas
                        self.bg = cyber.occupied
                        self.fg = cyber.mint

                    else
                        -- Escritorio vacío
                        self.bg = cyber.bg
                        self.fg = cyber.muted
                    end
                end,
            },
        }
        -- ---------------------------------
        -- Ventanas / tasklist
        -- ---------------------------------
        s.mytasklist = awful.widget.tasklist {
            screen = s,
            filter = awful.widget.tasklist.filter.currenttags,

            style = {
                bg_normal = cyber.bg,
                bg_focus = cyber.surface,
                disable_task_name = true,
                border_width = 1,
                border_color = cyber.border,
                shape = gears.shape.rounded_bar,
            },

            layout = {
                spacing = 5,

                spacing_widget = {
                    {
                        forced_width = 1,
                        forced_height = 15,
                        color = cyber.border,
                        widget = wibox.widget.separator,
                    },

                    valign = "center",
                    halign = "center",
                    widget = wibox.container.place,
                },

                layout = wibox.layout.fixed.horizontal,
            },

            buttons = tasklist_buttons,
        }

        -- ---------------------------------
        -- Reloj
        -- ---------------------------------
        local clock = wibox.widget.textclock(
            '<span foreground="' .. cyber.muted
            .. '">󰃭 </span>'
            .. '<span foreground="' .. cyber.text
            .. '">%b %d</span>'
            .. '<span foreground="' .. cyber.muted
            .. '">  /  </span>'
            .. '<span foreground="' .. cyber.mint
            .. '">󰥔 %H:%M</span>'
        )

        -- ---------------------------------
        -- Bandeja del sistema
        -- ---------------------------------
        local systray = wibox.widget.systray()
        systray:set_base_size(16)

        -- ---------------------------------
        -- Márgenes de los extremos
        -- ---------------------------------
        local left_widgets = wibox.container.margin(
            wibox.layout.fixed.horizontal(
                mylauncher,
                s.mytaglist,
                s.mypromptbox
            ),
            10, 6, 3, 3
        )

        local right_widgets = wibox.container.margin(
            wibox.layout.fixed.horizontal(
                systray,
                clock,
                info(4),
                info(3),
                info(1),
                info(2),
                power,
                s.mylayoutbox
            ),
            6, 10, 3, 3
        )

        -- ---------------------------------
        -- Barra flotante centrada
        -- ---------------------------------
        local bar_width = math.floor(s.geometry.width * 0.85)
        local bar_x = s.geometry.x
            + math.floor((s.geometry.width - bar_width) / 2)

        s.mywibox = awful.wibar {
            screen = s,
            position = "top",

            x = bar_x,
            width = bar_width,
            height = 32,

            bg = "#0D141ACC",
            fg = cyber.text,

            border_width = 1,
            border_color = cyber.border,
            shape = gears.shape.rounded_rect,
        }

        -- ---------------------------------
        -- Composición de tres zonas
        -- ---------------------------------
        s.mywibox:setup {
            layout = wibox.layout.align.horizontal,

            left_widgets,

            wibox.container.place(
                s.mytasklist,
                "center",
                "center"
            ),

            right_widgets,
        }
    end)
end
