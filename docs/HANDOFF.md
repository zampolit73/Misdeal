# Misdeal — Canonical Working Handoff

Updated: 2026-10-16 — **D200 selected THIRD production card art integrated QA-only, Godot F6 acceptance next**.

Source of truth: `zampolit73/Misdeal`, branch `main`. The assistant has direct connected GitHub read/write tools; do not ask the user to paste code, repeat project history or grant GitHub access without checking. Godot **4.7.x / GDScript**, no C# migration. Start a new chat by reading `AGENTS.md`, `docs/CONCEPT.md`, `docs/PROJECT_STATE.md`, `docs/ROADMAP.md`, `docs/DECISIONS.md`. Other references: `docs/INDEX.md`.

## Current exact milestone — Act 1 37/45 LIVE

RunState.ACT1_CARD_IDS includes 37 unique cards:
- #34 `funeral_procession`: original Funeral Priest + Pallbearers, Last Rite.
- #35 `defiled_laboratory`: original Alchemist + Homunculus, chemical hazards.
- #36 `threadbare_theatre`: **skeletal** Puppeteer + Marionettes, thread tethers; native D178 54/54 and D181 release-smoke PASS.
- #37 `black_crossing` / «Чёрная переправа»: original drowned Ferryman + 2 Drowned, two authored formations, storm surge.

The fate spread has **12 resolutions** then only sealed Bone Warden **XIII**. Eight more cards are planned to reach 45.

## Locked art, battle and native QA for Black Crossing #37

- Chosen card illustration **option 3** (448×274): `assets/pixel/card_unification_v1/run/black_crossing_approved_v1.webp.b64`.
- Ferryman **B** / Drowned **C** source-derived original 25-pose atlases, accepted D186.
- Stormy battle arena **«Последний причал»** 1280×720: `assets/pixel/battle/arenas/black_crossing_storm_pier_approved_v1.webp.b64`, accepted D187. Do not restore left rock towers or right timber frames that the user asked to remove.
- **D189** unit movement, placement, and sea push restricted to intact **upper pier planks**.
- **D191 native 54/54 combat PASS**, 0 full-party defeats, 18/18/18 wins per solo/duo/trio and Knight/Ranger/Mage; mean HP 86/74/77%, worst 58/42/50%. Storm effects: 78 warnings, 62 impacts, 66 pushes, 66 slow resets.
- **D196 visual baseline:** advancing breaker 94px with foam and runoff. User said **«давай пока оставим этот. продолжай»** — leave surf as-is, do not resume wave tuning without new user request.
- Local mechanics: initial delay 3.2s, warning 1.4s, wave push 43px left, temporary movement slow 30% for 1.6s on both factions, no raw damage, rest 4.5s. No global encounter or balance changes.
- **D197 Godot native real route user-confirmed:** preflight → actual Battle → Reward → Fate Spread/Table; user replied **«Все ок»**.
- **D198 Godot native release smoke USER-REPORTED PASS:** following `git pull` and F6 `res://scenes/dev/black_crossing_release_smoke.tscn` request, user replied **«все ок»** (2026-10-16). This is user-provided success feedback (not an independently captured Godot console/screenshot). Treat release QA gate as closed; do not request repeat D198 smoke.
- D198 `main` has card #37 registered for ordinary random Tier1 offers and updates former 36-card guards across previous smoke scenes. The release smoke verifies 37 unique cards, full live 37-card pool via **80 deterministic Tier1 random-deal trials**, selected encounter/choice/resolution, Fate Spread and boss XIII.

**No D198 tasks remain**; do not reopen #37, its asset selection, waves or balance unless the user identifies a new problem.

## D199 — approved choice for card #38 (selected, NOT implemented)

After several generated scene alternatives, user **selected gameplay option 3** («Дорога чёрных фонарей») and **scene art option 1** (moonlit muddy forest road, warm hanging lanterns, barren trees, distant gothic ruins). User required less generic AI-detail noise, Act1 skeleton-driven enemies, **more than three opponents**, then requested the main skeleton **2× taller** and materially more distinctive than his escorts. The assistant rendered a final character/encounter **concept sheet** with five unique skeletal archetypes, a giant draped lantern Guide carrying chained lanterns and a road formation. The latest user message explicitly says **«последняя концепция подходит»**. Treat this as approval of the final character design and theme.

**Five distinct roles, target roster 5 enemies** (one of each, two authored formations): `extinguished_guide` (Погасший проводник, giant ~2×), `lantern_bearer` (Носильщик фонаря), `road_sentinel` (Страж дороги), `oil_acolyte` (Масляный служка), `lantern_archer` (Стрелок фонарей). All are new skeletal enemies, not recolored D151–D153 or drowned units. Planned local combat mechanic: **two telegraphed moving lanternlight pools** temporarily buff enemies within their light; numbers must be designed/balanced after existing code inspection. No new global accuracy system, no D188 wash lane, no D152 chemical damage puddle or D153 tether copy.

**Exact reference to selected last concept sheet**: generated image ID `6fadac31-7e69-40c7-878f-1cb7602bbd75`, conversation upload filename `a_wide_detailed_pixel_art_concept_game_design_lay.png`, uploaded file ID `file_00000000041c81f7bae21d0c53926e17`. Last sheet has baked Russian text and panels: **CONCEPT REFERENCE ONLY**, not a production card bitmap or playable sprite atlas. Previous first selected standalone road scene and user-directed cleaner + 2× giant revisions should guide the **production, scene-first illustration**. Preserve this exact design in production rather than accidentally substituting another variant (same problem that arose with old D182 art).

**New committed specification**: `docs/DECK_EXPANSION_D199_BLACK_LANTERN_ROAD.md` and binding D199 record in `docs/DECISIONS.md`.

## D200 — chosen THIRD production art is now in GitHub

After the D199 approved five-role concept sheet, the user was shown three NEW text-free illustrations and explicitly chose **the THIRD** («третий арт лучше всего подходит»), then asked to continue. Source selected image `лунный_марш_скелетного_легиона.png` 1604×981, generation `f1821747-a46a-4e58-9fd9-9fd2b0f0a214`, conversation `file_00000000e49081f781fea566239097d4`. **Do NOT confuse it with the FIRST moodboard selected earlier; the later THIRD is definitive.**

D200 committed:
- `assets/pixel/card_unification_v1/run/black_lantern_road_selected_v1.webp.b64` — actual original third composition resized to **448×274**. Contains no UI text. Source art reference above preserves selection and rollback history.
- `scripts/ui/card_unification_v1.gd` — exact-card-ID strict WebP/Base64 loader, cached through existing `card_art_catalog.gd`.
- `resources/cards/black_lantern_road.tres` — **QA-only Tier1 combat metadata**, deliberately no encounter target until implemented.
- `scripts/dev/black_lantern_road_card_preview.gd` and `scenes/dev/black_lantern_road_card_preview.tscn` — F6 show approved third art at 448×274. Check card ID, dimensions and **37 cards still live**.
- No `RunState.CARD_PATHS` nor `ACT1_CARD_IDS` edits; no arena, sprites or mechanics yet. D199 rules require 5 unique skeleton roles and 2× distinct Guide, and user has NOT native-approved the 448×274 crop. **DO NOT claim native PASS.**

## NEXT TASK — native art acceptance then arena and animation production

1. User `git pull`, F6 **`res://scenes/dev/black_lantern_road_card_preview.tscn`**, confirm exact third-art 448×274 image and readable giant Guide/four escorts. If rejected, address art feedback; do not silently substitute earlier alternatives. Actual WebP is already in GitHub. This native check is pending.
2. Produce a **separate** 1280×720 battle arena with safe broad middle road and props only at sides/depth; user review in Godot before actual release.
3. Produce five genuinely distinct **full animation atlases** (idle/walk/attack/hit/death, if D153/D188 grid reused, 25 frames per role). Giant must remain double-height at combat scale while sharing a grounded boot line; do not crop or fake sprites from static sheet. After art review, implement `RunCardData`, `EncounterData`, five `UnitData`, encounter-local light logic, solo/duo/trio matrices (54 cases candidate), and Battle→Reward→Table.
4. Stage #38 as QA-only, NOT `ACT1_CARD_IDS`. Release only after original art, 54-case/functional checks, real reward path and full-pool random-deal smoke. Continue Act1 from **37/45**, no new cards live yet.
5. Keep D196 surf and existing #34–#37 code/DS2/Fate Spread 12+XIII unchanged. Work through connected GitHub and update state, changelog, decisions/roadmap as needed.

Historical details: `docs/D188_BLACK_CROSSING_ENCOUNTER.md`, `docs/DECISIONS.md`, `CHANGELOG.md`, Git history. New chat needs only mandatory start files plus D199 spec.
