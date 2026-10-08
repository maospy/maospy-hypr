# maospy-hypr

Escritorio **Hyprland** estilo Omarchy, con colores **Nord**, sobre **Arch Linux minimal**.

![maospy-hypr](wallpapers/maospy-nord.png)

## Qué incluye

- **Hyprland** (configuración Lua, atajos estilo Omarchy, teclado latam)
- **Waybar** Nord: escritorios, reloj en español, volumen, Bluetooth, red, CPU, RAM, notificaciones y botón de energía
- **Dock** fijo (nwg-dock-hyprland) y **launcher** Fuzzel
- **Wallpapers** con awww + Waypaper, en 7 paletas (Nord, Catppuccin, Dracula, Everforest, Gruvbox, Rosé Pine, Tokyo Night)
- **Login SDDM** con tema propio maospy
- **Bloqueo** de pantalla (hyprlock), bloqueo automático (hypridle) y **menú de energía**
- **Capturas** de pantalla e **historial del portapapeles**
- Modo oscuro para apps GTK y Qt/KDE (Dolphin)
- Opcionales: Chrome, VS Code, Antigravity, OnlyOffice, Spotify, Codex CLI, Claude Code, Docker, XAMPP 8.2 e impresoras

## Instalación

1. Instalá Arch Linux con `archinstall` usando el perfil **Minimal**, NetworkManager y un usuario con sudo.
2. Iniciá sesión con tu usuario y ejecutá:

```bash
sudo pacman -S --needed git
git clone https://github.com/maospy/maospy-hypr.git
cd maospy-hypr
./install.sh
```

Al principio pregunta qué aplicaciones opcionales querés. Después instala todo solo. Al terminar: `reboot`.

Para instalar todo sin preguntas: `./install.sh --todo`

Las configuraciones que ya tengas en `~/.config` se respaldan en `~/.config/maospy-backup-FECHA/`.

## Atajos principales

| Atajo | Acción |
|---|---|
| Super + Enter | Terminal (kitty) |
| Super + Espacio | Launcher (Fuzzel) |
| Super + Q | Cerrar ventana |
| Super + 1…0 | Cambiar de escritorio |
| Super + Shift + 1…0 | Mover ventana a otro escritorio |
| Super + H/J/K/L o flechas | Mover el foco |
| Super + V | Ventana flotante |
| Super + W | Elegir wallpaper |
| Super + N | Panel de notificaciones |
| Super + Esc | Menú de energía |
| Impr Pant | Captura de pantalla completa |
| Super + Shift + S | Captura de una zona |
| Super + Ctrl + V | Historial del portapapeles |
| Super + M | Cerrar sesión |

## Notas

- El teclado está configurado como **latam**. Para cambiarlo, editá `KB_X11` y `KB_CONSOLE` en `install.sh` y `kb_layout` en `dotfiles/hypr/hyprland.lua`.
- Waybar usa `ext/workspaces` temporalmente, por un error de Waybar 0.15.0 con la configuración Lua de Hyprland.
- Placas NVIDIA: los drivers se configuran aparte.

## Licencia

MIT. Los componentes externos conservan sus propias licencias.
