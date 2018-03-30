
if ! is-macos -o ! is-executable brew; then
  echo "Skipped: Homebrew-Cask"
  return
fi

brew tap caskroom/versions
brew tap caskroom/cask
brew tap caskroom/fonts
# brew install brew-cask

# Install packages

apps=(
  1password
  # adobe-creative-cloud 
  # adobe-illustrator-cc
  # adobe-indesign-cc 
  # adobe-photoshop-cc
  # adobe-photoshop-lightroom 
  # adobe-reader 
  appzapper
  arq
# audacity # cask removed
# audacity-lame-library 
#  audio-hijack
  bartender
  banktivity
  betterzip
  chronosync
#  clarify
  cleanmymac
#  clipmenu (replaced by clipy
  clipy
  codekit
  colloquy
  crashplan
  dash
  default-folder-x
  deltawalker
  devonthink-pro-office
  divvy
  docker
#  downie (404)
  dropbox
  # ember - discontinued. local copy installed manually
  encryptme 
  epic
  evernote
  expandrive
  # fantastical (app store)
  font-fira-code
  firefox
#  firefoxdeveloperedition
  fuzzyclock
  garagebuy
  garagesale
  google-chrome
  google-chrome-canary
#  google-drive
  google-backup-and-sync
  # gpgtools
  gpg-suite
  gqrx
  hammerspoon
  harvest
  hazel
  imagealpha
  imageoptim
  imazing # - replaced phoneview
  inboard
  inssider
  integrity
  iterm2 
  # kaleidoscope - consider licensing again if deltawalker gets clunky
  keybase
  kindle
  knox
  lastfm
  launchbar
  little-snitch 
  livereload
  mailmate
  # mamp 
  marked
  netspot
  nextcloud
  nvalt
  omnifocus 
  omnioutliner
  omniplan
  opera
  opera-developer
  otomatic
  owncloud
  renamer
  resilio-sync
  rubitrack-pro
  safari-technology-preview
  satellite-eyes 
  scrivener
  sequel-pro
  sketchup
  skype
  slack
  sourcetree
  sublime-text 
  superduper
  suspicious-package 
  taskpaper 
  textexpander
  torbrowser
  tormessenger
  tower
  transmission 
  transmit
  tripmode
  # unison
  versions
  virtualbox
  virtualbox-extension-pack 
  vlc
  webstorm
  whatsize
)

brew cask install "${apps[@]}"

# Quick Look Plugins (https://github.com/sindresorhus/quick-look-plugins)
brew cask install qlcolorcode qlstephen qlmarkdown quicklook-json quicklook-csv qlimagesize webpquicklook suspicious-package qlvideo

# Link Hammerspoon config
if [ ! -d ~/.hammerspoon ]; then ln -sfv "$DOTFILES_DIR/etc/hammerspoon/" ~/.hammerspoon; fi

