-- bar.lua
local beautiful = require("beautiful")

local function safe_widget(factory, ...)
    if type(factory) ~= "function" then
        return nil
    end

    local ok, result = pcall(factory, ...)
    if ok then
        return result
    end

    return nil
end

local function make_info(index, wibox)
    local ok, info = pcall(require, "widget-drymnz.informacion-sistema")

    if ok then
        local widget = safe_widget(info, index)
        if widget then
            return widget
        end
    end

    return wibox.widget.textbox("  --  ")
end

local function make_power()
    local ok, power = pcall(require, "widget-drymnz.power")

    if ok then
        return power
    end

    return nil
end



local function make_taglist(awful, gears, wibox, s, buttons)
    local icon_dir = gears.filesystem.get_configuration_dir()
        .. "icons/pacman/"

    local function cargar_imagen(archivo)
        local ok, imagen = pcall(
            gears.surface.load_uncached,
            icon_dir .. archivo
        )

        if ok then
            return imagen
        end

        return nil
    end

    local function fantasma(tag)
        local color = (tag.ghost_color or "#3299ff")
            :gsub("#", "")
            :lower()

        local archivo = color == "ff5555"
            and "fantasma_rojo.png"
            or ("fantasma_" .. color .. ".png")

        return cargar_imagen(archivo)
    end

    return awful.widget.taglist {
        screen = s,
        filter = awful.widget.taglist.filter.all,
        buttons = buttons,

        widget_template = {
            {
                {
                    {
                        id = "icon_role",
                        widget = wibox.widget.imagebox,
                    },
                    {
                        id = "pacman_role",
                        widget = wibox.widget.textbox,
                    },
                    layout = wibox.layout.fixed.horizontal,
                    spacing = 2,
                },
                margins = 8,
                widget = wibox.container.margin,
            },
            id = "background_role",
            widget = wibox.container.background,

            create_callback = function(self)
                self.shape = gears.shape.rounded_rect
            end,

            update_callback = function(self, tag)
                local texto =
                    self:get_children_by_id("pacman_role")[1]
                local icono =
                    self:get_children_by_id("icon_role")[1]

                if texto then
                    texto.markup = ""
                end

                if icono then
                    icono.resize = true
                    icono.forced_width = 24
                    icono.forced_height = 24

                    if tag.selected then
                        local archivo =
                            s.pacman_direction == "left"
                            and "pacman_left.png"
                            or "pacman.png"

                        icono.image = cargar_imagen(archivo)

                    elseif #tag:clients() > 0 then
                        icono.image = fantasma(tag)

                    else
                        icono.image = nil

                        if texto then
                            texto.markup =
                                '<span foreground="#a0a6b2">•</span>'
                        end
                    end
                end

                if tag.selected then
                    self.bg = beautiful.tag_active
                elseif #tag:clients() > 0 then
                    self.bg = beautiful.tag_occupied
                else
                    self.bg = beautiful.tag_empty
                end

                self.fg = beautiful.tag_fg
            end,
        },
    }
end


local function make_tasklist(awful, gears, s, buttons)
    local wibox = require("wibox")

    return awful.widget.tasklist {
        screen = s,
        filter = awful.widget.tasklist.filter.currenttags,
        buttons = buttons,

        style = {
            shape = gears.shape.rounded_rect,
        },

        layout = {
            spacing = 6,
            layout = wibox.layout.fixed.horizontal,
        },

        widget_template = {
            {
                {
                    {
                        id = "icon_role",
                        widget = wibox.widget.imagebox,
                    },
                    margins = 6,
                    widget = wibox.container.margin,
                },

                {
                    id = "pacman_role",
                    widget = wibox.widget.textbox,
                },

                spacing = 6,
                layout = wibox.layout.fixed.horizontal,
            },

            id = "background_role",
            widget = wibox.container.background,

            create_callback = function(self)
                self.shape = gears.shape.rounded_rect
            end,

            -- Mantener el comportamiento original de la lista de ventanas
            update_callback = function(self, c)
                self.bg = c == client.focus
                    and beautiful.task_bg_focus
                    or beautiful.task_bg

                self.fg = beautiful.task_fg
            end,
        },
    }
end

local function setup_bar(
    awful, gears, wibox, s,
    taglist_buttons, tasklist_buttons
)
    local margin = beautiful.bar_margin or 12
    local height = beautiful.bar_height or 38
    local geo = s.geometry

    s.mytaglist = make_taglist(
        awful, gears, wibox, s, taglist_buttons
    )

    s.mytasklist = make_tasklist(
        awful, gears, s, tasklist_buttons
    )

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

    local right_widgets = {
        layout = wibox.layout.fixed.horizontal,
        spacing = 10,

        make_info(4, wibox),
        make_info(3, wibox),
        make_info(1, wibox),
        make_info(2, wibox),

        wibox.widget.textclock(
            "  %a %d %b  %H:%M  "
        ),

        s.mylayoutbox,
    }

    local power = make_power()

    if power then
        table.insert(right_widgets, 1, power)
    end

    local systray = wibox.widget.systray()

    local right = {
        layout = wibox.layout.fixed.horizontal,
        spacing = 10,
        systray,
        right_widgets,
    }

    s.mywibox = awful.wibar {
        screen = s,
        position = "top",
        x = geo.x + margin,
        y = geo.y + margin,
        width = math.max(100, geo.width - margin * 2),
        height = height,
        bg = beautiful.bar_bg,
        fg = beautiful.bar_fg,
        shape = gears.shape.rounded_rect,
        border_width = 1,
        border_color = beautiful.border_normal,
        ontop = true,
    }

    s.mywibox:setup {
        layout = wibox.layout.align.horizontal,

        {
            layout = wibox.layout.fixed.horizontal,
            spacing = 8,
            s.mytaglist,
        },

        {
            layout = wibox.layout.flex.horizontal,
            s.mytasklist,
        },

        right,
    }
end

return setup_bar
