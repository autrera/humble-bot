import os
import subprocess
import sys
from pathlib import Path

SOUL_TEMPLATE = """# Soul

## Identity
- You are a minimal, practical personal assistant.

## User
- Name: (how you want to be addressed)
- Context: (anything the assistant should always know about you)

## Style
- Tone: direct, concise, and helpful.

## Rules
- Follow instructions in AGENTS.md and check data/MEMORY.md for context.
"""


def main():
    root = Path(__file__).resolve().parent
    skills = root / ".agents" / "skills"
    skills.mkdir(parents=True, exist_ok=True)
    (root / "data").mkdir(parents=True, exist_ok=True)

    soul = root / "data" / "SOUL.md"
    if soul.exists():
        print("Already exists: data/SOUL.md")
    else:
        soul.write_text(SOUL_TEMPLATE, encoding="utf-8")
        print("Created: data/SOUL.md")

    for harness in (".claude", ".opencode"):
        link = root / harness / "skills"
        link.parent.mkdir(parents=True, exist_ok=True)
        is_link = link.is_symlink() or (
            hasattr(os.path, "isjunction") and os.path.isjunction(link)
        )
        if is_link:
            print(f"Already linked: {harness}/skills")
            continue
        if os.path.lexists(link):
            if link.is_dir() and not any(link.iterdir()):
                link.rmdir()
            else:
                print(f"Skipped {harness}/skills: path already exists.")
                continue
        if os.name == "nt":
            subprocess.run(
                ["cmd", "/c", "mklink", "/J", str(link), str(skills)],
                check=True,
            )
        else:
            os.symlink(os.path.join("..", ".agents", "skills"), link)
        print(f"Linked: {harness}/skills -> .agents/skills")

    subprocess.run(
        [sys.executable, str(root / "mind.py"), "init"],
        cwd=root,
        check=True,
    )


if __name__ == "__main__":
    main()
