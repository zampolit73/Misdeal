# D199 — Дорога чёрных фонарей / Road of Black Lanterns

Date: 2026-10-16
Status: **D200 THIRD production art option selected and installed at 448×274 for native card QA (not yet Godot-approved); five enemy sprites, arena, battle logic and combat QA NOT implemented.** Live Act 1 remains 37/45.

## Exact user selections (binding)

1. From 3 candidate card #38 concepts, user explicitly chose **option 3 — «ДОРОГА ЧЁРНЫХ ФОНАРЕЙ»**, a combat encounter with alternating lantern-light and darkness on an old forest road.
2. From the 3 first scene illustrations the user chose **the FIRST**, the moonlit muddy forest road with suspended warm lanterns, bare trees and distant gothic ruin. User asked to remove AI-generated visual noise and preserve the skeleton-dominated Act 1 identity.
3. User insisted on **MORE THAN THREE combat enemies**, predominantly skeletons. A subsequent cleaner illustration introduced four small skeletons and a lead lantern skeleton.
4. User required the **main Lantern Guide to be around 2× the height** of the other skeletons, visually powerful rather than merely a larger copy.
5. User asked to distinguish that giant guide unmistakably from the followers, so the last AI-generated **character/encounter concept sheet** gave him a unique cloaked/armoured silhouette, chains, pole-like lantern yoke and multiple heavy lanterns. User then replied **«последняя концепция подходит»** — this is approval of the last reference sheet and 5-role identity.
6. **Latest approved sheet reference:** this conversation, generated image id `6fadac31-7e69-40c7-878f-1cb7602bbd75`, upload `a_wide_detailed_pixel_art_concept_game_design_lay.png` (`file_00000000041c81f7bae21d0c53926e17`). The sheet includes printed Russian annotations and panels: **DO NOT use the sheet as the in-game card artwork or arena texture.** Its visual direction is approved, but separate text-free production media must be made and checked.

## D200 — selected production card illustration (third of a NEW group)

Following the approved five-role concept sheet, the assistant rendered **three further standalone scene illustrations**. The user explicitly selected **the THIRD** with «третий арт лучше всего подходит», then requested «продолжай». **This newest choice supersedes the initial first-of-three environment moodboard preference for the final card image**, while keeping the original moonlit road language and all five enemy identities. Do not confuse third art in the NEW D200 group with option 3 of the older D199 gameplay selection.

- Chosen original chat image: `лунный_марш_скелетного_легиона.png`, generation ID `f1821747-a46a-4e58-9fd9-9fd2b0f0a214`, file ID `file_00000000e49081f781fea566239097d4`, original 1604×981.
- Exact chosen scene resized without recropping silhouettes or rerendering to a text-free **448×274 WebP**, committed to `assets/pixel/card_unification_v1/run/black_lantern_road_selected_v1.webp.b64` (D200). This is a selected-source conversion, not a new AI repaint, so the tall Guide and four escort skeletons are preserved.
- Native loader `scripts/ui/card_unification_v1.gd` checks decoded WebP dimensions and caches texture; `scripts/ui/card_art_catalog.gd` automatically uses it via the existing unified-art priority.
- **QA-only** `resources/cards/black_lantern_road.tres` is Tier1 combat but has **no encounter target yet**; standalone F6 `res://scenes/dev/black_lantern_road_card_preview.tscn` loads the exact resource/image. Do not select the QA card through normal dealing until a real encounter is built.
- **Native F6 card preview acceptance is still PENDING.** The prior user approval applies to the 1604×981 third image, not to a Godot 448×274 render log. Never claim F6 PASS in advance.

## Combat identity, one encounter with five DISTINCT skeleton enemies

| Russian role | Proposed resource id | Battle identity / visual silhouette |
| --- | --- | --- |
| **Погасший проводник** (leader) | `extinguished_guide` | Towering roughly **2× body height** compared with soldiers, broad hunching ragged black mantle/irregular shoulder plates, a distinctive tall metal lantern frame, several heavy lanterns and long hanging chains; controls light; visibly not just a rescaled foot soldier |
| **Носильщик фонаря** | `lantern_bearer` | Normal-size thick-boned skeleton carrying heavy lantern and wooden barricade/guard plank; defensive cover |
| **Страж дороги** | `road_sentinel` | Normal-size skeleton with long spear, guards the route and pins intruders at reach |
| **Масляный служка** | `oil_acolyte` | Fast light-boned skeleton with oil vessel/sickle and flickering hand lantern; pressure and support |
| **Стрелок фонарей** | `lantern_archer` | Thin skeleton archer with lantern attached to bow or harness; ranged threat |

Proposed authored roster = **5 total simultaneously present enemies** (one of each archetype); two authored formations rearrange their spacing, with all five roles unchanged. This directly responds to the user's request for >3 actual enemies, not merely multiple costume options. Tune solo/duo/trio only after a native matrix; five enemies and a double-height visual leader must NOT automatically imply double collider radius, double melee reach or impossible solo difficulty.

**2× means recognisable illustrated/sprite body height relative to standard skeletons at equivalent battle ground depth, not just moving the pivot or enlarging a canvas.** All boots must meet the same real ground line, with intact recognizable silhouette, correctly turning toward opponents. The leader's combat origin and move region stay on the road; frame height must not hide health bars or tactics.

## Distinct encounter-local gameplay mechanic — travelling lanternlight

The forest road is dark except for **two moving pools of lantern light**. During battle these zones wind up clearly, relocate and settle, alternating the safe/dangerous emphasis. **Enemies inside an active light zone get a short, visible combat advantage** (candidate implementation: faster attacks; exact multiplier/timers TBD from code inspection and balancing). Units in darkness have their normal stats; no new global accuracy/evasion system solely for this card. The player counterplay is formation, targeting and movement relative to the announced zones. The giant Guide visually cues where the light will go next. Do not replicate D188's seaward push lane, D152 chemical damage puddle or D153 puppeteer tethers; lanternlight is a telegraphed **temporary advantage zone**, not instant unavoidable damage.

Values still subject to native QA: light-zone count/diameter, cycle length, initial warning, buff and any leader-death interaction. Aim for readable battle under 60–90 seconds with five enemies and three party-size modes, no oppressive solo punishment. Implement only through a scoped Godot `.gd` controller and resources when art assets and exact mechanic have been prepared.

## Art contract / next production gates

- **Card illustration D200:** the user-chosen THIRD standalone illustration is now installed as QA-only **448×274** art under `black_lantern_road_selected_v1.webp.b64`, with original 1604×981 scene reference above. Check F6 before marking the runtime appearance approved. The earlier first-of-three is mood reference only, and the labelled design sheet is not runtime artwork.
- **Battle arena**: separately author a clean, 1280×720 environment with broad flat walkable middle road and an unambiguous lane for the actual hero/enemy deployment. Hanging lantern posts on margins/behind unit plane, no decorative obstacles drawn across the valid walkable combat floor.
- **Five new enemy sprite atlases**: distinct readable silhouettes (including double-height Guide), real full-body idle/walk/attack/hit/death animation states, in the existing 25-pose grid contract if the D153/D188 pipeline is reused. The concept-sheet character panels are static illustrations, **not** animation sprite sheets. Do not pretend an unanimated cropped illustration is native-tested art.
- **Encounter**: data-driven card `RunCardData`, `EncounterData`, five new `UnitData`, two 5-enemy placements and a local light-zone controller. Register into `CARD_PATHS` for QA first, **not** into `ACT1_CARD_IDS` until smoke and real reward route PASS.
- QA: distinct art/card preview; original unit gallery and full-body feet/facing; arena readability; 2 formations × 3 protagonists × 1/2/3 party sizes × 3 tactics = **54 deterministic combat trials** (if the existing D191 fixture pattern still fits), including conditional leader death and buff cleanup; native gameplay battle → reward → table; full-pool random deal release smoke, only then **38/45**.

## Non-goals

No changes to the D198 released #37, its D196 waves, approved variant-3 card art, DS2 / Fate Spread C, 12 + XIII structure, global party compensation or C# migration. Avoid overbuilding generic dynamic-light systems before this local encounter is playable. Keep explicit user approval gates for final card and production enemy/arena assets.
