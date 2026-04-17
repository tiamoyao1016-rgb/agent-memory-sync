---
name: agent-memory-sync
description: Unify shared memory across Codex, Claude Code, Qwen Code, and similar VS Code agents. Use when setting up or maintaining `.codex-memory` across multiple project roots, defining canonical project mappings, cleaning scaffold memories, reducing token cost for restart/resume flows, or aligning multiple coding agents to one shared memory strategy.
---

# Agent Memory Sync

Use this skill to keep multiple coding agents on one memory system instead of letting each workspace drift.

## Core Outcome

Produce and maintain these layers:
- Global stable rules in `E:\skills\.agents\memory\global`
- Shared skills in `E:\skills\.agents\skills`
- Project-local active state in each repo's `.codex-memory`
- A canonical project map for overlapping projects

Do not treat full chat history as the source of truth.

## Workflow

### 1. Inventory memory nodes

Scan the relevant project roots for `.codex-memory` directories before changing anything.

Use `scripts/inventory_memories.ps1` when the user has multiple roots such as:
- `E:\claude code-project`
- `E:\codex project`
- `E:\qwen project`

Record for each memory node:
- path
- last update
- whether `current.md` is real content or scaffold
- whether it is active, support, archived, scaffold, or delete-candidate

### 2. Resolve overlap with a canonical map

When the same product line appears in multiple roots, do not merge blindly.

Create or update:
- `E:\skills\.agents\memory\global\projects\index.md`
- `E:\skills\.agents\memory\global\projects\canonical-map.md`

Rules:
- Keep one canonical project memory for implementation status
- Keep supporting review memory only when it adds unique audit or acceptance value
- Mark empty or duplicate scaffold memories explicitly instead of pretending they are active

Read `references/status-model.md` for the recommended status model and overlap rules.

### 3. Make every canonical project self-bootstrapping

Each canonical project root should contain:
- `AGENTS.md`
- `.codex-memory/current.md`
- `.codex-memory/spec/index.md`

The project `AGENTS.md` should tell new sessions to read project memory first, then canonical map when overlap is possible.

Use `scripts/write_project_agent_entry.ps1` to create or refresh a minimal project entry file.

### 4. Keep restart and resume cheap

Optimize for closing VS Code and resuming later with minimal tokens.

Do:
- store only current facts, decisions, constraints, and working-set cues in `.codex-memory/current.md`
- keep project specs stable and small
- prefer new conversations from files over replaying long chats

Do not:
- rely on repeated compaction as the main strategy
- keep scaffold memories inside active project trees
- ask the user to restate long handoff prompts by default

### 5. Clean scaffold memory safely

Scaffold memories should not stay in active project trees once classified.

Preferred pattern:
- move them into a shared archive bucket such as `E:\skills\.agents\memory\global\archive\project-scaffolds`
- update the global project index so agents know the new archived location
- only delete after the user explicitly wants irreversible cleanup

### 6. Support multiple IDE agents

This method works best when each active project root has the same entry pattern.

For VS Code agents such as Codex and Claude Code:
- prefer the extension/plugin runtime when it already bundles its own binary
- do not assume a global npm CLI is required
- verify the extension still reads `AGENTS.md` and `.codex-memory` from the opened workspace

## Validation

After setup, test with a fresh session:
1. Open the canonical project root in VS Code.
2. Start a new conversation.
3. Ask which project is canonical, which memory files were read, and what the current task line is.
4. Confirm the agent does not choose scaffold or duplicate memories as the primary source.

If a fresh session still asks the user to restate the project history, the memory entry files are not lean or explicit enough.

## Resources

### scripts/inventory_memories.ps1
Scan project roots for `.codex-memory` nodes and summarize current-state file timestamps.

### scripts/write_project_agent_entry.ps1
Write a minimal `AGENTS.md` for canonical project roots so fresh sessions start from files, not chat history.

### references/status-model.md
Read when deciding active vs support vs scaffold vs archived memory states.
