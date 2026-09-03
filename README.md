# dotfiles

```text
    _     _    __ _ _
 __| |___| |_ / _(_) |___ ___
/ _` / _ \  _|  _| | / -_|_-<
\__,_\___/\__|_| |_|_\___/__/

```

Focused on macOS and flavors of Linux I use most (Debian, Mint, DietPi, Fedora, Arch, etc.).

![License](https://p.kagi.com/proxy/license-personal-blue?c=EgGQfWtq44GRXgvj3b8hBT9Ge2Vh_riJyU6FF9ZblGvu-jRvNFNzL-hMmsQsdQqaQUyn2mFUjhEMVdO-VTKJMzDItz0mlR3aOyCo6bhRRq0%3D)
![Shell](https://p.kagi.com/proxy/shell-zsh-orange?c=EgGQfWtq44GRXgvj3b8hBZKRAkalvT8vg7AbP1kL44dCofqhzvZAuQTA5EwIzx6WgbnaggTVjUFKRys4ahHK3w%3D%3D)
![OS](https://p.kagi.com/proxy/platform-macOS%20%7C%20Linux-success?c=EgGQfWtq44GRXgvj3b8hBe5AlT5CdAhhGjaxLHzJ-5yUToW3DhvsI5olR93MgK_B6azDlsF3R31EA_LRBpRneOTTB_UUE8TAlN4nbgJg6HUXwhgI-kQFpHdm-R4DULJE)
![Manager](https://p.kagi.com/proxy/managed%20by-Dotbot-yellow?c=EgGQfWtq44GRXgvj3b8hBSWaisRzt1x0yTAIDau0DNWx5SRRGZr0ZKLAOs2_tCOayEtdkgoQzmbAlmakL1_4HHgxfkFT1vvFsFS6Jn0ov2U%3D)

---

## What's Included

- **zsh** shell with three autocomplete plugins:
  - `zsh-autosuggestions` — grey ghost text suggestions from history
  - `zsh-syntax-highlighting` — green/red command coloring as you type
  - `zsh-history-substring-search` — Up/Down arrows search matching history
- **Powerlevel10k** prompt theme (configurable with `p10k configure`)
- **fzf** integration for fuzzy history search (Ctrl+R)
- Cross-platform **`updates`** function — updates system, package manager,
  Mac App Store (mas), npm, and Ruby gems with one command
- Cross-platform **`clean`** function — clears caches and frees disk space
  for brew/apt, npm, gems, pip, Docker, and trash with one command
- A collection of **aliases** and **functions** for common tasks:
  - `calc` — quick calculator (`calc "2 + 2"`)
  - `cheat` — command cheatsheets via cht.sh (`cheat tar`)
  - `ff` / `fd` — fuzzy find files/directories by name
  - `duf` — disk usage, sorted and formatted
  - `gz` — gzip compression ratio for a file
  - `dataurl` — create a data URL from a file
  - `down4me` / `uporno` — check if a site is down for everyone or just you
  - `wx` — weather report via wttr.in (`wx`, `wx 97201`, `wx -0` for full forecast)
  - `moon` — moon phase with ASCII art and phase name
- **Introspection commands** — `aliases` lists alias names, `fn` lists
  function names (or pass a name to see its body)
- A **welcome screen** showing weather, calendar, and time on terminal open
- **Automatic backups** — the installer backs up any existing real files
  before replacing them with symlinks
- **Standalone macOS defaults script** — applies ~100 system preferences
  (run manually, not part of `./install`)

## Repository Structure

    dotfiles/
    ├── README.md                         ← you are here
    ├── install.conf.yaml                 ← Dotbot config (what gets linked)
    ├── install                           ← Dotbot entry point (run this)
    ├── config/
    │   ├── zsh/
    │   │   ├── zshrc                     ← thin loader (→ ~/.zshrc)
    │   │   ├── zshenv                    ← env vars (→ ~/.zshenv)
    │   │   ├── .p10k.zsh                 ← prompt config (→ ~/.p10k.zsh)
    │   │   ├── options.zsh               ← history + shell options
    │   │   ├── aliases.zsh               ← shared aliases (all OSes)
    │   │   ├── aliases.linux.zsh         ← Linux-specific aliases
    │   │   ├── aliases.macos.zsh         ← macOS-specific aliases
    │   │   └── functions.zsh             ← shell functions (updates, clean, fn,
    │   │                                    calc, cheat, ff, fd, duf, gz,
    │   │                                    dataurl, down4me, uporno, wx, moon)
    │   └── git/
    │       ├── gitconfig                 ← (→ ~/.gitconfig)
    │       ├── gitconfig.macos           ← (→ ~/.config/git/gitconfig.macos)
    │       ├── gitconfig.linux           ← (→ ~/.config/git/gitconfig.linux)
    │       └── ignore                    ← (→ ~/.config/git/ignore)
    ├── scripts/
    │   ├── welcome.sh                    ← weather/calendar/time greeting
    │   └── setup/
    │       ├── backup_existing.zsh       ← backs up real files before linking
    │       ├── install_packages.zsh      ← OS-aware package installer
    │       └── macos_defaults.zsh        ← standalone macOS system preferences
    ├── powerlevel10k/                    ← git submodule
    └── dotbot/                           ← git submodule

## Install on a New Machine

    # 1. Clone the repo (with submodules for Dotbot and Powerlevel10k)
    git clone --recursive git@github.com:dropkick/dotfiles.git ~/.dotfiles

    # 2. Run the installer
    cd ~/.dotfiles
    ./install

    # 3. Set your terminal font to a Nerd Font (e.g. FiraMono Nerd Font)

    # 4. Restart your terminal — you should see the welcome screen and prompt

    # 5. If first time on this machine, configure the prompt:
    p10k configure

The installer:

1. Removes broken symlinks in your home directory
2. Backs up any existing real files that would be replaced (to
   ~/.dotfiles-backup-TIMESTAMP/)
3. Installs zsh + autocomplete plugins (via Homebrew on macOS,
   apt/dnf/pacman on Linux)
4. Creates symlinks for all config files (via Dotbot)
5. Creates the platform-specific gitconfig.local symlink
6. Ports bash history to zsh (if applicable)
7. Sets zsh as the default shell

### Automatic Backups

The installer automatically backs up any existing real files (not
symlinks) that would be overwritten by the symlinking step. Backups
are saved to:

    ~/.dotfiles-backup-YYYYMMDD-HHMMSS/

For example, if you already have a ~/.zshrc, it gets copied to
~/.dotfiles-backup-20260827-143000/.zshrc before being replaced
with a symlink.

The backup script reads install.conf.yaml dynamically — no hardcoding.
If you add new link targets to the config, they're automatically
included in future backups.

Once you've verified everything works, you can remove old backups:

    rm -rf ~/.dotfiles-backup-*

### How Dotbot Works

Dotbot reads `install.conf.yaml` and creates symlinks from the repo into
your home directory. For example:

    ~/.zshrc                       → dotfiles/config/zsh/zshrc
    ~/.config/dotfiles/aliases.zsh → dotfiles/config/zsh/aliases.zsh
    ~/.gitconfig                   → dotfiles/config/git/gitconfig
    ~/.config/git/ignore           → dotfiles/config/git/ignore
    ~/.config/git/gitconfig.macos  → dotfiles/config/git/gitconfig.macos
    ~/.config/git/gitconfig.linux  → dotfiles/config/git/gitconfig.linux

Because they're symlinks, any edit you make to the file in the repo
is immediately live — no copy step needed.

The repo can live anywhere (~/.dotfiles, ~/Projects/dotfiles, etc.) —
Dotbot uses absolute paths for symlinks, so the location doesn't matter.
Just run `./install` from wherever you cloned it.

## Making Changes

| What you want to do             | How                                                               |
| ------------------------------- | ----------------------------------------------------------------- |
| Add an alias                    | Edit `config/zsh/aliases.zsh`, then `source ~/.zshrc`             |
| Add an OS-specific alias        | Edit `aliases.linux.zsh` or `aliases.macos.zsh`                   |
| Add a function                  | Edit `config/zsh/functions.zsh`, then `source ~/.zshrc`           |
| Change prompt                   | Run `p10k configure` (saves to `~/.p10k.zsh`, which is symlinked) |
| Edit welcome screen             | Edit `scripts/welcome.sh`                                         |
| Change what gets linked         | Edit `install.conf.yaml`, then re-run `./install`                 |
| Update packages on this machine | Run `updates`                                                     |
| Clean caches / free disk space  | Run `clean`                                                       |
| List all aliases                | Run `aliases`                                                     |
| List all functions              | Run `fn` (or `fn <name>` to see a body)                           |
| Check weather                   | Run `wx` (or `wx <zip>`, `wx -0` for full forecast)               |
| Check moon phase                | Run `moon`                                                        |
| Check if a site is down         | Run `down4me <site>` (or `uporno <site>`)                         |
| Apply macOS defaults            | Run `~/.dotfiles/scripts/setup/macos_defaults.zsh`                |

## Syncing Across Machines

    # On the machine you changed:
    cd ~/.dotfiles
    git add -A
    git commit -m "description of change"
    git push

    # On other machines:
    cd ~/.dotfiles
    git pull
    ./install    # re-run to update symlinks if install.conf.yaml changed
    source ~/.zshrc    # reload zsh for alias/function changes

You only need to re-run `./install` when `install.conf.yaml` changed
(files added, removed, or renamed). For edits to existing files, just
`git pull` and `source ~/.zshrc` — the symlinks already point to the
updated content.

## The `updates` Function

Run `updates` to update everything on your system:

**On macOS:**

1. macOS software updates (`softwareupdate`)
2. Homebrew update + upgrade
3. Mac App Store apps (`mas upgrade`)
4. Global npm packages
5. Ruby gems

**On Linux:**

1. apt update + upgrade
2. Global npm packages
3. Ruby gems

Each step is labeled with a progress indicator and skips gracefully if
a tool isn't installed.

## The `clean` Function

Run `clean` to clear caches and free up disk space:

**On macOS:**

1. Homebrew cache (`brew cleanup --prune=0`)
2. Trash (`~/.Trash/*`)
3. DNS cache (`mDNSResponder`)
4. Ruby gem cleanup
5. npm cache
6. pip cache
7. Docker system prune

**On Linux:**

1. apt cleanup (`autoremove`, `clean`, `autoclean`)
2. Trash (`~/.local/share/Trash/*`)
3. Ruby gem cleanup
4. npm cache
5. pip cache
6. Docker system prune

Same as `updates` — each step skips gracefully if a tool isn't installed.

## macOS System Defaults

`scripts/setup/macos_defaults.zsh` is a standalone script that applies
~100 macOS system preferences (UI, keyboard, trackpad, Finder, Dock,
Safari, Mail, Calendar, Spotlight, Terminal, App Store, etc.).

**This is NOT run by `./install`** — system defaults are invasive
(kill apps, require sudo, change UI). Run it manually on a fresh Mac
or when you want to reapply preferences:

    # Run with default hostname (keeps existing)
    ~/.dotfiles/scripts/setup/macos_defaults.zsh

    # Run and set a custom computer name
    COMPUTER_NAME="primo" ~/.dotfiles/scripts/setup/macos_defaults.zsh

The script is safe to re-run — all `defaults write` commands are
idempotent. Hostname is only set if `COMPUTER_NAME` is passed; otherwise
the existing computer name is kept.

## Git Configuration

The global gitconfig is symlinked to `~/.gitconfig`. It includes:

- User info (name, email, GitHub user: dropkick, GitLab user: dropkickdesign)
- Aliases (`l`, `st`, `co`, `ci`, `p`, `pr`, `br`, `amend`, etc.)
- Color scheme for branch/diff/status output
- Push/fetch behavior (simple, followTags, prune)
- Global gitignore at `~/.config/git/ignore` (covers macOS + Windows metadata,
  Node.js, Sublime, VS Code, CodeKit)

### Platform-specific Git settings

OS-specific git settings (credential helper, pager) are handled
automatically. The repo includes two platform files:

- `gitconfig.macos` — `osxkeychain` credential helper, `diff-so-fancy` pager
- `gitconfig.linux` — `store` credential helper, plain `less` pager

Both are symlinked into `~/.config/git/` by Dotbot. During `./install`,
the setup script creates `~/.config/git/gitconfig.local` as a symlink
to the appropriate platform file based on OS. The main `~/.gitconfig`
includes it via:

    [include]
        path = ~/.config/git/gitconfig.local

No manual setup needed — it just works after `./install`.

## OS-Specific Aliases

The `zshrc` detects the OS via `uname -s` and loads:

- `aliases.zsh` — shared aliases (always loaded)
- `aliases.linux.zsh` — Linux-specific (loaded on Linux)
- `aliases.macos.zsh` — macOS-specific (loaded on macOS)

## DietPi / Minimal Systems

DietPi is Debian-based but minimal. If `install_packages.zsh` can't
install the zsh plugins via apt, clone from git as a fallback:

    git clone --depth=1 https://github.com/zsh-users/zsh-autosuggestions \
      ~/.zsh-plugins/zsh-autosuggestions
    git clone --depth=1 https://github.com/zsh-users/zsh-syntax-highlighting \
      ~/.zsh-plugins/zsh-syntax-highlighting

The `zshrc` already checks `~/.zsh-plugins/` as a fallback path.

For `fzf` on minimal systems:

    git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
    ~/.fzf/install

## License

Personal use. Feel free to fork and adapt.
