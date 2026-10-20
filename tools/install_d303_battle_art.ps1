# Installs exactly the five user-approved Battle DS3 module assets.
# Run from any directory, after downloading Misdeal_D303_Godot_final_art_bundle.zip:
# powershell -ExecutionPolicy Bypass -File .\tools\install_d303_battle_art.ps1 -Publish
# -Publish commits only these five imported images and the manifest, then pushes
# them to main. Other local user files and editor settings are never staged.
[CmdletBinding()]
param(
    [string]$ArchivePath = "",
    [switch]$Publish
)
Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

$project = (Resolve-Path (Join-Path $PSScriptRoot "..")).Path
if (-not (Test-Path (Join-Path $project "project.godot"))) {
    throw "This installer must live inside the Misdeal Godot repository."
}
$expected = [ordered]@{
    "command_game.webp" = "dedee26e488bd75ecbda28014dd62cc16cb9212e8d023613f330d6c4a66dcc47"
    "fight_panel_game.webp" = "343f85ec4af6088f51112cf152b6538162d625dee887b6b78413fe1764cf041c"
    "idle_game.webp" = "d9a08beb75a645134c114b4a7362721ecbf824fd1c65d359a1c12da2263d46a9"
    "selected_game.webp" = "991635cdbb1de565f48f4b9a9bcf9bf6ad5262064361e9c07d480f21a1e206db"
    "fight_button_game.webp" = "bdccdd7d0730b9e8cce312de6eb5d754c548aa2c9d186d0b0363ea8ab0d3d4c6"
}
$archiveName = "Misdeal_D303_Godot_final_art_bundle.zip"
if ([string]::IsNullOrWhiteSpace($ArchivePath)) {
    $downloads = Join-Path $env:USERPROFILE "Downloads"
    $possibles = @(
        (Join-Path $downloads $archiveName),
        (Join-Path $project $archiveName),
        (Join-Path (Get-Location).Path $archiveName),
        (Join-Path $env:USERPROFILE "Desktop\$archiveName")
    )
    foreach ($candidate in $possibles) {
        if (Test-Path $candidate) { $ArchivePath = $candidate; break }
    }
}
if (-not (Test-Path $ArchivePath -PathType Leaf)) {
    throw "Cannot locate $archiveName. Download the archive from the ChatGPT D304 message to Downloads, or pass -ArchivePath 'C:\path\$archiveName'."
}
$ArchivePath = (Resolve-Path $ArchivePath).Path
$destination = Join-Path $project "assets\pixel\ui\battle_ds3_d303"
$tmp = Join-Path ([System.IO.Path]::GetTempPath()) ("misdeal-d303-" + [guid]::NewGuid().ToString("N"))
New-Item -ItemType Directory -Path $tmp -Force | Out-Null
try {
    Expand-Archive -LiteralPath $ArchivePath -DestinationPath $tmp -Force
    # Verify *every* original derived asset before copying anything.
    foreach ($asset in $expected.Keys) {
        $source = Join-Path $tmp $asset
        if (-not (Test-Path $source -PathType Leaf)) { throw "D304 asset missing: $asset" }
        $actual = (Get-FileHash -LiteralPath $source -Algorithm SHA256).Hash.ToLowerInvariant()
        if ($actual -ne $expected[$asset]) {
            throw "D304 asset corrupted or replaced: $asset (SHA256 mismatch)"
        }
    }
    New-Item -ItemType Directory -Path $destination -Force | Out-Null
    foreach ($asset in $expected.Keys) {
        Copy-Item -LiteralPath (Join-Path $tmp $asset) -Destination (Join-Path $destination $asset) -Force
    }
    Copy-Item -LiteralPath (Join-Path $tmp "manifest.json") -Destination (Join-Path $destination "manifest.json") -Force
    Write-Host "D304 OK: five approved painted modules installed in $destination" -ForegroundColor Green
    if ($Publish) {
        Push-Location $project
        try {
            $branch = (& git branch --show-current).Trim()
            if ($LASTEXITCODE -ne 0 -or $branch -ne "main") {
                throw "Publish requires the checked-out main branch. Current branch: $branch"
            }
            $files = @()
            foreach ($asset in $expected.Keys) {
                $files += "assets/pixel/ui/battle_ds3_d303/$asset"
            }
            $files += "assets/pixel/ui/battle_ds3_d303/manifest.json"
            & git add -- $files
            if ($LASTEXITCODE -ne 0) { throw "git add failed" }
            & git diff --cached --quiet -- $files
            if ($LASTEXITCODE -eq 0) {
                Write-Host "D304: artwork was already committed. No new commit needed."
            }
            else {
                & git commit -m "D304: Import user-approved Gothic Battle DS3 painted modules" -- $files
                if ($LASTEXITCODE -ne 0) { throw "git commit failed" }
            }
            & git -c gc.auto=0 push origin HEAD:main
            if ($LASTEXITCODE -ne 0) { throw "git push failed. Art is safely installed locally; review remote branch before retrying." }
            Write-Host "D304 OK: approved art published to GitHub main." -ForegroundColor Green
        }
        finally { Pop-Location }
    }
    Write-Host "Restart Godot and open a real Battle. The UI switches to approved modules automatically."
}
finally {
    Remove-Item -LiteralPath $tmp -Recurse -Force -ErrorAction SilentlyContinue
}
