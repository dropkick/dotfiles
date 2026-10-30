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

# == package installation ==========================================
# Each package is installed individually so that one unavailable name
# can never abort the rest. Failures are collected and reported at the
# end instead of being reported as success.

FAILED_PKGS=""
INSTALLED_PKGS=""

if [ "$(id -u)" -eq 0 ]; then SUDO=""; else SUDO="sudo"; fi
PKG_LOG="${TMPDIR:-/tmp}/dotfiles-pkg.log"
: >"$PKG_LOG"

# pkg_install is defined per package manager inside the case below.
try_pkg() {
  if ! command -v pkg_install >/dev/null 2>&1; then
    info "internal error: pkg_install not defined"
    return 1
  fi
  if pkg_install "$1" >>"$PKG_LOG" 2>&1; then
    INSTALLED_PKGS="$INSTALLED_PKGS $1"
  else
    FAILED_PKGS="$FAILED_PKGS $1"
  fi
}

# Takes separate words, not one quoted string: zsh does not word-split
# quoted parameters, so quoting the list makes it a single argument.

install_list() {
  local p
  for p in "$@"; do try_pkg "$p"; done
}

report_pkgs() {
  if [ -n "$FAILED_PKGS" ]; then
    info "Could not install:$FAILED_PKGS"
    info "Everything else installed fine. Details: $PKG_LOG"
  else
    ok "$1 packages installed"
  fi
}

case "$(uname -s)" in
  Darwin)
    info "Detected macOS - using Homebrew"
    if ! command -v brew >/dev/null 2>&1; then
      info "Homebrew not found. Installing..."
      /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
      for b in /opt/homebrew/bin/brew /usr/local/bin/brew; do
        if [ -x "$b" ]; then eval "$("$b" shellenv)"; break; fi
      done
    fi
    if command -v brew >/dev/null 2>&1; then
      pkg_install() { brew install "$1"; }
      install_list zsh zsh-autosuggestions zsh-syntax-highlighting \
                   fzf mas bat figlet thefuck eza lsd
      report_pkgs "macOS"
    else
      info "Homebrew unavailable - skipping package installation"
    fi
    ;;

  Linux)
    info "Detected Linux"
    if command -v apt-get >/dev/null 2>&1; then
      info "Using apt (Debian/Ubuntu/Mint/DietPi)"
      $SUDO apt-get update -qq || info "apt update reported errors - continuing anyway"
      pkg_install() { $SUDO apt-get install -y "$1"; }
      # eza and figlet last: newest names, most likely to be missing.
      install_list zsh zsh-autosuggestions zsh-syntax-highlighting \
                   fzf lsd bat thefuck figlet eza
      # Debian/Ubuntu ship bat's binary as batcat
      if command -v batcat >/dev/null 2>&1 && ! command -v bat >/dev/null 2>&1; then
        mkdir -p "$HOME/.local/bin"
        ln -sf "$(command -v batcat)" "$HOME/.local/bin/bat"
        info "Linked batcat to ~/.local/bin/bat"
      fi
      report_pkgs "apt"

    elif command -v dnf >/dev/null 2>&1; then
      info "Using dnf (Fedora)"
      pkg_install() { $SUDO dnf install -y "$1"; }
      install_list zsh zsh-autosuggestions zsh-syntax-highlighting \
                   fzf lsd bat figlet thefuck eza
      report_pkgs "dnf"

    elif command -v pacman >/dev/null 2>&1; then
      info "Using pacman (Arch)"
      pkg_install() { $SUDO pacman -S --needed --noconfirm "$1"; }
      install_list zsh zsh-autosuggestions zsh-syntax-highlighting \
                   fzf lsd bat figlet thefuck eza
      report_pkgs "pacman"

    else
      info "No supported package manager found."
      info "Install manually: zsh, zsh-autosuggestions, zsh-syntax-highlighting,"
      info "fzf, lsd (or eza), bat, figlet, thefuck"
    fi
    ;;

  *)
    info "Unknown OS - skipping package installation."
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
ZSH_PATH="$(command -v zsh 2>/dev/null)"

if [ -z "$ZSH_PATH" ]; then
  info "zsh not found in PATH - skipping default shell check."
  ZSH_PATH=""
else
  if [ "$(uname -s)" = "Darwin" ]; then
    # Directory Services is the source of truth; getent does not exist here.
    current_shell="$(dscl . -read "$HOME" UserShell | awk '{print $2}')"
    # chsh validates against /etc/shells; Homebrew zsh is not listed by default.
    if ! grep -qx "$ZSH_PATH" /etc/shells; then
      echo "$ZSH_PATH" | sudo tee -a /etc/shells >/dev/null
      info "Registered $ZSH_PATH in /etc/shells"
    fi
  else
    current_shell="$(getent passwd "$USER" 2>/dev/null | cut -d: -f7)"
    [ -n "$current_shell" ] || current_shell="$SHELL"
  fi

  if [ "$current_shell" = "$ZSH_PATH" ] || [ "$current_shell" = "/bin/zsh" ]; then
    ok "zsh is already your default shell ($current_shell)"
  else
    printf "  Would you like to set zsh as your default shell? [y/N] "
    read -r REPLY < /dev/tty
    if [[ "$REPLY" =~ ^[Yy]$ ]]; then
      if chsh -s "$ZSH_PATH" 2>/dev/null || sudo chsh -s "$ZSH_PATH" "$USER"; then
        # Verify instead of assuming: chsh can exit 0 without changing anything.
        case "$(uname -s)" in
          Darwin) final_shell="$(dscl . -read "$HOME" UserShell | awk '{print $2}')" ;;
          *)      final_shell="$(getent passwd "$USER" 2>/dev/null | cut -d: -f7)" ;;
        esac
        if [ "$final_shell" = "$ZSH_PATH" ]; then
          ok "Default shell set to $ZSH_PATH. Log out and back in."
        else
          info "chsh reported success but shell is still $final_shell"
          info "Run manually:  sudo chsh -s $ZSH_PATH $USER"
        fi
      else
        info "Could not set zsh as default shell automatically."
        info "Run this manually:  sudo chsh -s $ZSH_PATH $USER"
      fi
    else
      info "Skipping. You can set it later with: chsh -s $ZSH_PATH"
    fi
  fi
fi

ok "📦 Package installation complete!"
