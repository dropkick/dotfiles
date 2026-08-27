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
    print -l "${aWeather[@]}"
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

tput sc                 # Save cursor position.

# Move up 9 lines
i=0
while [ $((++i)) -lt 10 ]; do tput cuu1; done

if [[ "$WeatherSuccess" == true ]] ; then
    Column=$((DateColumn - 10))
    tput cuf $Column        # Move x column number
    printf "          "     # Blank out ", country" with spaces
else
    tput cuf $DateColumn    # Position to column 34 for date display
fi

# Generate calendar and strip control characters
cal > /tmp/terminal1
tr -cd '\11\12\15\40\60-\136\140-\176' < /tmp/terminal1 > /tmp/terminal

CalLineCnt=1
Today=$(date +"%e")

printf "\033[32m"   # color green

while IFS= read -r Cal; do
    printf "%s" "$Cal"
    if [[ $CalLineCnt -gt 2 ]] ; then
        # See if today is on current line & invert background
        tput cub 22
        for (( j=0 ; j <= 18 ; j += 3 )) ; do
            Test=${Cal:$j:2}            # Current day on calendar line
            if [[ "$Test" == "$Today" ]] ; then
                printf "\033[7m"        # Reverse: [ 7 m
                printf "%s" "$Today"
                printf "\033[0m"        # Normal: [ 0 m
                printf "\033[32m"       # color green
                tput cuf 1
            else
                tput cuf 3
            fi
        done
    fi

    tput cud1               # Down one line
    tput cuf $DateColumn    # Move right
    CalLineCnt=$((++CalLineCnt))
done < /tmp/terminal

printf "\033[00m"           # color -- bright white (default)
echo ""

tput rc                     # Restore saved cursor position.

#-------- TIME --------------------------------------------------------------

tput sc                 # Save cursor position.

# Move up 8 lines
i=0
while [ $((++i)) -lt 9 ]; do tput cuu1; done
tput cuf $TimeColumn    # Move 61 columns right

# Do we have the toilet package?
if command -v toilet &>/dev/null; then
    echo " $(date +"%H:%M") " | \
        toilet -f future --filter border > /tmp/terminal
# Do we have the figlet package?
elif command -v figlet &>/dev/null; then
    date +"%H:%M" | figlet > /tmp/terminal
# else use standard font
else
    date +"%H:%M" > /tmp/terminal
fi

while IFS= read -r Time; do
    printf "\033[01;32m"    # color green
    printf "%s" "$Time"
    tput cud1               # Up one line
    tput cuf $TimeColumn    # Move right
done < /tmp/terminal

tput rc                     # Restore saved cursor position.
