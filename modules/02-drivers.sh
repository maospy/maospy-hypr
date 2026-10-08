#!/usr/bin/env bash
# Drivers de video según la placa detectada

gpu="$(lspci -nn | grep -iE 'vga|3d|display')"
info "Video detectado:"
echo "$gpu" | sed 's/^/     /'

pac mesa

if echo "$gpu" | grep -qi intel; then
    pac vulkan-intel intel-media-driver
fi
if echo "$gpu" | grep -qiE 'amd|ati|radeon'; then
    pac vulkan-radeon
fi
if echo "$gpu" | grep -qi nvidia; then
    warn "Placa NVIDIA detectada: los drivers NVIDIA se configuran aparte (nvidia-open)."
    warn "Ver: https://wiki.archlinux.org/title/NVIDIA"
fi

ok "Drivers listos"
