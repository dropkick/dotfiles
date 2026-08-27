#!/usr/bin/env zsh

# NAME: welcome.sh
# PATH: ~/.dotfiles/scripts/welcome.sh (symlinked to ~/scripts/welcome.sh)
# DESC: Display current weather, calendar and time on shell startup
# CALL: Sourced from ~/.zshrc on login
# DATE: Apr 6, 2017. Modified: Aug 27, 2026 (converted to zsh-compatible).

# Setup for 92 character wide terminal
DateColumn=34 # Default is 27 for 80 character line, 34 for 92 character line
TimeColumn=61 # Default is 49 for   "   "   "   "    61 "   "   "   "

# Replace Portland with your city name, GPS, etc. See: curl wttr.in/:help
curl 'wttr.in/Portland?0' --silent --max-time 3 > /tmp/now-weather

# Timeout #. Increase for slow connection---^

# zsh: read file into array (split on newlines)
aWeather=("${(@f)$(< /tmp/now-weather)}")
rm -f /tmp/now-weather

# Was valid weather report found or an error message?
# zsh arrays are 1-indexed: aWeather[1] is the first line
if [[ "${aWeather[1]}" == "Weather report:"* ]] ; then
    WeatherSuccess=true
    echo "${aWeather[@]}"
else
    WeatherSuccess=false
    echo "+============================+"
    echo "| Weather unavailable now!!! |"
    echo "| Check reason with command: |"
    echo "|                            |"
    echo "| curl wttr.in/Portland?0    |"
    echo "|   --silent --max-time 3    |"
    echo "+============================+"
    echo " "
fi
echo " "                # Pad blank lines for calendar & time to fit

#--------- DATE -------------------------------------------------------------

# calendar current month with today highlighted.
# colors 00=bright white, 31=red, 32=green, 33=yellow, 34=blue, 35=purple,
#        36=cyan, 37=white

tput sc                 # Save cursor position.
# Move up 9 lines
# Strip control characters from cal output
tr -cd '\11\12\15\40\60-\136\140-\176' < /tmp/terminal1 > /tmp/terminal
