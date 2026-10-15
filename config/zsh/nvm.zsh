# ═══════════════════════════════════════════════════════════════════════
#  nvm.zsh — Node Version Manager
#  ─────────────────────────────────────────────────────────────────────
#  Loaded by zshrc (interactive shells only).
#
#  NOT in zshenv on purpose — sourcing nvm.sh costs ~80ms on every zsh
#  process, including non-interactive scripts that never touch node.
#
#  Install: ~/.dotfiles/scripts/setup/install_nvm.zsh
#  Docs:    https://github.com/nvm-sh/nvm
# ═══════════════════════════════════════════════════════════════════════

export NVM_DIR="$HOME/.nvm"

if [[ -s "$NVM_DIR/nvm.sh" ]]; then
  source "$NVM_DIR/nvm.sh"
  # bash completion — zsh sources it fine, skip silently if absent
  [[ -s "$NVM_DIR/bash_completion" ]] && source "$NVM_DIR/bash_completion"
fi
