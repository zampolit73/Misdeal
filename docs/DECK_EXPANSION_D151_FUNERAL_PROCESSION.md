## D151 INTEGRATION GATE — 2026-10-15 — VISUAL APPROVED, REAL BATTLE HOOK STAGED; GODOT QA PENDING

**User explicitly accepted** the corrected V2 Funeral Priest / Pallbearer sprite presentation: «все отлично!». This supersedes earlier art-rejection/F6-pending notes below. Both original 576×480 atlases (25 poses each with full feet/coffin) and full-bleed 448×274 card art are already in `main`. The isolated Last Rite lifecycle had passed earlier in Godot.

**New code in GitHub main:** `scripts/battle/battle.gd` now creates `LastRiteController` *only* for encounter id `funeral_procession` (original 1 priest + 2 pallbearers), starts it together with unit combat, stops on battle victory/defeat, and shows a unique tactical preparation hint and victory subtitle. Old Grave Bellkeeper, Bone Shepherd/Whistle and all previously approved encounters untouched. `scripts/core/run_state.gd` adds `funeral_procession` to `CARD_PATHS` lookup **only** so isolated dev F6 can select it; it is **not** in `ACT1_CARD_IDS`, so the current normal Act1 deal pool remains **33/45**, not 34 yet. Real combat outcome still goes through normal victory → `res://scenes/reward/reward.tscn` → table flow.

**New scenes:** (1) `res://scenes/dev/funeral_procession_playtest.tscn`: resets dev run to Knight, force-offers Funeral Procession, opens actual battle preparation scene, tactical buttons, enemies, Last Rite, victory reward. (2) `res://scenes/dev/funeral_procession_smoke.tscn`: 54 isolated real-unit simulations (2 formations × 3 starting archetypes × party sizes 1/2/3 × 3 tactics), checks original resources and 25-frame anims, tracks wins/losses, ritual warnings/revivals/fury, hard timeout, and displays PASS/FAIL. Existing `res://scenes/dev/last_rite_smoke.tscn` earlier **PASS** verifies lifecycle, but **not** the new live battle hook. `bone_shepherd_smoke.gd` still expects 33 until this release gate passes.

**No native Godot run after the integration commits yet.** Static source/registry check passed for all new references; do not falsely claim 54/54, balanced solo fights, or full reward loop. **Only user action:** `git pull`; F6 `funeral_procession_playtest.tscn` (inspect actual battle, visually grounded sprites/ritual and victory→reward→table), then F6 `funeral_procession_smoke.tscn` (54-case QA, 2/3/1 hero matrix). Send final screenshot or error only. Assistant fixes directly in GitHub. **After engine PASS and acceptable real-play result**, register `funeral_procession` in `ACT1_CARD_IDS` as 34th card (Tier 1) and adapt existing pool-count assertions; do not activate it prematurely. Later new combat cards still require new species/art/abilities under D143.

---

## D151 ART PREPRODUCTION — 2026-10-14 — visual sheets reviewed, NOT shippable

Two new generated pixel-art presentation boards explore the **Funeral Priest** (censer, forbidden rites, black and crimson garments) and **Pallbearer** (heavy skeletal corpse carrier and ornate coffin). Both are promising silhouettes and consistent color direction; they are **not playable atlases**. Specifically, their frames are small, irregularly spaced on illustrated boards with embedded headings, dividers and cemetery backgrounds. They do NOT have independently authored full 4/6/6/3/6 poses in strict 96px opaque/transparent-per-cell coordinates. **Do not cut these posters into the production `576×480` 6×5 sheets, stretch a single pose, auto-clone missing poses, or claim the two atlases exist.** The look still awaits authentic spritesheet production and local art review.

Image generation metadata references (conversation only, not GitHub assets): first dual-role concept board `8715ff22-222e-4e9d-94f5-aaaad56d3989`, second three-character board `e5b1c0ab-db06-4d30-8447-92d8a0a27c33`. The role-specific visual intent is clear: the priest's censer is distinct from the OLD `grave_bellkeeper`'s bell. The third pale Pallbearer on the second moodboard is only an optional color-study, not a third enemy class or a new unit.

**NEXT ART PRODUCTION GATE:** Create clean isolated alpha sprite sheets role by role, no UI/text/backdrop; five genuine movement/action rows (idle 4, walk 6, attack 6, hit 3, death 6). Programmatically inspect all 25 authored cells for nonempty alpha and meaningful pose differences, common feet baseline, no object clipping; only then prepare `funeral_priest_frames.webp.b64` and `pallbearer_frames.webp.b64`, connect through `MisdealUnitAnimationLibrary` as a scoped opt-in and preview F6. The actual 448×274 card scene exists as a **local candidate** but is not committed nor artist-approved. Do not register `funeral_procession` in Act1 or alter live 33-card pool, old vetted DS2 art or combat during this art-development stage.

User already confirmed isolated `Last Rite` F6 PASS (mechanic only). No additional F6 needed until there are actual new textures.

---

## D151 QA — 2026-10-14 — Last Rite isolated Godot F6 PASS, visual assets next

User submitted a **real Godot F6 screenshot** showing `DECK EXPANSION 03 / LAST RITE — PASS` for `res://scenes/dev/last_rite_smoke.tscn`. Verified by local engine: 1 original funeral priest + 2 pallbearers Resource roster; one dead pallbearer can revive at **40% HP once per encounter**; a second resurrection is blocked; priest death cancels warning; temporary attack-rate buff expires/restores without stacking. This supersedes prior **F6 pending** status for the isolated ritual test. **Not tested** by this screenshot: live combat wiring, 1/2/3 hero balance, authored animation sprites, run/award/table flow or card visual approval. D151 `funeral_procession` remains **unregistered** and not live; current pool stays **33/45**. Previous bell-themed prototype remains rejected, no bells in the new encounter. Next: original painterly **448×274** `funeral_procession` card WebP and genuine **25-frame transparent 576×480** unit atlases for `funeral_priest` and `pallbearer` (not borrowed art, not static-pose duplication), then in-engine gallery, integrate scoped controller and run battle matrix. Never mark production pass before those gates.

---

# D151 — Funeral Procession / Last Rite (2026-10-14)

## Binding user approval
The previous D151 “Mourning Bell” (with `mourning_sexton` / `grave_toll`) was **rejected** because Misdeal already has the `grave_bellkeeper` and a bell-themed fight would lack visual identity. The user approved replacing it with **«ПОГРЕБАЛЬНАЯ ПРОЦЕССИЯ»**: one original **Погребальный жрец** (`funeral_priest`), two original **Гробоносца** (`pallbearer`), the necromantic **«Последний обряд»** (`LastRiteController`). **No bells** or alternate Bellkeeper art/roster. This supersedes historical `DECK_EXPANSION_D151_MOURNING_BELL.md`.

## Art direction
- Leader: original skull-faced priest in funeral vestments, forbidden book and smoking ritual censer, *no bell*.
- Attendants: two broad-shouldered coffin carriers, not existing skeletons/guards. A single ceremonial coffin ties scene together but is not a fourth enemy.
- Own cinematic full-bleed **448×274 WebP** card art, no baked typography/frame/buttons. Cold moonlight, crimson funeral cloth, blackened bronze and warm candlelight, consistent with approved D147 Bone Shepherd.
- Own genuine transparent **576×480, 6×5 96px** sprite atlas *per enemy*: 4 idle / 6 walk / 6 attack / 3 hit / 6 death frames, with visible alpha and planted feet, not single pose duplicates. Concept-only image generation in conversation does not count as production sprite art.
- Do not restyle approved DS2/Fate Spread, old Bellkeeper, Bone Shepherd or other legacy enemies.

## Implemented source in GitHub main (isolated only)
- `resources/cards/funeral_procession.tres`: Tier1 original combat card, not registered.
- `resources/encounters/funeral_procession.tres`: two formations, exact new roster 1 priest + 2 pallbearers.
- `resources/units/funeral_priest.tres`, existing new `resources/units/pallbearer.tres`.
- `scripts/data/last_rite_data.gd`, `resources/encounters/last_rite.tres`: 5.5s first trigger, 1s visible warning, 8s cooldown, one 40%-HP revival, or +20% attack rate for 2.5s.
- `scripts/battle/last_rite.gd`: self-contained encounter-specific ritual warning/resolve/interrupt and nonstacking buff rollback. On leader death interrupt and restore. Does not touch old Bellkeeper heal or Shepherd Whistle.
- `scripts/battle/unit.gd`: `revive_from_last_rite` allows only a *dead enemy* `pallbearer`, properly restores interrupted death tween and combat sprite state.
- `res://scenes/dev/last_rite_smoke.tscn` and `scripts/dev/last_rite_smoke.gd`: isolated Godot F6 real-Unit ritual lifecycle test.
- Superseded `mourning_bell`, `mourning_sexton`, `grave_toll` files and old smoke scene **deleted**.

## Not shipped / constraints
- Still **33 registered nonboss Act1 cards** of goal 45, 12+XIII per run unchanged. `funeral_procession` is *not* in `RunState.CARD_PATHS` / `ACT1_CARD_IDS`, and is not bound in `scripts/battle/battle.gd`: intentionally withheld until original card art and both genuine enemy animation atlases are produced and accepted. No user-facing fake or borrowed combat art.
- No Godot binary runtime in assistant; native F6 result remains **pending**. No balance, normal end-to-end win→reward→table or graphics approval claimed.
- Future: after sprites/card art, do playtest + functional smoke for two formations and 1/2/3 heroes, then hook live battle and advance registered pool to 34. D143 original-new-enemy rule is binding for every new combat card.

## Single user action for this checkpoint
`git pull`, open `res://scenes/dev/last_rite_smoke.tscn` and press F6. Expect headline **DECK EXPANSION 03 / LAST RITE — PASS**. If FAIL, send screenshot; assistant fixes directly in GitHub.
