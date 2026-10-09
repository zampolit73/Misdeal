### Fate Spread

- Approved visual direction: ornate physical occult table with red ritual cloth, candle/brass highlights, gothic edge props and chained XIII as the central focal point.
- Approved runtime plate: `assets/pixel/table/fate_spread/fate_spread_exact.webp`
- Live scene: `scenes/table/fate_spread_overlay.tscn`
- Live logic: `scripts/table/fate_spread_overlay.gd`
- Approved source master: `assets/source_archive/fate_spread/fate_spread_exact_master.webp`
- Earlier edge-art masters remain archived under `assets/source_archive/fate_spread_edges/` but are no longer runtime assets.
- Rule: the plate is atmosphere only. I–XII history, XIII state, counters, hold/discard contents and decision memory remain live Godot UI.
- The full plate defines the physical composition. Baked run-specific examples are covered by live masks/cards; `RunState` remains authoritative for cards, counts, Hold/Discard and XIII.

# Misdeal — Visual Asset Registry

Last updated: 2026-10-09

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

- Crypt: `assets/pixel/battle/arenas/visual_pass_v4/crypt.webp`
- Gallows: `assets/pixel/battle/arenas/visual_pass_v4/gallows.webp`
- Graveyard: `assets/pixel/battle/arenas/visual_pass_v6/graveyard.webp`
- Ossuary: `assets/pixel/battle/arenas/visual_pass_v6/ossuary.webp`
- Warden: `assets/pixel/battle/arenas/visual_pass_v6/warden.webp`
- Bone Crush: `assets/pixel/battle/arenas/visual_pass_v6/bone_crush.webp`

Battle runtime mapping lives in `scripts/battle/authored_backdrop.gd`.

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
- Local status: exact-art integration is committed; first post-integration screenshot is still pending. Future work should be pixel-level alignment/masking only unless the user changes direction.

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
