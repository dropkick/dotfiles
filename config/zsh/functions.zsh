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



# ── clean — Clean up caches and free disk space (cross-platform) ──────
# Runs OS-appropriate cleanup commands for:
#   - System package manager caches (Homebrew / apt)
#   - Global npm cache
#   - Ruby gem cleanup
#   - Old pip cache
#   - Docker (if installed)
#   - Trash / temporary files
#
# Usage: clean
function clean {
  ok "🧹 Let's clean up all the things..."

  # Detect OS
  case "$(uname -s)" in
    Darwin) OS="macos" ;;
    Linux)  OS="linux" ;;
  esac

  if [[ "$OS" == "macos" ]]; then
    # ── macOS cleanup ─────────────────────────────────────────────────
    info "[1/7] 🍺 Cleaning Homebrew cache..."
    command -v brew &>/dev/null && brew cleanup --prune=0 || info "brew not installed, skipping"
    ok "Homebrew cache cleaned"

    info "[2/7] 🗑️  Emptying trash..."
    rm -rf ~/.Trash/* 2>/dev/null
    ok "Trash emptied"

    info "[3/7] 🧽 Cleaning DNS cache..."
    sudo killall -HUP mDNSResponder 2>/dev/null
    ok "DNS cache flushed"

    info "[4/7] 💎 Cleaning Ruby gems..."
    command -v gem &>/dev/null && gem cleanup || info "gem not installed, skipping"
    ok "Ruby gems cleaned"

    info "[5/7] 📦 Cleaning npm cache..."
    command -v npm &>/dev/null && npm cache clean --force || info "npm not installed, skipping"
    ok "npm cache cleaned"

    info "[6/7] 🐍 Cleaning pip cache..."
    command -v pip &>/dev/null && pip cache purge 2>/dev/null || info "pip not installed, skipping"
    ok "pip cache cleaned"

    info "[7/7] 🐳 Cleaning Docker..."
    command -v docker &>/dev/null && docker system prune -f 2>/dev/null || info "docker not installed, skipping"
    ok "Docker pruned"

  elif [[ "$OS" == "linux" ]]; then
    # ── Linux cleanup ─────────────────────────────────────────────────
    info "[1/6] 📦 Cleaning apt cache..."
    command -v apt &>/dev/null && { sudo apt autoremove -y; sudo apt clean; sudo apt autoclean; } || info "apt not available, skipping"
    ok "apt cleaned"

    info "[2/6] 🗑️  Emptying trash..."
    rm -rf ~/.local/share/Trash/* 2>/dev/null
    ok "Trash emptied"

    info "[3/6] 💎 Cleaning Ruby gems..."
    command -v gem &>/dev/null && gem cleanup || info "gem not installed, skipping"
    ok "Ruby gems cleaned"

    info "[4/6] 📦 Cleaning npm cache..."
    command -v npm &>/dev/null && npm cache clean --force || info "npm not installed, skipping"
    ok "npm cache cleaned"

    info "[5/6] 🐍 Cleaning pip cache..."
    command -v pip &>/dev/null && pip cache purge 2>/dev/null || info "pip not installed, skipping"
    ok "pip cache cleaned"

    info "[6/6] 🐳 Cleaning Docker..."
    command -v docker &>/dev/null && docker system prune -f 2>/dev/null || info "docker not installed, skipping"
    ok "Docker pruned"

  else
    info "Unknown OS — skipping cleanup."
  fi

  ok "✨ All cleaned up!"
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

# ── functions — List all defined shell functions ──────────────────────
# Usage: functions          (lists names only)
#        functions <name>   (shows the body of a specific function)
#        functions -v       (shows all function names + bodies)
#
# Mirrors the `aliases` alias that lists alias names.
# Uses zsh's `functions` builtin under the hood (we wrap it to make the
# no-argument case show names only, since the bare builtin dumps bodies).
function functions_list {
  if [[ $# -eq 0 ]]; then
    # No args: print function names only, sorted
    print -l ${(ok)functions} | grep -v '^_' | sort
  elif [[ "$1" == "-v" || "$1" == "--verbose" ]]; then
    # -v: show all function names + bodies
    typeset -f
  else
    # Specific function name(s): show their bodies
    typeset -f "$@"
  fi
}


# ── calc — Quick calculator ──────────────────────────────────────────
function calc() {
  echo "$*" | bc -l
}

# ── cheat — Command cheatsheet via cht.sh ─────────────────────────────
function cheat() {
  curl cht.sh/"$1"
}

# ── ff — Fuzzy find file by name ──────────────────────────────────────
function ff() {
  find . -type f -iname "*$1*"
}

# ── fd — Fuzzy find directory by name ─────────────────────────────────
function fd() {
  find . -type d -iname "*$1*"
}

# ── duf — Disk usage, sorted and formatted ────────────────────────────
function duf() {
  du --max-depth="${1:-0}" -c | sort -r -n | awk \
    '{split("K M G",v); s=1; while($1>1024){$1/=1024; s++} print int($1)v[s]"\t"$2}'
}

# ── gz — Show gzip compression ratio for a file ───────────────────────
function gz() {
  local ORIGSIZE=$(wc -c < "$1")
  local GZIPSIZE=$(gzip -c "$1" | wc -c)
  local RATIO=$(echo "$GZIPSIZE * 100 / $ORIGSIZE" | bc -l)
  local SAVED=$(echo "($ORIGSIZE - $GZIPSIZE) * 100 / $ORIGSIZE" | bc -l)
  printf "orig: %d bytes\ngzip: %d bytes\nsave: %2.0f%% (%2.0f%%)\n" \
    "$ORIGSIZE" "$GZIPSIZE" "$SAVED" "$RATIO"
}

# ── dataurl — Create data URL from a file ─────────────────────────────
function dataurl() {
  local MIMETYPE=$(file --mime-type "$1" | cut -d ' ' -f2)
  if [[ $MIMETYPE == "text/"* ]]; then
    MIMETYPE="${MIMETYPE};charset=utf-8"
  fi
  echo "data:${MIMETYPE};base64,$(openssl base64 -in "$1" | tr -d '\n')"
}

# ── down4me — Check if a site is down for everyone or just you ───────
function down4me() {
  local site="$1"
  # Strip protocol and path
  local clean="${site#http://}"
  clean="${clean#https://}"
  clean="${clean%%/*}"
  local response
  response=$(curl -s --max-time 10 "https://isdownapi.com/api/check?domain=${clean}")
  local result
  result=$(echo "$response" | grep -o '"status":"[^"]*"' | cut -d'"' -f4)
  case "$result" in
    up)   print "✅ It's just you — ${clean} is up." ;;
    down) print "❌ It's not just you — ${clean} appears down." ;;
    *)    print "❓ Couldn't check ${clean} — try https://isdownapi.com/api/check?domain=${clean}" ;;
  esac
}

alias uporno='down4me'

# ── wx — Weather report via wttr.in ──────────────────────────────────
# Usage:
#   wx              → weather for default location (two-line format)
#   wx 97123        → weather for zip code 97123
#   wx "San Diego"  → weather for San Diego
#   wx -1           → one-liner (current conditions only)
#   wx -0           → full 3-day forecast
function wx() {
  local DEFAULT_LOCATION="Portland"
  local location="$DEFAULT_LOCATION"
  local format="-1"

  # Parse args — format flag or location can come in any order
  for arg in "$@"; do
    if [[ "$arg" == "-"[0-9] ]]; then
      format="$arg"
    else
      location="$arg"
    fi
  done

  # Replace spaces with + for the URL
  location="${location// /+}"

  curl -s "wttr.in/${location}${format}" --max-time 5
}

# ── moon — Moon phase via wttr.in ────────────────────────────────────
function moon() {
  curl -s "wttr.in/moon" --max-time 5
}
