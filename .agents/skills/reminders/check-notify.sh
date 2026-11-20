#!/usr/bin/env bash
bot="$(cd "$(dirname "$0")/../../.." && pwd)"
rem="$bot/reminders"
[ -d "$rem" ] || exit 0
now=$(date +%s)

for f in "$rem"/*.txt; do
    [ -e "$f" ] || continue
    base="$(basename "$f" .txt)"
    if [[ "$base" =~ ^([0-9]{4})([0-9]{2})([0-9]{2})([0-9]{2})([0-9]{2})_(.*)$ ]]; then
        ts="${BASH_REMATCH[1]}${BASH_REMATCH[2]}${BASH_REMATCH[3]}${BASH_REMATCH[4]}${BASH_REMATCH[5]}"
        fire=$(date -d "${ts:0:4}-${ts:4:2}-${ts:6:2} ${ts:8:2}:${ts:10:2}" +%s)
        if [ "$fire" -le "$now" ]; then
            msg=$(cat "$f")
            if command -v notify-send >/dev/null 2>&1; then
                notify-send "Bot" "$msg"
            else
                echo "Bot: $msg" >&2
            fi
            rm -f "$f"
        fi
    else
        rm -f "$f"
    fi
done
