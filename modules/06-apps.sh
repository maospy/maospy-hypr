#!/usr/bin/env bash
# Aplicaciones opcionales (según las respuestas del inicio)

[[ $OPT_SPOTIFY == 1 ]]     && { info "Spotify";            pac spotify-launcher; }
[[ $OPT_CHROME == 1 ]]      && { info "Google Chrome";      aur google-chrome; }
[[ $OPT_VSCODE == 1 ]]      && { info "Visual Studio Code"; aur visual-studio-code-bin; }
[[ $OPT_ANTIGRAVITY == 1 ]] && { info "Antigravity";        aur antigravity-ide; }
[[ $OPT_ONLYOFFICE == 1 ]]  && { info "OnlyOffice";         aur onlyoffice-bin; }

if [[ $OPT_PRINT == 1 ]]; then
    info "Impresoras (CUPS)"
    pac cups cups-pk-helper system-config-printer ghostscript
    sudo systemctl enable cups || true
fi

if [[ $OPT_AI == 1 ]]; then
    info "Node.js, Codex CLI y Claude Code"
    pac nodejs npm
    npm config set prefix "$HOME/.local"
    npm install -g @openai/codex || FAILED+=("codex")
    curl -fsSL https://claude.ai/install.sh | bash || FAILED+=("claude-code")
fi

ok "Aplicaciones listas"
