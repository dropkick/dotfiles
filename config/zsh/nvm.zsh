# nvm.zsh — lazy-load nvm
#
# Sourcing nvm.sh + bash_completion costs ~0.9s per shell (nvm_auto alone
# spends ~285ms running `nvm use` against .nvmrc on every startup). These
# stubs defer all of it to the first real use.

export NVM_DIR="$HOME/.nvm"

_nvm_load() {
  unfunction nvm node npm npx 2>/dev/null
  [[ -s "$NVM_DIR/nvm.sh" ]]          && source "$NVM_DIR/nvm.sh"
  [[ -s "$NVM_DIR/bash_completion" ]] && source "$NVM_DIR/bash_completion"
}

for _c in nvm node npm npx; do
  eval "$_c() { _nvm_load; $_c \"\$@\"; }"
done
unset _c
