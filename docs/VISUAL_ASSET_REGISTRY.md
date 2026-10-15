## 2026-10-15 — D153 ORIGINAL SKELETAL ANIMATION ATLASES COMMITTED; NATIVE ART QA PENDING

**Latest implemented source:** Both new, independently authored skeleton pixel-art animation WebP/base64 atlases now exist on `main`:
- `assets/pixel/units/deck_expansion_v1/threadbare_puppeteer_frames.webp.b64` (3,504 WebP bytes; SHA-256 `b3d13f1eea6f84eb43d6a3d14308b49f7cf0394beebe29bda72dfa4a4c8d0989`).
- `assets/pixel/units/deck_expansion_v1/bone_marionette_frames.webp.b64` (3,178 WebP bytes; SHA-256 `dcd1c3079917d1171b7026a9fa08aefd71e7121852d47fc136d42e0bef50e7eb`).

Each decoded lossless WebP is **576×480**, 6×5 transparent cells of 96×96 with **25 separately drawn, non-identical, visible skeleton poses** (idle 4, walk 6, attack 6, hit 3, death 6). Both were decoded and checked **after WebP export** for nonempty/unique used cells, transparent unused cells, two-pixel empty borders, full feet and source-right orientation. Both GitHub files were remotely refetched and their decoded bytes SHA-256 matched the local originals **exactly**. They are deliberately stylized hand-built pixel miniatures, not recycled enemy artwork, card-image cutouts or concept-board frames; full motion visual signoff remains the user's call. See `docs/D153_ANIMATION_ATLASES.md`.

**NEXT USER ACTION:** `git pull`, then **F6 `res://scenes/dev/threadbare_theatre_art_preview.tscn`**. Inspect both original skeletons across five repeating states (every 2 seconds), visible feet, direction, transitions, thread effects and no disappearing frames; send a screenshot or specific corrections. **This F6 has NOT been run in native Godot since the atlases were added, so do not claim user art acceptance or runtime PASS.** Existing prior D153 tether-logic F6 **PASS** remains valid; don't rerun it just to review sprites.

**Still gated (NOT live):** User's native gallery acceptance, authored theatre arena, production battle-only ThreadTether wiring, real battle→reward→table and 54-case matrix. D153 remains absent from both `RunState.CARD_PATHS` and `ACT1_CARD_IDS`; **live Act1 = 35/45**, 12 Fate Spread + sealed XIII. DS2 and D143/D167/D168 frozen. GitHub writes belong to the assistant; no manual ZIP, image transfer, code copy or upload.

---

## D152 approved environmental card art V2 installed + D168 variants rule (2026-10-15)

**Approved scene artwork delivered to GitHub:** `assets/pixel/card_unification_v1/run/defiled_laboratory_scene_v2.webp.b64` is the user-approved environment-driven D152 448×274 illustration (gothic alchemical laboratory with hooded Plague Alchemist, unstable Homunculus, vats, glassware, cages and occult light). `scripts/ui/card_unification_v1.gd` now points `D152_CARD_WEBP_B64` to this exact V2 file. GitHub content bytes were independently refetched and verified **identical** to the source; old sprite-showcase image remains unchanged in `assets/pixel/card_unification_v1/run/defiled_laboratory.webp.b64` for a one-line rollback. User approved the original composition **before** replacement, but the new v2 **has not yet been F6-reviewed inside Godot**. Original enemy 25-frame sprite atlases/balance unaffected, live deck still **35/45**. D168 now requires 2–3 real, meaningfully distinct visual previews **before** finalizing all future card art (default 3); D152 is an explicitly approved one-off exception. See AGENTS.md and DECISIONS.md D167/D168.

---

## D167 CARD SCENE RULE + D152 ENVIRONMENTAL ART CANDIDATE — 2026-10-15

**Approved rule:** encounter card images must look like slices of Misdeal's dark-fantasy world, never character sprite showcases. Must include narrative environment, scale, shadows, volumetric atmosphere, approved DS2 restrained palette; UI and card text live in Godot, not the image. Canonical: `AGENTS.md` and `docs/DECISIONS.md` D167.

**D152 visual candidate:** a new illustrated original alchemy workshop has been generated in this work session, with vaulted occult gothic laboratory architecture, suspended cages, green reaction vats, alchemical glassware, dark crimson drapery, liquid spills, a hooded Plague Alchemist and a crouched Homunculus both integrated into the scene. Prepared at 448×274 and visually inspected. **IMPORTANT: this candidate is NOT committed into GitHub runtime assets yet because the cross-tool byte transfer failed.** The live art remains the previous sprite-on-blurred-backdrop version under `assets/pixel/card_unification_v1/run/defiled_laboratory.webp.b64`. Preserve original art until transfer; use a versioned path for the new artwork and obtain user native F6 screenshot after changing the art loader. No mechanics, balance, cards or animation changes. The art can be re-generated from this scene description if conversation-local PNG is inaccessible in a fresh session.

---

## D151 ART/RESOURCE QA — 2026-10-15

User approved revised full-footprint `funeral_priest` and `pallbearer` (each 25 authored frames) and corrected left-facing source orientation. Godot F6 `funeral_procession_smoke.tscn` now **54/54 PASS**, confirms original 448×274 `funeral_procession` card and both 576×480 WebP animation atlases are loaded. The 54-case smoke does not certify every animation frame's artistic quality beyond prior user preview approval, nor normal reward transition or balance. Preserve accepted image binaries, palette and DS2 styling; no art assets changed in this QA-only update. `docs/DECK_EXPANSION_D151_FINAL_SMOKE_QA.md` is the dated acceptance reference.

---

## D151 RELEASE — 2026-10-15 — FUNERAL PROCESSION NOW LIVE AS ACT1 CARD 34/45

User replied «все ок» after D151 role-facing hotfix and the instructions to re-check the real playtest and 54-case smoke. Treat this as **user acceptance of the corrected in-game facing and overall result**, without inventing a separate 54/54 screenshot or exact win/loss counts. Live source now registers `funeral_procession` in `RunState.ACT1_CARD_IDS` (34 distinct nonboss cards including original priest + two coffin bearers); its `CARD_PATHS` was already present. Existing `scripts/battle/battle.gd` calls scoped `LastRiteController` start/stop for this encounter only. Previously approved D151 original card 448×274 WebP, original 25-frame sprite atlases, no-bell art direction and role-local facing correction all remain unchanged. Updated fixed-count guards in `scripts/dev/bone_shepherd_smoke.gd` and `scripts/dev/funeral_procession_smoke.gd` from 33 to 34. Exactly **12 Fate Spread resolutions plus sealed XIII** per run still unchanged; overall planned 45-card goal remains. Older Bellkeeper, Bone Shepherd, DS2 art, and balance multipliers untouched. **New release commit and test changes have not yet been re-run in native Godot by assistant**; perform one post-pull F6 `funeral_procession_smoke.tscn` and optionally a live normal-run/reward flow to catch any integration regressions. DO NOT claim independently verified post-release 54/54 metric. Next feature work: remaining 11 of 45 cards; every new fight requires new roles/behavior/art per D143. Original issue and decision history are below.

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

## D147 APPROVED VISUAL ASSETS INSTALLED — 2026-10-14
Imported user-approved 448x274 Bone Shepherd full-bleed WebP plus 576x480 25-frame raster animation atlases for Shepherd and Ossuary Lamb from verified D147 package. Production code prefers these new assets with SVG fallback. Gameplay, Whistle, UnitData, card pool and previously approved art unchanged. All files committed by local install script; Godot F6 gallery, playtest and 54/54 smoke still require user validation.

---

## D147 — 2026-10-14 — approved Bone Shepherd visuals prepared; GitHub loaders staged; binary import pending

User approved the **FIRST** of the two 2026-10-14 cinematic Bone Shepherd artworks (generation `46ed7a48-538d-4e5c-bd0f-27a0c41a7bbf`; Shepherd centered between two horned Lambs). Production card is center-cropped/resampled to **448×274** full-bleed WebP, no baked text or borders. Previously positively received Shepherd and Ossuary Lamb pose sheets converted into separate transparent **576×480 (6×5 96px)** animated WebP atlases (idle 4, walk 6, attack 6, hit 3, death 6); they have not been Godot-validated yet. **Production code changes ALREADY COMMITTED:** `scripts/ui/card_unification_v1.gd` prefers `run/bone_shepherd.webp`, fallback old SVG; `scripts/battle/unit_animation_library.gd` prefers `.webp.b64` for both new enemy roles, fallback existing SVG. **BINARY TEXTURES ARE NOT YET IN GITHUB MAIN**: ready-to-install art ZIP `Misdeal_D147_Approved_Bone_Shepherd_Art.zip` generated as a chat attachment with installer (`install.cmd`), SHA256 manifest, safe file import plus local Git commit/push and documentation updates. Once the user runs that single installer locally, source of truth will include actual assets; until then old SVG continues to render safely. No card pool, battle Whistle, old art, DS2/Fate Spread or stat change. **Still pending:** Godot F6 art preview, playtest, 54/54 smoke, user QA. No engine PASS claimed.

---

## D146 — NEW visual rework contract, not yet imported (2026-10-14)

The user has rejected D145 flat SVG card and unit visuals. Inspected accepted standalone painterly references `run/bone_patrol.webp`, `run/bone_swarm.webp`, `run/grave_crossfire.webp` and the richer Knight/Bone Warden 576×480 combat animation packs. D146 calls for real standalone painterly 448×274 Bone Shepherd illustration + two detailed authentic 25-pose creature atlases. Session's four image-generated multi-panel layout boards are **concept references only**; no generated asset has been connected to Godot. Keep original D145 asset paths listed below as current but rejected/unapproved until reviewed replacements ship. Full locked acceptance criteria: `docs/DECK_EXPANSION_D146_ART_REWORK.md`.

---

## D145 NEW ENEMY ART REFINEMENT — 2026-10-14 — local Godot review pending

Following screenshots of the first `bone_shepherd` and `ossuary_lamb` Godot sprites (visibly too flat for the detailed approved cemetery), the user authorized a focused artwork pass. Both existing original `assets/pixel/units/deck_expansion_v1/{bone_shepherd,ossuary_lamb}_frames.svg` remain separate **576×480 / 6×5 / 96px** native Godot texture sources with all **25** animated pose groups but now have significantly richer restrained DS2 texture/lighting: skull and rib shadows, weathered red funeral cloth, bronze, crisp hooves, lantern on Shepherd staff, and distinct tall commander versus low quadruped silhouettes. `assets/pixel/card_unification_v1/run/bone_shepherd.svg` stays a **448×274** dedicated illustration and now layers moonlit cemetery stones/fence/chapel, wet cobbles, ritual-cloth and warm light. **Original user-approved 18 previous Wave1 WebP assets stay untouched.** New composite imagegen boards were only inspiration; actual art sources remain directly authored SVG. Static SVG/XML/25-frame QA passed; Godot post-redraw screenshot/approval **not yet received**. See `docs/DECISIONS.md` D145. Current test scene `res://scenes/dev/bone_shepherd_art_preview.tscn`. Prior 54-case smoke parser fix still awaits rerun.

---

## NEW DECK EXPANSION ART — D144 Bone Shepherd source SVG (2026-10-14; local Godot visual QA pending)

This is **additional content**, separate from and in no way replacing the previous 18/18 approved Wave-1 WebP assets. The user approved the broad concept but **has not reviewed these live game atlas textures yet**. The composite generated concept-sheet image `e0f6a604-d75f-4cd2-83f0-3ab10fe24749` was illustrative only, **not the imported game asset**. All new files are independently authored pixel-shape SVG sources kept as UTF-8 in GitHub (the connected GitHub connector does not upload binary file contents), then loaded/imported by Godot as texture images.

| New visual | GitHub path | Dimensions | State |
|---|---|---:|---|
| `bone_shepherd` | `assets/pixel/units/deck_expansion_v1/bone_shepherd_frames.svg` | 576×480 (6×5 grid, 96px per cell) | 25 original five-state frames, SVG importer + Godot gallery visual QA pending |
| `ossuary_lamb` | `assets/pixel/units/deck_expansion_v1/ossuary_lamb_frames.svg` | 576×480 (6×5 grid, 96px per cell) | 25 original five-state frames, hoof/stance readability QA pending |
| `bone_shepherd` run card | `assets/pixel/card_unification_v1/run/bone_shepherd.svg` | 448×274 | Original cemetery-scene/card image, user in-engine approval pending |

Actual runtime: `scripts/battle/unit_animation_library.gd` uses `load(svg_path) as Texture2D` to build 4 idle, 6 walk, 6 attack, 3 hit, 6 death `SpriteFrames` per role, preserving new-species idle texture fallback. `scripts/ui/card_unification_v1.gd` returns the dedicated new card `Texture2D`. New SVG art must display feet/hooves correctly when rendered via `BattleUnit` at 1280×720; genuine Godot import not yet tested by assistant. F6 `res://scenes/dev/bone_shepherd_art_preview.tscn` to inspect. Existing imported units and Fate Spread unchanged. Source/UX accuracy: the real battle contains **1 Shepherd +2 Lambs, no ghost or dog**.

---

### FIRST WAVE COMPLETE — 2026-10-13 — D135 last 5 standalone WebP assets in GitHub

New five separate user-approved images from `docs/CARD_ART_WAVE1_REMAINING5_BRIEF.md` uploaded as **raw GitHub binaries** in `ac860ad2cacf17e7ab4e64c54f2ddfb70debd146`. Paths relative to `assets/pixel/card_unification_v1/`, SHA256 of the actual shipped WebP bytes:

| Live ID | Relative path | Pixels | Bytes | SHA256 |
|---|---|---|---:|---|
| `gravedigger_shop` | `run/gravedigger_shop.webp` | 448×274 | 42900 | `27d946f5d00366d3c53ff148f5525a83a75129364055acb67bda84d98901a667` |
| `bone_swarm` | `run/bone_swarm.webp` | 448×274 | 60158 | `444558761d3715a264025dd2cbe0d3925f1765aafbe21facb31805680fcf3664` |
| `grave_crossfire` | `run/grave_crossfire.webp` | 448×274 | 39878 | `d501bef16504efb8b73a175e6f41b866522d73555370974e083200d4f8123f8a` |
| `candle_seller` | `event/candle_seller.webp` | 1280×720 | 215846 | `33130fc7634cca9a1382effdf1319f6abcf8a6fd91a53176621fe5cce3605641` |
| `last_camp` | `event/last_camp.webp` | 1280×720 | 217006 | `ef6116ce8f8af9431642667752579e51363e8e0ccb071a118b1904f8658f0bc5` |

Git blob IDs remotely verified (all five). Mappings added in `scripts/ui/card_unification_v1.gd`: 3 `RUN_CARDS`, 2 `EVENTS`; original atlas event-path fallback remains. `gravedigger_shop` only overwrites its dealt-card illustration, NOT the separately approved Gravedigger Shop live DS2 appearance/economy; `bone_swarm` / `grave_crossfire` replace only offer card art, with combat logic untouched; `candle_seller` / `last_camp` supply both event background and cropped deal-card image through existing resolver. Exact source PNG titles/gen IDs and user approval: decision D135. New `scenes/dev/card_unification_final5_preview.tscn` F6 gallery for these five. Total D131 4 + D132 4 + D134 5 + D135 5 = **18/18** first-wave source inventory illustrations now committed, **without a Godot 4.7.x runtime certification**. User needs local smoke.

---

### ACTIVE UPGRADE AND REWARD ART — 2026-10-13 — D134 five files in GitHub main

Approved as five separate latest images and shipped as real WebP binaries in `e3729a4a86a9cce006ec8803fa6e7e0aa1f00de5`. All source 1570×1002, exported **608×388**, quality 90, directly resampled, no collage upscaling. Paths relative to `assets/pixel/card_unification_v1/`:

| Live ID | File path | Bytes | SHA256 |
|---|---|---:|---|
| `knight_iron_oath` | `upgrade/knight_iron_oath.webp` | 84528 | `57dc237b0ec6ea7fe785e82d633cd04043a788ac2d9f35337ca54229d77f59e9` |
| `ranger_arrowstorm` | `upgrade/ranger_arrowstorm.webp` | 79182 | `2d2ce9078d81de6fbbf066fe52e6ad3ed6ef0f0d545632168a3f6526fa5e7a5d` |
| `mage_glass_heart` | `upgrade/mage_glass_heart.webp` | 89166 | `25cda1fb23898a5ab5cfd7f2e0b8f2b6156e95b66ffd6e24267a47ca422bcf4e` |
| `gold_windfall` | `reward/gold_windfall.webp` | 89446 | `ac955a469970f05f3c92cdfd5a36e754441b256c213c0e1b19396c5ef663d8d0` |
| `relic_wager` | `reward/relic_wager.webp` | 56646 | `6cc40c40c20abbbd8557ad08c0d38446c134e20c5ec2d15c9d5da68cb829b669` |

The `CardArtCatalog.get_upgrade_texture()` / `get_reward_texture()` override lookup is already present. Original fallback atlas is retained; no UI/code changes in this art commit. User accepted images as drawn; local Godot in-engine QA still pending. User requirements: male gray-bearded wizard for `mage_glass_heart`, skeletal hand gripping ruby for `relic_wager`. D134 records exact source image names and generation IDs. **13/13 pictured D130 slots now have binary assets**; earlier 18-art inventory has additional 5 candidate-only items still outside approval/deployment.

---

### LIVE EVENT BACKGROUNDS — 2026-10-13 — D132 four approved 1280×720 WebPs in main

Binary delivery completed in `1722d070cfe5a5690596953a1465b198177a57b3`; paths below have their own separate approved event compositions (user signed off, no further generation needed):

| Event ID | New WebP, relative to `assets/pixel/card_unification_v1/event/` | Bytes | SHA256 |
|---|---|---:|---|
| `curse_forge` | `curse_forge.webp` | 284100 | `04658f71ce0aff97ed77235165fb7a9ea05f3ad848fe89b49239a31bf47b03ea` |
| `black_altar` | `black_altar.webp` | 213172 | `33dcb8351ca90da60e91e0fcaf5b7c0a6e27d6ad830d6434d453de8f8472b933` |
| `chained_prisoner` | `chained_prisoner.webp` | 251358 | `97ddc751b5390407269ebf8fb0dbb53a4ea41b6bdb1ab2077455dcf632093fb7` |
| `rattling_bridge` | `rattling_bridge.webp` | 179336 | `e85c8385f9dae40c9f05310a04f6d01e9f56081bfad6b7e0f66fb14b3cdebe8b` |

All exactly 1280×720 WEBP quality 91 exported from latest approved 1672×941 originals, rather than upscaled D130 contact sheet crops. Remote GitHub blobs verified; existing `card_unification_v1.gd` and `act_choice.gd` choose these first, preserving older backdrops as fallback. **In-engine live visuals remain for user to check**. D132 binds four exact source concepts. No other event/DS2/UI screen modified. Keep these distinct from 448×274 RunCard art.

---

### ACTIVE CARD ART — 2026-10-13 — D131 four approved deal-card WebPs now in GitHub main

The user-approved latest four D131 images were exported from their native 1604×981 PNGs as dedicated **448×274 WebP** (quality 82, not resized from the previous small concept collage) and committed as actual binary blobs in **`9d864113d66236111b8a3f048afaac35416cedf1`**:
- `assets/pixel/card_unification_v1/run/bone_patrol.webp` — 28,422 bytes; SHA256 `98d49a68620a0c096b90e9840d7cb6918ab090c519b9a129a7de4c6bb5dc515a`
- `assets/pixel/card_unification_v1/run/graveyard_ambush.webp` — 28,626 bytes; SHA256 `120b2410843b51e13162cf6a6e59f5c82b2da9819dff491926ea3b4fd614775f`
- `assets/pixel/card_unification_v1/run/gallows_volley.webp` — 20,632 bytes; SHA256 `4b71652ba533aff009a41988bf1b1c4e5fb088a8ce9f2b61d1a77565b88455f0`
- `assets/pixel/card_unification_v1/run/whispering_well.webp` — 29,670 bytes; SHA256 `2b6cd5446498264b493626fd772015ed860c00affd316dba8dfd80d983960665`

All four GitHub blob SHAs were verified. `scripts/ui/card_unification_v1.gd` is already loaded by `scripts/ui/card_art_catalog.gd` and selects these textures before previous v4 atlas. Existing art atlas remains as safe fallback. This modifies table **card images only**: the Whispering Well full event screen and DS2 Fate Spread stay untouched. D131 contains the precise approved originals/generation IDs and character requirements. **Local Godot F6/actual table visual QA is still pending.** The earlier chat artifact `misdeal_card_art_wave1_import.zip` included obsolete blurry versions for these four IDs and must not overwrite the new files after pulling. If those ZIP files were previously extracted as untracked files, remove/move just those four WebPs before `git pull` to avoid Git refusing to overwrite untracked paths.

---

### CURRENT MAGE — 2026-10-12 — clean bearded Mage sheet

- New active Mage `assets/pixel/units/combat_units_anim_v2/mage.webp.b64` commit `9d72854`, transparent 576×480, 25 used frames; old low-quality Mage archived `mage_archived_pre_dark_clean.webp.b64` commit `089b9fd`.
- Mage hero-only scale 1.65 remains as visually accepted in screenshot; Mage attack plays six authored frames (`6ce91f9`).
- Pending Godot F6 and actual battle review for alpha, limb silhouette, attack effects and ground contact.

### CURRENT MAGE ART — 2026-10-12 — elder bearded Mage atlas committed

- Active Mage: `assets/pixel/units/combat_units_anim_v2/mage.webp.b64` (`3e23cc8`), approved variant 1 of latest three concepts; white-bearded elder in dark-violet robes with glowing staff. Prior Mage asset archived as `mage_archived_pre_oldbeard.webp.b64` (`4c0e94a`).
- Existing SpriteFrames animated role remains unchanged in code. Remote file matches approved source. Local Godot F6 and live fight QA are pending, especially 25-pose boundaries, attack projectile and alignment.
- Other Pack 1/Pack 2 role configuration unchanged.

### CURRENT UNIT ART — 2026-10-12 — Blue Knight frame animation active

- Approved blue Knight 576×480 atlas is now `assets/pixel/units/combat_units_anim_v2/knight.webp.b64` (`6afd288`), with the prior flawed sheet preserved as `knight_archived_pre_blue.webp.b64` (`0101679`). Live `BattleUnit` no longer excludes Knight from SpriteFrames (`dffa7ee`).
- All Pack 1 five roles and Pack 2 four enemies are now animation-enabled (asset-dependent static-v4 fallback). Local Godot F6 and real fights are required to accept boots, attack frames and overall coherence.
- Older registry statements below claiming Knight is static v4 are historical and superseded by this header.

### PACK 2 CURRENT STATUS — 2026-10-12 — Four enemy animated sheets committed

- **Active Pack 2 sheets:** `assets/pixel/units/combat_units_anim_pack2_candidates/{bone_thrall,grave_bellkeeper,crypt_guard,bone_warden}.webp.b64` — 576×480 transparent WebP Base64, 6×5 × 96px, 25 used frames per role.
- **Last asset:** Bone Warden (`77a759d`), **loader:** `1238b3c`. `MisdealUnitAnimationLibrary` selects all 4 Pack 2 roles with v4 fallback. Existing Stage A attack VFX unchanged.
- **Godot quality gate remains open:** F6 5-state inspection and in-battle grounding/phase verification needed, especially for boss attack arc and death. Knight static v4; Ranger/Mage/Skeleton/Bone Archer Pack 1 v2 animated.

### CURRENT PACK 2 STATUS — 2026-10-12 — Crypt Guard added

- Pack 2 active animation roles: `bone_thrall`, `grave_bellkeeper`, `crypt_guard`; each has transparent 576×480 Base64 WebP in `assets/pixel/units/combat_units_anim_pack2_candidates/` and is loaded by `MisdealUnitAnimationLibrary` with v4 fallback.
- Crypt Guard commit: asset `5412b1d`, loader `fa78548`; offline 25-frame grid QA passed but in-engine F6 and battle review still pending.
- `bone_warden` remains static v4 with Stage A contact FX and needs a genuinely authored sheet. Knight intentionally static v4; the four other Pack 1 roles remain animated.

### CURRENT STATUS — 2026-10-12 — Pack 2 Bone Thrall + Grave Bellkeeper

- **In GitHub and used by production loader:** `assets/pixel/units/combat_units_anim_pack2_candidates/bone_thrall.webp.b64` and `grave_bellkeeper.webp.b64` (transparent 576×480; 6×5; 25 used poses each), v4 fallback. Latest Bellkeeper asset commit `c28011d`, loader commit `9f32e4b`.
- **Still static v4:** `crypt_guard` and `bone_warden`, each with existing Stage A attack-contact VFX. Knight intentionally static v4; other four Pack 1 roles animate as before.
- **QA:** user approved Bellkeeper visual and offline technical frame checks passed, but no Godot F6 or actual combat runtime review has yet occurred. Old registry entries below predating this header are historical.

### CURRENT GAME-ART STATUS — 2026-10-12 — Pack 2 staging complete; new character animation art missing

- **LIVE NOW:** Knight uses readable static v4 (offset -8); Ranger, male Mage, Skeleton and Bone Archer use real Pack 1 v2 frames. Bone Thrall, Grave Bellkeeper, Crypt Guard and Bone Warden still use **static v4** plus already-live Stage A short contact VFX.
- **NOT YET CREATED / NOT IN BATTLE:** 4 authentic per-role transparent 576x480 sheets (6x5 grid, 96px cells; 25 used frames), for `bone_thrall`, `grave_bellkeeper`, `crypt_guard`, `bone_warden`. No candidate `.webp.b64` has been approved or enabled. Candidate folder contains README only.
- **PREPARATION FINISHED:** staged importer `scripts/dev/import_animation_pack2_candidate.py`, isolated Godot validator `scripts/dev/unit_animation_candidate_validator.gd`, F6 comparison `scenes/dev/unit_animation_pack2_preview.tscn`. Details in `docs/UNIT_ANIMATION_PACK2.md`; check manual visual integrity of feet, weapon, pixel art and grounded fall.
- **Important correction:** historical sections below refer to Knight as animated in Pack 1, but its animation was withdrawn from **current production** because legs were unreadable. Keep v4 until redesigned frames pass visual review. Stage B has not altered the production loader or miniature art.
### Animation Pack 1 grounded v2 — live asset set (2026-10-12)

- Canonical live animation assets are now `assets/pixel/units/combat_units_anim_v2/{knight,ranger,mage,skeleton,bone_archer}.webp.b64`. Original `combat_units_anim_v1` remains committed for rollback.
- Cleaned detached previous-row legs/border scraps from generated sheet cuts and vertically aligned all **125 processed frame cells** (124 active character frames; Mage projectile-only frame is excluded) to last solid foot/body contact pixel **y=92** inside their 96×96 cells. The loader applies 2.7 fps Idle, 7 fps Walk.
- Unit animation rest-position is computed in `BattleUnit` from pixel sole center y=92.5 to current floor shadow ring y=36 using effective art scale; all real-world spawn placements and health labels remain unchanged. No combat/game-balance or arena art edits.
- Source review, applied fix and local gate documented in `docs/UNIT_ANIMATION_PACK1.md`.

### Unit Animation Pack 1 — active for five roles (2026-10-12)

- Five 576×480 transparent WebP atlases stored as Base64 text in `assets/pixel/units/combat_units_anim_v1/{knight,ranger,mage,skeleton,bone_archer}.webp.b64` (30 fixed 96×96 slots, only valid cells populated).
- Generated input sheets: `пиксельный_спрайт_лист_синего_рыцаря.png`, `пиксельный_спрайт_лист_лесного_следопыта.png`, `пиксельный_атлас_тёмного_мага.png` (male Mage), `пиксельный_спрайт_лист_скелета_воина.png`, `пиксельный_спрайт_лист_скелета_лучника.png`, each 1374×1145 (6×5 × 229px).
- Layout: row 0 Idle (4 frames), row 1 Walk (6), row 2 Attack (6; male Mage skips isolated projectile slot and uses 5), row 3 Hit (3), row 4 Death (6). Framerates and state rules in `scripts/battle/unit_animation_library.gd`; `BattleUnit` swaps frame textures and syncs rim texture.
- Remaining aliases and units still use static v4. Approved v4 atlas/male-Mage override stay in repo for safe fallback. This animation pass does not modify arena background art or existing map/grid conditions.
- F6 gallery: `res://scenes/dev/unit_animation_pack1_preview.tscn`. Full mapping and visual QA in `docs/UNIT_ANIMATION_PACK1.md`. Godot runtime QA pending.

### Combat Miniatures — approved Unit Art v4 (active 2026-10-11)

- Canonical runtime 3×3 transparent WebP atlas, 288×288, 96×96 per sprite: `assets/pixel/units/combat_units_v4/atlas.webp.b64`.
- Lossless editable 288×288 cutout master: `assets/source_archive/unit_art_v4/combat_units_v4_master.png.b64`; base64 decode to PNG before editing.
- Runtime loading and fixed 3×3 role index mapping: `scripts/battle/unit.gd` (`_get_art_texture`, `_get_unit_sheet_texture`).
- Tile order in the fallback atlas: row 0 `knight`, `ranger`, `mage`; row 1 `skeleton`, `bone_archer`, `grave_bellkeeper`; row 2 `bone_thrall`, `crypt_guard`, `bone_warden`.
- **Active male Mage override (2026-10-12):** `assets/pixel/units/combat_units_v4/mage_male.webp.b64` (standalone transparent 96×96 WebP, decoded in `_get_male_mage_texture()`); fallback is the atlas Mage cell. Lossless tile source: `assets/source_archive/unit_art_v4/mage_male_tile.png.b64`. Enemy sprites use `flip_h=true` on spawn, then turn toward live targets during combat; `RimSprite` flip is synchronized.
- Approved concept choice: Variant A for Knight/Ranger/Mage; detailed undead variants from the approved bestiary sheet. Nine transparent sprites were manually extracted/trimmed from the previously approved concepts, then cleaned.
- `bone_raider` and `crypt_sentinel` UnitData retain `visual_role` aliases to `bone_thrall` and `crypt_guard` pending unique silhouettes.
- Archived v3 parts (`assets/pixel/units/combat_units_v3/part_*.txt`) remain in GitHub for fallback. Game tests still need to validate pixel transparency, readability and labels.

### Fate Spread

- Approved visual direction: ornate physical occult table with red ritual cloth, candle/brass highlights, gothic edge props and chained XIII as the central focal point.
- Approved runtime plate: `assets/pixel/table/fate_spread/fate_spread_exact.webp`
- Live scene: `scenes/table/fate_spread_overlay.tscn`
- Live logic: `scripts/table/fate_spread_overlay.gd`
- Approved source master: `assets/source_archive/fate_spread/fate_spread_exact_master.webp`
- Earlier edge-art masters remain archived under `assets/source_archive/fate_spread_edges/` but are no longer runtime assets.
- Rule: the plate is atmosphere only. I–XII history, XIII state, counters, hold/discard contents and decision memory remain live Godot UI.
- The full plate defines the physical composition. Baked run-specific examples are covered by live masks/cards; `RunState` remains authoritative for cards, counts, Hold/Discard and XIII.

# Misdeal — Visual Asset Registry

Last updated: 2026-10-11

Purpose: make visual-source provenance and runtime mapping recoverable from GitHub without reading old chats.

## Canonical loading rules

- Dynamic text/state/buttons remain native Godot UI.
- Full-screen authored WebPs added through recent passes use runtime decoding through `scripts/ui/runtime_webp_texture.gd` or an equivalent battle-specific runtime decoder.
- New screen art should be native 1280×720 when it fills the viewport.
- Table-card art should stay near live display size or better; do not recreate the rejected 112×69 atlas approach.
- Source/master archives are not runtime dependencies.

## Production visual passes

### Card art

- v4: `assets/pixel/ui/visual_pass_v4/` — accepted corrected near-display redraw atlas.
- v5: `assets/pixel/ui/visual_pass_v5/` — completion batch for remaining table cards.
- v6 Bone Warden card: `assets/pixel/ui/visual_pass_v6/bone_warden_card.webp`.
- Broken Crown table card deliberately shares the approved Broken Crown artifact illustration.

All 25 active Act 1 cards resolve to current matching/object-specific art before legacy safety fallback.

### Battle arenas

Canonical live art: **Arena Redraw v2 (approved pack 1)**, integrated 2026-10-11. Ten arena IDs use native 1280×720 WebP assets in `assets/pixel/battle/arenas/arena_redraw_v2/`. The remaining two retain the prior v1 Base64-WebP payloads until pack 2 is approved and implemented.

| arena_id | Runtime source | Format |
| --- | --- | --- |
| `crypt` | `arena_redraw_v2/crypt.webp` | WebP bytes |
| `graveyard` | `arena_redraw_v2/graveyard.webp` | WebP bytes |
| `gallows` | `arena_redraw_v2/gallows.webp` | WebP bytes |
| `ossuary` | `arena_redraw_v2/ossuary.webp` | WebP bytes |
| `warden` | `arena_redraw_v2/warden.webp` | WebP bytes |
| `bone_crush` | `arena_redraw_v2/bone_crush.webp` | WebP bytes |
| `bone_swarm` | `arena_redraw_v2/bone_swarm.webp` | WebP bytes |
| `grave_crossfire` | `arena_redraw_v2/grave_crossfire.webp` | WebP bytes |
| `iron_wall` | `arena_redraw_v2/iron_wall.webp` | WebP bytes |
| `last_bell` | `arena_redraw_v2/last_bell.webp` | WebP bytes |
| `firing_square` | `arena_redraw_v1/firing_square.webp.b64` | Base64 WebP text |
| `bone_ritual` | `arena_redraw_v1/bone_ritual.webp.b64` | Base64 WebP text |

`scripts/battle/authored_backdrop.gd` is the authoritative live selector. It loads raw `.webp` bytes for the approved new pack and decodes legacy `.webp.b64` for the remaining two arenas; both paths create an `ImageTexture` and use nearest-neighbor fallback resizing. Live unit sprites, HUD, tactics, deployment and encounter data remain unchanged.

The new visual direction limits each environment to one dominant meaningful landmark, believable geography and a broad readable central combat floor. It preserves the existing Misdeal blue-black moonlight, warm firelight and restrained crimson gothic identity while avoiding repetitive AI-looking castles. The earlier `arena_redraw_v1`, `visual_pass_v4/v6` and `combat_expansion_v1` assets remain in Git history/repo for rollback. The 1672×941 PNG generation masters remain in the conversation package `misdeal_arena_redraw_pack1_review.zip`; the committed native WebPs are the complete runtime sources.

See `docs/ARENA_REVIEW_2026_10_11.md` for the approved arena-to-landmark map and local-validation checklist.

### Main menu

- Canonical main splash: `assets/pixel/main/approved_splash_hd/main_splash.webp`
- Runtime scene: `scenes/main/main.tscn`
- Runtime loader: `scripts/main/approved_main_backdrop.gd`
- Production size: 1280×720 WebP
- Accepted direction: restrained dark-gothic Wizard at the cursed table, reduced prop noise, red-black-gold foreground against cool moonlit city, live hotspot/UI kept outside the art.
- Superseded: the older compressed three-part splash and the intermediate over-rendered/off-model Wizard redraws.

### Wizard table

- Canonical runtime plate: `assets/pixel/table/approved_variant_c/table_exact.webp` (1280×720)
- Approved source master: `assets/source_archive/table/approved_variant_c/table_exact_master.webp` (1672×941)
- Approved normal-table composition: **final Variant C** — restrained oval ritual tabletop, Wizard centered behind it, two offer cards near the player, physical deck/discard holders at the sides.
- Superseded normal-table backdrop: `assets/pixel/table/visual_pass_v6/table_wizard.webp` (kept in repository history/assets, no longer referenced by `table.tscn`)
- Procedural `scripts/table/table_visual.gd` and `scripts/table/table_spread_visual.gd` remain available but are hidden on the canonical normal table.
- Scene/runtime logic: `scenes/table/table.tscn`, `scripts/table/table.gd`
- The full approved plate is the runtime visual foundation; run-specific cards, counts, Hold state, Wizard text and buttons remain live Godot UI aligned over it.
- Detailed run progress is not duplicated here; `РАСКЛАД СУДЬБЫ` owns the full I–XIII progression view.
- Important: authored table art bypasses the old heavy environment/card grade.
- Shared neutral card back: `assets/pixel/table/card_back_runtime.svg`.
- Runtime foundation rule: the two baked sample offer faces in `table_exact.webp` are permanently covered by neutral physical card backs beneath the live offer layer. Do not restore dark cleanup masks.
- Fate Spread Hold uses the same back when empty; Wizard Discard hides when empty and uses the back as the physical frame under the live top card when populated.
- Local status: the physical card-back pass is committed; local 1280×720 verification is pending.
- Visual lock: Fate Spread is frozen; the exact Variant C plate is the canonical normal-table art. Do not return to the procedural oval-table approximation.

### V7 high-visibility screens

- Knight portrait: `assets/pixel/class_select/v7/knight.webp`
- Ranger portrait: `assets/pixel/class_select/v7/ranger.webp`
- Mage portrait: `assets/pixel/class_select/v7/mage.webp`
- Reward: `assets/pixel/reward/v7/reward_backdrop.webp`
- Whispering Well: `assets/pixel/event/v7/whispering_well.webp`
- Curse Forge: `assets/pixel/event/v7/curse_forge.webp`
- Chained Prisoner: `assets/pixel/event/v7/chained_prisoner.webp`
- Black Altar: `assets/pixel/event/v7/black_altar.webp`
- Run End: `assets/pixel/run_end/v7/run_end.webp`

The same portraits are reused by Squad Dossier.

### Event choice mini-art

- Runtime mapping: `scripts/ui/approved_event_choice_art.gd`, consumed by `scripts/event/act_choice.gd` and `scripts/event/whispering_well.gd`.
- Visual rule: context art describes the event; mini-art describes the action. One dominant object/gesture/action is preferred over three repeated crops of the event image.
- Native 384×160 choice cells are preferred whenever an approved source already exists; the compact 192×80 sheet is now a fallback source, not the desired presentation size.
- Native Rattling Bridge source: `assets/pixel/event/choice/rattling_bridge_hd/` — 1152×160, three 384×160 cells: rescue / bag / walk away. Used for both bridge branches and as generic rescue/bag/leave actions where semantically truthful.
- Native approved Well/Prisoner atlas: `assets/pixel/ui/approved_event_choice_polish/event_choice_atlas.bin` — 1152×320, six 384×160 cells. Provides whisper, coins, occult-card, broken-chains and body-search actions.
- Compact approved sheet: `assets/pixel/event/choice/approved_choice_sheet_v2/` — 576×320, 192×80 cells. It remains the source for the approved Black Altar blood-sacrifice and cursed-offering cells; runtime reconstructs it before use.
- Reusable action vocabulary exposed by `ApprovedEventChoiceArt.get_action_texture()`: `rescue`, `bag`, `leave`, `whisper`, `coins`, `occult_card`, `chains`, `loot_body`, `blood`, `cursed_relic`.
- Explicit semantic event mappings now include Rattling Bridge, Whispering Well, Chained Prisoner, Black Altar recruitment, Lost Purse, Debtor Bones, Wizard Tithe, Blood Ledger, Bone Tax, Ash Rest recruitment and Last Camp recruitment.
- Curse Forge continues to use actual artifact art because its three choices are concrete relics.
- Role-development choices continue to show the actual offered upgrade art.
- Broken Crown now shows crown / coins / actual offered upgrade (or cursed-relic fallback) instead of three copies of the crown.
- Superseded runtime path: `assets/pixel/event/choice/black_altar_recruitment.svg`.


### V8 secondary event screens

| card_id | Runtime art |
| --- | --- |
| `candle_seller` | `assets/pixel/event/v8/candle_seller.webp` |
| `gravedigger_shop` | `assets/pixel/event/v8/gravedigger_shop.webp` |
| `blood_ledger` | `assets/pixel/event/v8/blood_ledger.webp` |
| `faceless_card` | `assets/pixel/event/v8/faceless_card.webp` |

### V9 final generic-event screens

| card_id | Runtime 1280×720 art | Archived generated master |
| --- | --- | --- |
| `rattling_bridge` | `assets/pixel/event/v9/rattling_bridge.webp` | `assets/source_archive/visual_pass_v9/rattling_bridge_master.webp` |
| `lost_purse` | `assets/pixel/event/v9/lost_purse.webp` | `assets/source_archive/visual_pass_v9/lost_purse_master.webp` |
| `debtor_bones` | `assets/pixel/event/v9/debtor_bones.webp` | `assets/source_archive/visual_pass_v9/debtor_bones_master.webp` |
| `bone_tax` | `assets/pixel/event/v9/bone_tax.webp` | `assets/source_archive/visual_pass_v9/bone_tax_master.webp` |
| `wizard_tithe` | `assets/pixel/event/v9/wizard_tithe.webp` | `assets/source_archive/visual_pass_v9/wizard_tithe_master.webp` |
| `ash_rest` | `assets/pixel/event/v9/ash_rest.webp` | `assets/source_archive/visual_pass_v9/ash_rest_master.webp` |
| `last_camp` | `assets/pixel/event/v9/last_camp.webp` | `assets/source_archive/visual_pass_v9/last_camp_master.webp` |
| `broken_crown` | `assets/pixel/event/v9/broken_crown.webp` | `assets/source_archive/visual_pass_v9/broken_crown_master.webp` |

Original V9 generated filenames from the conversation:

- Rattling Bridge — `лунный_мост_над_проклятым_ущельем.png`
- Lost Purse — `лунная_дорога_среди_мёртвых.png`
- Debtor Bones — `лунный_алтарь_костяных_костей.png`
- Bone Tax — `лунный_костяной_алтарь_у_готических_врат.png`
- Wizard Tithe — `готический_алтарь_под_полной_луной.png`
- Ash Rest — `готический_лагерь_под_полной_луной.png`
- Last Camp — `одинокий_лагерь_под_готическим_собором.png`
- Broken Crown — `разбитая_корона_в_лунных_руинах.png`

The archived masters are 1672×941 Q95 WebP exports from those generated PNGs. The runtime copies are separate 1280×720 production assets.

## Rejected / superseded art paths

### Rejected low-resolution v3

The broad v3 integration used roughly:

- 112×69 card cells;
- 320×180 arena cells.

It was locally rejected because upscaling produced muddy/blocky presentation. Do not restore this pipeline.

### Strong double grading

Legacy environment/card grade on already-dark authored art caused black crush on battle/table/event screenshots. Current authored surfaces either bypass it or use substantially reduced fallback strength.

### Generated full-screen UI mockups

Approved mockups may guide composition, but baked gameplay values/buttons/text are not production runtime UI. Preserve live Godot controls.

## Source preservation

Earlier production passes (v4-v8 and battle/table v6) are already recoverable from their committed runtime assets and Git history.

V9 additionally keeps larger source masters under `assets/source_archive/visual_pass_v9/` because these were the last generated images immediately before the transition away from broad art replacement.

If a future pass needs a different crop or export, start from the archived master where available rather than regenerating a new scene.

## Combat Expansion v1 dedicated visual set — 2026-10-11

The six gameplay-test encounters now have approved dedicated arena and card exports.

| Encounter | Battle backdrop | Table card |
| --- | --- | --- |
| `bone_swarm` | `assets/pixel/battle/arenas/combat_expansion_v1/bone_swarm.webp` | `assets/pixel/ui/combat_expansion_v1/cards/bone_swarm_card.webp` |
| `grave_crossfire` | `assets/pixel/battle/arenas/combat_expansion_v1/grave_crossfire.webp` | `assets/pixel/ui/combat_expansion_v1/cards/grave_crossfire_card.webp` |
| `iron_wall` | `assets/pixel/battle/arenas/combat_expansion_v1/iron_wall.webp` | `assets/pixel/ui/combat_expansion_v1/cards/iron_wall_card.webp` |
| `last_bell` | `assets/pixel/battle/arenas/combat_expansion_v1/last_bell.webp` | `assets/pixel/ui/combat_expansion_v1/cards/last_bell_card.webp` |
| `firing_square` | `assets/pixel/battle/arenas/combat_expansion_v1/firing_square.webp` | `assets/pixel/ui/combat_expansion_v1/cards/firing_square_card.webp` |
| `bone_ritual` | `assets/pixel/battle/arenas/combat_expansion_v1/bone_ritual.webp` | `assets/pixel/ui/combat_expansion_v1/cards/bone_ritual_card.webp` |

Production sizing:
- battle: 1280×720 WebP;
- card: 448×274 WebP.

These exports were cropped from the six user-approved composite concepts generated for Combat Expansion v1. The former semantic card aliases are retired. Bone Raider and Crypt Sentinel still intentionally reuse existing production unit silhouettes pending mechanical validation.

### Combat Expansion v1 archived composite masters

The approved generated composites used to derive the live arena/card exports are preserved for recropping:

- `assets/source_archive/combat_expansion_v1/bone_swarm_composite_master.webp`
- `assets/source_archive/combat_expansion_v1/grave_crossfire_composite_master.webp`
- `assets/source_archive/combat_expansion_v1/iron_wall_composite_master.webp`
- `assets/source_archive/combat_expansion_v1/last_bell_composite_master.webp`
- `assets/source_archive/combat_expansion_v1/firing_square_composite_master.webp`
- `assets/source_archive/combat_expansion_v1/bone_ritual_composite_master.webp`

These 1055×1491 source composites contain the approved arena concept in the upper portion and the approved card illustration in the lower portion. Use these masters rather than regenerating the concepts if a crop or export needs adjustment.
