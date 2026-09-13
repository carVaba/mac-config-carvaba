#!/bin/bash
# Idempotent Mac sync script. Takes NO arguments — run it as plain ./sync.sh,
# on a brand-new Mac (after setup_xcode.sh) or on an already-configured Mac,
# to install anything missing and converge it to this repo's state.
#
# Whether this machine installs GUI apps is read from a cache file written
# by first-setup.sh (see: ./first-setup.sh --no-gui). To flip it later,
# rerun first-setup.sh with --no-gui or --gui — sync.sh itself never takes
# flags, since it's meant to be re-run freely with no arguments.

set -e

YELLOW='\033[1;33m'
BLUE='\033[0;34m'
GREEN='\033[0;32m'
NC='\033[0m'

log() { echo -e "${BLUE}🚀 $1${NC}"; }
warn() { echo -e "${YELLOW}⚠️  $1${NC}"; }
success() { echo -e "${GREEN}✅ $1${NC}"; }

REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Machine-local preference: whether this Mac should skip GUI apps
# (e.g. a headless Mac mini). Lives outside the repo since it's
# per-machine state, not something to commit. Written by first-setup.sh
# --no-gui / --gui; sync.sh only ever reads it.
STATE_DIR="$HOME/.config/mac-config"
NO_GUI_MARKER="$STATE_DIR/no-gui"

# --- 0. Read the cached --no-gui preference, if any ---
read_no_gui_pref() {
    if [ -f "$NO_GUI_MARKER" ]; then
        NO_GUI=true
        log "Skipping GUI apps (cached --no-gui preference)."
    else
        NO_GUI=false
    fi
}

# --- 1. Homebrew ---
ensure_brew() {
    log "Checking Homebrew..."
    if ! command -v brew &> /dev/null; then
        /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    fi

    if [[ $(uname -m) == "arm64" ]]; then
        eval "$(/opt/homebrew/bin/brew shellenv)"
    else
        eval "$(/usr/local/bin/brew shellenv)"
    fi
}

# --- 2. Packages, single-sourced from Brewfile (+ Brewfile.gui unless --no-gui) ---
install_packages() {
    log "Installing/updating CLI packages from Brewfile..."
    brew bundle --file="$REPO_DIR/Brewfile"

    if [ "$NO_GUI" = true ]; then
        log "Skipping GUI apps (--no-gui mode)."
    else
        log "Installing/updating GUI apps from Brewfile.gui..."
        brew bundle --file="$REPO_DIR/Brewfile.gui"
    fi
}

# --- 3. Neovim config present ---
ensure_nvim_config() {
    mkdir -p "$HOME/.config"
    if [ ! -d "$HOME/.config/nvim" ]; then
        log "Cloning Neovim config..."
        git clone https://github.com/carVaba/nvim-carvaba.git "$HOME/.config/nvim"
    fi
}

# --- 4. Oh My Zsh + plugins ---
ensure_oh_my_zsh() {
    log "Checking Oh My Zsh..."
    if [ ! -d "$HOME/.oh-my-zsh" ]; then
        sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
    fi

    local ZSH_CUSTOM="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}"

    [[ ! -d "$ZSH_CUSTOM/plugins/zsh-autosuggestions" ]] && git clone "https://github.com/zsh-users/zsh-autosuggestions" "$ZSH_CUSTOM/plugins/zsh-autosuggestions"
    [[ ! -d "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting" ]] && git clone "https://github.com/zsh-users/zsh-syntax-highlighting" "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting"
    true
}

# --- 5. Symlink the repo zshrc onto ~/.zshrc ---
sync_zshrc() {
    log "Syncing zshrc..."
    local repo_zshrc="$REPO_DIR/zshrc"
    local target="$HOME/.zshrc"

    if [ -L "$target" ] && [ "$(readlink "$target")" = "$repo_zshrc" ]; then
        log "~/.zshrc already linked to repo zshrc, skipping."
        return
    fi

    if [ -e "$target" ] || [ -L "$target" ]; then
        local backup="$HOME/.zshrc.backup.$(date +%Y%m%d%H%M%S)"
        warn "Backing up existing ~/.zshrc to $backup"
        mv "$target" "$backup"
    fi

    ln -s "$repo_zshrc" "$target"
    success "~/.zshrc -> $repo_zshrc"
}

# --- 6. Misc one-off config (safe to re-run) ---
configure_misc() {
    log "Configuring Ruby via mise..."
    eval "$(mise activate bash)"
    mise settings ruby.compile=false
    mise use --global ruby@3.4.3

    log "Setting macOS defaults..."
    defaults write -g ApplePressAndHoldEnabled -bool false

    log "Configuring git delta pager..."
    git config --global core.pager "delta"
    git config --global delta.side-by-side true
}

main() {
    read_no_gui_pref
    ensure_brew
    install_packages
    ensure_nvim_config
    ensure_oh_my_zsh
    sync_zshrc
    configure_misc

    success "SYNC COMPLETE!"
    echo "1. Run 'gh auth login' if this is a new machine."
    echo "2. Run 'source ~/.zshrc' or restart your terminal to pick up changes."
    if [ "$NO_GUI" = true ]; then
        echo "3. This Mac is set to --no-gui. Run './first-setup.sh --gui' to re-enable GUI apps."
    fi
}

main
