#!/usr/bin/env bash
#
# setup-java.sh — interactive Java support setup for the advanced Neovim config.
#
# WHAT IT DOES (in order, asking before any change):
#   1. Checks for a JDK >= 17 (the minimum jdtls needs to run).
#   2. If missing/too old, offers to install one with whatever package manager
#      you have (Homebrew / SDKMAN / apt / dnf / pacman / zypper).
#   3. Installs the jdtls language server via Mason (headless Neovim).
#   4. Verifies the whole chain so the next time you open a .java file it Just Works.
#
# Nothing here edits your Neovim config — java.lua + tools.lua already wire up
# nvim-jdtls. This script only provisions the JDK + server those expect.
#
# Usage:  ./scripts/setup-java.sh        (run from anywhere)

set -euo pipefail

# ── pretty output ───────────────────────────────────────────────────────────
if [[ -t 1 ]]; then
  BOLD=$'\033[1m'; DIM=$'\033[2m'; RED=$'\033[31m'; GRN=$'\033[32m'
  YLW=$'\033[33m'; BLU=$'\033[34m'; RST=$'\033[0m'
else
  BOLD=""; DIM=""; RED=""; GRN=""; YLW=""; BLU=""; RST=""
fi
info()  { printf "%s==>%s %s\n" "$BLU$BOLD" "$RST" "$*"; }
ok()    { printf "%s ✓ %s%s\n" "$GRN" "$*" "$RST"; }
warn()  { printf "%s ! %s%s\n" "$YLW" "$*" "$RST"; }
err()   { printf "%s ✗ %s%s\n" "$RED" "$*" "$RST" >&2; }

# Ask a yes/no question. Default Yes. Returns 0 for yes, 1 for no.
confirm() {
  local prompt="$1" reply
  read -r -p "$(printf '%s%s%s [Y/n] ' "$BOLD" "$prompt" "$RST")" reply || true
  [[ -z "$reply" || "$reply" =~ ^[Yy] ]]
}

# Ask the user to pick one of $@; echoes the chosen value.
choose() {
  local i=1 choice
  for opt in "$@"; do printf "  %s%d%s) %s\n" "$BOLD" "$i" "$RST" "$opt" >&2; i=$((i+1)); done
  while true; do
    read -r -p "$(printf 'Pick [1-%d]: ' "$#")" choice || true
    if [[ "$choice" =~ ^[0-9]+$ ]] && (( choice >= 1 && choice <= $# )); then
      eval "echo \"\${$choice}\""; return 0
    fi
    warn "Enter a number between 1 and $#."
  done
}

REQUIRED_MAJOR=17

# ── 1. detect current JDK ────────────────────────────────────────────────────
# Echoes the major version (e.g. 21) of the active `java`, or nothing.
java_major() {
  command -v java >/dev/null 2>&1 || return 0
  # `java -version` prints to stderr; lines like  openjdk version "21.0.2"
  local v
  v=$(java -version 2>&1 | head -n1 | sed -E 's/.*version "([0-9]+).*/\1/')
  [[ "$v" =~ ^[0-9]+$ ]] && echo "$v"
}

info "Checking for a JDK (need ${REQUIRED_MAJOR}+)…"
CURRENT="$(java_major)"
if [[ -n "$CURRENT" && "$CURRENT" -ge "$REQUIRED_MAJOR" ]]; then
  ok "Found Java $CURRENT ($(command -v java))"
  NEED_JDK=0
elif [[ -n "$CURRENT" ]]; then
  warn "Found Java $CURRENT, but jdtls needs $REQUIRED_MAJOR+."
  NEED_JDK=1
else
  warn "No 'java' on PATH."
  NEED_JDK=1
fi

# ── 2. install a JDK if needed ───────────────────────────────────────────────
install_jdk() {
  local os mgrs=() pick
  os="$(uname -s)"

  command -v brew    >/dev/null 2>&1 && mgrs+=("Homebrew (brew install openjdk@21)")
  command -v sdk     >/dev/null 2>&1 && mgrs+=("SDKMAN (sdk install java)")
  [[ -s "$HOME/.sdkman/bin/sdkman-init.sh" ]] && ! command -v sdk >/dev/null 2>&1 \
                                       && mgrs+=("SDKMAN (sdk install java)")
  command -v apt-get >/dev/null 2>&1 && mgrs+=("apt (sudo apt-get install openjdk-21-jdk)")
  command -v dnf     >/dev/null 2>&1 && mgrs+=("dnf (sudo dnf install java-21-openjdk-devel)")
  command -v pacman  >/dev/null 2>&1 && mgrs+=("pacman (sudo pacman -S jdk-openjdk)")
  command -v zypper  >/dev/null 2>&1 && mgrs+=("zypper (sudo zypper install java-21-openjdk-devel)")

  if (( ${#mgrs[@]} == 0 )); then
    err "No known package manager found."
    if [[ "$os" == "Darwin" ]]; then
      echo "  Install Homebrew (https://brew.sh) then re-run, or grab a JDK from https://adoptium.net"
    else
      echo "  Install one of: apt / dnf / pacman / zypper / SDKMAN, or grab a JDK from https://adoptium.net"
    fi
    return 1
  fi

  echo "Available installers:" >&2
  pick="$(choose "${mgrs[@]}")"
  info "Installing via: $pick"

  case "$pick" in
    Homebrew*)
      brew install openjdk@21
      # Homebrew openjdk is keg-only; symlink so the system + nvim can find it.
      local prefix; prefix="$(brew --prefix)"
      if [[ "$os" == "Darwin" ]]; then
        warn "openjdk@21 is keg-only. To put it on PATH, run:"
        echo "    sudo ln -sfn ${prefix}/opt/openjdk@21/libexec/openjdk.jdk /Library/Java/JavaVirtualMachines/openjdk-21.jdk"
        echo "    echo 'export PATH=\"${prefix}/opt/openjdk@21/bin:\$PATH\"' >> ~/.zshrc"
        if confirm "Run the symlink + PATH steps now?"; then
          sudo ln -sfn "${prefix}/opt/openjdk@21/libexec/openjdk.jdk" /Library/Java/JavaVirtualMachines/openjdk-21.jdk
          echo "export PATH=\"${prefix}/opt/openjdk@21/bin:\$PATH\"" >> ~/.zshrc
          export PATH="${prefix}/opt/openjdk@21/bin:$PATH"
        fi
      fi
      ;;
    SDKMAN*)
      # shellcheck disable=SC1091
      [[ -s "$HOME/.sdkman/bin/sdkman-init.sh" ]] && source "$HOME/.sdkman/bin/sdkman-init.sh"
      sdk install java
      ;;
    apt*)    sudo apt-get update && sudo apt-get install -y openjdk-21-jdk ;;
    dnf*)    sudo dnf install -y java-21-openjdk-devel ;;
    pacman*) sudo pacman -S --noconfirm jdk-openjdk ;;
    zypper*) sudo zypper install -y java-21-openjdk-devel ;;
  esac
}

if (( NEED_JDK )); then
  if confirm "Install a JDK now?"; then
    install_jdk || { err "JDK install did not complete. Fix the above and re-run."; exit 1; }
    # Re-check in this shell.
    CURRENT="$(java_major)"
    if [[ -n "$CURRENT" && "$CURRENT" -ge "$REQUIRED_MAJOR" ]]; then
      ok "Java $CURRENT is now active."
    else
      warn "Installed, but 'java' isn't pointing at $REQUIRED_MAJOR+ in THIS shell."
      warn "Open a new terminal (or source your shell rc) and re-run to finish the jdtls step."
    fi
  else
    warn "Skipping JDK install. jdtls won't start until a JDK $REQUIRED_MAJOR+ is on PATH."
  fi
fi

# ── 3. install the jdtls language server via Mason ───────────────────────────
if ! command -v nvim >/dev/null 2>&1; then
  err "'nvim' not on PATH — install Neovim, then re-run to install jdtls."
  exit 1
fi

JDTLS_DIR="$(nvim --headless -c 'lua io.write(vim.fn.stdpath("data").."/mason/packages/jdtls")' -c 'q' 2>/dev/null || true)"
if [[ -n "$JDTLS_DIR" && -d "$JDTLS_DIR" ]]; then
  ok "jdtls already installed (Mason): $JDTLS_DIR"
else
  if confirm "Install the jdtls server via Mason now?"; then
    info "Running headless Neovim to install jdtls (this can take a minute)…"
    # MasonInstall runs async; the Lua block blocks until the handle reports done.
    nvim --headless -c 'MasonInstall jdtls' \
      -c 'lua local h=require("mason-registry").get_package("jdtls"):get_handle(); if h then while not h:is_closed() do vim.wait(500) end end' \
      -c 'qa' 2>&1 | grep -vi "^$" || true
    if [[ -d "${JDTLS_DIR:-/nonexistent}" ]] || nvim --headless -c 'lua os.exit(vim.fn.isdirectory(vim.fn.stdpath("data").."/mason/packages/jdtls"))' -c 'qa' 2>/dev/null; then
      ok "jdtls installed."
    else
      warn "Could not confirm jdtls. Open Neovim and run :Mason to check, or :MasonInstall jdtls."
    fi
  else
    warn "Skipping. jdtls auto-installs on first launch anyway (tools.lua), so you can just open Neovim."
  fi
fi

# ── 4. summary ───────────────────────────────────────────────────────────────
echo
info "${BOLD}Done.${RST} Next: open any .java file in a project (one with pom.xml,"
echo "    build.gradle, gradlew, mvnw, or .git) and jdtls attaches automatically."
echo "    First attach indexes the project — give it a moment. Then gd / K / gr / <leader>rn work."
echo
printf "%sTroubleshooting:%s\n" "$DIM" "$RST"
echo "    • :LspInfo        — is jdtls attached?"
echo "    • :Mason          — is the jdtls server installed?"
echo "    • java -version   — JDK ${REQUIRED_MAJOR}+ on PATH?"
