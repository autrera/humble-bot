---
name: Remember
description: How to handle "remember this" requests. Use when the user asks the bot to remember something, mentions facts or preferences to keep, or asks what was said before.
---

When the user asks to remember something, add it to `AGENTS.md` in the Bot folder:

- Facts, preferences, habits, and things said about a project -> the `Memory` section (prefix the entry with the date if it matters when it was learned).
- Who the user is and how they like answers -> the `About me` section.
- Rules for how to answer or behave -> the `Rules` section.
- Project or topic specifics -> the `Project notes` section or a new section for that topic.

Keep entries short, one line each, no fluff. The file is read at the start of every new session, so entries there apply to every future chat; you can edit it anytime.
