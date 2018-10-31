if ! is-macos -o ! is-executable ruby -o ! is-executable curl -o ! is-executable git; then
  echo "Skipped: Homebrew (missing: ruby, curl and/or git)"
  return
fi

ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"

# brew tap homebrew/versions
# brew tap homebrew/dupes
brew tap Goles/battery
brew tap homebrew/homebrew-php # for php and composer
brew update
brew upgrade

# Install packages

apps=(
  bats
  battery
  composer
  coreutils
  cmake
  diff-so-fancy
  dockutil
  ffmpeg
  fasd
  git
  git-extras
  gnu-sed --with-default-names
  grep --with-default-names
  hub
  httpie
  imagemagick --with-webp
  jq
  lynx
  mackup
  nano
  pandoc
  peco
  psgrep
  python
  python@2
  shellcheck
  ssh-copy-id
  tmux
  tree
  unar
  wget
  wifi-password
  wp-cli
)

brew install "${apps[@]}"

export DOTFILES_BREW_PREFIX_COREUTILS=$(brew --prefix coreutils)
set-config "DOTFILES_BREW_PREFIX_COREUTILS" "$DOTFILES_BREW_PREFIX_COREUTILS" "$DOTFILES_CACHE"

ln -sfv "$DOTFILES_DIR/etc/mackup/.mackup.cfg" ~
