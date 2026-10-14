# D151 — Mourning Bell / Похоронный звон — gated implementation

Date: 2026-10-14. Status: **source/gameplay controller + isolated Godot smoke created; art sheet and native F6 QA PENDING; NOT in live Act1 pool**.

## User intent and non-negotiables

User said «давай» to continuing the discussed D151 combat-card initiative. They have repeatedly required: every new combat card includes **genuinely new enemy types**, distinct battle roles/behavior, fully original card art **and actual authored animation states** matching the approved cinematic DS2/D147 art quality. Do not reuse old Grave Bellkeeper, skeleton, Bone Shepherd or Lamb sprites even as temporary live art. Finish art/engine review before adding card to normal run. GitHub access is connected and should be used autonomously. User should only need `git pull`, F6, and screenshot for final QA.

## New card / two original roles

- `mourning_bell` / «ПОХОРОННЫЙ ЗВОН» — **Tier 1 combat** card in `resources/cards/mourning_bell.tres`, unregistered. Authored two layouts in `resources/encounters/mourning_bell.tres`, graveyard arena. 1 `mourning_sexton` + 2 `pallbearer`, no mixed legacy role, no reinforcements.
- `mourning_sexton` («Погребальный распорядитель») — liturgical commander, skeletal elongated hooked back beneath grim black/red grave fabrics; larger carried bell chain or crooked rope, 102 HP, 5 damage, 1.60s attack, range 114, slow 52. **Different from existing Grave Bellkeeper healing support**: doesn't heal and never uses Bellkeeper art; triggers its own revive/fury ritual controller. Name/style can be finalized after user's card/sprite review.
- `pallbearer` («Гробоносец») — each is an individual wide, burdened bony coffin-bearer with cracked bronze shoulder hardware and funeral beam; HP 76, damage 9, attack interval 1.35, melee, speed 62. No color swap of skeleton/thrall/guard.
- Both unit Resources are genuinely new in `resources/units/`, not aliases of old Units. Card path anticipates `res://assets/pixel/card_unification_v1/run/mourning_bell.webp` **which does not yet exist in GitHub**; this is safe because card is **NOT** registered in `RunState.CARD_PATHS` or `ACT1_CARD_IDS`.

## Grave Toll / Погребальный звон state machine — code shipped

`scripts/data/grave_toll_data.gd`, `resources/encounters/grave_toll.tres`, `scripts/battle/grave_toll.gd` implement encounter-scoped `GraveTollController`:

1. Wait **5.5s** battle delta (not wall time); leader must be alive.
2. **1.0s telegraph** around leader and pallbearers, visibly interruptible by killing the leader.
3. Resolve: if the encounter has **never revived a bearer**, revive **one dead pallbearer (authored order)** at **40% HP** via narrow role-guarded `BattleUnit.revive_from_grave_toll()`; strictly one resurrection **total per encounter**, no infinite resurrection.
4. Otherwise living bearers gain temporary **20% faster attack cadence** for **2.5s**, with original attack interval restored exactly, including if the leader dies mid-buff. Does not modify damage, permanent stats, party multipliers, rewards or Wizard debt.
5. Cooldown between toll triggers is **8.0s**. No overlapping events, extra units or global status framework. Stops cleanly if the leader dies; the previous spawn roster remains the only authored roster.

`scripts/battle/unit.gd` has only one new function `revive_from_grave_toll`, which refuses unless role `pallbearer`, team enemy and dead. Cancels death/hit/attack tweens; restores HP, alpha, state, frame/animation, HUD, combat targeting and cooldown. No other unit is revivable through this method.

**IMPORTANT:** The Grave Toll controller is **not yet connected to production `battle.gd`**, because the card lacks valid animated visual roles and hasn't been visually approved. The existing Bone Shepherd Whistle and all production battles remain unchanged. The intended battle hook after authentic art validation follows the existing encounter-id guard pattern used by `_setup_bone_shepherd_whistle()`: find exactly one `mourning_sexton` and two `pallbearer`, instantiate controller only for `encounter.encounter_id == "mourning_bell"`, start/stop with the encounter, and keep one-shot resurrection compatible with `_on_unit_died` outcome checks. Do not activate before asset QA.

## Art: generated concept, not production sprite sheets

Two standalone new cemetery processional paintings were generated in the chat (generation IDs `cb871133-c39e-4327-bb54-5b2cd1b7a5d4`, `282a7a2e-5bb2-4ff6-b285-54c1ffafe2d8`). The preferred original card composition (large hanging bell left, rope-bearing skeletal leader center-left, two coffin carriers right, cold moonlight/warm votives) was cropped/resampled from the first image into the conversation artifact **`D151_mourning_bell_card_candidate.webp`** — exact **448×274**, **51,550 bytes**, SHA256 **`6b16b70efb45dabb5f6d63b53772372c953f9d315d6d26b5026d6044b022069f`**. There is **no UI/text/border baked** and old approved assets are unchanged. **This candidate has NOT been uploaded to GitHub or approved by user**.

The image generation attempt for unit sheets produced a second cinematic painting instead of frame-authored sheets. It is **NOT** a 25-frame sprite atlas. Do **not** fake 25 frames by shifting/copying a single pose or present it as animation. Need genuinely authored, transparent 576×480 WebP atlases (6×5 grid, 96×96 cell): idle 4, walk 6, attack 6, hit 3, death 6 **for EACH distinct original role**. Use approved D147 Bone Shepherd/lamb actual gameplay readability as quality bar. Only after verified sprites should you register roles in `MisdealUnitAnimationLibrary` and ship the card art.

## Test in Godot

Isolated new `res://scenes/dev/grave_toll_smoke.tscn` calls the actual `GraveTollController` with real `BattleUnit` nodes but **without sprites and without registering the card**. Tests unique unit/card/encounter Resources, roster/two formations, first revive 40%, no second revive, leader death telegraph cancels, fury timer and stat rollback. This is *not* the 54-battle live smoke nor an art review. **Godot F6 has not been run by user yet** and no engine PASS is claimed; if syntax/runtime failure occurs, fix directly in GitHub.

## Full integration acceptance gate

- User-approved, GitHub-committed original 448×274 card WebP and two independent genuine 25-frame battle atlases, no filler/empty cells, visual comparison to D147.
- Register `mourning_bell` in RunState only at this gate: pool **33→34** (Tier1 11→12); 12 actual resolved + Bone Warden XIII unchanged.
- Add isolated F6 original sprite gallery, real battle playtest, 54-case smoke with both formations × three roles × three party sizes × three tactics plus targeted lifecycle tests. Verify leader cast cancellation, exactly one revival, temporary fury reversion, no target reticle/FX after battle, actual normal victory→reward→table.
- Update `PROJECT_STATE`, `ROADMAP`, `DECISIONS`, `CHANGELOG`, `NEXT_CHAT_HANDOFF`, `VISUAL_ASSET_REGISTRY`. Preserve D142 HUNT/duo tuning as separate backlog.

## Next action

Check F6 `res://scenes/dev/grave_toll_smoke.tscn` after `git pull`; inspect unexpected native errors. Then obtain true original transparent animated unit frames (both roles) and commit the binaries/card art before progressing card pool.
