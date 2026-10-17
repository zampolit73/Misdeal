# Misdeal — Canonical Working Handoff

Updated: 2026-10-17 — **D208 native 54/54 functional PASS; +22% test reverted to +16% due unchanged observed stats; original forest art QA next**.

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

## NEXT CURRENT TASK — selected #38 forest arena, then skeletal art, then real battle

## D208 — user-native rerun PASS, +22% experiment reverted

Date: 2026-10-17. The user ran the same deterministic F6 `res://scenes/dev/black_lantern_road_battle_matrix.tscn` again after enabling +22% illuminated-enemy attack speed. Screenshot reports **D208 FUNCTIONAL PASS, 54/54 complete, 54 wins, 0 defeats, 0 timeouts**. Per party size solo/duo/trio 18/18/18 wins, per Knight/Ranger/Mage 18/18/18; mean surviving HP **80/70/74%**, worst **52/30/44%**, hero losses **0/2/4**, durations **13.2/14.6/13.3 sec**. All of those displayed metrics were identical (to displayed precision) to the user-native D207 +16% baseline. D208 counters: **90 warnings**, **11,433 active frames** (D207 11,434), **15,510 buffed-enemy frames** (D207 15,502), peak **3 lit enemies**, **635 real enemy attacks total, 59 attacks with a lantern speed bonus (9.3%)**. D207 did not count real attacks, so do not assert an exact before/after attack-count comparison.

Interpretation: The +22% experiment made no *observed* difference to the aggregate HP/duration/wins at displayed precision. Only 59/635 enemy attacks were made while accelerated; in this short fight increased cadence is therefore unlikely to meaningfully improve engagement. **Do not continue inflating enemy stats or light attack-speed numerics without visual/real combat evidence.** Reverted **only** `BlackLanternLightController.ATTACK_SPEED_MULTIPLIER` from 1.22 back to the **previous user-native-validated 1.16** in commit `cc624e3`. The D208 diagnostic_attack instrumentation remains in `scripts/dev/black_lantern_road_battle_matrix.gd` for future balance work. The reverted exact parameter is covered by the earlier D207 Godot test, but **no new post-revert D208 instrumented Godot run has been performed**. D208 +22% variant itself is user-native PASS; **this is not full balance approval**, much less release.

Next milestone: prioritize **exact user-selected third moonlit forest arena asset** (`лунная_дорога_через_туманный_лес.png`, 1672×941; source conversation artifact), import exact source-derived 1280×720 WebP as original art **only via supported authenticated GitHub asset transfer** (the connected GitHub creator accepts UTF-8 text; approved binary not committed yet). Then native scene QA for boot-floor clearance and telegraphed moving light/readability; check moving light paths against actual early/late skeleton movement before deciding whether to retune zones/timing. Five original skeleton animation sheets are still blocked by frame-edge cropping and the Sentinel axe/spear mismatch. Do not substitute prior backgrounds, doodles or unapproved art. Continue with true Battle→Reward→Table and full-pool smoke only after original art QA. Live pool remains **37/45**, `КАРАМБА73` untouched.


**Already verified:** D206 isolated resource/light contract native PASS; D207 baseline real BattleUnit 54/54 native PASS; D208 +22% diagnostic real BattleUnit 54/54 native PASS. **Final current source multiplier 1.16** (rollback commit `cc624e3`). Do not ask user to rerun D207/D208 unless a new code change requires it.

**NEXT:** import the exact approved option-3 moonlit forest bitmap, not a regenerated substitute or D204 blockout. Source lives among this conversation's mounted assets as `лунная_дорога_через_туманный_лес.png` (1672×941). Confirm its content/size before converting to standard 1280×720 loss-controlled WebP/Base64, but **do not claim GitHub import before the bytes are actually committed**. Stage a QA-only 1280×720 background and existing 3 heroes/5 enemy spatial envelopes with boot contact, plus two moving lantern pools with enough contrast and no HUD overlap. No unapproved character art in production; five original animation atlases still fail source-edge QC, with Road Sentinel requiring a spear. The live Battle remains unchanged; 37 cards in normal pool; freeze `backups/KARAMBA73-2026-10-16`, DS2, boss XIII and D196 sea storm.

**Native visual-only D205 light scene** remains unconfirmed F6 after its parser fix; check it as part of the future combined arena/art QA. For test data and comparisons, see `docs/D208_BLACK_LANTERN_BALANCE_PASS.md`. When exact arena/atlas art passes, wire #38 into real battle only, run reward→table QA, and then release smoke before adding to live pool.