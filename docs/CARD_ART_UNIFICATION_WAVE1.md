# APPROVED ART BASELINE — 2026-10-13 — last Misdeal card-art concept board

**User decision:** «отлично утверждаем последний визуал». The *last* image generation in the project conversation is the **approved visual master reference for the illustrated Wave 1 card-art direction** (D130). This is a concept board, **not** 13 individual texture files and **not** yet integrated into the game. Distinguish concept approval from runtime asset approval/verification. The native chat attachment is named `мрачный_концепт_арт_misdeal_награда_с_рубином.png` (1536x1024 PNG in the original conversation), generation ID `6c7d5d41-24a1-47f9-8f54-e689bbe265a5`; as of this checkpoint the raster concept master is **conversation-local, not committed to GitHub**. If the reference is not accessible in a fresh session, request/retrieve the already-approved master rather than regenerating from scratch and assuming fidelity.

### Approved exact compositions visible in the final sheet (13 slots)

**Deal cards — Section A (4):**
- `bone_patrol`: moonlit skeleton patrol with one large front soldier and several secondary undead, blue-gray cemetery
- `graveyard_ambush`: hooded/dark ambusher looming behind graves, isolated red eyes and blue moonlight
- `gallows_volley`: **small group of medieval archers shooting bows/arrows toward the gallows; NO guns, muskets or firearms, NO crowd**; exactly the quieter final version
- `whispering_well`: stone well with luminous pale blue spirits, restrained moonlit graveyard

**Event illustrations — Section B (4):**
- `curse_forge`: blacksmith at glowing forge, hot orange sparks against soot-dark stone
- `black_altar`: hooded ritual leader framed by restrained red sigil and candles
- `chained_prisoner`: muscular chained prisoner in gray-blue dungeon, clear pose
- `rattling_bridge`: dangerous narrow suspended bridge, moonlight and one strong silhouette

**Hero upgrades — Section C (3):**
- `knight_iron_oath`: black-armored knight kneeling with sword, worn brass light
- `ranger_arrowstorm`: hooded ranger with bow, flying arrows, cold green-blue environment
- `mage_glass_heart`: **MALE wizard, visibly mature, with a long gray/white beard**, blue-glowing crystalline heart and frosted shards; never the previously generated female mage

**Reward illustrations — Section D (2):**
- `gold_windfall`: antique treasure chest and coin pile lit by warm candles
- `relic_wager`: **anatomically recognizable skeletal/bony HAND holding a single large red faceted gemstone**, with crimson glow and candles; never the prior goblet/metal stand as the primary object

User accepted **all other compositions without further changes** after those iterative corrections. Preserve last board's arrangement, dramatic lighting, dark charcoal/bronze frame grammar, cool steel-blue graves vs ember/orange ritual scenes, and legible focal subjects. Do not add gunpowder weapons, replace the bearded mage with a woman, or replace the skeletal ruby hand with a mounted relic. Do not regenerate the whole board solely to edit one approved item.

### Five Wave 1 targets NOT shown/approved individually on the concept board

`gravedigger_shop`, `bone_swarm`, `grave_crossfire` table thumbnails; `candle_seller`, `last_camp` live event illustrations. These remain in the candidate inventory below and need matching authoring/review later. The concept sheet's four event images and four table cards are distinct art asset categories; do not map event backdrops over table art or vice versa.

### Implementation readiness

**Approved:** 13 concept compositions and unified art direction. **Not done:** generating clean standalone source illustrations (the board has borders, labels and preview insets), exporting to correct native dimensions, verifying imagery at 224x137/304x194/on a live event background, uploading binary assets and wiring `CardArtCatalog` and event visuals. Existing production images remain active. Do not crop text and preview inset from the sheet into final standalone texture; redraw/cleanly reconstruct each as an independent texture *matching* the approved master. Approval to create art ≠ confirmation art is already shipped.

---

# Misdeal — Card Art Unification: Wave 1 Inventory

Date: 2026-10-13  
Status: **13 compositions in the final concept board user-approved (D130); standalone assets and live integration still pending. Five other proposed Wave 1 targets not depicted.**  
Source of truth: `scripts/ui/card_art_catalog.gd`, `scripts/ui/artifact_art_catalog.gd`, `scripts/event/act_choice.gd`, `scripts/event/gravedigger_shop_ds2.gd`, `scenes/event/whispering_well.tscn`, `scripts/core/run_state.gd`, `docs/DESIGN_SYSTEM.md`.

## Scope / guardrails

The existing 1280x720 Design System 2.0 interface and original Fate Spread Variant C are approved (D123-D129). **Only art inside cards and selected nonprotected event backdrops is a candidate for redraw.** Do not replace frames, card geometry, approved Reward/Well/Shop layouts, battle arenas, unit sprites, intro, or splash art. Review artwork at its actual in-game thumbnail scale and in a contact sheet before overwriting live assets. Preserve original textures and fallback until reviewed; no mass atlas overwrite.

Style proposal: intentional dark-fantasy pixel art, chunky deliberate silhouettes, one clearly readable action/object, limited muted blackwood / moonlit blue / ritual crimson / ember / aged bronze palette. Avoid noisy AI-looking detail, complex tiny faces/hands, inconsistent perspective, shiny gold, painterly/pixel-art mixture. Do not embed Russian labels in raster art; keep copy in Godot. A single art direction does not mean duplicating compositions between cards.

## Wave 1 / 18 actual runtime artwork targets

### A. Seven RunCard illustrations, visible on the deal table (all via `CardArtCatalog.get_run_card_texture(card_id)`)

| ID | Existing LIVE source | Art focal point | Priority |
|---|---|---|---|
| `bone_patrol` | `assets/pixel/ui/visual_pass_v4/cards_hd.bin`, cell index 0, 224x137 | approaching skeletal patrol | high |
| `graveyard_ambush` | same v4 atlas, cell 1 | silhouettes emerging from gravestones | high |
| `gallows_volley` | same v4 atlas, cell 2 | gallows and a coherent arrow volley | high |
| `whispering_well` | same v4 atlas, cell 5 | well, mysterious glow, one focal point | high; **only table card**, not approved live Well screen |
| `gravedigger_shop` | same v4 atlas, cell 12 | seller and a single distinctive grave good | high; **only table card**, not approved live shop screen |
| `bone_swarm` | `assets/pixel/ui/combat_expansion_v1/cards/bone_swarm_card.webp`, native 448x274 | dangerous undead group with legible hierarchy | medium, cross-set style check |
| `grave_crossfire` | `assets/pixel/ui/combat_expansion_v1/cards/grave_crossfire_card.webp`, native 448x274 | graveyard crossfire with readable attackers | medium, cross-set style check |

The legacy fallback is `assets/pixel/ui/approved_card_art/run_hd.bin` with a different cell mapping; do not mistakenly edit it thinking it is authoritative. `bone_warden` uses a separate v6 asset, and `broken_crown` may resolve to artifact art; both are held out of Wave 1.

### B. Six actual large event backdrops (non-shop shared `ActChoice`)

| Card ID | Existing LIVE `EVENT_SCENE_ART_PATHS` resource | Primary scene |
|---|---|---|
| `curse_forge` | `assets/pixel/event/v7/curse_forge.webp` | forge, hammer, heat |
| `black_altar` | `assets/pixel/event/v7/black_altar.webp` | ritual altar, restrained crimson |
| `chained_prisoner` | `assets/pixel/event/v7/chained_prisoner.webp` | chained prisoner and one strong gesture |
| `candle_seller` | `assets/pixel/event/v8/candle_seller.webp` | vendor and candle flame |
| `last_camp` | `assets/pixel/event/v9/last_camp.webp` | sparse camp and fading embers |
| `rattling_bridge` | `assets/pixel/event/v9/rattling_bridge.webp` | precarious crossing, clear depth |

All six are referenced by `scripts/event/act_choice.gd`; retain complete 1280x720 environmental compositions appropriate to the live event screen. **Do not conflate these with 224x137 deal-card thumbnails.** The legacy `assets/pixel/event/v7/whispering_well.webp` is NOT the production Well background: `scenes/event/whispering_well.tscn` uses approved `table_exact.webp`. Likewise `assets/pixel/event/v8/gravedigger_shop.webp` exists in the generic event map but the production shop DS2 presenter hides that art and uses approved `table_exact.webp`. Do not waste Wave 1 slots on these dormant backdrops or change approved Well/Shop scenes.

### C. Three hero upgrade illustrations (shared `assets/pixel/ui/approved_card_art/ui_hd.bin`, cells 304x194)

| Upgrade ID | Atlas cell | Purpose |
|---|---|---|
| `knight_iron_oath` | 0 | Knight emblem / iron oath |
| `ranger_arrowstorm` | 4 | Ranger precision / dramatic arrows |
| `mage_glass_heart` | 6 | Mage distinctive magical focus |

Used via `CardArtCatalog.get_upgrade_texture(id)`. Keep approved Reward layout and readable text intact; new art must be approved in context before runtime switching.

### D. Two reward illustrations (same `ui_hd.bin`, cells 304x194)

| Reward art key | Atlas cell | Purpose |
|---|---|---|
| `gold_windfall` | 13 | legible cluster of coins rather than microdetail |
| `relic_wager` | 10 | single occult relic with ominous lighting |

Used via `CardArtCatalog.get_reward_texture(key)`; do not change reward logic, granted content or frozen composition.

## Art/technical production workflow (not implemented yet)

1. Make a contact sheet showing the existing 18 crops at in-game size, compare style/readability; classify keep / touch-up / redraw based on actual imagery, not merely old file names.
2. Produce a small **reference trio** (one run card, one event backdrop, one upgrade/reward) before generating the full batch. Review screenshots or side-by-side samples in the approved DS2 context.
3. For accepted replacements, prefer dedicated new `assets/pixel/.../card_unification_v1/` lossless or WebP textures rather than editing a multi-cell packed source; add explicitly keyed overrides in `CardArtCatalog` and event path table, with fallbacks to existing atlas cells.
4. Preserve native 448x274 landscape card dimensions (2x existing 224x137) where appropriate; upgrade/reward source aspect 304x194 (may author at 608x388), and live event backgrounds 1280x720. Verify aspect ratio, texture filtering and no stretched or blurry art.
5. Preview at 1280x720 in Godot before switching all 18 assets; test table, six events and Reward/upgrade states. Do not alter text/buttons, state, GameData/RunState, shop prices or other gameplay.
6. Only on approval deploy replacements and update `VISUAL_ASSET_REGISTRY.md`, `PROJECT_STATE.md`, `ROADMAP.md`, `DECISIONS.md` when a binding art decision is made, and `CHANGELOG.md`.

This document is a **precise candidate inventory**, not an assertion that every current image is objectively bad. Current art remains the active source until an accepted replacement is committed.
