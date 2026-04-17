param(
  [Parameter(Mandatory = $true)]
  [string]$ProjectRoot
)

$ErrorActionPreference = 'Stop'

if (-not (Test-Path -LiteralPath $ProjectRoot)) {
  throw "Project root not found: $ProjectRoot"
}

$target = Join-Path $ProjectRoot 'AGENTS.md'
$content = @'
# Project Agent Entry

## Sources of truth
- Global durable rules: `E:\skills\.agents\AGENTS.md`
- Project current state: `.codex-memory/current.md`
- Project spec index: `.codex-memory/spec/index.md`
- Global project overlap map: `E:\skills\.agents\memory\global\projects\canonical-map.md`

## Session start
Read in this order:
1. `.codex-memory/current.md`
2. `.codex-memory/spec/index.md`
3. `E:\skills\.agents\memory\global\projects\canonical-map.md` when project overlap is possible
4. `.codex-memory/tasks/index.md` and the active task brief when needed

## Long-context rule
- Prefer file-based continuation over replaying old chat history.
- Write new facts and decisions into `.codex-memory/current.md`.
- When context grows too long, prefer a new conversation that starts from these files.
'@

Set-Content -LiteralPath $target -Value $content -Encoding UTF8
Write-Host "Wrote $target"
