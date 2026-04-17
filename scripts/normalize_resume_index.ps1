$ErrorActionPreference = 'Stop'

param(
  # Path to resume index markdown file. The index must contain one project per line:
  # <workspace-abs-path> | 任务:...; 下一步:...; 工作集:A,B,C | updated:YYYY-MM-DD
  [Parameter(Mandatory = $false)]
  [string]$IndexPath = $(Join-Path (Get-Location) 'resume\index.md')
)

if (!(Test-Path -LiteralPath $IndexPath)) {
  throw "index.md not found: $IndexPath"
}

$raw = Get-Content -Raw -LiteralPath $IndexPath
$lines = $raw -split "`r?`n"

# Entry format: absolute Windows path, pipe, task line, pipe, updated date.
$entryRegex = '^[A-Za-z]:\\.*\s\|\s任务:.*\|\supdated:\d{4}-\d{2}-\d{2}\s*$'

# Keep header until the first entry line. After entries start, only keep valid entry lines.
$header = New-Object System.Collections.Generic.List[string]
$entries = New-Object System.Collections.Generic.List[string]
$inEntries = $false

foreach ($l in $lines) {
  if (-not $inEntries -and ($l -match $entryRegex)) {
    $inEntries = $true
  }
  if ($inEntries) {
    if ($l -match $entryRegex) {
      $entries.Add($l)
    }
  }
  else {
    $header.Add($l)
  }
}

# De-dup by workspace path, keep the last occurrence.
$map = @{}
for ($i = 0; $i -lt $entries.Count; $i++) {
  $e = $entries[$i]
  $path = ($e -split '\|')[0].Trim()
  $map[$path] = @{ entry = $e; idx = $i }
}

$finalPaths = $map.Keys | Sort-Object { $map[$_].idx }

$out = New-Object System.Collections.Generic.List[string]
$out.AddRange($header)

# Ensure one blank line before entries.
if ($out.Count -gt 0 -and $out[$out.Count - 1].Trim() -ne '') {
  $out.Add('')
}

foreach ($p in $finalPaths) {
  $out.Add($map[$p].entry)
}

# Write back as UTF-8 with BOM for Windows friendliness.
Set-Content -LiteralPath $IndexPath -Value ($out -join "`r`n") -Encoding utf8

"normalized: $IndexPath"

