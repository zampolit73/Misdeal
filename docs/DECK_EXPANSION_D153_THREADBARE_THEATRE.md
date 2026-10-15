## 2026-10-15 — D153 REAL BATTLE → REWARD → TABLE USER-REPORTED PASS; BALANCE SIGNOFF REMAINS

**Newest user QA:** After running the D153 real-scene dev entry `res://scenes/dev/threadbare_theatre_playtest.tscn`, the user replied **«все работает.»** This confirms, by direct user report, the *real gameplay test they were asked to perform*: approved ruined-theatre combat stage, original skeletal roster and D153-only tethers, completion and **victory → claim reward → return to Fate Spread/table** work in local Godot. This is a **user-reported full playtest PASS**, not an assistant-run engine test and not a separate video/screenshots of each screen. Do not ask for the same playtest again without a specific regression or change.

**Previous confirmed native technical QA:** `threadbare_theatre_battle_smoke.tscn` **54/54 FUNCTIONAL PASS**, 54 victories / 0 defeats, solo/duo/trio 18 each, surviving HP ~85 / 82–83 / 86%, battle duration 11.2 / 12.2 / 11.5 seconds, 123 tether joins / 92 ordinary breaks / 54 master-death breaks. Skeleton animations previously user-approved. Original arena already committed. All functional D153 requirements reported working.

**Remaining design gate before release:** encounter challenge is **not yet approved**. Universal victories and high surviving HP in the matrix may indicate the encounter is too forgiving; ask the user whether the real fight felt *too easy or appropriately challenging*. If too easy, adjust only D153-specific `threadbare_puppeteer.tres`, `bone_marionette.tres`, or encounter-specific placement; do **not** alter global party scaling or accepted art. Run a fresh 54-case matrix and route regression after tuning. If user says difficulty feels right, finalize release by adding only `threadbare_theatre` to `RunState.ACT1_CARD_IDS` as **36/45** and check normal offer/deal routing. **No automatic release on the phrase “все работает”.** Current live Act1 remains **35/45**; D153 remains QA-only although its `CARD_PATHS` lookup exists.

---

## 2026-10-15 — D153 REAL GODOT 54-CASE TECHNICAL MATRIX PASSED; PLAYTEST/REWARD & BALANCE PENDING

**NEWEST USER EVIDENCE:** User supplied two in-engine Godot screenshots showing **`D153 / THEATRE BATTLE — FUNCTIONAL PASS`** for `res://scenes/dev/threadbare_theatre_battle_smoke.tscn`. This is the **actual native outcome** (not an inferred assistant-side run):
- **54/54 simulations completed**, 54 player victories, 0 player defeats; 18/18 victories each in solo/duo/trio. Coverage: 2 formations × 3 starting protagonists × 3 party sizes × 3 tactical choices (`assault`, `hunt`, `formation`).
- Mean surviving hero HP: **solo 85%, duo 82–83%, trio 86%** (two screenshots differ by one rounded percentage point on duo; do not invent greater precision).
- Mean combat durations: **solo 11.2s, duo 12.2s, trio 11.5s**.
- Fallen heroes across simulations: **0 solo, 0 duo, 2 trio**.
- Tether counters: **123 established links, 92 normal breaks, 54 break events triggered by Puppeteer death**. Means ThreadTetherController was actively exercised.
- This is a **functional** result from the deterministic BattleUnit diagnostic; the smoke runner manually simulates AI and tether updates. It is **NOT** the live `battle.tscn` presentation/reward-route QA and it does **NOT** certify challenge/fairness. In particular, 54/54 victories with 82–86% average remaining HP signal **possibly low encounter difficulty**; do not alter other encounters/global multipliers or declare a balance verdict without the manual QA route.

**IMMEDIATE NEXT STEP:** User should run **F6 `res://scenes/dev/threadbare_theatre_playtest.tscn`** (this starts the **real** battle flow, unlike the matrix), review selected gloomy backstage arena/approved crimson skeleton animations, observe 32% thread protection and breaks, win and press **«ЗАБРАТЬ НАГРАДУ»**, choose a reward and return to **Fate Spread/table**. Ask for a real battle screenshot and whether reward→table works. If difficulty feels trivial, then tune **D153-specific** original UnitData/encounter parameters, rerun the 54-case test and repeat the live route. Avoid automatic buff solely based on scripted matrix numbers.

**GATE:** D153 remains QA-only and **absent from `RunState.ACT1_CARD_IDS` (35/45 live)**, despite a QA-only `CARD_PATHS` mapping. Native production battle flow/arena visibility and real reward/table transition are still unverified. Do **not** ship card #36 yet. Preserve the approved user-selected arena, D153 sprites, D151/D152, DS2 and 12+sealed XIII.

---

## 2026-10-15 — D153 THEATRE ARENA INSTALLED + PRODUCTION BATTLE TETHER WIRED; NATIVE QA NEXT

**LATEST AUTHORITATIVE D153 STATUS:** User approved the late, darker, restrained backstage image `лунная_арена_среди_руин_театра.png` (ruined internal theatre, central wooden battle floor, moon through broken roof, asymmetric stairs/rigging, crimson curtain, candles). After previously accepting both reauthored D153 25-frame skeleton animations in the Godot gallery («все ок»), user said «утвердили — продолжай», then «давай» for implementation.

**IN MAIN:** approved arena resampled to 1280×720 and stored as actual export-safe authored WebP `assets/pixel/battle/arenas/threadbare_theatre_approved_v1.webp.b64` (binary SHA-256 `6cb6db8138afca085add843833fbf579c00c99f81535a8a2f6266850e102ebe0`, 94,090 decoded bytes; exact remote Base64 content checked against source). `resources/encounters/threadbare_theatre.tres` now uses `arena_id = "threadbare_theatre"`. `authored_backdrop.gd` and `battle_visual.gd` register distinct D153 art and subtle stage dust; approved sprite art, card image and legacy arenas untouched.

**REAL BATTLE LOGIC SOURCE-INTEGRATED:** `scripts/battle/battle.gd` creates a `ThreadTetherController` only for the original one `threadbare_puppeteer` + two `bone_marionette` enemy roster. The controller starts only after combat intro/units start, protects linked skeletal marionettes by 32% in 285px, breaks/relinks with distance or master death, and restores baseline on battle resolution. Local-only; no global BattleUnit edits. The battle win subtitle/wizard combat line reflect severed strings. `scripts/core/run_state.gd` adds **only** a QA-accessible `CARD_PATHS` lookup for D153 to let the proper reward route resolve; **`ACT1_CARD_IDS` deliberately still has 35 entries and excludes D153**, so it is NOT in ordinary deals. This is a QA lookup, not card #36 release.

**NEW NATIVE TESTS TO RUN:** 
1. `git pull` then F6 `res://scenes/dev/threadbare_theatre_battle_smoke.tscn`. This deterministic diagnostic uses actual `BattleUnit` AI + ThreadTether on **54 cases**: 2 formations × 3 protagonists × 3 party sizes × 3 tactics. It prints technical PASS/FAIL, 54 completion, wins/losses, HP/durations and tether join/break counters. Must receive real user screenshot before claiming 54-case PASS or balance.
2. F6 `res://scenes/dev/threadbare_theatre_playtest.tscn` for **real scene**, starting QA-only Knight vs 1+2 skeletons. Inspect original ruined-stage background and original crimson skeleton art at 1280×720, preparation/tactical selections, golden protection strings, midfight break and end states; win → **ЗАБРАТЬ НАГРАДУ** → Reward → Table. This is an isolated dev-only offer; QA real-route proof remains pending.

**QA BOUNDARY:** GitHub commit and static code inspection passed; **Godot 4.7.x was not available to run natively in this session**. Therefore arena presentation, matrix, exact thread behavior in real battle, and reward/table navigation are **NOT YET NATIVE PASS**. User should send F6 screenshots/errors. Do not automatically activate D153 until native gameplay/balance QA passes. 12 Fate Spread slots + sealed XIII, DS2 and prior D151/D152 remain unchanged.

**Relevant source:** `docs/D153_NEXT_CHAT_START.md` is canonical compact handoff. Full prior thread smoke native PASS was an isolated controller test, accepted animation F6 was a separate art review.

---

## 2026-10-15 — D153 APPROVED THEATRE-ALIGNED REDRAW INSTALLED; GODOT F6 ART QA PENDING

**CURRENT MAIN OVERRIDES OLDER D153 ATLAS MESSAGES.** After seeing the original tiny skeleton atlases, the user rejected their appearance as unrelated to the approved moonlit ruined-theatre card and approved the **new** crimson-robed two-character redraws («Подходит)»). The assistant recovered those accepted high-resolution renderings, repacked each pose individually into 96×96 padded frames and **replaced BOTH runtime `.webp.b64` atlases on GitHub**:
- `assets/pixel/units/deck_expansion_v1/threadbare_puppeteer_frames.webp.b64` — **44,426 decoded WebP bytes**, SHA-256 `93f8839a778709f3c144a97eb3bef51e0b16944dc796e7cf9ec690896d23b846`.
- `assets/pixel/units/deck_expansion_v1/bone_marionette_frames.webp.b64` — **43,114 decoded WebP bytes**, SHA-256 `eb51e5d13968921bfa4ee4e9adef65c9c1939fb15a91f9e10a1c88e37633c755`.

**Static QA:** 576×480 transparent lossless WebP; 6×5 96px cells; exactly **25 filled unique poses each** (idle4, walk6, attack6, hit3, death6); all 5 unused cells empty; >3px alpha-safe border for all used cells after WebP decoding; complete body/feet; source-right. Removed spill fragments from the imprecise generated sprite-sheet gutters, then applied restrained 96-colour pixel palette. The very small previous D153 atlases are retained under `*_frames_rejected_v1.webp.b64` for rollback; the old generic appearance is **not approved**. The stage silhouettes now follow the **already approved** card: tall crowned puppeteer with ragged dark-crimson mantle, bone face/chest and dangling strings; smaller bone marionette with torn white/red garments and stage rig.

**NEXT ACTION for user:** `git pull` then F6 **`res://scenes/dev/threadbare_theatre_art_preview.tscn`**, watch both roles across all five states (each state changes every 2s). Confirm silhouette, feet, scale, no invisible/blinking frames, facing and continuity; send screenshot/feedback. **The newly installed redraw has NOT been validated by user in native Godot. Static QA is NOT native visual acceptance.**

**Remaining D153 gates:** native F6 gallery user acceptance, original theatre battle arena (crypt is placeholder), scoped real `ThreadTetherController` battle lifecycle, 54-case combat matrix, actual victory→reward→table QA. D153 still **NOT LIVE**, absent from `RunState.CARD_PATHS` and `ACT1_CARD_IDS`; Act1 **35/45**, 12 Fate Spread + sealed XIII. Preserve D143/D167/D168, DS2 and previously accepted D151/D152 unchanged. Next stage after art F6 acceptance is original theatre arena; no premature live activation.

---

## 2026-10-15 — D153 ORIGINAL SKELETAL ANIMATION ATLASES COMMITTED; NATIVE ART QA PENDING

**Latest implemented source:** Both new, independently authored skeleton pixel-art animation WebP/base64 atlases now exist on `main`:
- `assets/pixel/units/deck_expansion_v1/threadbare_puppeteer_frames.webp.b64` (3,504 WebP bytes; SHA-256 `b3d13f1eea6f84eb43d6a3d14308b49f7cf0394beebe29bda72dfa4a4c8d0989`).
- `assets/pixel/units/deck_expansion_v1/bone_marionette_frames.webp.b64` (3,178 WebP bytes; SHA-256 `dcd1c3079917d1171b7026a9fa08aefd71e7121852d47fc136d42e0bef50e7eb`).

Each decoded lossless WebP is **576×480**, 6×5 transparent cells of 96×96 with **25 separately drawn, non-identical, visible skeleton poses** (idle 4, walk 6, attack 6, hit 3, death 6). Both were decoded and checked **after WebP export** for nonempty/unique used cells, transparent unused cells, two-pixel empty borders, full feet and source-right orientation. Both GitHub files were remotely refetched and their decoded bytes SHA-256 matched the local originals **exactly**. They are deliberately stylized hand-built pixel miniatures, not recycled enemy artwork, card-image cutouts or concept-board frames; full motion visual signoff remains the user's call. See `docs/D153_ANIMATION_ATLASES.md`.

**NEXT USER ACTION:** `git pull`, then **F6 `res://scenes/dev/threadbare_theatre_art_preview.tscn`**. Inspect both original skeletons across five repeating states (every 2 seconds), visible feet, direction, transitions, thread effects and no disappearing frames; send a screenshot or specific corrections. **This F6 has NOT been run in native Godot since the atlases were added, so do not claim user art acceptance or runtime PASS.** Existing prior D153 tether-logic F6 **PASS** remains valid; don't rerun it just to review sprites.

**Still gated (NOT live):** User's native gallery acceptance, authored theatre arena, production battle-only ThreadTether wiring, real battle→reward→table and 54-case matrix. D153 remains absent from both `RunState.CARD_PATHS` and `ACT1_CARD_IDS`; **live Act1 = 35/45**, 12 Fate Spread + sealed XIII. DS2 and D143/D167/D168 frozen. GitHub writes belong to the assistant; no manual ZIP, image transfer, code copy or upload.

---

## 2026-10-15 — D153 NATIVE THREAD QA PASS; STRICT ORIGINAL ANIMATION GATE COMMITTED

Confirmed user Godot screenshot: `D153 / SKELETAL STRINGS — PASS`, 0 visible errors; original skeletal roster/two placements, 32% damage protection within 285px, tether break/relink and immediate protection removal on Puppeteer death plus cleanup all verified in **isolated** F6 logic test. D153 art preview was already seen rendering correctly in two separate screenshots.

**Next stage source committed, not yet animation assets:** `scripts/battle/unit_animation_library.gd` registers original D153 `threadbare_puppeteer` and `bone_marionette` with strictly separate `576×480` (6×5 cells of 96px) `.webp.b64` atlas paths under `assets/pixel/units/deck_expansion_v1/`. Requires all **25 independent visible frames** (idle4, walk6, attack6, hit3, death6), empty outer margins and unique non-repeated poses. **No fallback to old skeleton sprites**. Added `scenes/dev/threadbare_theatre_art_preview.tscn` five-state gallery with an explicit missing-original-art message. **Neither original 25-frame D153 atlas has been delivered or native-validated yet**; the art gallery is a preparation scaffold, NOT PASS, and no user F6 is needed until production sprite sheets exist. Generated concept boards / scene illustrations are references ONLY and must NOT be misrepresented as actual frame sheets. Future sprite art must retain full feet, right-facing source pose, no flicker.

**Release gates still pending:** approved source-accurate two full animation atlases in GitHub; native art gallery signoff; original theatre combat arena; D153-only `ThreadTetherController` lifecycle wiring in real `battle.gd`; native 54-case plus real battle→reward→table. D153 still NOT in `CARD_PATHS` or `ACT1_CARD_IDS`, live Act1 **35/45**, 12 Fate Spread + sealed XIII unchanged. Assistant handles source/assets in connected GitHub. Documentation in `docs/DECK_EXPANSION_D153_THREADBARE_THEATRE.md` and handoff; no manual ZIP/PowerShell/copying.

---

## 2026-10-15 — D153 ORIGINAL SKELETAL STRINGS NATIVE F6 PASS

User supplied Godot 4.7.2 screenshot of `res://scenes/dev/threadbare_theatre_smoke.tscn`: **D153 / SKELETAL STRINGS — PASS**. The scene explicitly reports passing original two-undead-types/two-formations data, **32% marionette protection within 285px**, range-severed bonds, immediate loss of protection on Puppeteer death, and cleanup restoring original damage multipliers. Godot debugger shows **0 errors** in this screenshot. This is **only the isolated encounter logic QA**, NOT animation approval, real battle wiring, theatre arena, real victory/reward/table or balance approval. D153 selected skeletal-theatre card artwork separately rendered in user Godot screenshots. The assistant now proceeds to original 25-frames-per-role unit animation production (puppeteer + bone marionette), then native gallery QA before battle integration. Active pool stays **35/45**, D153 NOT in CARD_PATHS nor ACT1_CARD_IDS; preserve D143/D167/D168, 12+sealed XIII, DS2 and all older encounters.

---

## 2026-10-15 — D153 NATIVE CARD PREVIEW RENDER CONFIRMED; THREAD SMOKE STILL UNVERIFIED

The user supplied **two Godot 4.7.2 screenshots of the same** `res://scenes/dev/threadbare_theatre_card_preview.tscn` scene. The selected third skeletal marionette / moonlit theatre illustration visibly loads in the **actual 448×274 slot**, with title, description and QA-only status; neither screenshot shows a blocking card-loader issue or any red error count (red counter 0). This verifies **native rendering of the staged D153 artwork** and confirms the chosen image is legible, but the user did not yet send an explicit statement of aesthetic acceptance after these screenshots.

**Crucial:** BOTH images are of `ThreadbareTheatreCardPreview`; there is **NO evidence yet for** `res://scenes/dev/threadbare_theatre_smoke.tscn`. DO NOT call the D153 32%-protection/range break/master death logic native PASS until its test screen is submitted. D153 still has no original 25-frame unit animation atlases, no theatre battle arena, and no production battle lifecycle wiring. Remains **NOT LIVE**, Act1 stays **35/45**, Fate Spread 12 + sealed XIII unchanged.

**Only next user action:** run F6 `res://scenes/dev/threadbare_theatre_smoke.tscn` after their existing `git pull` and share PASS/FAIL screenshot. Assistant must fix errors in GitHub; user should never manually paste code or manage assets. Proceed afterward to original skeletal character animation art, then real battle and full matrix before release. User's D168 multiple-concept selection is already fulfilled for D153; don't show another unrequested option round for this approved direction.

---

# D153 — Threadbare Theatre / Театр оборванных нитей

Date: 2026-10-15
Status: **original skeletal encounter DATA + local thread controller + 448x274 user-selected art staged, NOT LIVE**.

## Original undead direction / user approval

User specified that Misdeal's current enemies are undead, so the previous *wooden puppet* concept must be replaced by **skeleton marionettes**. The user liked the **third** visual option best, featuring an angular ruined theatre under shattered moonlight, an undead crowned puppet master, two bony marionettes in theatrical rags and physically visible threads. They then instructed the assistant to continue. Art direction must follow D167 dark-fantasy scene illustration, and D168 options-before-final workflow is considered satisfied by the already selected third concept.

The exact resulting 1604×981 selected/refined image was resized to **448×274** and saved as export-safe original WebP in GitHub:
`assets/pixel/card_unification_v1/run/threadbare_theatre_approved_v1.webp.b64`.
SHA256 of decoded WebP: `9a98c35b46f820acea3a0e3e3821fdb652f31a611428f384be6fd16900e260c3`.
Remote GitHub base64 content was refetched and independently compared byte-for-byte with the prepared source (MATCH). `scripts/ui/card_unification_v1.gd` now provides `get_run_texture("threadbare_theatre")` using a strict 448×274 WebP check; this is **only a QA art preview**, not a live card addition.

## Original staged resources (all independent of old enemies)

- `resources/units/threadbare_puppeteer.tres`: skeletal, ranged leader `threadbare_puppeteer`, provisional stats HP 108, damage 5.5.
- `resources/units/bone_marionette.tres`: original bone-and-rags marionette `bone_marionette` (two separate units), provisional HP 71/damage 8.5.
- `resources/encounters/threadbare_theatre.tres`: 1 master + 2 skeleton puppets, two independently-authored placements. The `crypt` arena is a **temporary data placeholder**, NOT approved theatre scenery.
- `resources/cards/threadbare_theatre.tres`: QA-only combat card data; intentionally **NOT** in `RunState.CARD_PATHS` or `ACT1_CARD_IDS`, which remains **35/45**.
- `scripts/battle/thread_tether.gd`: scoped ThreadTetherController without modifying global BattleUnit. While the skeletal master lives, puppets within **285px** receive **32% less damage** (multiplying each unit's original `damage_taken_multiplier` by 0.68). Movement can sever/reconnect a thread and death of the master immediately breaks all links and restores multipliers. Lines drawn between living units are distinct, not a generic area-of-effect poison/revive.
- `scripts/dev/threadbare_theatre_smoke.gd`, `scenes/dev/threadbare_theatre_smoke.tscn`: direct real BattleUnit F6 test of data/roster, near/far tether, damage reduction, break/relink, master death and cleanup.
- `scripts/dev/threadbare_theatre_card_preview.gd`, `scenes/dev/threadbare_theatre_card_preview.tscn`: staged original image shown at 448×274 using normal CardArtCatalog, and source guard that D153 is NOT yet live.

## IMPORTANT native QA boundary

**None of the new D153 scenes has yet been run in native Godot**. The source and GitHub files have been verified but cannot be labeled F6 PASS. Do not imply that a real D153 fight works: the controller is **not wired into** `battle.gd` and the two new enemy roles **do not yet have original animation atlases**. It is intentional to avoid rendering old skeleton sprites or blank units in a live battle.

Next minimal user steps:
1. `git pull`, F6 `res://scenes/dev/threadbare_theatre_card_preview.tscn` to verify card art is correct at runtime.
2. F6 `res://scenes/dev/threadbare_theatre_smoke.tscn` to test thread mechanics. Send one screenshot or PASS/FAIL text.
No manual file copying, ZIP extraction, or PowerShell required.

After that: generate original **25 authored frames per role** (idle4/walk6/attack6/hit3/death6) in separate transparent 576×480 atlases, preserve visible feet and actual unique poses; user reviews Godot gallery before production. Prepare original theatre combat arena, then wire controller **only** for `threadbare_theatre`, do native 54-case mechanical/balance test and real win→reward→table navigation, and only then register D153 as **36/45**. Maintain 12 Fate Spread resolutions + sealed XIII, DS2 Variant C, D143 genuine new enemies and D167/D168 card-art rules.
