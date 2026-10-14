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

> **NEW D146 USER PRIORITY (2026-10-14):** D145 Bone Shepherd card/SVG unit graphics were explicitly rejected as NOT matching the existing approved Misdeal cards/units. Stop deck expansion; first produce genuinely painterly full-bleed 448×274 card illustration consistent with `bone_patrol.webp`, `bone_swarm.webp`, `grave_crossfire.webp`, then two full authentic 25-frame 576×480 enemy atlases consistent with approved Knight/Bone Warden combat animation richness. D146 brief: [`docs/DECK_EXPANSION_D146_ART_REWORK.md`](DECK_EXPANSION_D146_ART_REWORK.md). Session generated concept boards only; none are live or approved. GitHub game art/code unchanged in D146 docs-only checkpoint. Old smoke 54/54 user QA remains outstanding. This D146 directive supersedes earlier suggested immediate art acceptance and prevents proceeding to Card02 prematurely.

# MISDEAL — CURRENT NEXT-CHAT HANDOFF

**Last consolidated:** 2026-10-14. **Repository:** `zampolit73/Misdeal`, branch `main`. **Status:** Bone Shepherd first new combat card implemented, D145 original artwork pass committed; **new Godot screenshots and 54/54 smoke test still required**. This document is an intentionally concise but complete continuity checkpoint; `docs/PROJECT_STATE.md`, `docs/DECISIONS.md`, and current GitHub code remain authoritative. Do not mistake historical discussions or the two reference moodboards for code already shipped.

## 1. How to continue on the first turn of a new chat

1. **Connect to the existing GitHub tools directly**. Do not ask the user for access. The project's instructions explicitly authorize direct GitHub modifications for implementation/fixes. Repository: `zampolit73/Misdeal`, main.
2. Read `AGENTS.md`, `docs/CONCEPT.md`, **this file**, `docs/SESSION_CHECKPOINT.md`, `docs/PROJECT_STATE.md`, `docs/ROADMAP.md`, `docs/DECISIONS.md`, `docs/HANDOFF.md`, `docs/VISUAL_ASSET_REGISTRY.md`, `docs/DESIGN_SYSTEM.md` if touching art/UI.
3. **Resume from user F6 verification, not from redesigning architecture or asking to approve Bone Shepherd again.** User previously approved initial new-enemy concept and specifically requested detailed art refinement, which was implemented under D145.
4. User locally operates **Godot 4.7.x / GDScript on Windows**, pulls via `git pull`, runs F6; assistant modifies connected GitHub directly. No Godot engine exists in assistant's container, so never claim a test passed unless local user screenshot/files confirm it.
5. Talk Russian; files, class names, node IDs, code and resource IDs in English. Preserve game design and accepted visual style; no speculative fundamental changes.

## 2. Established product and locked design

Misdeal is a **dark fantasy, card-driven roguelike with a compact tactical autobattler**. Evil Wizard is host/antagonist of a cursed card table. Player chooses Knight/Ranger/Mage protagonist, recruits other characters via actual run events. Precombat choices include party, placement, equipment, tactical order; combat auto-resolves. Act 1 progress uses physically authored **Fate Spread Variant C** with **12 resolved card slots I–XII + sealed center boss Bone Warden XIII**, NOT a node map. Maintain the approved **DS2** color/material treatment: blackened wood/obsidian, aged bronze, muted ritual blood-red, aged parchment, cold moonlight, crisp readable pixel-style imagery; **do not repaint approved Fate Spread C or change its table layout**.

Original wave one **18 approved standalone card/reward artworks** and existing seven **authored two-deployment encounters** are frozen except specific user-requested fixes. Every card's enemy lineup must agree with its name/description/art: never substitute random old enemies into an unchanged fight card. All new combat cards or event branches with optional battle **MUST feature genuinely original enemy types, roles, meaningful behaviors and original images**; no old skeletal soldiers/bellkeepers renamed/recolored/reshuffled. This is decision **D143**.

## 3. Deck expansion: exact current state

User accepted direction of **15 added Act 1 cards** (30 → 45 total pool), but these are a staged **proposal**, NOT already implemented. Existing 30 + **one actually registered new card = 31**; new card is `bone_shepherd` in **Tier 0** (11 Tier0 cards). **14 further expansion candidates remain not coded**; named preliminary idea list accidentally had 5 fight-bearing cards rather than claimed 3 because optional combat also counts — revise final expanded list before implementing. The run still resolves **12 + XIII**; do not extend run.

**First shipped Card 01: `КОСТЯНОЙ ПАСТУХ` / `bone_shepherd`**. One unique tall mourning-cloak/bone-crook **Bone Shepherd** commander and two unique horned skeletal quadrupedal **Ossuary Lambs** in both authored layouts. No old enemy archetypes, no third ghost, no summoned creatures, no unrelated card choice branches, no extra buffs from generated concept artwork. Fixed exactly:
- `resources/cards/bone_shepherd.tres`
- `resources/encounters/bone_shepherd.tres` — two distinct authored `PackedVector2Array` placements, fixed roster `bone_shepherd, ossuary_lamb, ossuary_lamb`, `arena_id="graveyard"`.
- `resources/units/bone_shepherd.tres` and `resources/units/ossuary_lamb.tres` — their own `UnitData` stats; initial playtest tuning, **not proven balanced**.
- `scripts/core/run_state.gd` — registered in `CARD_PATHS` and `ACT1_CARD_IDS`.
- `scripts/data/bone_shepherd_whistle_data.gd`, `resources/encounters/bone_shepherd_whistle.tres`, `scripts/battle/bone_shepherd_whistle.gd`.
- `scripts/battle/battle.gd` — binds controller ONLY when `encounter.encounter_id == "bone_shepherd"`, starts/stops with battle.
- `scripts/battle/unit.gd` — short-lived role-gated shared target / movement multiplier ONLY for `ossuary_lamb` while rushing; no unrelated HUNT, solo/duo/trio or legacy enemy AI change.

**Unique ability, Shepherd's Whistle:** first warning after **5.5s active combat**, **0.65s** red telegraph, both surviving Lambs temporarily chase one living player for **1.25s** at **movement ×1.35**, new warning every **8s from previous rush start**. No damage/cadence boost, stun or summon. Killing Shepherd during warning cancels, killing during active rush permits issued 1.25s order to finish then stops all future whistles; clean cooldown/reset. See D144 and full spec `docs/DECK_EXPANSION_BONE_SHEPHERD_PRODUCTION.md`.

## 4. Art: what exists, what is approved, and what still needs a screenshot

**Actual shipped game art is original GitHub SVG texture assets, not image-generator concept board:**
- `assets/pixel/units/deck_expansion_v1/bone_shepherd_frames.svg`: **576×480**, 6 columns × 5 rows, 96×96 frames, **25 authored frame groups**: idle 4, walk 6, attack 6, hit 3, death 6.
- `assets/pixel/units/deck_expansion_v1/ossuary_lamb_frames.svg`: same grid/state/count, clearly quadrupedal with visible feet, horned ram head.
- `assets/pixel/card_unification_v1/run/bone_shepherd.svg`: **448×274**, own moonlit graveyard image for the card.
- Role-to-animation loading in `scripts/battle/unit_animation_library.gd`, card art in `scripts/ui/card_unification_v1.gd` (via `CardArtCatalog`). SVG files are deliberate UTF-8 pixel-shaped source that Godot imports; not the existing Wave1 WebP art.

**D144 initial local screenshots WERE submitted**: image gallery loaded initial first-pass card/Shepherd/Lamb sprites; normal Knight cemetery fight loaded correct three new enemies and formation; both showed art **too flat/simplistic compared to richly detailed approved Knight and arena**. A third local screenshot showed dev smoke GDScript compile error at line 17 (`const EXPECTED_PATHS := PackedStringArray(...)` is not a constant). **Both problems addressed in GitHub, but local testing after changes remains outstanding.**

**D145 art refinement (latest substantial work) IS COMMITTED:**
- Shepherd animation SVG `ca9faceb9fd3`: richer skull, aged mourning textiles, layered dark bone and rib shapes, bronze fixtures, ember-lit crook lantern, controlled crisp pixel clusters, every frame preserved.
- Lamb animation SVG `39556396f130`: horned skull/muzzle, hoof joints, plated bones/ribs, burial bindings, weathered accent highlights, every frame preserved.
- Card illustration SVG `f25adbb53fa5b4`: more textured gothic moonlit cemetery with graves/chapel, fence, fog, wet stone, old cloth and warm lantern, fixed 448×274.
- Last art/roles/static QA confirmed valid SVG/XML structure, fixed dimensions and 25 animation groups each. **User has NOT yet inspected or approved D145 revised assets at live Godot scale.** Do not call them final polished accepted art. Generated two composite concept sheets in earlier chat were **moodboards/reference only**, showed additional unapproved event/summoning ideas; **those PNG boards were not imported/committed into game**. The live SVG artwork is the source of truth.

If visual feedback indicates D145 is still too flat against approved art, improve original art again based on fresh Godot screenshots. Keep design/rules intact. Do not replace sprites with a screenshot of a composite concept board: animation sheets must contain genuine separate poses, maintain boots/hooves on the ground, especially `idle/walk/attack/hit/death`.

## 5. Latest known bug and exactly what to test next

**Previously fixed compile error:**
- User's `bone_shepherd_smoke.tscn` Godot screenshot: line 17 `Assigned value for constant "EXPECTED_PATHS" isn't a constant expression`.
- `scripts/dev/bone_shepherd_smoke.gd`: replaced `const EXPECTED_PATHS := PackedStringArray([...])` with **`const EXPECTED_PATHS: Array[String] = [ ... ]`**, compare against runtime `PackedStringArray(EXPECTED_PATHS)` in `_validate_resources()`. Fix GitHub commit `228b62010ea0fff345da90f78105781ce13042a2`. Separate `arena.visible=false` fix to hide simulated battle behind smoke results in commit `4402074de6e7c0207b67b003f01bbd101c16ff01`.
- **No post-fix engine test screenshot** has been supplied. D145 source-art refinement does not prove `bone_shepherd_smoke` passes.

**Immediate user-side steps after entering new chat:**
1. **`git pull`** in local Misdeal project. If local Git untracked-file conflicts recur, inspect exact conflicting files before removal; never blindly use destructive `git clean`.
2. F6 **`res://scenes/dev/bone_shepherd_art_preview.tscn`** at 1280×720, inspect **all five buttons** `IDLE`, `WALK`, `ATTACK`, `HIT`, `DEATH`, and card image. Send screenshot of updated D145 sprites. Look especially for hoof placement, silhouettes and whether richness matches existing battle art.
3. F6 **`res://scenes/dev/bone_shepherd_smoke.tscn`**; expected **`DECK EXPANSION 01 — PASS`**, **54/54** bouts (= 2 formations × 3 protagonists × 3 party sizes × 3 orders), whistle lifecycle checks. **Not yet confirmed**: if FAIL, ask user for Godot Output/error screenshot and fix directly in GitHub.
4. F6 **`res://scenes/dev/bone_shepherd_playtest.tscn`** — real Knight fight in original graveyard; check miniatures at actual battle scale, stance rings/hoof grounding, telegraphed Whistle + simultaneous Lamb rush and normal victory→reward→table flow. Note **Battle startup** was previously verified; complete battle not yet.
5. After 54/54 and art approval, record exact result in all continuity docs, tune new enemy early-tier challenge only from observed results; then select **next original-enemy card or noncombat +15 card slice**. Do not automatically implement rest of deck while Card01 fails QA.

**Godot engine itself is not available to assistant; only source/static tests of post-fix scripts and D145 SVG are complete.** Screenshots from previous version do not certify updated D145 art.

## 6. Earlier measured tactical gameplay (separate backlog; do not erase)

- D136/D137: underlying Act 1 dealing and targeting/regression harnesses passed historical local Godot tests. D138 v2.2 72 real-unit simulated fights PASS. D139 v2.3 **180/180** F6 PASS, **79 wins / 101 losses**, reviewed in `docs/TACTICAL_GAMEPLAY_V23_BALANCE_REVIEW.md`.
- D140 v2.4 shared HUNT high-priority focus + D139 close-threat Knight interception, `scenes/dev/tactical_gameplay_v24_focus_party_benchmark.tscn`, user's screenshot **270/270 PASS** (158W/112L); actual 270-row CSV analysis in `docs/TACTICAL_GAMEPLAY_V24_BALANCE_REVIEW.md`. Overall ASSAULT **67/90**, FORMATION **67/90**, HUNT only **24/90**; `last_bell` HUNT **4/18**, ASSAULT/FORMATION **18/18**. HUNT never wins when ASSAULT loses in any 90 matched scenarios, whereas reverse occurs 43 times. Held-protagonist solo/duo/trio totals **82/90, 30/90, 46/90**. Late equipped Knight solo **24/24**, Knight+Ranger duo **0/24**, trio **2/24**. Real life Act1 win-rate NOT inferred from controlled harness.
- D141 v2.5 diagnostic-only signals `diagnostic_attack`, `diagnostic_damage`, `diagnostic_heal` and `scenes/dev/tactical_gameplay_v25_combat_diagnostics.tscn`, user supplied 126 case CSV +792 per-unit rows, full report `docs/TACTICAL_GAMEPLAY_V25_DIAGNOSTIC_REVIEW.md`. **126/126** case outcomes/durations identical to corresponding D140 scenarios; subset **66W/60L**. On Last Bell HUNT averages **12.78 attacks /281 damage/234 enemy damage/41 healing**, ASSAULT **18.78/395/103/26**, chase times similar. Late Knight duo attacks/damage and survivability collapse; only a diagnostic indication, not isolated culprit.
- **D142 isolated counterfactual tests** (HUNT threat-accessibility A/B; Knight duo one-factor pressure/placement) were **PROPOSED only, not implemented nor silently approved**. Full *actual* Act 1 Wizard wager/reward/progression/boss XIII QA remains outstanding. The new Bone Shepherd content and D145 art are **independent** of this balance backlog. Do not globally nerf existing enemies or change solo/duo scaling based merely on synthetic outcomes.

## 7. Source references and "done / pending"

| Status | Item |
|---|---|
| **DONE + GitHub main** | Card `bone_shepherd`, new enemy data, 1+2 exact roster/two positions, isolated Whistle, live SVG animation and card art, card registration (31 total) |
| **DONE + GitHub main** | D144 smoke parser hotfix and dev arena visibility fix |
| **DONE + GitHub main** | D145 richer DS2 material/source pixel-art pass for all 3 art assets, source/XML/animation frame audit |
| **DONE + measured** | Older 270-case tactical v24 F6+CSV and 126-case tactical v25 CSV/diagnostic analysis |
| **PENDING USER TEST** | D145 updated art/animation screenshot and live silhouette/grounding approval |
| **PENDING USER TEST** | 54/54 `bone_shepherd_smoke.tscn` post-fix and actual whistle test |
| **PENDING QA** | New encounter's player-facing full win/reward/return and normalized early Act 1 balance |
| **PENDING FUTURE WORK** | Remaining 14 proposed expansion cards, each fight containing genuinely new units + original art, and separate D142 balance experiments |

**Relevant decisions:** `docs/DECISIONS.md` D143 new-enemy rule, D144 Card01 implementation, D145 artwork quality. Full scope/design: `docs/DECK_EXPANSION_BONE_SHEPHERD_PRODUCTION.md`. Artwork registry: `docs/VISUAL_ASSET_REGISTRY.md`.

## 8. Chat restart script

User may start a fresh chat by saying simply: **«Продолжаем Misdeal с последнего GitHub-чекпоинта»**. Assistant should read these files + current GitHub rather than solicit repeated history, and resume from F6 screenshots/test results or related next authorized work. This handoff **does not ask the user to remember anything manually**. Update this file at the end of the next significant work session; keep `docs/SESSION_CHECKPOINT.md` succinct and aligned.
