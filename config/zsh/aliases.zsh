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
alias functions="functions_list"          # List all function names (or pass a name to see its body)
alias paths='echo -e ${PATH//:/\\n}'    # Print PATH entries, one per line


# ── Directory listing ─────────────────────────────────────────────────
# Colorized ls variants for different use cases:
#   l   — long list, all files, human-readable sizes
#   ll  — long list, all files
#   lt  — long list sorted by modification time (newest at bottom)
#   ld  — long list of directories only
#   lls — long list with file type indicators (*, /, @, etc.)
# alias l="ls -lahA --color"
# alias ll="ls -lA --color"
# alias lt="ls -lhAtr --color"
# alias ld="ls -ld --color */"
# alias lls="ls -laF --color"
# alias ls="ls --color"

# ── Modern ls replacements ───────────────────────────────────────────
# eza (exa fork): colorful, git-aware file listing
# lsd: ls with Nerd Font icons

# ── listing tools ──────────────────────────────────────────────────
# lls = long, all, classify. Defined in every branch so it exists
# even where eza can't be installed (e.g. Debian 12 bookworm).
# eza aliases — main listing tool (colors + git status built in)
if command -v eza &>/dev/null; then
  alias lls='eza -lAhF --git'
  alias ll='eza -lh --git'
  alias la='eza -lAh --git'
  alias l='eza -lAh --git'
  alias lt='eza -lAhF --tree --git'
  alias lr='eza -lAhF --git --reverse'
# lsd: ls with Nerd Font icons
elif command -v lsd &>/dev/null; then
  alias ls='lsd'
  alias lls='lsd -lAF'
  alias ll='lsd -lh'
  alias la='lsd -lAh'
  alias l='lsd -lAh'
  alias lt='lsd --tree --depth 2'
  alias lr='lsd -lAhF -r'
# plain-ls fallbacks
else
  alias ls='ls --color=auto'
  alias lls='ls -lAF --color=auto'
  alias ll='ls -lh --color=auto'
  alias la='ls -lAh --color=auto'
  alias l='ls -lAh --color=auto'
fi



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

# ── man → batman (syntax-highlighted man pages via bat-extras) ──────
if command -v batman &>/dev/null; then
  alias man='batman'                    # Use batman if installed, else regular man
fi

# Network speed test (downloads a test file and discards it)
# alias speedtest="wget -O /dev/null http://speedtest.wdc01.softsoftlayer.com/downloads/test10.zip"
alias speedtest='cloudflare-speed-cli --text'


alias ip="dig +short myip.opendns.com @resolver1.opendns.com"
alias localips="ifconfig | grep -Eo 'inet (addr:)?([0-9]+.){3}[0-9]+' | grep -v '127.0.0.1'"

# Track what I've done today
alias did="nano -S ~/did.txt"

# Update the wisdom quotes repo (github.com/dropkick/wisdom)
alias wisdom-update="git -C ~/.config/quotes pull --ff-only"
alias quotes-update="wisdom-update"

