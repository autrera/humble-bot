# Bot

A deliberately minimal personal assistant. It is a folder of files, not a service: no always-on conversation, no accounts, no runtime. Open a new chat for each topic and let the files carry the context.

## What is in here

- `AGENTS.md` - the instruction file your coding harness auto-loads. It asks the agent to load every file in `data/` at the start of a session.
- `data/` - your private state. Everything in it is gitignored except `.gitkeep`.
  - `SOUL.md` - who the assistant is: identity, tone, how to address you, rules. Name it whatever you like; every file in this folder is loaded at session start.
  - `MEMORY.md` - working memory exported by `mind.py`. Auto-generated; do not edit by hand.
  - Add or split other files here as you wish.
- `mind.py` - offline memory tool (MIT, Da7-Tech/mind), modified to export only to `data/MEMORY.md`. Its graph lives in `.mind/`, which is gitignored.
- `.agents/skills/` - your personal skills folder. Empty by default (only `.gitkeep` is tracked); add custom skills here for your assistant.
- `.claude/skills` and `.opencode/skills` - links to `.agents/skills` so both harnesses discover the same skills. One source of truth.
- `.gitignore` - ignores `data/*` (except `.gitkeep`), `.mind`, and your personal skills in `.agents/skills/*` (except `.gitkeep`).

## Setup

1. Clone the repo. Use the `Bot` folder as the working directory of your coding harness (T3 Code / OpenCode, Claude Code, etc.).
2. Create `data/SOUL.md`, or any other filename you prefer, and describe the assistant you want. Every file you put in `data/` is loaded at session start, so the names and split are up to you.
3. Run:

   ```
   python mind.py init
   ```

   On Windows, `py -3 mind.py init` also works. This creates `.mind/` and writes `data/MEMORY.md`. It does not create `AGENTS.md`, `CLAUDE.md` or `GEMINI.md`.
4. Start a new chat in this folder. `AGENTS.md` loads your data files and any skills in `.agents/skills/` are discovered automatically.

That is it.

## Day to day

- **Talking**: open a new session per question. There is no continuous conversation to maintain.
- **Memory**: `mind.py` keeps a weighted graph in `.mind/` and exports the hot facts into `data/MEMORY.md`, which your agent reads at session start. Useful commands, run from this folder:
  - `python mind.py remember "the fact"`
  - `python mind.py recall "the question"`
  - `python mind.py dream` and `python mind.py status`
- **Skills**: customize your bot by creating the skills you need inside `.agents/skills/` (each skill lives in its own subfolder with a `SKILL.md`). You can just ask your LLM to build a skill for you whenever a workflow comes up - everything inside `.agents/skills/` (except `.gitkeep`) is ignored by git so your personal skills and scripts stay private.

  Some ideas to get started:
  - **Daily briefing**: summarize today's notes, open tasks, or calendar items at the start of a chat.
  - **Habit or journal check-in**: prompt you with reflection questions and append entries to `data/`.
  - **Bookmark / reading inbox**: save links, summarize articles, and tag topics into your memory graph.
  - **Finances or expense log**: parse receipts or quick expense notes into a local CSV or markdown ledger.
  - **Workout or meal tracker**: log sessions and look up trends from files in `data/`.
  - **Project / repo helper**: automate status checks, release checklists, or weekly wrap-ups for your projects.

## Windows and Linux

On Windows, `.claude/skills` and `.opencode/skills` are directory junctions to `.agents/skills`. After cloning on another machine, link them to `.agents/skills` if you use Claude Code or OpenCode and want a single source of truth:

```bash
# Linux / macOS
ln -s ../.agents/skills .claude/skills
ln -s ../.agents/skills .opencode/skills
```

```cmd
:: Windows
mklink /J .claude\skills .agents\skills
mklink /J .opencode\skills .agents\skills
```
