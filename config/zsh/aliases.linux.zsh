# ═══════════════════════════════════════════════════════════════════════
#  aliases.linux.zsh — Linux-specific aliases
#  ─────────────────────────────────────────────────────────────────────
#  Only loaded when OS is detected as Linux.
#  Put aliases here that use Linux-specific commands or paths.
# ═══════════════════════════════════════════════════════════════════════


# ── Network ───────────────────────────────────────────────────────────
# Get public IP address via DNS lookup
alias ip="dig +short myip.opendns.com @resolver1.opendns.com"

# List local (non-loopback) IP addresses using the `ip` command
# (macOS uses ifconfig — see aliases.macos.zsh for that version)
alias localips="ip -br addr | grep -v 'lo'"


# ── Package management (Debian/Ubuntu/Mint/DietPi) ────────────────────
# Shortcuts for common apt operations
alias apti="sudo apt install"           # Install a package
alias apts="apt search"                 # Search for a package
alias aptu="sudo apt update && sudo apt upgrade"  # Update + upgrade all
alias aptsh="apt show"                  # Show package details
alias aptl="apt list --installed"       # List installed packages
alias cal="ncal -M -b"