
-- keys.lua
local awful = require("awful")
local gears = require("gears")

local function setup_keys(modkey, terminal)
    local globalkeys = gears.table.join(
        -- Ayuda
        awful.key({modkey}, "s", function()
            require("awful.hotkeys_popup").show_help(
                nil, awful.screen.focused()
            )
        end, { description = "Mostrar atajos", group = "Awesome" }),

        -- Lanzadores
        awful.key({modkey}, "Return", function()
            awful.spawn(terminal)
        end, { description = "Abrir terminal", group = "Lanzador" }),

        awful.key({modkey}, "r", function()
            awful.screen.focused().mypromptbox:run()
        end, { description = "Ejecutar comando", group = "Lanzador" }),

        awful.key({modkey}, "w", function()
            if _G.mymainmenu then
                _G.mymainmenu:toggle()
            end
        end, { description = "Menú", group = "Lanzador" }),

        -- Foco y escritorios
        awful.key({modkey, "Control"}, "Left", awful.tag.viewprev,
            { description = "Escritorio anterior", group = "Escritorios" }),
        awful.key({modkey, "Control"}, "Right", awful.tag.viewnext,
            { description = "Escritorio siguiente", group = "Escritorios" }),

        awful.key({modkey}, "Tab", function()
            awful.client.focus.history.previous()
            if client.focus then
                client.focus:raise()
            end
        end, { description = "Ventana anterior", group = "Ventanas" }),

        awful.key({modkey}, "space", function()
            awful.layout.inc(1)
        end, { description = "Siguiente distribución", group = "Diseño" }),

        awful.key({modkey, "Shift"}, "space", function()
            awful.layout.inc(-1)
        end, { description = "Distribución anterior", group = "Diseño" }),

        -- Awesome
        awful.key({modkey, "Control"}, "r", awesome.restart,
            { description = "Reiniciar Awesome", group = "Awesome" }),
        awful.key({modkey, "Shift"}, "q", awesome.quit,
            { description = "Salir de Awesome", group = "Awesome" }),

        -- Captura de pantalla
        awful.key({modkey, "Shift"}, "s", function()
            awful.spawn.with_shell(
                'mkdir -p "$HOME/Pictures" && ' ..
                'scrot -s "$HOME/Pictures/screenshot-%Y%m%d-%H%M%S.png"'
            )
        end, { description = "Capturar una región", group = "Sistema" }),

        -- Música: requiere MPD y MPC
        awful.key({"Mod1", "Shift"}, "w", function()
            awful.spawn.with_shell("mpc toggle")
        end, { description = "Reproducir / pausar", group = "Música" }),
        awful.key({"Mod1", "Shift"}, "s", function()
            awful.spawn.with_shell("mpc next")
        end, { description = "Siguiente canción", group = "Música" }),
        awful.key({"Mod1", "Shift"}, "a", function()
            awful.spawn.with_shell("mpc prev")
        end, { description = "Canción anterior", group = "Música" }),
        awful.key({"Mod1", "Shift"}, "x", function()
            awful.spawn.with_shell("mpc volume -3")
        end, { description = "Bajar volumen de MPD", group = "Música" }),
        awful.key({"Mod1", "Shift"}, "z", function()
            awful.spawn.with_shell("mpc volume +3")
        end, { description = "Subir volumen de MPD", group = "Música" }),

        -- Menubar
        awful.key({modkey}, "p", function()
            require("menubar").show()
        end, { description = "Lanzador de aplicaciones", group = "Lanzador" })
    )

    local clientkeys = gears.table.join(
        awful.key({modkey}, "f", function(c)
            c.fullscreen = not c.fullscreen
            c:raise()
        end, { description = "Pantalla completa", group = "Ventanas" }),

        awful.key({modkey, "Shift"}, "c", function(c)
            c:kill()
        end, { description = "Cerrar ventana", group = "Ventanas" }),

        awful.key({modkey}, "m", function(c)
            c.maximized = not c.maximized
            c:raise()
        end, { description = "Maximizar", group = "Ventanas" }),

        awful.key({modkey}, "n", function(c)
            c.minimized = true
        end, { description = "Minimizar", group = "Ventanas" }),

        awful.key({modkey, "Control"}, "space",
            awful.client.floating.toggle,
            { description = "Alternar flotante", group = "Ventanas" }),

        awful.key({modkey}, "t", function(c)
            c.ontop = not c.ontop
        end, { description = "Mantener encima", group = "Ventanas" }),

        awful.key({modkey, "Control"}, "Return", function(c)
            c:swap(awful.client.getmaster())
        end, { description = "Convertir en ventana principal", group = "Ventanas" })
    )

    -- Cambiar el foco con Mod4 + flechas.
    globalkeys = gears.table.join(
        globalkeys,
        awful.key({modkey}, "Left", function()
            awful.client.focus.byidx(-1)
            if client.focus then client.focus:raise() end
        end, { description = "Foco anterior", group = "Ventanas" }),
        awful.key({modkey}, "Right", function()
            awful.client.focus.byidx(1)
            if client.focus then client.focus:raise() end
        end, { description = "Foco siguiente", group = "Ventanas" })
    )

    -- Atajos de escritorios 1 a 9.
    for i = 1, 9 do
        globalkeys = gears.table.join(globalkeys,
            awful.key({modkey}, "#" .. (i + 9), function()
                local tag = awful.screen.focused().tags[i]
                if tag then tag:view_only() end
            end, {
                description = "Ir al escritorio " .. i,
                group = "Escritorios",
            }),

            awful.key({modkey, "Shift"}, "#" .. (i + 9), function()
                if client.focus then
                    local tag = client.focus.screen.tags[i]
                    if tag then
                        client.focus:move_to_tag(tag)
                        tag:view_only()
                    end
                end
            end, {
                description = "Mover ventana al escritorio " .. i,
                group = "Escritorios",
            })
        )
    end

    return globalkeys, clientkeys
end

return setup_keys
