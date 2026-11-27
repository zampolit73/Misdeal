# HUD Visual V2 — Table and Battle design candidate

2026-11-27, baseline main `735094e6`. The player asked whether the two top HUD groups shown in their native screenshots should be redesigned, and requested a review concept. **Await visual approval before implementation.** No production nodes, art, logic, tests or gameplay changed.

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

Existing banner and medallion fragments remain independent. 26 pt gold encounter, 17 pt ivory status, 23 pt progress, 14–15 pt modifer rows. Omit repeated exact encounter prefix in status presentation only, not guidance or changing status. Keep actual solo/duo/trio scaling, enemy pressure, extra debt/mark/oath/one-use-order/Last Deal conditions and full tooltip, team labels including wave/boss state. Use actual existing run state and encounter data, with responsive fit for longer localized copy. No change to existing battle timing, bottom V4 planner, active-order HUD, result, geometry, enemies, modifiers or saves.

## Implementation gate

Player approval of these two directions, then implement opt-in on only the existing HUD controls with real data. Targeted native checks: 1280×720 table start and later condition/long dialogue; solo/duo/trio battle, two waves and boss/conditional modifiers; no baked duplicate or overlapping layout. No broad retest requested. No native V2/engine acceptance is claimed yet.
