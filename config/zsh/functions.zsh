# ═══════════════════════════════════════════════════════════════════════
#  functions.zsh — Shared shell functions
#  ─────────────────────────────────────────────────────────────────────
#  Functions are more powerful than aliases: they can take arguments,
#  use variables, and contain logic. Add new functions here.
# ═══════════════════════════════════════════════════════════════════════


# ── Logging helpers (used by the `updates` function) ──────────────────
info() { echo -e "\033[1m[INFO]\033[0m $1" ; }
ok()   { echo -e "\033[32m[OK]\033[0m $1" ; }


# ── updates — Update all the things (cross-platform) ──────────────────
# Runs OS-appropriate update commands for:
#   - System software (macOS softwareupdate / Linux apt)
#   - Package manager (Homebrew / apt)
#   - Mac App Store apps (mas — macOS only)
#   - Global npm packages
#   - Ruby gems (if ruby/gem are installed)
#
# Usage: updates
function updates {
  ok "🚦 Let's update all the things..."

  # Detect OS
  case "$(uname -s)" in
    Darwin) OS="macos" ;;
    Linux)  OS="linux" ;;
  esac

  if [[ "$OS" == "macos" ]]; then
    # ── macOS updates ─────────────────────────────────────────────────
    info "[1/6] 🍎 Starting macOS software update..."
    sudo softwareupdate -i -a
    ok "macOS softwareupdate complete"

    info "[2/6] 🍺 Starting Homebrew update..."
    brew update
    ok "🍺 Homebrew update complete"

    info "[3/6] 🍺 Starting Homebrew upgrade..."
    brew upgrade
    ok "🍺 Homebrew upgrade complete"

    info "[4/6] 🛍️ Starting Mac App Store updates (mas)..."
    command -v mas &>/dev/null && mas upgrade || info "mas not installed, skipping"
    ok "Mac App Store updates complete"

    info "[5/6] 📦 Starting global npm update..."
    command -v npm &>/dev/null && npm update -g || info "npm not installed, skipping"
    ok "npm global packages updated"

    info "[6/6] 💎 Starting Ruby gem updates..."
    command -v gem &>/dev/null && { gem update --system; gem update; } || info "gem not installed, skipping"
    ok "Ruby gems updated"

  elif [[ "$OS" == "linux" ]]; then
    # ── Linux updates ─────────────────────────────────────────────────
    info "[1/4] 📦 Starting apt update..."
    sudo apt update
    ok "apt update complete"

    info "[2/4] 📦 Starting apt upgrade..."
    sudo apt upgrade -y
    ok "apt upgrade complete"

    info "[3/4] 📦 Starting global npm update..."
    command -v npm &>/dev/null && npm update -g || info "npm not installed, skipping"
    ok "npm global packages updated"

    info "[4/4] 💎 Starting Ruby gem updates..."
    command -v gem &>/dev/null && { gem update --system; gem update; } || info "gem not installed, skipping"
    ok "Ruby gems updated"

  else
    info "Unknown OS — skipping system updates."
  fi

  ok "💥 All the things have been updated!"
}


# ── mkcd — Create a directory and cd into it in one command ───────────
# Usage: mkcd my/new/project
function mkcd {
  mkdir -p "$@" && cd "$_"
}


# ── extract — Extract any archive by extension ────────────────────────
# Usage: extract archive.tar.gz
# Automatically picks the right tool based on file extension.
function extract {
  if [ -z "$1" ]; then
    echo "Usage: extract <archive>"
    return 1
  fi
  if [ -f "$1" ]; then
    case "$1" in
      *.tar.bz2|*.tbz2) tar xvjf "$1" ;;
      *.tar.gz|*.tgz)   tar xvzf "$1" ;;
      *.tar.xz)         tar xvJf "$1" ;;
      *.tar)            tar xvf  "$1" ;;
      *.bz2)            bunzip2  "$1" ;;
      *.gz)             gunzip   "$1" ;;
      *.rar)            unrar x  "$1" ;;
      *.zip)            unzip    "$1" ;;
      *.Z)              uncompress "$1" ;;
      *.7z)             7z x     "$1" ;;
      *) echo "extract: don't know how to extract '$1'..." ;;
    esac
  else
    echo "extract: '$1' is not a valid file"
  fi
}


# ── proj — Quick jump to a project directory ──────────────────────────
# Usage: proj myproject
# Looks in ~/projects/ first, then ~/repos/
function proj {
  if [ -d "$HOME/projects/$1" ]; then
    cd "$HOME/projects/$1"
  elif [ -d "$HOME/repos/$1" ]; then
    cd "$HOME/repos/$1"
  else
    echo "proj: no directory found for '$1' (checked ~/projects/ and ~/repos/)"
  fi
}


# ── Clipboard functions ───────────────────────────────────────────────
# copydir:  copies current directory path to clipboard
# copyfile: copies file contents to clipboard
# Uses pbcopy on macOS, xclip on Linux.
function copydir {
  emulate -L zsh
  print -n $PWD | pbcopy 2>/dev/null || print -n $PWD | xclip -selection clipboard 2>/dev/null
}

function copyfile {
  emulate -L zsh
  cat "$1" | pbcopy 2>/dev/null || cat "$1" | xclip -selection clipboard 2>/dev/null
}


# ── Network functions ─────────────────────────────────────────────────

# Get IP address from a hostname
hostname2ip() {
  ping -c 1 "$1" | egrep -m1 -o '[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}'
}

# Find the real URL behind a shortened URL
unshorten() {
  curl -sIL "$1" | sed -n 's/Location: *//p'
}
