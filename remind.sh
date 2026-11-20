#!/usr/bin/env bash
dir="$(cd "$(dirname "$0")" && pwd)"
rem="$dir/reminders"
mkdir -p "$rem"

if [ $# -lt 2 ]; then
    echo "usage: remind.sh \"2026-11-21 09:00\" \"message\"" >&2
    exit 1
fi

fire=$(date -d "$1" +%s) || fire=""
if [ -z "$fire" ] || [ "$fire" -le "$(date +%s)" ]; then
    echo "Use a future time, e.g. \"2026-11-21 09:00\" or \"09:00\"." >&2
    exit 1
fi

slug=$(printf '%s' "$2" | tr ' ' '-' | tr -cd '[:alnum:]-')
[ -n "$slug" ] || slug="note"
slug="${slug:0:40}"

file="$rem/$(date -d @"$fire" +%Y%m%d%H%M)_${slug}.txt"
printf '%s' "$2" > "$file"
echo "Reminder set: $2 for $(date -d @"$fire" '+%Y-%m-%d %H:%M') -> $file"

if ! crontab -l 2>/dev/null | grep -q 'check-notify.sh'; then
    ( crontab -l 2>/dev/null; echo "* * * * * bash $dir/check-notify.sh" ) | crontab -
    echo "Added the once-a-minute cron entry for check-notify.sh."
fi
