# D357 — Next-chat handoff (2026-10-27)

## Current status

D357 selected THIRD final Ossuary Gate image **not** the old empty gates art or another earlier scene. Original `неживой_дозор_у_лунных_врат.png`, 1536×1024 PNG SHA256 `f4442f0261219f832521fc1657305c4ac91884eed6d0febec8ecd36aae3c48e1`. It shows all four gameplay roles: guard, bell keeper, bone archer, bone thrall. Binary runtime `assets/pixel/card_unification_v1/run/ossuary_gate_d357_approved_option3.webp`, source crop 0,42–1536,981, WebP 448×274 quality 86, SHA256 `24e7fec8df8ac4f4b4610eb4032b6066d1d50b1dcff89a17d10cb4959d339645`, Git blob eda1cda2b6a3309f2afe38071054ee736360c3ce.

Only `scripts/ui/card_unification_v1.gd` ossuary_gate map changes; original `resources/cards/ossuary_gate.tres` retained as rollback. D315 strict SHA256/WebP format/448×274/catalog pixel identity lock protects selected 26th illustration. No changes to `resources/encounters/ossuary_gate.tres` (crypt_guard, grave_bellkeeper, bone_archer, bone_thrall), support healing, formations, rewards, DS3 or other approved assets.

## Next actions

1. Look up PR from branch `art/d357-ossuary-gate-approved-option3`; wait for **actual native Godot CI** outcome (GUT, D289, D315, D316, screenshot captures). Never claim PASS before GitHub confirms.
2. If CI green, squash-merge, verify binary in `main`, update PROJECT_STATE/ROADMAP/DECISIONS/HANDOFF/registry/CHANGELOG with merge commit and run URL. If red, inspect logs and fix before merge.
3. User local: `git pull`, F6 `scenes/dev/d315_card_ds3_gallery.tscn` inspect «ВРАТА ОССУАРИЯ»; the complete A1P3 F5 12-card + XIII human playtest is outstanding.
4. Next art D358 «Железная стена», followed by «Последний звон» and «Расстрельная площадь» — three remaining artistic approval rounds, options-first. Never change fundamental game design without discussion.
