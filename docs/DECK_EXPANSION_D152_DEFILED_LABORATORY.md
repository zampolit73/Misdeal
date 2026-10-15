# D152 — Defiled Laboratory (staged, NOT live)

**Checkpoint: 2026-10-15.** Two original enemy concepts generated, repacked into game-ready transparent 576×480 sheets, and code wired for a gated local Godot preview. **No production D152 card release, no Godot art/real-battle PASS yet.** Act1 remains **34/45 cards**.

## Implemented in GitHub main

- `resources/units/plague_alchemist.tres`, `resources/units/unstable_homunculus.tres`: original enemy identities/stats.
- `resources/encounters/defiled_laboratory.tres`: 1 alchemist + 2 homunculi with **two authored formations**, still provisional tuning.
- `scripts/battle/laboratory_hazards.gd`: encounter-local telegraph (1.2s), poison zone (2.2s), finite player damage pulses, on-death temporary spills and stop cleanup; native isolated `scenes/dev/defiled_laboratory_smoke.tscn` screenshot **PASS** verified by user.
- `scripts/battle/battle.gd`: ONLY encounter `defiled_laboratory` configures, starts and stops the local hazard controller. Other battles, D151 Last Rite, D144 Whistle, old global tactics and party scaling untouched. **New full battle F6 NOT yet validated**.
- `scripts/battle/unit_animation_library.gd`: strict original D152 art gate. For D152 roles first tries canonical committed `assets/pixel/units/deck_expansion_v1/{role}_frames.webp.b64`; if absent, reads **ignored local QA image** `assets/local_previews/d152/{role}_frames.png`. Both must be 576×480 RGBA, have 25 visible genuine cells and transparent 2px borders. It does NOT borrow old enemy art or repeat missing frames.
- `resources/cards/defiled_laboratory.tres` is **QA lookup only** via `RunState.CARD_PATHS`, with no final illustration (art_path empty). It is intentionally absent from `RunState.ACT1_CARD_IDS`, so Act1 stays **34/45**. Do not use this card for normal user-facing deals.
- `scenes/dev/defiled_laboratory_art_preview.tscn`: original 5-state idle/walk/attack/hit/death gallery (and honest missing-image blocker).
- `scenes/dev/defiled_laboratory_playtest.tscn`: guarded real battle through `battle.tscn`, refuses to start until BOTH original atlases are present and pass the quality gate. No false static art substitute.
- `.gitignore`: ignores `assets/local_previews/d152/` so the local asset preview package cannot create an untracked Git collision. Once approved, real production binaries must be committed under the distinct `.webp.b64` source paths.

## Art generated in the development conversation — not yet GitHub assets

Two **original image-generated sprite sheets** (1374×1145 PNG) were repacked locally into independent **576×480 RGBA PNG animation atlases**; each is a 6×5 grid of 96px cells, **25/25 occupied and nonduplicated** (idle 4 / walk 6 / attack 6 / hit 3 / death 6), unused cells transparent; offline 2px per-cell border quality checks passed, so no hard cropping at atlas edges. Both source art directions face RIGHT. Native Godot playback, consistency and art direction are **pending**. Offline candidate SHA256:
- `plague_alchemist_frames.png`: `5e2497eb29a07ee19e49b16619ae9ffd763b2b60f7f8e185980595a53ee892d0`
- `unstable_homunculus_frames.png`: `85fad8cdf1f4f14daac9c489f47f04903780d1e262669fa36824e98b588fc86d`

**Delivery caveat:** the connected GitHub text-file API does not carry this session's local binary PNG bytes. The assistant prepared a downloadable conversation attachment `misdeal_d152_animation_preview_pack.zip` containing BOTH images under the **ignored local preview** paths. The PNG bytes are **NOT in GitHub**. Do not imply `git pull` alone installs these sprites; a user must extract this optional QA pack into the project root before testing the gallery and battle. No manual code edits are needed. Do not consider a future chat to have the original binaries unless the pack/asset is provided again. Prior to production release, transfer approved art into tracked `.webp.b64` resources and remove dependence on the local pack.

## Local QA instructions

1. `git pull`; extract the *contents* of the D152 animation preview ZIP into the **Misdeal project root** (it creates `assets/local_previews/d152/plague_alchemist_frames.png` and `unstable_homunculus_frames.png`).
2. Reopen Godot to refresh assets, F6 `res://scenes/dev/defiled_laboratory_art_preview.tscn`. Inspect feet, full silhouette, alchemical equipment, attack readability, left/right movement in all 5 states for both characters. Neither should flicker or reveal neighboring poses.
3. Only after gallery art looks acceptable, F6 `res://scenes/dev/defiled_laboratory_playtest.tscn`. This starts a **real Knight battle**, with scoped chemical zones. Check orientation, formation, poison warning visibility, HP changes, death spill, no error. It is not the 54-case balance matrix or fully certified full-run navigation.

## Remaining release gates

1. Obtain explicit native Godot art acceptance; repair if clipping/facing issues surface.
2. Prepare original cinematic 448×274 **card art** (not yet created) and persist approved enemy atlases as production `.webp.b64` files **in GitHub**, not only the local ZIP.
3. Validate 2 formations × 3 heroes × 1/2/3 party sizes × ASSAULT/HUNT/FORMATION (54 cases) and real victory→reward→table; tune based on real player difficulty, avoiding unearned 100% auto-wins.
4. Only after all gates PASS, add D152 to `ACT1_CARD_IDS` for 35/45 and update deck-count smoke tests. `CARD_PATHS` is already dev-only registered, so it should **not** be appended again.
5. D151 real `funeral_procession_playtest.tscn` win→reward→table remains a separate unverified gate; its isolated 54/54 smoke is confirmed PASS.

Preserve D143 original enemy+animation requirements, DS2 / Fate Spread Variant C, 12+sealed XIII, existing D144/D151 animations and D142 HUNT/duo balance backlog.
