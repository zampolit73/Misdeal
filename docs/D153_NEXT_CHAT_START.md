# Misdeal — D153 current handoff (2026-10-15)

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


Repository: `zampolit73/Misdeal`, branch `main`. Read `AGENTS.md`, `docs/CONCEPT.md`, `docs/PROJECT_STATE.md`, `docs/ROADMAP.md`, `docs/DECISIONS.md` first; GitHub is the live technical truth. The assistant uses the connected GitHub tools to make all changes; user uses local Godot 4.7.x and `git pull`.

## Confirmed by user
- D153 card scene: chosen third, original moonlit destroyed theatre with **skeletal undead** puppeteer and two skeletal marionettes; source card art 448×274 has rendered in Godot.
- Redrawn crimson-bone animation atlases `threadbare_puppeteer_frames.webp.b64` and `bone_marionette_frames.webp.b64` were user-accepted after five-state gallery F6 («все ок»); never revert to the old generic mini-skeletons.
- Approved D153 arena image: latest rendered `лунная_арена_среди_руин_театра.png`, a relatively understated dark backstage scene with ONE distant silhouette, moon through broken roof, asymmetrical ladders, old rigging and open floor. User explicitly said «утвердили — продолжай» and requested implementation.
- Earlier isolated `scenes/dev/threadbare_theatre_smoke.tscn` native screenshot **PASS**, 0 displayed errors: 32% marionette damage reduction within 285px, severed distance, master death, and cleanup. This does **not** certify production battle.

## Now committed to main (source-integrated, not native-tested yet)
- `assets/pixel/battle/arenas/threadbare_theatre_approved_v1.webp.b64`: approved picture downsampled to 1280×720 WebP; 94,090 bytes decoded; SHA-256 `6cb6db8138afca085add843833fbf579c00c99f81535a8a2f6266850e102ebe0`. Refetched GitHub encoded contents byte-for-byte matched source.
- `resources/encounters/threadbare_theatre.tres` now points to `arena_id = "threadbare_theatre"`. `scripts/battle/authored_backdrop.gd` + `battle_visual.gd` route this specific arena to its new art and unobtrusive atmosphere.
- `scripts/battle/battle.gd` wires `ThreadTetherController` **only for D153**. Instantiates after enemy spawn, starts after intro, stops/restores on combat conclusion; enemy leader must be `threadbare_puppeteer`, 2 allies `bone_marionette`. Existing mechanisms for other encounters are untouched.
- `scripts/core/run_state.gd` includes D153 in `CARD_PATHS` **only for dev QA to reach real reward flow**. `ACT1_CARD_IDS` still excludes it: live Act1 remains **35/45**.
- `scenes/dev/threadbare_theatre_battle_smoke.tscn` — NEW 54-case F6 deterministic matrix, actual combat units and tether controller.
- `scenes/dev/threadbare_theatre_playtest.tscn` — NEW real battle → reward → table isolated QA entry. It sets up a Knight and injects an explicit D153 dev offer; no live deck insertion.

## Immediate next native checks (user only)
1. `git pull`, F6 `res://scenes/dev/threadbare_theatre_battle_smoke.tscn`; send screenshot showing PASS/FAIL, 54/54, victory/defeat and linked/broken counters.
2. F6 `res://scenes/dev/threadbare_theatre_playtest.tscn`. Observe original theatre **arena and skeletons**, actual battle, links, fight end → Claim Reward → Table. Send screenshot or exact error; assistant must fix in GitHub.

**Do not call native QA PASS yet**; no Godot binary available in authoring runtime. Matrix PASS will prove technical completion only; balancing with solo/duo/trio damage/HP telemetry is a separate user acceptance gate. D153 is NOT randomly playable until verified/released as #36. Keep DS2/Fate Spread I–XII+sealed XIII, D143 original-enemy rule, D167/D168 scene-first art/approval rule and all previously accepted D151/D152 visuals locked.
