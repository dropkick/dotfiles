# Copy pwd to clipboard

alias cpwd="pwd|tr -d '\n'|pbcopy"

# Shortcuts

alias gg="$DOTFILES_GIT_GUI"

alias cask="brew cask"

alias chrome="open -a ~/Applications/Google\ Chrome.app"
alias canary="open -a ~/Applications/Google\ Chrome\ Canary.app"
alias firefox="open -a ~/Applications/Firefox.app"
alias firefox-dev="open -a ~/Applications/Firefox\ Developer\ Edition.app"
alias opera="open -a ~/Applications/Opera.app"
alias safari="open -a ~/Applications/Safari.app"
alias safari-dev="open -a ~/Applications/Safari\ Technology\ Preview.app"

# Exclude macOS specific files in ZIP archives

alias zip="zip -x *.DS_Store -x *__MACOSX* -x *.AppleDouble*"

# Open iOS Simulator

alias ios="open /Applications/Xcode.app/Contents/Developer/Applications/iOS\ Simulator.app"

# Flush DNS

alias flushdns='sudo killall -HUP mDNSResponder && cowsay cache flushed'

# Start screen saver

alias afk="open /System/Library/CoreServices/ScreenSaverEngine.app"

# Log off

alias logoff="/System/Library/CoreServices/Menu\ Extras/User.menu/Contents/Resources/CGSession -suspend"

# Sleep

alias zzz="pmset sleepnow"

# Eject all ejectable volumes

alias ejector="osascript -e 'tell application "Finder" to eject (every disk whose ejectable is true)'"

# Quick-Look preview files from the command line

alias ql="qlmanage -p &>/dev/null"

# Show/hide desktop icons

alias desktopshow="defaults write com.apple.finder CreateDesktop -bool true && killfinder"
alias desktophide="defaults write com.apple.finder CreateDesktop -bool false && killfinder"

# Recursively remove Apple meta files

alias cleanupds="find . -type f -name '*.DS_Store' -ls -delete"
alias cleanupad="find . -type d -name '.AppleD*' -ls -exec /bin/rm -r {} \;"

# Clean up LaunchServices to remove duplicates in the "Open With" menu

alias lscleanup="/System/Library/Frameworks/CoreServices.framework/Frameworks/LaunchServices.framework/Support/lsregister -kill -r -domain local -domain system -domain user && killall Finder"

# Empty trash on mounted volumes and main HDD, and clear system logs

alias emptytrash="sudo rm -rfv /Volumes/*/.Trashes; sudo rm -rfv ~/.Trash; sudo rm -rfv /private/var/log/asl/*.asl"

# Reload native apps

alias killfinder="killall Finder"
alias killdock="killall Dock"
alias killmenubar="killall SystemUIServer NotificationCenter"
alias killos="killfinder && killdock && killmenubar"

# Kill all the tabs in Chrome to free up memory

alias chromekill="ps ux | grep '[C]hrome Helper --type=renderer' | grep -v extension-process | tr -s ' ' | cut -d ' ' -f2 | xargs kill"

alias update="dotfiles update"

# Set vtop to always use monokai theme
alias vtop="vtop --theme monokai"

# Create a Taskpaper todo file in the current folder
alias todofile='touch todo.taskpaper && open -a "Taskpaper" todo.taskpaper'

# Stuff I never really use but cannot delete either because of http://xkcd.com/530/
alias stfu="osascript -e 'set volume output muted true'"
alias pumpitup="osascript -e 'set volume 7'"

## Added 2018-02-02 (via https://gist.github.com/cirrusUK/f1eec87cf5e63985d4e3)

alias wget='wget -c'
alias robot='espeak'

# Show system information

alias displays="system_profiler SPDisplaysDataType"
alias cpu="sysctl -n machdep.cpu.brand_string"

alias pbtext="pbpaste | textutil -convert txt -stdin -stdout -encoding 30 | pbcopy"
alias pbspaces="pbpaste | expand | pbcopy"
