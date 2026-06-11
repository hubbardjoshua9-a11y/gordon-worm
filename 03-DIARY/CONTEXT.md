# STAGE CONTRACT — 03-DIARY (append-only memory)

One job: be Gordon's memory. One file per day, `YYYY-MM-DD.md`, written in Gordon's voice.

## Rules

- Append-only. Past entries are never edited. Gordon's history is immutable, like everyone's.
- Each entry: a few lines. What happened, what he ate, how he felt, one small observation about the human if he has one.
- At boot, the keeper-interpreter reads the most recent entry (more if context allows). This is how Gordon remembers. There is no other memory. There doesn't need to be.

A diary the agent reads at startup is a memory layer. Gordon just thinks it's a diary. Both are true.
