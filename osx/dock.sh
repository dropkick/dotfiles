#!/bin/sh

# Position (left, bottom, right) 
defaults write com.apple.dock orientation -string "left" 

dockutil --no-restart --remove all
dockutil --no-restart --add "/Applications/iTunes.app"
dockutil --no-restart --add "/Applications/Mail.app"
dockutil --no-restart --add "/Applications/Messages.app"
dockutil --no-restart --add "/Applications/Slack.app"
dockutil --no-restart --add "/Applications/Tweetbot.app"
dockutil --no-restart --add "/Applications/Reeder.app"
dockutil --no-restart --add '' --type spacer --section apps
dockutil --no-restart --add "/Applications/Pages.app"
dockutil --no-restart --add "/Applications/Numbers.app"
dockutil --no-restart --add "/Applications/PDFScanner.app"
dockutil --no-restart --add "/Applications/Evernote.app"
dockutil --no-restart --add "/Applications/Quiver.app"
dockutil --no-restart --add "/Applications/rubiTrack 4 Pro.app"
dockutil --no-restart --add '' --type spacer --section apps
dockutil --no-restart --add "/Applications/Google Chrome.app"
dockutil --no-restart --add "/Applications/Google Chrome Canary.app"
dockutil --no-restart --add "/Applications/Firefox.app"
dockutil --no-restart --add "/Applications/FirefoxDeveloperEdition.app"
dockutil --no-restart --add "/Applications/Safari.app"
dockutil --no-restart --add "/Applications/Safari Technology Preview.app"
dockutil --no-restart --add '' --type spacer --section apps
dockutil --no-restart --add "/Applications/iTerm.app"
dockutil --no-restart --add "/Applications/Sublime Text 2.app"
dockutil --no-restart --add "/Applications/Tower.app"
dockutil --no-restart --add "/Applications/CodeKit.app"
dockutil --no-restart --add "/Applications/Dash.app"
dockutil --no-restart --add "/Applications/System Preferences.app"
dockutil --no-restart --add "/Applications/Utilities/Console.app"
dockutil --no-restart --add '' --type spacer --section apps
dockutil --add '~/Projects' --view list --display folder
dockutil --add '~/Applications' --view list --display folder
dockutil --add '~/Downloads' --view list --display folder
killall Dock
