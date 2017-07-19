# Install Caskroom

brew tap caskroom/cask
brew install brew-cask
brew tap caskroom/versions

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
  audacity
  audacity-lame-library 
  audio-hijack
  bartender
  banktivity
  clarify
  cleanmymac
  clipmenu
  cloak
  # coda - removed 2017-07-19
  codekit
  colloquy
  crashplan
  dash
  default-folder-x
  deltawalker
  devonthink-pro-office
  docker
  divvy
  dropbox
  # ember - discontinued. local copy installed manually
  epic
  evernote
  expandrive
  # fantastical (app store)
  firefox
  firefoxdeveloperedition
  fuzzyclock
  garagebuy
  garagesale
  google-chrome
  google-chrome-canary
  google-drive
  gpgtools
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
  knox
  lastfm
  launchbar
  little-snitch 
  livereload
  # mamp 
  marked
  netspot
  nvalt
  omnifocus-clip-o-tron
  omnifocus 
  omnioutliner
  # omniplan - no current license
  opera
  opera-developer
  otomatic
  owncloud
  renamer
  resilio-sync
  rubitrack-pro
  safari-technology-preview
  satellite-eyes 
  sequel-pro
  sketchup
  skype
  slack
  sourcetree
  # sublime-text2
  sublime-text 
  superduper
  suspicious-package 
  taskpaper 
  # textexpander
  torbrowser
  tower
  transmission 
  transmit
  tripmode
  twitter
  unison
  versions
  vlc
  webstorm
  whatsize
)

brew cask install "${apps[@]}"

# Quick Look Plugins (https://github.com/sindresorhus/quick-look-plugins)
brew cask install qlcolorcode qlstephen qlmarkdown quicklook-json qlprettypatch quicklook-csv betterzipql qlimagesize webpquicklook suspicious-package
