# Misdeal — Current Project State

Updated: 2026-10-17 (D207 user-native 54/54 functional PASS; D208 focused +22% lanternlight balance candidate awaits F6). Source of truth: `zampolit73/Misdeal` / `main`.

## Safety snapshot: КАРАМБА73

User requested a 2026-10-16 fixed restore point for the **entire GitHub-tracked Misdeal project**, current game and development context. Frozen branch: `backups/KARAMBA73-2026-10-16`; exact recovery process and snapshot scope: `docs/checkpoints/KARAMBA73_2026-10-16.md`. The saved milestone is **37/45 released cards**, #38 QA-only, D200 third card artwork user-native-approved, D201 empty battle-arena concepts awaiting a choice. Saying **КАРАМБА73** later authorizes restoring this saved Git tree to `main` while first preserving the then-current `main` on a separate safety branch. Tracked GitHub files only; not unknown local Godot/untracked files.

## Live playable baseline

Godot **4.7.x / GDScript** dark-fantasy card-driven roguelike: evil Wizard hosts a cursed 12-resolution Fate Spread; the central Bone Warden is sealed as **XIII**. Knight / Ranger / Mage protagonists, conditional companion recruitment and loss (solo, duo, trio), decision cards, prepared tactical autobattles, rewards and return to the table all exist. DS2 / Fate Spread Variant C is the accepted UI. Preserve existing party-size compensation and Wizard Debt/Mark logic.

**Act 1 random-deal pool: 37/45 cards.** `RunState.ACT1_CARD_IDS` now includes:
- **#34** D151 Funeral Procession — original Funeral Priest and Pallbearers; localized Last Rite.
- **#35** D152 Defiled Laboratory — original Alchemist and Homunculus; localized chemical hazards.
- **#36** D153 Threadbare Theatre — original skeletal Puppeteer and Marionettes; localized tethers.
- **#37** D198 **Black Crossing / ЧЁРНАЯ ПЕРЕПРАВА** — original drowned Ferryman + two Drowned; localized storm waves.

There are **eight remaining planned cards** to reach 45. Boss XIII is NOT in the regular pool.

## Release QA and boundaries

**D153 (#36):** User-native D178 matrix **54/54 wins**, mean surviving HP 74/67/74% (solo/duo/trio), user-confirmed real reward→table, D181 native release smoke **PASS**; its smoke guards have now been updated for the 37-card pool. Keep the puppets skeletal and the approved original artwork.

**Black Crossing (#37):**
- **D182–D187 accepted visuals:** selected card illustration variant **3** (448×274), Ferryman **B** / Drowned **C** 25-pose original animations, and cleaned 1280×720 storm arena **«Последний причал»**. Assets are already in GitHub; do not redraw or replace them.
- **D188–D191 original combat:** two formations of one Ferryman + two Drowned. User-native **D191 functional PASS: 54/54 wins, 0 party defeats**; solo/duo/trio 18/18/18 and Knight/Ranger/Mage 18/18/18, mean surviving HP 86/74/77%, worst 58/42/50%, 78 warnings / 62 impacts / 66 pushes / 66 slow resets. Shared D189 bounds lock feet and impulses to the intact upper planks.
- **D196 visuals:** storm-wave renderer draws three rolling breakers with a 94px forward impact, foam and runoff, while damage remains zero, push 43px left and 30% slow for 1.6s. User said **«давай пока оставим этот. продолжай»**. Leave D196 as the current baseline; do not return to wave tuning without new feedback.
- **D197 native route QA:** after F6 preflight and pressing the actual battle→reward→table button, user replied **«Все ок»**. Treat pre-release real navigation as approved.
- **D198 live-source release:** `black_crossing` is in `RunState.ACT1_CARD_IDS` as card #37. Legacy D151–D153, shepherd and D188 regression guards were updated to 37. Added `res://scenes/dev/black_crossing_release_smoke.tscn`: it tests all 37 unique cards, original assets/formation, real **full-pool** random Tier1 offers (80 deterministic seed samples, without a two-card fixture), production selection/completion/Fate Spread and sealed boss XIII.
- **D198 user-reported native release smoke PASS:** after being asked to run `git pull` and F6 `res://scenes/dev/black_crossing_release_smoke.tscn`, the user replied **«все ок»** (2026-10-16). Treat the 37-card ordinary-pool release gate as satisfied by the user's confirmation, not as an independently captured engine log or screenshot. Card #37 is fully released. D191 54/54 remains valid because D198 changed only deck registration.

## D203 arena staging evaluation (not production)

Used the newly supplied artist/designer/developer skill archives for D201 art QA. Generated castle/causeway concepts remained too visually repetitive; **no arena was approved, committed as game art or assigned to #38**. The existing D201 option #2 (1280×720) was used **only** as a temporary staging test with 3 hero proxies, 5 skeletal enemy proxies (2× tall Guide), and 2 illustrative light zones. The production default ground bounds map to screen X110–1190 and Y380–538. Result: the region accommodates the intended figures, but excessive baked lamp highlights clash with the gameplay cue, so an alternate **dead-forest / ford / toll-gate** environment needs user selection. Details: `docs/D203_BLACK_LANTERN_ARENA_ART_QA.md`. Annotated preview `d201_arena_gameplay_clearance_test.png` is a **conversation attachment**, not a playable or committed arena. The frozen **КАРАМБА73** backup is unchanged. Act1 still **37/45**.

## D204 composition-only arena options (NOT production art)

Three **1280×720** pixel-style geographic **blockouts** were drawn and shown for card #38: **A dead forest bend**, **B stagnant flooded ford (dry fight strip)**, **C abandoned toll gate**. Each keeps the central battle strip open, avoiding the repetitive castles and excessive lanterns rejected in D203. They are intentionally low-fidelity composition aids, **not approved production bitmaps, and not in GitHub game assets**; no native Godot F6 took place. The image trio and montage remain conversation artifacts (`Misdeal_D201_arena_blockouts.zip`). User geography selection is pending; after selection, create genuinely finished alternate scene arts, ask for exact visual approval, then QA-only Godot staging. See `docs/D204_BLACK_LANTERN_ARENA_BLOCKOUT_OPTIONS.md`.

## D208 — modest encounter-only lanternlight pressure test (native F6 pending)

User Godot screenshot (2026-10-17) confirms **D207 real BattleUnit matrix 54/54 wins, 0 losses/timeouts**, 18 wins per solo/duo/trio and per Knight/Ranger/Mage. Mean surviving HP **80/70/74%**, worst **52/30/44%**, durations **13.2/14.6/13.3s**, individual hero deaths **0/2/4**, lantern telegraphs **90**, active frames **11,434**, buff-exposure frames **15,502**, max three lit enemies. This is functional **PASS**, not approved balance or actual player-facing combat/art. Compared with D153 accepted matrix (74/67/74% mean HP), the encounter is only moderately more forgiving; avoid blanket HP/damage increases.

D208 changes **only the candidate #38 light speed multiplier 1.16 → 1.22** in `scripts/battle/black_lantern_light.gd`, preserving five enemy stats, light phase timings/locations and all live battles. Updated the SAME invisible deterministic 54-case Godot scene `res://scenes/dev/black_lantern_road_battle_matrix.tscn` to label results D208 and instrument *real attacks during lanternlight* via BattleUnit's existing diagnostic signal. **D208 Godot F6 not yet run.** Full baseline + new QA gate: `docs/D208_BLACK_LANTERN_BALANCE_PASS.md`. Card #38 still **QA-only**, live pool **37/45**; approved selected arena binary and correct five original animation atlases still outstanding.

## D207 — 54-case tactical and balance baseline staged, native F6 PASS

New `res://scenes/dev/black_lantern_road_battle_matrix.tscn` tests **54 actual BattleUnit fights** (2 formations × 3 protagonist classes × solo/duo/trio × Assault/Hunt/Formation) using staged #38 UnitData and the encounter-only light controller, **without ever wiring #38 into normal battle or displaying unapproved sprites**. It records wins/losses, timeouts, mean/worst HP, casualty/round durations and light buff exposure. It verifies no light buff leakage or actors leaving battle bounds; victories alone are NOT a balance approval. Godot D207 F6 now **PASS per user screenshot**; D208 rereun pending. Full baseline: `docs/D207_BLACK_LANTERN_BATTLE_MATRIX.md` and `docs/D208_BLACK_LANTERN_BALANCE_PASS.md`.

## D206 F6 native contract — user screenshot PASS

**2026-10-17 screenshot:** green `СТАТИЧЕСКИЕ ПРОВЕРКИ ПРОЙДЕНЫ`, including 5 distinct UnitData, two formations/five enemies, and enemy-only lantern buff with cleanup. This is a genuine user-native **isolated resource/light PASS** after the `Array[Vector2]` fix `9f751e7`. It does not validate art, real combat, balance, complete route or release.

## D206 F6 runtime finding and hotfix — resolved

User Godot 4.7.2 screenshot of `black_lantern_road_contract_smoke.tscn` showed **typed-array runtime error** in staged `black_lantern_light.gd:109`: `Array` cannot be assigned to `Array[Vector2]`. Fixed GitHub `main` in `9f751e7`: explicit typed-array initialization and branch assignments across all light-zone array selection points. Native F6 re-run now **PASS** (user screenshot 2026-10-17). Live combat untouched; pool still **37/45**.

## D206 CURRENT — Five original enemy data resources and local light logic, QA-only

**Added to main but NOT LIVE:** 5 new `resources/units/{extinguished_guide,lantern_bearer,road_sentinel,oil_acolyte,lantern_archer}.tres`; a standalone `resources/encounters/black_lantern_road.tres` with two separate five-enemy formations; `scripts/battle/black_lantern_light.gd` with deterministic alternating pools, candidate 1.4s warning/3.1s active/1.8s rest and +16% attack speed for **lit enemies only**, restoring intervals when light ends or battle stops. This **is not wired into actual battle/RunState**. Numbers await native balance.

**Added isolated native data smoke (F6 not run):** `res://scenes/dev/black_lantern_road_contract_smoke.tscn` validates all 5 original UnitData roles, both safe 5-unit formations and isolated enemy-only light/reset behavior. Prior D205 visual light preview F6 also remains unconfirmed after the parser hotfix.

**Exact approved forest source prepared locally only:** third forest arena image from D205 resized to 1280×720 WebP in conversation container. The chosen bitmap is **not** committed to GitHub nor displayed by the game. Five art candidate sheets still need clean source frames and approved role-accurate weapons (Sentinel spear, not axe). No released cards, D196 waves, DS2 or checkpoint branch changed. Live pool **37/45**, #38 remains QA-only. D206 technical contract, art hashes and next gates: `docs/D206_BLACK_LANTERN_ENCOUNTER_STAGING.md`.

## D205 PREVIOUS — Forest art selection, sprite QA staging and light preview

**Selected arena art (user choice, NOT imported):** after selecting D204 geography A (Black Forest Bend), the user chose **option 3** of three new original forest images: `лунная_дорога_через_туманный_лес.png`, 1672×941. This approved *exact source* is a conversation artifact, not yet 1280×720 GitHub game art and not Godot QA. Preserve separate D200 selected card illustration.

**Five enemy animation concepts:** five uploaded 1254×1254 RGBA / 5×5 sheets were inspected and converted locally into five review-only **576×480 / 6×5 / 96px** WebP/Base64 candidates with 25 different nonempty cells each and five blank cells. Source-grid edge contamination remains in **13/20/24/21/13** frames for Guide/Bearer/Sentinel/Acolyte/Archer respectively. The Sentinel concept has an AXE, contradicting the accepted long SPEAR; other roles also need silhouette/weapon polish. Therefore **none are approved production atlases** and none were committed as `assets/` bytes. Review files are in the conversation-only `Misdeal_D205_Lantern_Animation_QA_Pack.zip`. Reproducible developer stager in GitHub: `scripts/dev/stage_black_lantern_art.py`.

**D205 preview parser hotfix:** user's Godot 4.7.2 screenshot caught `opacity` type-inference parser failure on line 121. Explicit `float` + `absf()` fix and typed interpolation variables committed; Godot F6 re-test pending. This was a dev preview script-only change, no production battle edits.

**QA-only new Godot scene in GitHub:** `res://scenes/dev/black_lantern_road_light_preview.tscn` illustrates two moving light pools and five enemies/three heroes as *bounding proxies*, with proposed **1.4s warning / 3.1s active / 1.8s rest** and a pause button. No real battle, unit modifiers, finalized stats, encounter registration, or F6 PASS. Godot F6 to review next. No changes to active game beyond dev-only assets/scripts; live Act1 **37/45**, card #38 QA-only.

See `docs/D205_BLACK_LANTERN_ASSET_AND_LIGHT_STAGING.md` for exact sources, blockers, and next action. Keep D196, #34–#37, Fate Spread 12+XIII, DS2 and frozen `КАРАМБА73` untouched.
