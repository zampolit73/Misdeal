## 2026-10-15 — CANONICAL D153 NEXT-CHAT HANDOFF (SESSION PAUSED)

**Start the next chat with `docs/D153_NEXT_CHAT_START.md`.** The user requested ending this work session and continuing the **next stage** in a fresh chat; this file is the authoritative concise checkpoint, with concrete file paths, confirmed Godot evidence, pending exact sprite atlas resources and first next action. User's **D153 / SKELETAL STRINGS — PASS** screenshot confirms ONLY the isolated tether logic. D153 448×274 skeletal theatre art renders in Godot, and the strict 25-frame/role animation loader and F6 gallery source are already committed. **Both actual 576×480 D153 sprite atlases are MISSING and must be created/committed next** before asking user to run the gallery. D153 NOT in the live deck, Act1 remains **35/45**. No need to replay previous card-preview or thread-logic tests; assistant should use connected GitHub to produce art and code, user just `git pull` and test when genuine sprites are installed. D143/D167/D168 and 12+sealed XIII remain locked.

---

## 2026-10-15 — D153 SELECTED SKELETAL THEATRE ART + ISOLATED THREAD MECHANIC STAGED (NATIVE QA PENDING)

**User correction and approval:** all D153 marionettes must be **skeletal undead**, consistent with Misdeal's Act1, not wooden dolls. User chose the **third** shown image (ruined gothic puppet theatre under moonlight) and asked to continue. This satisfies D168 art-options-before-selection for this encounter. D153 new identities are `threadbare_puppeteer` (skeletal leader) and `bone_marionette` (two skeletal marionettes); NO reuse of old enemy atlas/roles. Both D152 original animation/card art already accepted and retained.

**GitHub source now staged:** selected/refined D153 art committed as strict **448×274** `assets/pixel/card_unification_v1/run/threadbare_theatre_approved_v1.webp.b64` (SHA256 of WebP `9a98c35b46f820acea3a0e3e3821fdb652f31a611428f384be6fd16900e260c3`), remotely refetched and source matched exactly. Loader `card_unification_v1.gd` returns it only for QA `threadbare_theatre`. Added original two skeleton `UnitData` Resources, an `EncounterData` with two placements and QA-only `RunCardData`. `scripts/battle/thread_tether.gd` applies **local 32% marionette damage reduction** when within **285px** of a living skeletal master, draws physical links, breaks/reconnects by movement and restores baseline immediately if master dies. No global BattleUnit modification. Dedicated F6 `scenes/dev/threadbare_theatre_smoke.tscn` asserts mechanics; `scenes/dev/threadbare_theatre_card_preview.tscn` previews approved art.

**HARD BOUNDARY:** New D153 scenes and controller have **NOT yet been executed in native Godot**. The controller is **NOT wired into real battle.gd**; the original 25-frame sprites and actual theatre arena are NOT yet made. D153 is NOT in `RunState.CARD_PATHS` nor `ACT1_CARD_IDS`; live deck remains **35/45**, 12+sealed XIII. This stage avoids exposing placeholder or reused skeleton art. Next user action solely `git pull`, F6 `threadbare_theatre_card_preview.tscn` and F6 `threadbare_theatre_smoke.tscn`, send screenshot of PASS/FAIL. Then assistant develops original animations (25 frames per role), battle wiring and 54-case QA before 36/45. Rule in `docs/DECISIONS.md` D169; full current source `docs/DECK_EXPANSION_D153_THREADBARE_THEATRE.md`. Earlier wooden-puppet proposals are obsolete.

---

## 2026-10-15 — D168 ART OPTIONS FIRST; D152 SELECTED ENVIRONMENTAL ILLUSTRATION ACTIVE

**ACTUAL state in GitHub:** approved D152 original 448×274 world-scene image installed at `assets/pixel/card_unification_v1/run/defiled_laboratory_scene_v2.webp.b64`. Runtime `scripts/ui/card_unification_v1.gd::D152_CARD_WEBP_B64` now points at V2; legacy `run/defiled_laboratory.webp.b64` retained, allowing a one-line rollback. Remote GitHub text bytes matched source exactly. User explicitly chose/approved this image in chat. **Native Godot V2 card preview pending**, NOT automatically validated. Act1 live count **35/45**, game logic/animation/tactics/DS2 unchanged. No user ZIP handling.

**Mandatory future art workflow now D168:** show default **3 visibly different rendered image compositions** first, let user select or request revisions, only then author/commit the selected final bitmap. Applies to D153+, all future cards/redraws. Each candidate must comply with D167 dark-fantasy scene-first standard (not sprite showcase). User need only `git pull` and F6 `scenes/dev/defiled_laboratory_card_preview.tscn` now; no code or asset copying.

---

## 2026-10-15 — D152 RELEASED as Act1 card 35/45 (post-release native check pending)

**Verified before release:** user Godot screenshot of the **POST-TUNE** 54-case D152 combat matrix: 54/54 FUNCTIONAL PASS, 54 wins/0 losses; average remaining HP **70% solo / 57% duo / 60% trio**; hero casualties **0/4/4**; average duration **10.8/12.2/10.9s**, longest **16.6s**; tactics ASSAULT/HUNT/FORMATION each 18 victories, remaining HP **70/49/69%**; acid warnings **73**, hits **512**, spills **108**. This is the current result, not the old 67/435/14.9 pre-tune screenshot. The measured attrition is enough to release this Tier1 candidate without further buffs; technical 100% test wins are **not balance certification**. Approved original 448×274 card illustration and both 25-frame enemy atlases are in GitHub, and user previously accepted dev-preview real win→reward→table.

**RELEASE IMPLEMENTED IN MAIN:** `scripts/core/run_state.gd` now puts `defiled_laboratory` into `ACT1_CARD_IDS` (35 unique nonboss Act1 cards total; the 12+sealed XIII run length is unchanged). D152 remains in `CARD_PATHS`; do not add it twice. Updated 35-card assertions in `bone_shepherd_smoke.gd`, `funeral_procession_smoke.gd`, `last_rite_smoke.gd`, `defiled_laboratory_smoke.gd`, `defiled_laboratory_battle_smoke.gd` and adjusted `defiled_laboratory_playtest.gd` / `defiled_laboratory_card_preview.gd` to continue functioning after release. Other enemies, global multipliers, tactics, D143 originality, DS2 and Fate Spread untouched.

**Important qualification:** New 35-card pool code was reviewed/committed but **has not been rerun in the user's native Godot after activation**. The earlier D152 54-case F6 and dev real fight confirmations occurred **before** the card was placed into the live deck. Next user action: `git pull`, launch Godot and play a normal run / verify no new errors. No ZIP, PowerShell or manual edits. If any regression appears, assistant fixes it directly via connected GitHub. Next expansion target is **36/45** (10 remaining).

---

## 2026-10-15 — D152 CARD ART EXPLAINED; ENCOUNTER-ONLY BALANCE V1 RECHECK PENDING

**Actual card art vs concept:** original D152 448×274 image of Alchemist/Homunculus/acid lab is ALREADY tracked as `assets/pixel/card_unification_v1/run/defiled_laboratory.webp.b64` and displayed via `card_unification_v1.gd` and F6 card preview. The earlier large UI mock-up with buttons was concept art only; keep DS2 and no bypass mechanic. User previously replied «Все ок» to the real preview→battle→reward→table workflow (user-reported, not an automated trace). D152 is still **NOT IN THE LIVE ACT1 DECK (34/45)**.

**New provisional D152-only tuning:** Alchemist HP 108/damage 7.5; Homunculus HP 84/damage 9; acid cooldown 4.5s, pulse 6 damage, same 1.2s warning, 2.2s active duration, 66 radius; telegraph prefers dense living hero groups instead of first party member. No global balance or other cards changed. D152's existing 54-case native screenshot (**54 wins/0 losses**) is **PRE-TUNE baseline**, NOT fresh evidence. New F6 scene reports wins by party/tactic and residual HP, time and hero deaths, and verifies group target selection. **NOT YET RUN after tuning.** Next minimal user step `git pull`, F6 `res://scenes/dev/defiled_laboratory_battle_smoke.tscn` and send result. No ZIP, code edits or PowerShell. Details in `docs/DECK_EXPANSION_D152_BALANCE_V1.md`. Release to **35/45** only after measured balance acceptance.

---

## D152 QA UPDATE — 2026-10-15 — GODOT 54/54 PASS; ORIGINAL CARD ART STAGED

**User's Godot screenshot confirms:** `res://scenes/dev/defiled_laboratory_battle_smoke.tscn` **FUNCTIONAL PASS**, 54/54 completed, 54 wins / 0 losses (solo 18/0, duo 18/0, trio 18/0), 67 chemical telegraphs, 435 toxic hits, 108 death spills, maximum battle 14.9 seconds. This replaces any previous D152 "54-case pending" statement. Original D152 Plague Alchemist + Homunculus animation gallery was separately approved by user, and both real 25-frame atlases are already in GitHub. **54/54 is a technical smoke, NOT balance approval.** 100% wins in all compositions merits later challenge evaluation; do not change global solo/duo scalers or other encounters automatically.

**New candidate artwork (not yet native/user approved):** Original D152 card illustration assembled from D152 original enemy artwork and generated cursed-alchemy-laboratory imagery into a single **448×274** text-free WebP scene. GitHub `assets/pixel/card_unification_v1/run/defiled_laboratory.webp.b64` contains its packed bytes; independently refetched from GitHub and matched to source. `scripts/ui/card_unification_v1.gd` resolves this **only for `defiled_laboratory`** via a strict 448×274 loader, with no fallback to another card. New F6 `res://scenes/dev/defiled_laboratory_card_preview.tscn` displays the illustration and lets the user click **«ПРОВЕРИТЬ В БОЮ»** to enter `defiled_laboratory_playtest.tscn`. The generated concept UI text/button `Обойти` is **not gameplay** and was not implemented or baked into the card art; encounter stays combat-only.

**Still pending:** Godot 4.7.2 **native card art F6 inspection / user visual acceptance**; **normal win → reward selection → table** check with the dev-only card; measured fair challenge assessment. Keep D152 **QA-only `CARD_PATHS`**, **NOT `ACT1_CARD_IDS`**, Act1 **34/45**, run shape **12+sealed XIII**. Do NOT claim D152 live 35/45. No archive/PowerShell required: `git pull`, F6 `res://scenes/dev/defiled_laboratory_card_preview.tscn`, inspect card, click button, finish battle, choose reward, return to table, report result. The latest source still needs a native Godot run; any error should be fixed by assistant directly through GitHub. Detailed checkpoint: `docs/DECK_EXPANSION_D152_DEFILED_LABORATORY.md`.

---

## FIRST READ — D152 approved unit-art gallery; 54-fight smoke F6 pending (2026-10-15)

User showed new Godot 4.7.2 D152 animation gallery screenshot with original Alchemist and Homunculus successfully displayed and replied «Все ок». Prior role type parser error is resolved. Visuals are accepted; both original 25-frame WebP atlases already live in GitHub and require only git pull. **New** `res://scenes/dev/defiled_laboratory_battle_smoke.tscn` contains a 54-case functional matrix (2 formations, 3 heroes, party sizes 1/2/3, 3 tactical orders) with chemical hazard statistics. **NOT YET EXECUTED IN GODOT.** Next minimal user action: `git pull`, F6 that scene, send result. D152 remains QA-only, NOT live, Act1 still 34/45; 448×274 card art and full victory→reward→table flow pending. Full details: `docs/NEXT_CHAT_HANDOFF.md` and `docs/DECK_EXPANSION_D152_DEFILED_LABORATORY.md`.

---

## 2026-10-15 — D152 ART GALLERY GODOT PARSER HOTFIX; REAL BATTLE SCREENSHOT

User supplied two real Godot 4.7.2 screenshots. **Gallery error:** `scripts/dev/defiled_laboratory_art_preview.gd:21` had `var role := ROLES[i]` and Godot reported "Cannot infer the type of 'role' variable because the value doesn't have a set type." Committed a source fix: explicit `String` for role/state, explicit `SpriteFrames` and `Label` locals, stable typed loop frame-count checking. **Native F6 gallery recheck pending; do NOT mark the gallery PASS yet.** Separate user screenshot shows a running REAL `defiled_laboratory_playtest.tscn` battle: new alchemist + two homunculi rendered on the arena against Knight, an active hazard ring visibly present. This is visual proof that a battle launches and original enemy sprites display; NOT a full combat win, reward/table, balance or 54-case matrix certification. Both original atlases are tracked in GitHub. **No global gameplay/balance/AI adjustments.** D152 remains QA-only CARD_PATHS, not `ACT1_CARD_IDS`; live Act1 stays 34/45. User only needs `git pull`, reopen gallery F6 and share result, then finish a battle and confirm reward→table; assistant owns all code fixes. See `docs/DECK_EXPANSION_D152_DEFILED_LABORATORY.md`.

---

## 2026-10-15 — D152 BOTH ORIGINAL ANIMATION ATLASES NOW IN GITHUB MAIN (NO ZIP!)

**Override older D152 temporary-art notes:** original `plague_alchemist_frames.webp.b64` and `unstable_homunculus_frames.webp.b64` have BOTH been committed under `assets/pixel/units/deck_expansion_v1/`. Exact returned GitHub file bytes were independently refetched and compared to the local prepared source: **MATCH**. Each losslessly verified *for alpha and 25 distinct decoded cells* from the actual quality-80 WebP: 576×480, active 4/6/6/3/6, 25 distinct frames, empty outer 2px borders. **User no longer needs the previous ZIP, local PNG extraction, PowerShell or file copying.** Their ONLY next local steps: `git pull`, F6 `res://scenes/dev/defiled_laboratory_art_preview.tscn`, then (if visually fine) F6 `res://scenes/dev/defiled_laboratory_playtest.tscn`. Both gallery and real battle are **NOT yet native certified**. The isolated D152 hazards already passed F6; no full battle/balance PASS claimed. Original 448×274 card art still missing. `defiled_laboratory` remains QA-only `CARD_PATHS` lookup, NOT in `ACT1_CARD_IDS` (**34/45** live). Precise current source: `docs/DECK_EXPANSION_D152_DEFILED_LABORATORY.md`. D151 full reward/table is still separately unverified; preserve D143 originality, DS2 and 12+XIII.

---

## 2026-10-15 — D152 staged original animation QA + encounter-scoped real battle (NATIVE QA PENDING)

**Current implementation:** D152 `defiled_laboratory` remains **NOT LIVE**, Act1 **34/45**, Fate Spread 12+XIII unchanged. User-confirmed prior isolated `defiled_laboratory_smoke.tscn` was **PASS**. New code wires `LaboratoryHazardController` ONLY to D152 in `battle.gd` start/stop, makes `defiled_laboratory` a CARD_PATHS **lookup-only QA card** (NOT ACT1_CARD_IDS), adds strict animation loading for two original D152 roles and F6 `defiled_laboratory_art_preview.tscn` / `defiled_laboratory_playtest.tscn`. These new scenes **have not been run in Godot**. Original 25-cell/role 576×480 transparent art atlases were generated and passed *offline* alpha/uniqueness/padding checks, but binaries currently live in a conversation ZIP, **NOT in GitHub** (connected GitHub API is text-only). For native art QA, download `misdeal_d152_animation_preview_pack.zip` from the conversation and unzip its contents into project root **after git pull**: files go to ignored `assets/local_previews/d152/` to avoid future untracked Git conflicts. Then F6 art gallery, then F6 real Knight playtest; report screenshots/errors. Native art approval, original 448×274 card illustration, GitHub production binaries, 54-case real fight matrix, reward/table verification remain pending. `docs/DECK_EXPANSION_D152_DEFILED_LABORATORY.md` is detailed canonical source. Do not mistake this staging for 35/45 or completed release. D151 isolated 54/54 F6 PASS remains true, but D151 normal victory→reward→table is still a separate pending QA.

---

## 2026-10-15 — D152 DATA STAGING (NOT LIVE) + D151 INTEGRATION GATE

After user approval of next stage, inspected real `battle.gd` victory transition to `reward.tscn`, and `reward.gd` calling `RunState.complete_active_card()` then routing to table. This flow exists in code but native end-to-end D151 victory→reward→table is still **UNVERIFIED**. Previously verified D151 54/54 isolated F6 PASS is unchanged; do not rerun it reflexively.

Added **D152 Defiled Laboratory as staged data only**: original `plague_alchemist` and `unstable_homunculus` UnitData, `defiled_laboratory` EncounterData with two formations. **No playable release**, no card registry change, no original animations or card art yet, no hazard controller yet. Details and release criteria: `docs/DECK_EXPANSION_D152_DEFILED_LABORATORY.md`. Remains **34/45** live cards, 11 missing. NEXT: user can F6 `res://scenes/dev/funeral_procession_playtest.tscn` and complete win→reward→table manually; assistant then develops original D152 art + encounter-local hazards + native QA before shipping to deck. Preserve D143 originality rule, DS2, 12+XIII, and D142 backlog.

---

## FIRST READ, CURRENT 2026-10-15 — D151 verified Godot PASS

The previous blocking `_is_valid_target` crash has now been superseded by **user's Godot screenshot of D151 `FUNERAL PROCESSION — PASS`**: 54/54 combats complete; 54 wins, 0 losses, 58 warning telegraphs, 38 one-time revivals, 14 attack-speed buff occurrences, both original atlases/cards loaded. User previously approved corrected D151 character feet, coffin rendering and facing. `funeral_procession` is *live*, card 34 of 45; 12+XIII per run. **Do not ask to rerun same smoke** absent new regression. Full UI battle→reward→table still *not certified*, and 54 wins of 54 require a future measured balance check. For next-chat workflow read `docs/NEXT_CHAT_HANDOFF.md` and `docs/DECK_EXPANSION_D151_FINAL_SMOKE_QA.md` alongside consolidated `docs/SESSION_HANDOFF_2026_10_15.md`. Preserve all previous approval, D143 original-new-enemies mandate and separate D142 tactical balance backlog. No source/gameplay changes in this QA documentation pass.

---

## CONSOLIDATED NEW-CHAT HANDOFF — 2026-10-15 — D151 is CURRENT, D145 art history preserved

**Current cross-chat source of truth:** `docs/SESSION_HANDOFF_2026_10_15.md` (full integrated history), then **`docs/NEXT_CHAT_HANDOFF.md`** (most recent D151 bug/runtime details). GitHub main currently has **34/45 Act1 cards**, latest `funeral_procession` with all-new Priest/Pallbearers and Last Rite; **12 + XIII run shape unchanged**. DO NOT regress to earlier Bone Shepherd 31-card checkpoint. First priority remains native Godot **F6 `scenes/dev/funeral_procession_smoke.tscn`** after `git pull` and a **complete Godot editor restart**: previous user screenshot twice reproduced `BattleUnit._is_valid_target` use-after-free. GitHub main already has Variant validation, smoke immediate fixture free, and additional upfront freed-target reset in `_process` (latest protective commit `a59a9d9`). The possibility of a stale local/cached typed GDScript is unproven; if repeat, collect `git log -1 --oneline` and Godot debugger. **54/54 new F6 PASS NOT YET REPORTED**, do not invent it.

Earlier **D145 Bone Shepherd art pass** was committed in this conversation and remains relevant history: updated `bone_shepherd_frames.svg`, `ossuary_lamb_frames.svg`, `run/bone_shepherd.svg` in main with enhanced material detail, retained all 25 animated frames / 448×274 card dimensions, static source validation PASSED, native visual QA UNCONFIRMED. Moodboard sheets were concept references, **not** live assets or authorized extra mechanics. Preserve new-enemy-only D143 requirement for remaining 11 of 45 cards, DS2/Fate Spread Variant C, prior approved assets, and separate unresolved D142 HUNT/duo imbalance. **This handoff update is documentation-only; no new art/gameplay edits.**

---

## D151 target-lifetime hotfix — 2026-10-15 (F6 retest pending)

A user-provided Godot screenshot showed Funeral Procession 54-case smoke failing in `unit.gd:577` because `_is_valid_target(candidate: BattleUnit)` received a *previously freed* target. Fixed by changing the parameter to `Variant` and validating its instance and class before field access. Changed **only smoke** arena cleanup to immediate `free()` after manually processed battles; `queue_free()` at end of frame let a previous fight's units contaminate later fixture targets. Added an explicit smoke test that frees a current target and validates the next `BattleUnit._process` tick. Both code fixes are in `main`; Godot has **not** been rerun yet. F6 `res://scenes/dev/funeral_procession_smoke.tscn` after `git pull`. Current ACT1 pool remains 34/45, no art or Last Rite mechanics changed. Detailed status: `docs/NEXT_CHAT_HANDOFF.md`.

---

## D151 RELEASE — 2026-10-15 — FUNERAL PROCESSION NOW LIVE AS ACT1 CARD 34/45

User replied «все ок» after D151 role-facing hotfix and the instructions to re-check the real playtest and 54-case smoke. Treat this as **user acceptance of the corrected in-game facing and overall result**, without inventing a separate 54/54 screenshot or exact win/loss counts. Live source now registers `funeral_procession` in `RunState.ACT1_CARD_IDS` (34 distinct nonboss cards including original priest + two coffin bearers); its `CARD_PATHS` was already present. Existing `scripts/battle/battle.gd` calls scoped `LastRiteController` start/stop for this encounter only. Previously approved D151 original card 448×274 WebP, original 25-frame sprite atlases, no-bell art direction and role-local facing correction all remain unchanged. Updated fixed-count guards in `scripts/dev/bone_shepherd_smoke.gd` and `scripts/dev/funeral_procession_smoke.gd` from 33 to 34. Exactly **12 Fate Spread resolutions plus sealed XIII** per run still unchanged; overall planned 45-card goal remains. Older Bellkeeper, Bone Shepherd, DS2 art, and balance multipliers untouched. **New release commit and test changes have not yet been re-run in native Godot by assistant**; perform one post-pull F6 `funeral_procession_smoke.tscn` and optionally a live normal-run/reward flow to catch any integration regressions. DO NOT claim independently verified post-release 54/54 metric. Next feature work: remaining 11 of 45 cards; every new fight requires new roles/behavior/art per D143. Original issue and decision history are below.

---

## D151 ACTIVE CHECKPOINT — 2026-10-15 — user-approved sprites, Funeral Procession battle staged; F6 real combat pending

User approved corrected V2 original Funeral Priest and Pallbearer visual playback («все отлично!»). Current GitHub `main` now contains scoped `LastRiteController` hook in actual `battle.gd` (spawn/setup → fight start → stop on victory/defeat), new `CARD_PATHS` lookup only for `funeral_procession`, and **two F6 scenes**: `scenes/dev/funeral_procession_playtest.tscn` for actual UI→victory→reward→table, and `scenes/dev/funeral_procession_smoke.tscn` for a 54-battle matrix (2 deployments × 3 protagonists × 1–3 heroes × 3 tactical orders). Previous isolated `last_rite_smoke.tscn` native PASS remains valid, but **new battle/matrix scenes have NOT yet been executed in Godot**, so their real result/balance/reward navigation is pending. Static inspection of paths and hooks passed; no engine PASS claimed. `ACT1_CARD_IDS` **unchanged at 33**, target 45; the 34th card will become live only after native QA succeeds. Existing Bone Shepherd, Grave Bellkeeper, DS2 and art unchanged. Full authoritative D151 status: `docs/DECK_EXPANSION_D151_FUNERAL_PROCESSION.md`. User needs only `git pull`, run the two F6 scenes above and share result; fix any errors yourself through connected GitHub.

---

## D151 ART DELIVERY — 2026-10-15 — 2 authentic enemy atlases + card WebP committed, native F6 art QA PENDING

D151 Funeral Procession after user-approved bell-free redesign: original `funeral_priest` and `pallbearer` are now **actual texture assets in GitHub main**, not concept boards. Direct binary Git commit `18b8c2e`: `assets/pixel/units/deck_expansion_v1/{funeral_priest,pallbearer}_frames.webp.b64` each encodes a transparent **576×480** 6×5 (96px) atlas with **25 different valid authored cells** (idle 4, walk 6, attack 6, hit 3, death 6); original `assets/pixel/card_unification_v1/run/funeral_procession.webp` is standalone 448×274 full-bleed art. Offline WebP alpha and consecutive-pose-difference audits PASS; all 25 cells per role visible, but edge clipping/baseline/art acceptance **not yet native tested**. `scripts/battle/unit_animation_library.gd` now supports these two roles with strict missing-frame rejection (no copied/fake poses), `scripts/ui/card_unification_v1.gd` exposes card to preview, `res://scenes/dev/funeral_procession_art_preview.tscn` shows original art and interactive five-state live SpriteFrames. User action: `git pull`, F6 that one scene, visually review motion and cut-offs. Isolated Last Rite ability already had user-confirmed native PASS. **Still NOT in real Act1 deck, no production battle hook**, 33/45 current pool unchanged; no 34th card until visual QA and encounter combat QA. All approved Grave Bellkeeper/Bone Shepherd/DS2 assets remain intact. Full file map and acceptance gate: `docs/DECK_EXPANSION_D151_ART_QA.md`.

---

## D151 QA — 2026-10-14 — Last Rite isolated Godot F6 PASS, visual assets next

User submitted a **real Godot F6 screenshot** showing `DECK EXPANSION 03 / LAST RITE — PASS` for `res://scenes/dev/last_rite_smoke.tscn`. Verified by local engine: 1 original funeral priest + 2 pallbearers Resource roster; one dead pallbearer can revive at **40% HP once per encounter**; a second resurrection is blocked; priest death cancels warning; temporary attack-rate buff expires/restores without stacking. This supersedes prior **F6 pending** status for the isolated ritual test. **Not tested** by this screenshot: live combat wiring, 1/2/3 hero balance, authored animation sprites, run/award/table flow or card visual approval. D151 `funeral_procession` remains **unregistered** and not live; current pool stays **33/45**. Previous bell-themed prototype remains rejected, no bells in the new encounter. Next: original painterly **448×274** `funeral_procession` card WebP and genuine **25-frame transparent 576×480** unit atlases for `funeral_priest` and `pallbearer` (not borrowed art, not static-pose duplication), then in-engine gallery, integrate scoped controller and run battle matrix. Never mark production pass before those gates.

---

## D151 REDESIGN — 2026-10-14 — Funeral Procession replaces Mourning Bell (GitHub source committed; F6 pending)

User flagged that Misdeal **already has Grave Bellkeeper** with a bell. User **approved** abandoning the redundant D151 `mourning_bell`/`mourning_sexton`/`grave_toll` version for a distinctive **«ПОГРЕБАЛЬНАЯ ПРОЦЕССИЯ»** (`funeral_procession`, Tier1): **original funeral priest** `funeral_priest` with forbidden grimoire and smoking censer (**NO BELL**), two original heavy coffin-bearing `pallbearer` enemies, two distinct layouts. Mechanic **«Последний обряд»**: priest telegraphs necromantic sigil, revives **one** dead pallbearer **once per encounter** at 40% HP or temporarily quickens surviving bearers' attacks; priest death interrupts ritual and restores buff, no stacking. Implemented new `LastRiteData`, `LastRiteController`, new card/encounter/leader resources and `revive_from_last_rite()` guarded to dead enemy pallbearers. Created isolated **`res://scenes/dev/last_rite_smoke.tscn`** using actual `BattleUnit` instances. Deleted superseded eight bell-themed D151 draft files; old D151 spec marked obsolete. New canonical design/paths/test gate: `docs/DECK_EXPANSION_D151_FUNERAL_PROCESSION.md`.

**Importantly NOT live / no fake completion:** 33 registered cards unchanged (goal 45); no `funeral_procession` in RunState registry, no production `battle.gd` hook; no production original 448×274 WebP nor two authentic 25-frame 576×480 animation atlases in GitHub. Revised cinematic funeral procession art was generated as a candidate conversation image and 448×274 WebP download, *not* approved or committed to game assets. Await original battler sprite work and local Godot art/runtime QA; F6 new `last_rite_smoke.tscn` has NOT yet been run. User should `git pull`, F6 this isolated smoke and report any FAIL; assistant fixes in GitHub. Approved existing Grave Bellkeeper, DS2, Bone Shepherd, D148 54/54 previous smoke, D149/D150 original two event cards remain untouched. Historical superseded D151 Mourning Bell notes below do not override this current block.

---

## D151 — 2026-10-14 — Mourning Bell staged PROTOTYPE IN GITHUB; NOT LIVE, NEW ART PENDING

After user said «давай» to D151 and explicitly reaffirmed connected GitHub write access, verified latest `AGENTS.md`, `CONCEPT`, `PROJECT_STATE`, `ROADMAP`, `DECISIONS`, DS2 and encounter scripts from GitHub. New **Tier1** card `mourning_bell` («ПОХОРОННЫЙ ЗВОН») and two fully new enemy **resource identities** (`mourning_sexton` ×1 commander, `pallbearer` ×2 heavy coffin bearers) now exist in `resources/cards/`, `resources/encounters/`, `resources/units/`. There are two custom deployment layouts. Isolated `GraveTollData` and `GraveTollController` implement 5.5s initial wait, 1.0s interruptible ring warning, one enemy resurrection **total per encounter** at 40% HP, otherwise 20% quicker pallbearer attacks for 2.5s with full rollback even on leader death, 8.0s repeat interval. New `BattleUnit.revive_from_grave_toll` is explicitly role/team/death gated to `pallbearer`. No other combat or balance paths touched. **Not yet wired to `battle.gd`**, **not registered in `RunState.CARD_PATHS`/33 `ACT1_CARD_IDS`**, and incomplete art cannot enter normal game.

Created `res://scenes/dev/grave_toll_smoke.tscn` using actual Godot BattleUnit instances, new Resources and controller for cancellation/one-revive/non-stacking buff tests, **native F6 awaiting user's screenshot**; do NOT claim PASS before engine run. Card candidate is real standalone **448×274 WebP** generated locally in conversation (`D151_mourning_bell_card_candidate.webp`, SHA256 `6b16b70efb45dabb5f6d63b53772372c953f9d315d6d26b5026d6044b022069f`), plus a generated character/pose moodboard (generation `77ddee52-0148-48bd-8ece-4d605186b6fe`); these are NOT in GitHub/approved and the moodboard is NOT a 25-frame atlas. Still require authentic distinct 25-frame 576×480 transparent animated sprites for BOTH new roles and approval before activating a new card, original card-art binary upload, animation/battle integration, real 54-case smoke and win→reward→table. `docs/DECK_EXPANSION_D151_MOURNING_BELL.md` is canonical. Until then pool stays 33 / target 45, 12 cards + boss XIII unchanged; D150 accepted preview image and D148 54/54 smoke unaffected. Current user action: **`git pull`; F6 `scenes/dev/grave_toll_smoke.tscn`**. GitHub access is working, no permission reconfirmation needed. D142 HUNT/duo balance separate.

---

## D150 — 2026-10-14 — BOTH ORIGINAL EVENT WEBPs IN MAIN; LOCAL F6 VISUAL PREVIEW VERIFIED

**User supplied real Godot F6 screenshot** of `res://scenes/dev/deck_expansion_d150_art_preview.tscn`: two distinct 448×274 full-bleed card illustrations display under «ЛУННАЯ ПЕЧАТЬ» and «СКЛЕП ОТЗВУКОВ», both with green `D150 • оригинальный WebP найден`. Both images visually display with no baked title/buttons/card frame and fit the gallery. The assistant reviewed consistent painterly cold blue moonlit / warm candle DS2 imagery with accepted Bone Shepherd reference; **user has not yet explicitly written a separate artistic approval**. Source of truth checked in GitHub `main`: actual binaries `assets/pixel/card_unification_v1/run/moon_seal.webp` and `echo_crypt.webp` EXIST, and both `resources/cards/{moon_seal,echo_crypt}.tres` `art_path` fields point to them. This **supersedes D150 earlier installer/binaries-pending passages below**. D149 event flows were separately reported by user to run correctly; all other campaign/12+XIII/balance behavior was not exhaustively checked. **No further image installation or git push required.** Remaining backlog: first normal win→reward→table end-to-end screenshot for Bone Shepherd and eventual new cards (33/45), with novel enemies/AI/art for every new fight per D143. D142 HUNT/duo balance still unresolved.

---

## D150 — 2026-10-14 — new D149 art prepared (installer pending, GitHub binary not yet uploaded)

User verified D149 two new event-card choice flows locally in Godot («все отработало»). D149 is **runtime F6 accepted at user's reported level**, not a full-run/per-option numerical regression proof. Continuing from the prior stated art gate: two separate **448×274** painterly scene-only WebPs prepared for Moon Seal and Echo Crypt, no baked labels/UI, cropping from latest illustrative concept. Their binary source files are in conversation download `Misdeal_D150_Event_Art.zip`; GitHub has **ONLY** D150 fallback-aware loader `scripts/ui/card_unification_v1.gd` and isolated F6 scene `scenes/dev/deck_expansion_d150_art_preview.tscn` so far. The D150 image binary files themselves have **NOT** been committed to `main` yet; the one-click installer will validate hashes, copy both, switch only two `RunCardData.art_path` values, commit/push. Until then original D149 art aliases render safely. New art is **NOT** user visually approved yet. Full precise contract/source hashes/user steps: `docs/DECK_EXPANSION_D150_ART_PASS.md`. Gameplay remains 33 nonboss cards / 12 resolutions + sealed boss XIII. D143 brand-new enemies required for any later combat. D148 Shepherd 54/54 smoke stands, full actual fight→reward→table QA separate.

---

## D149 — 2026-10-14 — NEXT CONTENT SHIPPED: 33-card Act1 pool / paired noncombat choices; Godot F6 pending

User supplied in-engine 1280×720 screenshots of D147/148's **approved** cinematic Bone Shepherd run-card art, visible new Shepherd and Ossuary Lamb miniatures, and the real Knight precombat arena; user said «все ок. давай дальше». D148 isolated **54/54 PASS with 14 Whistles** remains the verified functional smoke baseline. These screenshots support card/sprite readability and the battle prepare screen; they are not proof that **all five** animation motions or normal fight→reward→table were played through; continue those QA as separate tasks. The visible new arts (not D145 rejected SVG) are accepted at shown scale.

**D149 implemented in GitHub `main`:** two additional genuine **noncombat** `RunCardData` events `moon_seal` («ЛУННАЯ ПЕЧАТЬ», Tier0) and `echo_crypt` («СКЛЕП ОТЗВУКОВ», Tier1), with 3 distinct choices + safe leave each and a conditional echo: keeping the silver seal in tier0 improves the later crypt's artifact/coins/HP terms, while crypt still works without it. Integrated into existing DS2 `act_choice.gd`, persistent event outcomes in existing `RunState`, and registered in pool: **33 nonboss cards** (Tier0=12, Tier1=11, Tier2=10). **Run length 12 + XIII unchanged**, no new combat/old enemy substitutions or stat-system changes. `resources/cards/bone_shepherd.tres`'s once-stale `art_path` now points to its verified approved `.webp`.

**Art gate:** D149 has only **temporary, thematic fallbacks to existing approved WebPs** from `run/whispering_well.webp` and `run/gravedigger_shop.webp`; the original accepted 18 art files were not changed. This is playable *content* awaiting new standalone painterly DS2 illustrations for those 2 new cards; do **not** claim original D149 images finished. F6 one-entry new scene `res://scenes/dev/deck_expansion_d149_event_preview.tscn` (Moon Seal, Crypt with seal, Crypt without seal); local Godot 4.7 native parse/UI/effect verification **not yet submitted**. `bone_shepherd_smoke.gd` updates the card count invariant to 33 but native D149 re-test outstanding; old D148 PASS is historical.

**Detailed source, effects, QA:** `docs/DECK_EXPANSION_D149_EVENT_DUO.md`. Still pending original D149 event art, F6 screenshots/options/return; separate Bone Shepherd actual victory→reward→table, and future new-enemy combat cards. D142 HUNT/duo diagnostic backlog remains unchanged. GitHub is connected: assistant implements/fixes directly; user only `git pull`, F6 one scene, screenshots if something fails.

---

## D148 — 2026-10-14 — Godot D147 QA hotfix (engine recheck pending)

User provided three screenshots after installing D147 commit `6866656`. Art preview and 54-case smoke cannot launch because `card_art_catalog.gd` preloads `card_unification_v1.gd`, whose D147 comment mistakenly started with `//` instead of GDScript `#`. **Fixed in GitHub main** at `c097a24`; this is a parser error, not missing assets. Manual battle DID launch with the new detailed Shepherd and Lamb textures, but Shepherd intermittently disappears for ~0.37s on idle. Checked the actual committed atlas source: Shepherd row0 idle columns 0–2 visible but **column 3 empty (alpha≈0)**, while all 25 used Lamb frames have visible alpha. **Fixed runtime defensively** at `9bc947a`: `MisdealUnitAnimationLibrary` scans alpha of 4/6/6/3/6 authored cells and blits the previous visible pose into an empty cell before making the `SpriteFrames` texture; the SVG fallback remains. For this exact D147 pack only Shepherd `idle[3]` is repaired. This does NOT yet replace/retouch the imperfect source WebP; follow-up real 4th idle artwork would be preferable after QA. Battle rules, source D147 binaries, Whistle, scaling, other cards/units and approved background unchanged. Static script and raster frame audit PASS; **Godot 4.7 F6 after these commits remains unverified**. NEXT USER: `git pull`, F6 `bone_shepherd_art_preview.tscn`, `bone_shepherd_smoke.tscn` (54/54), `bone_shepherd_playtest.tscn` (no idle disappear, full fight). Request screenshots only; if another parser error appears inspect output and fix directly in GitHub. Do not claim PASS yet.

---

## D147 — 2026-10-14 — approved Bone Shepherd visuals prepared; GitHub loaders staged; binary import pending

User approved the **FIRST** of the two 2026-10-14 cinematic Bone Shepherd artworks (generation `46ed7a48-538d-4e5c-bd0f-27a0c41a7bbf`; Shepherd centered between two horned Lambs). Production card is center-cropped/resampled to **448×274** full-bleed WebP, no baked text or borders. Previously positively received Shepherd and Ossuary Lamb pose sheets converted into separate transparent **576×480 (6×5 96px)** animated WebP atlases (idle 4, walk 6, attack 6, hit 3, death 6); they have not been Godot-validated yet. **Production code changes ALREADY COMMITTED:** `scripts/ui/card_unification_v1.gd` prefers `run/bone_shepherd.webp`, fallback old SVG; `scripts/battle/unit_animation_library.gd` prefers `.webp.b64` for both new enemy roles, fallback existing SVG. **BINARY TEXTURES ARE NOT YET IN GITHUB MAIN**: ready-to-install art ZIP `Misdeal_D147_Approved_Bone_Shepherd_Art.zip` generated as a chat attachment with installer (`install.cmd`), SHA256 manifest, safe file import plus local Git commit/push and documentation updates. Once the user runs that single installer locally, source of truth will include actual assets; until then old SVG continues to render safely. No card pool, battle Whistle, old art, DS2/Fate Spread or stat change. **Still pending:** Godot F6 art preview, playtest, 54/54 smoke, user QA. No engine PASS claimed.

---

## LATEST HANDOFF — 2026-10-14 — Full current context deposited for next chat

The comprehensive self-contained **GitHub handoff is [`docs/NEXT_CHAT_HANDOFF.md`](NEXT_CHAT_HANDOFF.md)**. New-chat agent should read it and current `AGENTS.md`, GitHub code, `PROJECT_STATE`, `ROADMAP`, `DECISIONS`, `VISUAL_ASSET_REGISTRY`, and `DESIGN_SYSTEM`. User wants a clean seamless restart and **direct GitHub edits** without repeated access questions. Current D145 art+first new enemy card are already in `main`; **updated D145 visuals and 54/54 smoke NOT YET confirmed in Godot**. No further code or asset changes in this checkpoint pass. Next action after `git pull`: preview art, smoke, actual battle; user sends screenshots/errors; assistant fixes directly. Original 18 approved Wave1 assets, DS2/Fate Spread C, 12+XIII unchanged.

---

## LATEST — 2026-10-14 — D145 original enemy art detailed, preserve Godot QA and user aesthetic review

Following initial user's three local screens (gallery flat SVG creatures, real Knight cemetery fight, smoke GDScript const parser error already fixed), user agreed «давай» to the assistant's proposed **DS2 art-redraw of Shepherd, Lambs and unique card image**. **ACTUAL GITHUB ART CHANGES COMMITTED:** updated in-place live SVG sheets at `assets/pixel/units/deck_expansion_v1/bone_shepherd_frames.svg` (25 poses, new fabric shadows/metal/ribs and small amber lantern) and `ossuary_lamb_frames.svg` (25 bone-wool plated ram poses, deep horn and hoof detailing), plus `assets/pixel/card_unification_v1/run/bone_shepherd.svg` (moonlit grave cemetery scene, old iron gate/chapel/stones, detailed ground/lantern, same 448×274). All are original programmatic pixel-shape sources and use already working Godot SVG importer. Generated composite concept sheets shown in chat are inspirational moodboards only and NOT game sprites or additional abilities. No `RunState` pool, 1+2 enemy roster, Whistle/controller or existing art/UI changes. Static SVG tag/dim/25-frame QA PASS. D145 recorded `docs/DECISIONS.md`.

**MUST TEST NEXT** (do not treat art as approved yet): user `git pull`, F6 `scenes/dev/bone_shepherd_art_preview.tscn` screenshots of idle + attack/walk; F6 `scenes/dev/bone_shepherd_playtest.tscn` actual battle vs Knight to judge floor/hoof size and visual cohesion; **still must F6 `scenes/dev/bone_shepherd_smoke.tscn`** after earlier parser fix to obtain 54/54 PASS. No recent engine smoke results. If user sends errors or art critique, open current GitHub scripts/art then fix directly, do not ask them to edit. Existing 31 card pool, 12+XIII, original 30 card identities, approved DS2/Fate Spread C and 18 Wave1 artworks unchanged; D142 balancing backlog separate. Resume with screenshot/results, don't ask to reapprove already confirmed overall concept.

---

## LATEST — 2026-10-14 — D144 screenshots verified, parser error fixed in main; 54 fights still untested after fix

User pulled original Bone Shepherd D144 commits and provided actual Godot screens: gallery renders card+both new SVG-animated enemy roles; Knight normal battle preparation renders 1 Shepherd +2 Lambs in graveyard. Unique visuals **display and load** but are flat/simple relative to approved high-detail DS2 Knight/arena — art pass needed, not approved polished. Smoke F6 was **blocked by parser error** `const EXPECTED_PATHS := PackedStringArray(...)` at line 17 of `scripts/dev/bone_shepherd_smoke.gd`. **FIXED via GitHub main**: `const EXPECTED_PATHS: Array[String] = [ ... ]` plus runtime `PackedStringArray(EXPECTED_PATHS)` in validation, commit `228b62010ea0fff345da90f78105781ce13042a2`; hide synthetic test arena `arena.visible = false`, commit `4402074de6e7c0207b67b003f01bbd101c16ff01`. Source QA checks passed. **NEXT USER ACTION:** `git pull`, F6 `res://scenes/dev/bone_shepherd_smoke.tscn`, report `DECK EXPANSION 01 — PASS` 54/54 or screenshot Godot Output/stack on FAIL. Do not claim runtime PASS without screenshot. If pass, assess art-quality upgrade, actual Whistle and normal reward path. No need to ask GitHub access; adjust code directly. D143 enemy uniqueness, D144 original new types, 31-card pool, previous DS2/Fate Spread/art unchanged. Separate HUNT/duo balance backlog.

---

## LATEST — 2026-10-14 — D144 Original Bone Shepherd first new playable card code/art committed; F6 handoff

User said «давай» to actually implement first new combat card after design docs. **Done in GitHub main:** `bone_shepherd` Tier0 registered (31 Act1 cards / 11 Tier0; 12+XIII intact), exactly one completely NEW funeral-crook commander `bone_shepherd` plus two completely NEW horned quadrupedal `ossuary_lamb` UnitData; same fixed roster in two authored positions; original creature-frame SVG atlases (576×480 each, 25 frame slots, five states; text-vector pixel source due GitHub UTF8 connector) and original 448×274 scene illustration SVG, loaded through AnimationLibrary and CardArtCatalog/Unification. The imagegen concept screenshot is NOT shipped live and user has NOT seen current native SVG sprites. `BoneShepherdWhistleController` encounter-local ability + typed Resource warns after 5.5s, 0.65s visible ring, 1.25s ×1.35 move-only double Lamb target focus, 8s repeat; handles Shepherd death and target death, resets on battle finish; only Lamb receives temporary AI override. No reused enemy visuals, random rosters, old stat nerfs or DS2 changes.

**DO THIS NEXT:** user `git pull` + Godot 4.7.x F6 `res://scenes/dev/bone_shepherd_art_preview.tscn`, `res://scenes/dev/bone_shepherd_smoke.tscn` (54 combats + whistle fixture, expect **DECK EXPANSION 01 — PASS**), and `res://scenes/dev/bone_shepherd_playtest.tscn` (normal Knight battle). Ask for screenshots and errors. Assistant has **NOT actually executed Godot**, only source/static XML-style SVG/registry checks, so any parser, texture import, animation or sprite grounding failure must be fixed directly via connected GitHub. Canonical updated `docs/DECK_EXPANSION_BONE_SHEPHERD_PRODUCTION.md`, D144 in DECISIONS and top PROJECT_STATE/ROADMAP/SESSION_CHECKPOINT. Remaining 14 planned additions are NOT implemented yet. Continue after screenshot, not another design preamble. Keep 18 approved art files, Fate Spread Variant C/DS2, original seven card-faithful layouts, measured D141 imbalance/D142 experiment separate.

---

## LATEST — 2026-10-14 — Bone Shepherd production spec ready; implement original art and battle next

User approved preparing a production-ready design pack. **docs/DECK_EXPANSION_BONE_SHEPHERD_PRODUCTION.md** is the canonical detailed content/art/technical spec: new Tier0 card with fixed roster of 1 unique Bone Shepherd (funeral cloak, hooked bone crook) and 2 unique horned Ossuary Lambs; precisely authored two formations and Russian copy; local data-driven Whistle 5.5s initial/0.65s telegraph/1.25s 1.35× move-only synchronized rush; death/target-cancel behavior; initial unbalanced unit stats; true new 6×5 96px-frame animated atlases and one fresh 448×274 run-card illustration. Check the complete Godot integration/QA plan in the spec, not the early moodboard (its ghost/dog/event-choice additions are unapproved). D143 applies to all new fight-bearing cards: every new enemy and animation must be original, not a reused/reskinned old role.

**This was a documentation-only production design session, not code/art release**: no new encounter/card data, no Whistle implementation, no sprites, no RunState registration and no local Godot test. Existing 30-card Act1 pool, 12+XIII length, 18 approved art files and DS2/Fate Spread Variant C still intact. Next user task: create actual sprites/card art (with suitable GitHub text B64 loader if binary upload unavailable), implement this complete vertical slice and F6 visual/combat test before registering card. D142 HUNT/duo diagnostics separate, unapproved. GitHub connected and used directly.

---

## LATEST — 2026-10-14 — Bone Shepherd original-enemy design proposed; awaiting artwork signoff

User said «отлично погнали» after D143 request for entirely new enemies in all new fight-bearing cards. The previously agreed workflow is first **propose and approve visual creatures/mechanics**, then implement a full BattleUnit card + real sprite assets. New design brief: **`docs/DECK_EXPANSION_BONE_SHEPHERD_CONCEPT.md`** for Tier0 `bone_shepherd`: 1 tall hooded/rib-cage shepherd with bone crook and ritual thread + 2 quadruped `ossuary_lamb` (funeral ram, horns, bone-wool plate). **Both new species**, not old bone raiders/thralls/skellies/bellkeepers, with distinct silhouettes/appropriate authentic animation; proposed unique Whistle cue briefly orders coordinated lamb rush. 1 shepherd +2 lambs in authored rear/front positions; DS2/Fate Spread art only. IMPORTANT: **This concept is NOT approved/implemented yet**; don't misreport it as in `RunState.ACT1_CARD_IDS`. Next user approves visual and mechanic direction or requests redraw. Then full card image+sprite sheets+enemy UnitData+EncounterData+unique AI behavior+Godot smoke and live test. Existing 30 cards and v25/D142 battle diagnostics untouched; GitHub directly connected.

---

## LATEST — 2026-10-14 — User demands brand-new enemies in ALL newly added combat cards (D143)

Deck Expansion concept: add 15 cards to Act 1's existing 30-card pool, preserving 12 resolved slots + XIII. User emphasized new combat cards must feature **completely new enemy types**, not old opponents in new positions, renamed or recolored. This applies **even when combat is one optional branch of an event card**. Recorded in `docs/DECISIONS.md` D143. Every new fight needs original `UnitData`/battle miniatures, tailored mechanics and art, custom `EncounterData` with authored roster, accurate card image/title/description. The previous speculative 15 names accidentally include FIVE combat-bearing designs despite advertised three: Funeral Bell, Bone Shepherd, Executioner at Crossing, optional combat Coin Vault Guard, Crimson Guard; clarify/reduce scope before implementation. **No card/encounter/enemy/art changes have been made**; previous D141 diagnostics and pending D142 balance experiment remain intact. Next: propose 15-card inventory with clearly identified optional fights and per-encounter new enemy design, implement new enemy combat as complete unit+art+encounter+card slices only when approved. Stay with GitHub `zampolit73/Misdeal`, Godot 4.7.x/GDScript, DS2/Fate Spread/art approvals, 12+XIII.

---

## LATEST — 2026-10-14 — D141 complete trace CSV diagnosis, no new gameplay edits

User supplied both D141 CSVs: 126 real-BattleUnit scenario outcomes and 792 spawned-unit records. Exact cross-match against the previously supplied D140 v24 CSV shows **126/126 identical outcome + duration**, confirming instrumented test didn't alter measurable results. Measured review saved **`docs/TACTICAL_GAMEPLAY_V25_DIAGNOSTIC_REVIEW.md`**. V25 66W/60L, 0 timeouts. Last Bell HUNT 4/18 vs other orders 18/18, mean executed hero attacks 12.78 vs ASSAULT 18.78, effective damage 281 vs 395, enemy damage 234 vs 103, effective healing 41 vs 26. Chase/total fight duration comparable, so don't call it merely a longer chase. Knight later equipped solo 24/24, Knight+Ranger 0/24, trio 2/24. Duo Knight+Ranger take full combined 414 damage (Knight 306 + Ranger 108) in every case and deliver ~40% less actual damage than solo. This is consistent with strong solo compensation and reduced duo staying power, but exact cause not isolated.

**Next ask:** user agreement to dev-only D142 A/B tests (keep HUNT existing as baseline, test local near-threat/ranged accessibility alternative under exact seeds, test one factor of Knight duo pressure/placement at a time) BEFORE modifying production stats/target heuristics. Also ask for normal 12+XIII Act 1 playthrough with actual risk/upgrades/rewards. No new balance code changed this session, only report/handoff. Seven card-faithful two-layout encounters, approved 18 arts, DS2/Fate Spread unchanged. No standalone v25 F6 screenshot was given; real generated CSVs validate completed test.

---

## LATEST — 2026-10-14 — D141 v2.5 diagnostic first-pass shipped; F6 outputs next

User approved «Давай» to Gameplay 2.5 after D140 CSV revealed `HUNT` outcome domination (24/90 vs ASSAULT 67/90), Last Bell HUNT 4/18, and late Knight+Ranger duo 0/24 vs Knight solo 24/24. **Production balancing has NOT been changed.** One `BattleUnit` script (`scripts/battle/unit.gd`) gained three optional observer signals emitted only for listeners: `diagnostic_attack`, `diagnostic_damage` (effective HP loss incl splash), `diagnostic_heal` (net restore). No AI, damage or healer calculation changes. Dev-only F6 `res://scenes/dev/tactical_gameplay_v25_combat_diagnostics.tscn` with script in `scripts/dev/` runs 126 original v24 seed-matched outcomes: 54 Last Bell across 3 protagonists/orders/sizes, 72 Knight-led late equipped Ossuary Gate/Firing Square (solo/duo/trio, 2 layouts, 3 orders, 2 seeds). Generates case and per-unit telemetry CSVs `user://misdeal_tactical_v25_trace_cases.csv`, `user://misdeal_tactical_v25_trace_units.csv`. Full fields and scope in `docs/GAMEPLAY_V25_DIAGNOSTICS.md` and D141 decision.

**NEXT USER:** `git pull`, F6 `scenes/dev/tactical_gameplay_v25_combat_diagnostics.tscn`, send PASS/FAIL screenshot and **both** CSVs. Assistant cannot run Godot locally: no engine PASS yet. Then compare v25 126 cases with exact corresponding previous D140 v24 case IDs, measure HUNT targets/chase vs attacks/healing and Knight duo per-unit performance; only after measured evidence consider actual balancing. Normal Act 1 progression with Wizard wagers, upgrades, rewards and boss XIII still requires test. Preserve original seven 2-layout card rosters, 18 arts, DS2/Fate Spread. GitHub write access connected; never ask user to copy scripts.

---

## LATEST — 2026-10-14 — D140 270-fight CSV analyzed; diagnostic-first follow-up proposed

User uploaded actual Godot-generated `misdeal_tactical_v24_party_focus.csv` (270 rows); source-level report **`docs/TACTICAL_GAMEPLAY_V24_BALANCE_REVIEW.md`** now records exact matrix, validated outcomes and caveats. User's previous D140 F6 PASS screen: 270/270, 158 wins, 112 defeats, HUNT shared focus/wounded target/frontline intercept preview PASS.

**What we now know:** ASSAULT 67/90, FORMATION 67/90, HUNT 24/90. Across the 90 exact same-encounter-layout-party-seed comparisons, HUNT is never successful where ASSAULT fails; 43 cases go the other way. `last_bell` HUNT 4/18 while other orders 18/18. Same protagonist controlled party-size progression: solo 82/90, duo 30/90, trio 46/90; late equipped Knight solo 24/24, Knight+Ranger duo **0/24**, trio 2/24. It is **not** a fair test of any sole stat multiplier because additional heroes, loadouts and enemy pressure change. Card variants 78/135 vs 80/135; no aggregate sign that layouts cause problem. v23/v24 seed/profile matrices differ; avoid false before/after causal HUNT conclusions.

**Next decision:** ask user whether to implement a **D141 Gameplay 2.5 focused diagnostics** package; trace real HUNT target/following/attack/heal interactions in `last_bell` and stage2 Knight+Ranger controlled losses, use identical matched conditions before changing combat heuristics/scalers. Actual Act 1 run progression+rewards+boss XIII should be QA'd. No code/roster/art change approved or performed in this CSV-analysis session. Preserve DS2/Fate Spread and art approvals. Read review doc, D140 decision, latest `PROJECT_STATE`/`SESSION_CHECKPOINT`; GitHub connected direct access.

---

## LATEST — 2026-10-13 — D140 local Gameplay 2.4 PASS; obtain CSV for balance

User supplied Godot screenshot `TACTICAL GAMEPLAY 2.4 — PASS`: **270/270** controlled BattleUnit bouts complete, **158 wins, 112 losses**, and Hunt shared-healer/wounded-target/near-threat regression PASS. This confirms committed D140 logic launches in Godot with no simulation timeouts. **CSV `user://misdeal_tactical_v24_party_focus.csv` not attached**, so no per-card/per-order/per-class balance inferences yet. The matrix fixes protagonist across party sizes, companions are deterministic, advanced scenarios are equipped, rather than real Act 1 progression.

**Next interaction:** ask for `misdeal_tactical_v24_party_focus.csv` via Godot user data folder, analyze each scenario and fixed-protagonist solo/duo/trio comparisons. Historical D139 case study `docs/TACTICAL_GAMEPLAY_V23_BALANCE_REVIEW.md`; earlier baseline had HUNT shortcomings and confounded protagonist rotation. Preserve accepted encounter identities, art and UI. No new source changes since D140; docs only updated with F6 PASS. Real Act 1 end-to-end rewards/boss still to verify.

---

## LATEST — 2026-10-13 — D140 shipped, new 270-fight local F6 required

User approved Gameplay 2.4 focused follow-up with «давай». Connected GitHub plugin used to implement `scripts/battle/unit.gd` shared HUNT target selection: alive-party-center tie breaker + lowest-HP-ratio first among healers or ranged enemies; nearest-target fallback for frontline-only fights remains unchanged. This coordinates hits on the same bellkeeper and preserves D139 Knight/melee immediate-threat (165) intercept. Hero/enemy stats, seven existing positional two-layout cards, DS2/Fate Spread/art, act/rewards and global solo/duo/trio scalers **untouched**. Full rationale in `docs/DECISIONS.md` D140.

Godot F6 scene `res://scenes/dev/tactical_gameplay_v24_focus_party_benchmark.tscn` + script committed. Preflight tests the specific double-healer HUNT focus + Knight close-threat vs ranged targeting; then records **270 actual BattleUnit deterministic simulated battles**: 54 `last_bell` bare and 216 tier2 equipped `ossuary_gate`/`firing_square`. All protagonists separately remain fixed while adding companions in a deterministic cyclic order solo→duo→trio, 2 layouts, 3 orders; 2 seeds for tier2. CSV `user://misdeal_tactical_v24_party_focus.csv` has party_roles plus case metadata/outcome/time/survivors. No claim that it measures normal run win rate.

**Next user:** `git pull`, run new v24 scene with F6 in Godot 4.7.x and send screenshot and new CSV. Godot binary unavailable in current assistant environment so this is source-shipped only, **not yet F6-verified**. Fix any parse/runtime errors directly via connected GitHub. After CSV, check `last_bell` HUNT viability and role-matched late solo/duo/trio. Full real Act 1 end-to-end 12+XIII path still needed. Historical `docs/TACTICAL_GAMEPLAY_V23_BALANCE_REVIEW.md` contains old matched comparison and confounds.

---

## LATEST — 2026-10-13 — 180-row D139 CSV analyzed and reviewed in GitHub

User supplied real `misdeal_tactical_v23_balance.csv`, 180 BattleUnit result rows, all completed 79 wins / 101 losses, Godot F6 PASS. Direct exact v22 72-bare-case join proves HUNT improved from **5/24→8/24** (4 newly won, 1 former win lost); ASSAULT/FORMATION each remain 13/24 identically. `last_bell` HUNT remains **1/6**, indicating unresolved support-target issue. Late tier2 bare **6/72**, upgraded profile **42/72**; on identical cases upgrades turned 36 losses to wins without making a win fail. Enhanced late solo **22/24**, duo **10/24**, trio **10/24**, but sample rotates class and no real progression, so do NOT change overall party scalers based on this alone. Real physical layout comparisons also rotate protagonists. Both later seeds yielded identical win/loss flags across matched cases.

**Canonical new analysis:** `docs/TACTICAL_GAMEPLAY_V23_BALANCE_REVIEW.md`; historical `docs/TACTICAL_GAMEPLAY_V22_BALANCE_REVIEW.md`. Next decision: request approval for improved HUNT focus/target cohesion experiment and a role-matched stage2 benchmark, then observe actual Act 1 rewards/run. Current turn changes docs ONLY; D139 production melee HUNT fix remains in code, no new production modifications. Maintain all approved enemy rosters/cards/assets/DS2/Fate Spread. Do not ask user to re-explain GitHub access.

---

## LATEST — 2026-10-13 — D139 F6 180/180 PASS, request results CSV

User shared Godot screenshot: `TACTICAL GAMEPLAY 2.3 — PASS`; 180 completed isolated BattleUnit fights, **79 wins, 101 losses**, and targeted Knight HUNT close-frontline vs distant-healer preview assertions PASS. D139 production `scripts/battle/unit.gd` (melee HUNT interceptions within 165) and F6 `scenes/dev/tactical_gameplay_v23_balance_benchmark.tscn` shipped previously. The scene generated `user://misdeal_tactical_v23_balance.csv`, **not yet uploaded**. Current only reliable results are total W/L and functional targeting regression, NOT breakdown by tier/protagonist/party/order/build.

**Next:** user attaches v23 CSV via Project > Open User Data Folder; analyze per-card/party/order results and `tier2_built` vs `bare` pairs and historical v22 CSV report in `docs/TACTICAL_GAMEPLAY_V22_BALANCE_REVIEW.md`. Only then suggest any scope-limited further fixes and real Act 1 QA. No gameplay changes made in this response, docs updated to preserve next-chat context. Original card rosters and approved DS2/art/Fate Spread unchanged.

---

## LATEST — 2026-10-13 — D139 implemented, new 180-fight v23 F6 acceptance required

User approved («утверждаю») the D138 CSV-derived balancing follow-up. Direct GitHub production commit updates **`scripts/battle/unit.gd`**: HUNT for melee player hero now temporarily prioritizes the nearest immediate frontline enemy (within 165 units) if its preferred ranged/healer support target is outside that radius. HUNT still seeks healer/ranged normally when no imminent threat or when support is reachable, and ranged heroes are unaffected. Card enemy rosters/IDs/arts/position data, rewards and existing global scaling unchanged.

New source `scripts/dev/tactical_gameplay_v23_balance_benchmark.gd`, scene `res://scenes/dev/tactical_gameplay_v23_balance_benchmark.tscn` is a Godot F6 outcome regression of **180** BattleUnit bouts (36 unupgraded tier 1, 144 tier-2 with 2 seeds and 2 profiles). The `tier2_built` illustrative profile uses one actual RunState-authored hero upgrade per present role plus one protagonist-linked artifact; exact production modifier order preserved. F6 also checks three Knight HUNT targeting cases. New CSV: `user://misdeal_tactical_v23_balance.csv`. This is new and **unrun by user or assistant in actual Godot**, not a claimed balance PASS.

**Next action:** user `git pull`, F6 new v23 scene, send screenshot and CSV (Godot Project > Open User Data Folder); if FAILED, inspect and correct current GitHub directly. Analyze old v22 CSV against new v23 naked rows for HUNT, late built vs naked for realistic threat, then tune only validated encounter-local outliers. Docs `PROJECT_STATE`, `ROADMAP`, `DECISIONS`, `CHANGELOG` updated. Previous v22 CSV report `docs/TACTICAL_GAMEPLAY_V22_BALANCE_REVIEW.md`. All original 7 two-layout card compositions and approved pixel art DS2/Fate Spread remain protected.

---

## LATEST — 2026-10-13 — Gameplay 2.2 CSV review finished; findings in GitHub

User uploaded actual Godot F6 72-fight CSV; report committed as **`docs/TACTICAL_GAMEPLAY_V22_BALANCE_REVIEW.md`**. Data: 31 wins/41 losses; by card `gallows_volley` 16/18, `last_bell` 12/18, `ossuary_gate` 2/18, `firing_square` 1/18. ASSAULT 13/24, HUNT 5/24, FORMATION 13/24. In six exactly matched `last_bell` cases HUNT loses 6/6 while both other orders win 6/6. Current HUNT code categorically prioritizes healers and then ranged by type above proximity; investigate safely without losing HUNT's value. Tier-2 baseline 3/36 wins, but no upgrades or artifacts in test, so do not global-nerf late-tier enemies from naked baseline. Full rationale and limitations in report.

**NEXT DECISION GATE:** request approval for minimal HUNT targeting fix and stage-aware upgraded late-Act benchmark; only adjust encounter stats after upgraded outcomes + real Act 1 feedback. This session's analysis commits changed documentation only, not actual `BattleUnit`, encounter rosters, graphics or RunState. Keep seven authored two-layout encounters and DS2/Fate Spread untouched. GitHub direct write still available.

---

## LATEST — 2026-10-13 — D138 72 full-BattleUnit baseline fights PASSED; CSV is next

The user provided a Godot screenshot `TACTICAL GAMEPLAY 2.2 — PASS`: **72/72** scenarios completed with **31 wins / 41 defeats**; no timeout/roster check failures reported. Scenarios use 4 authored D138 card encounters, 2 spatial formations, 3 party sizes and 3 normal tactical orders; real BattleUnit combat is advanced deterministically in an isolated test, with no upgrades/items/Wizard risk/rewards. Benchmark wrote `user://misdeal_tactical_v22_battles.csv` with encounter ID, layout variant, party size, protagonist, order, win/loss, seconds and surviving heroes/enemies.

**Do NOT claim the balance is accepted or tune enemies yet.** The 31/41 result alone does not identify hard cards, unfair solo, or best strategy. Request the **actual CSV attachment** from the user via Godot Project > Open User Data Folder; then analyze per-card/variant/party/order outcomes, durations and survivor counts to decide targeted follow-on testing and balance changes. Live Act 1 QA (battle HUD, prebattle tell, victory/reward/return and boss XIII) remains open. D136/D137 earlier tests user-confirmed PASS. Original card identities, DS2/Fate Spread, 18 shipped artworks frozen. This checkpoint only updates docs, not production.

---

## LATEST — 2026-10-13 — D138 approved/committed Gameplay 2.2, new Godot test next

User accepted the assistant's Gameplay 2.2 proposal with «утверждаем». Four existing late-Act tactical battles (`gallows_volley`, `ossuary_gate`, `last_bell`, `firing_square`) now each have a second authored enemy placement and contextual pre-battle hint via the D137 data-driven system. **No enemy types/rosters/names, cards/art, existing battle scripts, rewards, baseline scalars or UI layouts altered**. GitHub `main` also contains new `res://scenes/dev/tactical_gameplay_v22_battle_benchmark.tscn`/script: 72 simulated *full battle interactions* from real `BattleUnit` objects with deterministic 30-FPS ticks, win/loss/timeout, elapsed virtual seconds, surviving heroes and enemies; CSV at `user://misdeal_tactical_v22_battles.csv`. Full production Battle-scene UI/intro/reward/Wizard context is **not** exercised by benchmark, and measured outcomes are not automatically good balance.

**Next:** user `git pull`, run F6 new v22 scene; expect `TACTICAL GAMEPLAY 2.2 — PASS` if all 72 finish without 75-sec timeouts / invariant failures. Assistant has no local Godot executable; no engine test result yet. On FAIL inspect actual Godot error/CSV and repair directly in GitHub. Then local regular play in these four battles and review measured win-rate/order impacts across solo/duo/trio; only adjust on observations. D136/D137 prior F6 tests user-confirmed PASS; approved visuals frozen. If new chat, read `docs/SESSION_CHECKPOINT.md` and `docs/PROJECT_STATE.md`. Keep local user files safe; no destructive git clean.

---

## LATEST — 2026-10-13 — D137 F6 acceptance received; next action is real-game battle QA

User showed **`TACTICAL GAMEPLAY 2.1 — PASS`** screenshot in Godot after `git pull` to `a31ecf9`: **54** authored battle preparations, **324** initial order/target checks, **72** HUNT-vs-ASSAULT target divergences; enemy composition per card and retry deployment persistence passed. D136 48-run deal smoke also previously passed. This **does not prove full battle wins or solo/duo/trio balancing**. D137 code already shipped in `scripts/data/encounter_data.gd`, `scripts/core/run_state.gd`, `scripts/battle/battle.gd`, resources for `bone_swarm`, `iron_wall`, `grave_bell`, and F6 smoke. Each card still has its original enemy roster/art; the two possible enemy positioning layouts and solo FORMATION -10% incoming damage are intentional.

**Next:** user should play normal Misdeal and observe these three fights; validate target-preview, assignment of tactical orders, actual movement/combat/victory/loot/return, optional solo/duo/trio. Report specific anomalies or which scenario is too easy/hard. Then adjust real observed issues and extend tactical replayability to remaining authored combat cards only after the live QA gate. User's repo is current as of `a31ecf9`; no further pull needed for the docs-only response. Do not mistake this F6 success for full act/battle QA. Full D136 real Act 1 run also remains pending.

---

## LATEST — 2026-10-13 — D137 FIRST TACTICAL ENCOUNTER PASS SHIPPED; F6 QA NEXT

**READ `docs/SESSION_CHECKPOINT.md` and newest `docs/PROJECT_STATE.md` first.** User has already confirmed D136 `ACT 1 GAMEPLAY 2.0 — PASS` in Godot (48 simulated card runs); this does not confirm one real full run. User then approved Gameplay 2.1 within existing encounter cards (no random new enemy rosters) and directly authorized implementation. The connected GitHub plugin was used: `scripts/data/encounter_data.gd`, `scripts/core/run_state.gd`, `scripts/battle/battle.gd`, `resources/encounters/{bone_swarm,iron_wall,grave_bell}.tres` updated; F6 regression `scenes/dev/tactical_gameplay_v21_smoke.tscn` + script added. Each of those three original encounters now has two authored positions-only layouts with original enemy identities and pre-battle hint; random variant is chosen once per card per run, stable on defeat/retry. Solo FORMATION receives -10% incoming damage to differentiate it from solo ASSAULT; original solo/duo/trio baseline scalars and duo/trio tactics preserved. UI geometry/art/card 18/18 DS2/Fate Spread untouched.

**Required next local step:** `git pull`, F6 `res://scenes/dev/tactical_gameplay_v21_smoke.tscn` at 1280×720, report **TACTICAL GAMEPLAY 2.1 — PASS/FAIL**. New F6 is *source-committed only*, not tested in the engine by assistant. After PASS play the three fights (solo/duo/trio where practical) and compare ASSAULT/HUNT/FORMATION, target previews and alternate layouts. The F6 tests initial targeting, NOT win rates. If bug, inspect latest GitHub and fix directly. Only then broaden other combat-card setups from actual play observations. User does not need to re-explain Git access. D137 and roadmap updated.

---

## LATEST — 2026-10-13 — NEW CHAT START HERE: D136 Gameplay 2.0 implemented, local Godot QA pending

**READ `docs/GAMEPLAY_2_0_HANDOFF.md` FIRST AFTER REQUIRED BOOTSTRAP** for complete precise state and QA checks. The user asked «так запиши весь контекст в гит. в общем как мы делаем. что бы я продолжил в новом чате с этого де места». This is a documentation-only snapshot; don't treat it as approval to silently begin another mechanic. Prior assistant response after Gameplay 2.0 approval ended during a GitHub action, but **GitHub actually contains D136 implemented and documented**: `scripts/core/run_state.gd`, `scripts/table/table.gd`, smoke `scripts/dev/act1_gameplay_v2_smoke.gd` and F6 `scenes/dev/act1_gameplay_v2_smoke.tscn`. Do NOT redo it as if only proposed. GitHub is source of truth; direct GitHub connector works. User's latest local state: art work «Все ок» after resolving old untracked WebPs blocking `git pull`; **18/18 D131–D135 art files shipped**, approved DS2/Fate Spread and special Shop/Well/Reward screens preserved. Gameplay 2.0 plan approved («да, давай») and implemented source code adds legal varied mixed encounter/event deal scoring, Wizard situational remarks, scaled Mark gold 20/30/40 for unchanged +15% next-battle damage, all with original 12 cards + boss XIII, combat pressure and Wizard Wager/Hold/Meddling intact. **No Godot 4.7.x actual D136 PASS or full new run has been reported.** Next action is `git pull`, F6 Gameplay 2.0 smoke, then one real full Act 1; investigate concrete FAIL via connected GitHub, update checkpoint/CHANGELOG and commit scoped fix. Do not ask user to repeat requirements or GitHub access. This new-chat handoff itself changes only docs, not code or images.

---

## LATEST — 2026-10-13 — D136 ACT 1 GAMEPLAY 2.0 committed; direct GitHub access confirmed

Following user «все ок» for 18/18 first-wave art and «да, давай» to Gameplay 2.0, implementation was made DIRECTLY through connected `mcp__GitHub__*` actions. **Source paths**: `scripts/core/run_state.gd` (recent-history selection helper, mixed legal combat/event offer pairs, Wizard Meddling same-kind replacement preference, optional context dialog, scale gold payout of Wizard Mark to 20/30/40 per tier), `scripts/table/table.gd` (precise Mark hint and hover tooltip, pick confirmation, contextual lines). Mark enemy damage penalty remains 15%, Wager debt/sacrifice unchanged, no new enemy sets/arenas, solo/duo/trio stats unchanged. Existing run structure 12 + boss XIII, guaranteed tier combat timing, opening noncombat, Fate Hold, Wizard interventions, discard and retries unchanged. Frozen DS2/Fate Spread/18 artwork unmodified.

D136 is canonical change record. Added isolated regression F6 `scenes/dev/act1_gameplay_v2_smoke.tscn` and `scripts/dev/act1_gameplay_v2_smoke.gd` (48 seeded 12-deal simulations over solo/duo/trio, check 3 mandatory combat stages, all unique chosen cards, boss XIII, pressure unchanged, +20/+30/+40 Mark); assistant couldn't run Godot 4.7.x in tool runtime, so actual F6 result NOT confirmed. Next user action is **`git pull`; open `res://scenes/dev/act1_gameplay_v2_smoke.tscn` and F6**, expect "ACT 1 GAMEPLAY 2.0 — PASS", then one normal Act 1 run verifying card offer mix, Wizard mark/accept, wager, held cards, meddling and boss transition. If error, fetch current GitHub scripts, patch and commit directly. Keep previous D123–D135 visuals/gameplay baseline protected. Update checkpoint on local test feedback before deciding subsequent gameplay iteration.

---

## LATEST — 2026-10-13 — D135 18/18 ART BINARIES IN GITHUB; final five need local Godot review

Unlike two earlier erroneous assistant claims of absent GitHub access, connected tools **are available and were used**. User approved last five extra art paintings and instructed direct push. Done: main `ac860ad2cacf17e7ab4e64c54f2ddfb70debd146` stores exact `run/gravedigger_shop.webp`, `run/bone_swarm.webp`, `run/grave_crossfire.webp` 448×274 and `event/candle_seller.webp`, `event/last_camp.webp` 1280×720 under `assets/pixel/card_unification_v1/`. GitHub remote blobs verified. `scripts/ui/card_unification_v1.gd` mapping commit `05b3ca6` picks these automatically with WebP validation & approved old atlas/event fallback; `ActChoice` dynamic background resolver already applied to Candle Seller and Last Camp, also generates thumbnails for those event IDs. Shop new art is **only its dealt run card**; shop DS2 live UI and real pricing logic unaffected. `res://scenes/dev/card_unification_final5_preview.tscn` is the new F6 deterministic five-art gallery. D135 has originals and design locks. D131+D132+D134+D135: `18/18` first-wave candidate arts implemented in GitHub main, **not** a claim all in-engine displays tested. Next user action: `git pull` (no manual ZIP), F6 gallery at 1280×720 and normal encounter screens + outcomes/leave/return. Prior ZIP may contain same five files; only if git complains about untracked files, move the flagged old local copies outside repo. First-wave asset work done; focus next on Act 1 gameplay and reward smoke/vertical slice after user confirmation. Existing D123–D134 agreed art/screens remain unchanged.

---

## LATEST — 2026-10-13 — prepared briefs for five additional unapproved art candidates; no new images committed

User says «давай дальше» following binary shipment of final five D134 upgrade/reward art, without reporting a new Godot QA result. Assistant checked repo and elected to continue original 18-target art inventory, of which 13 D130 pictured artworks are shipped. Remaining five are `gravedigger_shop` **table art only**, `bone_swarm`, `grave_crossfire` **table combat art**, `candle_seller`, `last_camp` **live event backdrops**. Exact brief / mappings / sizes in **`docs/CARD_ART_WAVE1_REMAINING5_BRIEF.md`**. **No visual acceptance yet for these five**; generator returned previous five upgraded art pictures again, which were discarded. Do not place that mistaken repeat into `main` or describe any of the five as shipped. Need an explicit fresh image generation request identifying these exact five target scenes (or one target at a time), present to user, then only after approval produce 448×274 run and 1280×720 event images, scoped safe fallbacks in `card_unification_v1.gd`, binary GitHub commits and Godot QA. 13 accepted assets remain safe, Shop UI frozen, user has not yet explicitly validated D134 final five in Godot.

---

## LATEST — 2026-10-13 — D134 five new upgrade/reward art binaries successfully committed; 13/13 DONE in GitHub

Despite a prior assistant message incorrectly claiming GitHub write access was absent, the connected GitHub tools **are present and were used**. The exact five last generated, user-approved images were converted to `608×388` WebP and pushed as actual binaries to `main` in **`e3729a4a86a9cce006ec8803fa6e7e0aa1f00de5`**. Exact resource paths: `assets/pixel/card_unification_v1/upgrade/{knight_iron_oath,ranger_arrowstorm,mage_glass_heart}.webp` and `assets/pixel/card_unification_v1/reward/{gold_windfall,relic_wager}.webp`. Remote Git blobs and five-file-only diff verified. No extra ZIP needed. The last accepted artwork is the SECOND standalone Knight from the FIVE-picture output, generation `99064d63...`, not earlier knight `40712d9a...`; other four latest IDs recorded in D134. Keep gray/white-bearded **male** mage and **skeletal hand holding red ruby**.

The original 13 D130 pictured slots are **fully present as binary assets** across D131 4 RunCard + D132 4 event + D134 5 upgrades/rewards. Existing `card_unification_v1.gd` and `CardArtCatalog` already load them with fallback, so no game code or UI changed in D134. User should `git pull`, F6 `res://scenes/dev/card_unification_v1_preview.tscn`, check 13 images, and validate real upgrade/reward screens at 1280×720. Godot itself not independently executed. If the obsolete earlier ZIP was unpacked, five local untracked `upgrade/` and `reward/` files could block merge; instruct to move only those aside, then pull. Source art, DS2 screens, Fate Spread and gameplay untouched. The initial first-wave inventory included five MORE unapproved candidates beyond these 13, which are future scope only. See D134, `docs/CARD_ART_WAVE1_FINAL5_BRIEF.md`. Next session can continue with QA feedback or Act 1 gameplay without reconstructing old chat.

---

## LATEST — 2026-10-13 — 8/13 art delivered and accepted; next 5 illustration briefs locked

User's «все ок. погнали дальше» accepts the previously missing D132 art now visible in-game after thumbnail/tint fix. Binding D133; no need to revisit these 4 events (or the D131 first 4 run cards) without a new defect. Final five D130-approved image compositions have exact one-art-at-a-time direction, runtime keys/paths and 608×388 constraints in **`docs/CARD_ART_WAVE1_FINAL5_BRIEF.md`**. Remain pending as actual image assets; Godot is currently on atlas fallback. User explicitly wants to progress to these new five, not regenerate the old events. During this conversation image_gen unexpectedly returned two previous four-event collages despite text requesting five new assets; both wrong results REJECTED, not added anywhere. Alternative OpenArt account currently has zero credits; do not use it until available. **Next actionable step: a narrowly scoped user request for just the Knight Iron Oath illustration**, to guide image generation, followed by Ranger Arrowstorm, gray-bearded male Mage Glass Heart, Gold Windfall, skeletal hand holding ruby Relic Wager. Confirm visual samples separately then export/push binaries direct to main. No code or image assets changed in this latest documentation-only planning session. Do not claim five artworks completed or uploaded.

---

## LATEST — 2026-10-13 — Fix for user-reported missing event art at the table

User says approved four D132 event images did not appear in live game. Root of table case: D132 committed full 1280×720 WebPs and `ActChoice` background overrides, but live Fate Deal cards kept v4 atlas illustrations because `CardArtCatalog.get_run_card_texture` did not yet select the four D132 event assets. Now `scripts/ui/card_unification_v1.gd` also creates **center-cropped 448×274 table-card textures** for `curse_forge`, `black_altar`, `chained_prisoner`, `rattling_bridge` from the valid approved event files, with cache and legacy fallback (commits `dd4db61`, `46fe4c2`). `scripts/event/act_choice_ds2.gd` dims the new four event screens less harshly so background art is legible (commit `4d515fb`). Four existing D131 run art and their paths untouched. This is a narrow visual bug fix; no gameplay/scene resources/RunState touched. **Await local Godot proof**. User: `git pull`, compare actual table card and selected event for those four. F6 `scenes/dev/card_unification_v1_preview.tscn` tests source files; five other Wave 1 assets still absent are expected. A screenshot from one affected event is useful only if it still fails. Earlier checklist asking to unzip old art ZIP is now obsolete for these eight tracked binary WebPs.

---

## LATEST — 2026-10-13 — D132 four NEW event backdrops pushed to GitHub main

**Completed**, not just planned: main commit `1722d070cfe5a5690596953a1465b198177a57b3` contains exactly four 1280×720 WebP binaries from the user's latest accepted separate full-resolution event artworks: `assets/pixel/card_unification_v1/event/{curse_forge,black_altar,chained_prisoner,rattling_bridge}.webp`. Remote blob SHAs and commit diff confirmed. `scripts/ui/card_unification_v1.gd` and `scripts/event/act_choice.gd` were previously wired to load these when present and validated, reverting to original event PNG/WebP assets if missing; no source or gameplay edits. D132 has exact artwork source names/IDs: smith at forge; lone occult priest and red altar; solitary chained prisoner; one lantern-bearing traveler over bridge. This supersedes four low-resolution D130 event crops formerly supplied in conversation ZIP; do NOT unzip them over tracked art. D131 four run cards also shipped (8/13 D130 slots now in GitHub). **Next** user `git pull` + check four real events in Godot at 1280×720; avoid claiming runtime-tested. Then produce five remaining approved D130 upgrades and rewards. D123-D129 interface, Well/Shop background, gameplay unaffected.

---

## LATEST — 2026-10-13 — D131 four approved real WebP binaries uploaded to GitHub

User authorized publishing last four approved RunCard images; **completed** in main commit `9d864113d66236111b8a3f048afaac35416cedf1`: `assets/pixel/card_unification_v1/run/{bone_patrol,graveyard_ambush,gallows_volley,whispering_well}.webp`, each 448×274, direct downscale from correct latest approved individual 1604×981 PNG. Binary GitHub blobs and source tree preservation verified; existing `scripts/ui/card_unification_v1.gd` wired to `CardArtCatalog` requires no edits and automatically selects these. Previous 13-image `misdeal_card_art_wave1_import.zip` has obsolete small crops for **these four**; do not re-extract them over checked-in images. If the previous zip was already unpacked, `git pull` can report untracked WebPs with identical paths: move/delete the four old local copies first and pull again. Remaining nine D130 concept images are **not** binary-committed; proposed five additional images are not approved. No changes to approved UI, Whispering Well full screen, shop, arenas, RunState or gameplay; user Godot 1280×720 QA of the four table cards still outstanding. D131 now updated. Next continue remaining nine art preparations once four pass local inspection.

---

## MOST RECENT ART APPROVAL — 2026-10-13 — D131 FOUR FINAL TABLE CARD IMAGES

User approved the last four individual high-res image generations, improving formerly blurry cloned units. `bone_patrol` (gen 8a477bfd...), `graveyard_ambush` (gen 63ff9a81...), `gallows_volley` (gen 013c0ce3...), `whispering_well` (gen a13b068f...) are approved **as shown**. Full exact filenames/IDs and motifs documented in D131 and `docs/CARD_ART_UNIFICATION_WAVE1.md`. These supersede only D130's four table-card crops; the other nine D130 compositions stay accepted. The earlier 13-art ZIP still contains low-res obsolete versions of these four. Approved full-res images currently live in conversation attachments, **not GitHub**. No source/runtime files changed in this approval-only session; next task is export and deploy standalone 448x274 WebPs to existing optional override paths, then local QA. Do not regenerate approved images or restyle gameplay UI.

---

## QA detail — 2026-10-13

Source-only Godot F6 preview for all 13 candidate WebPs shipped in scenes/dev/card_unification_v1_preview.tscn and scripts/dev/card_unification_v1_preview.gd. User should pull current main and extract the conversation ZIP to Misdeal root, then F6. Preview counts missing files. It does NOT substitute an engine check or push binary image assets to GitHub; until extraction, current artwork remains active. No other activity needed until user reviews art quality.

---

## LATEST — 2026-10-13 — D130 art candidate package, Godot QA needed

Committed optional art source resolver scripts/ui/card_unification_v1.gd (82b686b), lookup changes in card_art_catalog.gd (a795478), ActChoice backdrop override (a016ebf) and file validation (fa2fd7a). Prepared user-downloadable misdeal_card_art_wave1_import.zip in conversation, with 13 WebPs in paths matching assets/pixel/card_unification_v1/{run,event,upgrade,reward}, hash manifest and review contact sheet. CAUTION: the binary WebP files are NOT in GitHub; code falls back to previous art until assets are locally installed by extracting ZIP into project root. These images were approximate extractions of D130 approved board, not pristine masters; some inset portions were reconstructed and blown-up event art may be soft. Do NOT claim live art changed solely after git pull or that these candidates were approved. Existing UI/Fate Spread, Shop, Reward and Well frozen. Next: local Godot screenshot/QA, possible clean higher-resolution separate originals. Full mapping in docs/CARD_ART_UNIFICATION_WAVE1.md.

---

## LATEST — 2026-10-13 — D130 approved card-art concept board

User explicitly accepted the last visual after several single-slot revisions. Documented in D130 and `docs/CARD_ART_UNIFICATION_WAVE1.md`: 13 approved pictured artwork compositions; 5 of the originally inventoried 18 items not pictured. Crucial: fewer medieval bow archers and **no firearms** on Gallows Volley; Mage is an **older man with gray beard** holding blue glass heart; Relic Wager is a **skeletal hand holding a crimson faceted jewel**. Other motifs in final board unchanged/accepted. Last chat image `мрачный_концепт_арт_misdeal_награда_с_рубином.png`, gen ID `6c7d5d41-24a1-47f9-8f54-e689bbe265a5` — concept image **not committed as PNG to GitHub**. This session only updated GitHub documents, not production images/code. Next: safely produce individual full-resolution no-frame textures faithful to approved sheet, upload verified assets and add keyed fallback mappings in `CardArtCatalog`/event art paths; then local Godot validation. Never claim 13 production files already installed. Keep D123-D129 protected UI, art/logic unchanged.

---

## LATEST ART PLAN — 2026-10-13 — precise card-art wave 1 inventory

User wants art unification following approved full DS2 interface; requested a concrete asset-by-asset starting list. New `docs/CARD_ART_UNIFICATION_WAVE1.md` lists **18 source-backed candidate illustrations** (7 run/deal cards, 6 active non-shop event backdrops, 3 hero upgrades, 2 rewards), exact current art paths and cell indices, reusable style rules and safe integration. No image generation or production art changes in this session. Approved Fate Spread, Reward/Well/Shop visuals remain frozen; legacy Well/Shop event backdrops are not their live full-screen backgrounds. Next: visually audit/contact sheet, select keep/revise/redraw, author three reference pieces, show for approval, then bulk switch accepted art via overrides with fallback. Do not infer this inventory equals final user approval or finished art.

---

## LATEST — 2026-10-13 — User accepted bulk Design System 2.0

After the integrated DS2 UI rollout, user replied **«все хорошо»** to the full-screen update in local Godot. This is visual sign-off for the remaining screens, and older notes here asking for a new screenshot to approve them are superseded. Do not restyle accepted screens without a newly reported issue. Integration and files: `scripts/event/act_choice_ds2.gd` with scoped hookup in `act_choice.gd`, `scripts/event/gravedigger_shop_ds2.gd`, `scripts/ui/misdeal_ds2_rollout.gd` called from Class Select, TAB Squad Status, Run End, Battle and Table. D129 documents user acceptance. Existing D123 Fate Spread, D124 Reward, D126 Well, D127 Shop remain binding.

**Next focus:** Act 1 content/gameplay and replayability. Before planning specific changes, inspect current GitHub card/encounter resources and `docs/ROADMAP.md`; discuss substantial design changes. Avoid needless UI QA loop. Exact functional coverage of every shop/event/reward edge case is still not independently demonstrated; handle as targeted backlog checks or on any issue report. Current checkpoint is documentation-only, no code/art modifications.

---

## LATEST — 2026-10-12 — Bulk DS2 rollout ready for full in-engine QA

User said «так, а давай остальное сделаем 1 большим пулом?» — explicit authorization for batching remaining UI work without separate pre-approval screenshots. In main: new `scripts/event/act_choice_ds2.gd` for all non-shop shared ActChoice event cards; guarded integration in `act_choice.gd` (shop still uses `gravedigger_shop_ds2.gd`), live event choice handlers untouched. New `scripts/ui/misdeal_ds2_rollout.gd` plus narrow calls in `scripts/class_select/class_select.gd`, `scripts/table/squad_status.gd`, `scripts/run_end/run_end.gd`, `scripts/battle/battle.gd`, `scripts/table/table.gd`. Reuses DS2 material primitives. Start/intro curated scenes and Fate Spread/Reward/Well/Shop not restyled; no scene resource modifications or new game mechanics. Static review of old gameplay bodies passed; Godot unavailable. Full local QA needed as a single `git pull` + complete game flow at 1280x720. Check multiple event card variants, dynamic disabling, result→Continue, tactical orders and shop; report concrete screenshot/parser/route problems for targeted fixes. D128 records scope. **Another chat must not claim this rollout approved in-engine.**

---

## LATEST — 2026-10-12 — Gravedigger Shop production DS2 done, pending local smoke

User approved the corrected F6 shop preview («все ок. внедряй»). Implemented scoped live DS2 shop with helper `scripts/event/gravedigger_shop_ds2.gd` and `if active_card.card_id == "gravedigger_shop"` in existing shared `act_choice.gd` (commits `bef2d4c`, `7b26850`, `664db0e`). Real button signals, `_configure_shop`, `_resolve_shop`, `_resolve_leave`, `_finish`, `_disable_choices`, `_return_to_table` unchanged by source comparisons. Uses dynamic RunState shop price (including Lost Purse), role/upgrade restrictions, real gold, and original Choice Buttons rather than preview fake purchases; supports result + continue footer. Other events/Fate Spread/Reward/Well not modified. Static source checks passed; **no local engine run**. NEXT: user git pull, enter real shop at 1280x720, inspect all card labels, affordability, absent role, live prices, purchase grant and deduction, or choose leave, then Continue. Treat production visuals/gameplay unaccepted until verified.

---

## NEWEST — 2026-10-12 — Shop preview F6 missing static text: fix pending QA

Real screenshot of `res://scenes/dev/design_system_v2_shop_preview.tscn` showed art and runtime-updated prices but invisible pre-authored title/role/description labels. Commit `f6bb46e` reassigns static Label text after scene hierarchy is built, and improves disabled/available visual differentiation. No engine-side recheck yet: `git pull`, F6 at 1280×720, verify complete header, labels above/inside all cards, details and footnote; request next screenshot only if missing/overlapping. Do not touch real shop `act_choice.gd` pending explicit preview approval.

---

## LATEST — 2026-10-12 — Gravedigger Shop visual prototype available

New isolated F6 preview in main: `res://scenes/dev/design_system_v2_shop_preview.tscn` + `scripts/dev/design_system_v2_shop_preview.gd`. Uses the existing DS2 visual kit and approved table, role upgrade images; 25 gold is illustrative only, demo toggle sets 40/10 gold and Mage absent/present. No RunState, production scene or economy modified. Ask user to `git pull` and F6 at 1280x720; do not migrate shared `act_choice.gd` without approval. Preserve D123 Fate Spread, D124 Reward, D126 Well. Existing real `gravedigger_shop` logic uses variable RunState price and Lost Purse consequences.

---

> **Fast restart:** Read [`docs/SESSION_CHECKPOINT.md`](SESSION_CHECKPOINT.md) for the concise current status, visual sign-offs, remaining QA and exactly scoped Gravedigger Shop task. Detailed history follows.

# LATEST HANDOFF — 2026-10-12 — Whispering Well visuals accepted; next shop preview

**User acceptance:** after commit `1adc634` fixed the actual ~55px right-shifted HBox card group, rescued the clipped two-line Mage outcome and separated warnings, user explicitly replied **«без скрина все хорошо. что дальше?»**. This confirms the local Godot **visual layout is good**; do not require another screenshot or continue polishing without a new reported defect. Recorded in binding decision **D126**. Earlier `Godot screenshot pending` notes below are superseded **for visual alignment only**. Detailed choice effect/routing gameplay verification remains separate and does not need to block the next preview.

Next recommended DS2 target: **Магазин могильщика / `gravedigger_shop`**. Repo inspection found it is NOT a standalone scene: `scripts/event/act_choice.gd` and `scenes/event/act_choice.tscn` are shared by many events (`ash_rest`, `curse_forge`, `chained_prisoner`, `black_altar`, `gravedigger_shop`, etc.). `_configure_shop()` uses dynamic `RunState.get_gravedigger_shop_price()`, Lost Purse outcome, 3 role-specific upgrade buys, and gold gating. **Never restyle the whole shared scene without explicit approval.** Build one isolated F6 shop DS2 preview using existing role-choice art/DS2 materials; after visual approval, integrate only when `active_card.card_id == "gravedigger_shop"`, keeping all shop price and grant handlers.

Original Fate Spread D123, live Reward major-upgrade D124, preview/live event D125, latest Whispering Well sign-off D126 remain authoritative. This session changed docs only, no production scripts or art; no git pull required for immediate visual changes.

---

# LATEST HANDOFF — 2026-10-12 — Corrected true Whispering Well row misalignment

User's latest Godot screenshot demonstrated the three card **group** was shifted ~50–55px right of header/footer; previous fixes only aligned text inside each card. Cause: sizing `HBoxContainer Choices` while three Buttons still had their old 330px minimum sizes, creating an oversized parent despite subsequent 292px child widths; centered layout left surplus space. Screenshot also showed clipping of «МАГ ПРИСОЕДИНИТСЯ» in first card and cramped disabled-gold warning. Commit `1adc634` in `scripts/event/whispering_well.gd`: apply child 292px minimums before parent size, set HBox beginning alignment, row x176 width928, reassert geometry deferred after live offer text is hidden, top-align header narrative and enlarge allowed two-line outcome area (56px), shift warning to y365. Header/footer centered at x640 in base 1280px viewport; no changes to actual DS2 art or card assets.

Source audit against preceding script blob `f534a957...`: `_refresh_choice_text`, `_on_accept_gift`, `_on_pay_coin`, `_on_leave`, `_disable_choices`, `_return_to_table`, `_apply_choice_art` untouched. Godot executable was not available; **await user's live 1280×720 screenshot** after `git pull` before claiming layout is fixed in-engine. Check centered card group, two visible rescue lines, warning margin, and enabled/disabled choice flow. D123 favorite Fate Spread, D124 approved Reward and D125 event direction remain binding. Historic notes below.

---

# LATEST HANDOFF — 2026-10-12 — Whispering Well card alignment committed

User supplied a second **real production Whispering Well** screenshot at 1280×720 after header fix and said visual treatment looked great but wanted all elements better aligned. User explicitly requested GitHub implementation. `scripts/event/whispering_well.gd` now has uniform header and card text baseline geometry, a 153px parchment region and reserved bottom warning line for all cards (`c513b63`); disabled choice details no longer repeat the warning, and font sizing uses final displayed text (`dd4b486`). All three card image/width/position assets and approved colors unchanged. Only UI code was touched.

**Strong static check:** `_refresh_choice_text`, `_on_accept_gift`, `_on_pay_coin`, `_on_leave`, `_disable_choices`, `_return_to_table`, `_apply_choice_art` are byte-identical to previous production script (blob `1226f476925a183beb734f438b52dff95c192430`). The complete original offer text remains on tooltips. No Godot executable available in this session.

NEXT: `git pull`, replay production `ШЕПЧУЩИЙ КОЛОДЕЦ` at 1280×720 with insufficient gold (20) and then sufficient gold; visually verify header rhythm and common card baselines, especially the red warning. If accepted, lock screen and continue next DS2 event preview. Original Fate Spread D123 and Reward D124 remain untouched. Previous handoffs historical.

---

# LATEST HANDOFF — 2026-10-12 — Whispering Well screenshot fix committed

After DS2 live event migration, user supplied a real 1280×720 screenshot showing production Whispering Well with three polished blood/coin/leave parchment cards. We found a visible **header layout defect**: the long story description lay across bottom header line; `GoldLabel` vanished behind opaque `HeaderPanel` due older scene draw order. `scripts/event/whispering_well.gd` now positions header title at y55, Wizard line y97, description y128 with header ending y180, and gold/party stats at y32 with `z_index=1` to render over panel; commit **`2a0baab`**. No changes to choice art geometry or seven preserved gameplay handlers. This is a code correction awaiting Godot recheck, **not user-accepted final live event**.

Next: user `git pull`, trigger Whispering Well, inspect Cyrillic description entirely inside header, visible stats, three choices, disabled gold warning. Confirm actual outcome/return to table and revisit case. Protect favorite Fate Spread D123 and accepted Reward major-upgrade D124. Move to other events only after the live presentation is approved. Older entries historical.

---

# LATEST HANDOFF — 2026-10-12 — Live Whispering Well DS2 implemented (awaiting Godot QA)

User approved the separate DS2 F6 Whispering Well preview and requested production implementation. Real `scripts/event/whispering_well.gd` migrated in `238c75b`, disabled-choice readability improved `f7c9fbc`, click selection highlighting added `3480acf`. `scenes/event/whispering_well.tscn` now points its backdrop to approved Variant C `table_exact.webp` (`ce5a35f`), not a new or edited table asset. The original production event Button nodes and approved choice art catalog remain; the layout/header/footer and dynamic descriptions use shared opt-in `MisdealUIKit` DS2 bronze/parchment styling.

**Gameplay handlers were compared against pre-change GitHub blob:** `_refresh_choice_text`, `_on_accept_gift`, `_on_pay_coin`, `_on_leave`, `_get_role_label`, `_disable_choices`, `_return_to_table` are all byte-for-byte unchanged. A new adapter splits live Button offer text into bounded title/cost/outcome labels and preserves full original wording in tooltips. Disable/warning states and one-click action routing are preserved. Both Mage rescue (blood / 25 gold / abandonment) and non-recruit revisit (extra upgrade, relic and fallback) must work.

**Local acceptance outstanding:** `git pull`, play a live Whispering Well event at 1280×720 with recruitable Mage and both insufficient/sufficient gold, verify visible labels and real choices, then play a non-recruit revisit if accessible. Report parser errors, clipped Cyrillic, payouts, card selection or missing art. F6 preview was approved; actual gameplay event has not been run by connector-side author. Reward major-upgrade visual baseline remains approved D124; other reward flows still need smoke. Fate Spread art and layout frozen by D123. New design decision D125 documents this scoped migration. Older sections below historical.

---

# LATEST HANDOFF — 2026-10-12 — DS2 isolated Whispering Well event preview created

After the user's real production Reward `major_upgrade` screenshot was accepted and frozen (D124), the user said «давай дальше». Next **review-gated** implementation is in GitHub main: `scenes/dev/design_system_v2_well_preview.tscn` and `scripts/dev/design_system_v2_well_preview.gd`. This **F6-only** preview shows a canonical DS2 bronze/darkwood/parchment presentation of **«ШЕПЧУЩИЙ КОЛОДЕЦ»** using the existing `assets/pixel/event/v7/whispering_well.webp` background and actual `ApprovedEventChoiceArt.get_whispering_well_texture(0..2)` images. Sample options mirror real recruit-Mage state: blood -12 max HP, payment 25 gold, or leaving Mage behind. User can select a card, inspect its state and simulate insufficient gold to disable/dim the second choice. **No RunState access, no scene routing, no event resolution, no live game scene changes.**

**NEXT:** `git pull`, open `res://scenes/dev/design_system_v2_well_preview.tscn`, press F6 at 1280×720, verify three choice cards, readable text, disabled gold demo, backdrop and hover/selection, and send screenshot. **Wait for visual approval** before migrating real Well event. Existing actual `scripts/event/whispering_well.gd` has recruiting vs post-recruit upgrades/relics logic, and its dynamic choices and costs must stay unchanged. Reward non-upgrade modes and reward grant/nav smoke are not yet verified; keep D123/D124 approved art and major-upgrade layout unchanged. Older history below is historical.

---

# LATEST HANDOFF — 2026-10-12 — DS2 isolated Whispering Well event preview

User approved production Reward major-upgrade appearance D124 and asked to continue. Isolated Event study now committed: `scenes/dev/design_system_v2_event_preview.tscn` + `scripts/dev/design_system_v2_event_preview.gd` (commit `95c3f68` script, `47ec75e` scene). Uses Variant C approved backdrop, DS2 `MisdealUIKit` material/bronze/parchment components, approved original Whispering Well choice art and three narrative options for preview. Click highlights selected card only; **no RunState or scene navigation**. Real production `scenes/event/whispering_well.tscn`, `scenes/event/act_choice.tscn` and award/choice code remain unchanged. Need user `git pull`, Godot F6 screenshot and approval BEFORE migrating one production event. Still need separate reward-flow gameplay smoke (the approved screenshot only proved major-upgrade visuals). Original Fate Spread/major-upgrade visuals protected by D123 and D124. Historical notes below.

---

# LATEST HANDOFF — 2026-10-12 — Real production Reward major-upgrade UI approved

User shared an **actual Godot 4.7.x screen** of DS2 `РАЗВИТИЕ ОТРЯДА` with two party members and three upgrade cards `ЖЕЛЕЗНАЯ КЛЯТВА`, `ГРАД СТРЕЛ`, `ПАЛАЧ`. Feedback: **«Все отлично! Фиксируй»**. Record this as approved screenshot-level visual baseline (decision **D124**). Keep its Variant C-derived darkwood/bronze/parchment treatment, exact card composition, titles and upgrade text fitting. Do not tweak art/layout purely for subjective polish without requesting approval. Main code: `scripts/reward/reward.gd`, `scenes/reward/reward.tscn`; previous commits `9a5594b`, `5d121d8`, `29a797d`.

**Distinguish tested vs untested:** major-upgrade screen **look** accepted; screenshot alone does not establish clicked upgrades, follow-on loot, reward grants or routing. Test `major_upgrade → normal_loot → table`, `death_wager`, `bonus_upgrade`, `elite_artifact` before marking all Reward modes completed. Continue D123 DS2 rollout to one events/shop preview after tests. Original Fate Spread Variant C stays frozen. No gameplay/visual code changes performed in this approval-only session; docs/decision state made ready for next chat.

---

# LATEST HANDOFF — 2026-10-12 — DS2 deployed to production Reward (Godot acceptance pending)

User approved the DS2 reward preview and its corrected text, then asked to implement the actual screen immediately. Main now contains:
- `scripts/reward/reward.gd` with real Reward Buttons/labels/award handlers retained but restyled to opt-in DS2 bronze/darkwood/parchment frame (commits `9a5594b` and `29a797d`). Normal loot, major/bonus upgrades, Death Wager, Crypt Guard/elite artifacts, RunState and scene routing unchanged.
- `scenes/reward/reward.tscn` switches its background reference to already-approved `assets/pixel/table/approved_variant_c/table_exact.webp` (commit `5d121d8`); original approved Fate Spread/table code/asset untouched.
- The shared DS2 `MisdealUIKit` methods were already opt-in; no other game screen migrated.

Cards remain clickable once to claim the real reward; unlike preview there is no second confirmation. Card title/effect/description have wrapping and guarded sizes, longer upgrade effects get extra space, and full text is also available in tooltip. Static GitHub source checks passed; **Godot runtime was NOT executed** here.

NEXT LOCAL: `git pull` and play ordinary loot, major upgrade into next reward, full three-card Death Wager, bonus upgrade and elite Crypt Guard. Check fonts/overflows, correct data, selection highlighting, real grants/navigation, and screenshots at 1280×720. Keep code-first bug triage in GitHub. If accepted, follow ROADMAP to events/shop one screen at a time, NEVER restyle favorite Fate Spread. Older handoffs are historical.

---

# LATEST HANDOFF — 2026-10-12 — DS2 preview copy fit fix in main

User F6-screenshot-approved the isolated Design System 2.0 Reward preview's overall visuals (based on canonical Fate Spread Variant C) **except overflowing card descriptions**. Fix committed as `dac4953` in `scripts/dev/design_system_v2_reward_preview.gd`: all three demo descriptions explicitly wrap to two lines, title/effect/description typography set to 16/15/13, auto-wrap configured before parenting/fixed layout, `clip_text` and parchment clipping guard neighboring cards. No assets, approved Fate Spread artwork, `RunState`, or live reward scene changed. Next: `git pull` and F6 `res://scenes/dev/design_system_v2_reward_preview.tscn` at 1280×720; check visible full text in all cards and hover/selection. **Production Reward migration still awaits final user approval of this corrected screenshot.** Older handoff entries are historical.

---

# LATEST HANDOFF — 2026-10-12 — F6-only Reward material preview for DS2

Binding visual direction remains the user's favorite Fate Spread Variant C tabletop, **never repaint or rearrange it** (D123, lead \`docs/DESIGN_SYSTEM.md\`). In main: \`scenes/dev/design_system_v2_reward_preview.tscn\`, \`scripts/dev/design_system_v2_reward_preview.gd\` and new opt-in functions \`MisdealUIKit.apply_v2_material_plate / apply_v2_parchment_plate / apply_v2_reward_card\`. Prototype reuses \`assets/pixel/table/approved_variant_c/table_exact.webp\`, existing \`CardArtCatalog\` reward illustrations (\`gold_windfall\`, \`relic_wager\`, \`bonus_upgrade\`) and a static mock of Death Wager choices. Hover, selecting cards and the inspect button only change presentation text; no \`RunState\`, reward grants, or scene navigation. **Production reward, table, Fate Spread, battle are unmodified.**

Next action: user \`git pull\`, open \`res://scenes/dev/design_system_v2_reward_preview.tscn\` and press **F6** at 1280×720. Validate art/background loaded, legible 3-card parchment panels, input/hover selection, and bottom feedback, then send screenshot for approval. Only after that migrate a single production Reward screen. Connector environment could not execute Godot, so do not claim runtime success. Older handoffs below are historical.

---

# LATEST HANDOFF — 2026-10-12 — Fate Spread is canonical Design System 2.0 reference

**Binding user approval:** screenshot of «MISDEAL — РАСКЛАД СУДЬБЫ» (existing approved Variant C) is user's favorite screen and the principal visual reference for all Misdeal UI. Do not redesign or recolor its original composition, rings I–XIII, card faces or materials. Base new visual grammar on obsidian dark wood, ritual red markings, aged bronze/gold, parchment, blue night lighting, tactile deck/cards and candles. See new lead section of `docs/DESIGN_SYSTEM.md` and decision D123.

`scripts/ui/misdeal_ui_kit.gd` now has **opt-in** `TABLE_OBSIDIAN`, `RITUAL_CRIMSON`, `AGED_BRONZE`, `PARCHMENT_WARM`, `MOONLIT_STEEL` constants; legacy GOLD/BRONZE/etc and live components are deliberately unchanged. **No game screen was restyled yet.** Next work: isolated F6 reward/event style preview, approval on actual 1280×720 Godot screenshot, then one-by-one safe migration. Existing compact health bars and recent character scale changes need local QA separately. Older history below may mention DS1 as the visual goal; D123 supersedes style hierarchy, not safe UI behavior.

---

# LATEST HANDOFF — 2026-10-12 — Compact battle health bars

User requested redesign after Gallows Volley screenshot: bright solid green/red slabs obscured character art. `scripts/battle/unit.gd` now styles existing `ProgressBar` with near-black background, bronze hairline border, muted green hero fill / deep red enemy fill, 58×7 typical footprint, 66px Crypt Guard width and 114×9 boss variant (`d744e61`). HP calculation/damage/healing, combat gameplay, unit art, node paths unchanged. **Need local Godot visual verification:** `git pull`, re-run Gallows Volley with party and enemies, inspect at full and low HP, unit crowds, boss. Earlier notes below are historical.

---

# LATEST — 2026-10-12 — Mage size correction after clean redraw

Latest screenshot Bone Swarm: the improved clean Mage atlas looked oversized at former art-only scale 1.65. Reduced Mage hero visual multiplier to **1.25** in `scripts/battle/unit.gd` (commit `38831c0`). Knight 0.90 and Ranger 1.00 unchanged; no art/gameplay updates. Next: `git pull`, open battle with Mage and Ranger side-by-side and confirm comparable height/grounding; adjust only from screenshot feedback.

---

# LATEST HANDOFF — 2026-10-12 — Clean Mage atlas, retain accepted height

User accepted Mage **height** at hero-only scale 1.65 but rejected poor alpha/art quality in screenshot. A stronger purple-robed, old-white-bearded Mage was generated and user approved it. New transparent 576×480 / 25-pose `assets/pixel/units/combat_units_anim_v2/mage.webp.b64` committed (`9d72854`) with exact GitHub Base64 verification (414688 chars). Old Mage resource archived as `mage_archived_pre_dark_clean.webp.b64` (`089b9fd`). Loader now plays all six Mage attack frames rather than obsolete skipped projectile-only cell (`6ce91f9`). **No change to current Mage scale 1.65**; all other heroes and battle mechanics unchanged.

LOCAL NEXT: `git pull`; F6 `res://scenes/dev/unit_animation_pack1_preview.tscn`; then actual Mage battle. Inspect solid cloak and readable beard/face, no speckled/ghost transparency, attack projectile FX, boots/ground and six attack poses. Offline frame checks passed but **no Godot runtime test was available**. Correct artwork based on actual screenshot; historical sections below are superseded.

---

# LATEST — 2026-10-12 — Mage art scale increased again

User screenshot from Firing Square: Knight and Ranger reasonably similar in apparent size; old-beard Mage still much smaller. Hero-only Mage visual multiplier increased **1.15 → 1.65** in `scripts/battle/unit.gd` (`ab22b50`); Knight 0.90, Ranger 1.00 unchanged. Baseline recomputed with final art scale, no collision/AI changes. Next: `git pull`, inspect trio pre-fight and after movement, send screenshot if Mage overshoots or still differs. Older scale recommendations below are superseded.

---

# LATEST HANDOFF — 2026-10-12 — Hero art scale normalization

Screenshot of **ЖЕЛЕЗНАЯ СТЕНА** revealed Knight visibly larger than Ranger and new elder Mage visually tiny. In `scripts/battle/unit.gd`, hero-only `HERO_ROLE_VISUAL_SCALES` now multiplies the existing hero art scale: Knight 0.90, Ranger 1.00, Mage 1.15 (commit `24b3df1`). `base_sprite_scale` and animated foot-rest position are computed AFTER the role factor, so floor baseline should follow the new scale. Enemies, boss, hitboxes, movement, AI, combat balance and art files are untouched.

**Pending local QA:** `git pull`, open the Iron Wall encounter with all three heroes, inspect matching perceived height against floor ring in placement, idle and actual combat. These are initial correction factors, not user-verified final parity. Previous Knight blue and bearded Mage animation QA remains open. Older sections below are historical.

---

# LATEST — 2026-10-12 — Approved old-bearded Mage replacement in main

User approved **variant 1 from the last three Mage concepts**, a silver-haired, white-bearded, staff-wielding elder with dark purple robe. Its new transparent 576×480 25-frame Base64 WebP replaces `assets/pixel/units/combat_units_anim_v2/mage.webp.b64` (`3e23cc8`); prior Mage sheet archived alongside as `mage_archived_pre_oldbeard.webp.b64` (`4c0e94a`). Remote Base64 confirmed exactly equal to supplied approved artifact (123144 characters). No `.gd` or combat content changed because Mage already loads animation frames.

**LOCAL QA STILL REQUIRED:** `git pull`, Godot 4.7.x `res://scenes/dev/unit_animation_pack1_preview.tscn` F6, Mage idle/walk/attack/hit/death. Check beard/staff, boot-floor contact, old presentation-line artifacts, attack/projectile-only frames and actual combat scale. Existing Mage animation loader historically skips a projectile-only fifth raw attack cell; the new source has 6 visually authored poses and that role-specific skip may need later reconsideration after local review. Do not silently change projectile frame routing without inspecting in-engine impact.

Pack 1: Knight blue, Ranger, Mage new oldbeard, Skeleton, Bone Archer all anim-enabled. Pack 2: Bone Thrall/Bellkeeper/Crypt Guard/Bone Warden anim-enabled. Other runtime QA remains outstanding. Old handoff sections below are historical.

---

# LATEST HANDOFF — 2026-10-12 — Blue Knight animation now live in GitHub

User approved new **blue** armored Knight with clearly distinct legs. The transparent 576×480 25-frame atlas is committed as `assets/pixel/units/combat_units_anim_v2/knight.webp.b64` (`6afd288`), and source-to-GitHub Base64 was verified (456632 chars). Previous flawed Knight sheet archived alongside as `knight_archived_pre_blue.webp.b64` (`0101679`). Production `scripts/battle/unit.gd` opted Knight back into normal SpriteFrames (`dffa7ee`), keeping static v4 fallback when animation file fails.

**Engine acceptance outstanding:** Godot 4.7.x not run here; user must `git pull`, open `res://scenes/dev/unit_animation_pack1_preview.tscn` (F6), examine Knight all five states, then test solo/duo/trio in Bone Swarm / Grave Crossroads. Confirm distinct left/right boots, grounding against ring, shield not obscuring feet, death pose and no frame boundary scraps. Other four Pack 1 roles, all Pack 2 enemies, combat mechanics unchanged.

Current art status: five Pack 1 roles and four Pack 2 roles now frame-enabled. After screenshot feedback, address only actual observed in-engine quality issues. Do not re-enable archived Knight or change fundamental combat design. All older handoff sections below are historical.

---

# LATEST HANDOFF — 2026-10-12 — All four Pack 2 animation assets committed / enabled

All four user-approved Pack 2 animated enemies have actual 576×480 transparent, 25-used-frame Base64 WebP resources at `assets/pixel/units/combat_units_anim_pack2_candidates/{bone_thrall,grave_bellkeeper,crypt_guard,bone_warden}.webp.b64`. Bone Warden was last: asset commit `77a759d`, loader commit `1238b3c`; GitHub's fetched Base64 text matches the approved source (379148 characters). Production `MisdealUnitAnimationLibrary` includes all four Pack 2 roles while preserving static v4 fallback. Original Stage A contact VFX remain; gameplay/AI/stat/battle layouts unaffected.

**Not yet validated in Godot:** no F6/full game runtime test was performed in this connector environment. User should `git pull`, F6 `res://scenes/dev/unit_animation_pack2_preview.tscn` and check five states of all four enemies, especially Bone Warden staff/scale/floor/corpse, then play Bone Warden battle for phase/contact effects. Mark Pack 2 visually accepted only after local in-engine approval.

**Other roles:** Knight static v4 by design due to unreadable archived animated legs; Ranger, Mage, Skeleton and Bone Archer keep Pack 1 v2 frames. Next meaningful animation asset work: genuinely redraw Knight frames and obtain visual approval; don't switch current static Knight without review. Sections below are historical and can incorrectly claim missing Pack 2 sheets.

---

# LATEST — 2026-10-12 — Crypt Guard animation uploaded and enabled

User approved Crypt Guard. Genuine transparent 576×480 sprite atlas `assets/pixel/units/combat_units_anim_pack2_candidates/crypt_guard.webp.b64` is now committed to main (`5412b1d`), GitHub bytes checked against uploaded source. `scripts/battle/unit_animation_library.gd` now routes `crypt_guard` alongside `bone_thrall` and `grave_bellkeeper` to optional Pack 2 candidate atlas files (`fa78548`); any missing/invalid sheet falls back to static v4. All five states exist (4/6/6/3/6). Offline validation succeeded, **but Godot F6 and combat QA NOT done**.

Now only Bone Warden remains static v4 among four Stage B enemies. Knight stays static v4; Ranger/Mage/Skeleton/Bone Archer stay animated Pack 1 v2. No gameplay/stat/AI changes. Next: user `git pull`, F6 `scenes/dev/unit_animation_pack2_preview.tscn`, inspect Crypt Guard and combat. Then author and approve actual Bone Warden sheet. The historical sections below may describe older checkpoints.

---

# LATEST HANDOFF — 2026-10-12 — Grave Bellkeeper animation live via Pack 2

User approved Grave Bellkeeper. The exact prepared transparent 576×480 (6×5, 96px each) 25-pose Base64 WebP sheet is committed at `assets/pixel/units/combat_units_anim_pack2_candidates/grave_bellkeeper.webp.b64` (commit `c28011d`) and verified against source export. `scripts/battle/unit_animation_library.gd` now includes `grave_bellkeeper` in production alongside `bone_thrall` (commit `9f32e4b`), with static-v4 fallback. Runtime Godot F6/battle is NOT tested yet.

**Do next:** `git pull`, open `res://scenes/dev/unit_animation_pack2_preview.tscn` with F6 and inspect Bellkeeper all states; check real Bellkeeper fights for feet, bell/chain, alignment and death. No combat mechanics, roster, balance or other models changed.

Knight static v4; Ranger/Mage/Skeleton/Bone Archer Pack 1 animated; Bone Thrall/Grave Bellkeeper Pack 2 animated; Crypt Guard and Bone Warden static v4 + Stage A VFX. **Next new asset: Crypt Guard.** All older handoff notes below are historical; prioritize this header.

---

# LATEST CHECKPOINT — 2026-10-12 — Bone Thrall Pack 2 asset uploaded

Actual approved 576×480 / 25-used-frame `bone_thrall.webp.b64` is now committed to `main` at `assets/pixel/units/combat_units_anim_pack2_candidates/bone_thrall.webp.b64` (commit `29d0725`). Fetched remote file equals locally approved Base64 asset. Previously changed production loader (commit `d25e471`) searches that directory for Bone Thrall and returns SpriteFrames; fallback static v4 when missing/broken. **Bone Thrall animation is now enabled by the presence of the actual asset**. No Godot F6/runtime smoke has been performed, so visual approval of the actual in-engine motion is still required.

Knight remains static v4; four existing Pack 1 roles stay animated; Grave Bellkeeper, Crypt Guard and Bone Warden remain static v4 + Stage A effects. These **three** spritesheets are still missing; no other combat unit switched. User should `git pull`, run F6 review scene then check Bone Thrall in a live encounter (feet, alpha, attack timing, death). Next chat can resume Pack 2 art with Bellkeeper.

---

# LATEST — 2026-10-12 — Approved Bone Thrall asset awaiting GitHub file upload

User approved a 576x480 transparent 6x5 / 25-pose Bone Thrall draft in this chat. Local artifact converted losslessly to `bone_thrall.webp.b64` (254065 bytes); **it is NOT YET IN GitHub**. Production animation library was patched safely: optionally load this exact filename from `assets/pixel/units/combat_units_anim_pack2_candidates/` for role `bone_thrall`, otherwise keep static v4. Commit `d25e471`. Other roles unaffected. No runtime Godot testing performed.

NEXT: commit the actual approved Base64 sprite asset, then run candidate F6 preview and a live Bone Thrall fight. Until the file exists in GitHub, no Bone Thrall animation is actually deployed. Remaining three enemies still need original sheets.

---

# CURRENT RESUME — 2026-10-12 — Animation frame briefs written; spritesheets not yet drawn

**GitHub checkpoint:** Pack 2 Stage B infrastructure is finished (importer + Godot validator + F6 candidate comparison). The new `docs/UNIT_ANIMATION_PACK2_FRAME_BRIEFS.md` now specifies row-by-row animation beats for Bone Thrall, Grave Bellkeeper, Crypt Guard and Bone Warden plus key-pose approvals and frame-grounding rules. This is documentation / asset-production planning, **not generated animation art**.

**Still missing:** all four true transparent 576×480 6×5 sheets, 25 distinct frame poses each; staged candidate `{role}.webp.b64` files have not been added. Begin with **four key poses for Bone Thrall**, review silhouette and foot contact, then build its full atlas and repeat for other roles. Do not crop arena images or fabricate animation from static v4.

**Production unchanged:** Knight static v4 (-8px), Ranger/Mage/Skeleton/Bone Archer existing Pack 1 v2 frames, four target undead static v4 + already live Stage A hit FX. No switch in `scripts/battle/unit.gd` or `scripts/battle/unit_animation_library.gd`. Existing importer/preview are ready for real candidates; Godot F6 smoke still pending.

**Next chat:** read `AGENTS.md`, `docs/PROJECT_STATE.md`, this file, `docs/UNIT_ANIMATION_PACK2.md` and `docs/UNIT_ANIMATION_PACK2_FRAME_BRIEFS.md`. Execute asset-production gate → candidate import → F6 quality review → user sign-off → **only then** per-role live activation.

---

# AUTHORITATIVE HANDOFF — 2026-10-12 — Pack 2 Stage B ready for art, NOT live

**FINAL VERIFIED RESUME POINT:** Technical preparation is **COMPLETE**, with the offline importer, candidate validator, side-by-side F6 Godot scene and staging instructions all present in GitHub. All four candidate paths were checked individually and **none exists yet**. The production battle scene/animation loader was **NOT switched** to any Pack 2 art. Do not crop a battle-screen illustration into character frames or fabricate repeated poses. The next task is **source/author real per-character spritesheets → stage/import → validate in F6 → get visual approval → only then enable in battle**. Engine F6 preview hasn't been run in this connector session.


**GitHub `zampolit73/Misdeal` is source of truth. User explicitly requested a checkpoint for a new chat. No need to re-ask for GitHub access or past development context. Read AGENTS.md, docs/CONCEPT.md and this latest section first.**

**PREPARATION COMPLETED:** `scripts/dev/import_animation_pack2_candidate.py` (authoring-only Python/Pillow PNG → lossless WebP/Base64, validated with existing Pack 1 art and invalid opaque art); `scripts/dev/unit_animation_candidate_validator.gd` (isolated candidate QA); `scripts/dev/unit_animation_pack2_preview.gd` and `scenes/dev/unit_animation_pack2_preview.tscn` (F6 v4 vs potential new frames); `assets/pixel/units/combat_units_anim_pack2_candidates/README.md`; `docs/UNIT_ANIMATION_PACK2.md`. Stage A real short attack-contact effects already live.

**SPRITESHEETS STILL REQUIRED:** no accepted animation sheets for `bone_thrall`, `grave_bellkeeper`, `crypt_guard`, `bone_warden`. Candidate folder has only README; do NOT claim assets generated, uploaded, approved or activated. Needed per role: true transparent 576x480 atlas, 6x5 cells of 96px, populated Idle4 / Walk6 / Attack6 / Hit3 / Death6 (25 real distinct poses). Pixel silhouette, separate boots, intact weapons, correct row segmentation and foot contact must be reviewed visually. Full-scene generated illustrations are unsuitable and were not integrated.

**PRODUCTION NOT SWITCHED:** `scripts/battle/unit.gd` and `scripts/battle/unit_animation_library.gd` were not modified in Stage B. Knight currently static v4 (visual Y offset -8); Ranger, male Mage, Skeleton and Bone Archer retain Pack 1 v2 frame animation. The four other undead remain static v4 with Stage A attack impact cues. No mechanics, targeting, positioning, damage or scene layouts were changed.

**NEXT:** (1) produce real sprite art; (2) import/stage each valid asset with committed importer; (3) Godot F6 preview, all five states, compare against v4 and reject poor feet or weapons; (4) obtain user approval; (5) activate individually in existing SpriteFrames loader with v4 fallback and smoke gameplay. Without art F6 should say `ОЖИДАЕТ АРТ`. Local Godot test of new staging scene remains pending.

**Canonical references:** PROJECT_STATE head, ROADMAP head, docs/UNIT_ANIMATION_PACK2.md, VISUAL_ASSET_REGISTRY head, DECISIONS D119–D121, CHANGELOG. All following HANDOFF sections are historical and may contain obsolete Knight offsets or animation states.

---
# LATEST LIVE CHECKPOINT — 2026-10-12 — Pack 2 Stage B art QA pipeline / gallery shipped, candidate art NOT yet available

The user said "давай дальше" after Stage A attack FX for the remaining undead. Repo checked against `AGENTS.md`, `CONCEPT.md`, `PROJECT_STATE.md`, `ROADMAP.md`, `DECISIONS.md`. **No genuine multi-frame sheets exist** yet for Bone Thrall, Grave Bellkeeper, Crypt Guard, Bone Warden. Two attempts at built-in image generation yielded full battle screen compositions rather than independently authored sprite frames; they were **not** inserted into the project. OpenArt available but account has 0 credits so no art generated there.

**Committed in main:**
- `scripts/dev/import_animation_pack2_candidate.py` (requires Pillow only for authoring/export, not for game). Tests strict 576×480 image, RGBA/alpha, 25 occupied 96×96 slots with Idle4/Walk6/Attack6/Hit3/Death6, reject opaque/incomplete/duplicate Walk/Attack; warns on y foot baseline outside 87..94 or touching cell edges. Exports lossless `.webp.b64`. Tested locally with existing grounded Pack1 artwork (accepted with warnings) and deliberately invalid opaque sheet (rejected).
- `scripts/dev/unit_animation_candidate_validator.gd` (runtime dev QA only): safely decode candidate staged resources, measure alpha presence/foot bounds and construct optional `SpriteFrames`; never consulted by live `BattleUnit`.
- `scripts/dev/unit_animation_pack2_preview.gd` and `scenes/dev/unit_animation_pack2_preview.tscn`: F6 gallery shows four actual v4 static enemies alongside optional valid candidates. Missing candidates show `ОЖИДАЕТ АРТ`. State buttons demonstrate any future approved animation for frame review.
- `assets/pixel/units/combat_units_anim_pack2_candidates/README.md`, `docs/UNIT_ANIMATION_PACK2.md`: candidate folder convention, visual quality tests and exact future stage steps.

**UNCHANGED:** main combat, its movement/facing/HP/AI, all four v4 enemy sprites and Stage A role-specific attack cues; Knight still static v4 with readable boots, other four Pack1 sprites remain animated. Nothing new is live until actual 6×5 candidate art is produced, reviewed in Godot and explicitly approved. No Godot executable here, so F6 still to be smoke-tested.

**NEXT:** author authentic readable 25-frame sheets for four remaining undead, validate/stage, show comparison and then deploy after approval. Don't pretend the QA implementation itself completed new character animations. For temporary playtest, `git pull` F6 both `scenes/dev/unit_undead_fx_preview.tscn` and `scenes/dev/unit_animation_pack2_preview.tscn`. Maintain GitHub continuity; no need to re-ask access. Old handoffs below are history.

---

# LATEST LIVE CHECKPOINT — 2026-10-12 — Undead Pack 2 Stage A (real attack-contact FX, not new spritesheets)

User said to continue after reverting Knight to a readable static v4. Inspected GitHub + checked local `/mnt/data` art for the four extra enemy roles. **There were no full frame animation sprite sheets** for Bone Thrall, Grave Bellkeeper, Crypt Guard, Bone Warden. Prior ImageGen attempt yielded a scenic battle illustration, **not valid separate animation cells**; it was correctly NOT connected to Godot. Instead committed a modest **production VFX stage** now, with clear Stage B to do later.

Committed GitHub files:
- `scripts/battle/unit_attack_visuals.gd`: small, transient native Line2D/Tween cues at attack contact: Thrall claw marks; Bellkeeper concentric gold-green bell pulses; Guard crossed bronze strokes; Warden red/gold ground pulses + heavy slash. FX last ~0.17–0.36s and queue_free themselves.
- `scripts/battle/unit.gd`: `ATTACK_VISUALS` preload and a single spawn call inside `_play_attack_feedback()`. Original `_attack_target()` still does real immediate damage and splash; new FX are not combat telegraphs or stat changes.
- `scripts/dev/unit_undead_fx_preview.gd` and `scenes/dev/unit_undead_fx_preview.tscn`: F6 gallery of actual static-v4 `BattleUnit` enemy nodes with per-role `ПОКАЗАТЬ УДАР` buttons, invoking identical effect helper without altering HP.
- `docs/UNIT_ANIMATION_PACK2.md`: truthful shipped Stage A vs unimplemented Stage B, smoke testing, frame-art QA requirements.

**Important live state:** Knight remains deliberately static v4 with clear legs and -8px static floor correction. Ranger, male Mage, Skeleton, Bone Archer have real v2 SpriteFrames. All four newly enhanced enemy types remain static v4 with attack-only VFX; DO NOT claim they now have idle/walk/death sprite animations. Keep main dark-fantasy combat/card gameplay intact.

**User next:** `git pull`, open `scenes/dev/unit_undead_fx_preview.tscn` and F6, test four buttons. Then play encounters with each enemy (particularly boss), confirm no overwhelming visuals or damage-delay changes. Runtime Godot not available here. After approval, produce genuine leg/weapon-readable pixel-art sprite sheets for Stage B, then connect through existing `MisdealUnitAnimationLibrary`, reverting to static on bad/missing art. Review real frames; do not crop screenshot-style illustrations into fake sprites.

---

# LATEST LIVE CHECKPOINT — 2026-10-12 — Knight static v4 fallback to restore readable legs

User explicitly requested replacing the Knight immediately and pushing to GitHub, after repeated screenshots showed animated Knight has no readable legs even with Y lift to -16px. **Change committed directly to main:** `scripts/battle/unit.gd`, code commit `1a1141d7e33c32f5ef3c8aa8da94acfc4bcec6c5`.

- New `STATIC_COMBAT_ART_ROLES := ["knight"]`, and `_ready()` skips the animation frame loader for that role only; calls established `_get_art_texture()` to use existing v4 atlas Knight tile (0,0), which has visible separate leg armor and boots. Unchanged: Ranger, male Mage, Skeleton, Bone Archer real SpriteFrames animations; unsupported enemies static v4.
- Knight `ROLE_FLOOR_OFFSETS["knight"]` changed `-16.0` → `-8.0` because static atlas boot alpha extends to y≈94/96 and art scale 1.28; extra -8 positions boots near existing ring y=36. Do not reuse animated Knight's offset for static.
- Retain Knight v1/v2 animation Base64 assets **and** the F6 animation gallery (which still previews the archived animated knight). Art fallback does not change the UnitData, HP/name nodes, combat timing/attack tween/facing, ally/enemy placement, collisions, arena or table art.
- **Next user:** `git pull` then look at Knight legs in Bone Swarm/Grave Crossroads before and during battle. Visual check local; Godot binary not run here. Redraw actual Knight 5-state atlas before switching animation back; do not solve leg visibility by further Y-offset nudging. Other four role animations remain.
- Checkpoints updated in `docs/PROJECT_STATE.md`, `docs/ROADMAP.md`, `docs/DECISIONS.md`, `CHANGELOG.md`, `docs/UNIT_ANIMATION_PACK1.md`.

Historical handoff entries about Knight -16/-12/other role animation status are superseded. Connected GitHub access worked; do not claim otherwise without checking.

---

# LATEST LIVE CHECKPOINT — 2026-10-12 — Knight sprite floor offset −16 px

The user requested raising Knight another 4px. Implemented and **committed directly into GitHub main**, code commit `11f904b003430f43e6d785a2b1bd4ed80fcc666b`: `scripts/battle/unit.gd` has `ROLE_FLOOR_OFFSETS["knight"] = -16.0`, previously -12.0. Ranger remains -6.0; no other roles, mechanics, hitbox/position, sprite atlas, arenas, scene geometry or gameplay were changed. Check in local Godot after `git pull`, especially Knight's boots to blue ground ring in Bone Swarm. Prior history with Knight -12px is superseded.

---

# LATEST LIVE CHECKPOINT — 2026-10-12 — Knight floor offset −12 px

The user explicitly requested another two-pixel Knight lift after sharing a Bone Swarm screenshot. **Committed directly to GitHub main**: `scripts/battle/unit.gd`, `ROLE_FLOOR_OFFSETS["knight"]` **−10.0 → −12.0**; code commit `6a5ac695c12a13de73860113e101618a499f026d`. All other role offsets (including Ranger −6), animation assets, battles, hitboxes, scene layout and art are unchanged. Godot runtime wasn't run here. User action: `git pull`, test Knight visual boot contact in Bone Swarm during placement/movement and against the blue ring. GitHub is source of truth. Historical entries below are superseded where they mention Knight −10 or older.

---

# LATEST LIVE CHECKPOINT — 2026-10-12 — Knight ground offset −10 px

User shared a three-hero Cemetery Ambush screenshot and suggested lifting Knight another couple pixels. **Done in GitHub `main`**: `scripts/battle/unit.gd`, `ROLE_FLOOR_OFFSETS["knight"]`: **−8.0 → −10.0**, commit `8d69a5812d98483f7c78c7fc800d50bcb7d09ee7`. No change to Ranger (−6px), Mage, enemies, animation atlases, logical placement/physics or game balance. The existing role-specific `_art_rest_position()` provides the final visual correction in all states. Next: user `git pull` and view Knight feet against blue floor ring during placement/attack. Godot runtime not tested here. No need to re-ask GitHub access. Historical notes below are superseded where they mention Knight −8px.

---

# LATEST LIVE CHECKPOINT — 2026-10-12 — Knight optical height −8 px

User asked for another +2 px visual lift of Knight after the previous Knight/Ranger parity test. **Successfully committed directly to GitHub `main`**: `scripts/battle/unit.gd` now sets `ROLE_FLOOR_OFFSETS["knight"] = -8.0` (formerly `-6.0`), commit `2452e6945396c257ce8ce5b71df15f012a1e7aca`. Ranger remains `-6.0`. Only the sprite's art-position calibration changed; runtime world position, animations, attack mechanics, shadows and UI are untouched. No local Godot test in this session. Next: user `git pull`, compare Knight foot contact in Bone Swarm and Grave Crossroads; adjust only Knight's offset further if warranted by screenshots. GitHub remains source of truth; all historical context below.

---

# LATEST LIVE CHECKPOINT — 2026-10-12 — Knight grounded like Ranger

After the per-role floor calibration hotfix, user screenshots showed Knight still a little lower than Ranger and suggested matching their settings. **Implemented on GitHub `main`:** `scripts/battle/unit.gd` has `ROLE_FLOOR_OFFSETS["knight"]` changed **−4 → −6 px**, matching Ranger (`−6 px`); change commit `61c3cc291c9a0197fdce065af7385871b1bb348e`. No other roles, animation rates, atlases, physical positions, renderer, battle rules or UI changed. Previous documented −4 for Knight is historical and superseded. The sole-origin helper is shared by all action/idle frames, so a single calibration value applies everywhere.

**Next user action:** `git pull` then check placement and fight in Bone Swarm / Grave Crossroads, compare Knight boots-to-ring alignment with Ranger. If Knight floats, revert/tune its own offset only; no arena/general scaling changes. Godot engine wasn't run in connector environment. Continuity docs updated; repo remains source of truth.

---

# LATEST LIVE CHECKPOINT — 2026-10-12 — Per-role floor offset fix in main

Following grounded Animation Pack 1 v2, the user provided **new gameplay screenshots** and confirmed animations are good except that feet still appear partly submerged in the battlefield. The previous assistant wrongly claimed it couldn't use GitHub; **this session successfully used connected GitHub tools and committed the fix**. Do not ask user to copy code or reconfirm GitHub access.

**Code:** `scripts/battle/unit.gd`, commit `53c998cd7cd8cd124a21e26d074b9a7d3a201695`. New `ROLE_FLOOR_OFFSETS` Dictionary: Knight -4, Ranger -6, male Mage -4, Skeleton -7, Bone Archer -7, Bone Thrall -6, Grave Bellkeeper -5, Crypt Guard -6, Bone Warden -6 (all px/local Y; negatives lift sprite). `_get_role_floor_offset()` provides the correction. `_art_rest_position()` adds it to the scale-aware base (v2 sole y=92.5 to ring y=36) or to original `ART_BASE_POSITION` if the role is static v4. `_ready()` always applies `_art_rest_position()`; static breathing now uses it, as does the static death tween. Animated idle and attack previously used the helper so automatically inherit it. No change to `SpriteFrames` library, anim files, physical origin, HP bars, unit movement, combat rules or background.

**Next LOCAL step:** `git pull`, launch Godot; check Bone Swarm / Cemetery Ambush in placement and after Fight, including the Skeleton/Bone Archer and static other undead variants. Confirm no hovering/sinking and that during Attack/Death feet don't snap to old Y. Godot cannot be launched from this GitHub connector session; if screenshots show one role still low, change just that entry (1–2px refinement). Do not implement animation Pack 2 before this visual gate unless user says so.

Continuity and decisions in `PROJECT_STATE`, `ROADMAP`, `DECISIONS`, `CHANGELOG`. Prior HANDOFF sections remain historical.

---

# LATEST LIVE CHECKPOINT — 2026-10-12 — Animation Pack 1 jitter / grounding hotfix

**GitHub is source of truth.** User reported (with screenshots of `Костяной рой` and `Засада на кладбище`) that new Unit Animation Pack 1 figures were jittery before combat and some appeared partly buried/dislocated. The problem was confirmed in the actual input assets: the 6×5 source sheet leaked detached previous-row **Knight legs** into the next Walk frames, and some skeleton frames had similar scraps. Initial idle 5fps and walk 9fps made the problem more obvious; the prior -16px origin put foot pixels below the game's +36px floor ring.

**Changes directly committed into `main`:**
- New **versioned** Base64/WebP assets: `assets/pixel/units/combat_units_anim_v2/{knight,ranger,mage,skeleton,bone_archer}.webp.b64`; original `combat_units_anim_v1` untouched for rollback. All 125 processed 96×96 cells (124 live character frames) have last solid sole pixel at y=92; detached top-row components were removed. Base64 sources were compared byte-for-byte with GitHub copies and all 5 atlases passed bbox/contact checks.
- `scripts/battle/unit_animation_library.gd`: runtime path switched to v2; Idle 2.7fps, Walk 7fps; Attack/Hit/Death unchanged, male mage skipped projectile-only frame unchanged.
- `scripts/battle/unit.gd`: new `_art_rest_position()` uses 96px cell, alpha sole center y=92.5, actual `base_sprite_scale.y`, world floor y=36. Applied at Ready, animated idle/hit and when attack tweens settle. Idle phases are staggered; walk/idle switching gains 180ms hysteresis.
- `docs/UNIT_ANIMATION_PACK1.md` has reproducible diagnosis and local smoke checklist.

**No Godot binary here.** User next actions: `git pull`, run Godot, inspect Bone Swarm and Graveyard Ambush **before combat** and after Fight; check Knight, male Mage, Skeleton/Bone Archer grounding, attack transitions and death. Also F6 `res://scenes/dev/unit_animation_pack1_preview.tscn`. If user reports remaining detached parts or clipping, inspect current GitHub code and clean specific frames, not a global movement/arena rewrite. No tactical/stat mechanics or scene layout changed.

---

# LATEST LIVE CHECKPOINT — 2026-10-12 — Unit Animation Pack 1 connected

The user asked to **connect the five newly generated pixel-art sprite sheets** following the earlier proposal and generation. GitHub writes have been made directly to `zampolit73/Misdeal` default branch.

**Active assets:** `assets/pixel/units/combat_units_anim_v1/knight.webp.b64`, `ranger.webp.b64`, `mage.webp.b64`, `skeleton.webp.b64`, `bone_archer.webp.b64`. Each decodes to a 576×480 transparent WebP atlas (6×5 grid, 96px cells) derived from conversation-provided/generated 1374×1145 source sheets. The male mage's projectile-only attack cell 4 is skipped in animated character frames. Source character artwork was not replaced for unsupported roles; approved static v4 retained as fallback.

**Code:** `scripts/battle/unit_animation_library.gd` constructs/caches `SpriteFrames` with 4 idle, 6 walk, 6 attack (Mage 5), 3 hit and 6 death frames at role-appropriate fps. `scripts/battle/unit.gd` uses SpriteFrames to swap `ArtSprite.texture` in its *existing Sprite2D* to protect animations/tweens/facing/outline and battle code; special one-shots for attack/hit/death, no rubbery fake idle for the animated roles. Rim sprite texture stays synchronized. Existing AI and immediate damage application still work; code does **not** change the combat hit timing. Others continue using v4 static art.

**Debug/test:** `scenes/dev/unit_animation_pack1_preview.tscn` F6, based on `scripts/dev/unit_animation_pack1_preview.gd`, draws all 5 using `AnimatedSprite2D` and offers IDLE/WALK/ATTACK/HIT/DEATH buttons; user should test F6 first, then run real Knight/Ranger/Mage fights against Skeleton/Bone Archer. See `docs/UNIT_ANIMATION_PACK1.md` for exact mapping and gate. No Godot runtime in this remote GitHub session; local verification pending.

**Next:** fix any parse/visual issues reported on screenshots before attempting Pack 2. Keep current arenas and Design System packages 1–3. Preserve source-of-truth GitHub docs; no manual copying required.

---

# LATEST LIVE CHECKPOINT — 2026-10-12 — Design System Package 3 core Screen Pass

The user requested immediate Package 3 after the previously committed Component Library, **even though the earlier F6 visual gate had not yet been reported as passed**. We proceeded conservatively, using connected GitHub and preserving every approved `.tscn` layout.

**Implemented:**
- `scripts/ui/misdeal_ui_kit.gd`: screen contrast/shadow helper `apply_screen_copy`, transparent splash hotspot font helper `apply_splash_hotspot`, `apply_offer_card_frame` containing the precise old table card StyleBox math (boss/marked/held priority), and `apply_battle_order_choice` highlighting only the actively toggled tactical order.
- `scripts/main.gd` / `scripts/intro/intro.gd`: apply text-only hotspot treatments, keeping backgrounds fully transparent and splash/intro art untouched.
- `scripts/class_select/class_select.gd` / `scripts/run_end/run_end.gd`: brighten small wizard/rule/summary/status copy via shared contrast without changing font size or geometry.
- `scripts/table/table.gd`: real offer-card frame moved to `MisdealUIKit`, source conditions remain `RunState` driven; top counts/stats text unified.
- `scripts/battle/battle.gd`: actual selected button highlights on the 3–5 tactical order toggles, with semantic colors; placement/instructions/metadata contrast only. No mechanics changes or battle-layout modifications.
- `docs/DESIGN_SYSTEM.md` Section 8: integration matrix and local smoke list.

**Unchanged:** table Variant C composition, v2 arena backgrounds, v4 units, male mage/facing, gameplay flow, placement geometry and game data. **No source .tscn layout was changed**; no global Theme/autoload or new font. Did not run Godot locally; user must `git pull` and test Main → Intro → ClassSelect → Table → Battle → RunEnd with click/hover/keyboard, all special card borders, 3–5 tactics, and legibility/clipping. Previous HANDOFF section on Package 2 remains history.

If errors are reported, first inspect live GitHub code; fix directly in repo. Keep next screen changes screenshot-driven rather than introducing new architecture.

---

# LATEST LIVE CHECKPOINT — 2026-10-12 — Design System Package 2 Components

User requested `пакет 2` after completing Foundation. Connected GitHub writes succeeded. Package 2 is **implemented in main but not yet run locally in Godot**.

Files:
- `scripts/ui/misdeal_ui_kit.gd`: added `apply_battle_panel` / `apply_battle_button`, `apply_selected_button`, `apply_tooltip_panel`, `make_tooltip`, `apply_card_surface`; all existing UI Kit APIs and tokens remain. Battle-specific styles are copied with the old numeric values intact.
- `scripts/battle/battle.gd`: replaced six panel and seven button calls with `MISDEAL_UI_KIT.apply_battle_panel` / `apply_battle_button`; deleted the two duplicated private style constructors. No combat changes.
- `scripts/ui/misdeal_tooltip_button.gd`: opt-in Button extending native `_make_custom_tooltip`. Existing game buttons still use their normal tooltip behavior.
- `scripts/dev/design_system_components_preview.gd` + `scenes/dev/design_system_components_preview.tscn`: isolated, interactive gallery for action/disabled/selected states, battle HUD style, card surfaces, status chip and hover tooltip. Not wired to Main/Table.
- `docs/DESIGN_SYSTEM.md` Section 7: component contract and manual smoke gate.

The approved table, art, v4 units and combat logic are unchanged. **LOCAL NEXT:** `git pull`, F6 `res://scenes/dev/design_system_components_preview.tscn`; inspect 1280×720 and hover/selection/tooltip. Test normal gameplay Main → Table → Battle including orders (3–5), cards and completion. If Godot flags a parse/runtime issue, inspect GitHub current code and fix there before proposing other work. Only after visual approval implement **Package 3 / Screen Pass**. Previous handoff's Package 1 comments are historical.

---

# LATEST LIVE CHECKPOINT — 2026-10-12 — Design System 1.0 Foundation

The user agreed to start the proposed compact Misdeal design system with **Package 1 / Foundation**. A GitHub inspection found an existing actively used `scripts/ui/misdeal_ui_kit.gd` and many authored style sizes in `.tscn`/battle scripts. To protect the approved art and vertical slice, **no current production screen has been restyled**.

Committed additions:
- `scripts/ui/misdeal_ui_kit.gd`: one canonical semantic palette (prior brand/class colors retained); spacing `SPACE_1/2/3/4/6/8`; typography `TYPE_MICRO/CAPTION/META/BODY/SECTION/TITLE/DISPLAY`; button heights, borders, viewport and advisory layer bands. Opt-in `apply_text_role` and `apply_button_minimum` helpers. Original UI Kit public methods remain compatible and use the same border weights.
- `docs/DESIGN_SYSTEM.md`: intent, exact usage, typography, contrast and visual constraints, no UI baked into arena art, Godot staging/review, package plan.
- `scripts/dev/design_system_foundation_preview.gd` + `scenes/dev/design_system_foundation_preview.tscn`: separate runnable 1280×720 visual specimen using **real Godot components** (9 palette swatches, bronze/steel panels, action buttons, text roles). Not reachable from main game, no extra dependencies.

**Next:** user `git pull`; open the preview scene, press **F6**; inspect Russian label readability and swatch layout, then check normal Main → Table → Battle still runs. Godot couldn't be launched here. Only after feedback start **Package 2 / Components**; review before changing HUD/card layouts. Current Male Mage, enemy flip, v4 characters and approved arenas remain untouched. Earlier HANDOFF descriptions remain historical.

---

# LATEST LIVE CHECKPOINT — 2026-10-12 — Male Mage + target-aware enemy facing

The user approved the second full 3×3 character roster specifically with a **male** Mage and reported that all new v4 undead appeared to fight with their backs to the heroes. The user instructed direct GitHub deployment. Implemented on `main`:

1. `assets/pixel/units/combat_units_v4/mage_male.webp.b64` = transparent 96×96 WebP male Mage (bearded purple wizard) taken from the latest approved concept. Lossless tile source `assets/source_archive/unit_art_v4/mage_male_tile.png.b64` is archived. Mage role is loaded separately in `scripts/battle/unit.gd`, with existing v4 atlas fallback. The other eight v4 roles remain unchanged.
2. `BattleUnit._ready` initializes enemy `ArtSprite.flip_h` to true (faces heroes on left). `_update_unit_facing` checks current target X during combat and flips the art when attacking/repositioning to the opposite side; `_sync_rim_visual` matches rim sprite flip. No code change to AI/target selection/combat metrics or arena presentation.

Important: Existing v4 atlas file itself is *not* overwritten (only Mage's runtime texture is overridden); do not assume the old atlas Mage cell is the active sprite. If the separate tile is absent/invalid, old Mage tile is used as fallback. Local verification in Godot remains required, especially Crypt Patrol, Iron Wall, Warden and target-side swaps. Previous messages saying GitHub write access was unavailable were incorrect: the connected GitHub tool has been used for real commits.

---

# LATEST LIVE CHECKPOINT — 2026-10-11 — Unit Art v4 now ACTIVE (nine sprites)

The user approved the full v4 character set and requested immediate integration, following several earlier unsuccessful attempts. **The actual v4 atlas is now committed to `main` and referenced by the battle runtime**, not merely a preview.

Files:
- `assets/pixel/units/combat_units_v4/atlas.webp.b64` — production 288×288 transparent RGBA WebP texture, encoded as text to match existing export-friendly asset packaging.
- `assets/source_archive/unit_art_v4/combat_units_v4_master.png.b64` — lossless 288×288 source sheet for retouch/rollback.
- `scripts/battle/unit.gd` — prioritizes v4 WebP, decodes via `Image.load_webp_from_buffer`, validates dimensions, caches one texture for all `BattleUnit` instances, and retains the previous v3 PNG parts as automatic fallback.

Atlas order: knight / ranger / mage; skeleton / bone_archer / grave_bellkeeper; bone_thrall / crypt_guard / bone_warden. Hero defaults were chosen from approved **Variant A** (blue silver knight, green hooded ranger, purple mage) and matching approved enemy silhouettes; art was downscaled/cut out for exactly the existing 96×96 slots. All combat roles sharing an existing `visual_role` (Bone Raider→Bone Thrall; Crypt Sentinel→Crypt Guard) still intentionally share artwork.

The gameplay, units' stats, AI, battle arena images, readable-floor changes, initial placements, HP HUD and tactical command logic are untouched. No local Godot run was available. The next task is **verify the nine sprites actually display at playtime**, evaluate transparent edges and 96px legibility, then fix *only concrete observed* cropping/art issues. Run `git pull`, Godot, Grave Crossfire/Iron Wall/Warden, capture screenshots and test dragging and a completed fight. Earlier handoff text claiming v4 is not integrated is superseded.

---

# LATEST LIVE CHECKPOINT — 2026-10-11 — Unit Readability Pass committed

The user found that figures visually disappeared into the approved rich v2 arena backgrounds in screenshots of Grave Crossfire and Gallows Volley, despite grounded unit positions and removal of always-on deployment grid. User requested immediate implementation directly in GitHub.

Implemented:
- `scripts/battle/unit.gd`: heroes at 1.28×, ordinary enemies 1.25× and bosses 1.24× base pixel-art scale (still multiply authored `visual_scale`); adjusted artwork anchor and HP/name offset; brighter cool/warm thin `RimSprite` contours; low-alpha localized dark underlay behind figures; preserved feet shadow, colored team ring and drag-only deployment glow; expanded hero click detection to cover visible art (no changed physical hitbox).
- `scripts/battle/battle.gd`: spread trio/duo initial `X` positions across the known legal tactical placement `Rect2` profiles instead of stacking heroes at `X=220` in Gallows/Crossfire. Also improved default, cave two-lanes, pocket/ossuary and Warden startup. This only affects hero initial staging; `_project_spawn_on_floor` still aligns the positions to the same walkable arena plane.
- Did **not** replace approved arena WebPs, alter enemy spawn resources, unit stats, tactical effects, combat AI, encounters, rewards, or card flow.

Static checks of the GitHub code and mathematical 1/2/3-hero spawn profile projection passed. **User local Godot playtest remains unverified.** To test: `git pull`, open Grave Crossfire and Gallows, inspect unit/enemy visibility plus labels and no overlap; drag a hero by upper torso, release, Fight. Also check boss and cave lanes. If visuals too harsh, tune these constants in `unit.gd` rather than changing background art.

---

# LATEST LIVE CHECKPOINT — 2026-10-11 — Deployment markers show only while dragging

Screenshots on Grave Crossfire and Crypt rejected the old **permanently visible pale bounding box and gold 3×2 slot circles**. The user explicitly asked for a code fix directly in GitHub.

Implemented on `main`: `scripts/battle/deployment_floor_markers.gd` now draws **nothing at rest** and only shows soft semi-transparent ellipses over actual legal deployment `Rect2` regions **while a hero is actively dragged**. `scripts/battle/unit.gd` additionally suppresses its secondary pre-battle placement ring until drag (the subtle contact shadow and team ring remain). No scene restructuring, artwork replacement, encounter logic, combat rules, spawn coordinates or HUD/tactics changes were made in this pass.

The earlier "always-on chalk circles" descriptions in this document are historical; this latest section supersedes that visualization. All twelve arenas use the same dynamic behavior. Godot local gameplay verification remains outstanding. User action: `git pull`, open Crypt or Grave Crossfire, observe idle -> drag -> release -> Fight; include two-pocket and two-lane encounter tests.

---

# LATEST LIVE CHECKPOINT — 2026-10-11 — Grounded battle floor and dynamic deployment markers

The user approved v2 arena pack 1 but screenshots from Bone Swarm / Last Bell / Iron Wall showed floating figures and no readable player placement zone. Code correction has now been committed in `scripts/battle/battle.gd`, `scripts/battle/unit.gd`, and NEW `scripts/battle/deployment_floor_markers.gd`: authored enemy/hero spawns are mapped from old high-background Y into a walkable floor band, combat movement clamps share that floor band, party placement regions are lowered and drawn using actual legal regions, dragged heroes snap to the real legal area, and contact shadows sit at the miniature soles. Split-band/pocket/front-line encounter distinctions are retained. The overlay hides on Fight and doesn't change enemy AI, tactics, rewards, or stat definitions. It works across all 12 IDs, while the 10 approved arena_redraw_v2 WebPs remain the active image assets and the 2 pack-2 arenas still use the v1 images.

**Do not assume the newly generated in-chat pictures with baked white circles were committed**. Instead the current code renders the placement markings dynamically from legal regions to prevent artwork drifting from gameplay. The existing 10 approved WebPs remain unchanged. Key constants, spawn projection and regions are now in `battle.gd`.

Next local check: `git pull`; run Godot 4.7.x, test Bone Swarm, Last Bell and Iron Wall (screenshots), then Gallows and Warden; verify all starts place units on stone, dragging respects bright chalk areas (including two pockets/bands), bars and labels remain legible, and the markings vanish when Fight begins. Godot could not be run here. Report the first failing arena/hero count if offsets need adjustment.

---

# LATEST LIVE CHECKPOINT — 2026-10-11 — Approved arena package 1 now integrated

The user approved the corrected arena art and explicitly requested live GitHub deployment. The TEN production WebPs under `assets/pixel/battle/arenas/arena_redraw_v2/` are now the active resources for `gallows`, `crypt`, `graveyard`, `ossuary`, `warden`, `bone_crush`, `bone_swarm`, `grave_crossfire`, `iron_wall`, and `last_bell`. Godot `scripts/battle/authored_backdrop.gd` loads these ten as raw WebP bytes, while `firing_square` and `bone_ritual` remain on v1 `.webp.b64` until art package 2.

The previously stated 'review only / not integrated' checkpoint below is historical and superseded. Future sessions must **not** repeat the mistaken claim that GitHub write access is unavailable; this session successfully created and committed GitHub binary blobs through the connected GitHub tools.

Important: no gameplay, spawn, battle controller, tactics or UI changes. Old v1 assets and old v4/v6/Combat Expansion art are retained. New visual rule: one major believable landmark per arena, no duplicated castle cities, readable unoccluded combat floor.

NEXT: after `git pull`, validate the ten backdrops in Godot, especially Bone Swarm and Warden, unit contrast and deployment/floor alignment; then design and approve package 2 (`firing_square`, `bone_ritual`). Full manifest is in `docs/ARENA_REVIEW_2026_10_11.md`. The original PNG masters are in the conversation attachment ZIP; committed 1280×720 WebPs are in the repo and directly recoverable.

---

# LATEST VISUAL CHECKPOINT — 2026-10-11: package-1 arena redraw for review only

Ten corrected battle-arena images plus one Bone Swarm alternative were generated after the user rejected castle-saturated backgrounds. They are NOT yet approved or wired into Godot. See `docs/ARENA_REVIEW_2026_10_11.md` for the full arena-by-arena manifest, rationale, attachment names, and next steps. The images are in the conversation's ZIP attachment, **not** yet in GitHub. Keep the live `arena_redraw_v1` assets untouched until the user approves the new concepts.

---

# ART DIRECTION CORRECTION — 2026-10-11 (latest feedback)

The user rejected the OpenArt arena exploration. Do NOT continue the pastoral/low-color indie pixel art experiments or use their generated variants as reference. The later nine-panel environment collage is also NOT an approved Misdeal battle style. Do NOT commit or wire any of those concept images into runtime.

The user clarified that the existing/older Misdeal illustrations (especially those not replaced during the recent 12-arena unified redraw) are already good and should be IMPROVED, not reinvented. Directly inspected the original GitHub assets as reference:
- `assets/pixel/battle/arenas/visual_pass_v4/gallows.webp` — strongest composition reference; moonlit Gothic skyline, restrained torches, wide stone arena and etched battle floor, serious dark-fantasy tonal language.
- `assets/pixel/battle/arenas/visual_pass_v4/crypt.webp` — grounded stone hall and ritual circle.
- `assets/pixel/battle/arenas/visual_pass_v6/graveyard.webp`, `warden.webp`, `ossuary.webp`, `bone_crush.webp` — accepted pre-unified art, accurate dark stone/red banner/teal moonlight/amber fire look.
- `assets/pixel/battle/arenas/combat_expansion_v1/*.webp` — original six dedicated arenas that preserve encounter-specific landmarks and are recoverable.
- `assets/pixel/table/approved_variant_c/table_exact.webp` and `assets/pixel/main/approved_splash_hd/main_splash.webp` — overall game's actual artistic language, **not** a 24-color minimalist mock-pixel-art style.

Aim for *source-based, reference-faithful art improvement* on one arena first: preserve dark painted/pixel-gothic mood, deep blue-black midtones, rusty crimson fabrics, warm candlelight, recognisable silhouette, broad unoccupied stone floor with ritual markings and live Godot gameplay UI; improve unique environmental storytelling, material handling, focal hierarchy and reduce visually repeated generated clutter, but no wholesale redesign. The recently active unified `arena_redraw_v1` remains deployed until user explicitly approves a new replacement. Keep gameplay and encounter mappings untouched during concept approval.

OpenArt generation in this session used the remaining 40 Free credits, and `openart_account_get` reported 0 remaining afterward; do not pretend further OpenArt generation happened. The previous batch was rejected. When generation is available, use image-to-image with the actual canonical GitHub source as visual reference, rather than text-to-image from a detached prompt. Make 1–2 specific comparison variants and request approval before integration.

---

# SESSION CLOSEOUT — 2026-10-11 — START THE NEXT CHAT HERE

This is the authoritative continuation point for the next Misdeal chat.

## What just happened

The user rejected the battle presentation twice:
1. the original battle screen felt low-quality, cramped and left no convincing room for tactics;
2. the first fix solved capacity but turned the screen into large black slabs and was also rejected.

The current battle HUD therefore uses the later modular-islands version:
- compact encounter plate at upper left;
- compact run-status plate at upper right;
- separate tactics island;
- separate Fight/target island;
- optional Wizard-condition island only when needed;
- 3–5 tactical orders distribute dynamically, with **НЕПОВИНОВЕНИЕ** kept readable.

After that, the user asked to improve **all arenas**. A complete unified redraw is now live for all twelve active arena IDs.

## Canonical arena state

Runtime directory:
`assets/pixel/battle/arenas/arena_redraw_v1/`

Active IDs:
`crypt`, `graveyard`, `gallows`, `ossuary`, `warden`, `bone_crush`,
`bone_swarm`, `grave_crossfire`, `iron_wall`, `last_bell`, `firing_square`, `bone_ritual`.

Important implementation detail:
- the committed runtime files are `*.webp.b64` payloads;
- `scripts/battle/authored_backdrop.gd` reads the text payload, base64-decodes it, then loads the WebP bytes into an `ImageTexture`;
- each decoded image is native 1280×720;
- this storage form is intentional for the current GitHub tool path and is already wired live.

Art direction of this set:
- broad quiet playable floor;
- high-frequency props pushed to edges/background;
- stronger large landmark silhouettes per encounter;
- warm stone/fire/red-cloth language, with colder moonlit separation where appropriate;
- no baked units or gameplay UI.

## Safety / do not regress

The project previously had a severe empty-arena regression during broad battle-animation work. The stable spawn/controller path was restored and locally confirmed working.

Do not casually rewrite attack timing, spawning, target acquisition or the battle controller while validating the new arena art. Current arena/HUD work is presentation-first.

## Next action

After `git pull`, locally open several fights — especially:
- **КОСТЯНОЙ РОЙ**
- **МОГИЛЬНЫЙ ПЕРЕКРЁСТОК**
- **РАССТРЕЛЬНАЯ ПЛОЩАДЬ**
- **КОСТЯНОЙ РИТУАЛ**
- **КОСТЯНОЙ НАДЗИРАТЕЛЬ**

Check only:
1. correct arena is loaded;
2. heroes/enemies remain readable;
3. placement still matches the visible floor;
4. units do not collide visually with the modular HUD;
5. Bone Warden still feels like the finale.

If screenshots show a concrete floor/deployment mismatch, fix that specific arena/profile. Do not redesign combat rules from visual feedback alone.

## Relevant commits immediately before this checkpoint

- `64ca6043699201df280ace773a850f68486b7dd9` — changelog for full arena redraw pass.
- `9f45d907edd4ef8973528406620df2d1c4c7c11e` — registered unified arena redraw assets.
- `77ecec67674887abb01e310701236dadf66694fa` — full arena redraw checkpoint.
- `490a54bf0d2f76f725aed43eb64d6ac7047b2c69` — modular battle HUD replacing rejected full-width slabs.

Everything needed to continue is in GitHub; do not ask the user to re-explain this session.

---

# CURRENT SESSION CHECKPOINT — All 12 battle arenas redrawn and live

Date: 2026-10-11

The user asked to improve every battle arena after the previous environments read as noisy/muddy behind small combat units. A complete replacement set is now committed and wired live.

Canonical runtime directory:
- `assets/pixel/battle/arenas/arena_redraw_v1/`

Covered arena IDs:
- `crypt`, `graveyard`, `gallows`, `ossuary`, `warden`, `bone_crush`;
- `bone_swarm`, `grave_crossfire`, `iron_wall`, `last_bell`, `firing_square`, `bone_ritual`.

`scripts/battle/authored_backdrop.gd` maps every active arena ID to this directory. Earlier v4/v6 and Combat Expansion arena plates remain recoverable but are no longer the live sources.

Art goal: larger environmental shapes, cleaner central floor, stronger encounter-to-encounter silhouettes and less fine detail competing with the units.

No spawn/controller/attack/tactical/balance code changed.

Immediate local check after `git pull`:
1. open several different fights, including an expansion encounter;
2. confirm the backdrop changes correctly with the encounter;
3. confirm heroes/enemies remain readable against the center floor;
4. drag heroes through the legal placement area and note any place where the visible floor disagrees with the gameplay bounds;
5. check Bone Warden separately as the finale.

---

# CURRENT SESSION CHECKPOINT — Modular battle HUD after local rejection

Date: 2026-10-11

The previous 170 px full-width battle footer was rejected locally as too blocky and visually cheap. It has been superseded by a modular HUD pass.

Live preparation layout now uses:
- compact left encounter plate + compact right run-status plate instead of one top slab;
- left tactical island, center Fight/target island and optional right Wizard-condition island instead of one bottom slab;
- dynamic tactic widths: 3 orders fill the panel, 4/5 orders redistribute the same width, full **НЕПОВИНОВЕНИЕ** remains readable;
- lighter battle-specific panel/button chrome;
- arena art remains visible around the UI instead of being covered by black rectangles.

Safety invariant remains unchanged: presentation only; no spawn/combat timing/targeting/tactical values were touched.

Local check after `git pull`: open the same **КОСТЯНОЙ РОЙ** preparation screen and compare the silhouette of the HUD first. Then test a 4/5-tactic state if available.

---

# CURRENT SESSION CHECKPOINT — Battle HUD/readability rework

Date: 2026-10-11

The latest local feedback rejected the battle screen presentation: the footer was too cramped, special tactics had no real room, and the overall battle UI read as low-quality.

A layout/readability pass is now implemented:
- battle footer expanded upward to 170 px;
- five fixed tactical slots with full **НЕПОВИНОВЕНИЕ** label;
- wide order-description area;
- separate target-preview and Fight column;
- side-objective panel moved into the right footer column;
- top encounter/status text placed on a framed plate;
- playable combat bounds moved above the footer;
- pixel-art fallback resize changed from Lanczos to nearest-neighbor.

Important safety note: no attack timing, spawn lifecycle, targeting rules, tactical effects, reward flow or encounter stats were changed. The earlier empty-arena regression guard still applies.

Immediate local check after `git pull`:
1. open a fight with only the normal three orders;
2. open a fight where **ЖЕРТВА** or **НЕПОВИНОВЕНИЕ** is available;
3. confirm all available tactics fit without abbreviations or overlap;
4. drag all heroes around the legal deployment area and confirm nobody can end up under the footer;
5. press **БОЙ** and verify units remain visible and fight normally;
6. send one screenshot if the arena art itself still looks muddy — that would require a separate native-HD asset redraw, not another UI squeeze.

---

# CURRENT SESSION CHECKPOINT — Combat Expansion art integrated

Date: 2026-10-11

This is the current continuation point for the next chat.

The user reported that Act 1 runs felt repetitive, so Combat Expansion v1 was added first, then the six new fights received approved dedicated visual concepts and those visuals were integrated into GitHub.

Current live expansion fights:
- `bone_swarm` — КОСТЯНОЙ РОЙ;
- `grave_crossfire` — МОГИЛЬНЫЙ ПЕРЕКРЁСТОК;
- `iron_wall` — ЖЕЛЕЗНАЯ СТЕНА;
- `last_bell` — ПОСЛЕДНИЙ ЗВОН;
- `firing_square` — РАССТРЕЛЬНАЯ ПЛОЩАДЬ;
- `bone_ritual` — КОСТЯНОЙ РИТУАЛ.

Dedicated production exports are already live:
- arenas: `assets/pixel/battle/arenas/combat_expansion_v1/*.webp` at 1280×720;
- table cards: `assets/pixel/ui/combat_expansion_v1/cards/*_card.webp` at 448×274;
- `scripts/battle/authored_backdrop.gd` routes each expansion `arena_id` to its own authored backdrop;
- `scripts/ui/card_art_catalog.gd` loads dedicated card art instead of the temporary semantic aliases;
- every new EncounterData now owns a matching dedicated `arena_id`.

The original approved generated composite concepts are archived under `assets/source_archive/combat_expansion_v1/*_composite_master.webp` so future recrops/exports do not require regenerating the scenes.

Important current gameplay state:
- the six new cards are in the real Act 1 random tier pools, two per tier;
- the act remains twelve resolved pre-boss cards;
- Bone Raider and Crypt Sentinel still intentionally reuse the Bone Thrall / Crypt Guard unit silhouettes. Their mechanics should be validated before commissioning dedicated unit art;
- battle spawning had a severe empty-arena regression earlier in the motion work. The stable battle core was restored and locally confirmed working. Do not reintroduce broad async attack/controller animation patches;
- current battle polish is isolated visual-only feedback (tactical tells, Sacrifice/Defiance state FX, hit readability).

Immediate next local action after `git pull`:
1. start a fresh run so the expanded random pool is rebuilt;
2. confirm the six new table cards show their new dedicated art rather than old aliases;
3. enter any new fight that appears and confirm the matching new arena backdrop loads, heroes/enemies still spawn, and deployment remains usable;
4. note which new encounters are fun/redundant/overtuned before adding more fights or creating dedicated Raider/Sentinel art.

Do not redesign the approved six arena/card concepts unless the user asks. They were explicitly approved and should now be treated as the visual source of truth for Combat Expansion v1.

---

### Combat Expansion v1 dedicated arenas/cards are live

All six new fights now have dedicated approved production art:
- `bone_swarm`;
- `grave_crossfire`;
- `iron_wall`;
- `last_bell`;
- `firing_square`;
- `bone_ritual`.

Implementation:
- native 1280×720 WebP backdrops: `assets/pixel/battle/arenas/combat_expansion_v1/`;
- dedicated 448×274 card art: `assets/pixel/ui/combat_expansion_v1/cards/`;
- encounter `.tres` files now use unique arena IDs;
- `scripts/battle/authored_backdrop.gd` selects exact expansion backdrops;
- `scripts/ui/card_art_catalog.gd` runtime-decodes exact expansion cards; the temporary alias map is removed;
- `battle_visual.gd` / `unit.gd` keep the closest validated atmosphere/tint families.

The only intentional visual reuse left in Combat Expansion v1 is enemy-unit silhouettes: Bone Raider still uses the Bone Thrall family, Crypt Sentinel the Crypt Guard family, pending gameplay validation.

Local check after pull:
1. start a fresh run;
2. inspect all six new cards when they appear — each must have unique art;
3. enter each new fight — each must show its matching unique arena;
4. verify heroes/enemies still render and remain on the floor;
5. report any arena whose playable floor visually disagrees with its current deployment bounds.

### Combat Expansion v1 is live

Six new combat cards are in the Act 1 random pool:
- tier 0: `bone_swarm`, `grave_crossfire`;
- tier 1: `iron_wall`, `last_bell`;
- tier 2: `firing_square`, `bone_ritual`.

New UnitData:
- `resources/units/bone_raider.tres` — fast fragile pressure, currently reuses `bone_thrall` visual_role;
- `resources/units/crypt_sentinel.tres` — lighter AOE guard, currently reuses `crypt_guard` visual_role.

New cards use semantic temporary art aliases in `scripts/ui/card_art_catalog.gd`:
- Bone Swarm → Bone Crush;
- Grave Crossfire → Graveyard Ambush;
- Iron Wall → Crypt Guard;
- Last Bell → Grave Bell;
- Firing Square → Gallows Volley;
- Bone Ritual → Ossuary Gate.

This is intentional gameplay-first reuse under D104. Do not generate a broad replacement art batch until run testing identifies the encounters worth keeping.

Local validation target:
1. start fresh runs so the expanded `ACT1_CARD_IDS` pool is rebuilt;
2. confirm new combat cards can appear in their intended tier;
3. check no card art is blank;
4. verify heroes/enemies spawn normally in each new fight;
5. pay special attention to Iron Wall / Last Bell / Firing Square / Bone Ritual difficulty in solo and duo;
6. report which fights actually feel different — redundant fights should be cut or redesigned before art investment.

### Safe combat-feedback pass is live

The user confirmed the restored battle core works again. New combat polish is intentionally isolated:

- `scripts/battle/battle_motion_fx.gd` is a visual-only overlay added to `battle.tscn`;
- it listens to tactical-order/Fight buttons directly and never calls spawn/controller/RunState logic;
- normal orders show short squad markers; Sacrifice/Defiance gain restrained persistent red/blue auras after Fight; Death Wager has a subtle red frame tell;
- `scripts/battle/unit.gd` only changes existing feedback functions: source-aware hit tint, stronger large-hit kick/number/sparks, slightly clearer ranged/magic tracers;
- `scripts/battle/battle.gd` is unchanged.

Regression guard:
- do not reintroduce async attack windup or broad battle-controller animation patches;
- do not move tactical FX into spawn/configure code;
- if anything disappears in battle, first disable/remove `BattleMotionFx` and compare `unit.gd` feedback-only changes before touching controller logic.

Local checks:
1. open a normal combat and confirm all heroes/enemies are present before Fight;
2. switch НАТИСК / ОХОТА / СТРОЙ and confirm only short markers appear;
3. when available, test ЖЕРТВА and НЕПОВИНОВЕНИЕ for restrained red/blue auras;
4. inspect melee/ranged/magic hits and one large hit;
5. open Death Wager and confirm the red frame is subtle.

### Event motion is partially restored, entry-only

Generic Act Choice and Whispering Well now have a safe entry-only choice-card stagger.

Important guardrails:
- no `button_down` commitment callbacks;
- no result-delay changes;
- no active-card initialization changes;
- no choice-art loader/source changes;
- no battle files touched.

The earlier broken wholesale event-motion patch must not be restored. Next local check is simple: open several generic events and Whispering Well, confirm all real text/art is present first, then verify the cards settle in without blank/template states.

### Motion Pass 5 — safe non-battle screens

While battle spawning is being protected after the empty-arena regression, motion work continued only on isolated UI controllers:
- `scripts/class_select/class_select.gd`: staggered three-card entry + chosen-card commit;
- `scripts/intro/intro.gd`: one-shot frame settle + initial hint/skip reveal;
- `scripts/table/squad_status.gd`: overlay open/close + role-switch focus.

No battle file was modified in this pass.

Local checks:
1. Main → Intro: click through all five frames and confirm there is no input delay/double advance;
2. Class Select: hover and choose each role once; selected card should focus before table transition;
3. Table → Squad [TAB]: switch 1/2/3 several times and close with TAB/Escape; portrait/stats must stay correct.

### Empty battle arena — full controller rollback applied

The first rollback of only `unit.gd` did not fix the user's local empty preparation arena. `scripts/battle/battle.gd` has now also been restored to the known-good pre-animation baseline `aa8f9d5ed05134b4a3507995c22d845191c237b7`.

This intentionally removes the recent battle tactical/result/Last Deal motion together with attack/death motion. Do not try to preserve those animation additions until local battle spawning is confirmed again. The next required check is simply: open Bone Patrol and confirm heroes + enemies render before pressing **БОЙ**.

### Battle units missing regression — hotfixed

The battle preparation screen was reported with zero visible heroes/enemies. `scripts/battle/unit.gd` has been restored to the known-good pre-Motion-Pass-2 version from commit `ddae81ca7e385cfc77767c7a5fbd190f001a624c`.

Keep the newer `battle.gd` tactical/result/Last Deal motion, but do not restore the prior async attack-windup/death-settle patch in `unit.gd` wholesale. First local check after pull must be that heroes and enemies render in preparation and can be dragged before battle.

### Motion Pass 4 — table ambience and outer shell is live

Key implementation:
- `scripts/table/table_spread_visual.gd` owns subtle candle halos and the event-driven ritual-circle reaction overlay. It does not replace/redraw the Variant C art.
- `pulse_deal()` reacts the deck and ritual area; `pulse_ritual(kind)` is called from existing deal/Hold/choice/Wizard state changes in `scripts/table/table.gd`.
- `scripts/core/scene_transition.gd` keeps the existing safe blackout swap, but chooses a very dark veil tint by destination path.
- `scripts/main.gd` has a one-shot entrance + Start commit.
- `scripts/run_end/run_end.gd` has a one-shot hierarchy reveal + New Run commit.

Do not increase candle halo opacity aggressively: the current overlay is meant to make authored flames feel alive, not draw new glowing blobs over the plate.
Do not convert ritual reactions into a permanent rotating/pulsing HUD circle.
Do not lengthen scene-transition timing; the tint is the polish, the fast swap is still the product requirement.

Local checks after pull:
1. stay on the table for several seconds and confirm candle flicker is barely perceptible rather than distracting;
2. deal, Hold, choose a card, accept/refuse a wager and trigger meddling if available — center-table reactions should be momentary;
3. traverse table → event/battle → reward/table and confirm transitions remain fast/dark;
4. view Main Menu and Run End once and confirm entry motion does not delay input materially.

### Motion Pass 3 — battle commands/results is live

Runtime changes are concentrated in `scripts/battle/battle.gd`:
- tactical order selection calls `_play_tactical_order_feedback()`;
- **БОЙ** awaits `_play_fight_commit_feedback()` before hiding deployment UI;
- side-objective success/failure calls `_play_side_objective_feedback()`;
- `_finish_battle()` defers `_animate_result_overlay(player_won)` after all result text/button visibility is configured;
- Last Deal gets one follow-up emphasis via `_pulse_last_deal_after_reveal()`;
- continue / Last Deal accept / Last Deal refuse await a tiny `_animate_result_choice_commit()` before navigation.

Do not add continuous result-panel breathing or repeated Last Deal pulsing. The current direction is a single clear reveal/commit sequence.

Local verification after pull:
1. switch between several tactical orders during deployment;
2. press **БОЙ** and confirm the short press beat does not feel laggy;
3. trigger a side-objective failure/success if convenient;
4. win a battle and take the reward;
5. lose a battle and inspect Last Deal, then test accept/refuse when possible.

### Motion Pass 2 is implemented — battle / Fate Spread / Wizard reactions

Current motion state:
- `scripts/battle/unit.gd`: attack impact is preceded by a tiny role-specific windup (melee ~0.08 s, ranged ~0.11 s, magic ~0.14 s). Cooldown is set before the windup, so do not additionally increase `attack_interval` to "compensate" — the presentation pass is not intended as a balance change.
- death feedback now staggers briefly before settle/fade.
- `scripts/battle/battle.gd`: Bone Warden Phase II pulses arena/backdrop color briefly; no generic camera shake.
- `scripts/table/fate_spread_overlay.gd`: visible ring cards stagger in, current position gets a focus beat, 4/8/12 milestone cards/counts/seal are emphasized. Do not move/redesign the frozen approved Fate Spread geometry.
- `scripts/table/table.gd`: Wizard wager/meddling/marked-card moments call `_pulse_wizard_reaction()`, which only tints the authored full-screen backdrop briefly. The Wizard painting itself remains static.

Animation regression guard:
- do **not** restore the previous wholesale `act_choice.gd` `button_down`/commit patch; it caused the raw template screen to appear.
- do **not** restore the previous Whispering Well commitment patch wholesale; it coincided with missing mini-art.
- Table Hold/discard and Reward motion remain active and locally accepted enough to continue from.

Immediate local checks after pull:
1. one melee-heavy battle and one ranged/magic battle;
2. a unit death on each side;
3. Bone Warden crossing 50% HP;
4. open Fate Spread at an ordinary point and at a 4/8/12 milestone if convenient;
5. trigger Wizard wager or meddling and confirm the backdrop tint is subtle, not a full-screen flash.

### Whispering Well choice art is restored

After the motion pass, the dedicated Well screen could render without its three choice images. `scripts/event/whispering_well.gd` is back on the stable pre-motion controller, and `get_whispering_well_texture()` uses the approved split-sheet source. Do not reapply the removed Well commitment-motion patch wholesale.

### Act Choice motion regression was rolled back

After Motion Pass 1, the generic Act Choice screen could show raw template placeholders instead of the selected event. The event-motion changes in `scripts/event/act_choice.gd` were rolled back to the known-good semantic-art state. Do not reapply the previous `button_down`/stagger commit patch wholesale. Table and Reward motion from the same pass remain enabled and should be tested independently.

### Motion language pass 1 is implemented

Table + Events + Rewards now share a more physical motion language.

Important runtime points:
- `scripts/table/table.gd`: Fate Hold has a card-to-hold stamp animation; card selection moves the chosen card toward the player and rejected cards toward discard.
- `scripts/table/table_spread_visual.gd`: discard stack has an explicit `pulse_discard()` impact reaction.
- Discard UI state is deliberately refreshed during the rejection travel near impact, not immediately when `RunState.choose_card()` succeeds.
- `scripts/event/act_choice.gd`: choice cards stage in and `button_down` starts commitment feedback before the resolver's `pressed` callback; result reveal is delayed slightly when that beat exists.
- `scripts/event/whispering_well.gd`: same committed-choice language on the dedicated Well screen.
- `scripts/reward/reward.gd`: staged card entrance plus an awaited ~0.18 s selected-reward focal beat; `_reset_buttons()` restores transforms/modulate so multi-stage rewards remain safe.

Do not turn this into floating/pulsing-everything UI. The accepted motion direction is object weight and short physical cause/effect.

Next suggested package is battle anticipation/death motion + Fate Spread ritual motion + restrained Wizard ambience.

### Broad Act 1 semantic mini-art pass complete for the main duplicate cases

Current runtime no longer relies on three copies of the event thumbnail for the main remaining duplicate-choice screens.

Now explicitly mapped in `scripts/event/act_choice.gd`:
- Lost Purse;
- Debtor Bones;
- Wizard Tithe;
- Blood Ledger;
- Bone Tax;
- Ash Rest recruitment;
- Last Camp recruitment;
- both Rattling Bridge states;
- Chained Prisoner states;
- Black Altar recruitment.

`scripts/ui/approved_event_choice_art.gd` exposes a small reusable semantic action library from already-approved assets: `rescue`, `bag`, `leave`, `whisper`, `coins`, `occult_card`, `chains`, `loot_body`, `blood`, `cursed_relic`.

Native 384×160 sources are preferred whenever available. Do not regress these screens to the generic event-image fallback just to make implementation simpler.

Remaining screenshot-driven exceptions should be handled individually. Faceless Card still has event-art fallback on choices without a truthful existing semantic image; shops/development cards already use the actual offered upgrade art and are not duplicate-thumbnail problems.

### Rattling Bridge mini-art wiring fix

The already-authored native bridge trio in `assets/pixel/event/choice/rattling_bridge_hd/` is now used for **both** Rattling Bridge states. The regular `rush / scavenge / careful` branch previously fell through to the generic event thumbnail, causing three duplicate bridge images. `act_choice.gd` now routes every `rattling_bridge` choice screen through `ApprovedEventChoiceArt.get_rattling_bridge_texture(index)`, and the loader uses the original 384×160 cells directly for quality.

### Approved event-choice mini-art sheet is canonical

The user approved the five-event mini-choice mockup as the visual target. Production now uses the cropped action-first illustrations from that sheet rather than duplicating the large event image or using schematic placeholders.

Canonical runtime source:
- `assets/pixel/event/choice/approved_choice_sheet_v2/part_00.txt`;
- `part_01a.txt`, `part_01b.txt`, `part_01c.txt`;
- `part_02.txt`, `part_03.txt`, `part_04.txt`;
- decoded by `scripts/ui/approved_event_choice_art.gd` into a 576×320 WebP sheet;
- each cell is 192×80 and intentionally displayed with nearest filtering.

Mapped states:
- Rattling Bridge recruitment;
- Whispering Well;
- Chained Prisoner recruitment;
- Black Altar recruitment.

Chained Prisoner's post-recruitment branch keeps the older dedicated semantic atlas. Curse Forge keeps the real artifact thumbnails, because its live options are three specific relics and those assets are more truthful than the concept-sheet generic forge actions.

Next visual targets are the remaining true duplicate-event-thumbnail cases: Lost Purse, Debtor Bones, Wizard Tithe, Ash Rest recruitment and Last Camp recruitment.

### Semantic choice-art continuation

After the approved Rattling Bridge trio, `black_altar` recruitment also received dedicated semantic mini-art. Runtime path:
- `assets/pixel/event/choice/black_altar_recruitment.svg`
- `ApprovedEventChoiceArt.get_black_altar_texture(index)`
- `act_choice.gd` applies it only while the Mage can still be recruited.

Do not redo Whispering Well / Chained Prisoner / Curse Forge: they already have semantically distinct choice imagery (dedicated atlas cells or actual artifact art). The next real duplicate-thumbnail targets are Lost Purse, Debtor Bones and Wizard Tithe, followed by the recruitment branches of Ash Rest and Last Camp.

### Semantic event-choice art benchmark

The next visual pass is now defined as: **context art describes the event; mini choice art describes the decision**. Do not keep reusing the same event illustration across all lower choice cards.

The first implementation is `rattling_bridge`:
- the rejected schematic SVG prototype has been removed;
- approved ranger-recruitment art lives in `assets/pixel/event/choice/rattling_bridge_hd/part_00.txt` + `part_01.txt`;
- loader/cell mapping: `scripts/ui/approved_event_choice_art.gd`;
- runtime selection: `scripts/event/act_choice.gd`;
- approved trio: rescue / bag / leave alone;
- the already-resolved branch still uses the generic fallback until its own dedicated trio is approved.

The art language is intentionally object/action-first and low-detail to reduce AI-like repetition. After local approval, continue the same language across the remaining event choice cards instead of regenerating whole event scenes.

## Continuation checkpoint — 2026-10-09 — screenshot cleanup committed — continue from here

This is the authoritative handoff for the next Project chat. GitHub is the source of truth for implemented code/state.

### Physical card-back solution is now canonical

After local screenshots showed that dark cleanup masks kept reading as holes, the user chose the physical-card solution.

`assets/pixel/table/card_back_runtime.svg` is now the shared neutral card back. On the normal Wizard table, two backs permanently occupy the baked offer positions beneath live cards, so a single centered live card reveals believable face-down cards rather than the baked sample events. The temporary cleanup panels and their table.gd visibility logic are gone.

In Fate Spread, empty Hold shows the same back with no dark title strip. Wizard Discard is completely absent when empty; when populated, its live top card sits on a card-back frame and is transformed to follow the authored painted stack.

Next local verification: one two-card deal, one single-card/retry state, empty Hold, populated Hold, empty discard and 2+ rejected-card discard. Only pixel alignment should remain.

### Latest refinement after local screenshots

The first cleanup attempt was rejected locally: the giant dark oval under the offers looked like a hole, and the Wizard-discard card in Fate Spread still floated off-angle.

Current `main` replaces that with two compact cloth-toned side cleanup patches that are visible only for single-card offers; two-card offers have no extra cleanup surface. The Fate Spread discard live-card layer is now 90% scale, lower, and rotated to the painted stack angle.

Next local check: pull `main`, inspect one normal two-card offer, one single-card/retry offer, and the Fate Spread discard with 2+ rejected cards. If anything remains, only small pixel offsets should be adjusted.

### Latest screenshot-driven fixes

The first local screenshot of the exact Variant C normal table exposed the baked sample offer cards when only one live card was present. `scenes/table/table.tscn` now has a restrained rounded dark cleanup layer directly beneath the live offers, covering that baked sample-card area without changing the approved table art direction.

The Fate Spread screenshot also exposed the Wizard-discard live card as axis-aligned over an angled painted stack, which made the dark backing visible. `scenes/table/fate_spread_overlay.tscn` now groups that live card/mask/title in a shared `CardLayer`, shifted and rotated to follow the physical stack; `scripts/table/fate_spread_overlay.gd` points at the new paths.

These are visual-only fixes. No gameplay, Fate Spread ring geometry or discard rules changed. Next step: `git pull`, verify both screenshots at 1280×720, then only nudge pixels if needed.

### What is visually locked

**Fate Spread / `РАСКЛАД СУДЬБЫ` is frozen.** The user explicitly accepted the current physical-table composition after several screenshot passes. Do not redesign it unless a concrete bug/leak appears.

Canonical Fate Spread files:
- `scenes/table/fate_spread_overlay.tscn`
- `scripts/table/fate_spread_overlay.gd`
- `scripts/table/fate_spread_reference_cleanup.gd`
- `assets/pixel/table/fate_spread/fate_spread_exact.webp`
- `assets/source_archive/fate_spread/fate_spread_exact_master.webp`

Important Fate Spread rules:
- I–XII/history/counts/Hold/Discard remain live run state.
- The approved sealed XIII skull/chain card is shown directly until the boss activates.
- Generic future card backs from the plate may remain visible when they truthfully represent future state.
- Live masks replace only baked run-specific/sample state.
- History hover is a compact cursor-adjacent tooltip.
- Do not move the ring, XIII, side holders or header without a concrete screenshot defect.

### Latest approved normal Wizard table

The user then approved a **cleaned-up Variant C** normal-table composition and explicitly asked to implement it almost exactly like the final art. This supersedes the earlier procedural oval-table approximation.

Canonical normal-table art:
- runtime: `assets/pixel/table/approved_variant_c/table_exact.webp` (1280×720)
- source master: `assets/source_archive/table/approved_variant_c/table_exact_master.webp`
- scene: `scenes/table/table.tscn`
- logic: `scripts/table/table.gd`
- loader: `scripts/ui/runtime_webp_texture.gd`

The approved visual language is:
- Wizard centered behind one broad oval red-black ritual table;
- restrained candle/brass/skull decoration, not dense AI-like micro-detail;
- physical deck stack on the left;
- physical rejected/discard stack on the right;
- two live offer cards near the player;
- Hold controls immediately above each live offer;
- `РАСКЛАД СУДЬБЫ [R]` centered between Wizard and cards;
- compact top HUD + live Wizard line;
- warm bronze/gold physical-card framing;
- no rectangular lower HUD slab and no duplicate compact progress map.

Current implementation:
- `WizardBackdrop` now runtime-decodes the exact approved full-screen Variant C plate.
- Old procedural `TableVisual`, compact `TableSpreadVisual`, and separate logo are hidden on the canonical normal table.
- Live offer cards are smaller/lower and use reduced rotation/hover motion to sit physically on the table.
- Deal origin is aligned to the left physical deck; discard destination is aligned to the right physical discard holder.
- Baked Hold text is covered by small live masks; live Hold buttons remain authoritative.
- Physical holder labels come from the art; only changing deck/discard numeric values are overlaid live.
- The old v6 Wizard crop remains in repository history/assets but is no longer the canonical table backdrop.
- No mechanics were intentionally changed by this visual pass.

### Immediate next action

The latest exact-art normal-table integration is committed but still needs the **first local 1280×720 screenshot after this exact plate was wired into runtime**.

After `git pull`, open the normal table with two offers and check only:
1. live offer cards align with/cover the baked sample-card zones cleanly;
2. Hold buttons do not double with baked Hold text;
3. deck/discard live numbers sit naturally on their physical plaques;
4. top HUD and Wizard line remain readable and do not feel like large black UI slabs;
5. live cards do not cover the Wizard's hands;
6. no hidden procedural table/logo/progress elements leak through;
7. wager overlay is still readable over the new full-screen plate.

If close, do **pixel-level alignment/mask/font fixes only**. Do not regenerate another table concept or return to the procedural oval-table version unless the user explicitly changes direction.

### Broader project state to remember

- Godot 4.7.x + GDScript.
- GitHub repo: `zampolit73/Misdeal`.
- Vertical-slice priority remains Act 1 through Bone Warden.
- All 25 active Act 1 table cards already have unique current art coverage.
- Dedicated current battle arenas exist for Crypt, Gallows, Graveyard, Ossuary, Warden and Bone Crush.
- Main menu, Class Select, Reward, Run End and all planned Act 1 event environments already have authored art passes.
- Solo/duo balance compensation is implemented and still benefits from full-run local validation; do not blanket-retune enemies before concrete test results.
- Pre-battle target intent lines are opt-in via the `ЦЕЛИ` toggle.
- Shared scene-transition veil is in place to avoid gray flashes; only revisit if a reproducible transition flash remains.
- Avoid broad architecture work or another global art replacement pass. The next phase after accepting the exact normal table should return to full vertical-slice validation, balance and concrete screenshot-driven fixes.


## Latest normal table exact-reference integration

## Current handoff — 2026-10-09 — continue from here

The user asked for the whole working context to be made durable in GitHub before moving to another chat.

### Do not revisit without concrete evidence

**Fate Spread is visually frozen.** The final approved physical-table composition is already in runtime and has gone through multiple local screenshot corrections. Only fix specific leaks/collisions if they appear.

### Latest approved normal table

The user's newest approved reference is the cleaned-up **Variant C** image with:
- Wizard centered behind the table;
- broad oval red-black ritual tabletop;
- relatively restrained edge props (candles/brass/skull, not dense generated clutter);
- physical deck stack at left and rejected stack at right;
- two offer cards centered near the player;
- Hold buttons immediately above each offer;
- `РАСКЛАД СУДЬБЫ [R]` centered under the Wizard;
- compact top status line + Wizard commentary.

That exact art is now the canonical runtime foundation at:
- `assets/pixel/table/approved_variant_c/table_exact.webp`
- source: `assets/source_archive/table/approved_variant_c/table_exact_master.webp`

Implementation:
- `scenes/table/table.tscn` uses `runtime_webp_texture.gd` to load the full 1280×720 plate;
- the old `TableVisual`, `TableSpreadVisual` and separate logo are hidden;
- live offer cards are ~230×278 and positioned around x=396 / 654, y=366;
- live Hold controls align to the art around y=334;
- live deck/discard animation points are near the physical side stacks;
- live deck/discard text now overlays only the changing numbers rather than redrawing the baked static labels;
- offer-card frames use a restrained brass/black physical-card treatment;
- dynamic run state remains authoritative despite the full-screen art.

### Next action in a new chat

First read the required project docs and current GitHub code, then ask for/inspect the **first local screenshot of this exact-art normal table** after the user pulls latest main.

Do not start a new broad visual generation pass. Fix only concrete alignment/masking problems from that screenshot. The likely first corrections, if needed, are tiny holder-number masks, Hold-button alignment, top-HUD width/opacity, and offer-card vertical position.

### Git access

GitHub access is available through the connected tools. Use it directly for implementation and fixes; do not repeatedly ask the user to copy files or claim Git is unavailable before checking the tools.


The user approved the final cleaned Variant C normal-table artwork and asked for it almost one-for-one. Runtime now uses `assets/pixel/table/approved_variant_c/table_exact.webp` as the full 1280×720 foundation, loaded through `runtime_webp_texture.gd`. The generated source master is archived at `assets/source_archive/table/approved_variant_c/table_exact_master.webp`.

`table.tscn` no longer relies on the old v6 upper-Wizard crop for the normal screen. The procedural tabletop and compact spread visual are hidden. Live HUD/Wizard text/buttons remain on top; offer cards are resized and aligned to the two card positions in the plate; only numeric deck/discard values are masked/replaced over the physical plaques; Hold text is masked so live Hold state remains authoritative. Deal/discard animation anchors match the physical side stacks.

Next local screenshot check: confirm there is no visible baked-card leakage around the two offer cards, deck/discard numbers do not double, Hold buttons line up with the art, and wager/memory overlays still read cleanly. Do not redesign the composition unless a concrete local screenshot exposes a mismatch.

# Misdeal — Current Handoff

Last updated: 2026-10-08

This file is the compact continuation point for a new ChatGPT Project chat. GitHub remains the source of truth for implemented state.

## Current baseline

Functional/visual baseline commit before this handoff archive: `bdc9246421b6a2efdd75cb3be3e750d87c485a01` — **Integrate final v9 event environments**.

The user locally confirmed the v7/v8 rollout and the table/battle brightness fixes as working/acceptable. The newest V9 event-environment package has been integrated in GitHub and is the next screenshot-validation target.

Do not ask the user to re-explain the recent visual history. Read this file, `docs/VISUAL_ASSET_REGISTRY.md`, `PROJECT_STATE`, `ROADMAP` and `DECISIONS`.

## What is now visually replaced

Broad Act 1 art replacement is considered complete.

- Main menu: approved authored splash, live transparent CTA hotspot.
- Intro: five authored 1280×720 frames.
- Wizard table: accepted v6 Wizard/table backdrop, live UI/cards, corrected midtones.
- All 25 active table cards: current v4/v5/object-specific art; no intentional unrelated-art fallback.
- Class Select: dedicated Knight / Ranger / Mage portraits.
- Squad Dossier: reuses the same dedicated portraits, not combat-sprite crops.
- Reward: dedicated v7 reward backdrop.
- Run End: dedicated v7 ending backdrop.
- Whispering Well: dedicated v7 environment.
- Curse Forge, Chained Prisoner, Black Altar: dedicated v7 environments.
- Candle Seller, Gravedigger Shop, Blood Ledger, Faceless Card: dedicated v8 environments.
- Rattling Bridge, Lost Purse, Debtor Bones, Bone Tax, Wizard Tithe, Ash Rest, Last Camp, Broken Crown: dedicated v9 environments.
- Battles: native-HD authored Crypt/Gallows and v6 Graveyard/Ossuary/Warden/Bone Crush; Bone Crush deployment/combat bounds were aligned to the visible floor.

## V9 event mapping

The shared live event scene is `scenes/event/act_choice.tscn`, driven by `scripts/event/act_choice.gd`.

| card_id | Player-facing card | Runtime art |
| --- | --- | --- |
| `rattling_bridge` | ГРЕМУЧИЙ МОСТ | `assets/pixel/event/v9/rattling_bridge.webp` |
| `lost_purse` | КОШЕЛЬ МЕРТВЕЦА | `assets/pixel/event/v9/lost_purse.webp` |
| `debtor_bones` | КОСТИ ДОЛЖНИКА | `assets/pixel/event/v9/debtor_bones.webp` |
| `bone_tax` | КОСТЯНАЯ ПОШЛИНА | `assets/pixel/event/v9/bone_tax.webp` |
| `wizard_tithe` | ДЕСЯТИНА ВОЛШЕБНИКА | `assets/pixel/event/v9/wizard_tithe.webp` |
| `ash_rest` | ПЕПЕЛЬНЫЙ ПРИВАЛ | `assets/pixel/event/v9/ash_rest.webp` |
| `last_camp` | ПОСЛЕДНИЙ ПРИВАЛ | `assets/pixel/event/v9/last_camp.webp` |
| `broken_crown` | СЛОМАННАЯ КОРОНА | `assets/pixel/event/v9/broken_crown.webp` |

The original generated V9 compositions are also preserved as larger 1672×941 Q95 WebP masters under `assets/source_archive/visual_pass_v9/`. Those archive files are not runtime dependencies; they exist so later art work can crop/re-export from the approved generated source instead of regenerating from memory.

## Important runtime-art rule

Godot 4.7.2 locally failed when newly committed WebPs were referenced directly through `preload()` or new `Texture2D` scene ext_resources before import state was ready.

For new authored screen WebPs, use the established runtime path:

- `scripts/ui/runtime_webp_texture.gd`
- `FileAccess`
- `Image.load_webp_from_buffer()`
- cached `ImageTexture`

Do not reintroduce direct preloads for newly added WebP screen art unless locally proven safe.

## Visual lessons already learned

Do not repeat these rejected passes:

- 112×69 card cells enlarged to live card size: rejected as muddy/blocky.
- 320×180 arena cells enlarged to 1280×720: rejected as visibly low quality.
- strong environment/card post-grading on already-dark authored art: rejected because it crushed midtones to black.
- broad generic AI-fantasy density with equal-detail candles/bones/ornament everywhere: rejected as obviously generated and hard to read.
- full-screen generated UI screenshots with baked prices/buttons/stats: do not use as production UI; dynamic state stays native Godot controls.
- combat units placed over architecture rather than the painted floor: explicitly fixed for Bone Crush and should remain a layout check for future arenas.

Accepted direction:

- authored dark-gothic pixel look;
- large quiet masses and readable focal subjects;
- fewer decorative micro-details;
- native/near-display resolution;
- live UI over authored environment art;
- nearest presentation where appropriate;
- preserve dark midtones rather than crushing everything to black.

## Current gameplay state that must not be accidentally changed by visual work

- Godot 4.7.x + GDScript.
- Act 1: 12 resolved cards, then Bone Warden boss.
- Run starts with exactly one chosen protagonist.
- Companions can be recruited/lost; solo/duo/trio is real run state.
- Solo compensation: hero HP ×2.2, damage ×1.9, attacks/sec ×1.25, movement ×1.10; enemy HP ×0.82 and damage ×0.80.
- Duo: +20% HP, +15% damage.
- Bone Warden composition/mechanics remain the benchmark; its enemy HP/damage inherit the same transparent party-size pressure scaling as other encounters.
- Tactical orders: НАТИСК / ОХОТА / СТРОЙ plus temporary ЖЕРТВА / НЕПОВИНОВЕНИЕ when unlocked.
- Wizard wagers, debt, marks, holds, memory, rescue scars and Last Deal are implemented systems.
- Visual passes must not silently alter mechanics, prices, stats, card odds or encounter composition.

## Latest local-fix follow-up

A 2026-10-08 Gallows Volley screenshot showed units, especially retreating ranged roles, climbing into the authored background above the visible floor. The encounter now uses a tighter floor-aligned combat rectangle, matching deployment band and adjusted party start positions. This is a movement-space fix for every unit in Gallows Volley, not an archer-only workaround. It is pending local verification.

The current V9 event environments were also reviewed directly from the repository against `docs/ART_DIRECTION.md`. Several remain visually over-detailed and repeat the same candles / gothic skyline / red-banner language. Do not replace them blindly; prioritize object-first redraws where local event screenshots confirm the mismatch, while keeping live UI/text untouched.

## Latest targeted battle fix

A post-handoff screenshot exposed Gallows Volley units visually moving over the background architecture. `main` now lowers/tightens that encounter's legal combat floor, moves hero/enemy spawns onto the stone platform, and clamps all units immediately when combat bounds are assigned. This is pending local verification, especially ranged retreat and separation with solo/duo/trio parties.

## Latest UI-kit screenshot fixes

The first local screenshot pass after the shared UI-kit rollout is already folded into `main`: authored-image hotspots on the main menu and intro are transparent again, and resolved generic Act Choice screens now hide the obsolete leave action and give long result messages their own bottom strip above a single `К СТОЛУ` button. The screenshots otherwise validated the new event and Reward/development chrome direction as substantially more coherent.

## Shared UI-kit follow-up

A first shared gothic UI-kit pass is now in `main` through `scripts/ui/misdeal_ui_kit.gd`. It is applied to the main menu, intro, Class Select, Wizard table/wager, Squad Dossier, shared Act Choice, Whispering Well, Reward, Battle HUD/Last Deal and Run End. The pass keeps all existing authored art and live UI content, but replaces the previous screen-by-screen chrome with one runtime style language.

This is pending local 1280×720 verification. Check especially event/reward card text margins, hover/disabled states, corner marks over portrait/art regions, Wizard wager readability and Battle HUD density. Fix concrete screenshot defects; do not start a second competing UI framework.

## Latest target-preview UX fix

The first-target intent system is no longer permanently visible during preparation. A live `ЦЕЛИ: ВКЛ/ВЫКЛ` toggle now sits above the central `БОЙ` action. It starts off on a fresh app launch, remembers the player's preference between battles/new runs during that app session, and the lines still disappear automatically as soon as combat begins. This keeps the tactical information available without permanently cluttering five-enemy layouts such as Death Wager.

## Latest parse-order hotfix

A follow-up local screenshot exposed one rollout mistake in `scripts/run_end/run_end.gd`: `SCENE_ROUTER` had been inserted before `extends Control`, causing `Unexpected "extends" in class body`. The declaration order is fixed. A repository check of all active navigation scripts confirms they now begin with `extends ...` and contain **zero direct `SceneTransition.` references**; navigation goes only through `SCENE_ROUTER`.

The old battle error line mentioning `SceneTransition` may remain visible in Godot's output history until the next clean run, but current `main` no longer contains that identifier in `battle.gd`.

## Latest SceneTransition compile hotfix

A local screenshot showed `Identifier "SceneTransition" not declared in the current scope` after the user's `project.godot` had previously conflicted during pull. The repository's canonical `project.godot` does contain the autoload, but navigation no longer relies on that global symbol at parse time.

All active navigation now uses `scripts/core/scene_router.gd`. It resolves `/root/SceneTransition` when registered; otherwise it instantiates `scene_transition.gd` as a persistent root child at runtime. This means a stale/local `project.godot` can no longer prevent battle/event scripts from compiling, and the seamless dark transition remains available.

## Latest gray-frame root fix + battle intent improvement

The first transition veil still produced an intermittent full-gray frame locally. The root cause path has now been removed: `SceneTransition` no longer calls `change_scene_to_file()` for normal navigation. It threaded-loads the incoming PackedScene while the old scene remains visible, instantiates it before blackout, waits until a fully opaque veil frame has actually rendered, manually adds the new scene while the old one still exists, switches `current_scene`, queues the old scene for deletion, waits for incoming runtime-art/layout frames, then reveals the result. Runtime and project clear colors are both forced to the same near-black fallback.

Battle preparation now also shows live target intents using the existing combat AI: blue arrows are hero first targets under the current tactical order; red arrows are enemy first targets under the current placement. They update during dragging/order changes and vanish on `БОЙ`.

Local verification priority: repeatedly cycle table → event → table → combat → reward → table several times, then verify the intent arrows remain readable in solo, trio and Death Wager layouts.

## Latest start-screen + transition fix

The user approved the restrained replacement main splash after rejecting the previous low-quality version and two over-AI/off-model Wizard attempts. The canonical runtime image is now `assets/pixel/main/approved_splash_hd/main_splash.webp` at 1280×720. `scripts/main/approved_main_backdrop.gd` loads it with FileAccess + `Image.load_webp_from_buffer()`; do not restore the removed compressed chunk loader.

A brief gray screen was also reported when changing into battle and when returning to card selection/table after events. `SceneTransition` is now a persistent autoload CanvasLayer that covers the viewport before scene replacement, survives the replacement, waits through the incoming scene's first two frames, and fades out. Active main/intro/class-select/table/event/battle/reward/run-end transitions and battle reloads use it. The renderer clear color is the same near-black fallback.

Pending local check: fresh `git pull` + Godot restart, then inspect the main splash and specifically table → battle, event → table, battle → reward and Last Deal reloads for any remaining flash.

## Latest gameplay/balance pass

A first full-run party-size pressure rebalance is now in `main`. Solo keeps one hero but receives HP ×2.2, damage ×1.9, attacks/sec ×1.25 and movement ×1.10; enemy HP/damage are reduced to 82%/80%. Duo keeps +20% HP/+15% damage while enemy HP/damage are 92%/90%. Trio remains the authored 100% encounter baseline.

Enemy composition and boss mechanics are unchanged. Grave Bell/support healing scales with enemy HP. Debt/Mark danger multipliers stack relative to the party-size baseline. Tier 0 also cannot force combat on card 1 anymore: at least one non-combat decision occurs first.

This is pending real local verification. Highest-value checks are: solo Ranger and solo Mage first mandatory fight, one duo mid-tier support/ranged fight, one late elite, and Bone Warden in solo/duo/trio. Do not blanket-retune individual enemies before those checks unless a concrete regression appears.

## Latest main-table Variant C rebuild

The Fate Spread itself is now frozen. The user then approved a cleaner Variant C reference for the **normal deal table** and asked to eliminate the square/rectangular-table feel.

Current `main` now uses:
- the existing authored v6 Wizard backdrop for the upper scene;
- a live/procedural wide oval physical tabletop and red-black ritual cloth drawn by `scripts/table/table_visual.gd`;
- one large central ritual sigil instead of a second mini Fate-Spread/progress graphic;
- physical side holders with live deck/rejected stacks;
- live offer cards at y≈350 with Hold controls directly above;
- centered `РАСКЛАД СУДЬБЫ [R]` access above the cards;
- no old rectangular lower shade / offer-focus rectangle.

The deal and discard animation targets were moved to the physical side holders. The normal-table `SpreadProgress` label is intentionally hidden; detailed Act progress belongs to the Fate Spread overlay.

Next local check is screenshot-driven only: verify at 1280×720 that the oval table overlays the v6 Wizard backdrop cleanly without covering his hands, and that cards/holders look physically seated on the cloth. Fix geometry from that screenshot; do not redesign Fate Spread.

## Latest Fate Spread final polish

The latest screenshot is close enough that composition is now frozen. Final tweaks in `main`:
- future live replacement cards hide the footer/title and use a subdued physical card-back style;
- hover decision memory is a small cursor-adjacent tooltip clamped to screen bounds instead of a wide bottom strip;
- empty Hold/Discard card masks use dark leather/burgundy rather than pure black.

Do not move the ring, XIII, side holders or header unless a concrete screenshot exposes a real collision/leak.

## Latest Fate Spread screenshot alignment pass

Latest local screenshot was already close to target. Do not change the ring geometry. Fixes now in `main`:
- XII is a baked sample slot in the approved plate just like I–IV, so it is always masked and replaced by live state;
- static title is taken directly from the approved reference; only dynamic subtitle/count/chapter rows are masked/redrawn;
- right discard count is positioned inside its physical holder;
- empty side holders omit the floating `ПУСТО` text.

Next screenshot should be evaluated for tiny per-slot leaks/offsets only.

## Latest Fate Spread reference-preserving cleanup

The previous screenshot exposed over-masking: future slots had large black rectangles and the live sealed XIII covered the approved central skull/chain card. This has been corrected without moving the composition.

I–IV are always live-covered because the reference has sample cards there. V–XII use the reference's generic future backs until they become current/resolved, at which point a tight live mask/card replaces that position. The approved sealed XIII is now used directly until the boss becomes active; only then is the center masked for a live boss replacement. The header mask is fully opaque and wider.

Next screenshot should be checked for small alignment leaks only. Do not reintroduce broad full-slot masks unless a specific baked card edge is visibly leaking.

## Latest Fate Spread baked-state cleanup

The exact-reference screenshot exposed duplicate baked state from the concept plate behind live UI (old sample cards, Roman numerals, header text and XIII label). Do not move the layout again. A dedicated `scripts/table/fate_spread_reference_cleanup.gd` now paints only over those baked dynamic regions inside `SpreadArea`, while the approved physical-table art remains untouched.

The header mask is wider/opaque, all twelve slot regions use larger cloth masks that also cover the old Roman numerals, and XIII has its own cleanup patch. Empty Hold/Discard title plates are dark instead of parchment-colored.

Next local screenshot should be checked only for residual baked-state leakage or small mask alignment issues.

## Latest Fate Spread exact-reference rebuild

The user rejected approximation and asked for the Fate Spread almost exactly like the final approved reference. Runtime now uses `assets/pixel/table/fate_spread/fate_spread_exact.webp` as the full 1280×720 physical-table foundation. The live overlay was re-laid to the reference rather than keeping the previous modal geometry.

Important implementation details:
- live slot positions are explicit per-card coordinates matching the reference perspective, not an even mathematical ellipse;
- resolved cards use parchment/gold physical-card styling, current/future cards use dark backs;
- Hold/Discard rely on the artwork's ornate holders while live masks replace the baked sample card/count;
- the top baked title/stats are masked and redrawn from current `RunState`;
- runtime WebP loader now supports linear filtering for full-screen authored plates;
- old runtime edge plates / underlay were removed.

Next local check should focus on leakage: any baked reference card/title/count still visible beside a live replacement must be fixed with position/mask tweaks, not by darkening the whole scene.

## Latest Fate Spread edge-art pass

The full-screen reference plate is no longer used by the live Fate Spread. It was too constrained by masking/dimming and still read like a dark modal. The approved physical-table look is now supplied by three dedicated edge plates loaded through `runtime_webp_texture.gd`:

- top: candles, brass, books and gothic rail;
- left: candles, skull/ritual props, chains and red cloth;
- right: skull, goblet, candles, coins and red cloth.

The live center/ring/XIII/history remains unchanged and authoritative. Source masters are preserved under `assets/source_archive/fate_spread_edges/`. Validate screenshot brightness/overlap before changing geometry again.

## Latest Fate Spread underlay visibility fix

The first local screenshot after integrating the approved reference showed almost no visible authored table atmosphere because `Frame` was painting over the root-level underlay. The underlay is now inside `Frame`, above its panel background and below all live controls. The outer frame/scrim are lighter so candles, metal props and red cloth can actually read.

The central `SpreadArea/TableSurface` was simultaneously made much more opaque, and a dark header mask was added, so the concept image's baked cards/title/counters remain suppressed. Side panels continue to cover the concept's baked held/discard areas. Preserve this layering principle: authored physical-table atmosphere at the edges, live run data at the center.

## Latest approved Fate Spread visual target

The user approved the ornate Fate Spread reference (physical red ritual table, candles, skulls/metal props, stronger gold/red hierarchy). The runtime now blends a deliberately dark/blurred derivative at `assets/pixel/table/fate_spread/reference_underlay.webp` underneath the live overlay. The frame/scrim were made translucent enough for that atmosphere to read while the procedural central surface still suppresses baked reference details.

Important: do not replace live I–XII cards, XIII, counts, hold/discard state or history text with static image content. The approved art is an atmospheric plate only; the live UI remains the source of truth.

## Latest Fate Spread memory + milestone pass

The Fate Spread now also acts as a run diary. `RunState.fate_choice_history` records each resolved pre-boss chosen/rejected pair. Hovering a completed slot scales it up and shows a compact detail strip with the chosen card and rejected alternative. Existing runs fall back to aligned resolved/rejected history where possible.

The center is now grounded by a low-contrast procedural red-black table surface. Chapter boundaries IV/VIII/XII are one-shot ritual beats: once the normal table unlocks after crossing a boundary, the spread auto-opens, a dedicated ritual sound plays, and XIII/seal gets a short pulse/shake. `fate_spread_last_milestone_shown` prevents repeats.

Local verification priority: finish card 4, card 8 and card 12 in a fresh run; confirm each automatic reveal happens once, does not fight Wizard wager/meddling locks, closes normally with R/Esc, and hover memory displays the correct rejected partner.

## Latest Fate Spread reference polish

After the user confirmed the cleaned-up spread and explicitly asked to stay close to the approved concept, the screen received a reference-driven polish pass: live occult seal beneath the ring, visible fate-thread connecting I–XII, brighter completed path, milestone gates at IV/VIII/XII, inward ritual spokes, progressive blood/ember center intensity, and a dedicated XIII chain/seal overlay. XIII starts with two crossed chains, loses one entering the final chapter, and reveals an awakened mark when the boss becomes due. Side holders are shorter so the center owns the composition.

Next local check should capture the spread at roughly 0, 4, 8 and 12 resolved cards. Fix only concrete readability/collision issues from those screenshots; keep the reference's restrained ritual-table composition rather than adding generic HUD decoration.

## Latest Fate Spread screenshot fix

The first local Fate Spread screenshots showed the active deal cards and the table `РАСКЛАД СУДЬБЫ` button drawing over the inspection overlay. This is fixed in `main`: opening the spread now hides the live card layer and progress access, the overlay sits at the valid top CanvasItem z-index (4095), and the twelve ring cards were reduced/re-spaced to give XIII clear visual priority. Closing with `R`, `Esc` or the button restores the live deal.

## Latest Act 1 progression system

The user approved the **РАСКЛАД СУДЬБЫ** concept and it is now implemented in `main` as live UI.

The normal cursed table keeps a subtle 12-position occult ring behind the active deal. `РАСКЛАД СУДЬБЫ [R]` opens `scenes/table/fate_spread_overlay.tscn`, which shows chronological resolved cards I–XII with real card art, the current position, central sealed XIII/Bone Warden, the held card, and the most recent rejected card in the Wizard discard. The overlay also shows live counts and the three visual four-card chapters. Future slots intentionally remain `?` because current offer RNG does not pre-schedule route types.

Local verification should check the overlay at early/mid/late progress and specifically confirm that the 12-card ring remains readable at 1280×720, long Russian card titles do not collide, held/rejected art is correct, and `R` reliably closes the overlay without triggering table actions beneath it.

## Exact next step

Do not begin another broad art-generation pass.

1. User pulls latest `main`.
2. Start a fresh **solo Ranger or solo Mage** run and confirm card 1 is non-combat, then play the first mandatory fight without debug intervention.
3. Continue far enough to verify one mid-tier ranged/support encounter and one late elite; report only concrete difficulty spikes or trivial fights.
4. Re-run **ЗАЛП С ВИСЕЛИЦЫ** during that pass and verify retreat/chase/separation keep every unit on the stone floor.
5. When convenient, repeat a shorter duo/trio check and use Bone Warden as the final benchmark. Only then retune individual enemies or boss numbers.
6. Visual work remains screenshot-driven only: fix concrete event/UI defects instead of starting another blanket art batch.

## Git workflow

The assistant has connected GitHub access in Project chats and should use it directly when implementation/fixes are requested. Do not repeatedly tell the user Git access is unavailable without first checking the connected GitHub tools.

The user normally needs only:

`git pull`

then restart/run Godot and report screenshots/errors.
