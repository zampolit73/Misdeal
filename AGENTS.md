# MISDEAL — Development Guide

## 2026-10-15 — D177 D153 MATRIX RESOURCE-LOAD REGRESSION FIX; RETEST PENDING

**User-provided real Godot screenshots:** after D176 local stat tuning, F6 `threadbare_theatre_battle_smoke.tscn` displays **`D153 / THEATRE BATTLE — FAIL`**, `Missing BattleUnit data in D153 matrix`. The diagnostic stopped during setup with a null `UnitData` — **this is not a combat loss or a balance conclusion**. It gave no filename, so the exact null source was not proven by screenshots.

**Probable D176 regression found in GitHub:** D176 inserted `# ...` comment lines **inside the `[resource]` block immediately before `script = ExtResource("1")`** in the two edited D153 enemy `.tres` files. Prior working versions had `script` as the first property. D177 removes these newly inserted lines while preserving all D176 tuned combat stats: Puppeteer HP 142/damage 7.5/interval 1.65/speed 55; Marionette HP 88/damage 10.5/interval 1.22/speed 78. Do not assert resource parsing was conclusively the cause until Godot is rerun.

**Regression detection improved:** `scripts/dev/threadbare_theatre_battle_smoke.gd` now preloads and validates all three hero `UnitData` resources and the two original enemy `.tres` files **before** the 54 cases, reporting exactly which resource fails. The later fixture also identifies hero role/enemy resource rather than only `Missing BattleUnit data`. 54-seed coverage, real BattleUnit/tether, win/loss/HP metrics and balancing warnings remain unchanged.

**NEXT:** `git pull`; F6 `res://scenes/dev/threadbare_theatre_battle_smoke.tscn` and send the updated output. If still failing, the new output should name the specific missing hero/enemy resource. If 54 cases complete, inspect win rates/HP for safe solo, duo, trio balance, then briefly repeat real `res://scenes/dev/threadbare_theatre_playtest.tscn` to verify combat feel. **D153 is still QA-only, Act1 35/45; do not enable #36 on the failed test.** Native D176/D177 post-tune matrix PASS is not claimed.

---


## 2026-10-15 — D176 D153 LOCAL BALANCE PASS COMMITTED; POST-TUNE GODOT QA PENDING

**User explicitly felt the real D153 fight was too easy and requested a local balance pass, a 54-case matrix recheck, and release preparation.** Source stats for original skeletons have been raised **only inside D153**: Puppeteer HP **108 → 142**, damage **5.5 → 7.5**, attack interval **1.80 → 1.65s**, speed **51 → 55**; Bone Marionette HP **71 → 88**, damage **8.5 → 10.5**, attack interval **1.33 → 1.22s**, speed **73 → 78**. Roster remains 1+2, ThreadTether stays at 32% defense in 285px and retains break/relink/death/cleanup semantics. No changes to D153 accepted sprites/arena/card art, global damage or party-size compensations, encounter placement, or non-D153 enemies.

**QA matrix improved:** `scripts/dev/threadbare_theatre_battle_smoke.gd` still uses the same seeded **54 scenarios (2 formations × 3 protagonists × 3 party sizes × 3 tactics)**, adds per-protagonist wins and **minimum HP** by party size to expose bad outliers, requires definite outcomes and at least one win per party size, and prints a non-gating balance warning when all 54 win with average team HP ≥ 80%, or fewer than 40 win. All original tether resource checks remain; FUNCTIONAL PASS does **not** certify satisfactory difficulty. No new result is being invented from old screenshots.

**Verification boundary:** Code and resource parameters were statically checked against the GitHub files. Godot executable is not available to the assistant runtime and GitHub had no CI workflow for running the game; **the tuned matrix has NOT been executed in native Godot yet**. Old **54/54 54 wins / 0 losses, 82–86% HP** screenshots describe **pre-tune baseline only** and must not be reused as the new result.

**NEXT:** User `git pull`, F6 `res://scenes/dev/threadbare_theatre_battle_smoke.tscn` and send the new PASS/FAIL + counts/HP screenshot; then F6 `res://scenes/dev/threadbare_theatre_playtest.tscn` for a fast difficulty sanity check (battle→reward→table already passed before tuning; no need for exhaustive route screenshots unless regression). If the new solo/duo/trio results and manual feel are acceptable, assistant may then put `threadbare_theatre` in `RunState.ACT1_CARD_IDS` as card **36/45**. Until that approval it is **QA-only, 35/45**, though `CARD_PATHS` contains its QA lookup. See `docs/D153_BALANCE_D176.md` for complete metrics and release checklist.

---


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


## 2026-10-15 — D153 ORIGINAL SKELETON ANIMATIONS ACCEPTED BY USER; THEATRE ARENA NEXT

**Newest direct user report:** After the assistant replaced both runtime D153 atlases with the richly illustrated theatre-aligned bone puppeteer and bone marionette, supplied a `git pull` + five-state F6 gallery check, the user replied **«все ок.»** Treat this as **user-reported native visual acceptance of D153 character animations** (idle/walk/attack/hit/death), not an independently captured debugger trace or proof of real combat. Supersedes the older "F6 art QA pending" top-of-file notes. Keep accepted crimson crowned master/marionette assets and rollback files unchanged.

**NEXT D153 STAGE: original combat arena.** Current `resources/encounters/threadbare_theatre.tres` still has `arena_id = "crypt"` as a temporary placeholder. `scripts/battle/authored_backdrop.gd` controls 1280×720 arena WebP (including `.webp.b64`), while `scripts/battle/battle_visual.gd` applies scene-specific atmospheric overlays. Author original *empty, playable* ruined moonlit puppet-theatre arena without characters, UI, baked tactical graphics or imported card illustration: crimson curtain remains, collapsed stage, moonlit Gothic arches, candles and physically meaningful dangling strings; central combat zone must stay clear and readable (UnitsLayer offset (20,96), combat bounds local y284–442, world y~380–538). Follow DS2/Fate Spread restrained palette and the already-approved card illustration. **Show 3 meaningfully different rendered arena compositions and obtain the user's choice BEFORE committing the new arena image or switching its runtime id.** This is new arena design, not another D153 card-art selection.

After arena visual approval, scope `ThreadTetherController` to the D153 production battle lifecycle only, native 54-case matrix and real victory→reward→table QA. **Not live**, absent from `RunState.CARD_PATHS` and `ACT1_CARD_IDS`; Act1 stays **35/45**, 12 Fate Spread cards + sealed XIII. Do not modify D151/D152, global combat or approved Fate Spread.

---


## 2026-10-15 — D153 APPROVED THEATRE-ALIGNED REDRAW INSTALLED; GODOT F6 ART QA PENDING

**CURRENT MAIN OVERRIDES OLDER D153 ATLAS MESSAGES.** After seeing the original tiny skeleton atlases, the user rejected their appearance as unrelated to the approved moonlit ruined-theatre card and approved the **new** crimson-robed two-character redraws («Подходит)»). The assistant recovered those accepted high-resolution renderings, repacked each pose individually into 96×96 padded frames and **replaced BOTH runtime `.webp.b64` atlases on GitHub**:
- `assets/pixel/units/deck_expansion_v1/threadbare_puppeteer_frames.webp.b64` — **44,426 decoded WebP bytes**, SHA-256 `93f8839a778709f3c144a97eb3bef51e0b16944dc796e7cf9ec690896d23b846`.
- `assets/pixel/units/deck_expansion_v1/bone_marionette_frames.webp.b64` — **43,114 decoded WebP bytes**, SHA-256 `eb51e5d13968921bfa4ee4e9adef65c9c1939fb15a91f9e10a1c88e37633c755`.

**Static QA:** 576×480 transparent lossless WebP; 6×5 96px cells; exactly **25 filled unique poses each** (idle4, walk6, attack6, hit3, death6); all 5 unused cells empty; >3px alpha-safe border for all used cells after WebP decoding; complete body/feet; source-right. Removed spill fragments from the imprecise generated sprite-sheet gutters, then applied restrained 96-colour pixel palette. The very small previous D153 atlases are retained under `*_frames_rejected_v1.webp.b64` for rollback; the old generic appearance is **not approved**. The stage silhouettes now follow the **already approved** card: tall crowned puppeteer with ragged dark-crimson mantle, bone face/chest and dangling strings; smaller bone marionette with torn white/red garments and stage rig.

**NEXT ACTION for user:** `git pull` then F6 **`res://scenes/dev/threadbare_theatre_art_preview.tscn`**, watch both roles across all five states (each state changes every 2s). Confirm silhouette, feet, scale, no invisible/blinking frames, facing and continuity; send screenshot/feedback. **The newly installed redraw has NOT been validated by user in native Godot. Static QA is NOT native visual acceptance.**

**Remaining D153 gates:** native F6 gallery user acceptance, original theatre battle arena (crypt is placeholder), scoped real `ThreadTetherController` battle lifecycle, 54-case combat matrix, actual victory→reward→table QA. D153 still **NOT LIVE**, absent from `RunState.CARD_PATHS` and `ACT1_CARD_IDS`; Act1 **35/45**, 12 Fate Spread + sealed XIII. Preserve D143/D167/D168, DS2 and previously accepted D151/D152 unchanged. Next stage after art F6 acceptance is original theatre arena; no premature live activation.

---


## 2026-10-15 — D153 USER-APPROVED REDRAW DIRECTION; PRODUCTION REPACK AND GITHUB REPLACEMENT PENDING

**NEWEST VISUAL HANDOFF:** Read `docs/D153_NEXT_CHAT_START.md` first. User rejected the previous tiny D153 sprite art (although it was technically complete and committed); user re-shared the previously approved ruined-theatre card illustration. A pair of newly **redrawn skeletal sprite sheet previews**, matching the theatrical crimson robes / bone / crown / marionette strings, were shown; user replied **«Подходит)»**. This is **approval of redrawn artistic direction**, not of the existing GitHub sprite files.

**Implementation status as verified:** GitHub still contains the **old rejected** `threadbare_puppeteer_frames.webp.b64` and `bone_marionette_frames.webp.b64`, not the newly accepted redrawn versions. Two new redraws were saved in the previous chat as `d153_threadbare_puppeteer_redraw.*` and `d153_bone_marionette_redraw.*` (PNG/WebP/Base64), but the naïvely downscaled 576×480 candidate has **cropped/bleeding sprite cell boundaries and nonempty unused cells** (25/25 frames touching outer 2px in both roles, 5/5 unused cells nonempty in both). Therefore these candidates require proper per-frame extraction/repacking and alpha validation **before** the strict Godot loader can accept them. **Do not tell user to `git pull`/F6 expecting approved redraws; no updated art was deployed yet.** The assistant must do the integration in GitHub without requesting ZIP/manual edits.

**Still unchanged:** D153 isolated tether logic F6 PASS, D153 card-art native display PASS, original theatre arena/battle integration/54-case QA pending; live Act1 **35/45**, not 36. Original card scene remains approved and should not be redrawn.

---


## 2026-10-15 — D153 ORIGINAL SKELETAL ANIMATION ATLASES COMMITTED; NATIVE ART QA PENDING

**Latest implemented source:** Both new, independently authored skeleton pixel-art animation WebP/base64 atlases now exist on `main`:
- `assets/pixel/units/deck_expansion_v1/threadbare_puppeteer_frames.webp.b64` (3,504 WebP bytes; SHA-256 `b3d13f1eea6f84eb43d6a3d14308b49f7cf0394beebe29bda72dfa4a4c8d0989`).
- `assets/pixel/units/deck_expansion_v1/bone_marionette_frames.webp.b64` (3,178 WebP bytes; SHA-256 `dcd1c3079917d1171b7026a9fa08aefd71e7121852d47fc136d42e0bef50e7eb`).

Each decoded lossless WebP is **576×480**, 6×5 transparent cells of 96×96 with **25 separately drawn, non-identical, visible skeleton poses** (idle 4, walk 6, attack 6, hit 3, death 6). Both were decoded and checked **after WebP export** for nonempty/unique used cells, transparent unused cells, two-pixel empty borders, full feet and source-right orientation. Both GitHub files were remotely refetched and their decoded bytes SHA-256 matched the local originals **exactly**. They are deliberately stylized hand-built pixel miniatures, not recycled enemy artwork, card-image cutouts or concept-board frames; full motion visual signoff remains the user's call. See `docs/D153_ANIMATION_ATLASES.md`.

**NEXT USER ACTION:** `git pull`, then **F6 `res://scenes/dev/threadbare_theatre_art_preview.tscn`**. Inspect both original skeletons across five repeating states (every 2 seconds), visible feet, direction, transitions, thread effects and no disappearing frames; send a screenshot or specific corrections. **This F6 has NOT been run in native Godot since the atlases were added, so do not claim user art acceptance or runtime PASS.** Existing prior D153 tether-logic F6 **PASS** remains valid; don't rerun it just to review sprites.

**Still gated (NOT live):** User's native gallery acceptance, authored theatre arena, production battle-only ThreadTether wiring, real battle→reward→table and 54-case matrix. D153 remains absent from both `RunState.CARD_PATHS` and `ACT1_CARD_IDS`; **live Act1 = 35/45**, 12 Fate Spread + sealed XIII. DS2 and D143/D167/D168 frozen. GitHub writes belong to the assistant; no manual ZIP, image transfer, code copy or upload.

---


## Card art approval workflow — show options BEFORE finalizing

**User-approved mandatory rule (2026-10-15):** Before producing/replacing final card illustrations, **show the user multiple distinct visual options (normally 3)** as actual image previews, not just written descriptions. Distinguish composition, framing, scene emphasis or lighting; avoid minor palette-only variations masquerading as options. **Wait for the user to choose/approve one** before replacing any live card art in GitHub. Iterate on the selected option if requested. Every option must already satisfy the scene-first dark-fantasy quality bar (D167), DS2 and text-free illustration rules. After approval, the assistant itself commits the approved image into GitHub (prefer versioned export-safe 448×274 WebP/base64), switches the runtime art pointer, keeps the previous file for one-step rollback, and asks the user only to `git pull` and inspect the Godot F6 card preview. Never require users to unzip assets, manually paste code or upload approved pictures for the assistant.

**Already-approved exception:** The user explicitly approved the scene-driven D152 replacement illustration on 2026-10-15. Transfer that exact image now; **do not ask for additional D152 concept choices retroactively**. Apply the options-first rule to D153 and all future card art passes.

## Card art quality bar — illustrated world scenes, never sprite showcases

**Mandatory for all new and revised encounter-card illustrations in Misdeal.** A card must look like a moment in the game's dark-fantasy world, **not a demonstration of character/unit sprites**.

- Depict an actual authored **place, situation or event**. Environmental storytelling must be visible: grounded architecture, functional props, ritual residue, worn materials, weather/smoke/magic and purposeful lighting.
- Give characters a **physical relationship to the scene**: matched light direction, cast/contact shadows, coherent scale and perspective, occlusion and action that communicates why they are present.
- Prioritize **scene composition and atmosphere** over showcasing complete character silhouettes. Approved enemy designs can inform the illustration, but simply placing sprite cutouts over a blurred/empty backdrop is not an acceptable final card.
- Preserve the accepted DS2 / Fate Spread Variant C materials, restrained dark-fantasy palette and clean 448×274 card-art slot. Do **not** bake UI buttons, titles, card frames, Russian text or choices into the illustration; Godot owns interface chrome and text.
- Review at **native displayed card size in Godot**, not just at source size. Require immediate read of place and encounter, good focal hierarchy, legible silhouettes, and no obvious repeated/generative detail noise.
- Apply this to **every future encounter card**; existing approved cards may be audited and improved opportunistically without indiscriminate redesign or replacing their gameplay.

**Explicit anti-pattern:** characters presented like two pasted game sprites on a soft/blurred background with no credible world scene.

## New-chat bootstrap

**NEW CHAT PRIORITY — D153 HANDOFF (2026-10-15):** Read **[`docs/D153_NEXT_CHAT_START.md`](docs/D153_NEXT_CHAT_START.md)** first. User explicitly paused this session to start the next development stage in a fresh chat. **Actual Godot F6 thread smoke PASS** (32% protection, 285px, break/reconnect/death/cleanup), approved chosen third skeletal theatre card art displayed in Godot. Original **two full 25-frame animation atlas files are absent from GitHub** (both exact file paths and next steps documented in handoff); animation loader and F6 gallery are already committed but have NOT passed native art QA. Next task: assistant produces and commits authentic skeleton Puppeteer + Marionette animation atlases, then user only `git pull` + gallery F6. No gameplay/card activation, live pool **35/45**. New chat must verify repository `main` and honor D143/D167/D168. Do not re-ask GitHub access.


**CURRENT D153 STATUS (2026-10-15): NATIVE SKELETAL STRINGS F6 PASS.** User's actual Godot screenshot shows `D153 / SKELETAL STRINGS — PASS` and debugger error count 0: 32% linked marionette protection within 285px, out-of-range break, master-death instant break, multiplier cleanup, distinct skeleton roster/two deployments all pass. D153 original moonlit theatre card picture was shown rendering in Godot earlier. Next in repository: `scripts/battle/unit_animation_library.gd` now has STRICT role branches for `threadbare_puppeteer` and `bone_marionette` refusing absent, edge-cropped, repeated or partially empty 576x480 25-frame `.webp.b64` sprites. `scenes/dev/threadbare_theatre_art_preview.tscn` was added for five-state Godot art QA. **Actual D153 original 25-frame atlases have NOT been committed**; image concept boards are NOT game atlases, so do not ask user to run the gallery yet. After genuine original assets are committed and verified, use gallery F6, then original combat arena, real battle wiring, 54-case matrix, reward/table QA. **NOT LIVE**; Act1 still 35/45, only source/data/art-card + isolated tether logic available. Newest details in `docs/DECK_EXPANSION_D153_THREADBARE_THEATRE.md` and `docs/NEXT_CHAT_HANDOFF.md`. GitHub access is working; make changes directly; user should never manually unzip or edit code.


**LATEST D153 2026-10-15 — SKELETAL THEATRE QA PACKAGE IN MAIN:** User chose the **third** displayed moonlit ruined puppet-theatre concept and corrected the whole roster to **undead skeleton marionettes**, not wooden dolls. Exact selected 448×274 illustration is in GitHub `assets/pixel/card_unification_v1/run/threadbare_theatre_approved_v1.webp.b64`, verified against source after refetch. D153 has ORIGINAL `threadbare_puppeteer` + `bone_marionette` UnitData, authored two-formation EncounterData, QA-only RunCardData; local tether controller `scripts/battle/thread_tether.gd` protects linked puppets by 32% within 285px, restores protection on separation or master death. Only F6 **ART PREVIEW** `scenes/dev/threadbare_theatre_card_preview.tscn` and isolated **MECHANIC SMOKE** `scenes/dev/threadbare_theatre_smoke.tscn` are currently staged; **NATIVE GODOT PASS NOT YET RECEIVED**. Missing original 25-frame/role animations, actual theatre arena, production battle wiring & 54-case QA: D153 is **NOT live** and absent from both CARD_PATHS and ACT1_CARD_IDS; current Act1 stays **35/45**. User next only `git pull`, F6 these two D153 scenes and send screenshots. Other mechanics DS2/Fate Spread/12+XIII unchanged. Canonical `docs/DECK_EXPANSION_D153_THREADBARE_THEATRE.md` and `docs/DECISIONS.md` D169; do not resurrect abandoned ordinary wooden marionette concept. All GitHub changes owned by assistant.


**LATEST 2026-10-15 — D152 V2 NATIVE USER ACCEPTED; D153 VISUAL CONCEPTS FIRST:** User explicitly replied «все ок, погнали дальше» after F6 inspecting the approved scene-led 448×274 `defiled_laboratory_scene_v2.webp.b64` illustration. Mark D152 world-scene art native-accepted, live Act1 **35/45**, gameplay untouched. D153 is *only proposed*, NOT implemented and NOT in live deck. Proposed unique encounter: `Threadbare Theatre / Театр оборванных нитей` with genuinely original puppet master + wooden marionettes and candidate thread-link tactics (not finalized). Per D168 show **THREE distinct actual image concepts before user approval**: A frontal crimson stage, B oblique eerie backstage with hanging strings/shadows, C diagonal broken stage with severed strings. Image generation attempted in this conversation; don't assume selected or generated assets are stored in GitHub. Previous unrelated chapel/caravan generations were **rejected**, not viable D153 art. Do not implement D153 combat/commit artwork until user approves direction. For updates use GitHub connected writes directly; do not request permission or user-side code copying. Canonical `docs/NEXT_CHAT_HANDOFF.md` and `docs/DECISIONS.md` D143/D167/D168.


**LATEST 2026-10-15 — D152 APPROVED V2 IMAGE INSTALLED:** User approved the distinct environment-led laboratory illustration shown in chat. Exact authored **448×274** WebP is now in GitHub at `assets/pixel/card_unification_v1/run/defiled_laboratory_scene_v2.webp.b64`; `scripts/ui/card_unification_v1.gd` points to it. Its GitHub bytes match the original, and the old `run/defiled_laboratory.webp.b64` remains unchanged for rollback. Card 35/45, AI, animations, DS2 and 12+XIII unchanged. **User native F6 V2 art review still pending.** Only user action: `git pull`, F6 `scenes/dev/defiled_laboratory_card_preview.tscn`. **D168 mandatory new art workflow:** next time (D153+), create and SHOW 2–3 meaningfully different IMAGE concepts (default 3), await explicit user choice, and ONLY THEN commit the chosen art and switch runtime. This D152 image was already chosen by user, so no new variants required for it. Read `docs/NEXT_CHAT_HANDOFF.md` and `docs/DECISIONS.md` D167/D168. Connected GitHub edits remain assistant-owned.

**LATEST D167 / D152 ART CANDIDATE (2026-10-15):** Scene-driven encounter card art is NOW A MANDATORY USER-APPROVED RULE in this file and `docs/DECISIONS.md` D167. A new illustrated Gothic laboratory candidate with real environment/props/lighting and the original Alchemist + Homunculus was generated and locally downsampled to **448×274**, visually inspected, but **NOT uploaded to GitHub yet**: the Library container-path bridge returned `Container session expired`. The live D152 card (35/45) STILL loads the older blurred-sprite visual from `assets/pixel/card_unification_v1/run/defiled_laboratory.webp.b64`. Do not claim the new image is live or user-approved. Next objective: transfer versioned new art through connected GitHub without asking user for ZIP/PowerShell/manual edits; preserve old art for rollback, update loader, and obtain F6 native screenshot. `docs/NEXT_CHAT_HANDOFF.md` has details.\n\n
**POST-RELEASE NATIVE PREVIEW CONFIRMATION:** User provided Godot screenshot showing the now-live D152 card art preview opening without visible errors, with original 448x274 art, title, description, Act1 status and playtest button. This confirms the F6 preview, NOT randomized normal dealing. User-facing visual issue noted: the actual shipped card illustration looks like two character sprites over a blurred green background, not an environment-led painted alchemy laboratory. An optional original environment art polish has been proposed but NOT implemented/approved; respect DS2 and no embedded UI controls. Newest notes in `docs/NEXT_CHAT_HANDOFF.md`.\n\n**LATEST 2026-10-15 D152 RELEASE TO MAIN — LIVE ACT1 35/45:** `defiled_laboratory` is now the **35th nonboss Act1 card** in `scripts/core/run_state.gd::ACT1_CARD_IDS`. Original 448×274 card art is in `assets/pixel/card_unification_v1/run/defiled_laboratory.webp.b64`; original Plague Alchemist and Unstable Homunculus 25-frame atlases, two formations and local toxic zones remain unchanged. Godot screenshot of the **post-D152-balance F6 matrix** gave **54/54 technical PASS**, 54 wins/0 losses, solo/duo/trio avg surviving HP **70/57/60%**, casualties **0/4/4**, tactics ASSAULT/HUNT/FORMATION surviving HP **70/49/69%**, warning/hit/spill counts **73/512/108**, max combat **16.6s**. This justified a Tier1 playable release, NOT a final balance certificate. Previous user feedback accepted original card visual and dev win→reward→table. Release updated 35-card smoke guards and retired obsolete 33-/34-card assertions. **The new LIVE 35-card pool has NOT YET been rerun in native Godot since activation.** Next user action is only `git pull` and a normal Godot run or a quick relevant F6 scene; assistant must fix new errors directly in connected GitHub, no code copying/ZIP/PowerShell. Run still **12 cards + sealed XIII**. Next card target **36/45** (10 remaining) with D143 genuinely new enemies and art. Canonical detail: `docs/NEXT_CHAT_HANDOFF.md`, `docs/DECK_EXPANSION_D152_BALANCE_V1.md` and `docs/DECISIONS.md` D166. Older D152 text below describing 34/45 and art staged is historical.

**Latest canonical restart snapshot:** [`docs/NEXT_CHAT_HANDOFF.md`](docs/NEXT_CHAT_HANDOFF.md), with long-form context in [`docs/SESSION_HANDOFF_2026_10_15.md`](docs/SESSION_HANDOFF_2026_10_15.md) and verified native QA in [`docs/DECK_EXPANSION_D151_FINAL_SMOKE_QA.md`](docs/DECK_EXPANSION_D151_FINAL_SMOKE_QA.md). **LATEST 2026-10-15: D151 Funeral Procession is live card 34/45, user screenshot in Godot shows FINAL 54/54 PASS (54 wins/0 losses; 58 Last Rite warnings, 38 revivals, 14 buffs). Previously-freed target crash is no longer reproduced in latest F6 run; old crash/pending notes are historical.** Original D151 art/facing accepted. Smoke is **not** balance certification (100% wins) and **not** full fight→reward→table confirmation; those remain separate later QA. Preserve 12+XIII, D143 original enemy/art requirement for remaining 11 cards, DS2/Variant C, unresolved D142 tactics. GitHub access is connected: implement and commit yourself, do not ask again. This latest statement overrides older pending instructions in prior documents.

GitHub is the source of truth for the current technical state of Misdeal.

At the start of a new chat, before proposing architecture or code changes, read:

1. `AGENTS.md`
2. `docs/CONCEPT.md`
3. `docs/SESSION_CHECKPOINT.md` (short, current restart brief)
4. `docs/PROJECT_STATE.md`
5. `docs/ROADMAP.md`
6. `docs/DECISIONS.md`
7. `docs/HANDOFF.md`
8. `docs/VISUAL_ASSET_REGISTRY.md`
9. `docs/DESIGN_SYSTEM.md` (when working on UI or visual presentation)
10. `docs/UNIT_ANIMATION_PACK1.md` and `docs/UNIT_ANIMATION_PACK2.md` (when working on unit art or animation)

For implemented code and current project state, prefer GitHub over remembered chat context.

Do not ask the user to repeat information that is already captured in these files.

At the end of a meaningful development session, leave the repository in a state from which another fresh chat can continue without reading the full conversation history.

## Product

Misdeal is a dark-fantasy card-driven roguelike with a compact tactical autobattler.

The player sits across from an evil wizard who controls a cursed game table. Exploration is represented by cards. Combat encounters resolve as short tactical autobattles.

Core loop:

1. Reveal or choose a card.
2. Resolve an event.
3. If combat: inspect enemies and arrange the party.
4. Run a short autobattle.
5. Receive consequences and rewards.
6. Continue the run.

## MVP direction

Build the smallest playable vertical slice first:

- card/event flow;
- one combat encounter;
- 3 player units vs 3 enemies;
- pre-battle placement;
- automatic targeting, movement and attacks;
- win/lose state;
- reward screen;
- return to the table.

## Tech

- Godot 4.7.x
- GDScript only
- Prefer text-based `.gd`, `.tscn` and `.tres` resources.
- Avoid third-party addons unless explicitly approved.
- Keep systems data-driven with Godot Resources where practical.

Do not migrate to C#/.NET without an explicit project decision.

## Code rules

- Use typed GDScript where it improves clarity.
- Prefer small focused scripts over one large manager.
- Use signals for cross-system communication when appropriate.
- Avoid hard-coded content values when they belong in data resources.
- Keep file names, node names, class names, resources and code in English.
- Keep code comments concise and useful.
- Do not introduce networking, ECS, dependency injection frameworks, or premature abstractions.
- Optimize for a playable vertical slice, not hypothetical future scale.

## Working with the user

The user runs Godot locally and pulls changes through Git.

When the user explicitly asks to implement or fix something:

- inspect the current GitHub code first;
- when connected GitHub tools are available in the session, use them directly;
- do not claim GitHub write access is unavailable without first checking the connected repository/tool state;
- make the changes directly in the repository when possible;
- do not make the user manually copy code that can be committed;
- use meaningful commit messages;
- after the change, tell the user only what they need to do locally, normally `git pull`, run the project, and what to verify.

When an error is reported, inspect the current repository before suggesting manual edits.

## Documentation maintenance

After a substantial implementation:

- update `docs/PROJECT_STATE.md`;
- update `docs/ROADMAP.md` when priorities or completed milestones change;
- record important technical or game-design decisions in `docs/DECISIONS.md`;
- update `CHANGELOG.md`.

`docs/PROJECT_STATE.md` must describe what actually exists in the repository, not intended future behavior.

## Project structure

- `scenes/` — Godot scenes
- `scripts/` — gameplay code
- `resources/` — unit/card/item/encounter data
- `assets/` — art/audio/fonts
- `docs/` — game and technical notes

## Art direction

Dark-fantasy pixel art, cursed tabletop, theatrical evil wizard, tactile cards and readable tactical miniatures.

Combat readability comes before detail: units must be recognizable by silhouette, team color is secondary, and UI should not overpower sprites.

Use nearest-neighbor presentation for pixel assets. Avoid mixing realistic painted unit portraits into the combat field.

For UI work, extend the existing `scripts/ui/misdeal_ui_kit.gd` and follow `docs/DESIGN_SYSTEM.md`. Do not restyle approved game screens solely to unify components; validate against actual 1280×720 Godot screenshots.

The prototype may still use simple shapes and text where needed, but new player-facing art should move toward one coherent pixel-art language.

## Current priority

Make a playable vertical slice before polishing visuals.

Do not change the fundamental game design without discussing it with the user first.
