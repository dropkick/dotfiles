# ── Pi-hole fleet module ──────────────────────────────────────────────
# All fleet functions for aldo / brio / cleo (NanoPi NEOs, DietPi,
# Pi-hole v6). Requires passwordless root SSH to each host (keys pushed
# during 2026-09-18 backup setup).
#
# Fleet rule baked into every function: pfSense DHCP hands out ALL
# THREE DNS IPs, so fleet actions must hit all three — a partial action
# is the worst state (inconsistent filtering/versions, no visibility).
#
# Hosts and colors are defined once here; functions stay otherwise
# self-contained. info()/ok() helpers live in functions.zsh.

# Fleet members — single source of truth for all pihole functions
typeset -ga _pihole_hosts=(cleo brio aldo)

# Shared colors (set once at load; TTY check happens per call)
typeset -g _c_ok='' _c_bad='' _c_dim='' _c_off=''

pihole-fail() { printf '%s[FAIL]%s %s\n' "$_c_bad" "$_c_off" "$*"; }
_pihole-colors() {
    if [[ -t 1 ]]; then
        _c_ok=$'\e[32m'; _c_bad=$'\e[31m'; _c_dim=$'\e[2m'; _c_off=$'\e[0m'
    else
        _c_ok=''; _c_bad=''; _c_dim=''; _c_off=''
    fi
}

# ──────────────────────────────────────────────────────────────────────

# flushdns-piholes — Flush local DNS cache + all Pi-hole hosts' DNS caches
#
# Clears the local systemd-resolved cache, then restarts the DNS resolver
# (with cache flush) on each Pi-hole host in sequence: cleo, brio, aldo.
#
# Usage: flushdns-piholes [domain]
# Optional domain is resolved afterwards to verify the result.

function flushdns-piholes() {
    emulate -L zsh
    local host target result rc
    local ok=0 fail=0
    local start=$SECONDS
    _pihole-colors

    # Local cache first — client-side staleness
    printf 'Local resolver (systemd-resolved)... '
    if sudo resolvectl flush-caches >/dev/null 2>&1; then
        printf '%s✓%s\n' "$_c_ok" "$_c_off"
    else
        printf '%s✗ FAILED%s\n' "$_c_bad" "$_c_off"
        (( fail++ ))
    fi

    # Then each Pi-hole — network-side staleness
    for host in "${_pihole_hosts[@]}"; do
        printf '%s... ' "${host}.dropkick.design"
        if ssh "root@${host}.dropkick.design" "pihole restartdns --flush-caches" >/dev/null 2>&1; then
            printf '%s✓%s\n' "$_c_ok" "$_c_off"
            (( ok++ ))
        else
            printf '%s✗ FAILED%s (host down or SSH error)\n' "$_c_bad" "$_c_off"
            (( fail++ ))
        fi
    done

    # Summary
    if (( fail == 0 )); then
        printf '%sAll %d hosts flushed%s in %ds\n' "$_c_ok" "$ok" "$_c_off" "$(( SECONDS - start ))"
    else
        printf '%s%d/%d flushed, %d FAILED%s in %ds\n' \
            "$_c_ok" "$ok" "$(( ok + fail ))" "$_c_bad" "$fail" "$_c_off" "$(( SECONDS - start ))"
    fi

    # Optional verification
    target="${1:-}"
    if [[ -n "$target" ]]; then
        result=$(dig +short "$target" | head -1)
        if [[ -n "$result" ]]; then
            printf '%s→ %s resolves to %s\n' "$_c_ok" "$target" "$result"
        else
            printf '%s→ %s did NOT resolve — check pfSense Unbound override%s\n' "$_c_bad" "$target" "$_c_off"
        fi
    fi
}

# ──────────────────────────────────────────────────────────────────────

# update-piholes — Update OS + Pi-hole on all fleet hosts
#
# Runs on each Pi-hole host in sequence (cleo, brio, aldo), in this order:
#   1. dietpi-update (unattended) — DietPi OS + APT upgrades (DietPi
#      applies apt upgrades itself; a separate apt step is redundant)
#   2. pihole -up -y — Pi-hole core/web/FTL
#   3. reboot check — flags (or with -r, performs) sequential reboots
#
# Usage: update-piholes [-p] [-q] [-r]
#   -p  Pi-hole only (skip dietpi-update)
#   -q  quiet — only show failures and the summary
#   -r  reboot hosts that need it (sequentially, waits for each)

function update-piholes() {
    emulate -L zsh
    local host step fqdn rc skip_os=0 quiet=0 reboot=0
    local h_ok=0 h_fail=0 rebooted=0
    local start=$SECONDS
    _pihole-colors

    v()  { (( quiet )) || info "$*"; }
    vok(){ (( quiet )) || ok   "$*"; }

    while getopts ':pqr' opt; do
        case $opt in
            p) skip_os=1 ;;
            q) quiet=1 ;;
            r) reboot=1 ;;
            *) printf 'Usage: update-piholes [-p] [-q] [-r]\n'; return 1 ;;
        esac
    done
    shift $(( OPTIND - 1 ))

    (( skip_os )) && v "Pi-hole only (skip dietpi-update)"
    (( reboot ))  && v "Reboot mode: hosts needing it will reboot sequentially (safe: DHCP hands out all three DNS IPs)"
    ok "🚦 Let's update the Pi-hole fleet…"

    for host in "${_pihole_hosts[@]}"; do
        fqdn="${host}.dropkick.design"
        local host_failed=0 steps=2
        (( skip_os )) && steps=1

        info "── $fqdn ──────────────────────"
        (( quiet )) || info "Connecting to $fqdn…"
        if ! ssh -o ConnectTimeout=10 -o BatchMode=yes "root@$fqdn" 'hostname' >/dev/null 2>&1; then
            pihole-fail "$fqdn unreachable (host down or SSH error) — skipping"
            (( h_fail++ ))
            continue
        fi
        vok "$fqdn connected"

        if (( ! skip_os )); then
            # 1. DietPi update (unattended; bare "1" = check + apply
            #    noninteractively; full path — not in PATH over non-login
            #    ssh; includes apt upgrades; exit 0 when already up to
            #    date). Full output passthrough — failure reasons show
            #    inline instead of being swallowed.
            info "[1/$steps] 🥗 Starting DietPi update…"
            if ssh "root@$fqdn" '/boot/dietpi/dietpi-update 1'; then
                ok "DietPi update complete (OS + APT)"
            else
                pihole-fail "DietPi update failed on $fqdn (see output above)"
                (( host_failed++ ))
            fi
        fi

        # 2. Pi-hole core/web/FTL
        local n=1; (( skip_os )) || n=2
        info "[$n/$steps] 🕳️ Starting Pi-hole update (core/web/FTL)…"
        if ssh "root@$fqdn" 'pihole -up -y' >/dev/null 2>&1; then
            ok "Pi-hole update complete"
        else
            pihole-fail "pihole -up failed on $fqdn (run manually to see why)"
            (( host_failed++ ))
        fi

        # 3. Reboot check (DietPi/Debian touch this file when needed)
        if ssh "root@$fqdn" '[ -f /var/run/reboot-required ]'; then
            if (( reboot )); then
                info "⚠ reboot required — rebooting $fqdn (sequential, fleet redundancy covers it)…"
                ssh "root@$fqdn" 'reboot' >/dev/null 2>&1
                local i=0
                info "Waiting for $fqdn to come back…"
                until ssh -o ConnectTimeout=5 -o BatchMode=yes "root@$fqdn" \
                        'pihole status web' >/dev/null 2>&1; do
                    (( i++ ))
                    if (( i > 45 )); then
                        pihole-fail "$fqdn did not come back after ~90s — CHECK IT"
                        (( host_failed++ ))
                        break
                    fi
                    sleep 2
                done
                (( i <= 45 )) && ok "$fqdn back up (rebooted, DNS answering)"
                (( rebooted++ ))
            else
                printf '%s[REBOOT]%s %s needs a reboot — rerun with -r to reboot now%s\n' \
                    "$_c_bad" "$_c_off" "$fqdn" "$_c_dim"
            fi
        else
            vok "no reboot required"
        fi

        if (( host_failed )); then
            pihole-fail "── $fqdn: $host_failed step(s) FAILED ──"
            (( h_fail++ ))
        else
            vok "── $fqdn: all steps complete ──"
            (( h_ok++ ))
        fi
    done

    # Summary
    if (( h_fail == 0 )); then
        ok "💥 All $h_ok hosts updated${rebooted:+ (+$rebooted rebooted)} in $(( SECONDS - start ))s"
        v "Fleet parity: no-sync policy — all three updated together ✓"
    else
        printf '%s[FAIL]%s %d/%d hosts updated, %d FAILED in %ds\n' \
            "$_c_bad" "$_c_off" "$h_ok" "$(( h_ok + h_fail ))" "$h_fail" "$(( SECONDS - start ))"
    fi

    return $(( h_fail > 0 ))
}

# ──────────────────────────────────────────────────────────────────────

# disable-piholes — Temporarily disable ad blocking on all Pi-hole hosts
#
# Runs `pihole disable <duration>` on each fleet host (cleo, brio, aldo).
# All three must be disabled together — DHCP hands out all three DNS IPs,
# so any one still blocking keeps filtering most queries.
#
# Usage: disable-piholes [duration]
#   duration  passed straight to pihole (e.g. 30s, 5m, 2h); default 5m
#             no duration = 5 minutes (NOT permanent — that's `pihole
#             disable` with no arg on the host, deliberately avoided here)
#
# Examples:
#   disable-piholes          # all three off for 5 minutes
#   disable-piholes 15m      # all three off for 15 minutes
#   disable-piholes 30s      # quick 30-second off (stubborn page)
#
# Re-enable immediately: enable-piholes

function disable-piholes() {
    emulate -L zsh
    local dur="${1:-5m}"
    local host fqdn
    local h_ok=0 h_fail=0
    local start=$SECONDS
    _pihole-colors

    ok "🛑 Disabling ad blocking fleet-wide for ${dur}…"

    for host in "${_pihole_hosts[@]}"; do
        fqdn="${host}.dropkick.design"
        if ssh -o ConnectTimeout=10 -o BatchMode=yes "root@$fqdn" "pihole disable $dur" >/dev/null 2>&1; then
            ok "$fqdn blocking disabled ($dur)"
            (( h_ok++ ))
        else
            pihole-fail "$fqdn — disable failed (host down or SSH error)"
            (( h_fail++ ))
        fi
    done

    if (( h_fail == 0 )); then
        ok "💤 All $h_ok hosts disabled — auto re-enable in $dur"
        info "${_c_dim}Change your mind early? enable-piholes${_c_off}"
    else
        pihole-fail "$h_ok/$(( h_ok + h_fail )) disabled, $h_fail FAILED — blocking may be inconsistent"
    fi

    return $(( h_fail > 0 ))
}

# ──────────────────────────────────────────────────────────────────────

# enable-piholes — Re-enable ad blocking on all Pi-hole hosts immediately
function enable-piholes() {
    emulate -L zsh
    local host fqdn
    local h_ok=0 h_fail=0
    _pihole-colors

    ok "🟢 Re-enabling ad blocking fleet-wide…"

    for host in "${_pihole_hosts[@]}"; do
        fqdn="${host}.dropkick.design"
        if ssh -o ConnectTimeout=10 -o BatchMode=yes "root@$fqdn" 'pihole enable' >/dev/null 2>&1; then
            ok "$fqdn blocking enabled"
            (( h_ok++ ))
        else
            pihole-fail "$fqdn — enable failed"
            (( h_fail++ ))
        fi
    done

    (( h_fail == 0 )) && ok "🎯 All $h_ok hosts blocking again"
    return $(( h_fail > 0 ))
}
