#!/usr/bin/env bash
# ==========================================================
#  maospy-hypr :: instalador
#  Hyprland estilo Omarchy sobre Arch Linux minimal
#  Uso:  ./install.sh          (pregunta qué apps instalar)
#        ./install.sh --todo   (instala todo sin preguntar)
# ==========================================================
set -uo pipefail

REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
LOG="$HOME/maospy-install.log"
export REPO_DIR LOG

# Distribución de teclado (Hyprland, SDDM y consola)
KB_X11="latam"
KB_CONSOLE="la-latin1"

source "$REPO_DIR/modules/lib.sh"

# ---------- Comprobaciones ----------
[[ $EUID -eq 0 ]] && die "No ejecutes el instalador como root. Usá tu usuario normal (se pedirá sudo)."
command -v pacman >/dev/null || die "Este instalador es solo para Arch Linux."
ping -c1 -W3 archlinux.org &>/dev/null || die "Sin conexión a internet."

ALL=0
[[ "${1:-}" == "--todo" ]] && ALL=1

banner

# ---------- Preguntas (todas al inicio, después corre solo) ----------
info "Elegí qué instalar además del escritorio:"
ask OPT_CHROME      "Google Chrome"
ask OPT_VSCODE      "Visual Studio Code"
ask OPT_ANTIGRAVITY "Antigravity (IDE de Google)"
ask OPT_ONLYOFFICE  "OnlyOffice"
ask OPT_SPOTIFY     "Spotify"
ask OPT_AI          "Codex CLI y Claude Code"
ask OPT_DOCKER      "Docker y Docker Compose"
ask OPT_XAMPP       "XAMPP 8.2 (Apache, MariaDB, PHP)"
ask OPT_PRINT       "Soporte de impresoras (CUPS)"
echo

# ---------- sudo durante toda la instalación ----------
info "Se necesita tu contraseña para instalar paquetes."
sudo -v || die "No se pudo obtener sudo."
( while true; do sudo -n true; sleep 50; kill -0 "$$" 2>/dev/null || exit; done ) 2>/dev/null &

# ---------- Registro ----------
exec > >(tee -a "$LOG") 2>&1
info "Registro de la instalación: $LOG"

# ---------- Módulos ----------
for m in "$REPO_DIR"/modules/[0-9]*.sh; do
    step "$(basename "$m" .sh)"
    source "$m"
done

# ---------- Fin ----------
echo
ok "¡maospy-hypr instalado!"
[[ -n "${BACKUP_DIR:-}" && -d "$BACKUP_DIR" ]] && info "Tus configuraciones anteriores quedaron en: $BACKUP_DIR"
[[ ${#FAILED[@]} -gt 0 ]] && warn "Pasos con errores (revisá el registro): ${FAILED[*]}"
echo
info "Reiniciá para entrar con el login maospy:  reboot"
