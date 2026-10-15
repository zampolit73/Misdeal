# Misdeal — D153 next-chat start (2026-10-15)

## This is the current checkpoint

Continue **D153 / Threadbare Theatre («Театр оборванных нитей»)** in `zampolit73/Misdeal`, Godot **4.7.x + GDScript** on `main`. The user explicitly requested pausing development **now** and starting the **next stage in a new chat**, so this checkpoint must be sufficient without rereading the conversation. GitHub is the current-code source of truth; the assistant has connected GitHub write access and should commit changes itself. **Do not ask for access or require manual ZIP, PowerShell or file copying.**

### Confirmed by actual user Godot screenshots

- D153 card F6 `res://scenes/dev/threadbare_theatre_card_preview.tscn`: the chosen **third** dark-fantasy **skeletal** puppeteer theatre image loads in the native 448×274 slot. Original game card artwork source: `assets/pixel/card_unification_v1/run/threadbare_theatre_approved_v1.webp.b64`. No missing-art error shown.
- D153 logic F6 `res://scenes/dev/threadbare_theatre_smoke.tscn`: **D153 / SKELETAL STRINGS — PASS**, Godot error counter **0**. Original two-unit-type undead roster and both formations PASS. Tether protects marionettes by **32%** within **285 px** of living Puppeteer, breaks outside range, returns on reconnection, breaks instantly on master death and cleans up base damage multipliers. This proves **isolated logic only**, NOT real battle or art animations.

### Committed and staged

- `resources/cards/threadbare_theatre.tres`
- `resources/encounters/threadbare_theatre.tres` — two formations; **crypt** arena only a temporary placeholder, not a theatre arena.
- `resources/units/threadbare_puppeteer.tres`, `resources/units/bone_marionette.tres` — genuinely new skeletons, NOT reuse of existing skeleton assets.
- `scripts/battle/thread_tether.gd` — battle-local protection mechanic, **not yet wired into production `battle.gd`**.
- `scripts/ui/card_unification_v1.gd` — selected original card illustration loader (preview only).
- `scripts/battle/unit_animation_library.gd` — strict, new D153 role loader: only real 576×480 (.webp.b64) animation spritesheets, **25 separately authored full-body frames per role**, with 96×96 cells and counts **idle 4 / walk 6 / attack 6 / hit 3 / death 6**, visibility, padding, uniqueness enforced, **no old-enemy sprite fallback**.
- `res://scenes/dev/threadbare_theatre_art_preview.tscn` — an animation F6 gallery, scaffolding only. **Do not ask user to run it before sprite sheets are committed.**

### Missing (verified against GitHub; 404)

- `assets/pixel/units/deck_expansion_v1/threadbare_puppeteer_frames.webp.b64`
- `assets/pixel/units/deck_expansion_v1/bone_marionette_frames.webp.b64`

The theatre card art is NOT an animation sheet; generated mood images / concept boards are NOT authentic 25-frame atlases. **Do not claim missing animations are complete.**

## Next stage — start here in the new chat

1. Create **two original skeletal character atlases** meeting the exact 6×5/96px technical contract, matching approved theatre art. Preserve visible feet, source-right facing, fully distinct real animation poses, no 2px edge cropping/blank frames/flicker. If image generation cannot reliably create actual frame sequences, say so rather than fabricating poses.
2. Independently validate the decoded images (size, alpha padding, occupied and unique cells), commit both `.webp.b64` files into GitHub directly, as with earlier D152 assets.
3. Only then request **one short user action**: `git pull`, F6 `res://scenes/dev/threadbare_theatre_art_preview.tscn`, send visual feedback.
4. After Godot art acceptance: produce proper theatrical battle backdrop/arena with D167 scene-level environmental storytelling; scope `ThreadTetherController` to D153 in `battle.gd`, real combat/reward/table QA, then deterministic 54-case balance matrix. Do not activate the card in the live Act1 pool until all release gates pass.

## Frozen constraints

- Live Act 1 is **35/45** cards; D153 remains **NOT** in `RunState.CARD_PATHS` **nor** `ACT1_CARD_IDS`; target after release **36/45**. Physical run is **12 Fate Spread encounters + sealed XIII**.
- D143: new fighting cards must contain genuinely original enemies and animations; these **must be undead skeleton marionettes**, **not wooden puppets**.
- D167: card illustrations must be fully realized dark-fantasy *world scenes*, not sprite showcases.
- D168: show user **three materially different image options before final art selection**; D153 already satisfied this rule, user selected variant C. Do not restart D153 art choice or replace approved artwork.
- DS2 / Fate Spread Variant C, existing D151/D152, global tactics and combat balance are unchanged. Prior D152 released as card #35, with accepted V2 environment illustration.

Read `AGENTS.md`, `docs/CONCEPT.md`, `docs/PROJECT_STATE.md`, `docs/ROADMAP.md`, `docs/DECISIONS.md` and this document at the next chat start, then verify current `main` before edits.
