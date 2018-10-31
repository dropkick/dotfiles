if ! is-executable brew -o ! is-executable git; then
  echo "Skipped: npm (missing: brew and/or git)"
  return
fi

brew install nvm

export DOTFILES_BREW_PREFIX_NVM=$(brew --prefix nvm)
set-config "DOTFILES_BREW_PREFIX_NVM" "$DOTFILES_BREW_PREFIX_NVM" "$DOTFILES_CACHE"

. "${DOTFILES_DIR}/system/.nvm"
nvm install 8
nvm alias default 8

# Globally install with npm

packages=(
  fkill-cli
  get-port-cli
  gtop
  gulp
  historie
  nodemon
  npm
  pageres
  pageres-cli
  prettier
  release-it
  spot
  superstatic
  svgo
  tldr
  underscore-cli
  vtop
)

npm install -g "${packages[@]}"
