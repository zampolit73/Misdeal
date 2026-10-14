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
