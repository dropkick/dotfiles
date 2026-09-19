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
# update-piholes — Update OS + Pi-hole on all fleet hosts
#
# Runs on each Pi-hole host in sequence (cleo, brio, aldo), in this order:
#   1. dietpi-update (unattended) — DietPi OS updates
#   2. apt update + full-upgrade — Debian packages (incl. sqlite3)
#   3. pihole -up -y — Pi-hole core/web/FTL
#
# Semi-verbose: one line per step per host, then a summary.
# Requires: passwordless root SSH to each host (same as flushdns-piholes).
#
# Usage: update-piholes [-p] [-q]
#   -p  Pi-hole only (skip dietpi-update and apt)
#   -q  quiet — only show failures and the summary

function update-piholes() {
    emulate -L zsh
    local host step rc skip_os=0 quiet=0
    local -a hosts=(cleo brio aldo)
    local total=${#hosts[@]} ok=0 fail=0 upToDate=0
    local start=$SECONDS

    while getopts ':pq' opt; do
        case $opt in
            p) skip_os=1 ;;
            q) quiet=1 ;;
            *) printf 'Usage: update-piholes [-p] [-q]\n'; return 1 ;;
        esac
    done
    shift $(( OPTIND - 1 ))

    # Colors (disabled if not a TTY)
    if [[ -t 1 ]]; then
        local c_ok=$'\e[32m' c_bad=$'\e[31m' c_dim=$'\e[2m' c_off=$'\e[0m'
    else
        local c_ok='' c_bad='' c_dim='' c_off=''
    fi

    v() { (( quiet )) || printf '%s\n' "$*"; }

    for host in "${hosts[@]}"; do
        local fqdn="${host}.dropkick.design"
        printf '%s%s%s\n' "$c_dim" "── $fqdn ────────────────────────" "$c_off"
        local host_failed=0

        # 1. DietPi update (unattended; -1 skips the interactive prompt)
        if (( ! skip_os )); then
            step='dietpi-update'
            v "  $step ... "
            if ssh "root@$fqdn" 'dietpi-update -1' >/dev/null 2>&1; then
                v "  ${c_ok}✓${c_off} $step"
            else
                # dietpi-update exits non-zero when nothing to do — check
                if ssh "root@$fqdn" 'dietpi-update -1 2>&1' | grep -qi 'up to date'; then
                    v "  ${c_ok}✓${c_off} $step (up to date)"
                else
                    printf '  %s✗ FAILED %s%s\n' "$c_bad" "$step" "$c_off"
                    (( host_failed++ ))
                fi
            fi

            # 2. apt packages
            step='apt full-upgrade'
            v "  $step ... "
            if ssh "root@$fqdn" \
                'export DEBIAN_FRONTEND=noninteractive; apt-get update -qq && \
                 apt-get full-upgrade -y -qq && \
                 apt-get autoremove -y -qq' >/dev/null 2>&1; then
                v "  ${c_ok}✓${c_off} $step"
            else
                printf '  %s✗ FAILED %s%s\n' "$c_bad" "$step" "$c_off"
                (( host_failed++ ))
            fi
        fi

        # 3. Pi-hole core/web/FTL
        step='pihole -up'
        v "  $step ... "
        if ssh "root@$fqdn" 'pihole -up -y' >/dev/null 2>&1; then
            v "  ${c_ok}✓${c_off} $step"
        else
            printf '  %s✗ FAILED %s%s (run manually to see why)\n' "$c_bad" "$step" "$c_off"
            (( host_failed++ ))
        fi

        if (( host_failed )); then
            (( fail++ ))
        else
            (( ok++ ))
        fi
    done

    # Summary
    if (( fail == 0 )); then
        printf '%sAll %d hosts updated%s in %ds%s\n' \
            "$c_ok" "$ok" "$c_off" "$c_dim" "$(( SECONDS - start ))"
    else
        printf '%s%d/%d hosts updated, %d FAILED%s in %ds\n' \
            "$c_ok" "$ok" "$(( ok + fail ))" "$c_bad" "$fail" "$c_off" "$(( SECONDS - start ))"
    fi

    # Reminder: the fleet has no sync — all three must stay in lockstep
    (( fail == 0 )) && v "${c_dim}(fleet parity: no-sync policy — all three updated together ✓)${c_off}"

    return $(( fail > 0 ))
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
#   wx              → narrow one-liner for default location (Portland)
#   wx 97123        → narrow one-liner for zip 97123
#   wx "San Diego"  → narrow one-liner for San Diego
#   wx -1           → one-liner (current conditions)
#   wx -2           → two-line format
#   wx -0           → full 3-day forecast
function wx() {
  local DEFAULT_LOCATION="Portland"
  local location="$DEFAULT_LOCATION"
  local fmt="format=4"

  # Parse args — format flag or location can come in any order
  for arg in "$@"; do
    if [[ "$arg" == "-"[0-9] ]]; then
      local num="${arg#-}"
      # 0, 1, 2 use short syntax (?0, ?1, ?2)
      # 3+ use format=N syntax
      if [[ "$num" -le 2 ]]; then
        fmt="$num"
      else
        fmt="format=$num"
      fi
    else
      location="$arg"
    fi
  done

  # Replace spaces with + for the URL
  location="${location// /+}"

  # --globoff prevents curl from interpreting ? as glob
  curl -sg --max-time 5 "wttr.in/${location}?${fmt}"
}

# ── moon — Moon phase via wttr.in (ASCII art + phase name) ───────────
function moon() {
  local phase
  phase=$(curl -sg --max-time 5 "wttr.in?format=j1" | grep -m1 'moon_phase' | sed 's/.*: *"//;s/".*//')
  if [[ -n "$phase" ]]; then
    print "\033[1;33m🌙 Phase: ${phase}\033[0m\n"
  fi
  curl -sg --max-time 5 "wttr.in/moon"
}

# ═══════════════════════════════════════════════════════════════════════
#
# flushdns-piholes — Flush local DNS cache + all Pi-hole hosts' DNS caches
#
# Clears the local systemd-resolved cache, then restarts the DNS resolver
# (with cache flush) on each Pi-hole host in sequence: cleo, brio, aldo.
#
# Usage: flushdns-piholes [domain]
#        Optional domain is resolved afterwards to verify the result.
#
# ─────────────────────────────────────────────────────────────────────

function flushdns-piholes() {
    local host target result rc
    local -a hosts=(cleo brio aldo)
    local total=${#hosts[@]}
    local ok=0 fail=0
    local start=$SECONDS

    # Colors (disabled if not a TTY)
    if [[ -t 1 ]]; then
        local c_ok=$'\e[32m' c_bad=$'\e[31m' c_off=$'\e[0m'
    else
        local c_ok='' c_bad='' c_off=''
    fi

    # Local cache first — client-side staleness
    printf 'Local resolver (systemd-resolved)... '
    if sudo resolvectl flush-caches >/dev/null 2>&1; then
        printf '%s✓%s\n' "$c_ok" "$c_off"
    else
        printf '%s✗ FAILED%s\n' "$c_bad" "$c_off"
        (( fail++ ))
    fi

    # Then each Pi-hole — network-side staleness
    for host in "${hosts[@]}"; do
        printf '%s... ' "${host}.dropkick.design"
        if ssh "root@${host}.dropkick.design" "pihole restartdns --flush-caches" >/dev/null 2>&1; then
            printf '%s✓%s\n' "$c_ok" "$c_off"
            (( ok++ ))
        else
            printf '%s✗ FAILED%s (host down or SSH error)\n' "$c_bad" "$c_off"
            (( fail++ ))
        fi
    done

    # Summary
    if (( fail == 0 )); then
        printf '%sAll %d hosts flushed%s in %ds\n' "$c_ok" "$ok" "$c_off" "$(( SECONDS - start ))"
    else
        printf '%s%d/%d flushed, %d FAILED%s in %ds\n' \
            "$c_ok" "$ok" "$(( ok + fail ))" "$c_bad" "$fail" "$c_off" "$(( SECONDS - start ))"
    fi

    # Optional verification
    target="${1:-}"
    if [[ -n "$target" ]]; then
        result=$(dig +short "$target" | head -1)
        if [[ -n "$result" ]]; then
            printf '%s→ %s resolves to %s\n' "$c_ok" "$target" "$result"
        else
            printf '%s→ %s did NOT resolve — check pfSense Unbound override%s\n' "$c_bad" "$target" "$c_off"
        fi
    fi
}


# update-piholes — Update OS + Pi-hole on all fleet hosts
#
# Runs on each Pi-hole host in sequence (cleo, brio, aldo), in this order:
#   1. dietpi-update (unattended) — DietPi OS + APT upgrades (DietPi
#      applies apt upgrades itself; a separate apt step is redundant)
#   2. pihole -up -y — Pi-hole core/web/FTL
#   3. reboot check — flags (or with -r, performs) sequential reboots
#
# Requires: passwordless root SSH to each host (same as flushdns-piholes).
#
# Usage: update-piholes [-p] [-q] [-r]
#   -p  Pi-hole only (skip dietpi-update)
#   -q  quiet — only show failures and the summary
#   -r  reboot hosts that need it (sequentially, waits for each)

function update-piholes() {
    emulate -L zsh
    local host step fqdn rc skip_os=0 quiet=0 reboot=0
    local -a hosts=(cleo brio aldo)
    local total=${#hosts[@]} h_ok=0 h_fail=0 rebooted=0
    local start=$SECONDS

    while getopts ':pqr' opt; do
        case $opt in
            p) skip_os=1 ;;
            q) quiet=1 ;;
            r) reboot=1 ;;
            *) printf 'Usage: update-piholes [-p] [-q] [-r]\n'; return 1 ;;
        esac
    done
    shift $(( OPTIND - 1 ))

    # Colors (disabled if not a TTY)
    if [[ -t 1 ]]; then
        local c_ok=$'\e[32m' c_bad=$'\e[31m' c_dim=$'\e[2m' c_off=$'\e[0m'
    else
        local c_ok='' c_bad='' c_dim='' c_off=''
    fi

    v()  { (( quiet )) || info "$*"; }
    vok(){ (( quiet )) || ok   "$*"; }
    fail(){ printf '%s[FAIL]%s %s\n' "$c_bad" "$c_off" "$*"; }

    (( skip_os )) && v "Pi-hole only (skip dietpi-update)"
    (( reboot ))  && v "Reboot mode: hosts needing it will reboot sequentially (safe: DHCP hands out all three DNS IPs)"
    ok "🚦 Let's update the Pi-hole fleet…"

    for host in "${hosts[@]}"; do
        fqdn="${host}.dropkick.design"
        local host_failed=0 steps=2
        (( skip_os )) && steps=1

        info "── $fqdn ──────────────────────"
        (( quiet )) || info "Connecting to $fqdn…"
        if ! ssh -o ConnectTimeout=10 -o BatchMode=yes "root@$fqdn" 'hostname' >/dev/null 2>&1; then
            fail "$fqdn unreachable (host down or SSH error) — skipping"
            (( h_fail++ ))
            continue
        fi
        vok "$fqdn connected"

        if (( ! skip_os )); then
            # 1. DietPi update (unattended; bare "1" = check + apply
            #    noninteractively; full path — not in PATH over non-login
            #    ssh; includes apt upgrades; exit 0 when already up to
            #    date). Full output passthrough — failure reasons show
            #    inline instead of being swallowed.
            info "[1/$steps] 🥗 Starting DietPi update…"
            if ssh "root@$fqdn" '/boot/dietpi/dietpi-update 1'; then
                ok "DietPi update complete (OS + APT)"
            else
                fail "DietPi update failed on $fqdn (see output above)"
                (( host_failed++ ))
            fi
        fi

        # 2. Pi-hole core/web/FTL
        local n=1; (( skip_os )) || n=2
        info "[$n/$steps] 🕳️ Starting Pi-hole update (core/web/FTL)…"
        if ssh "root@$fqdn" 'pihole -up -y' >/dev/null 2>&1; then
            ok "Pi-hole update complete"
        else
            fail "pihole -up failed on $fqdn (run manually to see why)"
            (( host_failed++ ))
        fi

        # 3. Reboot check (DietPi/Debian touch this file when needed)
        if ssh "root@$fqdn" '[ -f /var/run/reboot-required ]'; then
            if (( reboot )); then
                info "⚠ reboot required — rebooting $fqdn (sequential, fleet redundancy covers it)…"
                ssh "root@$fqdn" 'reboot' >/dev/null 2>&1
                local i=0
                info "Waiting for $fqdn to come back…"
                until ssh -o ConnectTimeout=5 -o BatchMode=yes "root@$fqdn" \
                        'pihole status web' >/dev/null 2>&1; do
                    (( i++ ))
                    if (( i > 45 )); then
                        fail "$fqdn did not come back after ~90s — CHECK IT"
                        (( host_failed++ ))
                        break
                    fi
                    sleep 2
                done
                (( i <= 45 )) && ok "$fqdn back up (rebooted, DNS answering)"
                (( rebooted++ ))
            else
                printf '%s[REBOOT]%s %s needs a reboot — rerun with -r to reboot now%s\n' \
                    "$c_bad" "$c_off" "$fqdn" "$c_dim"
            fi
        else
            vok "no reboot required"
        fi

        if (( host_failed )); then
            fail "── $fqdn: $host_failed step(s) FAILED ──"
            (( h_fail++ ))
        else
            vok "── $fqdn: all steps complete ──"
            (( h_ok++ ))
        fi
    done

    # Summary
    if (( h_fail == 0 )); then
        ok "💥 All $h_ok hosts updated${rebooted:+ (+$rebooted rebooted)} in $(( SECONDS - start ))s"
        v "Fleet parity: no-sync policy — all three updated together ✓"
    else
        printf '%s[FAIL]%s %d/%d hosts updated, %d FAILED in %ds\n' \
            "$c_bad" "$c_off" "$h_ok" "$(( h_ok + h_fail ))" "$h_fail" "$(( SECONDS - start ))"
    fi

    return $(( h_fail > 0 ))
}
