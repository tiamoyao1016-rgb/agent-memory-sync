param(
  [string[]]$Roots = @(
    'E:\claude code-project',
    'E:\codex project',
    'E:\qwen project'
  )
)

$ErrorActionPreference = 'Stop'

$rows = New-Object System.Collections.Generic.List[object]

foreach ($root in $Roots) {
  if (-not (Test-Path -LiteralPath $root)) { continue }

  Get-ChildItem -LiteralPath $root -Recurse -Directory -Force -ErrorAction SilentlyContinue |
    Where-Object { $_.Name -eq '.codex-memory' } |
    ForEach-Object {
      $current = Join-Path $_.FullName 'current.md'
      $currentExists = Test-Path -LiteralPath $current
      $lastWrite = $null
      $currentLength = $null

      if ($currentExists) {
        $item = Get-Item -LiteralPath $current
        $lastWrite = $item.LastWriteTime
        $currentLength = $item.Length
      }

      $rows.Add([pscustomobject]@{
        Root          = $root
        MemoryPath    = $_.FullName
        CurrentExists = $currentExists
        CurrentLength = $currentLength
        CurrentWrite  = $lastWrite
      })
    }
}

$rows |
  Sort-Object CurrentWrite -Descending |
  Format-Table -AutoSize

