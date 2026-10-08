#!/usr/bin/env bash
# XAMPP 8.2 (opcional) con las dependencias de 32 bits que evitan el error clásico

XAMPP_URL="https://sourceforge.net/projects/xampp/files/XAMPP%20Linux/8.2.12/xampp-linux-x64-8.2.12-0-installer.run/download"

if [[ $OPT_XAMPP == 1 ]]; then
    info "Dependencias de XAMPP (multilib y compatibilidad)"
    pac lib32-gcc-libs libxcrypt-compat net-tools inetutils
    aur ncurses5-compat-libs

    if [[ -d /opt/lampp ]]; then
        ok "XAMPP ya estaba instalado en /opt/lampp"
    else
        info "Descargando XAMPP 8.2.12"
        tmp="$(mktemp -d)"
        if curl -fL -o "$tmp/xampp.run" "$XAMPP_URL"; then
            chmod +x "$tmp/xampp.run"
            info "Instalando XAMPP (tarda un par de minutos, sin mostrar nada)"
            sudo "$tmp/xampp.run" --mode unattended || FAILED+=("xampp")
        else
            warn "No se pudo descargar XAMPP"; FAILED+=("xampp-descarga")
        fi
        rm -rf "$tmp"
    fi

    if [[ -d /opt/lampp ]]; then
        info "Servicio para que XAMPP arranque con la PC"
        sudo install -Dm644 "$REPO_DIR/system/xampp.service" /etc/systemd/system/xampp.service
        sudo /opt/lampp/lampp stop &>/dev/null
        sudo systemctl daemon-reload
        sudo systemctl enable xampp
        sudo chown -R "$USER:$USER" /opt/lampp/htdocs
        ok "XAMPP listo: http://localhost  (proyectos en /opt/lampp/htdocs)"
    fi
fi
