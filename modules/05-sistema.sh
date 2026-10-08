#!/usr/bin/env bash
# Tema oscuro, login SDDM maospy, servicios y ajustes del sistema

info "Activando modo oscuro (GTK)"
gsettings set org.gnome.desktop.interface gtk-theme 'Adwaita-dark' 2>/dev/null \
    && gsettings set org.gnome.desktop.interface color-scheme 'prefer-dark' 2>/dev/null \
    || warn "gsettings no disponible ahora; se usan los archivos gtk-3.0/gtk-4.0"

info "Instalando el tema de login maospy (SDDM)"
sudo cp -r "$REPO_DIR/sddm/maospy" /usr/share/sddm/themes/
sudo mkdir -p /etc/sddm.conf.d
printf "[Theme]\nCurrent=maospy\n" | sudo tee /etc/sddm.conf.d/maospy.conf >/dev/null

info "Ajuste para dongles Bluetooth Realtek (sin autosuspend)"
sudo install -Dm644 "$REPO_DIR/system/modprobe.d/btusb.conf" /etc/modprobe.d/btusb.conf

info "Activando servicios"
sudo systemctl enable NetworkManager bluetooth sddm || FAILED+=("servicios")

ok "Sistema configurado"
