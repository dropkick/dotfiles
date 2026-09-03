#!/usr/bin/env zsh

# NAME: welcome.sh
# PATH: ~/.dotfiles/scripts/welcome.sh (symlinked to ~/scripts/welcome.sh)
# DESC: Display cached weather, moon phase, and a random quote on shell startup
# CALL: Sourced from ~/.zshrc on login
# DATE: Apr 6, 2017. Modified: Sep 3, 2026 (15-min weather cache, moon, quotes).

zmodload -F zsh/stat b:zstat 2>/dev/null    # zsh builtin — portable mtimes

# ── Weather (15-minute cache) ──────────────────────────────────────────
WX_CACHE="/tmp/wttr-weather.cache"
WX_TTL=900                                   # seconds (15 min)

wx_fresh=false
if [[ -s "$WX_CACHE" ]]; then
    wx_mtime=$(zstat +mtime "$WX_CACHE" 2>/dev/null)
    [[ -n "$wx_mtime" ]] && (( $(date +%s) - wx_mtime < WX_TTL )) && wx_fresh=true
fi

if (( ! wx_fresh )); then
    curl 'wttr.in/Portland?0' --silent --max-time 3 > "$WX_CACHE.new" 2>/dev/null
    # Promote to cache only if it's a valid report — a network blip
    # leaves the previous cache in place as last-known weather.
    if [[ -s "$WX_CACHE.new" && "$(head -n1 "$WX_CACHE.new")" == *"Weather report:"* ]]; then
        mv "$WX_CACHE.new" "$WX_CACHE"
    else
        rm -f "$WX_CACHE.new"
    fi
fi

if [[ -s "$WX_CACHE" ]]; then
    aWeather=("${(@f)$(< "$WX_CACHE")}")
    print -l -- "  ${^aWeather[@]}"
else
    echo "  +============================+"
    echo "  |       WX unavailable       |"
    echo "  +============================+"
fi

# ── Moon phase (daily cache) ───────────────────────────────────────────
MOON_CACHE="/tmp/moon-phase-$(date +%F)"
if [[ -s "$MOON_CACHE" ]]; then
    phase=$(< "$MOON_CACHE")
else
    phase=$(curl -sg --max-time 3 "wttr.in?format=j1" | grep -m1 'moon_phase' | sed 's/.*: *"//;s/".*//')
    [[ -n "$phase" ]] && print -r -- "$phase" > "$MOON_CACHE"
fi
print "   " 
[[ -n "$phase" ]] && printf "\033[1;33m  🌕 %s\033[0m\n" "$phase"

# ── Quote ──────────────────────────────────────────────────────────────
QUOTE_FILE="${0:A:h:h}/config/quotes/quotes.txt"
QUOTE_WIDTH=50

if [[ -s "$QUOTE_FILE" ]]; then
    quotes=("${(@f)$(<"$QUOTE_FILE")}")
    quotes=("${(@)quotes:#}")           # drop blank lines
    if (( $#quotes )); then
        echo " "
        q="${quotes[$((RANDOM % $#quotes + 1))]}"
        fold -s -w $((QUOTE_WIDTH - 2)) <<< "$q" | sed 's/^/  /'
    fi
fi
