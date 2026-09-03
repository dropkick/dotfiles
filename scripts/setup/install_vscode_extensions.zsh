#!/usr/bin/env zsh
# Install VS Code extensions from the tracked list
# Skips extensions that are already installed

EXTENSIONS_FILE="${1:-$HOME/.dotfiles/config/vscode/extensions.txt}"

if [[ ! -f "$EXTENSIONS_FILE" ]]; then
  echo "  No extensions file found at $EXTENSIONS_FILE — skipping."
  exit 0
fi

if ! command -v code &>/dev/null; then
  echo "  VS Code not found — skipping extension install."
  exit 0
fi

INSTALLED=$(code --list-extensions)
INSTALLED_COUNT=0

while IFS= read -r ext; do
  [[ -z "$ext" ]] && continue
  if echo "$INSTALLED" | grep -q "^${ext}$"; then
    echo "  ✓ Already installed: $ext"
  else
    code --install-extension "$ext"
    INSTALLED_COUNT=$((INSTALLED_COUNT + 1))
  fi
done < "$EXTENSIONS_FILE"

echo "  ✅ Installed $INSTALLED_COUNT new extension(s)."
