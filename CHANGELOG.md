## D151 POST-RELEASE QA FIX — 2026-10-15 — FREED TARGET ERROR; RECHECK IN GODOT

User's real Godot 4.7.2 screenshot of `scenes/dev/funeral_procession_smoke.tscn` showed runtime debugger failure in `scripts/battle/unit.gd` at `_is_valid_target(target)`: **"Invalid type ... Object-derived class of argument 1 (previously freed) is not a subclass of the expected argument class."** This is a **failed smoke test**, NOT a native 54/54 PASS. Root cause: `_is_valid_target(candidate: BattleUnit)` enforced the object type *before* its `is_instance_valid` guard, so a stale/freed reference crashed; moreover, the D151 smoke used `arena.queue_free()` then resumed on `process_frame`, allowing old units to linger in `combat_units` across successive fixture rounds. **Both fixed in GitHub main:** `unit.gd` now accepts `candidate: Variant`, validates instance and BattleUnit class before reading alive/team; D151 smoke now uses immediate `arena.free()` only after manually simulated fights/QA fixtures end. Added isolated regression `_validate_freed_target` that destroys a target mid-lifecycle and verifies the unit's next tick does not crash or retain a dead reference. **No art, combat balance, Last Rite, original sprites or run design changes.** Act1 remains **34/45** with Funeral Procession live; 12+XIII unchanged. Code/static inspection confirms new guard, immediate fixture disposal and test wired; no Godot execution available here. **NEXT USER:** `git pull`, F6 `res://scenes/dev/funeral_procession_smoke.tscn`, send PASS screen or new error. Do not claim 54/54 or start adding cards until this regression is resolved.

---

## D151 RELEASE — 2026-10-15 — FUNERAL PROCESSION NOW LIVE AS ACT1 CARD 34/45

User replied «все ок» after D151 role-facing hotfix and the instructions to re-check the real playtest and 54-case smoke. Treat this as **user acceptance of the corrected in-game facing and overall result**, without inventing a separate 54/54 screenshot or exact win/loss counts. Live source now registers `funeral_procession` in `RunState.ACT1_CARD_IDS` (34 distinct nonboss cards including original priest + two coffin bearers); its `CARD_PATHS` was already present. Existing `scripts/battle/battle.gd` calls scoped `LastRiteController` start/stop for this encounter only. Previously approved D151 original card 448×274 WebP, original 25-frame sprite atlases, no-bell art direction and role-local facing correction all remain unchanged. Updated fixed-count guards in `scripts/dev/bone_shepherd_smoke.gd` and `scripts/dev/funeral_procession_smoke.gd` from 33 to 34. Exactly **12 Fate Spread resolutions plus sealed XIII** per run still unchanged; overall planned 45-card goal remains. Older Bellkeeper, Bone Shepherd, DS2 art, and balance multipliers untouched. **New release commit and test changes have not yet been re-run in native Godot by assistant**; perform one post-pull F6 `funeral_procession_smoke.tscn` and optionally a live normal-run/reward flow to catch any integration regressions. DO NOT claim independently verified post-release 54/54 metric. Next feature work: remaining 11 of 45 cards; every new fight requires new roles/behavior/art per D143. Original issue and decision history are below.

---

## D151 FACING HOTFIX — 2026-10-15 — committed; Godot retest pending

**User reported an actual Godot `funeral_procession_playtest.tscn` prebattle screenshot:** both new Funeral Priest and Pallbearer appeared turned AWAY from the hero. Found root cause in `scripts/battle/unit.gd`: standard art assumes source miniatures face RIGHT, setting `art_sprite.flip_h = team == 1` for enemies, and `flip_h = delta_x < 0` when retargeting. The D151 V2 atlases were instead painted facing LEFT at source. **Fix committed directly to GitHub:** new scoped `SOURCE_FACES_LEFT_ROLES = ["funeral_priest","pallbearer"]` plus `_set_facing_left(face_left)` in BattleUnit, used in both initial deployment and the dynamic target-facing path. For D151: enemy team on right now stays unflipped and faces hero left; on a target crossing right, flips to face right. Other heroes and legacy enemies preserve their original facing rule. `scripts/dev/funeral_procession_art_preview.gd` now displays the original left-facing poses, no redundant flip. `scripts/dev/funeral_procession_smoke.gd` includes a regression check for D151 role initial and target-facing plus old knight/skeleton deployment. **No artwork/balance/encounter mechanics changed.** This was source/static verified only; the user **has NOT yet run Godot after the fix**, so native PASS, full 54/54 matrix and victory→reward→table are still pending. New card remains lookup-only, not in live `ACT1_CARD_IDS`, so pool stays **33/45**. NEXT USER: `git pull`; F6 `res://scenes/dev/funeral_procession_playtest.tscn` and confirm the two enemy classes face the Knight left at prepare and correctly turn in action; F6 `res://scenes/dev/funeral_procession_smoke.tscn` (includes facing regression and 54 combat cases); send screenshot/FAIL. Do not ship as 34th card until native check.

---

## D151 ACTIVE CHECKPOINT — 2026-10-15 — user-approved sprites, Funeral Procession battle staged; F6 real combat pending

User approved corrected V2 original Funeral Priest and Pallbearer visual playback («все отлично!»). Current GitHub `main` now contains scoped `LastRiteController` hook in actual `battle.gd` (spawn/setup → fight start → stop on victory/defeat), new `CARD_PATHS` lookup only for `funeral_procession`, and **two F6 scenes**: `scenes/dev/funeral_procession_playtest.tscn` for actual UI→victory→reward→table, and `scenes/dev/funeral_procession_smoke.tscn` for a 54-battle matrix (2 deployments × 3 protagonists × 1–3 heroes × 3 tactical orders). Previous isolated `last_rite_smoke.tscn` native PASS remains valid, but **new battle/matrix scenes have NOT yet been executed in Godot**, so their real result/balance/reward navigation is pending. Static inspection of paths and hooks passed; no engine PASS claimed. `ACT1_CARD_IDS` **unchanged at 33**, target 45; the 34th card will become live only after native QA succeeds. Existing Bone Shepherd, Grave Bellkeeper, DS2 and art unchanged. Full authoritative D151 status: `docs/DECK_EXPANSION_D151_FUNERAL_PROCESSION.md`. User needs only `git pull`, run the two F6 scenes above and share result; fix any errors yourself through connected GitHub.

---

## D151 ART REPACK V2 — 2026-10-15 — clipping fixed offline; native F6 recheck pending

User noted that the original D151 art preview clipped the Priest's robe and Pallbearer's feet and showed adjacent-frame spill. Old D151 imported files were correctly rejected by the newly introduced 96px cell-edge quality gate, and card release remained blocked. The user approved continuing with replacement sprite sheets. **Fix now committed to GitHub `main`:** `assets/pixel/units/deck_expansion_v1/funeral_priest_frames.webp.b64` (`b9d1723`, SHA256 of contained WebP `02c0b86f30a1d35d7b18b9fbeb8c307d23ec488d1e1954f6b76b4f7cfd14e5f2`), `pallbearer_frames.webp.b64` (`e5c5103`, SHA256 `9b5e1f5051e13a33254a4dd941524154c6b61cf6a462df2843fc565f7f04f74d`). Their exact remote text bytes were independently refetched/compared and match the QA-generated files.

**Root cause and remedy:** the two generated 1374×1145 source actor sheets contained **five organically positioned rows, not a strict 229×229 coordinate grid**, so earlier uniform slicing cut through boots, robe and coffin. V2 reads actual transparent gaps between poses, extracts each original authored pose, scales it consistently per role, centers it with transparent padding and aligns the lower silhouette to local 96px y=90. No synthetic frames, borrowed units or repeated/duplicated poses. Both WebPs are **576×480** (6×5, 96px), 25 required active cells each (idle 4, walk 6, attack 6, hit 3, death 6). Offline redecoded lossless WebP: **50/50 active frames nonempty; 50/50 have zero alpha on the outer 3px per-cell borders; all adjacent silhouette differences nonzero** (minimum difference 3.83% Priest / 3.19% Pallbearer). The previously failing D151 strict 2px border-gate should now accept both. `funeral_procession_art_preview.gd` positioning changed from y=346 to y=354 so the new sole baseline matches the y=442 guide. Original **448×274** approved-style card art unchanged. Existing Bellkeeper, Shepherd, and all other characters untouched.

**Native QA is NOT yet complete.** Offline full-body containment is not proof the motions look fluid in the real Godot client. NEXT ACTION: user `git pull`, F6 `res://scenes/dev/funeral_procession_art_preview.tscn`, confirm the warning `АРТ НЕ ГОТОВ` is gone, both figures stand with feet/hem on the baseline, coffin and censer remain contained in IDLE/WALK/ATTACK/HIT/DEATH, and send one screenshot/verdict. If accepted, integrate already-tested `LastRiteController` into a scoped D151 actual battle, create combat smoke (solo/duo/trio, two formations, revival/interrupt), verify real victory→reward→table, only then register the new card (33→34/45). **Live 33-card pool remains unchanged** and Last Rite's earlier *isolated* Godot smoke PASS is still valid. No full production battle or visual acceptance claimed.

---

## D151 FRAME-CLIPPING BLOCKER — 2026-10-15 — GODOT SCREENSHOT + SOURCE AUDIT

User ran real `funeral_procession_art_preview.tscn`: original card looks good, but both **Funeral Priest and Pallbearer have feet/lower silhouettes cut off**, with fragments of neighbouring cells visible. User explicitly asked whether legs should be visible: **yes** for Pallbearer; Priest has a ground-touching robe, but no rectangular truncation/bleed should show. Checking `funeral_priest_frames.webp` and `pallbearer_frames.webp` decoded from the committed `576×480` atlas confirms **50/50 authored 96×96 cells contain visible alpha in the outer 2px border (>8 opaque pixels)**. First Pallbearer idle cell has 85 nontransparent pixels in last 2 rows and 95 in right border, i.e. the figure is already cropped in source. Prior frame audit only tested empty/duplicate frames and missed this. **Do not claim D151 sprite art visually passed** or enable `funeral_procession` in the main 33-card pool.

**Fixes already committed:** `scripts/dev/funeral_procession_art_preview.gd` now diagnoses per-role clipped-frame counts and shows **АРТ НЕ ГОТОВ** in F6 while retaining the source candidate for inspection. `scripts/battle/unit_animation_library.gd` has a D151-specific edge-margin validation rejecting these unfinished atlases before use, with no changes to old Bone Shepherd and other approved roles. The card image needs no change. **This is a safety gate, not a new fixed animation**: the currently committed 2 image binaries are still visually invalid and should be replaced with fully redrawn source actor poses, truly centered within 96px cells with 2+ px transparent margins all around, readable feet and grounded idle/walk, complete arms/coffin, no cross-cell bleed. Genuine 4/6/6/3/6 frames per role, avoid simple transforms or repeated poses. After creating replacement source, use exact 576×480 WebP base64 paths, run offline edge/alpha/uniqueness/baseline tests, then new Godot F6 preview and full combat QA. `Last Rite` isolated logic already PASS; no gameplay or 33-card pool change. **Do not ask user for another screenshot until source atlas artwork is actually corrected.**

---

## D151 ART DELIVERY — 2026-10-15 — 2 authentic enemy atlases + card WebP committed, native F6 art QA PENDING

D151 Funeral Procession after user-approved bell-free redesign: original `funeral_priest` and `pallbearer` are now **actual texture assets in GitHub main**, not concept boards. Direct binary Git commit `18b8c2e`: `assets/pixel/units/deck_expansion_v1/{funeral_priest,pallbearer}_frames.webp.b64` each encodes a transparent **576×480** 6×5 (96px) atlas with **25 different valid authored cells** (idle 4, walk 6, attack 6, hit 3, death 6); original `assets/pixel/card_unification_v1/run/funeral_procession.webp` is standalone 448×274 full-bleed art. Offline WebP alpha and consecutive-pose-difference audits PASS; all 25 cells per role visible, but edge clipping/baseline/art acceptance **not yet native tested**. `scripts/battle/unit_animation_library.gd` now supports these two roles with strict missing-frame rejection (no copied/fake poses), `scripts/ui/card_unification_v1.gd` exposes card to preview, `res://scenes/dev/funeral_procession_art_preview.tscn` shows original art and interactive five-state live SpriteFrames. User action: `git pull`, F6 that one scene, visually review motion and cut-offs. Isolated Last Rite ability already had user-confirmed native PASS. **Still NOT in real Act1 deck, no production battle hook**, 33/45 current pool unchanged; no 34th card until visual QA and encounter combat QA. All approved Grave Bellkeeper/Bone Shepherd/DS2 assets remain intact. Full file map and acceptance gate: `docs/DECK_EXPANSION_D151_ART_QA.md`.

---

## D151 ART STATUS — 2026-10-14

Generated two original pixel-art **concept presentation boards** for `funeral_priest` and `pallbearer`, exploring censer-based necromancer and coffin bearer with idle/walk/attack/hit/death silhouettes. These images include UI headings, background and uneven rows, and **are not real transparent 576×480 gameplay atlases**. Explicitly REJECT importing them, duplicating poses, or counting 25 authored animation cells. **No playable D151 art binaries imported and no live code changed** in this art research pass. Image references, quality gate and exact next action in `docs/DECK_EXPANSION_D151_FUNERAL_PROCESSION.md`. Last Rite isolated F6 remains user-confirmed PASS, pool unchanged at 33. Next obtain real isolated transparent original frame sheets for both new units, inspect all 25 per role, stage Godot preview, then original card WebP and runtime wiring.

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

## D148 — 2026-10-14 — LOCAL GODOT 54/54 SMOKE PASS VERIFIED

User submitted a post-hotfix **in-engine Godot screenshot** of `res://scenes/dev/bone_shepherd_smoke.tscn` clearly displaying `DECK EXPANSION 01 — PASS`: **54/54 complete battles, 54 wins / 0 losses, 14 in-battle Shepherd's Whistle activations**, and success of visual/resource loading plus whistle warning, synchronized rush, cancellation, leader death lifecycle checks. This supersedes prior **smoke re-run pending** notes. It certifies the isolated native harness run only: **54/54 wins is NOT evidence of good Tier0 balance**, particularly given the all-wins result; full actual Act 1 and rewards flow untested. User has currently shared only the smoke screenshot from the latest rerun. **Still pending:** post-D148 F6 art gallery screenshots for five animation states, actual battle/playtest confirmation that Shepherd idle no longer flickers, grounding/scale, visual sign-off at Godot size, and real victory→reward→table continuity. Earlier code fixes `c097a24` and `9bc947a` are in main; no new gameplay changes in this QA checkpoint. Do not request another smoke rerun unless a subsequent change warrants it.

---

## D148 — 2026-10-14 — Godot D147 QA hotfix (engine recheck pending)

User provided three screenshots after installing D147 commit `6866656`. Art preview and 54-case smoke cannot launch because `card_art_catalog.gd` preloads `card_unification_v1.gd`, whose D147 comment mistakenly started with `//` instead of GDScript `#`. **Fixed in GitHub main** at `c097a24`; this is a parser error, not missing assets. Manual battle DID launch with the new detailed Shepherd and Lamb textures, but Shepherd intermittently disappears for ~0.37s on idle. Checked the actual committed atlas source: Shepherd row0 idle columns 0–2 visible but **column 3 empty (alpha≈0)**, while all 25 used Lamb frames have visible alpha. **Fixed runtime defensively** at `9bc947a`: `MisdealUnitAnimationLibrary` scans alpha of 4/6/6/3/6 authored cells and blits the previous visible pose into an empty cell before making the `SpriteFrames` texture; the SVG fallback remains. For this exact D147 pack only Shepherd `idle[3]` is repaired. This does NOT yet replace/retouch the imperfect source WebP; follow-up real 4th idle artwork would be preferable after QA. Battle rules, source D147 binaries, Whistle, scaling, other cards/units and approved background unchanged. Static script and raster frame audit PASS; **Godot 4.7 F6 after these commits remains unverified**. NEXT USER: `git pull`, F6 `bone_shepherd_art_preview.tscn`, `bone_shepherd_smoke.tscn` (54/54), `bone_shepherd_playtest.tscn` (no idle disappear, full fight). Request screenshots only; if another parser error appears inspect output and fix directly in GitHub. Do not claim PASS yet.

---

## D147 APPROVED VISUAL ASSETS INSTALLED — 2026-10-14
Imported user-approved 448x274 Bone Shepherd full-bleed WebP plus 576x480 25-frame raster animation atlases for Shepherd and Ossuary Lamb from verified D147 package. Production code prefers these new assets with SVG fallback. Gameplay, Whistle, UnitData, card pool and previously approved art unchanged. All files committed by local install script; Godot F6 gallery, playtest and 54/54 smoke still require user validation.

---

## D147 — 2026-10-14 — approved Bone Shepherd visuals prepared; GitHub loaders staged; binary import pending

User approved the **FIRST** of the two 2026-10-14 cinematic Bone Shepherd artworks (generation `46ed7a48-538d-4e5c-bd0f-27a0c41a7bbf`; Shepherd centered between two horned Lambs). Production card is center-cropped/resampled to **448×274** full-bleed WebP, no baked text or borders. Previously positively received Shepherd and Ossuary Lamb pose sheets converted into separate transparent **576×480 (6×5 96px)** animated WebP atlases (idle 4, walk 6, attack 6, hit 3, death 6); they have not been Godot-validated yet. **Production code changes ALREADY COMMITTED:** `scripts/ui/card_unification_v1.gd` prefers `run/bone_shepherd.webp`, fallback old SVG; `scripts/battle/unit_animation_library.gd` prefers `.webp.b64` for both new enemy roles, fallback existing SVG. **BINARY TEXTURES ARE NOT YET IN GITHUB MAIN**: ready-to-install art ZIP `Misdeal_D147_Approved_Bone_Shepherd_Art.zip` generated as a chat attachment with installer (`install.cmd`), SHA256 manifest, safe file import plus local Git commit/push and documentation updates. Once the user runs that single installer locally, source of truth will include actual assets; until then old SVG continues to render safely. No card pool, battle Whistle, old art, DS2/Fate Spread or stat change. **Still pending:** Godot F6 art preview, playtest, 54/54 smoke, user QA. No engine PASS claimed.

---

## 2026-10-14 — D146 Bone Shepherd visual parity requirements (docs only)

- User rejected D145 flat SVG Shepherd/Lamb animation and new card art; visually audited against approved painterly run cards and detailed Knight/Bone Warden combat sprites.
- Added `docs/DECK_EXPANSION_D146_ART_REWORK.md` with original-enemy, dimensions, full-frame animation and visual approval gates; refreshed handoff, roadmap, art registry and decision log.
- Concept generation experiments were not production assets. No actual card/sprite, runtime loading, gameplay, Whistle, scale or previously approved artwork changed in this documentation checkpoint. 54/54 native Godot QA still pending.

---

## 2026-10-14 — Project-wide current-session GitHub handoff

- Wrote comprehensive [`docs/NEXT_CHAT_HANDOFF.md`](docs/NEXT_CHAT_HANDOFF.md): current GitHub source/asset paths, 31-card Act1 pool, D143/D144/D145 rules/status, all three F6 test scenes, previous parser fix, pending **54/54** post-fix smoke, pending **D145 art in-engine screenshot**, previous D139–D141 actual CSV diagnostics, unapproved D142 follow-up and remaining Deck Expansion scope.
- Linked the file from `AGENTS.md`, `PROJECT_STATE.md`, `ROADMAP.md`, `SESSION_CHECKPOINT.md`, and `HANDOFF.md` for immediate discovery in the next chat. **Documentation-only continuity pass** — no new gameplay, visuals, balancing, art approvals or engine test results claimed.

---

## 2026-10-14 — D145 Bone Shepherd artwork quality refinement (gameplay unchanged)

- Reworked actual `assets/pixel/units/deck_expansion_v1/bone_shepherd_frames.svg` with 25 separately detailed pixel-shape animation frames, dark-fantasy layered cloth texture, old bronze fittings, skeletal mask/ribs, moonlit paint shadows and a small lantern on crooked staff.
- Reworked `assets/pixel/units/deck_expansion_v1/ossuary_lamb_frames.svg` across 25 animation frames: richer horned skulls, jointed bone/hoof outlines, funerary drapery and textured rib plates, retaining the authentic four-legged silhouette.
- Repainted `assets/pixel/card_unification_v1/run/bone_shepherd.svg` (448×274) with graveyard chapel, broken fencing, graves, atmospheric moon and mist, worn cobbles, amber lantern and additional material texture. All existing 576×480/96px enemy cells, poses and art loader paths preserved.
- New composite AI concept sheet was shown only as reference, not used as a source sprite atlas; no unapproved extra event buttons/creature types/summons added. **Only 3 original source-art files + docs changed; no combat, balance, Whistle, UI or RunState changes.**
- Static SVG syntax/size/25-frame audit PASS. **Actual local Godot visual approval after redraw and prior pending Bone Shepherd smoke 54/54 PASS still required.**

---

## 2026-10-14 — D144 Bone Shepherd first local Godot parser hotfix

- User supplied live Godot images: genuine card/Shepherd/Lamb SVG art preview loads and Knight battle scene starts with correct new 1+2 roster; proves render/import/startup but **not** 54-test run or art-quality acceptance.
- Fixed `scripts/dev/bone_shepherd_smoke.gd` compile error at line 17: GDScript does not permit `PackedStringArray([...])` as `const`. Declared `EXPECTED_PATHS` as constant literal string array; converted to PackedStringArray during runtime encounter-roster assertion.
- Hid synthetic battle layer (`arena.visible = false`) so F6 benchmark statistics remain visible.
- **54/54 Godot smoke still pending user rerun after `git pull`**. New SVG art is visibly simplified compared with polished Knight/cemetery and is marked for a future art-quality pass; original new enemy identities, encounter card, combat Whistle and global scaling unchanged.

---

## 2026-10-14 — D144 first fully new-enemy combat card shipped (source, native Godot QA pending)

- New Tier0 **`bone_shepherd`** RunCardData and 2-formation EncounterData, with exactly **1 original Bone Shepherd commander + 2 original four-legged Ossuary Lambs**, no old enemies or moodboard extras; registered in RunState (Act1 pool 30→31, first-tier 10→11, run still 12 cards+boss XIII).
- Two completely new UnitData and original **pixel-form SVG sprite atlases** at `assets/pixel/units/deck_expansion_v1/{bone_shepherd,ossuary_lamb}_frames.svg` (576×480, 25 animation slots per role, idle/walk/attack/hit/death), plus original **448×274** `assets/pixel/card_unification_v1/run/bone_shepherd.svg` image. Godot loads SVG through Texture2D; text-based original artwork committed via connected UTF8 GitHub connector, not copied from old miniatures or the composite concept reference.
- New encounter-local `scripts/battle/bone_shepherd_whistle.gd`/WhistleData Resource: 5.5s initial delay, 0.65s visible warning, 1.25s movement-only ×1.35 joint Lamb rush to shared living hero, 8s repeat; safe leader death/no stack/clean end. Legacy combat targeting/scalers unchanged.
- New F6 scenes: `bone_shepherd_art_preview.tscn`, `bone_shepherd_smoke.tscn` (Whistle regression + 54 full-unit bouts), `bone_shepherd_playtest.tscn` (real battle UI). Static source/SVG/registry checks passed; **Godot 4.7 F6 engine and visual acceptance pending**.
- Documented implementation status in `docs/DECK_EXPANSION_BONE_SHEPHERD_PRODUCTION.md`, D144, PROJECT_STATE/ROADMAP/HANDOFF/CHECKPOINT; 14 further candidate cards not yet created, Fate Spread/DS2 and existing cards untouched.

---

## 2026-10-14 — New Bone Shepherd production-ready card package (design only)

- Added docs/DECK_EXPANSION_BONE_SHEPHERD_PRODUCTION.md: exact proposed Tier0 new combat card copy, unique Bone Shepherd ×1 and Ossuary Lamb ×2 UnitData, two authored deployments, measurable Whistle warning/shared-target bounded rush with preliminary timings/stats, unique genuine card + two enemy animation-art deliverables, Godot resource/file map and 54-combat test requirements.
- Confirmed spec uses existing UnitData, EncounterData, RunCardData, combat floor projection and animation B64 presentation. Existing 30-card pool, 12+XIII, seven approved two-layout combat identities, DS2/Fate Spread and 18 first-wave artworks unchanged.
- Only docs/handoff updated. No new sprites or code yet; next implementation step is authentic new creature artwork and full original-enemy combat slice.

---

## 2026-10-14 — First original-enemy Deck Expansion concept recorded (design only)

- After user explicitly agreed to begin new combat card content under D143, authored **`docs/DECK_EXPANSION_BONE_SHEPHERD_CONCEPT.md`** as the first Tier0 card brief for «КОСТЯНОЙ ПАСТУХ».
- Proposed genuinely new `bone_shepherd` tall crooked funeral herder and `ossuary_lamb` horned quadruped (two identical lambs) with original character silhouette/art, plus a readable telegraphed Whistle/short collective rush.
- **NOT SHIPPED:** no new RunState card, combat unit/encounter Resources, combat AI, sprite atlas or gameplay changes. Next gate is user's visual/mechanic approval; then complete 1+2 encounter including real art, tested in Godot.
- No alterations to existing thirty Act1 cards, DS2/Fate Spread, seven two-layout encounters, art and D142 old-balance follow-up.

---

## 2026-10-14 — D143 Act 1 new-card enemy contract recorded (docs only)

- User clarified: **any new card that leads to battle, including optional event combat, must introduce genuinely new enemy types and original battle visuals/mechanics**; no existing old enemies reused as “new” combat content.
- Existing planned 15-card expansion (30→45 Act 1 pool, 12 + XIII per run unchanged) requires per-new-encounter UnitData/art/AI/EncounterData/card identity. Preliminary named proposals imply **5** fight-bearing cards despite earlier “3 combats” shorthand; final production scope to be reconciled before shipping.
- Design constraint recorded in `docs/DECISIONS.md` D143. **No new cards, opponents, combat logic or artwork shipped.** D142 old-combat balance experiments remain separate.

---

## 2026-10-14 — D141 actual 126-battle traces analyzed (documentation only)

- Received both user-generated CSVs: **126 complete fight cases, 792 per-unit entries**, 66 wins/60 losses; 126/126 matched old D140 case outcomes and durations exactly; aggregate diagnostic totals reconcile to all per-unit rows.
- `last_bell` HUNT 4/18 vs ASSAULT/FORMATION 18/18: mean executed attacks 12.78 vs 18.78, actual damage 281 vs 395, enemy damage 234 vs 103, healing 41 vs 26; chase time similar. Likely early enemy exposure and lost DPS rather than merely longer pathing; causality not yet isolated.
- Knight late equipped solo 24/24 vs Knight+Ranger duo 0/24, trio 2/24; duo deaths occur before enough attacks and damage, with all 414 combined Knight+Ranger HP depleted each time. Solo scalars/positions require controlled follow-up before any tuning.
- Full report in `docs/TACTICAL_GAMEPLAY_V25_DIAGNOSTIC_REVIEW.md`. **No new combat logic/stat/AI/card/art changes**; next proposed D142 controlled A/B diagnostics and full real Act 1 QA require user approval.

---

## 2026-10-14 — D141 Gameplay 2.5: diagnostic-only combat telemetry

- User approved Gameplay 2.5 diagnostics after actual D140 270-result analysis showed HUNT weak (24/90) and late equipped Knight+Ranger duo 0/24 versus solo Knight 24/24 in matched scenes.
- Added optional `BattleUnit` signals `diagnostic_attack`, `diagnostic_damage`, `diagnostic_heal` for dev subscribers; all existing combat targeting/damage/heal/stat behavior unchanged.
- Added `scripts/dev/tactical_gameplay_v25_combat_diagnostics.gd` and `scenes/dev/tactical_gameplay_v25_combat_diagnostics.tscn`. **126 v24 exact-seed matched controlled BattleUnit bouts** (54 Last Bell bare + 72 Knight-led late equipped), instrument attack counts, actual damage incl splash, healing, target/chase seconds, movement and retarget counts.
- Write **two** per-case/per-unit CSV outputs (`user://misdeal_tactical_v25_trace_cases.csv`, `user://misdeal_tactical_v25_trace_units.csv`), documented in `docs/GAMEPLAY_V25_DIAGNOSTICS.md`. PASS would mean completion/file write, **not balanced gameplay or full Act 1**.
- Source checks passed; local Godot 4.7.x F6 for v25 **not yet performed**. Art, cards, encounters, global party stats/rewards and Fate Spread untouched.

---

## 2026-10-14 — D140 detailed CSV balance review (documentation only)

- Parsed actual user-provided `misdeal_tactical_v24_party_focus.csv`: 270 unique complete deterministic full-BattleUnit results, 158 wins/112 losses and no timeouts; report saved as `docs/TACTICAL_GAMEPLAY_V24_BALANCE_REVIEW.md`.
- **HUNT** 24/90 vs ASSAULT and FORMATION 67/90 each; HUNT wins no matched scenario where ASSAULT loses, but fails in 43 where ASSAULT wins. `last_bell` HUNT 4/18 vs 18/18 for each other order.
- Same-protagonist solo/duo/trio: 82/90, 30/90, 46/90; late equipped Knight solo 24/24 versus Knight+Ranger duo 0/24 and full trio 2/24. These results warrant diagnosis and full-run QA, **not automatic nerfs or global scaler edits**.
- No gameplay code, assets, enemy composition or balance multipliers changed; future diagnostic-first Gameplay 2.5 is proposed and **not yet approved**.

---

## 2026-10-13 — D140 local Godot 270-fight F6 passed (documentation only)

- User screenshot confirms `TACTICAL GAMEPLAY 2.4 — PASS`: 270/270 controlled full-BattleUnit simulations completed, **158 victories / 112 defeats**, HUNT common bellkeeper/wounded priority/nearby threat fixture passed.
- The CSV `user://misdeal_tactical_v24_party_focus.csv` is available locally in Godot user data, but has not been provided for case-by-case balance analysis.
- This checkpoint records local verification only; no new gameplay code, art, cards, enemy rosters, reward flow or scaler changes.

---

## 2026-10-13 — D140 Gameplay 2.4: coordinated Hunt focus and matched-party balance test

- User approved further HUNT double-healer focus and class/roster-controlled party-size comparisons.
- `scripts/battle/unit.gd`: HUNT now ranks healer/ranged targets by lowest health ratio then shared alive-party-center distance (healers remain above ranged). Nearest-melee fallback stays unchanged. Heroes using HUNT focus the same weakened support when possible; preserves D139 melee Knight immediate-danger interception.
- Added `scenes/dev/tactical_gameplay_v24_focus_party_benchmark.tscn` and dev GDScript with explicit two-bellkeeper focus/interception/return preview assertions and **270** controlled BattleUnit combat outcomes: 54 tier1 bare Last Bell, 216 tier2 equipped Ossuary Gate/Firing Square with fixed protagonists across party sizes, deterministic teammate order, 2 enemy layouts, 3 tactics, two late seeds.
- Exports `user://misdeal_tactical_v24_party_focus.csv` with party roles and separate game profile/seed/outcome/time/hero-enemy survivor fields. Uses authored existing hero upgrades and artifacts, baseline RunState multipliers; no global stat adjustments.
- **New F6 has not run in Godot yet**; previous v23 180 full-BattleUnit tests passed locally and v23 CSV analyzed. No changes to card identities, enemies, rewards, visual assets or Act 1 route.

---

## 2026-10-13 — D139 outcome CSV analyzed; targeted follow-up proposed (documentation only)

- Parsed actual user v2.3 Godot CSV: 180 complete cases, 79 wins/101 losses. Cross-joined original 72 v2.2 cases with corresponding v2.3 bare sample0.
- HUNT changed from **5/24 to 8/24** on matching cases (+4 new wins, -1 lost win); ASSAULT and FORMATION remained 13/24 each with identical outcomes/durations. `last_bell` HUNT remained 1/6, so D139 is a partial improvement, not total fix.
- Stage2 built loadout made 42/72 victories versus 6/72 bare; 36 matched cases improved and zero worsened. Late equipped solo 22/24, duo/trio 10/24 each, **but class/party confounding makes this a warning, not evidence for global scaling edits**.
- Detailed full review committed as `docs/TACTICAL_GAMEPLAY_V23_BALANCE_REVIEW.md`. Recommended next consent gate is HUNT support-target cohesion and better class-matched late-stage testing before any combat tuning.
- No gameplay scripts, enemy rosters, art, UI, rewards or combat coefficients changed.

---

## 2026-10-13 — D139 180-fight Gameplay 2.3 F6 validated locally (docs only)

- User screenshot confirms Godot `TACTICAL GAMEPLAY 2.3 — PASS`: **180/180** BattleUnit simulations completed with **79 victories / 101 defeats**, no timeout failures. Knight HUNT distant-support / near-threat interception regression passed.
- Results CSV written by Godot to `user://misdeal_tactical_v23_balance.csv`; detailed per-card/per-tactic/bare-versus-built analysis still pending user upload.
- Documentation-only acceptance checkpoint. No new code, balance, cards, enemies, artwork, rewards or visuals changed.

---

## 2026-10-13 — D139 Gameplay 2.3: melee HUNT interception and stage-aware benchmark

- User approved targeted HUNT logic refinement plus upgraded late-tier autobattle checks after analysis of 72 original v22 fights.
- `scripts/battle/unit.gd`: melee HUNT heroes (`attack_range<100`) intercept their closest immediate enemy when within 165 units and a support-priority target remains farther away; no changes to ranged hero target ranking, ASSAULT, FORMATION, AI abilities or enemy/combat stats.
- New isolated Godot F6 `scenes/dev/tactical_gameplay_v23_balance_benchmark.tscn`, script `scripts/dev/tactical_gameplay_v23_balance_benchmark.gd`: preflight checks three HUNT preview-target distances, then records 180 BattleUnit outcomes: tier-1 36 original bare comparisons, tier-2 144 comparisons across 2 deterministic seeds and bare/built profiles. `tier2_built` uses actual hero upgrade + class artifact Resources with same application order as production, one upgrade per present hero and one artifact for protagonist.
- Results exported to `user://misdeal_tactical_v23_balance.csv` with encounter, variant, party size, protagonist, order, profile, sample, result, simulated duration, survivors. PASS detects invalid/completion/timeouts, **not good balance**. Prior D136/D137/D138 Godot smoke were user-confirmed PASS, v23 local Godot run still pending.
- No changes to card contents, enemy rosters/position profiles, artwork, rewards, party-size multipliers or Act 1 (12 + XIII) progression.

---

## 2026-10-13 — D138 CSV balance review completed (analysis / docs only)

- User supplied actual `misdeal_tactical_v22_battles.csv`, parsed 72 full `BattleUnit` scenarios: 31 wins / 41 losses, 0 timeouts; group breakdown by card, party size, order and formation in new `docs/TACTICAL_GAMEPLAY_V22_BALANCE_REVIEW.md`.
- Most striking matched case: `last_bell`: HUNT 0/6 vs ASSAULT and FORMATION 6/6 each. Current HUNT target rank ignores distance; candidate tactical AI correction, **not yet implemented**.
- Bare tier-2 fights win only 3/36, but F6 excludes late build progression, so actual game balance cannot be inferred. Stage-aware benchmark proposed before encounter stat tweaks.
- No production combat behavior, encounter enemy rosters, art, DS2 or rewards changed.

---

## 2026-10-13 — D138 local full-battle F6 PASS verified (documentation only)

- Screenshot from the user's local Godot: `TACTICAL GAMEPLAY 2.2 — PASS`, **72/72** isolated full-BattleUnit baseline scenarios completed, **31 victories and 41 defeats**; four original cards × two authored layouts × solo/duo/trio × three tactical orders.
- The test wrote `user://misdeal_tactical_v22_battles.csv` with individual durations and survivor counts. The CSV has **not** been reviewed by assistant; the aggregate outcome is not a verdict on balance. Ask user for the CSV and actual Act 1 gameplay observations before modifying combat tuning.
- This commit updates handoff/test status only. **No combat data, game code, visuals, art or rewards changed.**

---

## 2026-10-13 — D138 Gameplay 2.2: four late-act tactical layouts and BattleUnit outcome benchmark

- User explicitly approved Gameplay 2.2 after accepting first three Gameplay 2.1 encounters.
- Added positional variants and distinct readable tactical tells to existing `gallows_volley`, `ossuary_gate`, `last_bell` and `firing_square` EncounterData Resources; the original enemy paths/names/card text/art/arenas/rewards are unchanged.
- Reused D137 formation selection and retry caching unchanged; existing baseline solo/duo/trio pressure and 3+2 orders, Wizard wagers/Mark and gameplay flow untouched.
- Added isolated F6 scene `scenes/dev/tactical_gameplay_v22_battle_benchmark.tscn` and GDScript: 72 controlled fixed-delta real BattleUnit autobattle runs (4 encounters × 2 authored layouts × 3 party sizes × 3 standard orders), comparing identical rosters/seeds for each order and writing outcomes, elapsed simulated time and hero/enemy survivor counts to `user://misdeal_tactical_v22_battles.csv`. Flags 75-second unresolved fights; not a proof of good win rates or complete Act 1/upgrade/reward coverage.
- **New F6 not executed in Godot by assistant; user local QA pending.** Earlier D136/D137 F6 tests passed per user. All 18 Wave 1 illustrations and DS2/Fate Spread preserved.

---

## 2026-10-13 — D137 local tactical F6 confirmed PASS (documentation checkpoint)

- User screenshot confirms Godot F6 `TACTICAL GAMEPLAY 2.1 — PASS` after pulling committed first-three-encounter gameplay: 54 setups, 324 initial target checks, 72 HUNT-vs-ASSAULT divergences.
- Verified card-faithful enemy rosters and stable retry formation; this test does not simulate combat wins. Next acceptance gate is live Bone Swarm, Iron Wall and Grave Bell battle observation across accessible solo/duo/trio parties, with orders/placement/rewards tested.
- **Docs-only checkpoint:** no production code, balance or art changed.

---

## 2026-10-13 — D137 Gameplay 2.1: encounter-authored deployments and solo Formation

- User confirmed the previous D136 48-run card-deal F6 simulation **PASS** in local Godot (not a complete real act-run confirmation).
- Introduced optional two-formation support in `EncounterData` and a per-card cached random variant in `RunState` that remains stable on retries and resets only with the run.
- `bone_swarm`, `iron_wall` and `grave_bell` now each have two authored positional formations and specific pre-battle placement tells. Enemy rosters, portraits/card IDs/arena IDs, unit stats and abilities are unchanged.
- Solo `FORMATION` now reduces incoming damage by 10%, making it a real defensive option rather than duplicating solo nearest-target behavior; `ASSAULT` retains movement advantage. Duo/trio orders and party-size pressure remain unchanged.
- Added `scenes/dev/tactical_gameplay_v21_smoke.tscn` F6 54-setup formation/party/protagonist/three-order target-preview and roster-fidelity regression with real BattleUnit instances. **Not yet run by user in Godot; not an end-to-end win-rate test.**
- Existing Act 1 deal/card economics, art wave 18/18, DS2/Fate Spread visuals, shops and boss mechanics untouched.

---

## 2026-10-13 — Gameplay 2.0 next-chat checkpoint (docs-only)

- Added complete `docs/GAMEPLAY_2_0_HANDOFF.md` and updated canonical `SESSION_CHECKPOINT`, `PROJECT_STATE`, `ROADMAP`, `HANDOFF` for fresh-chat continuation.
- Confirmed GitHub `main` already has D136 Gameplay 2.0 source (legally varied card offers, contextual Wizard tells and staged +20/+30/+40 Wizard Mark gold) and 48-run F6 regression scene. This is **implemented but not yet verified in Godot**.
- User previously reported art updates «Все ок» after resolving old local untracked WebP pull conflict. First wave **18/18 assets are in GitHub**, with approved DS2/Fate Spread retained.
- **No new production code, gameplay values, encounter data, visuals or assets changed** during this handoff-only update; next immediate action is `git pull` + F6 `scenes/dev/act1_gameplay_v2_smoke.tscn` and one real Act 1 run.

## 2026-10-13 — D136 Act 1 Gameplay 2.0: varied deals, Wizard voice and staged Mark rewards

- Updated `RunState` card-deal selection to soft-prefer content unlike the preceding two resolved cards, including mixed fight/nonfight pairs on unforced slots, while obeying each tier, mandatory combat slot, Fate Hold, Wizard Meddling and remaining-card rules.
- Reused the 30 existing authored regular cards and 14 authored encounter setups; combat AI, enemies, party-size scalars, Fate Spread layout and boss progression unchanged.
- Wizard Mark now pays **20/30/40 gold** across early/mid/late act tiers against the existing **+15% enemy next-battle damage**. Card hint, hover tooltip, pick confirmation and Wizard memory use the dynamic exact amount.
- Added alternating contextual Wizard remarks reacting to fight/event streaks and late solo/trio state without overriding debt, active wagers or priority Wizard memories.
- Added dev-only 48-run seeded F6 replayability/forced-combat/solo-duo-trio regression: `scenes/dev/act1_gameplay_v2_smoke.tscn`.
- GitHub source integration verified; **real Godot engine QA pending**. All approved DS2 interfaces and 18 first-wave art files untouched.

## 2026-10-13 — D135 complete 18/18 first-wave card illustrations in GitHub

- User accepted five additional paintings: Gravedigger Shop dealt card, Bone Swarm combat card, Grave Crossfire combat card, Candle Seller event and Last Camp event.
- Added three 448×274 and two 1280×720 standalone WebP **binary assets** to GitHub main (`ac860ad2`), verified all GitHub blobs and WebP format.
- Extended `card_unification_v1.gd` validated/fallback-aware RUN_CARDS and EVENTS mappings so existing real game art resolution loads the new artwork without altering gameplay or UI.
- Added standalone F6 preview scene `scenes/dev/card_unification_final5_preview.tscn` for deterministic local inspection.
- D131+D132+D134+D135 first-wave illustration delivery now `18/18` images in repo; local Godot runtime/visual smoke still needed.

## 2026-10-13 — Remaining five Wave 1 artwork concepts prepared

- Identified five candidates beyond the approved 13 D130 pictured compositions: shop, bone swarm, grave crossfire table cards; candle seller, last camp event backgrounds.
- Created `docs/CARD_ART_WAVE1_REMAINING5_BRIEF.md` with precise distinct subject briefs, expected production sizes, safe art override paths and frozen-interface constraints.
- New image generation did not follow these candidate briefs and instead duplicated the already-shipped five upgrade/reward artworks; rejected with **no gameplay, runtime, binary art or UI changes**.
- Five proposed images remain unapproved; latest five D134 artwork integration still awaits explicit in-Godot confirmation.

## 2026-10-13 — D134 final 5 approved hero upgrade and reward card assets delivered

- Added five standalone user-approved high-resolution card illustrations as actual binary 608×388 WebP in `assets/pixel/card_unification_v1/{upgrade,reward}/` (GitHub main commit `e3729a4a`): Knight Iron Oath, Ranger Arrowstorm, male gray-bearded Mage Glass Heart, Gold Windfall, skeletal hand gripping a red jewel for Relic Wager.
- Confirmed all five remote GitHub blobs and the five-file diff. Existing ID-keyed `CardArtCatalog` override selects them with legacy fallbacks; no gameplay/UI changes.
- **13/13** D130 pictured compositions now present as committed binary textures, separate from five other Wave 1 candidates not depicted or approved.
- Godot F6 and real reward/upgrade visual smoke pending; no manual ZIP installation required.

## 2026-10-13 — D132 live art confirmed, final five art briefs drafted (D133)

- User confirmed D132 new event art appeared correctly after the earlier live card/tint fix; fixed visuals recorded as accepted.
- Authored `docs/CARD_ART_WAVE1_FINAL5_BRIEF.md` specifying separate production art for the remaining three hero upgrades and two reward images with all D130 corrections intact.
- Image generation in this session twice returned obsolete four-event compositions, so those results were explicitly rejected and **no additional art binaries or game code were changed**.
- Five new individual illustrations and Godot verification remain future work.

## 2026-10-13 — Restore visibility of four D132 event illustrations on deal table

- Fixed missing art on four table/deal cards: `curse_forge`, `black_altar`, `chained_prisoner`, `rattling_bridge` now use center-cropped cached 448×274 thumbnails from the already committed full-resolution event images instead of legacy v4 atlas.
- Reduced DS2 scene background shading only for events with these valid new artworks so they are visible behind choice UI.
- No additional images, mechanics or unrelated UI edits. Local Godot smoke still required.

## 2026-10-13 — Four approved Act 1 event backgrounds shipped (D132)

- Converted four exact user-approved individual full-resolution images to 1280×720 WebP (quality 91): Curse Forge, Black Altar, Chained Prisoner, Rattling Bridge.
- Committed binary assets to `assets/pixel/card_unification_v1/event/` in GitHub main commit `1722d070`; verified each remote blob and 4-file-only diff.
- Earlier optional `card_unification_v1.gd` / ActChoice art loading automatically activates images with original background fallback; no gameplay/UI/code changes in art commit.
- Previous D130 small-crop event images superseded. Source-verified, Godot visual confirmation pending. With four D131 run cards, **8/13** approved compositions are now committed as runtime assets.

## 2026-10-13 — Four D131 approved Act 1 table-card images deployed

- Added real binary 448×274 WebPs in `assets/pixel/card_unification_v1/run/` for Bone Patrol, Graveyard Ambush, Gallows Volley, Whispering Well, from the exact final user-approved individual PNGs (commit `9d864113`).
- Existing optional CardArtCatalog resolver immediately uses these after pulling; old atlases remain preserved and as fallback.
- Confirmed four GitHub blob hashes. No screen layout or gameplay changes. Godot runtime inspection still required.
- Previous chat ZIP's blurred four D130 crops are superseded and should not be re-extracted over tracked assets.

## 2026-10-13 — Four deal-card artwork approvals (D131)

- User approved the four latest high-resolution images for Bone Patrol, Graveyard Ambush, Gallows Volley and Whispering Well after rejecting fuzzy art and cloned AI-looking figures.
- These replace the four older concept-board card crops; remaining nine approved D130 compositions stay accepted.
- Documented filenames, generation IDs and restrictions. No new image binaries, game code or UI changed in this documentation-only approval checkpoint.

## 2026-10-13 — Optional D130 card-art gallery

- Added standalone Godot F6 gallery scenes/dev/card_unification_v1_preview.tscn to preview all 13 candidate assets and report missing files without entering a random run.
- Does not change runtime mechanics or include the binary WebPs in GitHub.

## 2026-10-13 — Source hook for D130 card-art candidates

- Added scripts/ui/card_unification_v1.gd with ID-keyed optional standalone WebP texture paths, size/decode validation and original-art fallback.
- Added narrow lookup integration in scripts/ui/card_art_catalog.gd and scripts/event/act_choice.gd; no gameplay or layout edits.
- Generated a 13-WebP ZIP and visual contact sheet from approved D130 concept, as conversation-only artifacts (NOT binary assets committed to GitHub). These candidate images need visual quality verification in Godot.

## 2026-10-13 — Final card-art concept board accepted (D130)

- User approved the last concept illustration sheet after refinements to Gallows Volley (few archers with bows only), gray-bearded male Mage, and Relic Wager (skeletal hand holding red gemstone).
- Recorded all 13 pictured compositions as binding visual reference in `docs/CARD_ART_UNIFICATION_WAVE1.md`; clarified 5 other candidate Wave 1 images were not pictured.
- Documentation-only acceptance checkpoint: no PNG binaries, `.gd` wiring, texture swaps or gameplay changes committed.

## 2026-10-13 — Bulk DS2 visual acceptance

- User reviewed the consolidated production Design System 2.0 update in local Godot and confirmed «все хорошо».
- Marked bulk visual styling as accepted; no code, assets, layout or mechanics modified in this checkpoint.
- Next focus shifts to Act 1 gameplay/content and replayability; exhaustive conditional gameplay regression checks remain separate.

## 2026-10-12 — Bulk Design System 2.0 UI adoption

- Added `scripts/event/act_choice_ds2.gd` for remaining shared event screens: original story art + tactile choice cards, dynamic Cyrillic details, original choice input and state, centered variable-count rows, result footer.
- Introduced `scripts/ui/misdeal_ds2_rollout.gd` and applied it to Class Select, Squad Status, Run End, Battle HUD and Table/Wizard Wager chrome.
- Preserved already-approved Fate Spread, main/intro art, Reward, Whispering Well and Gravedigger Shop interfaces. No gameplay handler or `.tscn` modifications.
- GitHub source/scene path checks passed; consolidated Godot runtime/visual smoke still required.

## 2026-10-12 — DS2 production Gravedigger Shop

- After user approval of corrected F6 preview, enabled the approved bronze/parchment store presentation for `gravedigger_shop` only.
- Added `scripts/event/gravedigger_shop_ds2.gd`: authentic run gold and variable Lost Purse-adjusted price, party/upgrade availability states, existing role art and choice buttons, full offer tooltips, result footer and table return.
- `scripts/event/act_choice.gd` uses a card-id-guarded presenter call and shop-only resolved footer/coin refresh. Original shop transactions and other events are unchanged.
- Source comparisons passed; local Godot gameplay validation still pending.

## 2026-10-12 — Shop preview typography follow-up

- Fixed potential initialization-order issue in F6 shop preview: populate authored Label copy after controls are parented and positioned, because screenshot showed dynamic prices but missing static headings/details.
- Added clearer disabled-card dimming and contextual affordability text colors. Production shop untouched; local Godot confirmation outstanding.

## 2026-10-12 — Gravedigger Shop design preview

- Added isolated `design_system_v2_shop_preview` Godot F6 scene with three illustrated DS2 merchant choices and non-gameplay affordability / role-availability interactions.
- Production shop, real prices, purchases, events and accepted Fate Spread/Reward/Well art remain untouched.

# Changelog

## Unreleased

### Documentation — compact next-chat restart checkpoint (2026-10-12)

- Added `docs/SESSION_CHECKPOINT.md` with accepted Fate Spread/Reward/Whispering Well visual baselines, outstanding functionality checks and the scoped Gravedigger Shop F6 preview as next task.
- Linked the checkpoint from `AGENTS.md`, `docs/PROJECT_STATE.md` and `docs/HANDOFF.md`. No gameplay code or assets changed.


### Accepted — Whispering Well live DS2 layout (2026-10-12)

- User verbally confirmed final production Whispering Well card-row alignment and text treatment in local Godot after `1adc634`; marked visually accepted in decision D126 without requiring an extra screenshot.
- Identified scoped Gravedigger Shop DS2 preview as next task; shared `act_choice.gd` must not be globally restyled. No game code or art changes in this checkpoint.


### Fixed — Whispering Well card row center and clipped recruitment copy (2026-10-12)

- Corrected HBoxContainer's inherited old-width/min-size artifact: normalize child minima before sizing, use a centered 928px three-card row with deferred final layout (`1adc634`).
- Restored full two-line recruit outcome copy and added warning bottom clearance; normalized top-aligned event description. Original gameplay and art unchanged; Godot screen recheck pending.


### Changed — Whispering Well final DS2 alignment (2026-10-12)

- Aligned live event header and all three card titles, effect rows, descriptions and reserved warning strip (`c513b63`).
- Kept unavailable-choice text concise while preserving full real offer in tooltip (`dd4b486`).
- Confirmed original seven gameplay and illustration methods unchanged; local Godot visual recheck pending.


### Fixed — Live Whispering Well header overlap (2026-10-12)

- Adjusted DS2 header narrative/title positions and restored previously occluded gold/party counters over the opaque panel after real Godot screenshot review (`2a0baab`). Cards and event gameplay unchanged; in-engine recheck pending.


### Changed — DS2 production Whispering Well event (2026-10-12)

- Migrated live Whispering Well choice UI to approved Variant C / DS2 wood, bronze and parchment with real approved choice illustrations and dynamically rendered choice text (`238c75b`, `ce5a35f`).
- Added readable disabled-card state and selected border feedback (`f7c9fbc`, `3480acf`).
- Source-diff verified that all seven original choice/resolve/cost/return handlers are unchanged. Actual Godot event gameplay and visual acceptance pending; no new reward mechanics.


### Added — DS2 Whispering Well review scene (2026-10-12)

- New F6-only interactive event preview with approved Whispering Well illustrated backdrop and existing choice art, bronze/card/parchment material style and three authentic recruitment choices.
- Preview-only selection, inspect and simulated insufficient-gold disabled state; no changes to live event, RunState, reward logic or approved Fate Spread.
- Godot 1280×720 visual review and production migration approval pending.


### Added — DS2 Event visual preview (2026-10-12)

- Added F6-only Whispering Well card choice study with existing game art, Variant C backdrop, shared bronze/parchment UI styles and non-gameplay selected-card interaction. Production event scenes and logic untouched; Godot visual review pending.


### Approved — Live Reward major-upgrade UI visual baseline (2026-10-12)

- User accepted actual Godot 1280×720 production `РАЗВИТИЕ ОТРЯДА` with three upgrades (Knight/Ranger/Knight) in DS2 blackwood, bronze and parchment style; locked in D124.
- Acceptance documents the live screen's appearance only. Other reward modes and claim/navigation flows remain pending verification. No code or game-art changes at this checkpoint.


### Changed — Design System 2.0 live Reward screen (2026-10-12)

- Migrated production Reward presentation from colored panels to approved Fate Spread material language: existing Variant C table background, dark card chrome, aged bronze and parchment with actual dynamic offer art/text (`9a5594b`, `5d121d8`).
- Updated card copy layout for long reward/upgrade effect rows and bounded descriptions with full-text tooltips (`29a797d`).
- Retained all five reward modes, original click-to-claim handlers, RunState grants and navigation; no original Fate Spread or battle mechanics changes.
- Local Godot 4.7.x runtime visual/gameplay QA pending.


### Fixed — DS2 Reward preview overflowing descriptions (2026-10-12)

- Fixed bounded title/effect/description wrapping on the three preview parchment cards, adjusted typography and guarded clipping (`dac4953`). Production Reward and gameplay unchanged; local F6 verification pending.


### Added — Design System 2.0 isolated Reward preview (2026-10-12)

- Added independent F6-only Death Wager reward presentation using the approved Variant C table backdrop and real reward illustrations, with functional hover/selection/inspect feedback but no gameplay grants.
- Added opt-in material, parchment and reward-card components in \`MisdealUIKit\`; unchanged production reward and Fate Spread.
- Godot 1280×720 screenshot and user sign-off pending before any runtime UI migration.


### Design — Fate Spread becomes canonical Design System 2.0 reference (2026-10-12)

- Documented user-approved Fate Spread Variant C as primary whole-game visual reference and introduced opt-in dark wood/ritual red/aged bronze/parchment/moonlit steel material palette.
- Added non-breaking `MisdealUIKit` constants for future isolated preview and phased UI migration. Existing production visuals and gameplay remain unchanged.


### Changed — Compact gothic unit health tracks (2026-10-12)

- Restyled battle health indicators into smaller dark framed progress bars with subdued green/red fill and boss width variant, without changing HP updates or combat mechanics. Local Godot visual review pending.


### Fixed — Mage clean-atlas scale (2026-10-12)

- Reduced Mage art-only display multiplier from 1.65 to 1.25 after new atlas appeared too large relative to Ranger; no gameplay or asset changes.


### Fixed — Mage alpha/art quality and complete attack frames (2026-10-12)

- Replaced fading Mage sheet with approved solid-bearded-purple-robe 25-pose atlas (`9d72854`), archived old file (`089b9fd`).
- Fixed Mage playback to use all six attack poses (`6ce91f9`), retaining existing projectile gameplay FX.
- Preserved hero Mage scale 1.65 and all other roles. Godot visual acceptance outstanding.


### Fixed — Elder Mage undersized in battle (2026-10-12)

- Raised Mage hero-only sprite multiplier from 1.15 to 1.65 after Firing Square screenshot; Knight and Ranger unchanged, no combat physics or mechanics changed.


### Fixed — Hero display scale normalization (2026-10-12)

- Added hero-only scale factors in `BattleUnit` to align Knight (0.90), Ranger (1.00) and Mage (1.15) artwork in shared battle scenes; enemy scale and gameplay physics unaffected.
- Existing animated sole-based ground positioning uses final scale; Godot visual review remains pending.


### Changed — Bearded elder Mage animation (2026-10-12)

- Replaced Mage Pack 1 v2 atlas with user-approved older white-bearded purple-robed staff wizard (`3e23cc8`), preserved previous atlas as `mage_archived_pre_oldbeard.webp.b64` (`4c0e94a`).
- Verified exact Base64 resource in GitHub; offline 576×480/25 used-frame grid checks passed.
- Existing Mage loader and combat gameplay untouched; Godot F6 and actual battle visual inspection pending.


### Changed — Approved blue Knight frame animation (2026-10-12)

- Archived old malformed Knight v2 atlas and replaced production `combat_units_anim_v2/knight.webp.b64` with approved 25-pose blue Knight atlas, preserving readable leg/boot separation.
- Re-enabled Knight SpriteFrames in live `BattleUnit`; existing static v4 fallback remains. Ranger, Mage, Skeleton, Bone Archer and all Pack 2 enemies unchanged.
- Offline grid/alpha/grounding tests passed; Godot 4.7.x F6 and actual combat motion checks pending. No targeting, stats, balance or encounter changes.


### Added — Bone Warden frames and Pack 2 roster completion (2026-10-12)

- Committed user-approved 25-frame transparent 576×480 Bone Warden atlas (`77a759d`) and verified identical remote Base64 content.
- Enabled Bone Warden SpriteFrames (`1238b3c`) using existing Pack 2 path and static-v4 fallback. All four previously static Pack 2 undead enemy roles now have true frame art available in the live animation library.
- Local Godot F6 and combat-quality acceptance is still outstanding; no AI, HP, combat damage or phase changes. Knight remains static v4 until a new leg-readable sheet is approved.


### Added — Crypt Guard frame animation (2026-10-12)

- Committed approved transparent 576×480 Crypt Guard atlas with Idle4 / Walk6 / Attack6 / Hit3 / Death6 (`5412b1d`), source-to-remote verification succeeded.
- Enabled Crypt Guard through the existing Pack 2 animation loading path with static v4 fallback (`fa78548`). Bone Thrall and Grave Bellkeeper unchanged, Bone Warden remains static.
- Local Godot animation and combat QA outstanding. No balance or tactical behavior changes.


### Added — Grave Bellkeeper Pack 2 frame animation (2026-10-12)

- Added approved 25-pose transparent 576×480 Grave Bellkeeper WebP/Base64 atlas in `combat_units_anim_pack2_candidates/`, exact GitHub content verified.
- Enabled `grave_bellkeeper` via existing animation library with static-v4 fallback, joining Bone Thrall. Knight, other Pack 1 roles and remaining two static enemies unchanged.
- Godot F6 and actual battle visuals await local testing; no gameplay or stat changes.


### Added — Bone Thrall Pack 2 25-frame atlas (2026-10-12)

- Committed approved transparent 576×480 lossless WebP Base64 sheet (`assets/pixel/units/combat_units_anim_pack2_candidates/bone_thrall.webp.b64`, commit `29d0725`); verified exact remote content.
- Previously added optional `bone_thrall` loader now resolves this real asset and uses Idle/Walk/Attack/Hit/Death frames with existing v4 fallback. Combat stats, damage, AI, placement and other character models unchanged.
- Godot 4.7.x F6 and live combat animation verification pending. Bellkeeper, Crypt Guard and Warden sprite sheets not yet authored.


### Changed — Bone Thrall animation loading bridge (2026-10-12)

- Added optional `bone_thrall` SpriteFrames path to production animation library; missing atlas automatically falls back to existing v4 sprite. No combat timing/AI/stat changes.
- Approved and encoded RGBA Bone Thrall 25-frame art locally but its Base64 asset **is not yet committed to GitHub**, so this is not an active art switch. F6 and combat visual smoke pending.


### Docs — Undead animation frame production briefs (2026-10-12)

- Added explicit 25-pose storyboards and visual acceptance checks for Bone Thrall, Grave Bellkeeper, Crypt Guard and Bone Warden in `docs/UNIT_ANIMATION_PACK2_FRAME_BRIEFS.md`.
- Clarified sequence: four key-pose proofs → four real transparent sheets → importer/validator → Godot F6 review → explicit approval → cautious per-role activation.
- **No new sprite sheets supplied or generated; no production combat models switched.** Knight stays static v4 and current combat animations/VFX are unchanged. Runtime F6 QA remains pending.


### Docs — Pack 2 Stage B preparation complete; spritesheets remain outstanding (2026-10-12)

- Final GitHub handoff verification: all staging tools/preview files are present; all four expected `{role}.webp.b64` candidate paths are missing; production `BattleUnit` and animation loader were not migrated. No new game art is claimed.


- Pinned the canonical checkpoint for new chats: the offline importer, candidate-only Godot QA, F6 v4-vs-candidate review and staging documentation are implemented in GitHub.
- Confirmed that no real frame sheets exist for Bone Thrall, Grave Bellkeeper, Crypt Guard or Bone Warden; **zero new combat models were switched**. Stage A contact VFX and current Knight static v4 / other Pack 1 frame animations are unchanged.
- Next step: author genuine transparent 576x480 spritesheets, validate/stage, inspect and approve all five states in F6 before any production changes. No Godot F6 runtime validation was performed during this documentation pass.

### Added — Pack 2 Stage B validation and art staging (2026-10-12)

- Added a 6×5 RGBA sprite-sheet importer using lossless WebP Base64, rejecting empty, opaque, mismatched or duplicated animation rows, with grounding/edge warnings; tested on valid older artwork and deliberately invalid opaque art.
- Added optional in-Godot candidate frame validation and an F6 side-by-side gallery showing each of the four static v4 enemy silhouettes beside prospective new Idle/Walk/Attack/Hit/Death clips.
- Added a dedicated candidate folder/documentation; when no real sprite sheets exist, preview explicitly indicates the missing art. **No live combat sprite or mechanical changes.** High-quality authored enemy animation artwork is still pending.


### Added — Undead Pack 2 Stage A, attack-contact effects (2026-10-12)

- Added small role-specific impact accents for static Bone Thrall, Grave Bellkeeper, Crypt Guard and Bone Warden; native Godot Line2D/Tween effects end after 0.17–0.36 seconds and self-delete.
- Connected them to the live `BattleUnit` attack trigger, without delaying damage or changing AI, HP, cooldowns, tactics, art or floor offsets.
- Added `scenes/dev/unit_undead_fx_preview.tscn` F6 gallery with real static v4 enemies and interactive buttons, and `docs/UNIT_ANIMATION_PACK2.md` for Stage A/Stage B distinction.
- Actual multi-frame animations for those four enemies are **not yet created**. Local Godot smoke pending.


### Fixed — Knight silhouette readability (2026-10-12)

- Temporarily replaced the malformed Pack 1 animated Knight with the existing static v4 Knight sprite showing readable independent armored legs and boots; Ranger, Mage, Skeleton and Bone Archer remain animated.
- Restored an appropriate Knight-only v4 floor offset from -16 to -8px instead of endlessly lifting the faulty animated frames. Kept animation atlases for a future proper redraw.
- Preserved existing combat damage/movement/tactical rules, enemy facing, ring contact and UI. Local Godot visual check pending.


### Fixed — Knight visual floor alignment (2026-10-12)

- Raised the Knight's art-only floor offset by another 4px (`-12.0` → `-16.0`). Other roles and game mechanics unchanged; local visual verification pending.


### Fixed — Knight floor-contact refinement (2026-10-12)

- Raised Knight render position 2px through `ROLE_FLOOR_OFFSETS["knight"] = -12.0`, preserving all other roles and combat mechanics. Local Godot visual verification pending.


### Fixed — Knight visual ground-contact fine-tune (2026-10-12)

- Raised Knight's rendered miniature another 2 px via `ROLE_FLOOR_OFFSETS["knight"] = -10.0`, preserving other role offsets, artwork and combat physics.


### Fixed — Knight foot alignment (2026-10-12)

- Fine-tuned Knight's visual-only floor offset from −6 px to −8 px, without touching Ranger or other units. Visual check in local Godot pending.


### Fixed — Knight ground offset fine-tune (2026-10-12)

- Changed the Knight's visual-only floor offset from −4 px to −6 px to match the Ranger after side-by-side gameplay screenshots; no scene layout, animation atlas or combat logic change. Local Godot visual verification pending.


### Fixed — Per-role foot-floor visual calibration (2026-10-12)

- Applied optically calibrated sprite-only floor offsets for all five animated roles and four remaining static-v4 undead roles in `BattleUnit`; offsets lift characters by 4–7px where boots looked buried.
- Unified the sprite's initialized, idle, hit/attack-rest and old static death positions through `_art_rest_position()`, without changing the arena contact shadow or battle mechanics.
- Maintained Pack 1 v2 assets, unit world coordinates, HP/name overlays, enemy facing and all ability timings. Local Godot visual validation pending.


### Fixed — Unit Animation Pack 1 jitter and grounding (2026-10-12)

- Rebuilt all five Pack 1 WebP frame atlases as **v2**, eliminating orphan artwork from adjacent spritesheet rows and grounding all active frames to a uniform alpha sole y=92. Preserved the previous v1 atlases for rollback.
- Adjusted live `BattleUnit` animation baseline against the existing y=36 shadow/floor ring, including per-role art scale and attack tween recovery.
- Slowed Idle/Walk, staggered initial idle phase and debounced walk/idle state changes to reduce abrupt motion while preparing and during crowded autobattles.
- No balance/AI/sprite-facing/arena layout changes; exact uploaded asset equality and contact-row consistency checked. Local Godot smoke still required.


### Added — Unit Animation Pack 1 (2026-10-12)

- Added five transparent 576×480 animation WebP atlases, with 96×96 frames stored as Base64 resources, for Knight, Ranger, male Mage, Skeleton and Bone Archer.
- Added cached `SpriteFrames` animation library and actual Idle/Walk/Attack/Hit/Death frame states in live `BattleUnit`; static v4 remains fallback and all other roles are unchanged.
- Added in-Godot F6 animation gallery with actual `AnimatedSprite2D` samples and state buttons, plus `docs/UNIT_ANIMATION_PACK1.md` with export specs.
- Maintained existing damage/AI/skill/placement mechanics, enemy facing, battle art and HP/name UI. Runtime screenshot/interaction check pending.


### Changed — Design System Package 3 core screen pass (2026-10-12)

- Migrated production menu/intro, class selection, tabletop, battle prep and run-end copy to shared screen-readability colors/shadows while keeping their font sizes, layout geometry and painted backgrounds.
- Replaced local tabletop offer-card `StyleBoxFlat` constructors with the shared exact visual variant for normal, held, Wizard-marked and boss cards.
- Added clear persistent selected styling for the active battle tactical order via `MisdealUIKit`, without modifying the order toggle/AI/stat mechanics or the available 3–5 order layout.
- Preserved fully transparent splash/intro hotspots and unchanged positioning of all scene elements; Godot 4.7.x gameplay/visual smoke is still pending.


### Changed — Design System 1.0 Package 2 Components (2026-10-12)

- Moved duplicate compact battle panel/button `StyleBoxFlat` code from `battle.gd` into the shared `MisdealUIKit`, keeping prior visual numbers and game geometry intact.
- Added opt-in components: selected button styling, inset card surface, readable tooltip panel/native tooltip factory, plus reusable tooltip-enabled Button.
- Added isolated interactive Components preview scene for default/hover/pressed/disabled/selected buttons, cards, HUD modular plate and Russian hover tooltip.
- Updated Design System docs and continuity files. Existing game art, card/battle mechanics, HUD positions and table presentation are unchanged; Godot F6/local gameplay review pending.


### Added — Misdeal Design System 1.0 Foundation (2026-10-12)

- Added shared design tokens to the already-used `MisdealUIKit`: semantic palette, typographic roles, 4px spacing, border weights, button-height guidelines and advisory UI layer bands for a 1280×720 baseline.
- Added opt-in `apply_text_role` and `apply_button_minimum` helpers without changing existing table/combat sizing or navigation.
- Added `docs/DESIGN_SYSTEM.md` and a standalone in-Godot UI review scene at `scenes/dev/design_system_foundation_preview.tscn`, previewing palette, sample panels, buttons and Cyrillic type.
- All approved gameplay scenes, art and mechanics remain unchanged; new reusable component/style migration and any screen restyling are separate reviewed follow-up packages.


### Fixed — unit facing and male Mage (2026-10-12)

- Enemy combat miniatures start facing toward the hero side and turn to face their current target as combat progresses; rim silhouettes mirror with them instead of appearing backwards after encounters shift.
- Replaced only the active Mage role art with the approved bearded male Mage 96×96 transparent WebP tile; kept the original 3×3 v4 atlas as fallback and archived a lossless PNG source for future edits.
- No changes to attack mechanics, AI targeting, stats, arenas or player placements.


### Added — Approved Combat Unit Art v4 (2026-10-11)

- Replaced all nine combat miniature atlas roles with approved dark-Gothic character cutouts (Knight, Ranger, Mage, Skeleton, Bone Archer, Grave Bellkeeper, Bone Thrall, Crypt Guard, Bone Warden).
- Added the 288×288 3×3 WebP atlas at `assets/pixel/units/combat_units_v4/atlas.webp.b64` and its lossless PNG source archive.
- BattleUnit now decodes/caches the new WebP and automatically falls back to preserved v3 PNG assets if v4 is absent or invalid. Original v3 art is untouched for rollback.
- This is an art-only upgrade; no combat mechanics, stats, arena backgrounds or placement rules changed. Local Godot playtest is pending.


### Changed — Unit Readability Pass (2026-10-11)

- Enlarged live combat art silhouettes by about 10% for heroes, 8% for regular enemies and 5% for the boss, while keeping combat radii/physics unchanged.
- Tuned restrained cold/warm sprite contours and a subtle dark local backdrop to distinguish units on dense arena art without neon outlines.
- Kept contact shadows aligned with adjusted sprite anchors and moved health/name offsets to accommodate larger artwork.
- Staggered hero-only initial trio/duo positions inside each legal battlefield placement profile, including split lanes and two pockets.
- Widened the mouse pickup hit region over visible hero sprite art so dragging the enlarged figures is reliable.
- Preserved approved arena images, drag-only deployment glow, all enemy composition/AI, tactical orders and battle balance.


### Changed — quieter battle placement feedback (2026-10-11)

- Replaced always-on outlined deployment rectangles and 3×2 floor markers with a subtle floor glow that appears **only while dragging a hero** and derives from the true legal placement regions.
- Extra hero placement ring is visible only on the dragged unit; persistent contact shadow and restrained team ring remain.
- Gameplay, spawn/depth alignment, approved arena artwork and tactical command HUD remain unchanged.


### Fixed — battle-floor grounding and preparation markings (2026-10-11)

- Reprojected legacy authored encounter spawn depth into the actual playable floor of Arena Redraw v2; combat bounds now keep figures from entering distant scenery, including reinforcement spawns.
- Shifted free hero deployment and its special split/deep/pocket patterns onto the visible floor; clamped initial hero positions to their legal regions.
- Added `deployment_floor_markers.gd`: live warm-chalk circles and region edges that reflect real drag limits and disappear at Fight. These are visual hints for free placement, not fixed tile slots; they replace barely visible debug rectangles.
- Aligned contact shadows, team rings and the placement highlight with the sprites' feet. Enemy stats, AI targeting, tactical orders, encounter rosters and rewards were not changed.
- Kept existing approved v2 WebPs intact; experimental chat-only art with baked circles is not an active game dependency. Local Godot playtest is still required.


### Changed

- Integrated **Arena Redraw v2 package 1**: ten approved 1280×720 WebP battle backgrounds (`crypt`, `graveyard`, `gallows`, `ossuary`, `warden`, `bone_crush`, `bone_swarm`, `grave_crossfire`, `iron_wall`, `last_bell`). They now load from `arena_redraw_v2/`; `firing_square` and `bone_ritual` deliberately stay on the old v1 set pending package 2.
- `AuthoredBackdrop` reads native WebP bytes for the new images and still decodes Base64-WebP for the two untouched arenas. Old art is retained for rollback; combat/UI logic is unchanged.
- Updated arena design direction to give each fight a distinct readable landmark without repeating distant castles and ornamental clutter.


### Added

- Archived the six user-approved Combat Expansion v1 composite source masters under `assets/source_archive/combat_expansion_v1/` and added a top-level handoff checkpoint so a new chat can continue from the fully integrated arena/card-art state without reconstructing this session.
- Added Combat Expansion v1: six new Act 1 combat cards are now in the random tier pools — КОСТЯНОЙ РОЙ, МОГИЛЬНЫЙ ПЕРЕКРЁСТОК, ЖЕЛЕЗНАЯ СТЕНА, ПОСЛЕДНИЙ ЗВОН, РАССТРЕЛЬНАЯ ПЛОЩАДЬ and КОСТЯНОЙ РИТУАЛ.
- Added two lightweight enemy stat archetypes for encounter variety: Костяной налётчик (fast fragile pressure) and Склепный часовой (lighter AOE guard). They intentionally reuse the closest existing production combat silhouettes for this gameplay-validation pass.
- New fights reuse proven arena/deployment profiles: swarm split lanes, crossfire/firing-square deep-line placement, and support/ritual pocket placement. Threat tags and preparation cues expose the tactical problem before Fight.

- Added Fate Spread chosen/rejected pair history: hovering a completed slot enlarges it and shows which card was chosen and which alternative was rejected at that deal.
- Added one-shot IV/VIII/XII Fate Spread ritual beats with automatic reveal, seal/XIII pulse-shake and a dedicated generated table sound.
- Added a restrained procedural red-black table surface beneath the Fate Spread ring to keep the progression screen physically grounded in the cursed table.

- Added a live occult seal/fate-thread layer to `РАСКЛАД СУДЬБЫ`, including completed-path glow, chapter gates and a progressive XIII chain/seal that weakens as Act 1 advances.

- Added `РАСКЛАД СУДЬБЫ`, a live Act 1 progress view with twelve chronological card slots, a sealed central XIII/Bone Warden card, held-card display and Wizard rejected-card discard; open it from the table with `R` or the new button.

- Added live pre-battle first-target intent arrows: blue for hero focus under the selected tactical order, red for enemy focus under current placement.

- Added a persistent `SceneTransition` autoload veil that survives scene replacement and covers runtime texture setup between screens.

- Added `scripts/ui/misdeal_ui_kit.gd`, a shared runtime gothic/pixel chrome layer with reusable panel, card, action-button, chip, corner-mark and title treatments.
- Applied the shared UI kit across the main menu, intro, Class Select, Wizard table and wager, Squad Dossier, Act 1 events, Whispering Well, Reward, Battle HUD/Last Deal and Run End.

- Added durable project handoff and visual asset registry documents so a fresh Project chat can continue without reconstructing the visual-history transcript.
- Archived the eight final V9 generated event masters at 1672×941 under `assets/source_archive/visual_pass_v9/` for future crop/re-export work.
- Added the final V9 generic-event environment batch for Rattling Bridge, Lost Purse, Debtor Bones, Bone Tax, Wizard Tithe, Ash Rest, Last Camp and Broken Crown.
- Added dedicated V8 event environments for Candle Seller, Gravedigger Shop, Blood Ledger and Faceless Card.
- Added dedicated v7 Class Select portraits for Knight, Ranger and Mage.
- Added native 1280×720 v7 authored backdrops for Reward, Whispering Well, Curse Forge, Chained Prisoner, Black Altar and Run End.
- Added the prepared v6 Wizard/table backdrop as a clean 1280×398 runtime WebP with no baked gameplay UI.
- Added the latest native-HD v6 battle redraws for Graveyard, Ossuary, Bone Warden and Bone Crush, plus the latest dedicated Bone Warden table-card redraw.
- Completed current-art coverage for all 25 active Act 1 table cards. Added a supplementary 224×137 v5 redraw atlas for **ПЕПЕЛЬНЫЙ ПРИВАЛ**, **КОСТЯНАЯ ДАВКА**, **ТОРГОВЕЦ СВЕЧАМИ**, **КОСТЯНАЯ ПОШЛИНА** and **СТАВКА НА СМЕРТЬ**.
- Added the first object-first card redraw batch for **ГРЕМУЧИЙ МОСТ**, **КОШЕЛЬ МЕРТВЕЦА** and **ШЕПЧУЩИЙ КОЛОДЕЦ**, loaded as dedicated runtime-decoded WebP overrides instead of old atlas cells.

- Saved a dedicated visual-pass checkpoint (`docs/VISUAL_PASS_CHECKPOINT.md`) so a fresh chat can continue the anti-AI production-art pass from GitHub without reconstructing the conversation.
- Added the dedicated approved Bone Crush arena as split base64 WebP source parts and runtime decoding support for authored arena assets stored this way.
- Added `docs/ART_DIRECTION.md` and a shared production art-grade shader/material pair for the new authored low-resolution visual target.
- Added optional Wizard combat conditions worth +15 gold on victory: kill the Grave Bellkeeper first in **МОГИЛЬНЫЙ ЗВОН**, keep every hero above 25% HP in **ЗАЛП С ВИСЕЛИЦЫ**, and clear **КОСТЯНАЯ ДАВКА** within 16 seconds. A live objective panel shows success/failure state during combat.
- Added the temporary tactical order **НЕПОВИНОВЕНИЕ** after two explicit refusals of Wizard wagers/marked cards. It gives -20% incoming damage and -15% outgoing damage for one combat, and is consumed when that combat begins.
- Added personalized Bone Warden Phase II reinforcement plans driven by the Act 1 reckoning profile: two Thralls for **БЕЗ СВИДЕТЕЛЕЙ**, a Grave Bellkeeper for **ИСПИСАН ШРАМАМИ**, two Archers for **ЛЮБИМЕЦ СТАВОК**, or the existing Archer + Thrall pair for an untyped run.
- Added encounter-specific deployment geometry for **ЗАЛП С ВИСЕЛИЦЫ**, **КОСТЯНАЯ ДАВКА**, **ВРАТА ОССУАРИЯ** and **КОСТЯНОЙ НАДЗИРАТЕЛЬ**. Player-unit dragging now supports multiple disconnected legal regions and the live arena shows subtle deployment-zone panels before combat.
- Added compact threat tags to combat cards on the Wizard table, including ranged pressure, healing support, swarm, AOE and boss-phase cues.
- Added whole-run **КАРТА БЕЗ ЛИЦА** reckoning branches for deliberate companion loss, multiple rescue scars and repeated accepted Wizard risks.
- Added one-use **УДЕРЖАТЬ** control to normal two-card Act 1 offers. The reserved card is protected from rejection, cannot be chosen immediately and returns as a guaranteed offer after two resolved cards.
- Added visible **ПЕЧАТЬ ВОЛШЕБНИКА** cards twice per run. Taking the marked card grants +20 gold and activates +15% enemy damage until the next combat victory; taking the other card has no mechanical penalty.
- Added situational scar-key payoffs: **ШРАМ ЦЕПЕЙ** can bypass Bone Tax's blood price, **ШРАМ ДОРОГИ** halves the Faceless Card deterministic-development price, and **ШЁПОТ ПОД КОЖЕЙ** reduces Blood Ledger's blood cost from 25 to 10 HP.
- Added **ПОСЛЕДНЯЯ СДЕЛКА**, a one-use Wizard rescue offer on the first combat defeat of a run. The player may pay the explicitly shown owned relic to replay the same fight; if no relic exists, the price is **КЛЕЙМО ПОСЛЕДНЕЙ СДЕЛКИ** for -15 protagonist max HP.
- Added real failed-run state and defeat presentation. Refusing the Last Deal, or losing again after it has already been used, now ends the run and opens a loss-version run summary instead of returning to the table for a free retry.
- Added the cursed tactical order **ЖЕРТВА** as a one-battle option after accepting a voluntary Wizard wager: +40% party damage, +20% attack speed and 2% max-HP self-drain per living hero per second. The option is consumed when the next combat begins and does not return on retry.
- Added restrained Wizard table tells: smoother dealing after an acceptance-heavy wager history, sharper dealing after refusal-heavy history, a brief pre-swap card twitch before Wizard meddling, and memory-linked dim/pulse reactions for companion loss and rescue scars.
- Added cross-card event consequences for the vertical slice: Lost Purse now changes Gravedigger Shop pricing, Debtor Bones changes Wizard Tithe pricing, and prior Blood Ledger use adds a gold bonus to the Broken Crown melt route.
- Added persistent named rescue scars on the protagonist: **ШРАМ ЦЕПЕЙ** (-10 max HP), **ШРАМ ДОРОГИ** (-8 max HP), and **ШЁПОТ ПОД КОЖЕЙ** (-12 max HP). Scars are applied by sacrificial companion-rescue routes, affect effective combat stats and appear in Squad Dossier.
- Added Wizard Memory reactions for rescue scars, staying solo through the middle of Act 1, and deliberately abandoning both possible companions.
- Added a dedicated approved event-choice atlas cropped from the accepted Whispering Well and Chained Prisoner mockups, preserving their exact well/treasure/book/chain/coin-hand imagery at 384×160 per card.
- Added a dedicated object-centric artifact-art atlas for Dead Man's Shield, Blind Quiver, Cracked Focus and Broken Crown, reused by Curse Forge and artifact reward screens.
- Added a high-resolution Curse Forge scene layer behind the live event UI while keeping artifact text, disabled states and choices dynamic.
- Integrated the user-approved full pixel-art card set: unique illustrations for all 25 active Act 1 table cards, all nine hero-development paths, and six reward states.
- Added repository-safe runtime-decoded WebP atlases for table-card art and development/reward art under `assets/pixel/ui/approved_card_art/`.

### Changed

- Replaced all twelve active battle backdrops with the unified native-1280×720 `arena_redraw_v1` production set. The new plates use broader quiet combat floors, stronger large-scale silhouettes and perimeter-weighted detail so units read against the environment instead of disappearing into bones and props.
- `AuthoredBackdrop` now routes `crypt`, `graveyard`, `gallows`, `ossuary`, `warden`, `bone_crush`, `bone_swarm`, `grave_crossfire`, `iron_wall`, `last_bell`, `firing_square` and `bone_ritual` through the same canonical arena directory. Combat mechanics and encounter geometry are unchanged.

- Replaced the rejected full-width battle HUD slabs with compact modular plates: encounter info, run status, tactics, Fight/target preview and optional Wizard condition now occupy separate translucent islands so the authored arena remains visible.
- Tactical buttons now distribute dynamically across the tactical island: three baseline orders fill the available width, while four/five-order states shrink evenly without abbreviating **НЕПОВИНОВЕНИЕ**.
- Battle preparation now uses lighter one-pixel battle-specific panel/button chrome instead of the heavier shared menu/event UI treatment. Combat behavior is unchanged.

- Repacked the battle HUD after local rejection: a dedicated 170 px command footer now reserves five readable tactical-order slots, shows **НЕПОВИНОВЕНИЕ** in full, gives the order description its own wide area, separates target preview from the primary **БОЙ** action, and moves Wizard side objectives out of the playable battlefield.
- Added a subtle top battle information plate and moved the live combat floor upward so encounter/status text and units no longer compete with the command footer. Combat rules and timing are unchanged.
- Pixel-art arena fallback resizing now uses nearest-neighbor instead of Lanczos to avoid softening authored battle plates.

- Replaced all six Combat Expansion v1 temporary art aliases with dedicated approved visuals. Each new fight now has its own native 1280×720 authored battle backdrop and its own 448×274 table-card illustration: КОСТЯНОЙ РОЙ, МОГИЛЬНЫЙ ПЕРЕКРЁСТОК, ЖЕЛЕЗНАЯ СТЕНА, ПОСЛЕДНИЙ ЗВОН, РАССТРЕЛЬНАЯ ПЛОЩАДЬ and КОСТЯНОЙ РИТУАЛ.
- Dedicated expansion arena IDs now select their exact backdrop while preserving the nearest validated low-alpha atmosphere/tint family. Combat mechanics, spawn composition and deployment rules are unchanged.

- Extended tactical-order visual tells from a sub-half-second flash to roughly one second total: the marker now holds briefly before fading, while Sacrifice/Defiance persistent combat auras remain unchanged.
- Reintroduced combat polish safely after the empty-arena rollback. A new isolated `battle_motion_fx.gd` overlay listens to the existing tactical buttons without modifying battle spawning/controller flow: НАТИСК / ОХОТА / СТРОЙ show short readable squad markers, ЖЕРТВА adds a restrained red squad aura, НЕПОВИНОВЕНИЕ a cold-blue defensive aura, and Death Wager gets a subtle red battle-frame tell.
- Improved hit readability inside the existing stable `BattleUnit` feedback path only: melee/ranged/magic impacts now tint differently, large hits get a stronger kick / larger damage number / two extra sparks, and ranged/magic tracers are slightly clearer. Attack cadence, damage application, targeting, cooldowns and spawn code are unchanged.

- Reintroduced event animation conservatively after the earlier regressions: generic Act Choice and Whispering Well now only animate their already-initialized visible choice cards on screen entry (short stagger + settle). No button-down commitment hooks, event resolution timing, active-card initialization or choice-art loading paths were changed.
- Added Motion Polish Pass 5 to safe non-battle screens while the battle core remains frozen for regression recovery. Class Select cards now stage in, the chosen protagonist gets one clear focus beat before leaving, Intro frames get a tiny settle instead of a static swap, and the Squad dossier opens/closes cleanly with a short role-switch focus reaction.
- No battle controller/unit files were touched in this pass.

- Added Motion Polish Pass 4 for table ambience and outer-shell flow. The approved Variant C table now gets subtle candle-halo flicker from the live overlay, while deal/hold/choice/Wizard moments wake the existing ritual-circle area with short color-coded pulses instead of moving the painted backdrop itself.
- The physical deck now reacts slightly when a new deal starts; existing discard impact motion remains unchanged.
- Scene veils keep the same fast timing but now use very dark destination-specific tints for battle, reward, event and run-end transitions, preserving the blackout safety system while making scene changes feel less generic.
- Main menu and Run End now use one-shot staged entrance motion plus short button commit beats; no looping panel motion was added.

- Added Motion Polish Pass 3 for battle commands and post-combat flow. Tactical-order buttons now give a short physical confirmation beat, the FIGHT action visibly commits before the preparation HUD disappears, side-objective success/failure gets restrained panel feedback, and battle result overlays reveal in staged layers instead of appearing instantly.
- Victory, defeat and Last Deal now share the same short result-motion language: scrim/backdrop/title/subtitle reveal in sequence, visible actions fade in after the result, Last Deal receives one restrained price/backdrop emphasis, and clicking reward/Last Deal actions gives a brief commit beat before scene navigation.
- No battle rules, reward values, Last Deal costs or tactical-order effects changed.

- Added Motion Polish Pass 2 without changing combat balance or Fate Spread geometry. Melee, ranged and magic attacks now telegraph with short role-specific anticipation before the existing strike; death motion now has a brief stagger before the body settles/fades.
- Bone Warden Phase II now carries a short arena/backdrop reaction in addition to the existing phase label and reinforcement call, giving the boss transition more weight without adding screen shake.
- Fate Spread now opens as a ritual sequence: visible history/current cards reveal around the ring with a restrained stagger, the current position receives a short focus beat, and 4/8/12 milestones emphasize the relevant slot/counts/seal while keeping the approved layout frozen.
- Added restrained Wizard table reactions to wagers, refusals, accepted deals and card meddling by briefly tinting the authored backdrop rather than animating the painted character as a puppet.
- Generic Act Choice and Whispering Well commitment animations remain rolled back after the earlier regressions; their stable screens are intentionally left untouched in this pass.

- Added the first large motion-polish pass for the vertical slice. Table card choices now feel physical: Fate Hold pulls the selected card into the hold control and stamps it before returning it marked, chosen cards move toward the player, rejected cards travel into the discard area, and the discard pile/count react on impact instead of updating before the card arrives.
- Event choice screens now stage their mini-cards on entry and visibly commit a choice before revealing the result: the selected card lifts/warms while alternatives recede. Whispering Well uses the same interaction language.
- Reward screens now stage the header/cards on entry and give the selected reward a short focal beat while the alternatives dim before the reward resolves or the next reward tier appears.
- Motion remains intentionally restrained and fast: no continuous floating UI, no particle spam, and no gameplay timing/mechanics were changed.

- Expanded semantic mini-choice art across the remaining high-visibility Act 1 duplicate-thumbnail cases. Lost Purse, Debtor Bones, Wizard Tithe, Blood Ledger, Bone Tax, Ash Rest recruitment and Last Camp recruitment now show action-specific mini-art instead of three copies of the event illustration.
- Faceless Card now uses occult-card art for the unknown reveal and the actual offered upgrade art for the paid fate route; only the burn option keeps the event illustration until a truthful burn-card mini-art exists.
- Reused the approved action vocabulary deliberately: coins/payment, greed bag, body search, occult gamble, blood cost, broken chains, rescue and walk-away now act as consistent visual verbs across events. Role-development screens continue to show the actual offered upgrade art, and Curse Forge continues to show the actual relics.
- Restored native 384×160 sources wherever they already exist: Whispering Well now reads from the original approved 1152×320 choice atlas, Chained Prisoner recruitment mixes the native chain/loot cells with the native bridge leave cell, and Black Altar payment uses the native coin cell. Only Black Altar blood/offering still require the compact approved sheet.

- Integrated the user-approved five-event semantic choice-card mockup as the new production mini-art benchmark. Rattling Bridge recruitment, Whispering Well, Chained Prisoner recruitment and Black Altar recruitment now use dedicated action-first pixel illustrations from the approved sheet instead of repeating the large event scene.
- The approved mini-art sheet is stored as a runtime-decoded 576×320 WebP split into text parts under `assets/pixel/event/choice/approved_choice_sheet_v2/`; each 192×80 cell is shown with nearest filtering for a cleaner, less AI-like card-scale read.
- Curse Forge intentionally keeps the actual Dead Man's Shield / Blind Quiver / Cracked Focus artifact illustrations because those images match the current live choices more accurately than the concept-sheet forge placeholders.

- Extended the semantic event-choice pass to **ЧЁРНЫЙ АЛТАРЬ** recruitment: blood sacrifice, ritual payment and stolen offering now use separate mini illustrations instead of repeating the altar event thumbnail.
- Audited the original five benchmark events: Whispering Well and Chained Prisoner already use dedicated choice imagery, while Curse Forge uses the actual artifact illustrations for its three live choices. The next true duplicate-art gaps are Lost Purse, Debtor Bones, Wizard Tithe and the recruitment branches of Ash Rest / Last Camp.

- Started the semantic event-choice art pass with **ГРЕМУЧИЙ МОСТ**. Its ranger-recruitment choices now use three dedicated painted mini illustrations — rescue / loot-bag / lone-crossing — instead of duplicating the event image.
- Replaced the rejected schematic SVG prototypes with an approved 1152×160 runtime-decoded WebP atlas stored as split base64 text under `assets/pixel/event/choice/rattling_bridge_hd/`. The already-resolved bridge branch still uses the generic fallback until its own three semantic illustrations are authored.

- Replaced the Wizard-table baked face-up offer exposure with permanent neutral physical card backs beneath the live offer layer. Two-card deals cover them; single-card/retry states now reveal logical face-down cards instead of old sample events or dark masks.
- Fate Spread empty Hold now shows the same physical card back with no dark title plate, while the Wizard discard hides completely when empty and uses a card-back-backed live top card aligned to the painted stack when non-empty.

- Replaced the oversized Wizard-table baked-card mask with two narrow cloth-toned cleanup patches that appear only for single-card offers; normal two-card deals no longer sit over a dark oval "hole".
- Re-seated the Fate Spread Wizard-discard live card by shrinking it, lowering it and matching the painted stack angle more closely.

- Added a dedicated dark oval cleanup layer beneath live Wizard-table offers so baked sample cards from the approved Variant C plate no longer bleed through when only one live card is shown.
- Rotated and shifted the Fate Spread Wizard-discard live card layer to sit on the painted discard stack instead of exposing the rectangular cleanup backing.

- Added a durable continuation checkpoint covering the frozen Fate Spread, exact Variant C normal-table integration, canonical asset paths, current visual rules and the immediate local validation plan for the next Project chat.

- Made the user's final cleaned-up Variant C illustration the canonical full-screen Wizard deal table. The physical Wizard/room/oval table/deck/discard composition now comes from the approved 1280×720 plate, while offer cards, Hold state, counts, Wizard text and controls remain live Godot UI aligned over it.

- Replaced the normal Wizard table's procedural/partial composition with the final approved Variant C full-screen plate. Live offers, Hold controls, HUD, Wizard line, Fate Spread action and deck/discard counts are aligned over the physical art; card sizing/animation anchors were updated and the old compact table-progress visual is suppressed.

- Rebuilt the normal Wizard/card-selection table around the approved Variant C composition: a wide oval red-black ritual tabletop, one strong central sigil, physical deck/discard holders and lower live offer cards; removed the old rectangular lower-table shading and duplicate compact progress ring.

- Final Fate Spread polish: live future replacements now read as plain physical card-backs, the hover decision history is a compact cursor-adjacent tooltip instead of a bottom HUD strip, and empty Hold/Discard interiors use dark leather tones rather than flat black.

- Refined the exact-reference Fate Spread cleanup so generic future card-backs and the sealed XIII remain visible from the approved art; live masks now appear only where run-specific state actually replaces the reference, eliminating the oversized black rectangles from the previous pass.

- Rebuilt `РАСКЛАД СУДЬБЫ` around the final approved full-table reference almost one-for-one: live I–XII cards now follow the reference ring positions, Hold/Discard use the ornate physical holders, XIII is aligned to the central ritual card, and live masks replace only baked run-specific state.

- Replaced the nearly invisible full-screen Fate Spread reference underlay with dedicated top/left/right authored edge-art plates loaded at runtime, preserving bright candle/brass/red-cloth atmosphere while keeping the center fully data-driven.

- Integrated the approved ornate Fate Spread art direction as a dark blurred runtime underlay beneath the live Godot spread, adding candlelit table props, red ritual cloth and gothic material richness without baking run-specific cards or counters into the image.

- Shortened the Fate Spread side holders, strengthened the central ritual hierarchy and made chapter styling escalate from restrained gold to ember/red in line with the approved reference.

- The normal table progress marker is now a circular occult spread rather than a linear diamond strip, and resolved cards are now represented by the Fate Spread while the right-side discard counts rejected cards only.

- Pre-battle target-intent lines are now opt-in through a `ЦЕЛИ: ВКЛ/ВЫКЛ` toggle above the fight button, default off, with the choice remembered between battles for the current app session.

- Scene transitions now preload the incoming PackedScene while the outgoing scene remains alive, then manually swap scenes under a fully rendered veil instead of calling `change_scene_to_file()` during the blackout.

- Replaced the compressed low-quality main-menu splash with the approved restrained main-menu redraw, stored as a native 1280×720 runtime WebP.
- Routed main/intro/class-select/table/event/battle/reward/run-end scene changes and battle reloads through the shared transition veil.

- Rebalanced incomplete-party combat for full Act 1 runs: solo heroes now use HP ×2.2 / damage ×1.9 / attacks ×1.25 / movement ×1.10, while solo enemies use 82% HP and 80% damage; duo enemies use 92% HP and 90% damage alongside the existing duo hero bonus.
- Wizard Debt and Wizard Mark now multiply on top of party-size enemy pressure, and enemy support healing follows enemy HP scaling.
- Tier 0 can no longer force combat on the very first resolved card; the first mandatory early fight occurs after at least one non-combat decision.

- Existing approved event-choice art, artifact art and authored screen backdrops now sit inside one consistent live Godot chrome system instead of each screen relying on unrelated local panel/button styling.

- The eight V9 events now use dedicated native 1280×720 environments in the shared live Act Choice scene while keeping all gameplay text/state/buttons dynamic.
- Broad Act 1 art replacement is considered complete after V9; further visual changes should be targeted from local screenshot review.
- Squad Dossier now reuses the dedicated Class Select Knight / Ranger / Mage portraits instead of enlarging the combat-unit atlas.
- The four new V8 event environments are loaded through the runtime WebP decoder while all event UI/state remains live.
- Class Select no longer enlarges 96×96 combat sprites as portraits.
- Reward no longer uses the old generic table background.
- Whispering Well and Run End no longer depend on their procedural environment renderers.
- Shared Act Choice now shows dedicated environment art for Curse Forge, Chained Prisoner and Black Altar while keeping all event logic/UI live.
- Reduced the shared cursed-choice table shade so new authored environments keep readable midtones.
- Brightened the reward backdrop and removed double-grading from Whispering Well choice art so prepared event/reward illustrations keep their midtones.
- Removed the remaining double-darkening from the Wizard table and live table/wager art; authored assets now render without the legacy post-grade.
- Reduced the Wizard wager scrim from 0.82 to 0.52 alpha and halved the passive table shade layers.
- Reduced fallback environment/card grade strengths to preserve dark-mid detail on older event/reward surfaces.
- Replaced the over-dark Graveyard/Ossuary/Warden/Bone Crush presentation with the latest reviewed authored sources. Authored battle backdrops are now shown without the legacy environment-grade material.
- Bone Crush deployment lanes, initial unit positions and combat bounds are aligned to the visible floor plane so units no longer appear suspended on the architecture.
- **СЛОМАННАЯ КОРОНА** now uses the exact approved object-centric Broken Crown artifact illustration on its table card.
- Card-art lookup now prefers the v5 completion batch before the accepted v4 redraw atlas, while retaining the legacy 25-card sheet only as a safety fallback.
- Wired the first object-first card redraw batch into live table rendering for **ГРЕМУЧИЙ МОСТ**, **КОШЕЛЬ МЕРТВЕЦА** and **ШЕПЧУЩИЙ КОЛОДЕЦ**.
- Reduced card-art grade strength from 0.58 to 0.30 to preserve authored dark midtones.

- Reduced the shared card-art grade strength so newly authored card illustrations retain readable dark midtones while remaining inside the Misdeal palette.

- Local screenshot review established Bone Crush as the first true redraw benchmark, kept the shared grade as a consistency layer, and moved future deployment visuals toward in-world floor markings instead of blue debug-style panels.
- **КОСТЯНАЯ ДАВКА** now uses its own lower-detail gothic arena instead of reusing Ossuary. Deployment-zone presentation is now subdued warm floor marking rather than blue debug-style rectangles, with additional authored two-band chalk marks for this encounter.
- Wizard-table backdrop/card art, authored battle backdrops and Whispering Well choice art now share the first production-grade treatment. Battle backdrops use nearest filtering/resampling; Whispering Well's procedural glow/detail treatment is more restrained.
- Bone Warden keeps its fixed 700-HP benchmark and existing core combat stats; only the Phase II reinforcement composition now reacts to run history, with the verdict shown before the player commits to the fight.
- Wizard-refusal history now has a direct tactical payoff through **НЕПОВИНОВЕНИЕ**, complementing the wager-acceptance path that grants **ЖЕРТВА**.
- Faceless Card's existing fourth action now becomes a contextual late-run resolution when the player's history qualifies: **БЕЗ СВИДЕТЕЛЕЙ**, **ИСПИСАН ШРАМАМИ** or **ЛЮБИМЕЦ СТАВОК**. This uses explicit run facts rather than a hidden morality meter.
- Special deployment encounters now start heroes inside their authored legal regions and explain the placement rule in the preparation HUD.
- Wizard-mark danger is surfaced in both the table condition strip and battle condition block, stacks visibly with Wizard debt, persists through Last Deal retry and clears only after a combat victory.
- Held cards use a dedicated table tab and blue card-state treatment; marked cards use a visible Wizard seal, ember border and explicit `+20 gold / enemies +15%` hint.
- Battle preparation HUD now separates encounter threat/tactical guidance from persistent run conditions. Solo/duo compensation, Wizard debt, **ЖЕРТВА** availability and used Last Deal state render in a compact right-side block instead of extending the main status line into the card counter.
- Shortened and sharpened preparation cues for Bone Warden, Death Wager, Crypt Guard, Grave Bell, Bone Crush, Ossuary Gate and Gallows Volley so the player sees the actual tactical problem before combat.
- Synced `docs/CONCEPT.md` with the implemented solo compensation: HP ×2, damage ×1.8, attack cadence ×1.25 and movement ×1.10.
- Free combat retry after defeat has been removed. Retry is now possible only through the one-use Last Deal, and its payment persists for the remainder of the run.
- Squad Dossier and run-end summary now surface the Last Deal's permanent HP brand/payment state when relevant.
- The table HUD now exposes **ЖЕРТВА ГОТОВА** after an accepted Wizard wager, and the Wizard's acceptance line explicitly tells the player that the extra order will appear in the next combat.
- Blood-rescue event text now names the scar and its protagonist max-HP cost directly on the choice card instead of presenting the sacrifice as an anonymous party HP penalty; gold rescue routes still avoid the scar where available.
- Whispering Well and Chained Prisoner now match the approved choice-card mockups more closely: larger art bands, divider medallions, stronger semantic border colors and explicit disabled-state messaging; Chained Prisoner uses the accepted blue/red/amber rescue-risk-greed split.
- Shared Act 1 choice cards gain the same lightweight divider/medallion language so event options read more like intentional cards without baking live gameplay text into art.
- Final Wizard Wager refinement: softer outer frame, longer contract connector, brighter reward art, larger/higher `x2` and tighter action spacing after local screenshot review.
- Wizard Wager was tightened again after local visual review: the modal is shorter, both term illustrations are larger, risk/reward color separation is stronger, a central contract sigil links the two terms and the accept action now has a dedicated ember-glow hover style.
- Reworked the shared Act 1 event window hierarchy: generic events now show framed context art in the header, run-state chips replace loose floating labels, role-development choices show the actual offered upgrade art, and risk-oriented choices gain restrained semantic accents. This removes repeated merchant/event imagery from Candle Seller, Gravedigger Shop and similar screens without changing mechanics.
- Whispering Well choice cards now have illustrated upper bands using the relevant well, development or relic imagery, with text pushed below the art instead of competing for the same space.
- Reworked **СТАВКА ВОЛШЕБНИКА** into a more ceremonial two-term decision panel: the next-fight penalty and doubled-loot reward now have separate illustrated frames and clearer accept/refuse hierarchy.
- Re-composed **КУЗНИЦА ПРОКЛЯТИЙ** with a tighter header, visible forge environment and larger object-focused relic cards; Death Wager and Crypt Guard relic rewards now show the actual offered artifact instead of generic relic art.
- Wizard-table offers now resolve art by `card_id`, so Rattling Bridge, Lost Purse, Blood Ledger, Crypt Guard, Bone Crush, Bone Warden and every other active card show their own approved scene instead of sharing the old five-image pool.
- Hero development now uses nine distinct approved illustrations; Ranger and alternate Knight/Mage paths no longer fall back to repeated role portraits.
- Ordinary loot, Death Wager and elite rewards now use the approved Blood Coin, Gold Windfall, Relic Wager, Bonus Upgrade, Empty Cache and Elite Relic art while keeping reward text live.
- Generic Act 1 event choices now show the active event's approved illustration in their upper art band instead of leaving Rattling Bridge and similar choice cards as flat black placeholders; Curse Forge and Chained Prisoner retain their dedicated option art.

### Verified

- Static post-Last-Deal balance audit keeps the current solo/duo/trio compensation and fixed encounter benchmarks unchanged pending fresh full-run evidence; no speculative blanket enemy nerf/buff was introduced.
- Clean wizard-table art pass confirmed locally after screenshot review: removing the procedural hands/heavy frames restored the authored Wizard art and live cards as the main visual focus.
- Physical wizard-table staging pass confirmed locally: deal animation, fan/hover behavior, discard motion and spread layout are working acceptably.
- Voluntary Wizard wager flow confirmed locally: wager modal, debt state and doubled ordinary loot are working acceptably.
- First combat-feel and prototype-SFX pass confirmed locally: attack motion, hit/death response and runtime combat cues are working acceptably.
- Complete nine-role combat sprite atlas confirmed locally after the v2 fallback preload fix.
- Authored gothic battle backdrop confirmed locally after backdrop import/z-order fixes.
- Final five-card Act 1 content batch confirmed locally: Rattling Bridge, Lost Purse, Candle Seller, Bone Tax and Death Wager.
- Late-game Act 1 escalation confirmed locally: Faceless Card, Blood Ledger, Broken Crown, Last Camp and Ossuary Gate.
- 12-card Act 1 offer/rejection/tier flow and boss handoff confirmed working locally.
- Bone Warden boss encounter and enrage behavior confirmed working locally.
- Final wizard-table composition/readability polish confirmed locally and accepted.
- Pixel battle presentation pass confirmed visually acceptable locally.
- First pixel-art combat readability pass confirmed locally: larger sprites, ground rings and compact HP presentation read clearly.
- Whispering Well event choices and one-time-per-run lockout confirmed working locally.
- Three-card encounter selection, three-victory finite run, run-end summary and new-run reset confirmed working locally.
- First `table -> battle -> reward -> table` loop confirmed working locally.
- Bone Archer arena-bound retreat fix confirmed working locally.
- Data-driven `UnitData` refactor confirmed working locally.
- Hit/death combat feedback confirmed working locally.
- Combat-time unit separation confirmed working locally.
- Pre-battle hero dragging confirmed working locally.

### Fixed

- Escalated the missing-unit hotfix: because restoring only `unit.gd` did not recover battle setup locally, `scripts/battle/battle.gd` was also restored to the last known-good pre-animation baseline. Battle spawning, deployment, tactics, side objectives, Last Deal and result flow are now back on the stable controller; battle-specific motion passes are temporarily removed pending a smaller verified reintroduction.
- Hotfixed a severe battle regression where the preparation screen could load with no heroes or enemies. `scripts/battle/unit.gd` was restored to the last known-good pre-windup version; the attack-anticipation/death-motion experiment is temporarily rolled back while the rest of the battle UI/result/Fate Spread/table motion remains active.
- Fixed Whispering Well choice cards losing their mini-art after the motion pass. The dedicated Well controller was restored to the last stable pre-motion version, and its three choice images now load again from the approved split-sheet source rather than the raw legacy atlas path.
- Hotfixed an Act Choice regression from the first motion pass: the generic event scene could remain on its template placeholders (`СОБЫТИЕ / Описание / ВЫБОР A-B-C`) instead of initializing the active event. The risky Act Choice motion layer was rolled back to the last known-good semantic-art version; table and reward motion remain enabled.
- Fixed Rattling Bridge regular-state choice cards falling back to the large event thumbnail. Both bridge branches now use the already-authored semantic mini-art trio, and the bridge specifically uses the original native 1152×160 / 384×160-per-cell HD atlas instead of the downscaled unified-sheet copy.
- Fixed visibly blocky semantic event choice art: the approved 192×80 source cells are now reconstructed once to 384×160 with Lanczos before slicing, and live choice TextureRects use linear sampling when fitting the art into the ~300 px UI card width. This removes the harsh nearest-neighbor magnification that made the approved illustrations look low-quality in-game.
- Fixed final Fate Spread reference alignment issues: baked XII sample card no longer leaks, the approved static title is used directly instead of a large black live header, Wizard Discard count sits inside its physical holder, and empty side holders no longer show a floating `ПУСТО` label.

- Fixed baked reference-state leakage in `РАСКЛАД СУДЬБЫ`: old sample cards, Roman numerals, title/count text and XIII label are now masked beneath live state without darkening the physical table; empty Hold/Discard title plates also stay dark until populated.

- Fixed the approved Fate Spread reference plate being almost invisible behind the outer frame. It now renders inside the frame above the panel background, while stronger live center/header masks prevent baked concept cards/text from competing with real run state.

- Fixed Fate Spread layering/readability after the first local screenshot: live offer cards and the table's `РАСКЛАД СУДЬБЫ` button are hidden while the inspection overlay is open, the overlay uses a valid top z-index, and the twelve historical slots are smaller with more breathing room around XIII.

- Fixed `run_end.gd` declaration order after the resilient scene-router rollout; all navigation scripts now start with their `extends` declaration and contain no direct `SceneTransition` identifier references.

- Fixed Godot compile failures when a locally modified `project.godot` had not registered the new `SceneTransition` autoload: navigation now uses a resilient router that finds the singleton or creates the persistent transition node at runtime.

- Eliminated the actual empty-scene interval behind the intermittent gray transition frame; incoming runtime art/layout now settles while the persistent veil remains opaque.

- Fixed the brief gray viewport flash during scene changes (notably table → battle and event → table) by keeping a persistent dark veil over the viewport until the incoming scene is ready; the renderer clear color now matches the same near-black fallback.

- Fixed the first UI-kit screenshot regressions: the authored main-menu and intro click hotspots are transparent again instead of rendering empty opaque frames.
- Fixed resolved Act 1 event layout so the old leave action disappears after a choice and long result text gets a dedicated strip above the single `К СТОЛУ` action.

- Fixed Gallows Volley units appearing to retreat or spawn over background architecture: combat bounds, party/enemy positions and placement geometry now sit on the authored floor, and battle units clamp to combat bounds as soon as those bounds are assigned.

- Constrained **ЗАЛП С ВИСЕЛИЦЫ** to an authored-floor combat rectangle and matching deployment band so retreat, chase and separation cannot push any unit into the background/air above the stone arena; refreshed solo/duo/trio start positions to the same playable plane.

- Fixed Godot 4.7.2 parse failures for newly added v7 WebP art by routing the new screen assets through a cached runtime WebP decoder instead of direct preload/Texture2D resource references.
- Rejected and removed the low-resolution v3 runtime path that enlarged 112×69 card cells and 320×180 arena cells.
- Added native 1280×720 v4 battle backdrops for Crypt and a new dedicated Gallows Volley arena; Graveyard/Ossuary/Warden keep their validated HD sources and Bone Crush keeps its dedicated benchmark.
- Rebuilt the broad redraw card integration as a 224×137 v4 atlas with semantic source mapping for 19 cards, including **КОСТИ ДОЛЖНИКА**. Six cards without matching redraw sources now keep their unique approved 224×137 fallback art instead of receiving unrelated imagery.
- Removed the generation-order mapping bug that could place arena concepts or unrelated scenes onto the wrong card.
- Fixed the Bone Crush atmosphere parse error in Godot 4.7 by typing the Rect2 band array and marker coordinates explicitly.
- Fixed the first visual-redraw card batch integration: Rattling Bridge, Lost Purse and Whispering Well now actually resolve their dedicated runtime overrides from repository text assets.

- Combat-condition timers now start only after the cinematic fight intro, so **КОСТЯНАЯ ДАВКА** does not lose objective time during presentation and **ЖЕРТВА** no longer drains HP before units actually enter combat. The Gallows Volley no-critical condition also fails correctly if a hero dies before emitting the 25% critical-health cue.
- Applied rescue-scar max-HP penalties to live combat spawning as well as dossier stat calculation, so named scars now have the same real protagonist HP cost in the autobattle that the UI reports.
- Fixed Act 1 event-window footer overflow at 1280×720: generic choice cards are slightly shorter with the leave/continue row pulled fully on-screen, and Chained Prisoner now reserves a dedicated bottom action row instead of overlapping its center card.
- Fixed Squad Dossier layering so live table offer cards are hidden while the dossier is open and cannot render over hero stats; also enlarged the hero portrait and rebalanced stats/development/relic columns.
- Fixed the Godot 4.7.2 parser-inference failure in the event-window semantic style pass by explicitly typing style-name arrays, styleboxes and hover/disabled booleans in `act_choice.gd` and `whispering_well.gd`.
- Replaced the first card-art atlas pass that crushed approved illustrations to 88×54 px (table) and 80×48 px (development/reward). The same approved images are now stored at 224×137 and 304×194 per cell respectively, with WebP bytes decoded directly from repository-safe `.bin` blobs instead of enlarging thumbnail art.
- Replaced the incorrect combat-unit portraits on non-combat UI with the exact accepted screen-art crops. Hero development now uses the approved Iron Oath / Glass Heart / Executioner illustrations, and matching approved art is wired into Curse Forge and Chained Prisoner choices. Ranger paths deliberately remain text-led until matching art is approved rather than reusing unrelated battle sprites.
- Fixed Godot 4.7.2 parser failure in `act_choice.gd` from Variant-returning theme-style lookups by giving the duplicated `StyleBoxFlat` values explicit types.
- Replaced the temporary low-resolution arena rollback with repository-safe native-HD blobs for crypt, graveyard, ossuary and Warden; the earlier binary-truncation path is no longer used.
- Removed compile-time WebP `preload()` calls from the arena backdrop selector after Godot 4.7.2 still rejected the arena textures during script parsing on a clean pull. Arena WebPs are now read as raw bytes and decoded at runtime with `Image.load_webp_from_buffer()`, matching the already-validated main-menu splash loading path and preventing importer failures from crashing startup.
- Fixed the arena startup crash after the HD-quality pass: the crypt/graveyard/ossuary WebP blobs in GitHub were truncated to ~15 KB and could not be imported by Godot. Restored the last validated authored arena blobs and now Lanczos-resample/cache every arena family to 1280×720 at runtime with linear filtering.
- Fixed the HD arena parser regression: `authored_backdrop.gd` and related notes had been serialized with literal escape sequences instead of physical line breaks, causing Godot 4.7.2 to parse the whole script as one invalid line.
- Removed nearest-neighbor 2× arena presentation; validated authored sources are now resampled once with Lanczos to cached 1280×720 runtime textures and shown with linear filtering.

- Fixed Godot 4.7.2 parser failure in the multi-arena visual layer: renamed the local ellipse helper so it no longer overrides the built-in CanvasItem `draw_ellipse(...)` method with an incompatible signature.
- Reverted the rejected wizard-table dressing layer after local visual review: removed the procedural dealer hands, oversized side inlays, dense orange frames/runes and extra tabletop props that clashed with the authored pixel background.
- Rebalanced the table presentation around the live cards: small deck/discard stacks and a low-contrast fate track remain, while deal/hover/choose/discard/substitution animations are preserved.
- Moved the victory/defeat result UI into a dedicated high-layer `CanvasLayer` with a dim scrim so combat-unit sprites, names and HP bars can no longer render over the result panel; the modal is also positioned higher and tactical-order controls hide on battle end.
- Corrected the Wizard's card-hand anatomy on the production main-menu splash to five fingers.
- Removed the obsolete compile-time `preload()` of `combat_units_v2.png` that prevented `unit.gd` from parsing in Godot 4.7.2. The validated v3 atlas is now the only production unit-art source.
- Removed the obsolete/broken `assets/pixel/units/combat_units_v2.png` fallback asset.

- Fixed the authored battle backdrop being invisible: the direct WebP committed to GitHub was truncated to 8.7 KB and the backdrop node also sat behind the fullscreen black fallback via `z_index = -100`.
- Battle now reconstructs the validated 1280×720 authored WebP from five repository chunks through `authored_backdrop.gd`, and the backdrop is drawn above the black fallback.
- Removed the broken truncated `assets/pixel/battle/battle_backdrop.webp` file.
- Fixed Godot 4.7.2 parser failure in the new boss-arena chain/brazier drawing by replacing Variant-inferred loop values with typed Vector2 arrays and explicit local types.
- Clamp final hero max HP to 20 and damage to 1 so stacked late-run sacrifices cannot create invalid combat units.
- Split the battle result overlay into a large victory/defeat title and a separate compact wizard-reaction subtitle so post-battle text no longer overlaps the panel and units.
- Removed floating default tooltips from wizard-table combat cards so hover text no longer covers card illustrations.
- Replaced hover tooltips with wizard commentary in the dedicated upper strip and protected selection commentary from mouse-exit resets.
- Removed obsolete procedural table-side props and candles that conflicted with the authored pixel backdrop.
- Reworked combat readability after local feedback that painted miniatures were unreadable at tactical scale.
- Removed A/B/C suffixes from duplicate enemy display names.
- Added hard combat-arena bounds so retreating units and their pursuers cannot leave the battlefield.
- Bone Archer now fights when cornered instead of endlessly retreating into the arena boundary.
- Fixed pre-battle dragging being blocked by fullscreen Control UI layers.
- BattleUnit placement input now uses the main input phase, while decorative battle UI ignores mouse events.

### Changed

- Reworked the four user-approved reference screens against the actual screenshots: hero development now removes the invented diamond/quick-stat chrome and uses taller illustrated cards with in-card choose bars; Curse Forge and Chained Prisoner now use dedicated absolute compositions around their approved character art; the Wizard wager is enlarged and reveals more of the cursed table behind it.
- Re-aligned **РАЗВИТИЕ ОТРЯДА**, **КУЗНИЦА ПРОКЛЯТИЙ**, **ЗАКОВАННЫЙ ПЛЕННИК** and **СТАВКА ВОЛШЕБНИКА** to the approved mockup compositions: taller illustrated cards, dominant art windows, in-card choose bars, stronger header framing and a larger ritual wager modal.
- Hero-development cards now use approved art when available and a role-specific art fallback only for upgrade paths that do not yet have a dedicated approved illustration; combat-atlas sprites are not used on this screen.
- Polished **РАЗВИТИЕ ОТРЯДА** beyond the shared shell: upgrade cards now show live hero portraits, separate role/path/description regions, concise tradeoff summaries, three-step fate markers, stronger backdrop suppression and tighter card proportions.
- Reworked reward/development screens around the authored Wizard backdrop with a compact run HUD, stronger role-card presentation and hover feedback; reworked the Wizard wager into a larger ceremonial modal with clearer accept/refuse hierarchy.
- Restyled protagonist selection and fallback event screens to match the same approved Misdeal table language instead of isolated flat-black prototype panels.
- Rebuilt the battle preparation controls into one darker gothic bottom HUD with clearer pressed tactical-order states, a larger central fight button and restart hidden until results.
- Combat-polish v2 remains presentation-only: movement positions, targeting rules, tactical orders, stats and encounter compositions are unchanged.
- Rebuilt all four authored battle arenas from the preserved 1672×941 source renders into high-quality native 1280×720 WebP assets, removing the visible softness caused by 640×360 source upscaling. Runtime WebP byte decoding remains in place for importer robustness.
- Replaced the visually weak procedural arena-family overlays with four dedicated authored pixel-art battle backdrops: crypt, moonlit graveyard, ossuary and Bone Warden lair. `EncounterData.arena_id` now selects the actual backdrop texture.
- Reduced `battle_visual.gd` back to dynamic boss effects only, removing static procedural environment drawing that competed with authored art.
- Refined wizard-table hierarchy after screenshot review: added a subtle lower-table veil over the baked background-card row, compacted/lightened the stats and Wizard-commentary chrome, quieted the squad button and moved the fate progress to a tiny table-edge counter/marker row.
- Replaced the rejected live/table-art main-menu composition with the user-approved dedicated main-menu pixel splash: Wizard, five-card table, MISDEAL title and painted **ВОЙТИ В ИГРУ** CTA.
- Upgraded the production main-menu splash from the 640×360 fallback to a native 1280×720 WebP reconstructed from three repository-safe chunks and rendered with linear filtering; only a transparent native Godot hotspot is layered over the painted CTA.
- Rebuilt the main menu around the production Wizard/table art and real MISDEAL logo instead of the old centered prototype panel.
- Replaced the generic **ВОЙТИ В ИГРУ** presentation with a single in-world **СЕСТЬ ЗА СТОЛ** action on the cursed tabletop.
- Removed the old procedural candles/eyes/card mockup from the active main-menu composition.
- Rebalanced **СИЛА ОДИНОЧКИ** after local playtest feedback that early three-enemy encounters were nearly impossible: solo now gets x2 HP, x1.8 damage, x1.25 attacks/second and x1.10 movement speed.
- Kept early enemy stats/encounter compositions and Bone Warden fixed rather than introducing party-size enemy scaling.
- Rebuilt protagonist class cards with dedicated portrait/title/stat/role/description regions instead of multiline button text under the sprite.
- Expanded and clipped wizard-table card description regions and moved **ВЫБРАТЬ / ПОВТОРИТЬ / ПРИНЯТЬ ВЫЗОВ** into a separated bottom strip.
- Raised battle result panels and command buttons above unit Y-sorting/floating combat feedback.
- Hide the finished **БОЙ** button when the post-battle continue action appears, removing duplicate overlapping button text.
- Combat now spawns only the current recruited party instead of always spawning Knight/Ranger/Mage.
- Major/bonus hero-upgrade offers are generated only from current party roles; solo runs can see multiple upgrade paths for the protagonist.
- General-pool hero-specific relics are filtered to current party roles, and Curse Forge disables relics for absent heroes.
- Squad dossier now shows unresolved/lost companions as faded fate entries and opens on the protagonist.
- Prologue now leads to class selection; **НОВЫЙ ЗАБЕГ** skips the comic but still requires a new protagonist choice.
- Existing event cards dynamically switch into recruitment scenes when the corresponding companion fate is still unresolved.
- Wizard table now exposes the current party build without leaving or regenerating the active card offer.
- Effective hero-stat calculation is centralized in `RunState.get_effective_hero_stats()` for the status UI and mirrors battle modifier order/clamps.
- Main-menu **ВОЙТИ В ИГРУ** now resets the run and opens the story intro before the wizard table; consecutive new runs from the run-end screen still go straight to the table.
- Capped optional hero development from events and Death Wager at 3 upgrades per run; the three guaranteed tier upgrades remain separate.
- Blood Ledger now restores an optional-upgrade slot when it erases an upgrade that came from the optional pool.
- Event HUD exposes the optional progression counter as **ДОП. X/3** and build-upgrade event choices disable cleanly at the cap.
- Death Wager converts its extra-upgrade branch to +45 gold when optional development is already 3/3.
- Retuned Bone Warden for the capped 4–6-upgrade target curve: 700 HP, 24 damage, 1.0 s cadence, 60 move speed and stronger phase-II enrage multipliers.
- Reworked progression-facing event cards so positive permanent rewards primarily grant hero development, relics or gold instead of generic party-wide HP/damage.
- Ash Rest and Last Camp now let the player develop a chosen hero directly.
- Gravedigger Shop and Candle Seller now sell the next concrete Knight/Ranger/Mage upgrade.
- Black Altar now trades party HP for a concrete role-specific hero upgrade.
- Chained Prisoner, Broken Crown and Bone Tax now include least-developed-hero progression paths.
- Faceless Card now rolls between gold, relic and hero-development outcomes; burning it can clear wizard debt.
- Blood Ledger now buys development, trades blood for relic/build progression, or erases the latest acquired hero upgrade for +70 gold.
- Whispering Well now trades blood/gold for hero development or relics instead of positive global stat buffs.
- Event HUD now shows compact development/relic counts and build-choice buttons wrap longer upgrade descriptions.
- Replaced ordinary post-combat gold / party HP / party damage choices with a build-progression flow: one guaranteed major hero upgrade per Act 1 tier, followed by normal or special loot.
- Normal non-special combat loot is now gold-only; permanent party HP/damage is no longer the default combat progression reward.
- Death Wager reward changed from raw +HP/+damage options to +60 gold / a visible available artifact / one additional hero-upgrade choice.
- Wizard-table HUD now emphasizes hero progression count and relic count instead of global HP/damage counters.
- Reward cards now use Knight/Ranger/Mage visual accents and wrapped text for build choices.
- Replaced all current combat-unit rendering with the final v3 unified 3×3 high-detail 96×96 pixel atlas covering Knight, Ranger, Mage, Skeleton, Bone Archer, Grave Bellkeeper, Bone Thrall, Crypt Guard and Bone Warden.
- Production v3 unit art is reconstructed from ten repository PNG-base64 chunks under `assets/pixel/units/combat_units_v3/`; `BattleUnit` validates the decoded 288×288 atlas before use.
- Grave Bellkeeper, Bone Thrall and Crypt Guard now have unique authored sprites instead of tinted Skeleton fallback art.
- Retuned unit sprite scale and HP/name offsets for the new detailed atlas: Thrall smaller, support near standard size, Crypt Guard elite-sized, Bone Warden boss-sized.
- Replaced the procedural battle wall/floor/HUD rendering with an authored full-screen gothic battle backdrop based on the user's second approved reference.
- General battle architecture, throne, candles, banners, chains, skull piles, ritual floor and UI frames are now painted into the backdrop; live units, HP, labels and buttons remain native Godot layers.
- Added the authored battle backdrop as five validated base64 WebP chunks under `assets/pixel/battle/authored_backdrop/`, decoded at runtime by `scripts/battle/authored_backdrop.gd`.
- Reduced `battle_visual.gd` to lightweight dynamic boss overlays so ordinary combat no longer gets a second procedural arena drawn over the authored art.
- Removed the obsolete procedural `battle_hud_visual.gd` renderer so the painted HUD chrome is not doubled.
- Re-aligned title/status/progress/faction labels and bottom command buttons to the painted frames in the authored backdrop.
- Rebuilt the live battle composition around the approved gothic pixel reference: denser crypt architecture, larger ritual floor, faction lighting split, heavy HUD framing and stronger command hierarchy.
- Replaced the core Knight, Ranger, Mage, Skeleton and Bone Archer textures with a new transparent 64×64 pixel set and increased live sprite scale/HP/name spacing.
- Expanded the live arena from 1200 to 1240 px and adjusted the hero deployment bounds to match the new composition.
- Restyled **БОЙ** as the dominant red primary action while keeping **ПЕРЕИГРАТЬ** visually secondary.
- Act 1 now guarantees at least one selected combat in each early/mid/late four-card tier while preserving two-card choice and rejection.
- The mandatory combat slot is randomized among the first three positions of each tier so combat pacing is controlled without becoming fully predictable.
- Death Wager enhanced reward reduced from +75 gold / +50 HP / +8 damage to +60 gold / +35 HP / +5 damage.
- Bone Warden first twelve-card retune to 580 HP / 22 damage was superseded by the 3+3 progression-economy balance pass: 700 HP / 24 damage with stronger enrage.
- Bone Warden final fight upgraded from a single stat/enrage check into a two-phase boss encounter; this new version is pending local verification.

### Added

- Added runtime-decoded approved event character decor for **Curse Forge** and **Chained Prisoner**, bringing the blacksmith and prisoner/environment silhouettes from the approved mockups into the live dynamic event screens without baking gameplay text or values into the background.
- Added a unified dark-gothic ritual presentation layer for non-combat choices: protagonist select, all generic Act 1 event cards, Whispering Well, reward/hero-development screens, prototype/fallback events and the Wizard wager modal now share the same visual hierarchy, framed choices and restrained motion.
- Added event-specific atmosphere variants to the generic event shell (forge sparks, chains, altar rings, bridge fog, candle glow and bone dressing) without changing event mechanics.
- Added combat presentation v2: arena-aware unit tint/rim/contact shadows, short hit-stop, impact sparks, undead bone-fragment deaths, Wizard combat commentary, dynamic arena atmosphere and a cinematic `СХВАТКА` start transition.
- Added data-driven battle arena families via `EncounterData.arena_id`: crypt, graveyard, ossuary and a dedicated Bone Warden lair.
- Distributed all current Act 1 combat encounters across the new arena families, adding distinct lighting, silhouettes, fog/stone/bone dressing and boss-lair chains/gate while preserving the existing combat layer and authored base backdrop.
- Added a richer cursed-table dressing pass: denser wood/runner detail, inlaid deck/discard zones, ritual marks, coins, wax seal and warmer light pools.
- Added stylized five-finger Wizard dealer hands below the live-card layer; they react to deals and visibly reach/glow during card substitution without intercepting input.
- Reworked the wizard table into a physical card spread: visible deck/discard piles, live counts, a 12-card fate track with XIII boss marker, staggered dealing, fan rotation, hover lift and choose/discard motion.
- Added lightweight procedural table-card audio for dealing, selection, discard and Wizard substitution; single-card retry/boss offers now use one centered slot.
- Added Wizard Memory v1: the Wizard now remembers eight behavior families across the run and can reference wagers, companion fates, debt-clearing, battle defeats/retries and greed-heavy gold choices at the table.
- Added role-aware and repeat-aware contextual Wizard lines while keeping memory narrative-only; it does not alter stats, card odds, encounter selection or rewards.
- Added the first voluntary Wizard wager modal at the cursed table: accept +25% enemy damage on the next combat for x2 next ordinary loot, or refuse with no mechanical penalty.
- Scheduled up to two wager opportunities per Act 1 run, suppressed while a Wizard debt is already active; accepted/refused counts are retained for future Wizard-memory dialogue.
- Added the Wizard's first active table cheat: two rare visible card substitutions per Act 1 run, one in the mid tier and one in the late tier.
- A meddling offer briefly locks, the targeted card flips edge-on, and the Wizard replaces it with another same-tier card from the same resolution family; the removed card remains eligible to appear later.
- Added a first combat-feel pass: subtle idle/breathing, role-aware melee/ranged/magic attack motion, ranged/magic tracers, stronger hit response and a falling/fading death presentation.
- Added lightweight runtime-generated combat SFX for melee, ranged and magic attacks, impacts, deaths, Bellkeeper healing, Bone Warden phase change, tactical-order selection, combat start and victory/defeat stingers.
- Three pre-battle tactical orders: **НАТИСК**, **ОХОТА**, **СТРОЙ**.
- **НАТИСК** adds +15% hero movement while keeping nearest-target behavior.
- **ОХОТА** dynamically prioritizes support and ranged enemies, including reinforcements that appear after combat has started.
- **СТРОЙ** dynamically focuses threats nearest the most vulnerable living ally.
- Tactical orders can be switched during deployment and lock when **БОЙ** starts.

- Per-run **КЕМ ТЫ БЫЛ, КОГДА ВСЁ НАЧАЛОСЬ?** class-selection scene after the story prologue.
- Runs now start with exactly one protagonist: Knight, Ranger or Mage.
- Persistent per-run companion fate states: **НЕ РАЗЫГРАНА / В ОТРЯДЕ / ПОТЕРЯН**.
- Knight recruitment through **ЗАКОВАННЫЙ ПЛЕННИК**, with **ПОСЛЕДНИЙ ПРИВАЛ** as fallback if fate remains unresolved.
- Ranger recruitment through **ГРЕМУЧИЙ МОСТ**, with **ПЕПЕЛЬНЫЙ ПРИВАЛ** as fallback.
- Mage recruitment through **ШЕПЧУЩИЙ КОЛОДЕЦ**, with **ЧЁРНЫЙ АЛТАРЬ** as fallback.
- Solo/duo compensation: solo +50% HP/+35% damage, duo +20% HP/+15% damage.
- Run-end party/fate summary.
- **ДОСЬЕ ОТРЯДА** modal on the wizard table, opened by **ОТРЯД [TAB]** or Tab.
- Knight / Ranger / Mage status tabs with portraits from the production combat atlas.
- Derived effective-stat view for HP, damage, attacks/second, range, movement, DPS, minimum range and splash when relevant.
- Base-stat comparison coloring so run changes are immediately visible.
- Per-hero lists of acquired upgrades and currently applicable relics, including party-wide relics.
- Dynamic presentation-only build names such as **ЖЕЛЕЗНАЯ СТЕНА**, **СНАЙПЕР**, **ЗАЛПОВИК**, **ПИРОМАНТ** and **СТЕКЛЯННАЯ ПУШКА**.
- Five-frame skippable dark-fantasy pixel-art comic prologue between the main menu and the first wizard-table deal.
- Intro narrative establishes the aged protagonist, the old pact with the Wizard and the offer to replay a life whose corrected choices rewrite the fates of everyone previously saved.
- Intro controls: click/Space/Enter to advance, painted top-right **ПРОПУСТИТЬ** button and Esc to skip, with short fades between frames.
- Five production 1280×720 WebP intro frames under `assets/pixel/intro/`.
- Data-driven `HeroUpgradeData` run-progression layer.
- Nine unique hero upgrades: three each for Knight, Ranger and Mage.
- Stable per-tier major-upgrade offers stored in RunState so each early/mid/late tier guarantees one build-defining choice after its first combat victory.
- Optional bonus-upgrade reward flow used by Death Wager.
- Hero upgrades apply to runtime HP, damage, attack cadence, range, minimum range, splash and movement before artifacts.
- Run-end summary now lists acquired hero upgrades.
- Dedicated **Bone Warden** combat art instead of reusing the normal Skeleton sprite.
- Dedicated **Bone Warden** final-card illustration.
- Dedicated final-boss arena treatment with red ritual geometry, barred gate, chains and stronger braziers.
- Bone Warden melee cleave: 60% splash damage in a 92 px radius.
- Bone Warden Phase II at 50% HP with a visible transition cue and one Bone Archer + one Bone Thrall reinforcement wave.
- EncounterData optional reinforcement paths/names/positions for small phase-based encounter additions.
- Larger Bone Warden name/HP presentation and pulsing multi-ring boss aura.
- Completed the full 24-card pre-boss Act 1 pool with bespoke mechanics; active cards no longer use the generic prototype resolver.
- Real **ГРЕМУЧИЙ МОСТ** early traversal event with risky, mixed-cost and safe crossing choices.
- Real **КОШЕЛЬ МЕРТВЕЦА** greed event with escalating gold-for-HP trades.
- Real **ТОРГОВЕЦ СВЕЧАМИ** early build shop selling role-specific hero development.
- Real **КОСТЯНАЯ ПОШЛИНА** forced payment event with gold, blood or HP-for-least-developed-hero progression.
- Real **СТАВКА НА СМЕРТЬ** late five-enemy elite encounter.
- Death Wager enhanced reward screen (now +60 gold / visible relic / extra hero-upgrade choice).
- Death Wager-specific **СТАВКА** battle framing and wizard reaction.
- Real late **КАРТА БЕЗ ЛИЦА** event with hidden random outcome, paid safe outcome and guaranteed low-risk burn choice.
- Real **КРОВАВАЯ КНИГА** build-manipulation event: buy development, trade blood for relic/progression, or sell the latest upgrade for gold.
- Special source-locked **СЛОМАННАЯ КОРОНА** artifact: party-wide +22% damage for -10 max HP per hero.
- `ArtifactData.general_pool` and party-wide `target_role = "*"` support for named special relics.
- Real **ПОСЛЕДНИЙ ПРИВАЛ** preparation event choosing a final Knight/Ranger/Mage development.
- Real **ВРАТА ОССУАРИЯ** late combat combining Crypt Guard, Grave Bellkeeper, Bone Archer and Bone Thrall.
- Ossuary Gate-specific preparation and victory framing.
- Real **ЧЁРНЫЙ АЛТАРЬ** event trading party HP for concrete Knight/Ranger/Mage development.
- Real **ЗАКОВАННЫЙ ПЛЕННИК** event with paid least-developed-hero training, blood-for-relic chain breaking, loot and refusal branches.
- Real **КОСТИ ДОЛЖНИКА** event with a 50/50 high-stakes gamble plus two deterministic alternatives.
- Real **ДЕСЯТИНА ВОЛШЕБНИКА** event with gold payment, HP payment or refusal.
- Temporary **ДОЛГ ВОЛШЕБНИКУ** run condition: +25% enemy damage until the next normal reward.
- Wizard debt doubles the next normal gold loot to +50 gold and clears when that loot is taken.
- Wizard-debt HUD and battle-preparation warnings.
- Real **МОГИЛЬНЫЙ ЗВОН** combat encounter with the first support enemy, **Могильный звонарь**.
- Grave Bellkeeper periodic ally-heal pulse with **ЗВОН!** feedback and green healing numbers.
- **Костяной раб** swarm enemy and real five-enemy **КОСТЯНАЯ ДАВКА** encounter.
- **Страж склепа** elite enemy with larger presentation, visible name and melee splash damage.
- Real **СТРАЖ СКЛЕПА** elite encounter with two Bone Thralls.
- Elite reward override: Crypt Guard victory guarantees an unowned artifact choice, or +50 gold if the artifact pool is exhausted.
- Encounter-specific preparation/status framing for Grave Bell, Bone Crush and Crypt Guard.
- Data-driven `ArtifactData` and persistent per-run artifact ownership.
- First three hero-specific artifacts: **ЩИТ МЕРТВЕЦА**, **СЛЕПОЙ КОЛЧАН**, **РАСКОЛОТЫЙ ФОКУС**.
- Artifact combat modifiers for HP, damage, attack interval, range, splash and movement.
- Real **ПЕПЕЛЬНЫЙ ПРИВАЛ** choices: directly develop Knight, Ranger or Mage, or refuse.
- Functional **ЛАВКА МОГИЛЬЩИКА** selling the next role-specific hero development for gold.
- Real **КУЗНИЦА ПРОКЛЯТИЙ** artifact choice with already-owned artifacts disabled.
- Shared Act 1 choice-event scene showing current gold and acquired artifacts.
- Run-end artifact summary.
- Act 1 run structure expanded to 12 resolved pre-boss cards followed by **КОСТЯНОЙ НАДЗИРАТЕЛЬ** as the final boss card.
- Two-card wizard offers: choosing one permanently rejects the other card for that run.
- Data-driven `RunCardData` and a 24-card structural Act 1 pool: 8 early, 8 mid and 8 late cards.
- Generic prototype-card resolver so unimplemented card concepts can participate in real run pacing before bespoke mechanics are built.
- Active combat cards persist after defeat, so returning to the table offers the same fight as **ПОВТОРИТЬ**.
- First boss encounter: **КОСТЯНОЙ НАДЗИРАТЕЛЬ**, now reached after the 12-card Act 1 path.
- Lightweight boss tuning fields in `UnitData`: boss flag, visual scale and one-time HP-threshold enrage modifiers.
- Bone Warden boss presentation with larger sprite scale, visible boss name, wider HP bar, double ground ring and **ЯРОСТЬ!** feedback at 50% HP.
- Boss enrage increases damage, attack speed and movement speed without introducing a general ability framework.
- Boss-specific battle framing: **БОСС** enemy header, preparation warning and a unique wizard reaction after victory.
- Final wizard-table composition pass: compact HUD/commentary strip, slightly smaller and lower card row, wider breathing room around the wizard, and a subdued lower runner/sigil.
- Encounter-specific wizard reactions on card hover, including a dedicated Whispering Well teaser.
- Approved wizard-table concept archived at `assets/concepts/approved_table_direction.png`.
- Approved battle composition reference archived at `assets/concepts/approved_battle_direction.jpg`.
- Rebuilt wizard table using authored concept slices plus live Godot UI.
- Authored pixel wizard/room backdrop, Misdeal logo and four encounter/event card illustrations under `assets/pixel/table/`.
- Illustrated interactive cards now keep encounter text and state data-driven instead of baking gameplay values into the background.
- Dynamic table HUD remains live for deal count, gold, HP modifier and damage modifier.
- Cross-screen pixel-art UI pass for the main menu, wizard table, Whispering Well, reward screen and run-end screen.
- Procedural pixel wizard table with masonry, cursed wood, ritual sigil, candles and deck.
- Pixel wizard portrait used as the active table host visual.
- Pixel Whispering Well backdrop with stonework, glowing water and teal-lit choices.
- Pixel reward altar presentation with three visually distinct reward cards.
- Pixel run-end ritual summary screen and pixel main-menu title composition.
- Atmospheric pixel battle presentation pass with masonry ruins, banners, torches, bones, rubble, blood stains and stronger ritual markings.
- Framed pixel HUD chrome for encounter/status/command areas.
- Dynamic Act 1 card-progress indicator in table and battle HUD.
- Framed victory/defeat result panel.
- Short attack-lunge motion for combat sprites.
- First dark-fantasy pixel-art combat sprite set for Knight, Ranger, Mage, Skeleton and Bone Archer (superseded by the new 64×64 set in the approved battle-visual rebuild).
- Pixel-stone battle arena renderer with restrained ritual markings.
- Ground-level team rings, compact team-colored HP bars and larger nearest-neighbor unit sprites.
- Pixel-styled battle buttons and reduced combat text clutter.
- First authored dark-fantasy art asset pack under `assets/art/`.
- Painted cursed-table background and authored evil-wizard portrait integrated into the table scene.
- Authored cursed card-back art added to the table composition.
- Authored Knight, Ranger, Mage, Skeleton and Bone Archer miniature textures integrated into combat.
- Procedural unit silhouettes retained as fallback visuals while gameplay rings/HP/feedback stay readable.
- First procedural visual blockout for the cursed table with wood grain, ritual markings and candle accents.
- Styled combat/event card frames with hover depth and distinct event-card treatment.
- Expanded wizard portrait blockout with stronger silhouette, crown details and pulsing orb.
- Data-driven unit visual roles and distinct prototype miniatures for Knight, Ranger, Mage, Skeleton and Bone Archer.
- First non-combat event card: **ШЕПЧУЩИЙ КОЛОДЕЦ**.
- One-time Whispering Well state and three choices: blood-for-development, gold-for-relic/build fallback, or refusal.
- Whispering Well gold spend now buys a relic/build fallback rather than raw party HP.
- Animated placeholder wizard portrait with pulsing eyes on the table.
- Data-driven `EncounterData` Resource type.
- Three playable combat cards: Bone Patrol, Graveyard Ambush and Gallows Volley.
- Selected encounters now drive enemy composition and spawn positions in the generic battle scene.
- Three-victory finite run structure.
- Run-end summary scene with a new-run action.
- Russian player-facing text across the main menu, wizard table, battle, rewards and unit display names.
- First wizard-table scene with a playable Graveyard Ambush card and two face-down placeholders.
- Persistent prototype `RunState` autoload.
- Post-victory reward scene with Blood Coin, Iron Ward and Tempered Steel choices.
- Persistent party-wide HP and damage reward bonuses applied to later battles.
- Post-battle flow from victory to rewards and back to the table.
- Defeat return path to the table.
- Bone Archer enemy with ranged keep-distance behavior.
- Mage splash damage that hits nearby secondary enemies.
- Data-driven `UnitData` Resource type.
- Separate Knight, Ranger, Mage and Skeleton `.tres` unit definitions.
- Battle spawning now reads unit stats from Resources instead of hard-coded stat arguments.
- Hit flash and impact scale pulse when units take damage.
- Floating damage numbers.
- Short shrink/fade feedback on unit death.
- Combat-time separation steering so living units no longer stack into a single point.
- Pre-battle preparation phase.
- Drag-and-drop repositioning for player heroes.
- Deployment-zone bounds.
- Rejection of overlapping hero placement.
- Placement guidance in the battle UI.
- Placement automatically locks when **FIGHT** is pressed.

### Project workflow

- Added persistent project-state documentation for continuity across ChatGPT Project chats.
- Established GitHub as the source of truth for implemented technical state.
- Added roadmap and decision log maintenance rules.

## 2026-10-04 — First playable combat prototype

### Added

- Initial Godot 4.7.x project.
- Misdeal title/main scene.
- Transition from the main screen into a test battle.
- Test encounter with Knight, Ranger and Mage versus three Skeletons.
- Automatic nearest-enemy targeting.
- Automatic movement and attacks.
- Melee/ranged attack ranges and attack cooldowns.
- Health bars, death state, victory and defeat detection.
- Battle restart.
- `UPDATE_MISDEAL.bat` helper for pulling repository updates.
- Initial game concept and development guide.

### Verified

- User confirmed the autobattle completes successfully locally.
- User confirmed **RESTART** correctly reloads the encounter.
