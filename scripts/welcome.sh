#!/usr/bin/env zsh

# NAME: welcome.sh
# PATH: ~/.dotfiles/scripts/welcome.sh (symlinked to ~/scripts/welcome.sh)
# DESC: Display cached weather, moon phase, and a random quote on shell startup
# CALL: Sourced from ~/.zshrc on login
# DATE: Apr 6, 2017. Modified: Nov  3, 2026
#       - wttr.in is primary for both wx and moonphase calls; each has an
#         api.open-meteo.com failover. "WX unavailable" only if all fail.
#       - A wttr.in failure opens a 30-minute circuit breaker, so an outage
#         costs one wttr attempt per 30 min instead of one per refresh.

zmodload -F zsh/stat b:zstat 2>/dev/null    # zsh builtin — portable mtimes

LOCATION="Portland"                          # wttr.in location string
LAT="45.5152"                                # Portland, OR — coords for Open-Meteo
LON="-122.6784"

WELCOME_CACHE="${XDG_CACHE_HOME:-$HOME/.cache}/welcome"
mkdir -p "$WELCOME_CACHE" 2>/dev/null
WX_CACHE="$WELCOME_CACHE/weather.cache"
WX_TTL=1800                                  # seconds (30 min)
WX_TTL_FAIL=300                              # shorter TTL while showing failover output
WX_DOWN_MARK="$WELCOME_CACHE/wttr-down.mark" # circuit breaker: last wttr failure
WX_DOWN_TTL=1800                             # seconds to skip wttr after a failure

# ── Helpers (removed at the bottom — this script is sourced) ────────────
_ok_fresh() {                                # $1=file  $2=ttl
    [[ -s "$1" ]] || return 1
    local m
    m=$(zstat +mtime "$1" 2>/dev/null) || return 1
    (( $(date +%s) - m < $2 ))
}

_json_num() {                                # $1=key  $2=json fragment -> number
    local re="\"$1\"[[:space:]]*:[[:space:]]*(-?[0-9]+(\.[0-9]+)?)"
    local -a match mbegin mend
    [[ $2 =~ $re ]] && print -r -- $match[1]
}

_compass() {                                 # 217 -> SW
    local -a dirs=(N NNE NE ENE E ESE SE SSE S SSW SW WSW W WNW NW NNW)
    local i=$(( ( ${1:-0} + 11 ) / 22 % 16 ))
    print -r -- ${dirs[i+1]}
}

_wmo() {                                     # $1=WMO code  $2=is_day -> "☁️  Overcast"
    case $1 in
        0)   (( ${2:-1} )) && print -r -- "☀️  Clear sky"     || print -r -- "🌙 Clear" ;;
        1)   (( ${2:-1} )) && print -r -- "🌤️  Mainly clear"  || print -r -- "🌙 Mostly clear" ;;
        2)   print -r -- "⛅ Partly cloudy" ;;
        3)   print -r -- "☁️  Overcast" ;;
        45|48) print -r -- "🌫️  Fog" ;;
        51|53|55|56|57) print -r -- "🌦️  Drizzle" ;;
        61|63|65|66|67) print -r -- "🌧️  Rain" ;;
        71|73|75|77) print -r -- "🌨️  Snow" ;;
        80|81|82) print -r -- "🌧️  Showers" ;;
        85|86) print -r -- "🌨️  Snow showers" ;;
        95|96|97|99) print -r -- "⛈️  Thunderstorm" ;;
        *)   print -r -- "🌡️  WMO $1" ;;
    esac
}

_wx_openmeteo() {                            # wttr-style block; nonzero = failed
    local url json cur t f rh w wd code day
    url="https://api.open-meteo.com/v1/forecast?latitude=${LAT}&longitude=${LON}"
    url+="&current=temperature_2m,apparent_temperature,relative_humidity_2m"
    url+=",weather_code,wind_speed_10m,wind_direction_10m,is_day"
    url+="&temperature_unit=fahrenheit&wind_speed_unit=mph&timezone=auto"

    json=$(curl --silent --connect-timeout 2 --max-time 3 "$url" 2>/dev/null) || return 1
    [[ $json == *'"current":{'* ]] || return 1      # error JSON has no current block
    cur=${json#*'"current":{'}
    cur=${cur%%\}*}

    t=$(_json_num temperature_2m "$cur")            || return 1
    f=$(_json_num apparent_temperature "$cur")
    rh=$(_json_num relative_humidity_2m "$cur")
    w=$(_json_num wind_speed_10m "$cur")
    wd=$(_json_num wind_direction_10m "$cur")
    code=$(_json_num weather_code "$cur")
    day=$(_json_num is_day "$cur")

    print -r -- "${LOCATION}  ·  open-meteo"
    print -r -- "$(_wmo ${code:-0} ${day:-1})"
    print -r -- "$(printf '%.0f' $t)°F · feels $(printf '%.0f' ${f:-$t})°F"
    print -r -- "Wind $(printf '%.0f' ${w:-0}) mph $(_compass ${wd:-0}) · ${rh:-?}% RH"
}

_moon_name() {                               # $1 = fraction 0..1 -> "Waning Crescent"
    local f=$1 ip fp th seg
    [[ $f == <-> || $f == <->.<-> || $f == .<-> ]] || return 1
    if [[ $f == *.* ]]; then fp=${f#*.}; else fp=; fi
    fp=${fp[1,3]}                            # truncate to 3 decimals
    fp=${(r:3::0:)fp}                        # right-pad to 3 with zeros
    ip=${f%%.*}; ip=${ip:-0}
    th=$(( ip * 1000 + fp ))                 # fraction in thousandths, integer math
    seg=$(( (th * 8 + 500) / 1000 % 8 ))
    case $seg in
        0) print -r -- "New Moon" ;;
        1) print -r -- "Waxing Crescent" ;;
        2) print -r -- "First Quarter" ;;
        3) print -r -- "Waxing Gibbous" ;;
        4) print -r -- "Full Moon" ;;
        5) print -r -- "Waning Gibbous" ;;
        6) print -r -- "Last Quarter" ;;
        7) print -r -- "Waning Crescent" ;;
    esac
}

_moon_emoji() {                              # $1 = phase name -> emoji
    case $1 in
        "New Moon")        print -r -- "🌑" ;;
        "Waxing Crescent") print -r -- "🌒" ;;
        "First Quarter")   print -r -- "🌓" ;;
        "Waxing Gibbous")  print -r -- "🌔" ;;
        "Full Moon")       print -r -- "🌕" ;;
        "Waning Gibbous")  print -r -- "🌖" ;;
        "Last Quarter")    print -r -- "🌗" ;;
        "Waning Crescent") print -r -- "🌘" ;;
        *)                 print -r -- "🌕" ;;
    esac
}

_moon_wttr() {                               # primary 
    local json name
    local -a match mbegin mend
    json=$(curl -sf --connect-timeout 2 --max-time 4 "wttr.in/${LOCATION}?format=j1" 2>/dev/null) || return 1
    [[ $json =~ '"moon_phase":[[:space:]]*"([A-Za-z ]+)"' ]] || return 1
    name=$match[1]
    [[ $name == (New|Waxing|First|Full|Waning|Last)* ]] || return 1
    print -r -- $name
}

_moon_openmeteo() {                          # failover
    local json frac
    json=$(curl --silent --connect-timeout 2 --max-time 3 \
        "https://api.open-meteo.com/v1/forecast?latitude=${LAT}&longitude=${LON}&daily=moon_phase&timezone=auto&forecast_days=1" \
        2>/dev/null) || return 1
    [[ $json == *'"moon_phase":['* ]] || return 1
    frac=${json#*'"moon_phase":['}; frac=${frac%%,*}; frac=${frac%%]*}
    frac=${frac//[^0-9.]/}
    [[ -n $frac ]] || return 1
    _moon_name "$frac"
}

_moon_offline() {                            # ruh roh, last resort
    local age
    # new moon 2000-01-06 18:14 UTC; synodic month 2551443 s
    age=$(( ($(date +%s) - 947182440) % 2551443 ))
    (( age < 0 )) && age=$(( age + 2551443 ))
    _moon_name "$(printf '0.%03d' $(( age * 1000 / 2551443 )))"
}

# ── Weather refresh: wttr.in -> Open-Meteo, guarded by a circuit breaker ──
_wx_refresh() {                              # 0 = cache written, 1 = all failed
    local code tmp="$WX_CACHE.new.$$"        # $$ so concurrent shells don't collide

    if ! _ok_fresh "$WX_DOWN_MARK" "$WX_DOWN_TTL"; then
        code=$(curl "wttr.in/${LOCATION}?0" --silent \
                    --connect-timeout 2 --max-time 3 \
                    -o "$tmp" -w '%{http_code}' 2>/dev/null)
        if [[ $code == 200 && -s "$tmp" ]] \
           && [[ "$(head -n1 "$tmp")" == *"Weather report:"* ]] \
           && ! grep -qiE 'sorry|unknown location|quota|unavailable' "$tmp"; then
            mv -f -- "$tmp" "$WX_CACHE"
            rm -f -- "$WX_DOWN_MARK"
            return 0
        fi
        rm -f -- "$tmp"
        date +%s >| "$WX_DOWN_MARK"
    fi

    if _wx_openmeteo >| "$tmp" 2>/dev/null && [[ -s "$tmp" ]]; then
        mv -f -- "$tmp" "$WX_CACHE"
        return 0
    fi
    rm -f -- "$tmp"
    return 1
}

# ── Weather (30-min cache; 5 min while showing failover output) ─────────
wx_ttl=$WX_TTL
grep -q 'open-meteo' "$WX_CACHE" 2>/dev/null && wx_ttl=$WX_TTL_FAIL
if ! _ok_fresh "$WX_CACHE" "$wx_ttl"; then
    ( _wx_refresh ) &!      # fork + disown: never blocks the prompt
fi

if [[ -s "$WX_CACHE" ]]; then
    aWeather=("${(@f)$(< "$WX_CACHE")}")
    print -l -- "  ${^aWeather[@]}"
else
    printf '  +----------------------------+\n'
    printf '  |       WX unavailable       |\n'
    printf '  +----------------------------+\n'
fi


# ── Moon phase (daily cache; wttr.in -> Open-Meteo -> local math) ──────
MOON_CACHE="$WELCOME_CACHE/moon-phase-$(date +%F)"

if [[ -s "$MOON_CACHE" ]]; then
    phase=$(< "$MOON_CACHE")
else
    phase=$(_moon_wttr)       || \
    phase=$(_moon_openmeteo)  || \
    phase=$(_moon_offline)
    [[ -n $phase ]] && print -r -- "$phase" >| "$MOON_CACHE"
fi
print "   "
[[ -n "$phase" ]] && printf "\033[1;33m  %s %s\033[0m\n" "$(_moon_emoji "$phase")" "$phase"

# ── Quote ──────────────────────────────────────────────────────────────
QUOTE_FILE="$HOME/.config/quotes/quotes.txt"
QUOTE_WIDTH=50

# Show a random quote if the quotes repo is installed; otherwise skip silently
if [[ -s "$QUOTE_FILE" ]]; then
  quotes=("${(@f)$(<"$QUOTE_FILE")}")
  quotes=("${(@)quotes:#}")          # drop blank lines
  if (( $#quotes )); then
    echo " "
    q="${quotes[$((RANDOM % $#quotes + 1))]}"
    fold -s -w $((QUOTE_WIDTH - 2)) <<< "$q" | sed 's/^/ /'
  fi
fi

print -l -- "$WELCOME_CACHE"/moon-phase-* | tail -n +8 | xargs -r rm -f 2>/dev/null

# ── Clean up (sourced into your login shell) ───────────────────────────
unfunction _ok_fresh _json_num _compass _wmo _wx_refresh _wx_openmeteo \
           _moon_name _moon_emoji _moon_wttr _moon_openmeteo _moon_offline 2>/dev/null
unset wx_ttl phase aWeather quotes q LOCATION LAT LON 2>/dev/null
