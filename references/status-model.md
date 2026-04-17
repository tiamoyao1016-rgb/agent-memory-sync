# Status Model

Use these labels consistently in the global project index.

## active
- The primary memory for a live project or product line.
- Use for implementation status and current direction.

## active-support
- A secondary memory that still adds unique value.
- Typical use: review, audit, acceptance, or handoff memory tied to the active project.

## archived
- A completed or paused project memory that is still useful for reference.
- Keep searchable, but do not use as default context.

## archived-reference
- A meta project, bootstrap example, or rules project worth keeping for reference only.

## scaffold
- A mostly empty bootstrap memory.
- Not useful as active context.

## scaffold-duplicate
- A scaffold that overlaps with a stronger canonical project memory.
- Keep out of active project trees when possible.

## delete-candidate
- Temporary or clearly disposable residue.
- Only delete after explicit confirmation or after moving to archive if reversibility matters.

## Overlap Resolution

When two or more memories describe the same product line:
- choose one canonical project memory for implementation truth
- keep one supporting review memory only if it contains unique decisions or acceptance logic
- archive or move every empty scaffold out of the active tree

## Encoding Rule

Before trusting a memory file:
- check whether the content is actually readable
- if `current.md` is garbled but nearby task files are clean, rewrite the summary from the clean sources instead of doing blind encoding conversion

