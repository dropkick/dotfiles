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
  coda
  codekit
  crashplan
  dash
  default-folder-x
  deltawalker
  divvy
  dropbox
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
  # gpgtools
  harvest
  hazel
  imagealpha
  imageoptim
  imazing
  inboard
  inssider
  integrity
  iterm2 
  # kaleidoscope 
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
  opera
  opera-developer
  otomatic
  owncloud
  # rubitrack
  safari-technology-preview
  satellite-eyes 
  sequel-pro
  slack
  skype
  sourcetree
  sublime-text2
  # sublime-text 
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
  versions
  vlc
  webstorm
  whatsize
)

brew cask install "${apps[@]}"

# Quick Look Plugins (https://github.com/sindresorhus/quick-look-plugins)
brew cask install qlcolorcode qlstephen qlmarkdown quicklook-json qlprettypatch quicklook-csv betterzipql qlimagesize webpquicklook suspicious-package
