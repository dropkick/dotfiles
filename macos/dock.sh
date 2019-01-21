#!/bin/sh

# Set up a 'browsers' folder with symlinks to all browsers to use as a launcher in dock
mkdir -p $HOME/Stacks/browsers

# Link browsers
ln -s '/Applications/Brave Browser.app' ~/Stacks/browsers/0\ -\ Brave
ln -s '/Applications/Firefox.app' ~/Stacks/browsers/1\ -\ Firefox
ln -s '/Applications/Firefox Developer Edition.app' ~/Stacks/browsers/2\ -\ Firefox\ Developer
ln -s '/Applications/Google Chrome.app' ~/Stacks/browsers/3\ -\ Chrome
ln -s '/Applications/Google Chrome Canary.app' ~/Stacks/browsers/4\ -\ Chrome\ Canary
ln -s '/Applications/Safari.app' ~/Stacks/browsers/5\ -\ Safari
ln -s '/Applications/Safari Technology Preview.app' ~/Stacks/browsers/6\ -\ Safari\ Preview
ln -s '/Applications/Opera.app' ~/Stacks/browsers/7\ -\ Opera
ln -s '/Applications/Epic.app' ~/Stacks/browsers/8\ -\ Epic
ln -s '/Applications/TorBrowser.app' ~/Stacks/browsers/9\ -\ TorBrowser
ln -s '/Applications/Reeder.app' ~/Stacks/browsers/10\ -\ Reeder

# Position (left, bottom, right) 
defaults write com.apple.dock orientation -string "left" 

dockutil --no-restart --remove all
dockutil --no-restart --add "/Applications/MailMate.app"
dockutil --no-restart --add "/Applications/iTerm.app"
dockutil --no-restart --add "/Applications/Visual Studio Code.app"
dockutil --no-restart --add "/Applications/Tower.app"
dockutil --no-restart --add "/Applications/Dash.app"
# dockutil --no-restart --add '' --type spacer --section apps
dockutil --no-restart --add "/Applications/nvALT.app"
dockutil --no-restart --add "/Applications/DEVONthink Pro Office.app"
dockutil --no-restart --add "/Applications/PDFScanner.app"
dockutil --no-restart --add '' --type spacer --section apps
dockutil --add '~/Stacks/browsers' --view list --display stack --sort name
dockutil --add 'vnc://dynamo.dropkick.design' --label 'dynamo.dropkick.us VNC'
dockutil --add 'smb://dynamo.dropkick.design' --label 'dynamo.dropkick.design SMB'
dockutil --add 'afp://projects.sandstrompartners.com' --label 'projects.sandstrom SMB'
dockutil --add '/Applications' --view list --display folder --sort name
dockutil --add '~/Projects' --view list --display folder
dockutil --add '~/Downloads' --view list --display folder

killall Dock
