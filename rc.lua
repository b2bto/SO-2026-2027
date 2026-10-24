    -- ============================================================
    -- AWESOMEWM | AI DEVELOPER CYBERPUNK
    -- Tema: Negro / Cian neón / Violeta
    -- ============================================================

    pcall(require, "luarocks.loader")

    local gears = require("gears")
    local awful = require("awful")
    local wibox = require("wibox")
    local beautiful = require("beautiful")
    local naughty = require("naughty")
    local hotkeys_popup = require("awful.hotkeys_popup")

    require("awful.autofocus")
    require("awful.hotkeys_popup.keys")

    -- ============================================================
    -- MODULOS PERSONALIZADOS
    -- ============================================================

    local function safe_require(name)
        local ok, result = pcall(require, name)

        if not ok then
            naughty.notify({
                title = "Error de modulo",
                text = name .. ":\n" .. tostring(result),
                timeout = 8,
            })
            return false
        end

        return true
    end

    safe_require("color")
    safe_require("bar")
    safe_require("keys")

    -- ============================================================
    -- PALETA DE COLORES
    -- ============================================================

    tono_lila_dos = tono_lila_dos or "#A78BFA"
    tono_georgias_2 = tono_georgias_2 or "#161B22"
    tono_georgias_3 = tono_georgias_3 or "#0D1117"
    tono_georgias_4 = tono_georgias_4 or "#F0F6FC"
    tono_amarillo = tono_amarillo or "#F1FA8C"
    tono_azul_cielo = tono_azul_cielo or "#00D9FF"

    color_naranja_one = color_naranja_one or "#FFB86C"
    color_azul_two = color_azul_two or "#6272A4"

    local theme = {
        bg = "#0D1117",
        bg_alt = "#161B22",
        fg = "#F0F6FC",
        muted = "#8B949E",
        cyan = "#00D9FF",
        purple = "#A78BFA",
        pink = "#FF6B81",
        border = "#30363D",
    }

    -- ============================================================
    -- APLICACIONES
    -- ============================================================

    terminal = "kitty"
    editor = os.getenv("EDITOR") or "nvim"
    editor_cmd = terminal .. " -e " .. editor

    browser = "firefox"
    browserG = "google-chrome-stable"
    vscode = "code"
    ink = "inkscape"
    gimp = "gimp"
    krita = "krita"
    archivos = "thunar"

    modkey = "Mod4"

    -- ============================================================
    -- TEMA
    -- ============================================================

    beautiful.init(
        gears.filesystem.get_themes_dir() .. "default/theme.lua"
    )
    -- Fuente para la barra cyberpunk
    beautiful.font = "JetBrainsMono Nerd Font 10"

    beautiful.bg_normal = theme.bg
    beautiful.fg_normal = theme.fg
    beautiful.bg_focus = theme.bg_alt
    beautiful.fg_focus = theme.cyan
    beautiful.bg_urgent = theme.pink
    beautiful.fg_urgent = "#FFFFFF"

    beautiful.border_width = 2
    beautiful.border_normal = theme.border
    beautiful.border_focus = theme.cyan
    beautiful.border_marked = theme.purple

    beautiful.useless_gap = 6
    beautiful.font = "Sans 10"

    beautiful.menu_height = 24
    beautiful.menu_width = 220
    beautiful.menu_border_width = 1
    beautiful.menu_border_color = theme.purple
    beautiful.menu_bg_normal = theme.bg
    beautiful.menu_fg_normal = theme.fg
    beautiful.menu_bg_focus = theme.bg_alt
    beautiful.menu_fg_focus = theme.cyan
    beautiful.bg_systray = theme.bg

    awful.layout.layouts = {
        awful.layout.suit.tile,
        awful.layout.suit.floating,
        awful.layout.suit.fair,
        awful.layout.suit.tile.left,
        awful.layout.suit.max,
    }

    -- ============================================================
    -- FONDOS DE PANTALLA
    -- ============================================================

    local home = os.getenv("HOME") or ""
    local wp_path = home .. "/.config/awesome/wallpaper/"
    local preferred_wallpaper = wp_path .. "54396-pc.jpg"

    local function file_exists(path)
        if not path or path == "" then
            return false
        end

        local file = io.open(path, "rb")

        if file then
            file:close()
            return true
        end

        return false
    end

    local function scandir(directory)
        local files = {}

        local pipe = io.popen(
            "find " .. string.format("%q", directory)
            .. " -maxdepth 1 -type f "
            .. "\\( -iname '*.png' -o -iname '*.jpg' "
            .. "-o -iname '*.jpeg' -o -iname '*.webp' \\) "
            .. "-printf '%f\\n' 2>/dev/null"
        )

        if not pipe then
            return files
        end

        for filename in pipe:lines() do
            files[#files + 1] = filename
        end

        pipe:close()
        return files
    end

    local wp_files = {}
    local current_wallpaper = nil

    local function set_wallpaper(s)
        if current_wallpaper and file_exists(current_wallpaper) then
            gears.wallpaper.maximized(current_wallpaper, s, true)
        elseif beautiful.wallpaper then
            local wallpaper = beautiful.wallpaper

            if type(wallpaper) == "function" then
                wallpaper = wallpaper(s)
            end

            if wallpaper and file_exists(wallpaper) then
                gears.wallpaper.maximized(wallpaper, s, true)
            else
                gears.wallpaper.set(theme.bg)
            end
        else
            gears.wallpaper.set(theme.bg)
        end
    end

    local function random_wallpaper()
        wp_files = scandir(wp_path)

        if #wp_files == 0 then
            return
        end

        local candidates = {}

        for _, filename in ipairs(wp_files) do
            local path = wp_path .. filename

            if path ~= current_wallpaper or #wp_files == 1 then
                candidates[#candidates + 1] = path
            end
        end

        current_wallpaper =
            candidates[math.random(#candidates)]

        for s in screen do
            set_wallpaper(s)
        end
    end

    math.randomseed(os.time())

    wp_files = scandir(wp_path)

    if file_exists(preferred_wallpaper) then
        current_wallpaper = preferred_wallpaper
    elseif #wp_files > 0 then
        current_wallpaper =
            wp_path .. wp_files[math.random(#wp_files)]
    end

    awful.screen.connect_for_each_screen(function(s)
        s.padding = 6
        set_wallpaper(s)
    end)

    screen.connect_signal("property::geometry", function(s)
        set_wallpaper(s)
    end)

    gears.timer({
        timeout = 350,
        autostart = true,
        call_now = false,
        callback = random_wallpaper,
    })

    -- ============================================================
    -- MENU PRINCIPAL
    -- ============================================================

    local myawesomemenu = {
        {
            "Atajos de teclado",
            function()
                hotkeys_popup.show_help(nil, awful.screen.focused())
            end,
        },
        {"Manual", terminal .. " -e man awesome"},
        {"Editar configuracion",
            editor_cmd .. " " .. awesome.conffile},
        {"Reiniciar AwesomeWM", awesome.restart},
        {"Salir", awesome.quit},
    }

    local navegadores_internet = {
        {"Firefox", browser},
        {"Google Chrome", browserG},
    }

    local Developer = {
        {"Visual Studio Code", vscode},
        {"Kitty", terminal},
        {"Inkscape", ink},
        {"GIMP", gimp},
        {"Krita", krita},
    }

    local mymainmenu = awful.menu({
        items = {
            {
                "AwesomeWM",
                myawesomemenu,
                gears.filesystem.get_configuration_dir()
                    .. "icons/awesome-icon.png",
            },
            {"Navegadores", navegadores_internet},
            {"Developer", Developer},
            {"Abrir terminal", terminal},
            {"Archivos", archivos},
            {"Cambiar fondo", random_wallpaper},
        },
        theme = {
            width = 240,
            height = 24,
            border_width = 1,
            border_color = theme.purple,
            bg_normal = theme.bg,
            fg_normal = theme.fg,
            bg_focus = theme.bg_alt,
            fg_focus = theme.cyan,
        },
    })

    local mylauncher = awful.widget.launcher({
        image = gears.filesystem.get_configuration_dir()
            .. "icons/awesome-icon.png",
        menu = mymainmenu,
    })

    local mykeyboardlayout = awful.widget.keyboardlayout()
    local mytextclock = wibox.widget.textclock(" %a %d %b | %H:%M ")

    -- ============================================================
    -- BOTONES DE ESCRITORIOS
    -- ============================================================

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

        awful.button({modkey}, 3, function(t)
            if client.focus then
                client.focus:toggle_tag(t)
            end
        end),

        awful.button({}, 4, function(t)
            awful.tag.viewnext(t.screen)
        end),

        awful.button({}, 5, function(t)
            awful.tag.viewprev(t.screen)
        end)
    )

    -- ============================================================
    -- BOTONES DE VENTANAS
    -- ============================================================

    local tasklist_buttons = gears.table.join(
        awful.button({}, 1, function(c)
            if c == client.focus then
                c.minimized = true
            else
                c:emit_signal(
                    "request::activate",
                    "tasklist",
                    {raise = true}
                )
            end
        end),

        awful.button({}, 3, function()
            awful.menu.client_list({theme = {width = 280}})
        end),

        awful.button({}, 4, function()
            awful.client.focus.byidx(1)
        end),

        awful.button({}, 5, function()
            awful.client.focus.byidx(-1)
        end)
    )

    local clientbuttons = gears.table.join(
        awful.button({}, 1, function(c)
            c:emit_signal(
                "request::activate",
                "mouse_click",
                {raise = true}
            )
        end),

        awful.button({modkey}, 1, function(c)
            c:emit_signal(
                "request::activate",
                "mouse_click",
                {raise = true}
            )
            awful.mouse.client.move(c)
        end),

        awful.button({modkey}, 3, function(c)
            c:emit_signal(
                "request::activate",
                "mouse_click",
                {raise = true}
            )
            awful.mouse.client.resize(c)
        end)
    )

    -- ============================================================
    -- BARRA PERSONALIZADA
    -- ============================================================

    if type(throw_bar) == "function" then
        local ok, err = pcall(
            throw_bar,
            awful,
            set_wallpaper,
            tasklist_buttons,
            wibox,
            gears,
            taglist_buttons
        )

        if not ok then
            naughty.notify({
                title = "Error en bar.lua",
                text = tostring(err),
                timeout = 8,
            })
        end
    else
        naughty.notify({
            title = "Barra no disponible",
            text = "No se encontro la funcion throw_bar().",
            timeout = 6,
        })
    end

    -- ============================================================
    -- RATON
    -- ============================================================

    root.buttons(gears.table.join(
        awful.button({}, 3, function()
            mymainmenu:toggle()
        end),

        awful.button({}, 4, function()
            awful.tag.viewnext()
        end),

        awful.button({}, 5, function()
            awful.tag.viewprev()
        end)
    ))

    -- ============================================================
    -- ATAJOS DE TECLADO
    -- ============================================================

    if type(relizar_kyes) == "function" then
        local ok, err = pcall(
            relizar_kyes,
            modkey,
            awful,
            hotkeys_popup,
            gears,
            terminal
        )

        if not ok then
            naughty.notify({
                title = "Error en keys.lua",
                text = tostring(err),
                timeout = 8,
            })
        end
    end

    if type(globalkeys) == "table" then
        root.keys(globalkeys)
    else
        naughty.notify({
            title = "Atajos no disponibles",
            text = "globalkeys no esta definido.",
            timeout = 6,
        })
    end

    -- ============================================================
    -- REGLAS DE VENTANAS
    -- ============================================================

    awful.rules.rules = {
        {
            rule = {},
            properties = {
                border_width = beautiful.border_width,
                border_color = theme.border,
                focus = awful.client.focus.filter,
                raise = true,
                keys = clientkeys or gears.table.join(),
                buttons = clientbuttons,
                screen = awful.screen.preferred,
                placement =
                    awful.placement.no_overlap
                    + awful.placement.no_offscreen,
            },
        },

        {
            rule_any = {
                type = {"normal", "dialog"},
            },
            properties = {
                titlebars_enabled = false,
            },
        },

        {
            rule_any = {
                class = {
                    "Pavucontrol",
                    "Nm-connection-editor",
                },
            },
            properties = {
                floating = true,
            },
        },
    }

    -- ============================================================
    -- SEÑALES DE VENTANAS
    -- ============================================================

    client.connect_signal("manage", function(c)
        if awesome.startup
            and not c.size_hints.user_position
            and not c.size_hints.program_position
        then
            awful.placement.no_offscreen(c)
        end
    end)

    client.connect_signal("mouse::enter", function(c)
        if awful.client.focus.filter(c) then
            c:emit_signal(
                "request::activate",
                "mouse_enter",
                {raise = false}
            )
        end
    end)

    client.connect_signal("focus", function(c)
        c.border_color = theme.cyan
        c.opacity = 1
    end)

    client.connect_signal("unfocus", function(c)
        c.border_color = theme.border
        c.opacity = 0.94
    end)

    -- ============================================================
    -- APLICACIONES AL INICIO
    -- ============================================================

    local function run_once(cmd, process_name)
        if type(cmd) ~= "string" or cmd == "" then
            return
        end

        process_name = process_name or cmd:match("([^/]+)$")

        if not process_name then
            return
        end

        local check = string.format(
            'pgrep -u "$USER" -x %q >/dev/null 2>&1',
            process_name
        )

        awful.spawn.with_shell(check .. " || " .. cmd)
    end

    run_once(
    "picom --config ~/.config/picom/picom.conf",
    "picom"
)
    run_once(
        "/usr/lib/polkit-kde-authentication-agent-1",
        "polkit-kde-authentication-agent-1"
    )
    run_once("mpd", "mpd")

    -- ============================================================
    -- NOTIFICACIONES
    -- ============================================================

    naughty.config.defaults.timeout = 5
    naughty.config.defaults.bg = theme.bg_alt
    naughty.config.defaults.fg = theme.fg
    naughty.config.defaults.border_width = 2
    naughty.config.defaults.border_color = theme.cyan

    if awesome.startup_errors then
        naughty.notify({
            preset = naughty.config.presets.critical,
            title = "Error al iniciar AwesomeWM",
            text = tostring(awesome.startup_errors),
            timeout = 10,
        })
    end

    do
        local in_error = false

        awesome.connect_signal("debug::error", function(err)
            if in_error then
                return
            end

            in_error = true

            naughty.notify({
                preset = naughty.config.presets.critical,
                title = "AI Developer | Error",
                text = tostring(err),
                timeout = 8,
            })

            in_error = false
        end)
    end

    -- ============================================================
    -- FIN DE CONFIGURACION
    -- ============================================================
