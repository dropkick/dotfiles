#!/usr/bin/env zsh
# ═══════════════════════════════════════════════════════════════════════
#  backup_existing.zsh — Back up real files & create dirs before Dotbot
#  ─────────────────────────────────────────────────────────────────────
#  Reads install.conf.yaml, extracts all link targets, and:
#    1. Creates any missing parent directories (so Dotbot can link into them)
#    2. Backs up any existing real files (not symlinks) to
#       ~/.dotfiles-backup-TIMESTAMP/
#
#  This runs as a shell step BEFORE the link step in install.conf.yaml,
#  so Dotbot's force:true can safely overwrite without losing data or
#  failing on missing directories.
#
#  No hardcoding — targets are pulled dynamically from the YAML.
# ═══════════════════════════════════════════════════════════════════════

set -e

CONFIG="${1:-install.conf.yaml}"
TIMESTAMP=$(date +%Y%m%d-%H%M%S)
BACKUP_DIR="$HOME/.dotfiles-backup-$TIMESTAMP"
BACKED_UP=0

# ── Extract link targets from install.conf.yaml using Python ───────────
# Dotbot requires Python, so this is a safe dependency.
TARGETS=$(python3 -c "
import yaml, sys, os

with open('$CONFIG') as f:
    data = yaml.safe_load(f)

targets = []
for entry in data:
    if isinstance(entry, dict) and 'link' in entry:
        for key in entry['link']:
            targets.append(key)

print('\n'.join(targets))
" 2>/dev/null)

if [[ -z "$TARGETS" ]]; then
  echo "  No link targets found in $CONFIG — skipping backup."
  exit 0
fi

# ── Create missing parent directories for all link targets ─────────────
# Dotbot's force:true overwrites files but does NOT create parent dirs.
# We do it here so linking never fails on a missing directory.
DIRS_CREATED=0
while IFS= read -r target; do
  expanded=$(eval echo "$target")
  parent=$(dirname "$expanded")
  if [[ ! -d "$parent" ]]; then
    mkdir -p "$parent"
    echo "  📁 Created directory: $parent"
    DIRS_CREATED=$((DIRS_CREATED + 1))
  fi
done <<< "$TARGETS"

if [[ $DIRS_CREATED -gt 0 ]]; then
  echo "  ✅ Created $DIRS_CREATED director(y/ies)."
else
  echo "  ✅ All target directories already exist."
fi

# ── Back up any real (non-symlink) files ───────────────────────────────
while IFS= read -r target; do
  # Expand ~ and env vars in the target path
  expanded=$(eval echo "$target")

  if [[ -e "$expanded" ]] && [[ ! -L "$expanded" ]]; then
    if [[ $BACKED_UP -eq 0 ]]; then
      mkdir -p "$BACKUP_DIR"
      echo "  📦 Backing up existing files to: $BACKUP_DIR"
    fi

    # Create parent directory structure in backup
    backup_path="$BACKUP_DIR/$expanded"
    mkdir -p "$(dirname "$backup_path")"

    cp -r "$expanded" "$backup_path"
    echo "    ✓ Backed up: $expanded"
    BACKED_UP=$((BACKED_UP + 1))
  fi
done <<< "$TARGETS"

if [[ $BACKED_UP -gt 0 ]]; then
  echo "  ✅ Backed up $BACKED_UP file(s)."
else
  echo "  ✅ No existing real files to back up."
fi
