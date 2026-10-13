# Act 1 Deck Expansion — Card 01 / Bone Shepherd: Production-Ready Specification

**Prepared:** 2026-10-14. **Status:** implementation-ready **design/technical brief**. **No new live card, UnitData, sprite art or AI has shipped at this point.**  
**User direction:** «вообще все хорошо. давай готовь)», then «давай» after being offered a production-ready content specification. These approve preparing this production pack; do not confuse that with a Godot-tested playable implementation.  
**Binding decisions:** `docs/DECISIONS.md` D143 (new combat cards = genuinely new enemy designs) and approved DS2 / Fate Spread Variant C look. Source concept `docs/DECK_EXPANSION_BONE_SHEPHERD_CONCEPT.md`. **This document is the detailed production source**, superseding any incidental extra enemies, event choices or unimplemented buffs shown in the illustrative moodboard.

## 1. Scope contract / what ships in the first vertical slice

One **Tier 0 combat card**, one **EncounterData** with **two authored deployment formations**, **two completely new enemy species**, three enemy instances per fight, one **unique, visually telegraphed special ability**, original **deal card illustration**, and original **battle sprite animation sheets for both species**. No generic new card/event/ability framework. No temporary reuse or palette swaps of skeleton/archer/bellkeeper/thrall visual assets. No retroactive edits to existing seven card-specific alternate-formation encounter rosters, Fate Spread, Wizard deals, existing approved artwork or global solo/duo/trio scalers.

**Fixed opposing roster, both variants:** `bone_shepherd` **×1**, `ossuary_lamb` **×2**. The image brainstorm showed a third ghost enemy, wolves and event-choice buttons: these are **not in scope** and must not enter implementation without a separate user decision.

**Progression contract:** existing `RunState.ACT1_CARD_IDS` has 30 pre-boss cards, exactly 10 per tier; the first implemented addition should make that pool **31**, Tier 0 **11**, with **12 resolved slots and Bone Warden XIII unchanged**. Full +15 goal (45 cards) will be delivered gradually; do **not** register nonfunctional placeholder cards. Existing forced combat and two-offer restrictions need smoke/regression checks with 11-tier0 cards.

## 2. Player-facing card content — production copy

| Resource property | Final proposed value |
|---|---|
| `card_id` | `bone_shepherd` |
| `title` | **КОСТЯНОЙ ПАСТУХ** |
| `type_label` | **БОЙ** |
| `tier` | `0` |
| `resolution_type` | `combat` |
| `target_path` | `res://resources/encounters/bone_shepherd.tres` |
| `art_path` | `res://assets/pixel/card_unification_v1/run/bone_shepherd.webp` after a real verified art file exists; otherwise use a tested original B64 loader, **never point to a missing image** |
| `card_text` | **«Из тумана выходит костяной пастух. Его стадо давно не дышит — но всё ещё слушается свиста.»** |
| `wizard_line` | **«Такие послушные овцы. Жаль, что тебя они не считают пастухом.»** |

**Full encounter introduction (separate EncounterData `card_text`):**  
**«На тропу выходит Пастух с двумя костяными агнцами. Его свист заставляет стадо одновременно бросаться в атаку. Убейте пастуха, чтобы он больше не отдавал приказов.»**

**Player-facing formation hints:**
- **РАЗДЕЛЁННОЕ СТАДО —** агнцы с разных сторон, Пастух держится позади.
- **СБЛИЖЕННОЕ СТАДО —** агнцы наступают рядом, Пастух глубже в тылу.

**No player-facing choices** within this particular `combat` card. The source moodboard's “pay to pass / avoid fight” buttons are exploratory illustration artifacts and are **not** part of this first gameplay slice.

## 3. Enemy profiles — genuinely new enemies

These numerical values are **initial playtest guesses**, NOT balanced/approved global tuning. Exact role, silhouette and behavior are the acceptance criteria; tune values only after F6 and normal gameplay checks. Fields shown match currently implemented `scripts/data/unit_data.gd`, not invented properties.

| Field | Bone Shepherd (`bone_shepherd`) | Ossuary Lamb (`ossuary_lamb`) |
|---|---:|---:|
| `unit_name` | Костяной пастух | Костяной агнец |
| `visual_role` | `bone_shepherd` | `ossuary_lamb` |
| `max_hp` | **88** | **44** |
| `damage` | **6** | **7** |
| `attack_interval` | **1.50** | **0.95** |
| `attack_range` | **132** | **45** |
| `minimum_range` | **70** | **0** |
| `move_speed` | **56** | **104** |
| `body_radius` | **21** | **17** |
| `separation_padding` | **11** | **9** |
| `separation_strength` | **112** | **115** |
| `visual_scale` (art-only) | **1.0** | **0.94** |
| `show_enemy_name` | **true** | **false** |
| `support_heal_interval/amount` | **0/0** | **0/0** |
| `splash_radius` | **0** | **0** |

**Distinct silhouettes, non-negotiable:**
- **Shepherd:** a thin *inverted wedge* mourning cloak, sparse large arched ribs/roots holding the empty body, a tall sharply curved **shepherd's crook made of bone**, one muted ember glint and a single torn ritual-crimson cloth strip. **No bell, priestly staff, giant skeletal warrior, crown, shields or metal armour** (avoid legacy Grave Bellkeeper/Crypt Guard silhouettes).
- **Lamb:** low, **four-legged** barrel chest with sparse large “bone wool” plates, small ramlike curving horns, bony pointed muzzle, thick foreleg stance. Strong horizontal silhouette, not a dog/wolf/standard bone raider. Both lambs share the *new* role/sheet, with light authored phase differences permitted (not an extra species).

**Gameplay:** Shepherd maintains space and makes a modest ranged attack using the existing range/cooldown/damage handling. Lambs are new melee harriers, usually attack nearest hero as existing enemy logic does. The special behavior below is their meaningful new feature. No summons, healing, vulnerability aura, jumps, defense debuffs or lingering death fog in this first version.

## 4. Signature encounter mechanic — SHEPHERD'S WHISTLE

**Goal:** telegraphed cooperative movement, a clear opportunity for positioning and a decision about attacking the commander first, without a global status system, unavoidable crowd control or artificial RNG.

### Proposed data tuning (`Resource` is preferred)

| Parameter | Initial value | Meaning |
|---|---:|---|
| `whistle_initial_delay` | **5.5 s** | Earliest first warning after combat starts |
| `whistle_cooldown` | **8.0 s** | Time from an executed rush's start to next warning (never stack effects) |
| `whistle_telegraph` | **0.65 s** | Visible/audible warning, no damage or movement boost |
| `whistle_rush_duration` | **1.25 s** | Temporary ordered charge window |
| `whistle_lamb_speed_multiplier` | **1.35** | Multiplies the lambs' *movement speed only* while rushing |
| `whistle_max_target_distance` | **850 px** | Defensive cap for selecting the shared target on the arena (never teleport) |

Tune from actual in-engine tests; avoid extra scene-independent switches. Prefer a focused **`BoneShepherdWhistleData` Resource** (e.g. `scripts/data/bone_shepherd_whistle_data.gd`, `resources/encounters/bone_shepherd_whistle.tres`) and a small localized controller or role-specific BattleUnit extension. Do NOT add properties to every UnitData if only two creatures need them. The encounter already has two formation positions through `EncounterData`.

### Deterministic behavior state machine

1. At `start_combat`, initialize the whistle to **WAITING**. The first warning occurs **after 5.5 s of active combat**, only if the Shepherd is alive and at least one Lamb is alive. Timers use **combat delta**, not `Time.get_ticks_msec()`, so the v22–v25 manual `BattleUnit._process(1/30)` dev loops can reproduce outcomes.
2. On `WAITING → TELEGRAPH`, find a **single living player target** closest to the **center of alive Lamb positions** (tie break by party order/scene tree index for deterministic behavior). If no valid player unit exists, do nothing. Capture the target reference and show **one low-contrast ritual red/sand whistle ring at the Shepherd + a short identical outline tick above each alive Lamb**. Keep cue for **0.65 seconds**, with no damage, no stun, no speed boost.
3. At `TELEGRAPH → RUSH`, if the Shepherd is alive and at least one Lamb alive: order each living Lamb to temporarily **pursue that same captured player target** for up to **1.25 s**, using existing bounded movement/collision. Multiply movement speed **1.35×** *only for these Lambs*; **do not multiply damage, attack cadence or hit stop**. If captured target has died, choose the nearest remaining valid living hero once; if none, cancel. **Do not teleport** or cross combat bounds.
4. At `RUSH → RECOVERY`, restore baseline speed and normal enemy nearest-target acquisition (clear ordered target lock) **exactly once**. Preserve whatever position/hp/damage the unit reached. No unbounded coroutine/tween applying modifiers twice.
5. After the **8-second interval measured from RUSH start**, and only after the previous rush has expired, allow the next `TELEGRAPH` if Shepherd and Lambs are alive. Never overlap two whistles.
6. **If Shepherd dies in TELEGRAPH:** immediately cancel pending charge and clear visuals. **If Shepherd dies during RUSH:** currently active rush completes its remaining up-to-1.25s window, but no more whistle can start. If one Lamb dies: the surviving Lamb obeys; if both die: skip remaining timer work. If fight ends: clear temporary modifiers/references/sounds, no subsequent signals or lingering state when node is freed.
7. A Lamb moved outside attack range still respects existing attack range/minimum range and emits normal damage through `BattleUnit` path only; moving faster is not a hit. No new collision physics, ally heals, vulnerabilities, summons, crowd-control, screen shake or new AI types for legacy enemies.

### Integration with current production AI (verified existing behavior)

- Currently `BattleUnit._find_preferred_enemy()` calls `_find_nearest_enemy()` for **every enemy**; thus the shared rush-target order needs a narrowly scoped temporary override for **enemy Lambs only** while `rush_active`, NOT changes to hero HUNT priority or to all enemy targeting.
- Currently `BattleUnit._get_current_move_speed()` only special-cases heroes under ASSAULT. Add a bounded role-gated Lamb speed factor during the charge; do not permanently mutate the base `move_speed`.
- Currently `_process()` returns early on hit stop, and enemy target acquisition normally updates only when invalid. During rush set/validate the captured target and return to normal at end; tests should include leader death, target death and hit stop without stuck rush flags.
- Existing `BattleUnit._attack_target()` applies instantaneous damage; preserve this to avoid changing timing in D141–D142 baseline.
- Keep one short VFX cue under `UnitsLayer` linked to actual unit positions, clipped/visible within existing floor bounds; no huge screen overlay. If audio is unavailable, a visible cue alone is acceptable; never invent an audio asset or silently attach an old generic bell sound to a *whistle*.
- Dev tests should explicitly count *one warning, one activation, one clean expiry*, not just compare final W/L. **Do not rely on per-frame visual tween completion for gameplay timers** in manual-simulation tests.

## 5. Exact authored enemy roster / two deployments

Both formations feature exactly three instances in consistent array order:
`[bone_shepherd, ossuary_lamb, ossuary_lamb]`.

`EncounterData` initial coordinates (the existing `Battle._project_spawn_on_floor()` projects **source y-values** onto the actual floor; these are design-source coordinates, not the post-projection final feet):

| Slot | Unit | Variant 0 — **Разделённое стадо** | Variant 1 — **Сближённое стадо** |
|---|---|---|---|
| 0 | Shepherd | `Vector2(1035, 262)` | `Vector2(1090, 270)` |
| 1 | Lamb A | `Vector2(840, 173)` | `Vector2(852, 223)` |
| 2 | Lamb B | `Vector2(848, 355)` | `Vector2(929, 337)` |

Keep x inside the existing 90–1170 combat floor, with unit radius allowance; keep y inside the authored **125–405** source band and distances between source spawns above 48px, same constraints used by the v24–v25 encounter validators. Project through `_project_spawn_on_floor()`, do not set these raw values as post-project scene positions. Use **`arena_id = "graveyard"`** initially (reuses existing graveyard floor *environment* rather than reusing any legacy *enemy*); new custom arena artwork is NOT required to satisfy the player's new-enemy request. Different arena art may be considered separately.

Suggested encounter unit filenames:
- `res://resources/units/bone_shepherd.tres`
- `res://resources/units/ossuary_lamb.tres`
- `res://resources/encounters/bone_shepherd.tres`
- `res://resources/cards/bone_shepherd.tres`

**Invariant:** Both authored variants have exactly identical `enemy_unit_paths` and `enemy_names`; only placements/hints differ. No reinforcements. Do not use legacy `bone_raider.tres` for a placeholder Lamb.

## 6. Original art: exact production deliverables and review checks

### A. Deal illustration (one original scene, not a UI screenshot)

- Subject: crooked tall funeral shepherd standing near a broken cemetery gate, **two** four-legged horned Ossuary Lambs in foreground, separated enough to read all three. Shepherd's hooked crook and Lamb horn outlines must stay visible within **448×274** card-image safe crop. Sparse grave silhouettes, one moonlit horizon, restrained crimson trail in dirt, bronze/warm flicker on crook. No extra ghost, canine/wolf form, healer silhouette, portrait text or invented three-choice buttons.
- Native master: draw larger if needed but deliver **a dedicated 448×274 WebP** consistent with `scripts/ui/card_unification_v1.gd` `RUN_CARDS` expected size (not downscaled from a low-resolution screenshot, not upscaled contact sheet). The actual `RunCardData.art_path` must point to a real committed asset; `RUN_CARDS["bone_shepherd"]` must resolve that image without falling back to legacy atlas. If binary GitHub upload isn't supported by this session's connector, use a **text-based `.webp.b64` asset and a verified minimal loader** like existing unit art, with an explicit path and fail-safe; don't claim an `.webp` binary was committed when it wasn't.
- Keep text as **actual Godot UI type**, not baked into illustration; this avoids erroneous Cyrillic/overflow. Check preview on physical table/Fate Spread at 1280×720.

### B. Battle character sprites and animation sheets (two **original** sheets)

**Character 1:** `bone_shepherd`. **Character 2:** `ossuary_lamb`. Each must be standalone pixel work, not cropping units from the exploratory overall concept image and not reskinning `combat_units_v4`. Use current documented format **6 columns ×5 rows, 96×96 transparent RGBA cells = 576×480 atlas per role**. Align important boots/hoof contacts around the same visible sole baseline in each frame; `BattleUnit.ANIM_SOLE_Y = 92.5` and `FLOOR_CONTACT_Y = 36` indicate presentation constraints, actual art-level offset to be calibrated in engine.

| Row | State | Number of **distinct, authored** frames | Target |
|---|---|---:|---|
| 0 | `idle` | **4** | Subtle real pixel-shape shift / controlled posture |
| 1 | `walk` | **6** | Readable true leg/hoof step cycle |
| 2 | `attack` | **6** | Shepherd crook reach; Lamb horns/lunge, no blurred duplication |
| 3 | `hit` | **3** | Brief real recoil, feet still grounded |
| 4 | `death` | **6** | Clear collapse into cloth/ribs or fall onto side, not floating |

The other atlas cells stay truly transparent. **New role mapping required** in `scripts/battle/unit_animation_library.gd`: add `bone_shepherd` and `ossuary_lamb` to `ROLES`, map to `res://assets/pixel/units/deck_expansion_v1/{role}.webp.b64` (or equivalent real `SpriteFrames` `.tres` flow), not to old Pack 1 or Pack 2 roles. Provide **an original static first-frame fallback of the SAME new creature** if an animation sheet fails; the existing `_get_art_texture()` legacy atlas returns null for unknown roles, which is **NOT an acceptable fallback**. No empty black squares/invisible entities.

**Readability test:** both units distinguishable at **actual 1280×720 arena zoom** and current `ENEMY_DISPLAY_SCALE=1.25`, without names or hover. Lamb legs and hooves must be visible; Shepherd must not sink into the floor ring. The two creatures have strongly distinct tall vs low outlines; enemy orientation correctly flips, no six-finger/extra-limb artifacts, no detached projectile visible as a character sprite, no unrelated ghost. Tone matches DS2 blackened woods/blood red/bronze/moonlit steel, with restrained pixel clusters; avoid excessive AI detail and glows.

### C. One short Whistle cue (code-based acceptable)

Small amber/crimson arc travelling from crook and two brief Lamb highlights. **0.65s** warning, minimum readable at arena scale, may be `Line2D`/Tween like `scripts/battle/unit_attack_visuals.gd`, but no new texture atlas required for cue. Don't reuse Grave Bellkeeper's green concentric bell-wave cue. Limit allocations/effects, self-clean when leader dies or battle ends.

### D. Preview / approval deliverable

Before shipping live combat pool registration, produce a **standalone F6 1280×720 gallery** showing the **actual** new sprite frames in `idle`, `walk`, `attack`, `hit`, `death` and the dedicated **card art in its card frame**, at both native and actual battle scale. Users must be able to inspect real hoof contact and visually compare against existing Knight/Ranger/Mage. The prior single large moodboard is **not** a sprite atlas or evidence of playable art.

## 7. Godot integration files / minimum-churn implementation order

| Step | Path(s) | Change |
|---:|---|---|
| 1 | `assets/pixel/card_unification_v1/run/bone_shepherd.webp` or verified equivalent B64; `assets/pixel/units/deck_expansion_v1/{bone_shepherd,ossuary_lamb}.webp.b64` | Real approved individual images/sprite atlases, no borrowed old characters |
| 2 | `scripts/battle/unit_animation_library.gd`, `scripts/battle/unit.gd`, `scripts/ui/card_unification_v1.gd` | Register only new visuals, matching source dimensions; provide role-specific valid static fallback |
| 3 | `resources/units/bone_shepherd.tres`, `resources/units/ossuary_lamb.tres` | Data fields above, no new UnitData-wide special fields |
| 4 | `scripts/data/bone_shepherd_whistle_data.gd`, `resources/encounters/bone_shepherd_whistle.tres`, focused ability code or a small controller `scripts/battle/bone_shepherd_whistle.gd` | Data-driven timer/telegraph/target order/move-only charge; hook into real scene via exact encounter ID; no globally changed enemy AI |
| 5 | `resources/encounters/bone_shepherd.tres`, `resources/cards/bone_shepherd.tres` | Specific roster, two variants, correct player text and real card art |
| 6 | `scenes/dev/bone_shepherd_preview.tscn`, `scripts/dev/bone_shepherd_preview.gd`; `scenes/dev/bone_shepherd_smoke.tscn` + script | Author art preview, whistle lifecycle regression and small real BattleUnit scenario matrix |
| 7 | `scripts/core/run_state.gd` `CARD_PATHS` and `ACT1_CARD_IDS` | **Register only after** card, enemy sprites, whistle mechanic and tests pass; no dummy placeholder. Re-check Tier0 pool count 11 and forced fight spacing |
| 8 | `docs/PROJECT_STATE.md`, `docs/ROADMAP.md`, `docs/DECISIONS.md` when design changes, `CHANGELOG.md`, `docs/SESSION_CHECKPOINT.md`, `docs/HANDOFF.md` | Truthful status of production/art/Godot PASS and next steps; meaningful commits |

**Implementation caution:** An isolated `Node`/controller under combat `UnitsLayer` makes it easier to keep actual ability timers tied to `BattleUnit` / `Battle` and to clean up on battle end. Current `Battle._spawn_unit()` instantiates units, applies per-party multipliers then adds to `units_layer`; the ability must be bound **after all three enemy units exist**, not during spawning of the first Shepherd. Dev harness must mirror binding. A tiny BattleUnit role-specific optional rush override is acceptable; a generalized enemy behavior framework is not. If current node order requires a safe deferred bind, do it only after unit add, before `start_combat()`.

## 8. Test matrix / acceptance gates

1. **Content integrity static:** unique new IDs don't collide with preexisting `CARD_PATHS` / `ACT1_CARD_IDS`; real resource paths load; Tier0 count 11 after registration; the two formations have same exactly **three new enemy instances**; no ghost/dog/legacy Bone Raider, no nonexistent `art_path`, no surprise event UI.
2. **Mechanic preflight (Godot F6):** when Shepherd+two Lambs alive, first warning begins after 5.5 active battle seconds; cue lasts 0.65s; speed multiplier **1.35** only while rushing for **1.25s**; both pursue same valid hero; no duplicate stacks; restored baseline at end; no unintended additional damage. Repeat cycle once. Kill Shepherd during warning → no rush. Kill Shepherd after rush starts → finish current rush only, no future whistles. Kill one Lamb → surviving Lamb responds. Kill both → no additional effects. Hero target dies → safe retarget or cancel. No visuals/timers linger after combat.
3. **Battles against protagonist Knight, Ranger, Mage** in solo/duo/trio (with fixed teammates), at least **2 authored enemy deployments × 3 hero classes × 3 sizes × 3 baseline orders = 54 deterministic bouts**; no 75s timeouts, errors, stuck invulnerable units or off-floor movement. Start with the Tier0 test build (no unwarranted Tier2 upgrades), then inspect real play. Don't equate all-wins/all-losses with healthy balance; use actual observed traces and adjustment only after evidence. Preserve D141 trace signals.
4. **Card flow:** `RunState.get_card("bone_shepherd")` returns correct `combat` target and real image; new card can actually be offered under current 2-card tier deal logic without duplicate IDs; enemy portrait/preview shows actual new silhouettes; winning returns through reward to the table; losing obeys current run rules; Fate Spread advances correctly; final XIII still triggers at the existing slot. Ensure forced fights are not starved by adding one more Tier0 combat entry.
5. **Visual QA:** screenshot from Godot at **1280×720** confirms card image fit/text readability, Shepherd and both Lambs visibly grounded and recognizably new, full body inside bounds, whistle telegraph visible without busy UI, no image fallbacks/purple placeholders, and correct flip when enemies face heroes.
6. **Regression:** existing seven two-formation encounters unchanged; existing D140 D141 targeting, battle-order behavior and DS2/Fate Spread main screen unchanged. Do not worsen known HUNT or party-size benchmarks without discussing cause.

**Pass definition:** production new-encounter implementation is accepted only when (a) correct original image & creature sheets are committed, (b) actual Godot F6 visual+mechanic checks pass, and (c) user approves in-game appearance and behavior. A source-only static check is **not** an engine PASS, and a standalone moodboard is **not** a playable card.

## 9. Subsequent deck development (explicitly OUT OF SCOPE today)

Only after Bone Shepherd passes: implement the remaining **14** proposed cards in staged packets, each new fight-bearing card receiving **its own true new enemy types and art** under D143. The previous 15-card brainstorm contained **five** fight-bearing candidates despite describing three; reconcile the final approved +15 list and content/art cost before starting multiple new fights. Old D142 controlled HUNT / Knight-duo balance experiments remain a separate task and must not be implicitly 'solved' by a new enemy.

### Source-of-truth / change log

This document is **design/planning only**. No `*.gd` battle logic, `*.tres` card/enemy/encounter content, active sprite art or `RunState` registry has been changed in this production-brief session. Current GitHub repo remains playable as before. The next implementation step is art production with verified source files and a live card/UnitData/EncounterData slice, not another architecture rewrite.
