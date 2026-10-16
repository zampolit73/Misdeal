# Misdeal — Canonical Working Handoff

Updated: 2026-10-16 — **D206 five-role QA-only encounter + isolated light controller + F6 contract smoke committed; no native PASS or live pool change**.

Source of truth: `zampolit73/Misdeal`, branch `main`. The assistant has direct connected GitHub read/write tools; do not ask the user to paste code, repeat project history or grant GitHub access without checking. Godot **4.7.x / GDScript**, no C# migration. Start a new chat by reading `AGENTS.md`, `docs/CONCEPT.md`, `docs/PROJECT_STATE.md`, `docs/ROADMAP.md`, `docs/DECISIONS.md`. Other references: `docs/INDEX.md`.

## Frozen safety checkpoint — КАРАМБА73

**2026-10-16 user-requested full tracked-project snapshot:** GitHub fixed branch `backups/KARAMBA73-2026-10-16` and manifest `docs/checkpoints/KARAMBA73_2026-10-16.md`. When the user sends the exact code word **КАРАМБА73**, follow that manifest's non-destructive recovery procedure: first preserve current `main` on a separate pre-restore branch, then commit the backup's exact **tree** on top of current `main` and fast-forward the branch. No force push, no overwriting the frozen checkpoint, no assumptions about untracked local files. This is a restore command, not an invitation to discuss options. The checkpoint saves **Act1 37/45**, #38 QA-only and D201 arena choice pending.

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
- No `RunState.CARD_PATHS` nor `ACT1_CARD_IDS` edits; no arena, sprites or mechanics yet. D199 rules require 5 unique skeleton roles and 2× distinct Guide, and the native F6 crop has now been **user-confirmed** («вск ок» in reply to the preview request). This is user-reported approval, not independently captured Godot footage.

## D203 — specialist-skill arena QA status (no runtime changes)

The user asked to continue using three uploaded custom skills (designer, artist, developer). All three `SKILL.md` instructions were actually read; the artist's style/pixel/QA references were consulted. Freshly generated landscape samples remained too similar (fortress + viaduct + dozens of amber lanterns), so **no new environment is accepted or loaded in Godot**. A technical overlay on already-shown **D201 option #2**, native 1280×720, tested **3 heroes versus 5 enemies** including a **double-height** boss and two illustrative moving light zones. Screenshot artifact: `d201_arena_gameplay_clearance_test.png` in conversation only; rectangle computed from production `battle.gd` UnitsLayer offset (20,96) and COMBAT_BOUNDS (90,284,1080,158). Overlay is *not* a sprite or Godot native result. Main visual blocker: baked lantern clutter would drown out tactical lanternlight cue. Technical acceptance brief: `docs/D203_BLACK_LANTERN_ARENA_ART_QA.md`.

**Next:** produce genuinely new, distinct empty arena geographies (forest bend / dark ford / broken toll gate); once user chooses, integrate exact art and run F6. No arena selected yet; Act1 37/45, D200 card approved. `backups/KARAMBA73-2026-10-16` snapshot must stay frozen.

## D204 — geography blockouts shown (NO scene/image integration)

Three deliberately simple, separate 1280×720 pixel-style **composition blockouts** were produced as conversation-only PNGs, plus a comparison montage and `Misdeal_D201_arena_blockouts.zip`: **A black forest bend**, **B peat-water ford with dry central walkway**, **C collapsed toll gate with old cart wheel**. Their job is to test geographic difference, leg-contact floor space, and restrained lamp positions after the failed repetitive D201 castle-background attempts. All three remain **unapproved**; they are NOT polished artist backgrounds, native Godot previews, or committed game assets. Do not replace approved #38 D200 card illustration with any blockout. One D204 documentary record: `docs/D204_BLACK_LANTERN_ARENA_BLOCKOUT_OPTIONS.md`.

## D205 — user-selected actual forest art; sprite concepts and QA-only light scene

Since D204, user explicitly chose **A — Black Forest Bend**, then **the THIRD** from three newly rendered forest arena images. This latest arena source is `лунная_дорога_через_туманный_лес.png`, RGB 1672×941, **NOT** the D200 selected card illustration. It is a chat artifact only; DO NOT falsely claim imported or replaced in GitHub. Record/user-selected art direction is final, Godot integration/QA pending.

Previous assistant turn generated five separate 1254×1254 RGBA 5×5 skeleton concept animation sheets. Read `docs/D205_BLACK_LANTERN_ASSET_AND_LIGHT_STAGING.md` for their exact original Russian filenames, role mapping and art QC. Static converter packaged five 576×480 6×5 96px QA candidates with 25 varied populated frames, but **source edge clipping flagged 13 / 20 / 24 / 21 / 13 frames**, and `road_sentinel` uses an unapproved axe instead of a spear. Art not approved; pack is only in conversation `Misdeal_D205_Lantern_Animation_QA_Pack.zip`. `scripts/dev/stage_black_lantern_art.py` in GitHub reproduces candidate conversion from the original files (not included in GitHub assets). Do not wire up unfinished 5 roles or replace them with legacy art.

**D205 Godot 4.7.2 parser fix:** user screenshot showed `Cannot infer the type of opacity` at `scripts/dev/black_lantern_road_light_preview.gd:121`. Fixed GitHub `main` in commit `a786d2b` by replacing ambiguous `abs(...)` expression with typed float / `absf(...)`, and typing `v` and `eased`. **Ask user to `git pull` and F6 the same isolated preview; no native re-test is confirmed yet.** No changes to production gameplay or active deck.

**Source-integrated in GitHub (dev-only):** `scripts/dev/black_lantern_road_light_preview.gd` + `res://scenes/dev/black_lantern_road_light_preview.tscn`. F6 shows two travelling light pools, 5 rectangular enemy proxies (175px large guide), 3 hero proxies, 1.4s warning → 3.1s active → 1.8s rest. This does NOT modify attacks/damage, battle or live deck. Native F6 is **NOT RUN**.

## D206 Godot 4.7.2 light typed-array runtime fix (NEXT F6)

User-native `black_lantern_road_contract_smoke.tscn` screenshot reported `Trying to assign an array of type "Array" to a variable of type "Array[Vector2]"` in `scripts/battle/black_lantern_light.gd` line 109. The conditional `get_pool_centers() if active else []` created an untyped empty array. GitHub fix `9f751e7`: initialize a typed empty Array then populate inside `if active`, and replace other conditional typed array selections with explicit branches. Smoke is **NOT YET PASS**; next action is `git pull` and F6 the SAME `res://scenes/dev/black_lantern_road_contract_smoke.tscn`, report native result. No released gameplay or card pool changes.

## D206 — five original resources and isolated light mechanics staged, no production switch

GitHub `main` now has exactly five **new** UnitData Resources and standalone `resources/encounters/black_lantern_road.tres` (two 5-unit placements). These are **unbalanced candidates** and not registered in RunState normal card paths or ACT1 pool. An isolated `BlackLanternLightController` in `scripts/battle/black_lantern_light.gd` records enemy baseline attack intervals, warns/activates/rests (1.4/3.1/1.8s candidates), gives up to +16% attack speed to illuminated ENEMIES only, then resets intervals on unlit/rest/stop. **It is not connected to `battle.gd` or live combat yet**. Godot engine QA not run.

A second native QA scene is now present: `res://scenes/dev/black_lantern_road_contract_smoke.tscn`. It verifies resources, both authored formations in bounds, only-enemy speedup and reset. Next chat should ask user to `git pull`, F6 the contract smoke; also ask about the older D205 `black_lantern_road_light_preview.tscn` (parser error repaired but native F6 response still missing).

Chosen exact arena bitmap `лунная_дорога_через_туманный_лес.png` was converted **locally** to 1280×720 WebP (same source, 16:9); it remains **not imported to GitHub**, so do not claim arena is visible in Godot. Original approved D200 card art remains untouched; D205 skeletal atlas candidates still art QA blocked. No game behavior, DS2, #37 waves or `КАРАМБА73` branch changed. Details & SHA references: `docs/D206_BLACK_LANTERN_ENCOUNTER_STAGING.md`.

## NEXT TASK — D206 contract F6, D205 light F6, then approved arena import

1. User `git pull`; **F6 `res://scenes/dev/black_lantern_road_contract_smoke.tscn`** and report PASS/FAIL. Then recheck the D205 `res://scenes/dev/black_lantern_road_light_preview.tscn` after parser fix if not yet confirmed. Native smoke has NOT run.
2. Import **the selected exact third forest image** into GitHub at 1280×720 in accepted game art format when image-byte transfer is available; QA-only native arena with floor bounds. Never substitute an AI re-render, previous A/B/C blockout or a different option.
3. Improve source atlases until each has correct approved original five roles, no source-frame crop, correctly scaled Guide and aligned feet; then commit/present native animated sprite preview. A converter PASS is not art acceptance. New UnitData are **proposals only**; do not pretend the latest sheet supplies original animation atlases.
4. Connect the already-staged `EncounterData` and `BlackLanternLightController` to #38 battle **only after approved art**; run 54-case native matrix, real battle→reward→table, and ordinary-deal smoke before releasing card #38.
5. Preserve existing D196 storm and released #34–#37, DS2, 12+XIII; never touch frozen backup `backups/KARAMBA73-2026-10-16`.

Detailed current handoff: `docs/D205_BLACK_LANTERN_ASSET_AND_LIGHT_STAGING.md`. **Live Act1 remains 37/45**. Godot 4.7.x / GDScript only.
