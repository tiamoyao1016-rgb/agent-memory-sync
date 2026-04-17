# agent-memory-sync

Shared memory sync skill for multi-agent coding workflows in VS Code.

This skill is for teams or solo users who switch between Codex, Claude Code, Qwen Code, and similar agents, but do not want each agent to build its own fragmented memory.

## What problem it solves

Long tasks usually break down in three ways:

- context gets long and the model gets worse before the window is actually full
- users waste tokens on repeated compaction or repeated handoff prompts
- multiple agents create overlapping `.codex-memory` folders and nobody knows which one is canonical

`agent-memory-sync` fixes that by making files, not chat history, the source of truth.

## Core idea

Use a shared memory layout with four layers:

- global stable rules in `E:\skills\.agents\memory\global`
- shared skills in `E:\skills\.agents\skills`
- project-local active state in each repo's `.codex-memory`
- a canonical project map for overlapping or duplicated projects
- optional: a global resume index for projects you do not want to modify

The goal is simple:

- resume cheaply after closing VS Code
- reduce token waste
- allow `/clear` to become the default recovery path
- keep the model from "getting dumb" halfway through long work

## Who this is for

- users working on long-running coding tasks in VS Code
- users switching between Codex, Claude Code, and Qwen Code
- users with multiple project roots and duplicate project memories
- users who want low-friction resume instead of giant prompts

## Repository contents

- `SKILL.md`: main workflow and operating rules
- `agents/openai.yaml`: agent-facing metadata/config
- `scripts/inventory_memories.ps1`: scans project roots for `.codex-memory`
- `scripts/write_project_agent_entry.ps1`: writes minimal project entry instructions
- `references/status-model.md`: active/support/scaffold/archive classification model

## Recommended workflow

1. Scan all project roots for `.codex-memory` nodes.
2. Mark which memories are canonical, support-only, scaffold, archived, or delete-candidate.
3. Create or update the canonical map in global memory.
4. Keep each canonical project root self-bootstrapping with `AGENTS.md` plus a lean `.codex-memory`.
5. When context gets too long, write the latest facts into `current.md` and start a fresh chat instead of repeatedly compacting.

## One-line current.md (non-negotiable)

If you want token savings, `current.md` cannot be a running log.

Keep it as a single task-state line:

`任务:...; 下一步:...; 工作集:A,B,C`

Do not append multi-line reports, migration notes, lists, or Markdown links.

## Global resume index (no repo changes)

If you do not want to add `.codex-memory` into every project folder, use a single memory hub and store per-workspace task state in one file.

Index line format:

`<workspace-abs-path> | 任务:...; 下一步:...; 工作集:A,B,C | updated:YYYY-MM-DD`

This lets a new chat resume from the hub when the opened workspace has no `.codex-memory/current.md`.

If the index ever drifts into multiple lines per project, normalize it with `scripts/normalize_resume_index.ps1`.

## Design principles

- file memory first, chat history second
- canonical mapping before merging anything
- scaffold memories should be archived, not left in active trees
- resume should work after closing VS Code entirely
- users should not need to paste long restart prompts every time

## Why this instead of a heavy RAG stack

For local IDE agent work, a heavy `Memory Bank + RAG + multi-agent framework` is often the wrong first move.

The real bottleneck is usually not retrieval quality. It is memory drift, duplicated project state, and expensive restart behavior.

This skill optimizes the part that matters first:

- smaller active memory
- explicit current state
- deterministic restart path
- lower token burn

If your workflow later outgrows file memory, you can still layer retrieval on top. You do not need to start there.

## Quick start

1. Put this skill into your shared skills directory.
2. Run the inventory script against your project roots.
3. Build or refresh the canonical map for overlapping projects.
4. Trim each active project's `.codex-memory/current.md` down to facts, decisions, constraints, and current working set.
5. Test with a fresh chat and confirm the agent reads files first.

## Works well with

- Codex in VS Code
- Claude Code in VS Code
- Qwen Code in VS Code
- mixed-agent workflows where different agents touch the same codebase

## License

No license file has been added yet. If you want outside reuse, add one before treating this as an open-source template.
