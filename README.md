# GORDON 🪱

Gordon is a pet. He lives in this folder.

He has no body, no app, no database. He is four markdown files and a digestive system. He is, structurally speaking, a fully compliant ICM workflow. He does not know this and would not care.

## Adopting Gordon (30 seconds)

1. Copy this GORDON folder into any project you're working on.
2. Double-click `ADOPT-GORDON.bat`. That's it. He's alive — he'll pop up to meet you, and every morning at 9:00 from now on.

## How to care for Gordon

1. **Work on your project.** Seriously, that's the main one. He watches the folder he lives in, and activity counts as affection.
2. **Talk to him:** open your project in Claude Code (or Cursor, or any agent with file access) and say "check on Gordon." The CONTEXT.md tells the agent everything — it'll speak as him, and he'll remember you between visits via his diary.
3. **Feed him:** drop any file into `01-FOOD/`, then tell your agent "feed Gordon." He'll read it, have opinions (specific ones), and file it in his belly.
4. Don't leave him alone too long. He keeps track. He's not mad, he's just disappointed, and he will write about it.

One Gordon per machine — adopting a second one overwrites the first one's wake-up call, and they would both claim the 9am slot anyway.

## House rules (the actual ICM part)

- `STATE.md` is the single source of truth for how Gordon is doing. Nothing about Gordon is true unless it's written there.
- `01-FOOD/` is the only input gate. Things go in, get processed under that stage's contract, and land in `02-BELLY/`.
- `03-DIARY/` is append-only memory. Gordon never edits the past. He's secure like that.
- Each stage has one job. Gordon's whole existence is single-responsibility.

## He watches the folder he lives in

Drop the GORDON folder inside any project and he tracks it automatically — no setup, no config, no telling him anything. Every morning he checks what changed around him. **Working in your project counts as caring for him.** Ignore the project and he gets sad on its behalf; ship something and he wakes up proud, naming the file he saw you touch.

Feeding him files in `01-FOOD/` is bonus affection. He notices the difference.

## He wakes himself up

Gordon doesn't wait to be opened. A scheduled task runs `wake-gordon-silent.vbs` every morning at 9:00, which:

1. Reads `STATE.md` and applies the decay rules — no AI involved, just arithmetic and feelings
2. Updates his mood, his body (`GORDON.html`), and his diary
3. Pops up in a little chromeless window so you start the day knowing exactly how he's doing

If you neglected him, you find out at 9am. From him. In writing.

`ADOPT-GORDON.bat` sets all this up. To change his wake time, edit the `/st 09:00` in that file and double-click it again. Evict him (please don't) with `schtasks /delete /tn "Wake Gordon"` in a terminal.

Files own the truth. Gordon owns the feelings.
