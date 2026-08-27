# ═══════════════════════════════════════════════════════════════════════
#  options.zsh — Zsh history settings and shell options
#  ─────────────────────────────────────────────────────────────────────
#  Sourced by ~/.zshrc. Controls history behavior and shell features.
# ═══════════════════════════════════════════════════════════════════════

# ── History ───────────────────────────────────────────────────────────
# Where to save history and how much to keep.
# 50,000 entries is a big jump from bash's default 1,000 — this gives
# the autosuggestions plugin plenty to draw from.
HISTFILE=~/.zsh_history
HISTSIZE=50000
SAVEHIST=50000

# ── History options ───────────────────────────────────────────────────
setopt SHARE_HISTORY          # Share history between open terminals
setopt APPEND_HISTORY         # Don't overwrite; append to history file
setopt INC_APPEND_HISTORY     # Write to history file immediately (not on exit)
setopt HIST_IGNORE_DUPS       # Don't save consecutive duplicates
setopt HIST_IGNORE_SPACE      # Don't save commands starting with a space
setopt HIST_REDUCE_BLANKS     # Trim extra whitespace from history entries

# ── General shell options ─────────────────────────────────────────────
setopt INTERACTIVE_COMMENTS   # Allow # comments in interactive shell
setopt AUTO_CD                # Type a dir name to cd into it (no `cd` needed)
setopt EXTENDED_GLOB          # Powerful glob patterns: ^(pattern), *~pattern
setopt NO_BEEP                # Don't beep on errors (annoying)
