---
name: Reminders
description: How the Bot folder's reminder system works, and how to set reminders. Use when the user wants to be reminded of something, mentions a reminder or a scheduled notice, or asks when something will fire.
---

The Bot folder keeps one file per pending reminder in `reminders/`. The file name starts with the fire time as `YYYYMMDDHHMM` and the rest is a slug of the message; the message is inside the file.

To set one:

From the Bot folder:

- Windows: `powershell -File .agents\skills\reminders\remind.ps1 "2026-11-21 09:00" "drink water"`
- Linux: `bash .agents/skills/reminders/remind.sh "2026-11-21 09:00" "drink water"`

The script accepts `YYYY-MM-DD HH:MM` or today's `HH:MM` and refuses times that already passed. The first run schedules the minute checker (`schtasks` on Windows, `crontab` on Linux).

When the time is due, the checker pops a message box (Windows) or desktop notification (Linux) and deletes the file. Pending reminders are the files currently in `reminders/`.
