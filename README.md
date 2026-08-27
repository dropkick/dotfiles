cat &gt; ~/Projects/dotfiles/README.md &lt;&lt; &#x27;ENDOFFILE&#x27;
# dotfiles

My cross-platform dotfiles, managed with [Dotbot](https://github.com/anishathalye/dotbot).
Works on macOS and Linux (Debian, Mint, DietPi, etc.).

## What&#x27;s Included

- **zsh** shell with three autocomplete plugins:
    - `zsh-autosuggestions` — grey ghost text suggestions from history
    - `zsh-syntax-highlighting` — green/red command coloring as you type
    - `zsh-history-substring-search` — Up/Down arrows search matching history
- **Powerlevel10k** prompt theme (configurable with `p10k configure`)
- **fzf** integration for fuzzy history search (Ctrl+R)
- Cross-platform **`updates`** function — updates system, package manager,
  Mac App Store (mas), npm, and Ruby gems with one command

- A collection of **aliases** and **functions** for common tasks
- A **welcome screen** showing weather, calendar, and time on terminal open

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
    │   │   └── functions.zsh             ← shell functions (incl. `updates`)
    │   └── git/
    │       ├── gitconfig                 ← (→ ~/.gitconfig)
    │       └── ignore                    ← (→ ~/.config/git/ignore)
    ├── scripts/
    │   ├── welcome.sh                    ← weather/calendar/time greeting
    │   └── setup/
    │       └── install_packages.zsh      ← OS-aware package installer
    ├── powerlevel10k/                    ← git submodule
    └── dotbot/                           ← git submodule

## Install on a New Machine

    # 1. Clone the repo (with submodules for Dotbot and Powerlevel10k)
    git clone --recursive <mailto:git@github.com>:yourusername/dotfiles.git ~/.dotfiles

    # 2. Run the installer
    cd ~/.dotfiles
    ./install

    # 3. Set your terminal font to a Nerd Font (e.g. FiraMono Nerd Font)

    # 4. Restart your terminal — you should see the welcome screen and prompt

    # 5. If first time on this machine, configure the prompt:
    p10k configure

The installer:

1. Installs zsh + autocomplete plugins (via Homebrew on macOS, apt/dnf/pacman on Linux)
2. Clones zsh-history-substring-search from git
3. Creates symlinks for all config files (via Dotbot)
4. Ports bash history to zsh (if applicable)
5. Sets zsh as the default shell

### How Dotbot Works

Dotbot reads `install.conf.yaml` and creates symlinks from the repo into
your home directory. For example:

    ~/.zshrc                       → dotfiles/config/zsh/zshrc
    ~/.config/dotfiles/aliases.zsh → dotfiles/config/zsh/aliases.zsh
    ~/.gitconfig                   → dotfiles/config/git/gitconfig
    ~/.config/git/ignore           → dotfiles/config/git/ignore

Because they&#x27;re symlinks, any edit you make to the file in the repo
is immediately live — no copy step needed.

The repo can live anywhere (~/.dotfiles, ~/Projects/dotfiles, etc.) —
Dotbot uses absolute paths for symlinks, so the location doesn&#x27;t matter.
Just run `./install` from wherever you cloned it.

## Making Changes

| What you want to do | How |
|---|---|
| Add an alias | Edit `config/zsh/aliases.zsh`, then `source ~/.zshrc` |
| Add an OS-specific alias | Edit `aliases.linux.zsh` or `aliases.macos.zsh` |
| Add a function | Edit `config/zsh/functions.zsh`, then `source ~/.zshrc` |
| Change prompt | Run `p10k configure` (saves to `~/.p10k.zsh`, which is symlinked) |
| Edit welcome screen | Edit `scripts/welcome.sh` |
| Change what gets linked | Edit `install.conf.yaml`, then re-run `./install` |
| Update packages on this machine | Run `updates` |

## Syncing Across Machines

    # On the machine you changed:
    cd ~/.dotfiles
    git add -A
    git commit -m &quot;description of change&quot;
    git push

    # On other machines:
    cd ~/.dotfiles
    git pull
    ./install    # re-run to update symlinks if install.conf.yaml changed

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
a tool isn&#x27;t installed.

## Git Configuration

The global gitconfig is symlinked to `~/.gitconfig`. It includes:

- User info (name, email, GitHub user, GitLab user)
- Aliases (`l`, `st`, `co`, `ci`, `p`, `pr`, `br`, etc.)
- Color scheme for branch/diff/status output
- Push/fetch behavior (simple, followTags, prune)
- Global gitignore at `~/.config/git/ignore`

OS-specific git settings (credential helper, pager) live in
`~/.gitconfig.local`, which is NOT managed by this repo — each machine
has its own. Create it manually:

**macOS:**

    cat &gt; ~/.gitconfig.local &lt;&lt; &#x27;EOF&#x27;
    [credential]
        helper = osxkeychain
    [core]
        pager = diff-so-fancy | less --tabs=4 -RFX
    EOF
    git config --global include.path ~/.gitconfig.local

**Linux:**

    cat &gt; ~/.gitconfig.local &lt;&lt; &#x27;EOF&#x27;
    [credential]
        helper = store
    [core]
        pager = less --tabs=4 -RFX
    EOF
    git config --global include.path ~/.gitconfig.local

## OS-Specific Aliases

The `zshrc` detects the OS via `uname -s` and loads:

- `aliases.zsh` — shared aliases (always loaded)
- `aliases.linux.zsh` — Linux-specific (loaded on Linux)
- `aliases.macos.zsh` — macOS-specific (loaded on macOS)

## DietPi / Minimal Systems

DietPi is Debian-based but minimal. If `install_packages.zsh` can&#x27;t
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
ENDOFFILE
