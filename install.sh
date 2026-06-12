#!/usr/bin/env bash
#
# install.sh — symlink both Neovim configs into ~/.config so Neovim can find them.
#
# Neovim looks for its config in  ~/.config/$NVIM_APPNAME  (default: "nvim").
# We keep the real files in THIS git repo and just point ~/.config at them with
# symlinks. That way `git pull` here instantly updates your editor everywhere.
#
#   ~/.config/nvim          -> <repo>/nvim           (the NOOBY config, the default)
#   ~/.config/nvim-advanced -> <repo>/nvim-advanced  (the ADVANCED config)
#
# Run it any time — it's idempotent (safe to re-run). Existing *real* directories
# are backed up to "<dir>.backup.<timestamp>" before we replace them; existing
# symlinks are simply refreshed.

set -euo pipefail

# Absolute path to the directory this script lives in (= the repo root).
REPO="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CONFIG_HOME="${XDG_CONFIG_HOME:-$HOME/.config}"

link() {
  local src="$1" dest="$2"

  if [ ! -d "$src" ]; then
    echo "  skip: $src does not exist yet"
    return
  fi

  mkdir -p "$CONFIG_HOME"

  # If something real (not a symlink) is already there, back it up first.
  if [ -e "$dest" ] && [ ! -L "$dest" ]; then
    local backup="${dest}.backup.$(date +%Y%m%d%H%M%S)"
    echo "  backup: $dest -> $backup"
    mv "$dest" "$backup"
  fi

  # -s symlink, -f force overwrite, -n don't follow an existing symlinked dir.
  ln -sfn "$src" "$dest"
  echo "  linked: $dest -> $src"
}

echo "Installing Neovim configs from: $REPO"
link "$REPO/nvim"          "$CONFIG_HOME/nvim"
link "$REPO/nvim-advanced" "$CONFIG_HOME/nvim-advanced"

cat <<'EOF'

Done.

  nvim                              -> nooby config
  NVIM_APPNAME=nvim-advanced nvim   -> advanced config

Optional: add a shortcut for the advanced config to your shell rc
(~/.zshrc or ~/.bashrc):

  alias nva='NVIM_APPNAME=nvim-advanced nvim'

First launch will auto-install plugins. Then run :checkhealth inside Neovim.
EOF
