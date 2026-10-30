#!/usr/bin/env zsh
# ═══════════════════════════════════════════════════════════════════════
#  install_packages.zsh — OS-aware package installer
#  ─────────────────────────────────────────────────────────────────────
#  Called automatically by Dotbot during `./install`.
#  Detects the OS and installs the zsh + autocomplete plugin packages.
#  Safe to re-run — skips already-installed items.
# ═══════════════════════════════════════════════════════════════════════

# Log helpers (in case functions.zsh hasn't been loaded yet)
info() { echo -e "\033[1m[INFO]\033[0m $1" ; }
ok()   { echo -e "\033[32m[OK]\033[0m $1" ; }

info "📦 Detecting OS and installing packages..."

# ══ package installation ═══════════════════════════════════════════
# Each package is installed individually: one unavailable name must
# never abort the rest. Failures are collected and reported at the end.

FAILED_PKGS=""
INSTALLED_PKGS=""

if [ "$(id -u)" -eq 0 ]; then SUDO=""; else SUDO="sudo"; fi
PKG_LOG="$(mktemp -t dotfiles-pkg.XXXXXX)"

# pkg_install <name>  — defined per package manager 
below
try_pkg() {
  if pkg_install "$1" >>"$PKG_LOG" 2>&1; then
    INSTALLED_PKGS="$INSTALLED_PKGS $1"
  else
    FAILED_PKGS="$FAILED_PKGS $1"
  fi
}

install_list() {
  for p in $1; do try_pkg "$p"; done
}

report_pkgs() {
  if [ -n "$FAILED_PKGS" ]; then
    info "⚠️  Could not install:$FAILED_PKGS"
    info "    Everything else installed fine. Details: $PKG_LOG"
    # info "    Debian 12 (bookworm) has no eza package — see README for the static binary."
  else
    ok "$1 packages installed"
  fi
}

case "$(uname -s)" in
  Darwin)
    # ── macOS: install via Homebrew ─────────────────────────────────
    info "Detected macOS — using Homebrew"
    if ! command -v brew &>/dev/null; then
      info "Homebrew not found. Installing..."
      /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
      # Homebrew isn't on PATH in this shell yet (Apple Silicon and Intel)
      for b in /opt/homebrew/bin/brew /usr/local/bin/brew; do
        if [ -x "$b" ]; then eval "$("$b" shellenv)"; break; fi
      done
    fi
    command -v brew &>/dev/null || { info "⚠️  Homebrew unavailable — skipping packages"; }
    if command -v brew &>/dev/null; then
      pkg_install() { brew install "$1"; }
      install_list "zsh zsh-autosuggestions zsh-syntax-highlighting fzf mas bat figlet thefuck eza lsd"
      report_pkgs "macOS"
    fi
    ;;

  Linux)
    info "Detected Linux"
    if command -v apt-get &>/dev/null; then
      info "Using apt (Debian/Ubuntu/Mint/DietPi)"
      $SUDO apt-get update -qq || info "apt update reported errors — continuing anyway"
      pkg_install() { $SUDO apt-get install -y "$1"; }
      # eza/figlet last: newest additions, most likely to be unavailable
      install_list "zsh zsh-autosuggestions zsh-syntax-highlighting fzf lsd bat thefuck figlet eza"
      # Debian/Ubuntu install bat's binary as `batcat` [fa93e3]
      if command -v batcat &>/dev/null && ! command -v bat &>/dev/null; then
        mkdir -p "$HOME/.local/bin"
        ln -sf "$(command -v batcat)" "$HOME/.local/bin/bat"
        info "Linked batcat → ~/.local/bin/bat"
      fi
      report_pkgs "apt"

    elif command -v dnf &>/dev/null; then
      info "Using dnf (Fedora)"
      pkg_install() { $SUDO dnf install -y "$1"; }
      install_list "zsh zsh-autosuggestions zsh-syntax-highlighting fzf lsd bat figlet thefuck eza"
      report_pkgs "dnf"

    elif command -v pacman &>/dev/null; then
      info "Using pacman (Arch)"
      pkg_install() { $SUDO pacman -S --needed --noconfirm "$1"; }
      install_list "zsh zsh-autosuggestions zsh-syntax-highlighting fzf lsd bat figlet thefuck eza"
      report_pkgs "pacman"

    else
      info "⚠️  No supported package manager found."
      info "    Install manually: zsh, zsh-autosuggestions, zsh-syntax-highlighting,"
      info "    fzf, lsd (or eza), bat, figlet, thefuck"
    fi
    ;;

  *)
    info "⚠️  Unknown OS — skipping package installation."
    ;;
esac

# ── Install cloudflare-speed-cli for speedtest alias ─────────────
info "📦 Installing cloudflare-speed-cli package..."
curl -fsSL https://raw.githubusercontent.com/kavehtehrani/cloudflare-speed-cli/main/install.sh | sh
ok "cloudflare-speed-cli package installed"

# ── Clone zsh-history-substring-search (not in apt repos) ─────────────
info "🔌 Ensuring zsh-history-substring-search is installed..."
mkdir -p ~/.zsh-plugins
if [ ! -d ~/.zsh-plugins/zsh-history-substring-search ]; then
  git clone --depth=1 \
    https://github.com/zsh-users/zsh-history-substring-search \
    ~/.zsh-plugins/zsh-history-substring-search
  ok "zsh-history-substring-search installed"
else
  ok "zsh-history-substring-search already installed"
fi

# ── Port bash history (if bash history exists and zsh doesn't) ────────
if [ -f ~/.bash_history ] && [ ! -f ~/.zsh_history ]; then
  info "📜 Porting bash history to zsh..."
  awk '{ print ": " systime() ":0;" $0 }' ~/.bash_history >> ~/.zsh_history
  ok "bash history ported"
fi


# ── Set zsh as default shell if it isn't already ───────────────────────
info "🐚 Checking default shell..."
CURRENT_SHELL=$(getent passwd "$USER" 2>/dev/null | cut -d: -f7 || echo "$SHELL")
ZSH_PATH=$(command -v zsh 2>/dev/null)

if [[ -z "$ZSH_PATH" ]]; then
  info "zsh not found in PATH — skipping default shell check."
elif [[ "$CURRENT_SHELL" == *zsh ]]; then
  ok "zsh is already your default shell."
else
  printf "  Would you like to set zsh as your default shell? [y/N] "
  read -r REPLY < /dev/tty
  if [[ "$REPLY" =~ ^[Yy]$ ]]; then
    # Try chsh first (works on macOS, some Linux distros)
    if chsh -s "$ZSH_PATH" 2>/dev/null; then
      ok "Default shell set to zsh. Log out and back in for it to take effect."
    else
      # chsh failed (PAM restriction on Debian/Ubuntu) — try sudo
      info "chsh failed (likely PAM restriction). Trying with sudo..."
      if sudo chsh -s "$ZSH_PATH" "$USER" 2>/dev/null; then
        ok "Default shell set to zsh. Log out and back in for it to take effect."
      else
        info "Could not set zsh as default shell automatically."
        info "Run this manually:  sudo chsh -s $ZSH_PATH $USER"
      fi
    fi
  else
    info "Skipping. You can set it later with: chsh -s $ZSH_PATH"
  fi
fi

ok "📦 Package installation complete!"
