# .files

These are my dotfiles. Take anything you want, but at your own risk.

It targets macOS systems, but it should work on \*nix as well (with `apt-get`).

## Issues

None known.

## Credits

Much of this is from [Lars Kappert](https://github.com/webpro/)'s setup. A good amount of bits and inspiration from [Dan Lowe](https://github.com/tangledhelix) here as well.

Many thanks to the [dotfiles community](http://dotfiles.github.io/) and the creators of these incredibly useful tools.

## Package overview

- [Homebrew](https://brew.sh) (packages: [Brewfile](./install/Brewfile))
- [homebrew-cask](https://formulae.brew.sh/cask/) (packages: [Caskfile](./install/Caskfile))
- [Node.js + npm LTS](https://nodejs.org/en/download/) (packages: [npmfile](./install/npmfile))
- Latest Ruby (packages: [Gemfile](./install/Gemfile))
- Latest Git, Bash 4, Python 3, GNU coreutils, curl
- [Hammerspoon](https://www.hammerspoon.org) (config: [keybindings & window management](./config/hammerspoon))
- [Mackup](https://github.com/lra/mackup) (sync application settings)
- `$EDITOR` (and Git editor) is [GNU nano](https://www.nano-editor.org)

## Apps installed from App Store

These are either unavailable in Homebrew/Cask or my personal license is via the App Store.

* [Amphetamine](https://itunes.apple.com/us/app/amphetamine/id937984704) - better replacement for Caffiene 
* [Chronicle](https://itunes.apple.com/us/app/chronicle-bill-management/id402355593) - Bill management
* [ColorSnapper 2](https://itunes.apple.com/us/app/colorsnapper-2/id969418666) - color picker/eyedropper
* [Day One](https://itunes.apple.com/us/app/day-one/id1055511498) - journaling 
* [Deliveries](https://itunes.apple.com/us/app/deliveries-a-package-tracker/id924726344) - a package tracker
* [Dropzone 3](https://itunes.apple.com/us/app/dropzone-3/id695406827) - move files, open applications and share files
* [EchoHam](https://itunes.apple.com/us/app/echoham/id873302145?mt=12) - Echolink network from mac
* [Exporter for Contacts](https://www.subclassed.com/apps/exporter-for-contacts/export-mac-os-x-mail-address-book-contacts-to-csv-or-excel) - Contacts export in multiple formats with custom templates
* [Fantastical](https://itunes.apple.com/us/app/fantastical-2-calendar-reminders/id975937182) - calendars and reminders 
* [Firefox Developer Edition](https://www.mozilla.org/en-US/firefox/developer/) - at last cheeck no cask available
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

* [Adobe Creative Cloud](https://creative.adobe.com/products/download/creative-cloud) installed via homebrew/cask - install Acrobat DC, Animate CC, Audition CC, Illustrator CC, InDesign CC, Media Encoder CC, Photoshop CC, and XD CC from this app
* [Brett's PopClip Extensions](https://github.com/ttscoff/popclipextensions) - Brett Terpstra's treasure trove of extensions for PopClip – which is installed via Homebrew cask – lots of really useful markdwon formatting tools here.
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

The Xcode Command Line Tools includes `git` and `make` (not available on stock macOS).
Then, install this repo with `curl` available:

    bash -c "`curl -fsSL https://raw.githubusercontent.com/dropkick/dotfiles/master/remote-install.sh`"

This will clone (using `git`), or download (using `curl` or `wget`), this repo to `~/.dotfiles`. Alternatively, clone manually into the desired location:

    git clone https://github.com/dropkick/dotfiles.git ~/.dotfiles

Use the [Makefile](./Makefile) to install everything [listed above](#package-overview), and symlink [runcom](./runcom) and [config](./config) (using [stow](https://www.gnu.org/software/stow/)):

    cd ~/.dotfiles
    make

## Post-install
* `dotfiles dock` (set [Dock items](./macos/dock.sh)) - in my particular case, I install all of my app store apps before this as I set shortcuts to them in the dock with this step.
* `dotfiles macos` (set [macOS defaults](./macos/defaults.sh))
* Mackup
	* Log in to cloud sync being used (Nextcloud/Owncloud in my case)
	* `mackup restore`
	* `ln -s ~/.config/mackup/.mackup.cfg ~` (until [#632](https://github.com/lra/mackup/pull/632) is fixed)

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

Alternatively, you can have an additional, personal dotfiles repo at `~/.extra`. The runcom `.bash_profile` sources all `~/.extra/runcom/*.sh` files.

## Additional resources

- [Awesome Dotfiles](https://github.com/webpro/awesome-dotfiles)
- [Homebrew](https://brew.sh)
- [Homebrew Cask](http://caskroom.io)
- [Bash prompt](https://wiki.archlinux.org/index.php/Color_Bash_Prompt)
- [Solarized Color Theme for GNU ls](https://github.com/seebi/dircolors-solarized)

