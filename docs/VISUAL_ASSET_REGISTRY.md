# Misdeal — Active Visual Asset Registry

## D182–D183 — Black Crossing card artwork (native F6 approved)

Chosen **third** image: diagonal ruined pier, ferryman above right, two drowned undead low left. `assets/pixel/card_unification_v1/run/black_crossing_approved_v1.webp.b64` (448×274 WebP from selected image; remote bytes verified). F6: `res://scenes/dev/black_crossing_card_preview.tscn` — user screenshot and explicit «утверждено», **PASS**. Original approved Ferryman/Drowned sprite atlases are shipped and user F6-approved (D186); the user-approved final stormy battle arena is now `assets/pixel/battle/arenas/black_crossing_storm_pier_approved_v1.webp.b64` (1280×720; native F6 accepted by user, D187). Live Act1 is **37/45** following D198 Black Crossing release; D196 storm-wave VFX is held as the current version. Native D198 random-deal release smoke was user-confirmed PASS; D196 surf remains the accepted-for-now visual baseline.

Updated: 2026-10-16 (D198). **Approved assets must not be replaced during cleanup.**

## D153 — approved production assets

- Card illustration (scene-led, 448×274): `assets/pixel/card_unification_v1/run/threadbare_theatre_approved_v1.webp.b64`.
- Battle environment (1280×720): `assets/pixel/battle/arenas/threadbare_theatre_approved_v1.webp.b64` — moonlit ruined theatrical backstage, asymmetric stairs/rigging, dark crimson fabric, clear unit floor. Approved after multiple lower-noise concept iterations.
- Skeletal Puppeteer atlas: `assets/pixel/units/deck_expansion_v1/threadbare_puppeteer_frames.webp.b64`.
- Skeletal Marionette atlas: `assets/pixel/units/deck_expansion_v1/bone_marionette_frames.webp.b64`. Both 576×480, 25 frames, approved redesigned character appearances.
- Old/rejected D153 atlas bytes remain in Git history/versioned backups for rollback. Do **not** swap to old generic mini-skeletons or copy the card bitmap onto the battlefield.
- Card-art quality bar: D167 scene-first; D168 show 3 actual art alternatives before finalization; avoid obvious replicated castles, micro-detail and generic AI decorative clutter.

## Prior visual registry (still useful for assets and rollback)

The detailed inventory of V1–V9 image paths, Godot loaders, DS2 details and prior Combat Expansion artwork below is a **historical inventory** and may include outdated release-status notes. Current gameplay state is always `docs/PROJECT_STATE.md`. Complete originally prefixed material is archived at `docs/archive/2026-10-15-pre-cleanup/docs/VISUAL_ASSET_REGISTRY.md`.

---

# Misdeal — Visual Asset Registry

Last updated: 2026-10-11

Purpose: make visual-source provenance and runtime mapping recoverable from GitHub without reading old chats.

## Canonical loading rules

- Dynamic text/state/buttons remain native Godot UI.
- Full-screen authored WebPs added through recent passes use runtime decoding through `scripts/ui/runtime_webp_texture.gd` or an equivalent battle-specific runtime decoder.
- New screen art should be native 1280×720 when it fills the viewport.
- Table-card art should stay near live display size or better; do not recreate the rejected 112×69 atlas approach.
- Source/master archives are not runtime dependencies.

## Production visual passes

### Card art

- v4: `assets/pixel/ui/visual_pass_v4/` — accepted corrected near-display redraw atlas.
- v5: `assets/pixel/ui/visual_pass_v5/` — completion batch for remaining table cards.
- v6 Bone Warden card: `assets/pixel/ui/visual_pass_v6/bone_warden_card.webp`.
- Broken Crown table card deliberately shares the approved Broken Crown artifact illustration.

All 25 active Act 1 cards resolve to current matching/object-specific art before legacy safety fallback.

### Battle arenas

Canonical live art: **Arena Redraw v2 (approved pack 1)**, integrated 2026-10-11. Ten arena IDs use native 1280×720 WebP assets in `assets/pixel/battle/arenas/arena_redraw_v2/`. The remaining two retain the prior v1 Base64-WebP payloads until pack 2 is approved and implemented.

| arena_id | Runtime source | Format |
| --- | --- | --- |
| `crypt` | `arena_redraw_v2/crypt.webp` | WebP bytes |
| `graveyard` | `arena_redraw_v2/graveyard.webp` | WebP bytes |
| `gallows` | `arena_redraw_v2/gallows.webp` | WebP bytes |
| `ossuary` | `arena_redraw_v2/ossuary.webp` | WebP bytes |
| `warden` | `arena_redraw_v2/warden.webp` | WebP bytes |
| `bone_crush` | `arena_redraw_v2/bone_crush.webp` | WebP bytes |
| `bone_swarm` | `arena_redraw_v2/bone_swarm.webp` | WebP bytes |
| `grave_crossfire` | `arena_redraw_v2/grave_crossfire.webp` | WebP bytes |
| `iron_wall` | `arena_redraw_v2/iron_wall.webp` | WebP bytes |
| `last_bell` | `arena_redraw_v2/last_bell.webp` | WebP bytes |
| `firing_square` | `arena_redraw_v1/firing_square.webp.b64` | Base64 WebP text |
| `bone_ritual` | `arena_redraw_v1/bone_ritual.webp.b64` | Base64 WebP text |

`scripts/battle/authored_backdrop.gd` is the authoritative live selector. It loads raw `.webp` bytes for the approved new pack and decodes legacy `.webp.b64` for the remaining two arenas; both paths create an `ImageTexture` and use nearest-neighbor fallback resizing. Live unit sprites, HUD, tactics, deployment and encounter data remain unchanged.

The new visual direction limits each environment to one dominant meaningful landmark, believable geography and a broad readable central combat floor. It preserves the existing Misdeal blue-black moonlight, warm firelight and restrained crimson gothic identity while avoiding repetitive AI-looking castles. The earlier `arena_redraw_v1`, `visual_pass_v4/v6` and `combat_expansion_v1` assets remain in Git history/repo for rollback. The 1672×941 PNG generation masters remain in the conversation package `misdeal_arena_redraw_pack1_review.zip`; the committed native WebPs are the complete runtime sources.

See `docs/ARENA_REVIEW_2026_10_11.md` for the approved arena-to-landmark map and local-validation checklist.

### Main menu

- Canonical main splash: `assets/pixel/main/approved_splash_hd/main_splash.webp`
- Runtime scene: `scenes/main/main.tscn`
- Runtime loader: `scripts/main/approved_main_backdrop.gd`
- Production size: 1280×720 WebP
- Accepted direction: restrained dark-gothic Wizard at the cursed table, reduced prop noise, red-black-gold foreground against cool moonlit city, live hotspot/UI kept outside the art.
- Superseded: the older compressed three-part splash and the intermediate over-rendered/off-model Wizard redraws.

### Wizard table

- Canonical runtime plate: `assets/pixel/table/approved_variant_c/table_exact.webp` (1280×720)
- Approved source master: `assets/source_archive/table/approved_variant_c/table_exact_master.webp` (1672×941)
- Approved normal-table composition: **final Variant C** — restrained oval ritual tabletop, Wizard centered behind it, two offer cards near the player, physical deck/discard holders at the sides.
- Superseded normal-table backdrop: `assets/pixel/table/visual_pass_v6/table_wizard.webp` (kept in repository history/assets, no longer referenced by `table.tscn`)
- Procedural `scripts/table/table_visual.gd` and `scripts/table/table_spread_visual.gd` remain available but are hidden on the canonical normal table.
- Scene/runtime logic: `scenes/table/table.tscn`, `scripts/table/table.gd`
- The full approved plate is the runtime visual foundation; run-specific cards, counts, Hold state, Wizard text and buttons remain live Godot UI aligned over it.
- Detailed run progress is not duplicated here; `РАСКЛАД СУДЬБЫ` owns the full I–XIII progression view.
- Important: authored table art bypasses the old heavy environment/card grade.
- Shared neutral card back: `assets/pixel/table/card_back_runtime.svg`.
- Runtime foundation rule: the two baked sample offer faces in `table_exact.webp` are permanently covered by neutral physical card backs beneath the live offer layer. Do not restore dark cleanup masks.
- Fate Spread Hold uses the same back when empty; Wizard Discard hides when empty and uses the back as the physical frame under the live top card when populated.
- Local status: the physical card-back pass is committed; local 1280×720 verification is pending.
- Visual lock: Fate Spread is frozen; the exact Variant C plate is the canonical normal-table art. Do not return to the procedural oval-table approximation.

### V7 high-visibility screens

- Knight portrait: `assets/pixel/class_select/v7/knight.webp`
- Ranger portrait: `assets/pixel/class_select/v7/ranger.webp`
- Mage portrait: `assets/pixel/class_select/v7/mage.webp`
- Reward: `assets/pixel/reward/v7/reward_backdrop.webp`
- Whispering Well: `assets/pixel/event/v7/whispering_well.webp`
- Curse Forge: `assets/pixel/event/v7/curse_forge.webp`
- Chained Prisoner: `assets/pixel/event/v7/chained_prisoner.webp`
- Black Altar: `assets/pixel/event/v7/black_altar.webp`
- Run End: `assets/pixel/run_end/v7/run_end.webp`

The same portraits are reused by Squad Dossier.

### Event choice mini-art

- Runtime mapping: `scripts/ui/approved_event_choice_art.gd`, consumed by `scripts/event/act_choice.gd` and `scripts/event/whispering_well.gd`.
- Visual rule: context art describes the event; mini-art describes the action. One dominant object/gesture/action is preferred over three repeated crops of the event image.
- Native 384×160 choice cells are preferred whenever an approved source already exists; the compact 192×80 sheet is now a fallback source, not the desired presentation size.
- Native Rattling Bridge source: `assets/pixel/event/choice/rattling_bridge_hd/` — 1152×160, three 384×160 cells: rescue / bag / walk away. Used for both bridge branches and as generic rescue/bag/leave actions where semantically truthful.
- Native approved Well/Prisoner atlas: `assets/pixel/ui/approved_event_choice_polish/event_choice_atlas.bin` — 1152×320, six 384×160 cells. Provides whisper, coins, occult-card, broken-chains and body-search actions.
- Compact approved sheet: `assets/pixel/event/choice/approved_choice_sheet_v2/` — 576×320, 192×80 cells. It remains the source for the approved Black Altar blood-sacrifice and cursed-offering cells; runtime reconstructs it before use.
- Reusable action vocabulary exposed by `ApprovedEventChoiceArt.get_action_texture()`: `rescue`, `bag`, `leave`, `whisper`, `coins`, `occult_card`, `chains`, `loot_body`, `blood`, `cursed_relic`.
- Explicit semantic event mappings now include Rattling Bridge, Whispering Well, Chained Prisoner, Black Altar recruitment, Lost Purse, Debtor Bones, Wizard Tithe, Blood Ledger, Bone Tax, Ash Rest recruitment and Last Camp recruitment.
- Curse Forge continues to use actual artifact art because its three choices are concrete relics.
- Role-development choices continue to show the actual offered upgrade art.
- Broken Crown now shows crown / coins / actual offered upgrade (or cursed-relic fallback) instead of three copies of the crown.
- Superseded runtime path: `assets/pixel/event/choice/black_altar_recruitment.svg`.


### V8 secondary event screens

| card_id | Runtime art |
| --- | --- |
| `candle_seller` | `assets/pixel/event/v8/candle_seller.webp` |
| `gravedigger_shop` | `assets/pixel/event/v8/gravedigger_shop.webp` |
| `blood_ledger` | `assets/pixel/event/v8/blood_ledger.webp` |
| `faceless_card` | `assets/pixel/event/v8/faceless_card.webp` |

### V9 final generic-event screens

| card_id | Runtime 1280×720 art | Archived generated master |
| --- | --- | --- |
| `rattling_bridge` | `assets/pixel/event/v9/rattling_bridge.webp` | `assets/source_archive/visual_pass_v9/rattling_bridge_master.webp` |
| `lost_purse` | `assets/pixel/event/v9/lost_purse.webp` | `assets/source_archive/visual_pass_v9/lost_purse_master.webp` |
| `debtor_bones` | `assets/pixel/event/v9/debtor_bones.webp` | `assets/source_archive/visual_pass_v9/debtor_bones_master.webp` |
| `bone_tax` | `assets/pixel/event/v9/bone_tax.webp` | `assets/source_archive/visual_pass_v9/bone_tax_master.webp` |
| `wizard_tithe` | `assets/pixel/event/v9/wizard_tithe.webp` | `assets/source_archive/visual_pass_v9/wizard_tithe_master.webp` |
| `ash_rest` | `assets/pixel/event/v9/ash_rest.webp` | `assets/source_archive/visual_pass_v9/ash_rest_master.webp` |
| `last_camp` | `assets/pixel/event/v9/last_camp.webp` | `assets/source_archive/visual_pass_v9/last_camp_master.webp` |
| `broken_crown` | `assets/pixel/event/v9/broken_crown.webp` | `assets/source_archive/visual_pass_v9/broken_crown_master.webp` |

Original V9 generated filenames from the conversation:

- Rattling Bridge — `лунный_мост_над_проклятым_ущельем.png`
- Lost Purse — `лунная_дорога_среди_мёртвых.png`
- Debtor Bones — `лунный_алтарь_костяных_костей.png`
- Bone Tax — `лунный_костяной_алтарь_у_готических_врат.png`
- Wizard Tithe — `готический_алтарь_под_полной_луной.png`
- Ash Rest — `готический_лагерь_под_полной_луной.png`
- Last Camp — `одинокий_лагерь_под_готическим_собором.png`
- Broken Crown — `разбитая_корона_в_лунных_руинах.png`

The archived masters are 1672×941 Q95 WebP exports from those generated PNGs. The runtime copies are separate 1280×720 production assets.

## Rejected / superseded art paths

### Rejected low-resolution v3

The broad v3 integration used roughly:

- 112×69 card cells;
- 320×180 arena cells.

It was locally rejected because upscaling produced muddy/blocky presentation. Do not restore this pipeline.

### Strong double grading

Legacy environment/card grade on already-dark authored art caused black crush on battle/table/event screenshots. Current authored surfaces either bypass it or use substantially reduced fallback strength.

### Generated full-screen UI mockups

Approved mockups may guide composition, but baked gameplay values/buttons/text are not production runtime UI. Preserve live Godot controls.

## Source preservation

Earlier production passes (v4-v8 and battle/table v6) are already recoverable from their committed runtime assets and Git history.

V9 additionally keeps larger source masters under `assets/source_archive/visual_pass_v9/` because these were the last generated images immediately before the transition away from broad art replacement.

If a future pass needs a different crop or export, start from the archived master where available rather than regenerating a new scene.

## Combat Expansion v1 dedicated visual set — 2026-10-11

The six gameplay-test encounters now have approved dedicated arena and card exports.

| Encounter | Battle backdrop | Table card |
| --- | --- | --- |
| `bone_swarm` | `assets/pixel/battle/arenas/combat_expansion_v1/bone_swarm.webp` | `assets/pixel/ui/combat_expansion_v1/cards/bone_swarm_card.webp` |
| `grave_crossfire` | `assets/pixel/battle/arenas/combat_expansion_v1/grave_crossfire.webp` | `assets/pixel/ui/combat_expansion_v1/cards/grave_crossfire_card.webp` |
| `iron_wall` | `assets/pixel/battle/arenas/combat_expansion_v1/iron_wall.webp` | `assets/pixel/ui/combat_expansion_v1/cards/iron_wall_card.webp` |
| `last_bell` | `assets/pixel/battle/arenas/combat_expansion_v1/last_bell.webp` | `assets/pixel/ui/combat_expansion_v1/cards/last_bell_card.webp` |
| `firing_square` | `assets/pixel/battle/arenas/combat_expansion_v1/firing_square.webp` | `assets/pixel/ui/combat_expansion_v1/cards/firing_square_card.webp` |
| `bone_ritual` | `assets/pixel/battle/arenas/combat_expansion_v1/bone_ritual.webp` | `assets/pixel/ui/combat_expansion_v1/cards/bone_ritual_card.webp` |

Production sizing:
- battle: 1280×720 WebP;
- card: 448×274 WebP.

These exports were cropped from the six user-approved composite concepts generated for Combat Expansion v1. The former semantic card aliases are retired. Bone Raider and Crypt Sentinel still intentionally reuse existing production unit silhouettes pending mechanical validation.

### Combat Expansion v1 archived composite masters

The approved generated composites used to derive the live arena/card exports are preserved for recropping:

- `assets/source_archive/combat_expansion_v1/bone_swarm_composite_master.webp`
- `assets/source_archive/combat_expansion_v1/grave_crossfire_composite_master.webp`
- `assets/source_archive/combat_expansion_v1/iron_wall_composite_master.webp`
- `assets/source_archive/combat_expansion_v1/last_bell_composite_master.webp`
- `assets/source_archive/combat_expansion_v1/firing_square_composite_master.webp`
- `assets/source_archive/combat_expansion_v1/bone_ritual_composite_master.webp`

These 1055×1491 source composites contain the approved arena concept in the upper portion and the approved card illustration in the lower portion. Use these masters rather than regenerating the concepts if a crop or export needs adjustment.

