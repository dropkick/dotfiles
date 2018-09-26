# .files

These are my dotfiles. Take anything you want, but at your own risk.

Much of this is based on how [Lars Kappert](https://github.com/webpro/) has set his system up. A good amount of bits and inspiration from [Dan Lowe](https://github.com/tangledhelix) here as well.

This mess targets macOS systems, but has some checks to make lots of it work on *nix as well. macOS stuff is at very least broken out into its own files.

## Package overview

* Core
    * Bash + [coreutils](http://en.wikipedia.org/wiki/GNU_Core_Utilities) + bash-completion
    * [Homebrew](http://brew.sh/), [homebrew-cask](http://caskroom.io/)
    * Node.js + npm
    * `$EDITOR` (and Git editor) is [GNU nano](https://www.nano-editor.org)
    * GNU [sed](http://www.gnu.org/software/sed/), [grep](https://www.gnu.org/software/grep/), [Wget](https://www.gnu.org/software/wget/)
    * [fasd](https://github.com/clvv/fasd), [fkill-cli](https://github.com/sindresorhus/fkill-cli), [gtop](https://github.com/aksakalli/gtop), [psgrep](https://github.com/jvz/psgrep/blob/master/psgrep), [pgrep](http://linux.die.net/man/1/pgrep), [spot](https://github.com/guille/spot), [tree](http://mama.indstate.edu/users/ice/tree/), [unar](https://theunarchiver.com/command-line), [vtop](https://github.com/MrRio/vtop)
    * Git + [SourceTree](http://www.sourcetreeapp.com) + [hub](http://hub.github.com/), Subversion + [Cornerstone](https://www.zennaware.com/cornerstone/)
    * [rvm](https://rvm.io/) (Ruby 2.5)
    * Python 2 + 3 (`python/pip`, `python3/pip3`)
    * [Docker](https://www.docker.com/products/docker#/mac)
* Dev (Node/JS/JSON): [http-server](https://github.com/nodeapps/http-server), [jq](http://stedolan.github.io/jq/), [nodemon](http://nodemon.io), [peco](http://peco.github.io), [superstatic](https://github.com/firebase/superstatic), [underscore-cli](https://github.com/ddopson/underscore-cli)
* Graphics: [ffmpeg](https://www.ffmpeg.org), [imagemagick](http://www.imagemagick.org), [svgo](https://github.com/svg/svgo)
* macOS: [dockutil](https://github.com/kcrawford/dockutil), [Hammerspoon](https://www.hammerspoon.org), [Mackup](https://github.com/lra/mackup), [Quick Look plugins](https://github.com/sindresorhus/quick-look-plugins)
* [macOS apps](https://github.com/dropkick/dotfiles/blob/master/install/brew-cask.sh)


## Apps installed from App Store

These are either unavailable in Homebrew/Cask or my personal license is via the App Store.

* [Amphetamine](https://itunes.apple.com/us/app/amphetamine/id937984704) - better replacement for Caffiene 
* [Chronicle](https://itunes.apple.com/us/app/chronicle-bill-management/id402355593) - Bill management
* [ColorSnapper 2](https://itunes.apple.com/us/app/colorsnapper-2/id969418666) - color picker/eyedropper
* [Day One](https://itunes.apple.com/us/app/day-one/id1055511498) - Journaling <applet></applet>
* [Deliveries](https://itunes.apple.com/us/app/deliveries-a-package-tracker/id924726344) - a package tracker
* [Dropzone 3](https://itunes.apple.com/us/app/dropzone-3/id695406827) - move files, open applications and share files
* [EchoHam](https://itunes.apple.com/us/app/echoham/id873302145?mt=12) - Echolink network from mac
* [Exporter for Contacts](https://www.subclassed.com/apps/exporter-for-contacts/export-mac-os-x-mail-address-book-contacts-to-csv-or-excel) - Contacts export in multiple formats with custom templates
* [Fantastical](https://itunes.apple.com/us/app/fantastical-2-calendar-reminders/id975937182) - calendars and reminders 
* [FruitJuice](http://fruitjuiceapp.com/) - macOS battery maintenance and monitoring
* [iA Writer](https://itunes.apple.com/us/app/ia-writer/id775737590) - minimal distraction writing app
* [Keynote](https://itunes.apple.com/us/app/keynote/id409183694) - presentations 
* [Numbers](https://itunes.apple.com/us/app/numbers/id409203825) - spreadsheets 
* [Pages](https://itunes.apple.com/us/app/pages/id409201541) - word processor
* [Paprika Recipe Manager 3](https://itunes.apple.com/us/app/paprika-recipe-manager-3/id1303222628) - recipe management 
* [PDF Scanner](https://itunes.apple.com/us/app/pdfscanner-simple-document/id410968114) - Simple document scanning and OCR 
* [Pommie](https://itunes.apple.com/us/app/pommie/id963504129?mt=12) - menubar Pomodoro timer
* [Quiver](https://itunes.apple.com/us/app/quiver-programmers-notebook/id866773894) - the Programmer’s Notebook
* [Reeder](https://itunes.apple.com/us/app/reeder-3/id880001334) - RSS reader
* [Silicio](https://itunes.apple.com/us/app/silicio-for-spotify-itunes-deezer-and-vox/id933627574?mt=12) - used to report itunes to last.fm
* [Site Sucker](https://itunes.apple.com/us/app/sitesucker/id442168834?mt=12) - spider and download local copies of websites
* [Toast DVD](https://itunes.apple.com/us/app/toast-dvd/id829469267?mt=12) - DVD creation
* [Tweetbot 3 for Twitter](https://itunes.apple.com/us/app/tweetbot-3-for-twitter/id1384080005?mt=12) - twitter client
* [WiFi Explorer](https://itunes.apple.com/us/app/wifi-explorer/id494803304) - Scan, monitor, and troubleshoot wireless networks

## Packages to install manually (not covered by Homebrew, App Store, etc.)

* [Adobe Creative Cloud](https://creative.adobe.com/products/download/creative-cloud) - install Illustrator, Photoshop, etc. from this app
* [Ember]() - Discontinued image catalog and screenshot app. I have a local copy of installer. Still working on MacOS.
* [iRehearse Plus](http://rjvmedia.co.uk/irehearse-plus) - 
* [Permute](https://trial.charliemonroe.net/permute/download.php) - media file conversion utility (I intend to make a homebrew cask for this)
* [Privacy Badger](https://www.eff.org/privacybadger) - Install extensions/add-ons for Chrome, Firefox, and Safari
* [Seasonality Core](http://getseasonality.com/core/)
* [uBlock Origin](https://github.com/gorhill/uBlock/#installation) - Install extensions/add-ons for Chrome, Firefox, and Safari

## Post Installation 

* Tower CLI Tool - To install the `gittower` command line tool, run installer from Tower's preferences on the Integration tab. (Make sure that Tower is run from the /Applications folder before trying to install.)


## Install

On a sparkling fresh installation of macOS:

    sudo softwareupdate -i -a
    xcode-select --install

Note: update `COMPUTER_NAME` constant in [macos/defaults.sh](https://raw.github.com/dropkick/dotfiles/master/macos/defaults.sh) with correct/current machine name before firing that script.

Install the dotfiles with either Git or curl:

### Clone with Git

    git clone https://github.com/dropkick/dotfiles.git ~/.dotfiles
    source ~/.dotfiles/install.sh

### Remotely install using curl

Alternatively, you can install this into `~/.dotfiles` remotely without Git using curl:

    bash -c "`curl -fsSL https://raw.githubusercontent.com/dropkick/dotfiles/master/remote-install.sh`"

Or, using wget:

bash -c "`wget -O - --no-check-certificate https://raw.githubusercontent.com/dropkick/dotfiles/master/remote-install.sh`"

## The `dotfiles` command

    $ dotfiles help
    Usage: dotfiles <command>

    Commands:
       clean            Clean up caches (brew, npm, gem, rvm)
       dock             Apply macOS Dock settings
       edit             Open dotfiles in IDE (code) and Git GUI (stree)
       help             This help message
       macos            Apply macOS system defaults
       test             Run tests
       update           Update packages and pkg managers (OS, brew, npm, gem)

## Customize/extend

You can put your custom settings, such as Git credentials in the `system/.custom` file which will be sourced from `.bash_profile` automatically. This file is in `.gitignore`.

Alternatively, you can have an additional, personal dotfiles repo at `~/.extra`.

* The installer (`install.sh`) will run `~/.extra/install.sh`.
* The runcom `.bash_profile` sources all `~/.extra/runcom/*.sh` files.

## Additional resources

* [Awesome Dotfiles](https://github.com/webpro/awesome-dotfiles)
* [Homebrew](http://brew.sh/) / [FAQ](https://github.com/Homebrew/homebrew/wiki/FAQ)
* [homebrew-cask](http://caskroom.io/) / [usage](https://github.com/phinze/homebrew-cask/blob/master/USAGE.md)
* [Bash prompt](http://wiki.archlinux.org/index.php/Color_Bash_Prompt)
* [Solarized Color Theme for GNU ls](https://github.com/seebi/dircolors-solarized)

## Credits

Many thanks to the [dotfiles community](http://dotfiles.github.io/) and the creators of the incredibly useful tools.
