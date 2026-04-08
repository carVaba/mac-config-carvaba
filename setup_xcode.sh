#!/bin/bash

# --- Configuration & Colors ---
set -e
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
GREEN='\033[0;32m'
NC='\033[0m'

log() { echo -e "${BLUE}🚀 $1${NC}"; }
warn() { echo -e "${YELLOW}⚠️  $1${NC}"; }
success() { echo -e "${GREEN}✅ $1${NC}"; }

# --- 1. Apple Command Line Tools ---
log "Checking Apple Command Line Tools..."
if ! xcode-select -p &> /dev/null; then
    xcode-select --install
    warn "Please click 'Install' on the popup."
    warn "Wait for the UI installer to completely finish, then press Enter here to continue."
    read -p ""
fi

# --- 2. Homebrew Installation ---
log "Checking Homebrew..."
if ! command -v brew &> /dev/null; then
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi

# Set path for current session based on architecture
if [[ $(uname -m) == "arm64" ]]; then
    eval "$(/opt/homebrew/bin/brew shellenv)"
else
    eval "$(/usr/local/bin/brew shellenv)"
fi

# --- 3. Xcodes & Aria2 ---
log "Installing Xcodes CLI & Aria2..."
brew install aria2 xcodesorg/made/xcodes

# --- 4. Install Xcode ---
log "Starting Xcode Installation..."
warn "You will be prompted for your Apple ID / App Store Connect credentials."
xcodes install --latest

success "Xcode Setup Complete! You can now run ./first-setup.sh"
