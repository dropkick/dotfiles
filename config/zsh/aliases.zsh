# ═══════════════════════════════════════════════════════════════════════
#  aliases.zsh — Shared aliases (all operating systems)
#  ─────────────────────────────────────────────────────────────────────
#  These aliases work on both Linux and macOS.
#  OS-specific aliases live in aliases.linux.zsh / aliases.macos.zsh.
# ═══════════════════════════════════════════════════════════════════════


# ── Shortcuts ─────────────────────────────────────────────────────────
alias reload="source ~/.zshrc"          # Reload zsh config without restarting
alias _="sudo"                          # Quick sudo: _ apt update
alias g="git"                           # Git shorthand
alias gall="git add ."                  # Stage all changes
alias rr="rm -rf"                       # Force-remove recursively

# Git log: colorized, graph, short date, truncated author
#   %Cred%h              — short hash in red
#   %Cgreen %cd          — commit date in green
#   %Cblue%<(14,trunc)%an — author name in blue, truncated to 14 chars
#   %Creset %s           — commit message
#   %Cred %d             — branch/tag refs in red
alias glog="git log --pretty=format:'%Cred%h %Cgreen %cd %Cblue%<(14,trunc)%an %Creset %s %Cred %d %Creset' --graph --date=short -20"

# Pretty git log: one-line, all branches, graph + file stats
alias gitpretty="git log --oneline --decorate --all --graph --stat"

# Git log with file change stats
alias gstat="git log --stat"


# ── Default options for commands ──────────────────────────────────────
alias rsync="rsync -vh"                 # Verbose + human-readable sizes
alias psgrep="psgrep -i"               # Case-insensitive process search


# ── Introspection ─────────────────────────────────────────────────────
alias aliases="alias | sed 's/=.*//'"   # List all alias names (no values)
alias paths='echo -e ${PATH//:/\\n}'    # Print PATH entries, one per line


# ── Directory listing ─────────────────────────────────────────────────
# Colorized ls variants for different use cases:
#   l   — long list, all files, human-readable sizes
#   ll  — long list, all files
#   lt  — long list sorted by modification time (newest at bottom)
#   ld  — long list of directories only
#   lls — long list with file type indicators (*, /, @, etc.)
alias l="ls -lahA --color"
alias ll="ls -lA --color"
alias lt="ls -lhAtr --color"
alias ld="ls -ld --color */"
alias lls="ls -laF --color"
alias ls="ls --color"


# ── Directory navigation ──────────────────────────────────────────────
alias ..="cd .."                        # Up one directory
alias ...="cd ../.."                    # Up two directories
alias ....="cd ../../.."               # Up three directories
alias -- -="cd -"                       # Toggle to previous directory
alias cd.='cd $(readlink -f .)'         # cd to real path (resolve symlinks)


# ── tree (directory tree viewer) ──────────────────────────────────────
alias tree="tree -A"                    # ANSI color
alias treed="tree -d"                   # Directories only
alias tree1="tree -d -L 1"              # Depth 1
alias tree2="tree -d -L 2"              # Depth 2


# ── npm (Node.js package manager) ─────────────────────────────────────
alias ni="npm install"
alias nu="npm uninstall"
alias nup="npm update"
alias nri="rm -r node_modules && npm install"   # Fresh reinstall
alias ncd="npm-check -su"                        # Interactive npm-check


# ── Miscellaneous ─────────────────────────────────────────────────────
alias hosts="sudo $EDITOR /etc/hosts"   # Edit hosts file
alias quit="exit"
alias week="date +%V"                   # Current ISO week number
alias grip="grip -b"                    # GitHub Markdown preview in browser
alias cal="ncal -M -b"                  # Calendar, Monday-first

# Network speed test (downloads a test file and discards it)
alias speedtest="wget -O /dev/null http://speedtest.wdc01.softsoftlayer.com/downloads/test10.zip"

# Track what I've done today
alias did="nano -S ~/did.txt"
