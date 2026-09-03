#!/usr/bin/env zsh

# NAME: welcome.sh
# PATH: ~/.dotfiles/scripts/welcome.sh (symlinked to ~/scripts/welcome.sh)
# DESC: Display current weather and a random quote on shell startup
# CALL: Sourced from ~/.zshrc on login
# DATE: Apr 6, 2017. Modified: Sep 3, 2026 (weather + fortune quote only).

# Replace Portland with your city name, GPS, etc. See: curl wttr.in/:help
curl 'wttr.in/Portland?0' --silent --max-time 3 > /tmp/now-weather

# Timeout #. Increase for slow connection---^

# zsh: read file into array (split on newlines)
aWeather=("${(@f)$(< /tmp/now-weather)}")
rm -f /tmp/now-weather

# Was valid weather report found or an error message?
# zsh arrays are 1-indexed: aWeather[1] is the first line
if [[ "${aWeather[1]}" == "  Weather report:"* ]] ; then
    print -l "${aWeather[@]}"
else
    WeatherSuccess=false
    echo "  +============================+"
    echo "  |       WX unavailable       |"
    echo "  |        Check with:         |"
    echo "  |                            |"
    echo "  |   curl wttr.in/Portland?0  |"
    echo "  |   --silent --max-time 3    |"
    echo "  +============================+"
fi

##-------- QUOTE --------------------------------------------------------------

# Fortune-style random quote from config/quotes/quotes.txt.
# ${0:A} resolves this script's symlink (~/scripts/welcome.sh -> repo),
# so the quotes file is found no matter where the repo is cloned.
QUOTE_FILE="${0:A:h:h}/config/quotes/quotes.txt"
QUOTE_WIDTH=50

if [[ -s "$QUOTE_FILE" ]]; then
    quotes=("${(@f)$(<"$QUOTE_FILE")}")
    quotes=("${(@)quotes:#}")           # drop blank lines
    if (( $#quotes )); then
        echo " "
        q="${quotes[$((RANDOM % $#quotes + 1))]}"
        fold -s -w $((QUOTE_WIDTH - 2)) <<< "\"$q\"" | sed 's/^/  /'
    fi
fi
