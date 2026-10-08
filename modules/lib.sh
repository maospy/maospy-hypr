#!/usr/bin/env bash
# Funciones comunes del instalador

FAILED=()
BACKUP_DIR=""

info() { echo -e "\e[36m==>\e[0m $*"; }
ok()   { echo -e "\e[32m ✓ \e[0m $*"; }
warn() { echo -e "\e[33m !  $*\e[0m"; }
die()  { echo -e "\e[31m ✗  $*\e[0m"; exit 1; }
step() { echo; echo -e "\e[1;34m━━━ $* ━━━\e[0m"; }

banner() {
    echo -e "\e[36m"
    echo "   maospy-hypr  ·  Hyprland + Nord sobre Arch Linux"
    echo -e "\e[0m"
}

# ask VAR "pregunta"  -> VAR=1 (sí, por defecto) o VAR=0
ask() {
    local var="$1" q="$2" r
    if [[ "$ALL" == 1 ]]; then printf -v "$var" 1; return; fi
    read -rp "   ¿Instalar $q? [S/n] " r
    case "${r,,}" in
        n|no) printf -v "$var" 0 ;;
        *)    printf -v "$var" 1 ;;
    esac
}

# Lee una lista de paquetes ignorando comentarios y líneas vacías
pkgs() { grep -vE '^\s*(#|$)' "$REPO_DIR/packages/$1"; }

pac() {
    sudo pacman -S --needed --noconfirm "$@" || { warn "Falló pacman: $*"; FAILED+=("pacman"); }
}

aur() {
    yay -S --needed --noconfirm --answerdiff None --answerclean None "$@" \
        || { warn "Falló AUR: $*"; FAILED+=("aur:$*"); }
}

# place ORIGEN DESTINO : copia respaldando lo que ya exista
place() {
    local src="$1" dest="$2"
    if [[ -e "$dest" ]]; then
        [[ -z "$BACKUP_DIR" ]] && BACKUP_DIR="$HOME/.config/maospy-backup-$(date +%Y%m%d-%H%M%S)" && mkdir -p "$BACKUP_DIR"
        mv "$dest" "$BACKUP_DIR/"
    fi
    mkdir -p "$(dirname "$dest")"
    cp -r "$src" "$dest"
    # Las configuraciones se guardaron con /home/maospy: adaptarlas al usuario actual
    grep -rlI "/home/maospy" "$dest" 2>/dev/null | xargs -r sed -i "s|/home/maospy|$HOME|g"
}
