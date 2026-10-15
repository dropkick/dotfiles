#!/usr/bin/env zsh
# ═══════════════════════════════════════════════════════════════════════
#  install_nvm.zsh — install nvm + a default Node version
#  ─────────────────────────────────────────────────────────────────────
#  Called automatically by Dotbot during `./install`.
#  Safe to re-run — skips anything already present.
# ═══════════════════════════════════════════════════════════════════════

info() { echo -e "\033[1m[INFO]\033[0m $1" ; }
ok()   { echo -e "\033[32m[OK]\033[0m $1" ; }

NVM_VERSION="v0.40.8"
NODE_VERSION="24"
export NVM_DIR="$HOME/.nvm"

# ── Remove distro node/npm if present ─────────────────────────────────
# Debian/Ubuntu/Mint ship nodejs at /usr/bin/node — years behind and it
# fights nvm for PATH. Only remove it if dpkg says it's package-managed.
if command -v apt &>/dev/null && dpkg -l nodejs 2>/dev/null | grep -q '^ii'; then
  info "Removing distro nodejs (conflicts with nvm)..."
  sudo apt remove --purge -y nodejs npm 2>/dev/null || true
  sudo apt autoremove -y 2>/dev/null || true
  ok "Distro nodejs removed"
fi

# ── Install nvm ───────────────────────────────────────────────────────
if [[ -s "$NVM_DIR/nvm.sh" ]]; then
  ok "nvm already installed at $NVM_DIR"
else
  info "Installing nvm $NVM_VERSION..."
  # PROFILE=/dev/null stops install.sh from appending its loader block to
  # a shell profile. Here ~/.zshrc is a SYMLINK into this repo, so letting
  # it append would dirty a tracked file. config/zsh/nvm.zsh loads nvm.
  curl -o- "https://raw.githubusercontent.com/nvm-sh/nvm/${NVM_VERSION}/install.sh" \
    | PROFILE=/dev/null bash
  ok "nvm $NVM_VERSION installed"
fi

# ── Load nvm into THIS shell ──────────────────────────────────────────
# The installer writes files; it can't affect the running process. Without
# this, `nvm install` below is "command not found".
[[ -s "$NVM_DIR/nvm.sh" ]] && source "$NVM_DIR/nvm.sh"

# ── Install Node + set as default ─────────────────────────────────────
if ! command -v nvm &>/dev/null; then
  info "⚠️  nvm did not load — skipping Node install."
  info "    Open a new shell and run: nvm install $NODE_VERSION"
else
  if nvm ls "$NODE_VERSION" &>/dev/null; then
    ok "Node $NODE_VERSION already installed"
  else
    info "Installing Node $NODE_VERSION (this takes a minute)..."
    nvm install "$NODE_VERSION"
  fi
  # Set the default for NEW shells. Without this every fresh terminal
  # falls back to whatever was last `nvm use`d — or to nothing.
  nvm alias default "$NODE_VERSION" >/dev/null
  ok "Node $NODE_VERSION set as default ($(nvm version "$NODE_VERSION"))"
fi

ok "🟢 Node setup complete!"
