#!/usr/bin/env bash
# Hyprland, barra, dock, launcher, audio, bluetooth, fuentes y temas

info "Instalando el escritorio Hyprland"
pac $(pkgs hyprland.txt)

info "Instalando fuentes y temas"
pac $(pkgs tema.txt)

info "Instalando paquetes del AUR del escritorio"
aur $(pkgs aur.txt)

ok "Escritorio instalado"
