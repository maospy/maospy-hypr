#!/usr/bin/env bash
# Copia las configuraciones de maospy a ~/.config (con respaldo)

info "Copiando configuraciones a ~/.config"
for d in "$REPO_DIR"/dotfiles/*/; do
    name="$(basename "$d")"
    if [[ "$name" == "kde" ]]; then
        # kdeglobals, dolphinrc, ... van sueltos en ~/.config
        for f in "$d"*; do place "$f" "$HOME/.config/$(basename "$f")"; done
    else
        place "${d%/}" "$HOME/.config/$name"
    fi
    ok "$name"
done

info "Instalando scripts maospy en ~/.local/bin"
mkdir -p "$HOME/.local/bin"
cp "$REPO_DIR"/bin/* "$HOME/.local/bin/"
chmod +x "$HOME"/.local/bin/maospy-*

info "Copiando wallpapers a ~/Wallpapers"
mkdir -p "$HOME/Wallpapers"
cp -n "$REPO_DIR"/wallpapers/* "$HOME/Wallpapers/"

if ! grep -q '.local/bin' "$HOME/.bashrc" 2>/dev/null; then
    echo 'export PATH="$HOME/.local/bin:$PATH"' >> "$HOME/.bashrc"
fi
export PATH="$HOME/.local/bin:$PATH"

info "Instalando temas maospy (paletas de colores)"
mkdir -p "$HOME/.local/share/maospy"
cp -r "$REPO_DIR/themes" "$REPO_DIR/templates" "$HOME/.local/share/maospy/"
cp "$REPO_DIR/keybinds.txt" "$HOME/.local/share/maospy/"
"$HOME/.local/bin/maospy-theme" nord

ok "Configuraciones copiadas"
