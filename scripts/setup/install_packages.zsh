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

case "$(uname -s)" in
  Darwin)
    # ── macOS: install via Homebrew ─────────────────────────────────
    info "Detected macOS — using Homebrew"
    if ! command -v brew &>/dev/null; then
      info "Homebrew not found. Installing..."
      /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    fi
    brew install zsh zsh-autosuggestions zsh-syntax-highlighting fzf mas
    ok "macOS packages installed"
    ;;

  Linux)
    # ── Linux: detect package manager ───────────────────────────────
    info "Detected Linux"
    if command -v apt &>/dev/null; then
      info "Using apt (Debian/Ubuntu/Mint/DietPi)"
      sudo apt update
      sudo apt install -y zsh zsh-autosuggestions zsh-syntax-highlighting fzf
      ok "apt packages installed"

    elif command -v dnf &>/dev/null; then
      info "Using dnf (Fedora)"
      sudo dnf install -y zsh zsh-autosuggestions zsh-syntax-highlighting fzf
      ok "dnf packages installed"

    elif command -v pacman &>/dev/null; then
      info "Using pacman (Arch)"
      sudo pacman -S --noconfirm zsh zsh-autosuggestions zsh-syntax-highlighting fzf
      ok "pacman packages installed"

    else
      info "⚠️  No supported package manager found."
      info "    Install manually: zsh, zsh-autosuggestions, zsh-syntax-highlighting, fzf"
    fi
    ;;

  *)
    info "⚠️  Unknown OS — skipping package installation."
    ;;
esac

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

# ── Set zsh as default shell ──────────────────────────────────────────
if [ "$SHELL" != "$(which zsh)" ] 2>/dev/null; then
  info "🐚 Setting zsh as default shell..."
  chsh -s "$(which zsh)"
  ok "Default shell set to zsh (takes effect on next login)"
fi

# ── Create platform-specific gitconfig.local symlink ───────────────────
# The main ~/.gitconfig has [include] path = ~/.config/git/gitconfig.local
# We symlink that to the right platform file (both are stowed by Dotbot).
info "🔗 Setting up platform-specific gitconfig.local..."
mkdir -p ~/.config/git
if [ -L ~/.config/git/gitconfig.local ] || [ -f ~/.config/git/gitconfig.local ]; then
  rm -f ~/.config/git/gitconfig.local
fi
case "$(uname -s)" in
  Darwin)
    ln -s ~/.config/git/gitconfig.macos ~/.config/git/gitconfig.local
    ok "gitconfig.local → gitconfig.macos"
    ;;
  Linux)
    ln -s ~/.config/git/gitconfig.linux ~/.config/git/gitconfig.local
    ok "gitconfig.local → gitconfig.linux"
    ;;
esac


# ── Set zsh as default shell if it isn't already ───────────────────────
info "🐚 Checking default shell..."
CURRENT_SHELL=$(getent passwd "$USER" 2>/dev/null | cut -d: -f7 || echo "$SHELL")
ZSH_PATH=$(command -v zsh 2>/dev/null)

if [[ -z "$ZSH_PATH" ]]; then
  info "zsh not found in PATH — skipping default shell check."
elif [[ "$CURRENT_SHELL" == *zsh ]]; then
  ok "zsh is already your default shell."
else
  info "Your default shell is $CURRENT_SHELL — zsh is at $ZSH_PATH"
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
