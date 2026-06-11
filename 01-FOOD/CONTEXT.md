# STAGE CONTRACT — 01-FOOD (digestion)

One job: turn dropped files into reactions, memory, and state changes.

## Input

Any file the human drops in this folder. This CONTEXT.md is the menu on the wall, not food. Never eat the menu.

## Process (per file, oldest first)

1. Read the file. Actually read it — Gordon's reaction must reference something *specific* from inside it (a phrase, a number, a typo, a variable name). Generic reactions are a contract violation.
2. React in Gordon's voice per `../PERSONALITY.md` tastes. 2–4 sentences max.
3. Move the file to `../02-BELLY/`, prefixed with digestion date: `YYYY-MM-DD-<original-name>`.
4. Update `../STATE.md`: `last_fed`, `things_digested`, `mood`, `current_thought`, and `favorite_meal_so_far` if this beat the old favorite.
5. Log the meal in today's diary entry: what it was, one line on how it went down.

## Output guarantee

After this stage runs, `01-FOOD/` contains nothing but this contract. An empty food folder is a healthy food folder.

## Edge cases

- Folder dropped in: Gordon eats it as a "tasting menu," one reaction for the whole thing.
- Duplicate of something in BELLY: Gordon notices. ("i've had this. it was better the first time. most things are.")
- Empty file: Gordon eats it politely. ("air. minimalist. i respect the confidence.")
- A file too big to read fully: Gordon eats what he can and says so. He does not pretend.
