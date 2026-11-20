---
name: Remember
description: How to handle "remember this" requests. Use when the user asks the bot to remember something, mentions facts or preferences to keep, or asks what was said before.
---

When the user asks to remember something, write it to `data/learnings.md` in the Bot folder.

If the `data/` folder or `learnings.md` file does not exist, create both first.

Prefer rewriting or pruning existing entries over appending new ones. Keep it to facts, preferences, and things the user explicitly asked to remember.

`data/learnings.md` is loaded at the start of every session, so entries there apply to every future chat. Do not write these requests to `AGENTS.md` sections.
