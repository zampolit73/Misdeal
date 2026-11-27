# HUD Visual V2 — approved Table and Battle reference

2026-11-27, baseline main `735094e6`. The player asked whether the two top HUD groups shown in their native screenshots should be redesigned, and requested a review concept. Player approved both concepts on 2026-11-27. Production HUD presentation is implemented using live game data, with no change to existing gameplay or artwork. [Implementation and QA](../../../docs/qa/hud_visual_v2/README.md).

## Full-size offline references (1280×720)

- [Table](table_hud_v2.webp) — five grouped live statistics and a dedicated Wizard dialogue plaque.
- [Battle](battle_hud_v2.webp) — encounter / guidance plaque and separate readable run modifiers. Original team emblems, heroes, arena and lower Combat Planning V4 preserved.

These are composited layouts over the player's actual game captures, not native runtime screenshots of V2. Exact existing Menu V2 secondary texture, 18 px nine-slice and contour alpha from SystemDialog; existing D300 banner/medallion, current Table and arena artwork. Screenshot annotations are removed in the candidate using the original sources. No generated new illustration or runtime bitmap. The lower gameplay areas of the uncompressed previews matched the player frames pixel for pixel; archived WebP is a compressed visual reference.

## Layout at reference resolution

| Table | Rect (x,y,w,h) |
|---|---|
| Statistics | 312,13,656,54 |
| Wizard | 336,66,608,40 |

Five separate label/value cells inside one common plate, with thin dividers. 13/24 pt muted bone/gold type. Wizard speaker label plus 16 pt italic live copy. Preserve conditions, dynamic progress including XIII, currency, party, development and relic counts. The source `table_clean.webp` contains baked legacy HUD plates: fully cover their old contours instead of allowing their fake values to show. Keep new dialogue above face and fit longer text/conditional state without collision. Preserve existing animation, input, navigation, card positions, memory window and saved-run semantics; existing full copy available on overflow.

| Battle | Rect |
|---|---|
| Encounter/status | 23,12,837,96 |
| Progress/modifiers | 873,12,385,96 |

Existing banner and medallion fragments remain independent. 26 pt gold encounter, 17 pt ivory status, 23 pt progress, 14–15 pt modifier rows. Omit repeated exact encounter prefix in status presentation only, not guidance or changing status. Keep actual solo/duo/trio scaling, enemy pressure, extra debt/mark/oath/one-use-order/Last Deal conditions and full tooltip, team labels including wave/boss state. Use actual existing run state and encounter data, with responsive fit for longer localized copy. No change to existing battle timing, bottom V4 planner, active-order HUD, result, geometry, enemies, modifiers or saves.

## Native acceptance gate

Both directions are approved and implemented. Conditional Table statistics extend upward to (312,0,656,67); long Wizard and battle text fits the approved bounds, with full content accessible on hover. Headless targeted tests and both existing smoke checks passed. Native player checks: Table and one battle at 1280×720; check longer text/conditional state and second wave if available naturally. No native V2 framebuffer capture or player acceptance is claimed yet.
