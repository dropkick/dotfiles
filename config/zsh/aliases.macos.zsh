# ═══════════════════════════════════════════════════════════════════════
#  aliases.macos.zsh — macOS-specific aliases
#  ─────────────────────────────────────────────────────────────────────
#  Only loaded when OS is detected as macOS (Darwin).
#  Trimmed from the original .dot/config/zsh/alias.macos.zsh to keep
#  only the practical ones. Add back anything you miss.
# ═══════════════════════════════════════════════════════════════════════


# ── Clipboard ─────────────────────────────────────────────────────────
alias cpwd="pwd|tr -d '\n'|pbcopy"      # Copy current path to clipboard


# ── Browsers ──────────────────────────────────────────────────────────
alias chrome="open -a 'Google Chrome'"
alias firefox="open -a Firefox"
alias safari="open -a Safari"


# ── System ────────────────────────────────────────────────────────────
alias flushdns='sudo killall -HUP mDNSResponder'  # Flush DNS cache
alias afk="open /System/Library/CoreServices/ScreenSaverEngine.app"  # Screensaver
alias zzz="pmset sleepnow"              # Sleep immediately
alias ejector="osascript -e 'tell application \"Finder\" to eject (every disk whose ejectable is true)'"


# ── Finder ────────────────────────────────────────────────────────────
alias killfinder="killall Finder"
alias killdock="killall Dock"
alias killos="killfinder && killdock"
alias emptytrash="sudo rm -rfv /Volumes/*/.Trashes; sudo rm -rfv ~/.Trash; sudo rm -rfv /private/var/log/asl/*.asl"

# ── File cleanup ──────────────────────────────────────────────────────
# Exclude macOS metadata files when creating ZIP archives
alias zip="zip -x *.DS_Store -x *__MACOSX* -x *.AppleDouble*"

# Recursively remove .DS_Store files in current directory
alias cleanupds="find . -type f -name '*.DS_Store' -ls -delete"

# ── Quick Look (preview files from CLI) ───────────────────────────────
alias ql="qlmanage -p &>/dev/null"

# ── System info ───────────────────────────────────────────────────────
alias displays="system_profiler SPDisplaysDataType"
alias cpu="sysctl -n machdep.cpu.brand_string"

# ── Network ───────────────────────────────────────────────────────────
alias localip="ipconfig getifaddr en0"  # Get local IP on primary interface
alias localips="ifconfig | grep -Eo 'inet (addr:)?([0-9]*\.){3}[0-9]*' | grep -Eo '([0-9]*\.){3}[0-9]*' | grep -v '127.0.0.1'"


# ── iOS Simulator ─────────────────────────────────────────────────────
alias ios="open /Applications/Xcode.app/Contents/Developer/Applications/iOS\ Simulator.app"

# ── Audio ────────────────────────────────────────────────────────────
alias stfu="osascript -e 'set volume output muted true'"
alias pumpitup="osascript -e 'set volume 7'"

alias cal="command cal"