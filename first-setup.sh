#!/bin/bash

# --- Configuration & Colors ---
set -e # Exit on error
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
GREEN='\033[0;32m'
NC='\033[0m'

log() { echo -e "${BLUE}🚀 $1${NC}"; }
warn() { echo -e "${YELLOW}⚠️  $1${NC}"; }
success() { echo -e "${GREEN}✅ $1${NC}"; }

# --- 1. Environment & Architecture ---
setup_arch() {
    if [[ $(uname -m) == "arm64" ]]; then
        HOMEBREW_PREFIX="/opt/homebrew"
    else
        HOMEBREW_PREFIX="/usr/local"
    fi
    # Immediate path availability for the current script
    eval "$($HOMEBREW_PREFIX/bin/brew shellenv 2>/dev/null || true)"
}

# --- 2. Core Dependencies ---
install_base_tools() {
    log "Checking Xcode Command Line Tools..."
    if ! xcode-select -p &> /dev/null; then
        xcode-select --install
        warn "Wait for the UI installer to finish, then press Enter."
        read -p ""
    fi

    log "Checking Homebrew..."
    if ! command -v brew &> /dev/null; then
        /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    fi
    setup_arch
}

# --- 3. Package Management (CLI & GUI) ---
install_packages() {
    log "Installing Brew Packages..."
    # Using 'mise' for 2026 standard env management
    local packages=(
        fd fzf gh ripgrep mise git-delta neovim 
        aria2 xcodesorg/made/xcodes exiftool bat jq 
        xcbeautify zoxide eza tldr tmux swiftlint
    )
    brew install "${packages[@]}"

    log "Installing GUI applications..."
    local casks=(iterm2 sublime-text sublime-merge proxyman)
    brew install --cask "${casks[@]}"
}

# --- 4. Configuration (Neovim & Ruby) ---
configure_apps() {
    log "Setting up Neovim..."
    mkdir -p "$HOME/.config"
    if [ ! -d "$HOME/.config/nvim" ]; then
        git clone https://github.com/carVaba/nvim-carvaba.git "$HOME/.config/nvim"
    fi

    log "Configuring Ruby via Mise (Modern rbenv alternative)..."
    if ! grep -q 'eval "$(mise activate zsh)"' "$HOME/.zshrc"; then
        echo 'eval "$(mise activate zsh)"' >> "$HOME/.zshrc"
    fi
    eval "$(mise activate bash)"
    mise use --global ruby@3.4.3
}

# --- 5. Shell & System ---
configure_shell() {
    log "Setting up Oh My Zsh..."
    if [ ! -d "$HOME/.oh-my-zsh" ]; then
        sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
    fi

    local ZSH_CUSTOM="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}"
    
    # Plugin cloning helper
    clone_plugin() {
        [[ ! -d "$ZSH_CUSTOM/plugins/$1" ]] && git clone "https://github.com/zsh-users/$1" "$ZSH_CUSTOM/plugins/$1"
    }

    clone_plugin "zsh-autosuggestions"
    clone_plugin "zsh-syntax-highlighting"

    # Idempotent plugin update
    log "Updating .zshrc plugins..."
    sed -i '' 's/^plugins=(.*/plugins=(git zsh-autosuggestions zsh-syntax-highlighting sublime zoxide)/' "$HOME/.zshrc"
    
    log "Setting macOS defaults..."
    defaults write -g ApplePressAndHoldEnabled -bool false
    git config --global core.pager "delta"
    git config --global delta.side-by-side true
}

# --- Main Execution ---
main() {
    setup_arch
    install_base_tools
    install_packages
    configure_apps
    configure_shell

    success "CORE SETUP COMPLETE!"
    echo "1. Run 'gh auth login' to finish GitHub setup."
    echo "2. Run 'source ~/.zshrc' to refresh your current terminal."
}

main "$@"
