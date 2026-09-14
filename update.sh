#!/bin/bash
# Reverse-sync: pull local drift on THIS Mac back into the repo, so every
# other machine picks it up next time it runs sync.sh.
#
# sync.sh goes repo -> machine (install what the repo says you need).
# update.sh goes machine -> repo, for two kinds of drift:
#   1. Brew packages installed by hand (e.g. `brew install --cask x`) that
#      aren't yet declared in Brewfile / Brewfile.gui.
#   2. Neovim config changes made locally (e.g. running :Lazy update, which
#      rewrites lazy-lock.json) that haven't been committed yet.
#
# Only reports "leaf" formulas (brew leaves) — not the library dependencies
# brew pulled in automatically — so the Brewfile stays a curated tool list,
# not a dump of every dependency on the machine.

set -e

BLUE='\033[0;34m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

log() { echo -e "${BLUE}🔍 $1${NC}"; }
success() { echo -e "${GREEN}✅ $1${NC}"; }
warn() { echo -e "${YELLOW}⚠️  $1${NC}"; }

REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
BREWFILE="$REPO_DIR/Brewfile"
BREWFILE_GUI="$REPO_DIR/Brewfile.gui"

declared_formulas() {
    grep -h '^brew "' "$BREWFILE" | sed -E 's/^brew "([^"]+)".*/\1/'
}

declared_casks() {
    grep -h '^cask "' "$BREWFILE" "$BREWFILE_GUI" | sed -E 's/^cask "([^"]+)".*/\1/'
}

diff_new() {
    # $1 = installed list (newline-separated), $2 = declared list
    comm -23 <(echo "$1" | sort -u) <(echo "$2" | sort -u)
}

# Formulas from non-core taps come back from `brew leaves` tap-qualified
# (e.g. "getsentry/xcodebuildmcp/xcodebuildmcp") even when the Brewfile
# declares them by their short name ("xcodebuildmcp"). Compare by basename
# so an already-declared formula isn't reported as new just because of that.
diff_new_formulas() {
    local installed="$1" declared="$2"
    local declared_basenames
    declared_basenames="$(sed -E 's#.*/##' <<< "$declared")"
    while IFS= read -r item; do
        [ -z "$item" ] && continue
        local base="${item##*/}"
        if ! grep -qxF "$base" <<< "$declared_basenames"; then
            echo "$item"
        fi
    done <<< "$installed"
}

check_brew() {
    log "Checking for packages installed here but missing from Brewfile/Brewfile.gui..."

    local new_formulas new_casks
    new_formulas="$(diff_new_formulas "$(brew leaves)" "$(declared_formulas)")"
    new_casks="$(diff_new "$(brew list --cask 2>/dev/null)" "$(declared_casks)")"

    if [ -z "$new_formulas" ] && [ -z "$new_casks" ]; then
        success "Nothing new — Brewfile/Brewfile.gui already cover everything installed here."
        return
    fi

    if [ -n "$new_formulas" ]; then
        warn "Formulas installed here but not in Brewfile:"
        echo "$new_formulas" | sed 's/^/  - /'
    fi
    if [ -n "$new_casks" ]; then
        warn "Casks installed here but not in Brewfile.gui:"
        echo "$new_casks" | sed 's/^/  - /'
    fi

    echo
    read -p "Add these to the repo's Brewfile(s)? [y/N] " -r reply
    if [[ ! "$reply" =~ ^[Yy]$ ]]; then
        log "Not modifying any file. Re-run and answer yes when ready."
        return
    fi

    local stamp
    stamp="$(date +%Y-%m-%d)"

    if [ -n "$new_formulas" ]; then
        {
            echo ""
            echo "# Added by update.sh on $stamp (found installed, not yet declared)"
            while IFS= read -r formula; do
                [ -n "$formula" ] && echo "brew \"$formula\""
            done <<< "$new_formulas"
        } >> "$BREWFILE"
        success "Added $(echo "$new_formulas" | grep -c .) formula(s) to Brewfile."
    fi

    if [ -n "$new_casks" ]; then
        {
            echo ""
            echo "# Added by update.sh on $stamp (found installed, not yet declared)"
            while IFS= read -r cask; do
                [ -n "$cask" ] && echo "cask \"$cask\""
            done <<< "$new_casks"
        } >> "$BREWFILE_GUI"
        success "Added $(echo "$new_casks" | grep -c .) cask(s) to Brewfile.gui."
    fi

    warn "Review with 'git diff Brewfile Brewfile.gui', tidy up the placement/comments, then commit."
}

# --- Neovim config drift (e.g. lazy-lock.json from a local :Lazy update) ---
check_nvim_config() {
    log "Checking for local Neovim config changes not yet committed..."

    local changed
    changed="$(git -C "$REPO_DIR" status --porcelain -- lazy-lock.json init.lua lua/ 2>/dev/null)"

    if [ -z "$changed" ]; then
        success "No local Neovim config drift — lazy-lock.json and lua/ match the repo."
        return
    fi

    warn "Neovim config has local changes not yet committed:"
    echo "$changed" | sed 's/^/  /'

    echo
    read -p "Commit these Neovim config changes now? [y/N] " -r reply
    if [[ ! "$reply" =~ ^[Yy]$ ]]; then
        log "Left uncommitted. Review with 'git -C \"$REPO_DIR\" diff' and commit when ready."
        return
    fi

    git -C "$REPO_DIR" add lazy-lock.json init.lua lua/
    git -C "$REPO_DIR" commit -m "Sync local Neovim plugin/config changes"
    success "Committed Neovim config changes."
}

main() {
    check_brew
    echo
    check_nvim_config
}

main "$@"
