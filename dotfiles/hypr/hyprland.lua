-- ==========================================
--  maospy-rice :: hyprland.lua  v0.1
-- ==========================================

---- MONITOR ----
hl.monitor({ output = "", mode = "preferred", position = "auto", scale = "auto" })

---- PROGRAMAS ----
local terminal = "kitty"
local menu     = "fuzzel"

---- AUTOARRANQUE ----
hl.on("hyprland.start", function ()
    hl.exec_cmd("waybar")
    hl.exec_cmd("swaync")
    hl.exec_cmd("systemctl --user start hyprpolkitagent")
    hl.exec_cmd("awww-daemon")
    hl.exec_cmd("sleep 1 && waypaper --restore")
    hl.exec_cmd("nwg-dock-hyprland -r -x -i 40 -mb 8 -c fuzzel")
    hl.exec_cmd("hypridle")
end)

---- VARIABLES ----
hl.env("XCURSOR_SIZE", "24")
hl.env("HYPRCURSOR_SIZE", "24")
hl.env("QT_QPA_PLATFORMTHEME", "qt6ct")

---- APARIENCIA (Nord, liviano) ----
hl.config({
    general = {
        gaps_in  = 4,
        gaps_out = 10,
        border_size = 2,
        col = {
            active_border   = { colors = {"rgba(88c0d0ee)", "rgba(81a1c1ee)"}, angle = 45 },
            inactive_border = "rgba(4c566aaa)",
        },
        resize_on_border = true,
        layout = "dwindle",
    },
    decoration = {
        rounding = 8,
        rounding_power = 2,
        shadow = { enabled = false },
        blur   = { enabled = true, size = 3, passes = 1 },
    },
    animations = { enabled = true },
    dwindle = { preserve_split = true },
 
    misc = {
        force_default_wallpaper = 0,
        disable_hyprland_logo   = true,
    },
    input = {
        kb_layout = "latam",
        numlock_by_default = true,
        follow_mouse = 1,
        sensitivity = 0,
    },
})

---- ANIMACIONES (pocas y rapidas) ----
hl.curve("easeOutQuint", { type = "bezier", points = { {0.23, 1}, {0.32, 1} } })
hl.curve("almostLinear", { type = "bezier", points = { {0.5, 0.5}, {0.75, 1} } })
hl.animation({ leaf = "global",     enabled = true, speed = 10,  bezier = "default" })
hl.animation({ leaf = "windows",    enabled = true, speed = 4,   bezier = "easeOutQuint", style = "popin 87%" })
hl.animation({ leaf = "fade",       enabled = true, speed = 3,   bezier = "almostLinear" })
hl.animation({ leaf = "workspaces", enabled = true, speed = 2,   bezier = "almostLinear", style = "fade" })

---- ATAJOS (estilo Omarchy) ----
local mod = "SUPER"

hl.bind(mod .. " + RETURN", hl.dsp.exec_cmd(terminal))
hl.bind(mod .. " + SPACE",  hl.dsp.exec_cmd(menu))
hl.bind(mod .. " + Q",      hl.dsp.window.close())
hl.bind(mod .. " + V",      hl.dsp.window.float({ action = "toggle" }))
hl.bind(mod .. " + T",      hl.dsp.layout("togglesplit"))
hl.bind(mod .. " + N",      hl.dsp.exec_cmd("swaync-client -t -sw"))
hl.bind(mod .. " + W",      hl.dsp.exec_cmd("waypaper"))
hl.bind(mod .. " + M",      hl.dsp.exec_cmd("command -v hyprshutdown >/dev/null 2>&1 && hyprshutdown || hyprctl dispatch 'hl.dsp.exit()'"))

-- Foco: flechas y H/J/K/L
hl.bind(mod .. " + left",  hl.dsp.focus({ direction = "left" }))
hl.bind(mod .. " + right", hl.dsp.focus({ direction = "right" }))
hl.bind(mod .. " + up",    hl.dsp.focus({ direction = "up" }))
hl.bind(mod .. " + down",  hl.dsp.focus({ direction = "down" }))
hl.bind(mod .. " + H", hl.dsp.focus({ direction = "left" }))
hl.bind(mod .. " + L", hl.dsp.focus({ direction = "right" }))
hl.bind(mod .. " + K", hl.dsp.focus({ direction = "up" }))
hl.bind(mod .. " + J", hl.dsp.focus({ direction = "down" }))

-- Escritorios 1-10
for i = 1, 10 do
    local key = i % 10
    hl.bind(mod .. " + " .. key,         hl.dsp.focus({ workspace = i }))
    hl.bind(mod .. " + SHIFT + " .. key, hl.dsp.window.move({ workspace = i }))
end
hl.bind(mod .. " + mouse_down", hl.dsp.focus({ workspace = "e+1" }))
hl.bind(mod .. " + mouse_up",   hl.dsp.focus({ workspace = "e-1" }))

-- Mover/redimensionar con el mouse
hl.bind(mod .. " + mouse:272", hl.dsp.window.drag(),   { mouse = true })
hl.bind(mod .. " + mouse:273", hl.dsp.window.resize(), { mouse = true })

-- Volumen
hl.bind("XF86AudioRaiseVolume", hl.dsp.exec_cmd("wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 5%+"), { locked = true, repeating = true })
hl.bind("XF86AudioLowerVolume", hl.dsp.exec_cmd("wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"),      { locked = true, repeating = true })
hl.bind("XF86AudioMute",        hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"),     { locked = true })

---- REGLAS DE VENTANAS ----
hl.window_rule({
    name = "suppress-maximize-events",
    match = { class = ".*" },
    suppress_event = "maximize",
})
hl.window_rule({
    name = "fix-xwayland-drags",
    match = { class = "^$", title = "^$", xwayland = true, float = true, fullscreen = false, pin = false },
    no_focus = true,
})

-- Mezclador de audio flotante
hl.window_rule({
    name  = "pavucontrol-float",
    match = { class = "org.pulseaudio.pavucontrol" },
    float = true,
})

-- Menu de energia
hl.bind("SUPER + ESCAPE", hl.dsp.exec_cmd("$HOME/.local/bin/maospy-power"))

-- Capturas de pantalla
hl.bind("Print",             hl.dsp.exec_cmd("$HOME/.local/bin/maospy-screenshot full"))
hl.bind("SUPER + SHIFT + S", hl.dsp.exec_cmd("$HOME/.local/bin/maospy-screenshot area"))

-- Historial del portapapeles
hl.bind("SUPER + CTRL + V", hl.dsp.exec_cmd("cliphist list | fuzzel --dmenu --prompt 'Portapapeles > ' | cliphist decode | wl-copy"))
hl.on("hyprland.start", function ()
    hl.exec_cmd("wl-paste --watch cliphist store")
end)

-- Blueman flotante
hl.window_rule({
    name  = "blueman-float",
    match = { class = ".*blueman-manager.*" },
    float = true,
})
