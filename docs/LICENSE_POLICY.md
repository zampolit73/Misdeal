# Misdeal — License Compliance 1.0

Mandatory for all DARK FORGE roles. Applies to the repository and commercial player
distribution, not just files currently referenced by F5. No new dependency or asset is
authorized merely because it appears in this policy or a research shortlist.

## Import and reuse rules

- Default allowlist: MIT, MIT-0, BSD-2-Clause, BSD-3-Clause, Apache-2.0, ISC,
  0BSD, CC0-1.0 and OFL-1.1 (fonts). CC BY 3.0/4.0 is acceptable only with
  complete per-work credit, license link and change notice. Preserve required
  upstream copyright/license/NOTICE files, including dependency notices.
- Do not put GPL/AGPL/LGPL, CC BY-SA, NC, ND, unknown/unlicensed, proprietary
  demo assets, ripped game assets or unclear custom-license content in the
  player build without separate documented legal review and an explicitly
  revised policy. A free download is not a copyright grant. GPL can permit
  paid distribution; the restriction here protects Misdeal's intended closed
  source model, not a claim that GPL prohibits commerce.
- Tools used separately for authoring (e.g. Blender or GPL sprite exporters)
  need not become game dependencies. Check output rights, embedded templates,
  source models, textures, audio, fonts, model terms, and references separately.
  Never assume a code license covers demo art. Do not copy proprietary
  trademarks or branded content. A mirror is not proof of the original grant.
- For AI-generated or original project assets, retain prompt/source/approval,
  tool terms or authorship/permission evidence, and check reference rights.
  A visual approval or a generation receipt alone is not proof of copyright
  clearance or exclusive ownership. Log externally sourced ingredients.
- Before import, select a pinned commit/version or immutable source, verify the
  original license for each included file and dependency, archive copies of
  the applicable license and NOTICE texts, and record the author, source,
  date, edits, provenance and exact imported file SHA-256. For music, also
  review recording/composition rights and streamer/Content ID risk.
- No replacing or deleting approved assets merely to resolve a license question.
  Quarantine new unresolved material outside the project; flag historical
  unresolved assets without removing them until a reviewed replacement exists.

## Registry and notices

`THIRD_PARTY_ASSETS.json` is the machine-readable registry, and
`THIRD_PARTY_NOTICES.md` collects distribution credits (including changes to CC BY
works). Existing detailed audio and visual provenance documents remain authoritative
for their historical evidence. `licenses/` holds archived original texts for future
imports; existing vendored texts remain at their original paths.

The baseline is pinned to the actual pre-policy Git revision
`0e1dd62ac0c52cf02d7daa3e6a467cd9a6272c14`. Historical entries are
`documented`, not independently cleared. The legacy audit remains incomplete:
complete the inventory of the original assets, fonts, code, source archives,
AI/reference provenance and actual export contents before a commercial release.
The baseline never grants a license.

For every new or changed asset/addon/shader in the gate's scope add a
`new_resources` entry (batch entries may cover multiple exact files):

```json
{
  "id": "unique-package-id",
  "status": "verified",
  "origin": "third-party",
  "author": "Original author",
  "source_url": "https://example.org/original-project",
  "revision": "pinned-commit-or-original-version",
  "obtained_on": "YYYY-MM-DD",
  "licenses": ["MIT"],
  "license_files": ["licenses/package-id/LICENSE.txt"],
  "evidence": "docs/provenance/package-id.md",
  "files": {
    "assets/example.png": "64-lowercase-hex-characters-from-sha256"
  }
}
```

Example above is a schema illustration only, not a real asset. For original or
generated content, use `origin: original` or `generated`, `licenses:
["PROJECT-ORIGIN"]`, a descriptive `revision`, and a nonempty
`rights_review` describing provenance/references/tool rights. PROJECT-ORIGIN is
a registry marker, not a legal license. The evidence document must exist.
For third-party content also add a notice with the same entry ID and complete
attribution. Record external code copied into ordinary GDScript or config
files too, even where automatic discovery cannot identify its origin.

Legacy status: `documented` means not cleared; `verified` requires actual
source/license evidence and notices; `excluded` requires evidence of
exclusion from player export (public repository redistribution must still be
lawful). Do not change status merely to make the gate pass.

## Check before commit and before release

From the project root (Python 3.9+ and Git; no Godot, pip, API or network):

```powershell
python scripts/dev/check_licenses.py --inventory
python scripts/dev/check_licenses.py --release
```

The first command checks registry structure, local evidence existence,
exact file hashes, commercial license allowlist, and unregistered changed
assets/addons/shaders/media since the immutable baseline. It also checks
untracked non-ignored additions and warns about legacy review.
The second is a stricter publication gate: any unresolved legacy entry,
incomplete legacy audit or missing engine/copyright and export review
evidence fails with nonzero status. A shallow clone without the baseline
fails closed; fetch the baseline/history instead of resetting it.

The script intentionally cannot identify unknown intellectual property in
an arbitrary file, prove author identity, verify licensing of an external
source automatically, or inspect a future package by itself. Manual
verification and the release package review remain mandatory. The check
does not start Godot or change game files. Source assets encoded as .b64 or
split chunks are still assets; only engine .import/.uid metadata and asset
Markdown documentation are excluded from automatic changed-file detection.

## Commercial release checklist

1. Resolve every legacy entry and save the full baseline review report; do
   not blindly mark undocumented art, generated assets or dependencies approved.
2. Review the exact export manifest (including .pck and any bundled DLLs).
   Exclude editor-only GUT, test scenes, source archives, QA previews and
   unused/rejected material where appropriate.
3. Include the actual Godot version's license and third-party copyright file,
   all applicable plugin and font notices, and complete art/audio credits next
   to the distributed build or in an accessible in-game legal page. Save a
   package review report showing where those files ship.
4. Set the corresponding report paths in the registry only after the review;
   run the strict gate before any public demo, Steam build or commercial
   distribution. Nonzero exit code means stop, not ignore.
5. Have a qualified legal reviewer validate uncertain grants before release.

Godot official license guidance:
https://docs.godotengine.org/en/stable/about/complying_with_licenses.html
Creative Commons: https://creativecommons.org/share-your-work/cclicenses/
OFL: https://openfontlicense.org/open-font-license-official-text/
GitHub no-license guidance:
https://docs.github.com/en/repositories/managing-your-repositorys-settings-and-features/customizing-your-repository/licensing-a-repository

Current implementation is a local preflight; no repository branch rules,
export profiles, or GitHub Actions settings are changed. Release automation
must call the strict gate before packaging when a release pipeline is added.
