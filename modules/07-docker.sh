#!/usr/bin/env bash
# Docker (opcional)

if [[ $OPT_DOCKER == 1 ]]; then
    info "Instalando Docker"
    pac docker docker-compose docker-buildx
    sudo systemctl enable docker || FAILED+=("docker")
    sudo usermod -aG docker "$USER"
    ok "Docker listo (funciona sin sudo después de reiniciar)"
fi
