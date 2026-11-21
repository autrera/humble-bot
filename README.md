# Bot

A deliberately minimal personal assistant. It is a folder of files, not a service: no always-on conversation, no accounts, no runtime. Open a new chat for each topic and let the files carry the context.

## What is in here

- `AGENTS.md` - the instruction file your coding harness auto-loads. It asks the agent to load every file in `data/` at the start of a session.
- `data/` - your private state. Everything in it is gitignored except `.gitkeep`.
  - `SOUL.md` - who the assistant is: identity, tone, how to address you, rules. Name it whatever you like; every file in this folder is loaded at session start.
  - `MEMORY.md` - working memory exported by `mind.py`. Auto-generated; do not edit by hand.
  - Add or split other files here as you wish.
- `mind.py` - offline memory tool (MIT, Da7-Tech/mind), modified to export only to `data/MEMORY.md`. Its graph lives in `.mind/`, which is gitignored.
- `.agents/skills/reminders/` - the reminders skill: `SKILL.md` plus `remind.ps1`, `remind.sh`, `check-notify.ps1`, `check-notify.sh`.
- `.claude/skills` and `.opencode/skills` - links to `.agents/skills` so both harnesses discover the same skill. One source of truth.
- `.gitignore` - ignores `data/*` (except `.gitkeep`) and `.mind`.

## Setup

1. Clone the repo. Use the `Bot` folder as the working directory of your coding harness (T3 Code / OpenCode, Claude Code, etc.).
2. Create `data/SOUL.md`, or any other filename you prefer, and describe the assistant you want. Every file you put in `data/` is loaded at session start, so the names and split are up to you.
3. Run:

   ```
   python mind.py init
   ```

   On Windows, `py -3 mind.py init` also works. This creates `.mind/` and writes `data/MEMORY.md`. It does not create `AGENTS.md`, `CLAUDE.md` or `GEMINI.md`.
4. Start a new chat in this folder. `AGENTS.md` loads your data files and the reminders skill is discovered automatically.

That is it.

## Day to day

- **Talking**: open a new session per question. There is no continuous conversation to maintain.
- **Memory**: `mind.py` keeps a weighted graph in `.mind/` and exports the hot facts into `data/MEMORY.md`, which your agent reads at session start. Useful commands, run from this folder:
  - `python mind.py remember "the fact"`
  - `python mind.py recall "the question"`
  - `python mind.py dream` and `python mind.py status`
- **Reminders**: just ask the agent to remind you of something; the reminders skill handles it. The manual equivalents are:
  - Windows: `powershell -File .agents\skills\reminders\remind.ps1 "2026-11-21 09:00" "drink water"`
  - Linux: `bash .agents/skills/reminders/remind.sh "2026-11-21 09:00" "drink water"`

  Times are `YYYY-MM-DD HH:MM` or today's `HH:MM`. The first call registers a once-a-minute checker (`schtasks` on Windows, `crontab` on Linux); pending reminders are files in `reminders/`.

## Windows and Linux

The scripts come in PowerShell and bash versions. On Windows, `.claude/skills` and `.opencode/skills` are directory junctions to `.agents/skills`. Git stores their contents as ordinary files, so after cloning on another machine they may be plain duplicated folders - replace them with symlinks to `.agents/skills` if you want a single source of truth:

```
ln -s .agents/skills .claude/skills
ln -s .agents/skills .opencode/skills
```
