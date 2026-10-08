#!/usr/bin/env bash
# Base: multilib, actualización, herramientas, yay, carpetas y teclado

info "Activando el repositorio multilib"
if ! grep -q '^\[multilib\]' /etc/pacman.conf; then
    sudo sed -i '/^#\[multilib\]$/,/^#Include/ s/^#//' /etc/pacman.conf
fi

info "Actualizando el sistema"
sudo pacman -Syu --noconfirm || FAILED+=("actualizacion")

info "Instalando herramientas base"
pac $(pkgs base.txt)

if ! command -v yay >/dev/null; then
    info "Instalando yay (AUR)"
    tmp="$(mktemp -d)"
    git clone https://aur.archlinux.org/yay-bin.git "$tmp/yay-bin" \
        && (cd "$tmp/yay-bin" && makepkg -si --noconfirm) \
        || FAILED+=("yay")
    rm -rf "$tmp"
fi

info "Creando carpetas personales (Descargas, Documentos, ...)"
xdg-user-dirs-update

info "Teclado: $KB_X11"
sudo localectl set-x11-keymap "$KB_X11" || true
sudo localectl set-keymap "$KB_CONSOLE" || true

ok "Base lista"
