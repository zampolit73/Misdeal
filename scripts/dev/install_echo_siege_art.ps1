param(
    [Parameter(Mandatory=$true)]
    [string]$Archive,
    [switch]$Commit,
    [switch]$Push
)

# Installs only the five user-approved Echo of the Siege event illustrations.
# No gameplay, scene, UI, balance or unrelated asset changes.
$ErrorActionPreference = "Stop"
Set-StrictMode -Version Latest
if ($Push -and -not $Commit) { throw "-Push requires -Commit." }
$repo = (Resolve-Path (Join-Path $PSScriptRoot "../..")).Path
$zip = (Resolve-Path $Archive).Path
$assetRoot = "assets/pixel/events/final_five"
$ids = @("banner_seamstress","unsent_letters","borrowed_boots","false_weights","last_signal")
$expectedSources = @{
    banner_seamstress = "be70f5375c703fc9ad4c5a1f5cfb57eea5f499ac849526348fa842ee483e39b2"
    unsent_letters = "3e84b66a1109af5867126e6a3d87dd480d28f6fe3641fef137ef8becfabb5e0f"
    borrowed_boots = "7cf1d2d0fa0cd813bdc0017b49d920f0fbd5692b0013f6d90cc716cb0120e88b"
    false_weights = "6d1c166f5587a68f366f68b210e3f6cae748d8a35a77cadc2bab605d399e95d6"
    last_signal = "2a53828e4fec3105605502fe5a4aa05610c5af46f5f8d61e35fc79cde7854026"
}

# Never allow the original five-card ZIP to undo the later user-approved Boots v2 art.
$existingManifestPath = Join-Path $repo "$assetRoot/manifest.json"
if (Test-Path -LiteralPath $existingManifestPath) {
    $existingManifest = Get-Content -LiteralPath $existingManifestPath -Raw -Encoding UTF8 | ConvertFrom-Json
    if ($existingManifest.PSObject.Properties["approved_sources"] -and
        [string]$existingManifest.approved_sources.borrowed_boots -eq "2ec39769890b2229255b62d46e7585186cf23b31b1c63a1da0c064c39f66d519") {
        throw "This original five-card pack is obsolete for Borrowed Boots. Use the 2026-11-10 boots-v2 one-card patch."
    }
}
Add-Type -AssemblyName System.IO.Compression
Add-Type -AssemblyName System.IO.Compression.FileSystem
$stage = Join-Path ([System.IO.Path]::GetTempPath()) ("misdeal-echo-siege-" + [guid]::NewGuid().ToString("N"))
New-Item -ItemType Directory -Path $stage -Force | Out-Null
try {
    [System.IO.Compression.ZipFile]::ExtractToDirectory($zip, $stage)
    $manifestPath = Join-Path $stage "ECHO_SIEGE_APPROVED_MANIFEST.json"
    if (-not (Test-Path $manifestPath)) { throw "Missing approved manifest in ZIP." }
    $manifest = Get-Content -Raw -Encoding UTF8 $manifestPath | ConvertFrom-Json
    $entries = @($manifest.entries)
    if ($entries.Count -ne $ids.Count) { throw "Expected five approved entries." }

    $validated = New-Object 'System.Collections.Generic.List[string]'
    foreach ($id in $ids) {
        $e = @($entries | Where-Object { $_.id -eq $id })
        if ($e.Count -ne 1) { throw "Expected exactly one manifest entry for $id." }
        $source = "$assetRoot/sources/echo_siege_approved/$id/approved_source.png"
        $sourceFile = Join-Path $stage ($source.Replace('/', [System.IO.Path]::DirectorySeparatorChar))
        if (-not (Test-Path $sourceFile)) { throw "Missing source: $source" }
        $sourceHash = (Get-FileHash -Algorithm SHA256 $sourceFile).Hash.ToLowerInvariant()
        if ($sourceHash -ne $expectedSources[$id] -or $sourceHash -ne [string]$e[0].source_sha256) {
            throw "Source SHA mismatch for $id"
        }
        $validated.Add($source)
        foreach ($kind in @("card","backdrop")) {
            $rel = "$assetRoot/$id/$kind.webp"
            $file = Join-Path $stage ($rel.Replace('/', [System.IO.Path]::DirectorySeparatorChar))
            if (-not (Test-Path $file)) { throw "Missing image: $rel" }
            $actualHash = (Get-FileHash -Algorithm SHA256 $file).Hash.ToLowerInvariant()
            if ($actualHash -ne [string]$e[0].output.$kind.sha256) { throw "WebP SHA mismatch: $rel" }
            $validated.Add($rel)
        }
    }

    # Only touch known image paths. Reject local edits to these exact target paths.
    Push-Location $repo
    try {
        if ($Push) {
            $branch = (& git branch --show-current).Trim()
            if ($LASTEXITCODE -ne 0) { throw "git branch failed." }
            if ($branch -ne "main") { throw "-Push requires local main; currently on '$branch'. Switch to main before running this installer." }
        }
        $dirty = @(& git status --porcelain -- @($validated.ToArray()) "$assetRoot/manifest.json")
        if ($LASTEXITCODE -ne 0) { throw "git status failed." }
        if ($dirty.Count -gt 0) {
            throw ("There are pre-existing local edits on approved target paths. Resolve first: " + ($dirty -join "; "))
        }
        foreach ($relative in $validated) {
            $sourceFile = Join-Path $stage ($relative.Replace('/', [System.IO.Path]::DirectorySeparatorChar))
            $destination = Join-Path $repo ($relative.Replace('/', [System.IO.Path]::DirectorySeparatorChar))
            $destinationDir = Split-Path -Parent $destination
            New-Item -ItemType Directory -Path $destinationDir -Force | Out-Null
            Copy-Item -LiteralPath $sourceFile -Destination $destination -Force
        }

        # The manifest and packer point at the approved originals, not old 2/3/2/3/3 options.
        $gameManifestFile = Join-Path $repo "$assetRoot/manifest.json"
        $gameManifest = Get-Content -Raw -Encoding UTF8 $gameManifestFile | ConvertFrom-Json
        if (-not $gameManifest.PSObject.Properties["approved_sources"]) {
            $gameManifest | Add-Member -NotePropertyName approved_sources -NotePropertyValue ([pscustomobject]@{})
        }
        foreach ($id in $ids) {
            $e = @($entries | Where-Object { $_.id -eq $id })[0]
            $gameManifest.approved_sources | Add-Member -NotePropertyName $id -NotePropertyValue $e.source_sha256 -Force
            foreach ($kind in @("card","backdrop")) {
                $key = "$id\$kind.webp"
                $gameManifest.files.PSObject.Properties[$key].Value = [string]$e.output.$kind.sha256
            }
        }
        $json = $gameManifest | ConvertTo-Json -Depth 30
        [System.IO.File]::WriteAllText($gameManifestFile, $json + [Environment]::NewLine, (New-Object System.Text.UTF8Encoding($false)))
        Write-Host "Installed and hash-verified all 5 approved PNGs + 10 WebPs."
        Write-Host "Rebuilt manifest approved_sources and output hashes. Existing old candidate sources retained."
        if ($Commit) {
            & git add -- @($validated.ToArray()) "$assetRoot/manifest.json"
            if ($LASTEXITCODE -ne 0) { throw "git add failed." }
            # --only is important: unrelated files may already be staged in a local Godot checkout.
            & git commit --only -m "art: ship five approved Echo of Siege event illustrations" -- @($validated.ToArray()) "$assetRoot/manifest.json"
            if ($LASTEXITCODE -ne 0) { throw "git commit failed." }
            if ($Push) {
                & git push origin HEAD
                if ($LASTEXITCODE -ne 0) { throw "git push failed." }
            }
        }
    } finally {
        Pop-Location
    }
} finally {
    Remove-Item -LiteralPath $stage -Recurse -Force -ErrorAction SilentlyContinue
}
