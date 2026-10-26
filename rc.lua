
-- rc.lua
-- Arch Linux + AwesomeWM
-- Minimal Developer

pcall(require, "luarocks.loader")

local gears = require("gears")
local awful = require("awful")
local wibox = require("wibox")
local beautiful = require("beautiful")
local naughty = require("naughty")
local menubar = require("menubar")

require("awful.autofocus")
require("awful.hotkeys_popup.keys")

local config_dir = gears.filesystem.get_configuration_dir()

-- Tema activo
local theme = dofile(config_dir .. "theme.lua")
beautiful.init(theme)

local modkey = "Mod4"
local terminal = "kitty"
local editor = os.getenv("EDITOR") or "nvim"
local editor_cmd = terminal .. " -e " .. editor

menubar.utils.terminal = terminal

-- Errores de inicio
if awesome.startup_errors then
    naughty.notify({
        preset = naughty.config.presets.critical,
        title = "Error al iniciar Awesome",
        text = tostring(awesome.startup_errors),
    })
end

do
    local in_error = false

    awesome.connect_signal("debug::error", function(err)
        if in_error then return end
        in_error = true

        naughty.notify({
            preset = naughty.config.presets.critical,
            title = "Error de Awesome",
            text = tostring(err),
        })

        in_error = false
    end)
end

-- Distribuciones de ventanas
awful.layout.layouts = {
    awful.layout.suit.tile,
    awful.layout.suit.fair,
    awful.layout.suit.floating,
    awful.layout.suit.max,
}

-- Menú principal
local awesome_menu = {
    { "Atajos", function()
        require("awful.hotkeys_popup").show_help(
            nil, awful.screen.focused()
        )
    end },
    { "Editar configuración", editor_cmd .. " " .. awesome.conffile },
    { "Reiniciar Awesome", awesome.restart },
    { "Salir", awesome.quit },
}

local browser_menu = {
    { "Firefox", "firefox" },
}

mymainmenu = awful.menu({
    items = {
        { "Awesome", awesome_menu },
        { "Navegador", browser_menu },
        { "Terminal", terminal },
        { "Archivos", "thunar" },
    },
    theme = {
        height = beautiful.menu_height,
        width = beautiful.menu_width,
        bg_normal = beautiful.menu_bg_normal,
        fg_normal = beautiful.menu_fg_normal,
        bg_focus = beautiful.menu_bg_focus,
        fg_focus = beautiful.menu_fg_focus,
        border_width = beautiful.menu_border_width,
        border_color = beautiful.menu_border_color,
    },
})

-- Prompt para ejecutar comandos
local function create_prompt(s)
    s.mypromptbox = awful.widget.prompt()
end

-- Fondo de pantalla
local function set_wallpaper(s)
    if beautiful.wallpaper
        and gears.filesystem.file_readable(beautiful.wallpaper)
    then
        gears.wallpaper.maximized(
            beautiful.wallpaper, s, true
        )
    else
        gears.wallpaper.set(beautiful.bg_normal, s)
    end
end

-- Botones de escritorios. La dirección se actualiza al cambiar de tag.
local taglist_buttons = gears.table.join(
    awful.button({}, 1, function(t)
        t:view_only()
    end),
    awful.button({modkey}, 1, function(t)
        if client.focus then
            client.focus:move_to_tag(t)
        end
    end),
    awful.button({}, 3, awful.tag.viewtoggle),
    awful.button({}, 4, function(t)
        t.screen.pacman_direction = "right"
        awful.tag.viewnext(t.screen)
    end),
    awful.button({}, 5, function(t)
        t.screen.pacman_direction = "left"
        awful.tag.viewprev(t.screen)
    end)
)

-- Botones de tareas
local tasklist_buttons = gears.table.join(
    awful.button({}, 1, function(c)
        if c == client.focus then
            c.minimized = true
        else
            c:emit_signal("request::activate", "tasklist", {
                raise = true,
            })
        end
    end),
    awful.button({}, 3, function()
        awful.menu.client_list({ theme = { width = 250 } })
    end),
    awful.button({}, 4, function()
        awful.client.focus.byidx(1)
    end),
    awful.button({}, 5, function()
        awful.client.focus.byidx(-1)
    end)
)

-- Botones del ratón para ventanas
local clientbuttons = gears.table.join(
    awful.button({}, 1, function(c)
        c:emit_signal("request::activate", "mouse_click", {
            raise = true,
        })
    end),
    awful.button({modkey}, 1, function(c)
        c:emit_signal("request::activate", "mouse_click", {
            raise = true,
        })
        awful.mouse.client.move(c)
    end),
    awful.button({modkey}, 3, function(c)
        c:emit_signal("request::activate", "mouse_click", {
            raise = true,
        })
        awful.mouse.client.resize(c)
    end)
)

-- Nueve escritorios por pantalla.
-- Se conservan los nombres 1-9; bar.lua dibuja Pac-Man y los fantasmas.
awful.screen.connect_for_each_screen(function(s)
    awful.tag(
        { "1", "2", "3", "4", "5", "6", "7", "8", "9" },
        s,
        awful.layout.layouts[1]
    )

    -- Colores arcade mezclados aleatoriamente para esta sesión.
    -- Cada escritorio conserva su color incluso al abrir/cerrar ventanas.
    local colores_fantasma = {
        "#ff5555", -- rojo
        "#ff77c8", -- rosa
        "#35c9e7", -- celeste
        "#ff9f43", -- naranja
        "#55d66b", -- verde
        "#b084f5", -- morado
        "#4d8dff", -- azul
        "#ffd166", -- amarillo cálido
        "#e6e6e6", -- gris claro
    }

    for i = #colores_fantasma, 2, -1 do
        local j = math.random(i)
        colores_fantasma[i], colores_fantasma[j] =
            colores_fantasma[j], colores_fantasma[i]
    end

    s.pacman_direction = s.pacman_direction or "right"
    s._last_selected_tag = s.selected_tag

    for i, t in ipairs(s.tags) do
        t.ghost_color = colores_fantasma[i]

        t:connect_signal("property::selected", function(tag)
            if not tag.selected then return end

            local anterior = s._last_selected_tag
            if anterior and anterior ~= tag then
                local indice_anterior, indice_nuevo
                for indice, item in ipairs(s.tags) do
                    if item == anterior then indice_anterior = indice end
                    if item == tag then indice_nuevo = indice end
                end

                if indice_anterior and indice_nuevo then
                    s.pacman_direction = indice_nuevo > indice_anterior
                        and "right" or "left"
                end
            end

            s._last_selected_tag = tag
        end)
    end

    s.padding = beautiful.useless_gap or 8
    create_prompt(s)
    set_wallpaper(s)

    local setup_bar = require("bar")
        setup_bar(
            awful, gears, wibox, s,
            taglist_buttons, tasklist_buttons
        )

        -- Actualizar los escritorios después de crear la barra.
        gears.timer.delayed_call(function()
            for _, tag in ipairs(s.tags) do
                tag:emit_signal("property::selected", tag.selected)
            end
        end)
    end)

-- Actualizar fondo al cambiar la geometría de pantalla
screen.connect_signal("property::geometry", function(s)
    set_wallpaper(s)
end)

-- Atajos de teclado
local setup_keys = require("keys")
local globalkeys, clientkeys = setup_keys(modkey, terminal)
root.keys(globalkeys)

root.buttons(gears.table.join(
    awful.button({}, 3, function()
        mymainmenu:toggle()
    end),
    awful.button({}, 4, awful.tag.viewnext),
    awful.button({}, 5, awful.tag.viewprev)
))

-- Reglas de ventanas
awful.rules.rules = {
    {
        rule = {},
        properties = {
            border_width = beautiful.border_width,
            border_color = beautiful.border_normal,
            focus = awful.client.focus.filter,
            raise = true,
            keys = clientkeys,
            buttons = clientbuttons,
            screen = awful.screen.preferred,
            placement = awful.placement.no_overlap
                + awful.placement.no_offscreen,
            size_hints_honor = false,
        },
    },
    {
        rule_any = {
            type = { "dialog" },
        },
        properties = {
            floating = true,
        },
    },
}

-- Estado visual de las ventanas
client.connect_signal("focus", function(c)
    c.border_color = beautiful.border_focus
end)

client.connect_signal("unfocus", function(c)
    c.border_color = beautiful.border_normal
end)

-- Inicio de aplicaciones: evita duplicados detectables
local function run_once(process, command)
    awful.spawn.with_shell(
        "pgrep -x '" .. process ..
        "' >/dev/null || " .. command
    )
end

run_once("picom", "picom")
run_once("mpd", "mpd")

-- Polkit: configura aquí el agente instalado en tu sistema.
-- No todos los equipos Arch utilizan la misma ruta.

-- Bandeja del sistema
beautiful.bg_systray = beautiful.bar_bg
