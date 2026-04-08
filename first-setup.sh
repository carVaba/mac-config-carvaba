#!/bin/bash

# --- Configuration & Colors ---
set -e
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
GREEN='\033[0;32m'
NC='\033[0m'

log() { echo -e "${BLUE}🚀 $1${NC}"; }
success() { echo -e "${GREEN}✅ $1${NC}"; }

# --- 1. Environment ---
# We still need this in case you ran the first script, closed the terminal, and came back later!
if [[ $(uname -m) == "arm64" ]]; then
    eval "$(/opt/homebrew/bin/brew shellenv 2>/dev/null || true)"
else
    eval "$(/usr/local/bin/brew shellenv 2>/dev/null || true)"
fi

# --- 2. Package Management (CLI & GUI) ---
install_packages() {
    log "Installing Brew Packages..."
    # aria2 and xcodes have been removed from this list
    local packages=(
        fd fzf gh ripgrep mise git-delta neovim 
        exiftool bat jq xcbeautify zoxide eza tldr tmux swiftlint node font-hack-nerd-font tree-sitter-cli
    )
    brew install "${packages[@]}"

    log "Installing GUI applications..."
    local casks=(iterm2 sublime-text sublime-merge proxyman)
    brew install --cask "${casks[@]}"
}

# --- 3. Configuration (Neovim & Ruby) ---
configure_apps() {
    log "Setting up Neovim..."
    mkdir -p "$HOME/.config"
    if [ ! -d "$HOME/.config/nvim" ]; then
        git clone https://github.com/carVaba/nvim-carvaba.git "$HOME/.config/nvim"
    fi

    log "Configuring Ruby via Mise..."
    if ! grep -q 'eval "$(mise activate zsh)"' "$HOME/.zshrc"; then
        echo 'eval "$(mise activate zsh)"' >> "$HOME/.zshrc"
    fi
    eval "$(mise activate bash)"
    mise settings ruby.compile=false
    mise use --global ruby@3.4.3
}

# --- 4. Shell & System ---
configure_shell() {
    log "Setting up Oh My Zsh..."
    if [ ! -d "$HOME/.oh-my-zsh" ]; then
        sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
    fi

    local ZSH_CUSTOM="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}"
    
    [[ ! -d "$ZSH_CUSTOM/plugins/zsh-autosuggestions" ]] && git clone "https://github.com/zsh-users/zsh-autosuggestions" "$ZSH_CUSTOM/plugins/zsh-autosuggestions"
    [[ ! -d "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting" ]] && git clone "https://github.com/zsh-users/zsh-syntax-highlighting" "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting"

    log "Updating .zshrc plugins..."
    sed -i '' 's/^plugins=(.*/plugins=(git zsh-autosuggestions zsh-syntax-highlighting sublime zoxide)/' "$HOME/.zshrc"
    
    log "Setting macOS defaults..."
    defaults write -g ApplePressAndHoldEnabled -bool false
    git config --global core.pager "delta"
    git config --global delta.side-by-side true
}

# --- Main Execution ---
main() {
    install_packages
    configure_apps
    configure_shell

    success "ENVIRONMENT SETUP COMPLETE!"
    echo "1. Run 'gh auth login' to finish GitHub setup."
    echo "2. Run 'source ~/.zshrc' to refresh your current terminal."
}

main "$@"
