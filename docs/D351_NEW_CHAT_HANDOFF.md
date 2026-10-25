# D351 NEW CHAT HANDOFF — Bone Tax (2026-10-26)

Source of truth: `zampolit73/Misdeal` main, AGENTS.md and docs/CONCEPT.md, PROJECT_STATE.md, ROADMAP.md, DECISIONS.md, DESIGN_SYSTEM.md, VISUAL_ASSET_REGISTRY.md.

## Art accepted / exact transfer

- `bone_tax` user chose OPTION #1 and continued after standalone render `скелет_страж_у_ворот_замка.png`; use final image, not preliminary triptych nor options 2/3.
- Source original 1536×1024 PNG SHA256 `babeb15689f4b2a3c9d658f5eaec8440ac44e191b4f9c6e04878eb8b53ab65bf`.
- Skeletal armored tollkeeper with open extended bony palm, steel axe upright, bowl with coins at lower left, two torches, rusty gate grille, burgundy cloth, distant castle. No card UI baked in.
- Exact game WebP: `assets/pixel/card_unification_v1/run/bone_tax_d351_approved_gatekeeper.webp`, 448×274, SHA256 `d1ec73bfe982eaaac6abddf4b22c6bda3e778a09520df26dbc9235a08cbc8639`. From `(0,42)-(1536,981)` Lanczos Q86.
- File was uploaded to GitHub via `create_blob` binary Base64 encoding, Git blob SHA `e9695f9c3911fbb9f8183a2e73bf94006a2e6a40` and tree/commit. Unlike D350 it is a regular .webp, NOT .webp.b64.

## Implementation / QA

- `CardUnificationV1.RUN_CARDS["bone_tax"]` points to native image; original `resources/cards/bone_tax.tres` and atlas fallback unchanged.
- D315 smoke adds nineteenth native WebP image and 20th total approved individual art. SHA256 check for D351, WebP decode/dimensions and actual `CardArtCatalog` pixel equality.
- Prior approved D350 Debtor Bones three-dice image, D349 Crown, DS3, all game mechanics and Fate Spread 12+XIII untouched.
- Confirm *real* GitHub Actions Godot 4.7.x green on D351 PR head **before merging**. Prior D350 green 48/48 is not evidence of D351.
- After merge, user: `git pull`; Godot F6 `scenes/dev/d315_card_ds3_gallery.tscn`, inspect «КОСТЯНАЯ ПОШЛИНА». Human A1P3 F5 12+XIII run pending.
- Next D352 choose another existing unapproved card placeholder; show 2–3 real image options, wait for choice.
