#!/bin/bash
# One-shot bootstrap for a brand-new Mac. Run ./setup_xcode.sh first.
#
# Usage:
#   ./first-setup.sh              install everything (CLI + GUI)
#   ./first-setup.sh --no-gui     terminal tools only (e.g. a headless Mac
#                                 mini) — remembered for future ./sync.sh runs
#   ./first-setup.sh --gui        forget --no-gui and go back to GUI apps
#
# This script writes the GUI preference to a machine-local cache, then hands
# off to sync.sh (which takes no arguments) for the actual, idempotent
# package + shell config work.

set -e

BLUE='\033[0;34m'
GREEN='\033[0;32m'
NC='\033[0m'

log() { echo -e "${BLUE}🚀 $1${NC}"; }
success() { echo -e "${GREEN}✅ $1${NC}"; }

REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

STATE_DIR="$HOME/.config/mac-config"
NO_GUI_MARKER="$STATE_DIR/no-gui"

for arg in "$@"; do
    case "$arg" in
        --no-gui)
            log "Caching --no-gui preference for this machine..."
            mkdir -p "$STATE_DIR"
            touch "$NO_GUI_MARKER"
            ;;
        --gui)
            log "Clearing --no-gui preference for this machine..."
            rm -f "$NO_GUI_MARKER"
            ;;
        *)
            echo "Unknown argument: $arg (expected --no-gui or --gui)" >&2
            exit 1
            ;;
    esac
done

log "Running sync.sh to install packages and configure the shell..."
"$REPO_DIR/sync.sh"

success "FIRST-TIME SETUP COMPLETE!"
