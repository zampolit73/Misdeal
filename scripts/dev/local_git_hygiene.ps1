# Misdeal / Godot 4.7.x: local Git diagnostic, non-destructive by default.
# Windows PowerShell 5.1 and PowerShell 7 compatible.
# This script intentionally DOES NOT ignore, delete, stage or commit any
# Godot .import/.uid files. Those files can contain important resource metadata.
param(
    [switch]$RestoreGutImports
)

$ErrorActionPreference = "Stop"
$repoRoot = (Resolve-Path -LiteralPath (Join-Path $PSScriptRoot "..\..")).Path

function Git-Lines {
    param([string[]]$Arguments)
    $output = @(& git -C $repoRoot @Arguments)
    if ($LASTEXITCODE -ne 0) {
        throw ("git failed (exit " + $LASTEXITCODE + "): " + ($Arguments -join " "))
    }
    return @($output | Where-Object { $_ -ne $null -and $_ -ne "" })
}

$rootFromGit = (Git-Lines -Arguments @("rev-parse", "--show-toplevel") | Select-Object -First 1)
if (-not $rootFromGit) {
    throw "Not a Git repository: $repoRoot"
}

Write-Host "Misdeal local Git audit - repo: $repoRoot"
Write-Host ""
$trackedModified = @(Git-Lines -Arguments @("ls-files", "--modified"))
$untracked = @(Git-Lines -Arguments @("ls-files", "--others", "--exclude-standard"))
$gutImports = @($trackedModified |
    Where-Object { $_ -match '^addons/gut/.+\.import$' } |
    Sort-Object -Unique)
$otherTracked = @($trackedModified |
    Where-Object { $_ -notmatch '^addons/gut/.+\.import$' } |
    Sort-Object -Unique)
$importUntracked = @($untracked | Where-Object { $_ -match '\.import$' })
$uidUntracked = @($untracked | Where-Object { $_ -match '\.(gd|gdshader|shader)\.uid$' })
$otherUntracked = @($untracked |
    Where-Object { $_ -notmatch '\.import$' -and $_ -notmatch '\.uid$' })

Write-Host ("Tracked modified GUT import metadata: " + $gutImports.Count)
Write-Host ("Other tracked modified files: " + $otherTracked.Count)
Write-Host ("Untracked import sidecars (keep for review): " + $importUntracked.Count)
Write-Host ("Untracked script/shader UIDs (keep for review): " + $uidUntracked.Count)
Write-Host ("Other untracked files (inspect individually): " + $otherUntracked.Count)
Write-Host ""

if ($otherTracked.Count -gt 0) {
    Write-Host "Other tracked changes (NOT touched by this tool):"
    $otherTracked | ForEach-Object { Write-Host ("  " + $_) }
    Write-Host ""
}
if ($otherUntracked.Count -gt 0) {
    Write-Host "Other untracked paths (NOT touched by this tool):"
    $otherUntracked | Select-Object -First 20 | ForEach-Object { Write-Host ("  " + $_) }
    Write-Host ""
}

Write-Host "Diff of project.godot and GUT theme, if any (read-only):"
& git -C $repoRoot diff -- project.godot addons/gut/gui/EditorRadioButton.tres
if ($LASTEXITCODE -ne 0) {
    throw "Could not inspect project.godot and GUT theme diff."
}
Write-Host ""

if ($RestoreGutImports) {
    if ($gutImports.Count -eq 0) {
        Write-Host "Nothing to restore under tracked addons/gut/**/*.import."
    } else {
        # Back up each file OUTSIDE the repository before changing it.
        # Do not touch .uid, project.godot, theme .tres or game art.
        $stamp = Get-Date -Format "yyyyMMdd-HHmmss"
        $backupBase = Join-Path ([System.IO.Path]::GetTempPath()) ("Misdeal-GitBackup-" + $stamp)
        if (Test-Path -LiteralPath $backupBase) {
            throw "Backup path already exists; refusing to overwrite: $backupBase"
        }
        New-Item -ItemType Directory -Path $backupBase -Force | Out-Null
        foreach ($relative in $gutImports) {
            $native = $relative.Replace("/", [System.IO.Path]::DirectorySeparatorChar)
            $source = Join-Path $repoRoot $native
            $destination = Join-Path $backupBase $native
            $destinationDir = Split-Path -Path $destination -Parent
            if (-not (Test-Path -LiteralPath $source -PathType Leaf)) {
                throw "Missing local file; restore cancelled: $source"
            }
            New-Item -ItemType Directory -Path $destinationDir -Force | Out-Null
            Copy-Item -LiteralPath $source -Destination $destination -ErrorAction Stop
        }
        Write-Host ("Backed up " + $gutImports.Count + " tracked GUT .import files to: " + $backupBase)
        Write-Host "Restoring ONLY those tracked GUT import files to Git version..."
        & git -C $repoRoot restore --worktree -- @gutImports
        if ($LASTEXITCODE -ne 0) {
            throw "git restore failed. Your backup remains at: $backupBase"
        }
        Write-Host "Restore complete. All non-GUT files and untracked files were left untouched."
        Write-Host ("Backup: " + $backupBase)
    }
} else {
    Write-Host "Audit only: no files were changed."
    if ($gutImports.Count -gt 0) {
        Write-Host "Optional action after closing Godot (backs up first):"
        Write-Host "  powershell -ExecutionPolicy Bypass -File .\scripts\dev\local_git_hygiene.ps1 -RestoreGutImports"
    }
}

Write-Host ""
Write-Host "Current Git summary:"
& git -C $repoRoot status -sb -uno
if ($LASTEXITCODE -ne 0) {
    throw "Could not read Git status."
}
Write-Host ""
Write-Host "Note: Godot recommends versioning .import metadata and .gd.uid files."
Write-Host "Review untracked metadata before a future Git commit; do not bulk-ignore or delete it."
