\# Install Homebrew

ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"

brew tap homebrew/versions
brew tap homebrew/dupes
brew tap Goles/battery
brew update
brew upgrade

# Install packages

apps=(
  bash-completion2
  bats
  battery
  coreutils
  cmake
  dockutil
  docker
  ffmpeg
  fasd
  gifsicle
  git
  gnu-sed --with-default-names
  grep --with-default-names
  hub
  httpie
  imagemagick --with-webp
  jq
  lynx
  mackup
  homebrew/dupes/openssh
  peco
  psgrep
  python
  p7zip
  shellcheck
  ssh-copy-id
  svn
  tree
  vim
  wget
  wifi-password
)

brew install "${apps[@]}"
