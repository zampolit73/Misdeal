# Misdeal — Active Roadmap

## D263 — Original character-free Court architecture candidate and honest art gate

- [x] Reproducibly generate a standalone **1280×720 empty** underground tribunal with stairs, throne, scales, candles, contiguous tactical floor; NO burned-in Court units.
- [x] Validate image size, lossless round-trip and Godot 4.7.2 scene decoding with approved D261 selected-card-art reference intact; F6 `court_of_the_mute_d263_empty_arena_preview.tscn`, G toggles legal floor.
- [x] Inspect exploratory sprite montage and reject as final: Magistrate ~24 miniatures, Bailiff ~18–20; Scrivener ~30 but opaque/composite, no clean grounded 6×5 sheet. Do NOT invent missing original poses or register false art.
- [ ] **NEXT D264:** make THREE full original clean-alpha sprite sheets (each 25 distinct = idle4/walk6/attack6/hit3/death6, 5 empty in 6×5 96px), coherent grip/facing and boots; single combined native F6.
- [ ] Refine current flat-color geometric floor into artistically acceptable **rich authored, character-free** scene matching selected second D261 portrait; current D263 asset remains QA only.
- [ ] Stage game-ready arena + rich original sprites, test full native 54-case Court balance and Battle→Reward→Table, then **release card #39 separately**. Keep ACT1 38/45 and KARAMBA73 unchanged.

## D262 — Court original combat roster and encounter-only red verdict targeting (QA technical PASS)

- [x] Stage **new** `mute_magistrate`, `ash_scrivener`, `bone_bailiff` `UnitData` with four original enemy instances and two formations; no borrowed enemy roles.
- [x] Implement original `verdict_target`: 1.4s conspicuous red warning on one hero, 2.5s focus from both Bailiffs, 3.6s rest; scribe death removes focus. Local controller only; no global AI, stun or guaranteed damage.
- [x] Hook exact Court encounter lifecycle into genuine Battle without exposing #39 in regular card pool; Godot 4.7.2 **6 true Battle startup cases and verdict contract PASS**, D260 38-card 54-case matrix regression PASS.
- [ ] **NEXT: batch-author 3 rich original 25-pose animated pixel-art atlases** `6×5×96px`, 5 alpha blank cells each; unique prop grips and planted feet, proper 1x facing/contact, one combined native F6.
- [ ] Original separate tribunal arena in the exact chosen card world's language: giant scales, ruined bench, walkable stone under units, NO baked unit illustrations; pass actual native art review.
- [ ] Native full 54-case solo/duo/trio×formations balance + Battle→Reward→Table; then explicit #39 activation **39/45**. Until then 38/45 live, original D261 card art and KARAMBA73 frozen.

## D261 — User-approved SECOND Court card art integrated in GitHub, native QA PASS

- [x] User chose **A `Суд безмолвных`**, a new tactical undead tribunal encounter; three original combat enemy types required, no reused costume swaps.
- [x] User explicitly chose **second** of three rendered illustration alternatives; source SHA-256 recorded and exact portrait-derived `448×274` WebP uploaded to GitHub, no repaint or regenerate.
- [x] New QA-only `court_of_the_mute.tres`, `CARD_PATHS` addressable entry, strict chosen-art loader, F6 preview. Godot 4.7.2 WebP integrity/native preview **PASS**.
- [ ] **NEXT D262:** new pixel art/complete animation packs (25 genuinely distinct frames per role) for Magistrate, Scrivener, Bailiff; one combined visual/motion QA, no micro-approvals.
- [ ] Original tribunal combat arena with walkable stone floor and recognizable huge scales. Scoped visibly telegraphed red `verdict_target` mechanics; no stuns, no global target AI changes.
- [ ] Native Godot real 3-party-size/two-formation battle+54-case regression and actual Battle→Reward→Table; only then release #39 to **39/45**, separate commit.
- [x] Keep #38 and Act1 **38/45 LIVE**, DS2/Fate Spread and KARAMBA73 unchanged.

## D261 — HISTORICAL: 3-way concept and pre-art review stage

- [x] Review latest `main`: Act1 **38/45** after released #38; DS2, Fate Spread, original new-enemy D143 and scene-first art D167/D168 rules remain.
- [x] Draft **three distinct next-card directions** in [D261 options](D261_CARD39_CONCEPT_OPTIONS.md): A mute skeletal court with encounter-local marked target; B haunted memorial garden with finite defensive ward; C stranger's epitaph choice event.
- [ ] **NEXT user selects A/B/C** (recommend A); no assumption that `«все ок»` picked a design.
- [ ] Show 3 actually rendered, non-repetitive art options under D168 for selected direction; wait for explicit choice before committing selected source image.
- [ ] Combat A/B requires 3 completely new original enemy roles, full 25-cel animation packets, novel localized mechanic and original arena, native solo/duo/trio balance and real Battle→Reward→Table; event C requires approved actual event choices and normal route validation.
- [ ] Only after all relevant gates release #39 to **39/45**. Until then keep Act1 38/45, no change to KARAMBA73.

## D260 — Card #38 released: Act1 38/45

- [x] Actual Godot 4.7.2 54-case local balance assessment: average remaining HP solo/duo/trio 79.7/69.2/74.6%, 54 wins/zero timeouts, 0/2/4 individual hero deaths, ~13–15s fights.
- [x] Compared previous D153 74/67/74% remaining HP; **accept existing five-enemy UnitData and x1.16 travelling light for initial release**, no generic buff inflation.
- [x] Explicitly add `black_lantern_road` in `ACT1_CARD_IDS`, now **38/45 live**; card art D200/arena D209/original full-five animations intact.
- [x] Official Godot 4.7.2 released Tier1 offer/choose→Battle win→Reward claim→Table PASS; post-release 54-case matrix PASS.
- [x] Provide `res://scenes/dev/black_lantern_d260_released_battle_preview.tscn` for direct user F6 (party/formation).
- [ ] **NEXT D261:** develop card #39 direction with user; D143 new enemies for any combat, 2–3 distinct rendered options before card art change (D168).
- [ ] Fix unrelated `approved_battle_direction.jpg` concept import only after tracing actual references; respond to reproducible visual crop issues from real gameplay. KARAMBA73 immutable.

## D259 — Original five-role production-format staging before card #38 release

- [x] Export source-preserving canonical D257 Guide/Acolyte/Archer 25-cel WebP to runtime `deck_expansion_v1`; cell-wise normalize source facing, validate 25 unique/5 clear per role.
- [x] Register all FIVE in strict shared library, preserving exact Sentinel/Bearer, `BattleUnit` behavior, enemy UnitData and original 37-card pool.
- [x] Fix QA-release card's missing `target_path` to point to original Black Lantern encounter; **not** added to deal pool yet.
- [x] Official Godot 4.7.2 full five-library-real-Battle preflight and 54-case functional regression PASS.
- [x] Correct invalid >4096 `z_index` values in real Battle HUD without changing layout ordering.
- [x] **Real headless Fight→Reward→Table PASS** in Godot 4.7.2: 3v5 win, Continue→Reward→Table/card completion using QA-only frame signal for native transition. User D258 reported no issues; visual critique remains feedback-driven.
- [ ] Make evidence-based local difficulty decision; 54/54 wins alone do not approve balance. Then release card #38 in **separate commit** to 38/45 only when gates pass. KARAMBA73 frozen.

## D258 — All five skeletons in real Battle QA and Godot CI matrix

- [x] Stage all five original rich enemy identities with full 25-pose atlases in isolated D258 real-AI 3v5 and genuine Battle launcher; correct left-origin Guide/Archer QA facing in memory only.
- [x] Godot 4.7.2 native headless source/scene smoke and **actual Battle preflight PASS** (eight BattleUnits, D253 light, two authored formations available, three D257 packs injected).
- [x] Rerun existing **54/54 real BattleUnit matrix functional PASS**: zero party defeats/timeouts, 18 wins per party size and class. Balance acceptance **OPEN**.
- [ ] **NEXT** real local F6 Fight→Reward→Table (trio/Перекрёсток, then solo/duo/Марш) plus original ×1 movement, prop/floor/HUD and lanternlight visual QA.
- [ ] Correct artistic, HUD or encounter difficulty issues from real game, run release smoke, register remaining three roles globally **only when complete**, then consider #38 38/45.
- [x] Preserve 37/45 live, original D244/D224 sprites and frozen KARAMBA73.

## D257 — Three complete character atlas repair candidates and one native art gate

- [x] Restore cross-cell pixels with a source-aware author for all three approved D255 silhouettes; stage three lossless 25-frame **QA-only** atlases via successful GitHub Actions.
- [x] Verify 75 distinct frames, 15 truly blank slots, 2px alpha margins and report 9/10/8 reconstructed source components. Apply local lower-edge contour trial; **11 original lower-cut source flags remain reviewable**.
- [x] Provide ONE combined D257 Godot gallery for all three roles, all states, both facings, and native ×1 scale.
- [ ] **NEXT** F6 visual art/motion review and repair defects, particularly sole contact and prop continuity; technical QC is not artistic sign-off. Only stage all three in real 3v5 upon acceptance.
- [ ] Actual D254 Battle→Reward→Table with solo/duo/trio and both formations; normalized 54-case balance matrix, crowding fix as needed; release #38 only after all gates. **Live pool remains 37/45**.

Updated: 2026-10-19 (D260 #38 released 38/45, release route and balance CI PASS; next D261).

## D256 — Current new-chat restart checkpoint

- [x] Archive complete D255 source files, 75 unique candidate sprites, per-frame QA report and F6 triple-character preview in GitHub.
- [x] Consolidate exact continuation and risks in `docs/D256_NEW_CHAT_HANDOFF.md`; align NEXT_CHAT_HANDOFF/INDEX/HANDOFF/PROJECT_STATE.
- [ ] **NEXT** correct D255 source-edge **12 Guide / 13 Acolyte / 9 Archer** frame warnings at original pose/prop level, verify 75 natural motions and true original rich silhouette. Only then one combined Godot F6.
- [ ] Register all three after actual artistic acceptance; native #38 real Battle→Reward→Table, normalized 54-case balance and release smoke. Until then ACT1 **37/45**, checkpoint frozen.

## D255 — Three complete character-art candidates in one batch; source cropping art gate

- [x] User positively received new visual direction for original Guide/Oil Acolyte/Archer; archive their three transparent full 25-pose illustrated sheets, distinct original silhouettes.
- [x] Reproducibly pack **three complete 25-frame** sets at fixed source scale into 576×480 RGBA lossless WebP, 75 unique/15 genuinely empty, inset margins correct, verify visible-pixel round-trip. One combined x1/x2.1 five-state left/right Godot QA preview created.
- [ ] Repair known **12/13/9 source-cell edge-overflows** (Guide/Oil/Archer) that sever airborne lamps/chain fire/cloth; inspect true motion quality internally. No provisional style regression or code-only fake uniqueness.
- [ ] After a clean full-batch art pass, one user-native combined F6 and real 3v5. Stage remaining three roles globally only if art approved; D254 real Battle→Reward→Table, 54-case balance and 38/45 card release still gated.
- [ ] Keep 37/45 released cards and KARAMBA73 unchanged.

## D254 — Original #38 real Battle QA route and party variation

- [x] Add `black_lantern_road` **ONLY** to RunState CARD_PATHS so a test session may resolve it; leave 37 ACT1_CARD_IDS exactly unchanged.
- [x] Add standalone F6 launcher for real Battle with solo/duo/trio and both authored formations. Temporary Guide/Acolyte/Archer 25-frame original QA art is injected per instance, Sentinel and Bearer use staged rich art.
- [ ] Native user F6 `scenes/dev/black_lantern_d254_real_battle_route_qa.tscn`: verify real Battle intro/tactics/lantern boost, win→Reward→Table, no engine errors. This is a technical route check, not final art approval.
- [ ] Full original clean rich Guide 25 cels, Oil Acolyte and Archer, then normalized 54-case balance/native final visual pass and #38 public 38/45 smoke. KARAMBA73 frozen.

## D253 — Dormant real Battle lanternlight hook for #38

- [x] Reuse D206 scoped light in normal Battle ONLY for exact original five-enemy `black_lantern_road` roster. Configure after normal units, start after Fight/intro, stop + restore on either battle result.
- [x] Preserve all other encounters, original battle data, D244/D224 staged art, live pool 37/45, KARAMBA73.
- [x] Local D251 matte cleanup test internally rejected as insufficient to fix compressed chain-attack motion and scale. No invalid art shipped.
- [ ] Rich original 25 whole posed frames for rigid triple-chain-lantern yoke Guide, then Acolyte and Archer, all with internal art QA.
- [ ] Godot-native actual #38 Battle→Reward→Table and 54-case party/formation matrix under released balance AFTER art is complete; release #38 only then.

## D252 — Native two-formation 3v5 visual-smoke gate closed

- [x] D251 user video: **ПЕРЕКРЁСТОК** native 3v5 ends win at 9.7 sec, all 3 heroes, 0 enemies; **МАРШ** native 3v5 also wins at 9.7 sec, 3/3 heroes. Actual button switches, not just restart.
- [x] New enemy-name OFF default improves crowded combat; changing to ON itself not tested. Scoped lantern light active and rest states with live enemy buff counter are visibly working.
- [ ] Original rich 25-pose **rigid triple-lamp shoulder-yoke Guide**: D251 extraction is an internally rejected art/motion reference, D218 tech actor still large and flat. Do not register as finished until genuinely clean consistent frame-by-frame art.
- [ ] Oil Acolyte and Lantern Archer rich character packs, crowded hero label/HP readability adjustments, then NORMAL #38 Battle→Reward→Table + solo/duo/trio 54-case matrix. Both current isolated 3v5 wins at 9.7s/3 heroes surviving should prompt difficulty review only in normalized final QA.
- [ ] #38 release to 38/45 only after full five-role art and live encounter QA; KARAMBA73 unchanged.

## D251 — Guide paint and encounter readability (not yet production-ready)

- [x] New detailed original Guide silhouette shows correct rigid shoulder yoke with three amber chain lamps, preserves Style B materials rather than copying a shield soldier.
- [x] Reproducibly pack 25 distinct transparent 96×96 native cels from 1536×1024 concept illustration; alpha margin, unique hashes, WebP round-trip structural PASS; **reject** as final due hairline cutout and distorting extreme chain attacks/falls.
- [x] D249 isolated 3v5: name labels hidden by default for enemy crowd readability, optional toggle; formation switch now explicitly shows destination → ПЕРЕКРЁСТОК / ← МАРШ.
- [ ] Rich original clean transparent per-pose Guide repaint correcting attack body/lamps and corpse consistency; one full 25-frame native F6 ONLY when internally ready. Do not weaken checks or force D251 through.
- [ ] F6 D249 improved QA and actual second ПЕРЕКРЁСТОК formation; then remaining rich Acolyte/Archer, true Battle→Reward→Table, 54 cases and pool 38/45. Live 37/45 KARAMBA73 frozen.

## D250 — User's first authentic D249 3v5 recording: one formation passes

- [x] D249 first real Godot video shows MARШ 3 heroes vs 5 original enemies on D209, real AI movement, 5→0 enemies, 3 heroes survive first ~9.6s, visible damage/attack counters.
- [x] Scoped light warning/active phases and live `усилено скелетов 1` counter, manual light off; restart observed.
- [ ] Confirm `ПЕРЕКРЁСТОК` second deployment on a future test. Recorded second run **also says МАРШ**, so do not mark the two-formation gate closed.
- [ ] Replace the large flat/geometric obstructive Guide D218 with full rich B-style **25 unique poses** depicting a rigid yoke and exactly three separately chained amber lanterns. Tight battle HUD labels and overlaps also need composition QA.
- [ ] Original rich Oil Acolyte/Archer; final 3v5 native both formation passes, true balance/matrix and production Battle→Reward→Table release gates before 38/45.

## D249 — Complete five-role REAL combat composition without premature card release

- [x] User D248 Guide native 1v1 technical no-blocker. D218 NOT rich final art.
- [x] Reject three exploratory Guide image sheets that lost rigid iron shoulder yoke/three lanterns or proper 25-cel sprite source. No accidental import.
- [x] Isolated D249 real 3v5 BattleUnit encounter with three real heroes, five original enemies, two formation options, scoped D206 light speed buff and strict temporary original art (D218/D217/D219) only for incomplete three roles.
- [ ] One F6 scene res://scenes/dev/black_lantern_d249_five_enemy_combat_qa.tscn: inspect all 8 sprites, two formations, floor contact and light cycles; report concrete errors for fix.
- [ ] Rich original Style B 25 poses with rigid yoke and three chain-hung lanterns Guide; then Oil Acolyte and Archer. Only after true art acceptance integrate full #38 Battle/Reward/Table, rerun 54-case matrix and release 38/45. KARAMBA73 frozen.

## D248 — Bearer accepted-to-proceed; original rich Guide 25-frame art required

- [x] User replied `«все ок»` after real D247 Bearer-vs-Knight Godot duel.
- [x] Canonical D224 Bearer atlas staged byte-exact beside D244 Sentinel; shared strict library registers only these two original B-style #38 roles, no card release.
- [x] QA-only D248 `black_lantern_guide_d248_combat_preview.tscn` real BattleUnit Guide-vs-Knight motion probe with temporary **simplified** original 25-pose D218 source; both directions/death, HP×3 only, no library role activation.
- [ ] Author new truly rich B-style **25 wholly posed** tall Guide, distinctive *three separate chain-hung lamps from iron yoke*; internally QA all actions before ONE user-native full-pack F6; never replace with new Bearer/shield clone.
- [ ] Rich Oil Acolyte & Lantern Archer full-25 art; genuine #38 3v5 with moving pools/light, deterministic matrix, reward/table and 38-card smoke/release only after full approval. 37/45 LIVE, KARAMBA73 frozen.

## D247 — Sentinel staged, next Bearer real combat check

- [x] User reports D246 real one-Sentinel movement **«вроде все ок»**, provisionally acceptable; no asserted video/exhaustive art PASS.
- [x] Copy *exact D244 git blob* into staged `road_sentinel_frames.webp.b64` (D229 archive preserved), update regression gallery and animation-library notes; #38 still not in pool.
- [x] Create one Knight vs D224 Lantern Bearer real AI preview (25 different original frames, HP-only ×3, reverse side and death buttons) on approved D209; no generic fallback or global Bearer registration.
- [ ] ONE **native F6** for `scenes/dev/black_lantern_bearer_d247_combat_preview.tscn`; accept or repair known potential D224 shield/cape cut, floor contact, hand-held lantern, flip and collapse.
- [ ] After Bearer, new original 25-frame complete packs for Guide, Oil Acolyte and Lantern Archer; then 5-role 3v5, light, balance, real battle/reward/table and full #38 release QA. Live **37/45**, KARAMBA73 frozen.

## D246 — Single Sentinel D244 real BattleUnit movement QA

- [x] Add isolated real AI **one Sentinel vs one Knight** D209 forest fight, unaltered movement, aiming, real hit/death feedback. D244 frames apply to only a QA BattleUnit instance (no global role cache).
- [x] Include restart, swapped-side attack direction and explicit death controls. Only HP ×3 locally to lengthen observation; check #38 stays outside 37-card live pool.
- [ ] **User-native F6:** run `res://scenes/dev/black_lantern_sentinel_d246_combat_preview.tscn`, observe actual walk floor contact, left/right automatic facing and attacks; send one short recording or defect list. Do not claim PASS until native test.
- [ ] Final D244 art verdict, four other unique characters, full 3v5/light/balance/reward and release gates; existing 37/45 and KARAMBA73 untouched.

## D245 — One complete D244 native video review (real Godot)

- [x] Reviewed user's actual 21.38s Godot D244 recording; 5 animations and both facings shown, ×3 and ×1 on D209 forest; gallery loads and plays, native review gate **completed**.
- [x] Confirmed spear extends nearly horizontally at ATTACK contact in both facings; DEATH buckles/falls to visible armored floor corpse rather than rotated/smeared poster; held lantern stays with actor.
- [ ] **One overall subjective D244 art acceptance** (user supplied video without verdict); avoid inventing user approval. Short-lived contact pose and subtle foot weight shift are visual review considerations; do not merely change FPS.
- [ ] After art sign-off, complete remaining four original roles in 25-frame batches, then real #38 3v5, lighting, route/matrix, reward and card-pool release QA. **37/45 LIVE.**

## D244 — Illustrated Sentinel all-25 pack QA

- [x] Generated 25 whole illustrated B-style armored skeleton poses in one complete image (not D243 geometry), preserving held amber lantern and long spear.
- [x] Isolated all 25 source characters via alpha-connected segmentation (prevents source-grid clipping on long thrust), perspectively shortened spear only where necessary to fit fixed 96×96, packed 6×5 lossless WebP/Base64.
- [x] Offline QC: 25 distinct, 5 transparent unused, full character in 2px inset, source-reproducible Python authoring and QC report.
- [x] Created new separate ×1/×3, five-state, left/right Godot F6 gallery using exact D209 forest; **native F6 not yet run**.
- [ ] ONE real full-pack native F6 visual review: leg weight during walk, forward pointed-spear contact, wrist lantern grip, progressive fall/corpse, both facings. Fix any identified flaws before registering.
- [ ] Other four authored role packs, #38 3v5 + localized light mechanic + balance + actual Battle→Reward→Table + 38-card pool smoke. Live still 37/45, checkpoint KARAMBA73 frozen.

## D243 — Technical movement study, NOT yet finished art

- [x] Construct 25 separate per-pose joint silhouettes, including horizontal spear impact and staged physical fall, and verify 25 unique/5 clear/2px/576×480 lossless texture.
- [x] Internally reject D243's visually simplified geometric finish against approved D235 high-detail character. No need for user to test rejected draft.
- [ ] Replace entire study with actual rich B-style painted frames in a ONE-BATCH original 25-cel pack; internal motion/art QA first, only ONE real finished-pack F6 by user.
- [ ] Finish four other original roles and #38 3v5 light/route/reward/balance/release. LIVE 37/45, KARAMBA73 frozen.

## D242 — Native recorded D241 QA fails acting/motion

- [x] Reviewed user's actual 17s MP4 / 16.6s Loom of full D241 QA scene; walk stiff, spear attack not a convincing thrust, death becomes a rotated flattened illustration. Loading PASS is **NOT animation ART PASS**. `docs/D242_SENTINEL_NATIVE_VIDEO_ART_FAIL.md`.
- [ ] **Reauthor complete Sentinel 25 full-body illustrated poses** for walking weight transfer, stab/hand mechanics, hit and collapsing death, preserving approved D235 B style and D234 held lantern. Avoid programmatically assembled body rotations, failed D236 polygon boots and reuse of rejected D239/D241.
- [ ] Internally evaluate new full pack against real shipped D153/D183 motion at x1/x3, stage ONE full Godot F6 scene; no old D241 retest, no per-state user approvals.
- [ ] Only after full art QA tackle other four roles and #38 3v5 light/route/balance/full-pool release gate. Live pool remains 37/45.

## D240/D241 PREVIOUS (ART REJECTED) full-character acceptance gate

- [x] Compared previous released Puppeteer/Marionette/Ferryman full-body animations and traced D239 mismatch to independently drawn polygon boots/greaves and upper/lower compositing; user explicitly **rejected** D239 visuals.
- [x] Re-extracted genuine D235 full-body illustrations with matching armored legs and assembled **one new 25-state D241 QA candidate** with 5 empty cels, static QC and one native F6 scene.
- [ ] One native Godot full-package review of `res://scenes/dev/black_lantern_sentinel_d241_wholebody25_preview.tscn` for feet, weight shift, spear grip/thrust, grounded death. Whole-body source compositing has NOT been approved as final original hand-painted action poses.
- [ ] If still unnatural, **repaint full-body attack/death/movement poses**, not geometric boot grafts or FPS tweaks. Do not register in real Battle until genuine art acceptance. Then other four 25-frame enemies and #38 balance/release QA.

## D239 previous/rejected acceptance gate

- [x] Author/assemble **one complete** 25-cell richly illustrated-source Road Sentinel QA atlas (4/6/6/3/6, 5 clear), and generate source-traced pixel QC in GitHub.
- [x] Stage **one native full-pack F6 gallery** with both facing directions, x1 and x3, approved D209 forest. No per-state user approvals.
- [ ] **Native Godot 4.7 full-pack test and artistic acceptance:** spear thrust/contact, natural knees/corpse pose and real ×1 quality still need user feedback. D239 source-composited is not 25 independently repainted full drawings.
- [ ] Refine whole pack from that single review; complete other four original role packs, then 3v5/light/route/54-case/full-pool QA before #38 release. Preserve existing 37-card pool.

## Completed / locked

- [x] Playable cursed table, exactly 12 Fate Spread resolutions + sealed boss XIII, and tactical battle → reward → table core loop. Solo/duo/trio preserved; DS2 / Variant C visual system accepted.
- [x] #34 D151 Funeral Procession, #35 D152 Defiled Laboratory, #36 D153 Threadbare Theatre all released with distinct enemies, encounter mechanics and scene-led original art. D153 D178 54/54 native balance and D181 native release smoke PASS.
- [x] D182–D187 Black Crossing: accepted card variant 3, Ferryman B/Drowned C atlases and stormy «Последний причал» arena.
- [x] D188–D191 Black Crossing authored 1+2 fight, wave push/slow and D189 safe plank boundaries. **D191 native 54/54 wins**, 0 entire-party defeats.
- [x] D196 storm VFX held as the current visual baseline after user's request; no more wave tuning in this phase.
- [x] D197 user-native preflight and real battle → reward → table confirmed («Все ок»).
- [x] **D198 Black Crossing #37 fully released.** Live 37-card pool, migrated D151–D153/shepherd smoke guards and full-pool random-deal release scene committed. The user replied **«все ок»** to the requested Godot F6 release smoke (user-reported native PASS, no independent log).

## D225 next QA gate — D224 art turning left/right

- [x] **D224 native gallery screenshot received:** correct D209 backdrop, selected Bearer full art visible in x3 and x1, shield-attack pose on screen. This is **NOT** the full five-motion or two-way motion PASS.
- [x] **D225 gallery both-facing controls added** to `scripts/dev/black_lantern_bearer_d224_art_preview.gd`: two buttons `← ВЛЕВО` / `ВПРАВО →` flip both views together and update the current state label. Both views retain nearest filtering; no actual 25-cel image bytes changed.
- [x] **D225 native Godot direction controls user OK:** user replied «все ок. давай дальше» after F6 request; this confirms gallery directional QA at user-report level, not production combat/art.
- [x] **D225 native Godot F6 previously requested (now user-confirmed):** same `res://scenes/dev/black_lantern_bearer_d224_art_preview.tscn`. Check walk / shield attack / fall in BOTH directions. The image's slightly soft details originate from prior 1374→96 pixel repack, not a missing NEAREST setting. Original art refinement later, do NOT silently sharpen user-approved source.
- [ ] Original five-role final polished atlases + combined five-vs-three art review, Battle→Reward→Table and #38 release gates remain.

## D238 CURRENT — produce FULL 25-cel Sentinel animation before next user QA

- [x] **Workflow approved by user**: no more piecemeal idle/walk/attack/death proposals and screenshots; one full game-ready 25-frame delivery per character, one F6 QA when complete. New rule permanently added to `AGENTS.md` / `docs/DECISIONS.md`.
- [x] **New-chat handoff archived:** [`docs/D238_BATCH_ANIMATION_NEXT_CHAT.md`](D238_BATCH_ANIMATION_NEXT_CHAT.md) captures accepted D234/D235/D236R, exact QA asset paths, five-role #38 scope, production status, and immediate one-pack task.
- [ ] **ONE complete rich Road Sentinel atlas:** idle4 + **approved D236R walk6** + original spear-thrust attack6 + hit3 + death6, with 5 unused alpha-clear slots, correct wrist-held D234 lantern, rich D235 outfit, full-scale x1 readability and grounded movement. Rework source frame-by-frame internally until look/motion passes; don't swap in procedural D229 art or fake cropped imagegen animation sheets.
- [ ] **ONE integrated native F6 QA** displaying all five animation states and both directions at x1/x3 on D209; after that, directly fix reported issues and update production art. Do not demand five separate user checkpoints.
- [ ] Repeat complete-25 approach for remaining Lantern Bearer, Oil Acolyte, Extinguished Guide and Lantern Archer; only after the cast, actual #38 combat/lighting/reward/matrix/release. Regular card pool 37/45.

## D237 SUPERSEDED PER-STATE USER GATE — accepted WALK baseline, genuine spear attack six-cel QA

- [x] User replied **«пойдет»** to D236R comparison: corrected gait sufficiently good to move forward. This is a **limited walk visual OK**, not complete final art or integrated battle.
- [x] Supersede D236 unnatural walk; retain D236R original six support/swing WALK frames with accepted D234 lantern grip and approved D235 richer visual direction.
- [ ] **D237 build six genuinely different spear-thrust attack poses** (anticipation/contact/recovery; clear pointed spear, free-hand lantern grip, feet planted), in QA-only resource and ×1/×3 Godot preview, without touching production role until all 25 states finished.
- [ ] Later hit3/death6 and cohesive 25-cel art approval, other four foes, actual #38 battle/light/reward/full pool. Ordinary pool **37/45**.

## D236R prior gait repair — gait fix after user's D236 visual FAIL

- [x] **D236 native visual FAIL:** user «не естествено». Do NOT accept motion based on six unique art hashes. Extreme stride, sudden swapped boots and nearly static torso investigated.
- [x] **D236R gait loop correction staged in main:** alternate 3 contact/weight/push vs 3 opposite-foot stance phases, each frame one planted foot (y91), ≤10px x/y next-step incl wrap, smaller stride, slight body bob while keeping D234 lantern attached; 6 distinct WALK +24 alpha-clear, zero clipped margins. `docs/D236R_SENTINEL_GAIT_REPAIR_QA.md`.
- [x] **D236 vs D236R side-by-side F6:** `res://scenes/dev/black_lantern_sentinel_d236r_gait_compare.tscn` x3/x1 both moving on D209 forest, half-speed control, facing, floor guides.
- [ ] **User-native D236R F6:** verify right-hand gait at actual x1 incl seamless repeat, spear/lantern and soles. **Unconfirmed**. If still unnatural, switch to genuine per-pose illustrated limb animation instead of repeated synthetic limb coordinate polishing.
- [ ] Final richly painted 25 original cels and full #38 release QA. Technical live cards remain **37/45**.

## D236 PREVIOUS / FAILED — real leg-movement proof, need x1 art acceptance

- [x] **Discarded defective D235 poster auto-segmentation:** background brown gradients and spear cropping make naive extract unsuitable, never promote those.
- [x] **D236 true six-phase leg pose motion pilot:** reconstruct from clean D234 handled-lantern upper artwork; hand-defined 6 planted/passing/swing boot/knee poses, 6 distinct cells in walk row1, **24 EMPTY**, no alpha-edge errors. Reproducible GitHub `tools/art/author_road_sentinel_d236_walk6_pilot.py`, art `road_sentinel_d236_walk6_pilot.webp.b64`. `docs/D236_SENTINEL_WALK6_MOTION_PILOT.md`.
- [x] **D236 isolated F6 scene:** `res://scenes/dev/black_lantern_sentinel_d236_walk6_pilot.tscn`; static accepted D209, D234 4-IDLE left vs D236 6-WALK right, x3/x1/facing/pause, structural validators.
- [ ] **USER Godot F6:** confirm feet walk (not slide/floating), correct wrist-lantern, leg art at x1; **NOT native-PASS** until user response. Six poses use reused upper D234 illustrations and drawn legs, NOT fully artist-painted six rich whole bodies, so final D235 fidelity is not automatically accepted.
- [ ] Polish motion/character frame quality before attempting next actual attack6, hit3, death6 and final 25 + five other skeletons/release #38; live pool 37/45.

## D235 PREVIOUS — six-walk Sentinel Style-B visual approved, production cells next

- [x] **D234 grip art direction accepted** by user: wrist-mounted amber lantern visibly HELD, no floating prop. Previous D233 rejected.
- [x] **D235 visual approval** («принято»): rich six-character 3×2 walking illustration, real long SPEAR, layered armor, burgundy hood, hand-held lamp. Original image source SHA `9fa8e48baed60364411e13e2a58d1549e052bbdc250c26b37933d2081442b181`, high-quality full-resolution WebP reference now **committed** under `assets/pixel/units/black_lantern_road_qa/road_sentinel_d235_approved_walk_concept_q95.webp.b64`. `docs/D235_SENTINEL_WALK_ART_APPROVAL.md`.
- [ ] **D235 original six walk cels at true 96px alpha:** draw six physically distinct legs/sole/planted passing poses, consistent lantern wrist grip + spear, protect rich look at x1. Original generated 3×2 poster has gradient backdrop; not a packable animation sheet.
- [ ] Isolated F6 native walk motion/feet/hand x1 on **D209** then remaining attack6, hit3, death6 genuinely authored. Do NOT switch released battle sprite library or card #38 before full art, battle and release QA.
- [x] D229 remains only staged technical alpha atlas; normal pool **37/45**.

## D234 PREVIOUS — fix art continuity BEFORE adding more animations

- [x] **D233 visual issue confirmed by user**: lantern near knee appears detached from free hand; D233 is **REJECTED** as an animation method acceptance.
- [x] **D234 source fix committed**: relocate same rich illustrated lantern to gauntlet, visible short forged hanger + wrist overlap and strictly pivot-linked tiny sway across 4 idle; vacated image region patched with source burgundy-cloak texture. `docs/D234_SENTINEL_HAND_LANTERN_ATTACHMENT_QA.md`.
- [x] **D234 side-by-side Godot F6 scene** `res://scenes/dev/black_lantern_sentinel_d234_hand_lantern_compare.tscn`: left BAD D233/right fixed D234, both x3/x1 and facing controls on exact D209. Static QC 4 unique, 26 blank, no border hits; **not 25 real frames**.
- [ ] **User-native D234 visual check**: at ×1 confirm free hand/handle truly reads as joined and patch isn't an obvious flat panel in all four phases. Only then continue actual separate poses walk6/attack6/hit3/death6. Godot native PASS not yet received.
- [ ] Final illustrated 25-pose quality, four other unique enemies and real battle→reward/light/balance release are still pending. Actual 37-card pool unchanged.

## D233 PREVIOUS — validate real rich-art idle motion before 25-frame commitment

- [x] **D233 idle-only motion proof** from D232 rich transparent figure, reproducible repo-relative painter `tools/art/author_road_sentinel_d233_idle_proof.py`: original body preserved, independent lantern and cloak tip movement, warm flicker. 4 actual distinct alpha cels + 26 clear, zero border faults. **Cutout animation from ONE illustrated pose; not hand-drawn four distinct full character stances or 25 finished cells.** `docs/D233_SENTINEL_IDLE_CUTOUT_PROOF.md`.
- [x] **Dedicated D233 Godot F6 preview** `res://scenes/dev/black_lantern_sentinel_d233_idle_cutout_proof.tscn`, left D232 single still/right 4-frame idle moving, both x3/x1 on approved D209 forest, pause and both orientations, strict 4+26 cell QA.
- [ ] **Native F6 and user method/art feedback:** judge if frame motion preserves lantern and cloak quality at x1; D232 look quality not yet explicitly user-approved.
- [ ] **Then 21 additional different original character poses** (walk6, attack6, hit3, death6) as true art, not 21 copies/tweens of idle. Real full 25-cel QA and battle only after quality success.
- [x] Current staged technical D229 production loader and normal 37-card pool remain untouched.

## D232 PREVIOUS — ONE art-quality check before authentic 25-cel animation

- [x] **D232 one alpha-cleared high-detail original-looking spear guard sample**: correctly shaped long spear, ornate iron armor, separate hand lantern and oxblood cape. Extracted from **one** generated pixel illustration pose and scaled to exactly 96×96 with NEAREST; **NOT native pixel-painted and NOT a valid 25-cel animation sheet**. Original cutout saved as lossless WebP/B64; alpha safe (9,5)–(86,93).
- [x] **D232 actual x1/x3 comparison scene:** `res://scenes/dev/black_lantern_sentinel_d232_art_direction_preview.tscn`, D229 old LEFT vs new static candidate RIGHT, five-state playback INTENTIONALLY ABSENT, correct D209 forest.
- [ ] **D232 real user visual/art direction acceptance:** examine x1 on Godot; only after acceptance work on original 25 true poses. Native Godot not run here.
- [ ] **D232 25-frame production (future):** recreate high-fidelity style in true state cels/alpha/bounds, protect spear and lantern, then real 3v5/battle/reward/light/54-case checks. Do not re-register single still as BattleUnit animation.
- [x] D229 production-stage 25-cel atlas and #38 pool intentionally unchanged; **37/45** live.

## D231 PREVIOUS — restore promised rich Sentinel visual bar; D230 final-art flag REOPENED

- [x] **Diagnosed visual regression / expectation mismatch:** original 1254×1254 illustrated `пиксельный_атлас_скелета_стража.png` has elaborate armor, cloak and lantern but an incorrect **AXE**, 5×5 generated poses; accepted D221 spear concept is rich but includes baked background. Both differ substantially from plain procedural D229 6×5×96px code-generated atlas. D230's claim of final quality was misleading. `docs/D231_SENTINEL_ART_FIDELITY_CORRECTION.md`.
- [x] **D229 SECOND vs FIRST D228 choice retained AS TECHNICAL SHORTLIST** (not final aesthetic quality waiver); D230 role registration currently exists only for unreleased encounter #38.
- [ ] **Proper high-fidelity original game sprites:** produce a single REAL game-scale crisp spear Sentinel matching accepted D221 richness for renewed art approval before painting all 25 poses; no more slight noisy Python shape bumps. If current 96px fidelity is insufficient, obtain user input before changing asset budget/format.
- [ ] **Full 25-pose release-ready Sentinel atlas**, 5 other state roles each complete, combined battle QA. No releasing original AXE art or procedural D229 as visually final. Live Act1 37/45.

## D230 PREVIOUS / SUPERSEDED FINAL-ART CLAIM — Road Sentinel final art DONE; proceed to remaining four enemies

- [x] **User formally chose option TWO / RIGHT D229 as final Road Sentinel** («давай примем 2 вариант и уже закончим с этим»). Never restart pixel-polish passes or ask again between D228/D229. Final art bytes exactly equal approved D229 source. `docs/D230_ROAD_SENTINEL_FINAL_APPROVAL.md`.
- [x] **D230 role-specific production atlas and library registration:** `assets/pixel/units/deck_expansion_v1/road_sentinel_frames.webp.b64`, `MisdealUnitAnimationLibrary.get_frames("road_sentinel")` strict 25 genuine frames/5 empty, `BattleUnit` authored-left orientation correct. Card #38 still QA-only.
- [x] **D230 isolated production-loader F6 smoke staged:** `res://scenes/dev/black_lantern_sentinel_d230_approved_smoke.tscn` compares selected art with actual animation library output at x1/x3 and both directions; does not re-open art approval.
- [ ] **D230 engine-native smoke (may bundle with combined QA):** Godot F6 not yet user-confirmed. Errors should prompt code fixes only, not aesthetic reconsideration.
- [ ] **Next art role:** Lantern Bearer source-approved D224 shield + free-hand lantern; complete its accepted final frame quality as needed; after that original Oil Acolyte, 1.8× Extinguished Guide, Lantern Archer. Then collective 3-vs-5 forest, real #38 battle/light/reward/matrix and release, 37→38 cards only after PASS.

## D229 PREVIOUS / SUPERSEDED artistic comparison — compare actual x1 before another repaint

- [x] **D229 original native 96px art experiment**: real large chest/pauldron facets, richer hood, improved real-spear blade edge, preserves all 25 moving states + 5 fully empty with 0 border violations. Old D228 art unchanged. `docs/D229_SENTINEL_NATIVE_SCALE_AB_REVIEW.md`.
- [x] **D229 A/B Godot F6 comparison scene**: `res://scenes/dev/black_lantern_sentinel_d229_compare.tscn`, D228 left and D229 right, both x3/x1, common animation state + direction controls, exact chosen D209 forest.
- [ ] **USER native F6 and aesthetic result**: compare A/B especially ×1; D228 native F6 was NOT separately accepted just because user asked to continue. Check walk/attack/death and left/right. No assumed PASS.
- [ ] **Final Sprite art fidelity:** x1 differences remain subtle; consider higher-quality silhouette composition at same 96px, *not* endless micro-polish, before agreeing to production sprite. Then remaining original four enemy final passes, combined battle and #38 real release.

## D228 previous QA gate — style-B Sentinel art fidelity

- [x] **D228 native sprite repaint shipped to QA branch of main:** detailed 96px original armor shapes, frayed burgundy cloak, upgraded genuine spear head and bindings, lantern metal cage. 25 different physical animation cels/5 empty/zero alpha border violations, correct 6×5 row-per-state. D227 preserved for visual comparison. `docs/D228_SENTINEL_ORNAMENTAL_PIXEL_ART_QA.md`.
- [x] **Isolated D228 F6 Godot gallery added:** `res://scenes/dev/black_lantern_sentinel_d228_art_preview.tscn` x3/x1, left/right, all five state buttons, approved D209 backdrop.
- [ ] **D228 native user art/animation QA:** verify appearance at x1, full spear thrust, lantern/cape staying attached through walking and collapse, both directions. No actual F6 PASS as of this commit. Polished accepted D221 visual target remains a hard gate.
- [ ] **Before live release:** final-art quality for all five enemies, integrated real #38 Battle→Reward→Table/light and full-pool/matrix smoke; ordinary pool stays 37/45.

## D227 previous native art QA gate — original painted Sentinel 96px

- [x] **D227 25-frame pixel art pass committed**: true native-resolution geometry (armor, skull, cloth, spear, lamp and greaves), alpha-safe original frames `idle4/walk6/attack6/hit3/death6`, five transparent cells, 25 unique, zero border touches. Original D226 QA untouched; **full D221 visual fidelity still not claimed**. `docs/D227_SENTINEL_PIXEL_FIDELITY_QA.md`.
- [x] **D227 F6 scene committed** `res://scenes/dev/black_lantern_sentinel_d227_art_preview.tscn` with x3 / x1 and LEFT/RIGHT, on accepted D209 forest.
- [ ] **D227 user Godot QA and art decision:** check walking soles, exact spear thrust, arm/lantern placement, final grounded collapse in both orientations; compare D226 vs D227. **Native PASS not yet received**.
- [ ] Full polished five-role artwork, real integrated #38 battle, reward route/matrix and 38/45 release checks all pending. Old released pool stays 37/45.

## D226 previous gate — painted Road Sentinel

- [x] **D226 richer original 25-cel spear Sentinel candidate:** deterministic native 96px drawn art in approved armored A silhouette/B palette with torn russet hood and copper-iron wear; 25 unique + 5 transparent, zero edge warnings, original pointed spear/amber lamp. **Not the final D221 fine-detail quality yet.**
- [x] **D226 isolated Godot F6 gallery:** original D209 moonlit forest, 3× and 1× frames, left/right direction switches, five states, strict validators. Source/asset/QA documented in `docs/D226_SENTINEL_STYLE_B_ART_QA.md`.
- [x] **D226 screenshot: native loading and leftward walk visible** — user showed x3 + x1 gallery on D209 background with no red QA error. This is **partial evidence only**, not all five motion states and left/right toggles tested.
- [ ] **D226 art fidelity / D227 native 96px repaint:** skull, plate volume, rusty metal clusters, spear head, lantern shape and burgundy mantle still visibly simpler than user-approved D221 illustration. Preserve 25 authored poses; not permitted to call D226 a final art PASS based solely on rendered gallery.
- [ ] **D226 full five-state/direction user-native visual review:** `res://scenes/dev/black_lantern_sentinel_d226_art_preview.tscn`, confirm direction, leg contact, real spear thrust, visible lantern at 1×, death; assess against D221 accepted detailed illustration. No live sprite swap until approved.
- [ ] **Full five-hero original art completion + real #38 battle/reward/table/release smoke** remains outstanding; live 37/45.

## D209/D210 status

- [x] **D209 native arena art visual PASS** — user F6 screenshot and «все ок» on selected third black-forest art, 3 hero + 5 enemy proxies and moving pools; this confirms layout only, not final character art.
- [x] **D210 art preflight** — five source 5×5 sheets and remapped 6×5 candidates visually audited; 13/20/24/21/13 boundary-contact warnings, Sentinel axe vs approved spear. Five atlas approval gates still **BLOCKED**. See `docs/D210_BLACK_LANTERN_ANIMATION_ART_QA.md`.
- [x] **D211 Sentinel option A approved** by user («а»): armored long-spear silhouette with small lantern. No authentic production atlas yet. `docs/D211_ROAD_SENTINEL_SPEAR_CONCEPT_OPTIONS.md`.
- [x] **D213 canonical animation master brief committed:** fixes prior chat D212/D213 row-major mismatch. All five Godot atlases MUST be row-per-state: idle(4), walk(6), attack(6), hit(3), death(6); 5 transparent surplus cells. `docs/D213_BLACK_LANTERN_MASTER_ANIMATION_BRIEF.md`.
- [x] **D214 Bearer production specification committed:** 25 explicit pose directions, heavy lantern + wooden defensive plank, real pixel/foot/alpha gates; purely ART specifications, no real atlas. `docs/D214_LANTERN_BEARER_PRODUCTION_SPEC.md`.
- [x] **D215 first original Road Sentinel QA atlas produced and committed:** handmade pose-specific 25 frames, 6×5 correct rows, transparent WebP/B64, no border spills, isolated native gallery F6; 3× and 1× on D209. **User art approval and native F6 PENDING; QA-only, not enabled in gameplay.** `docs/D215_SENTINEL_NATIVE_ANIMATION_QA.md`.
- [ ] Produce/review FIVE **genuinely authored** idle/walk/attack/hit/death 96px transparent atlases. Begin with Sentinel's correct spear; retain prior selected arena and card illustration.
- [x] **D215 Road Sentinel native F6 OK** — user replied «все ок продолжай дальше» after five-state standalone gallery check. QA candidate is acceptable for next art step; still not registered as live sprite or in battle.
- [x] **D216 Lantern Bearer original 25-frame QA asset staged:** shield-first melee, separately held amber lamp, walk/hit/death (576x480 WebP/B64, 25 distinct poses, 5 blank, zero border flags). Authored Python source + QA-only Godot gallery committed. `docs/D216_LANTERN_BEARER_ANIMATION_QA.md`.
- [x] **D217 Oil Acolyte QA source/gallery staged:** genuine third role with original flask+curved sickle+small belt-lamp identities. Local independent 25-pose PNG/WebP raster passed offline alpha QC; GitHub hosts a **separate 25-state original SVG QA** plus native `load_svg_from_buffer` F6 scene. Neither is production library art. `docs/D217_OIL_ACOLYTE_ANIMATION_QA.md`.
- [x] **D217 error diagnosis + source fix:** user Godot F6 screenshot flagged death row4 cells4/5; deleted only two offending low rib strokes from editable SVG, commit `a8a80f1`. QA checks remain strict, no gameplay/source substitution; native retest required.
- [x] **D217 native Oil Acolyte F6 retest user-reported PASS:** user replied «все ок» after the exact post-hotfix F6 request; removed border errors from death row4 col4/5, without loosening QA. No video or full-flow battle acceptance.
- [x] **D218 Guide QA atlas and F6 gallery source committed:** 25 original 96px cels, 5 unused transparent, no offline border contact; large leader silhouette with 3 chained lamps, 1.8x beside 1x Bearer on accepted D209 art. Full: `docs/D218_EXTINGUISHED_GUIDE_ANIMATION_QA.md`. **Godot F6 still pending**.
- [ ] **D218 native Guide F6:** `res://scenes/dev/black_lantern_guide_animation_preview.tscn`, inspect size ratio, feet, light chains, five motions, final corpse.
- [x] **D219 isolated Lantern Archer F6 positive user report** — user replied «все ок» after the D219 gallery test; technical preview only, NOT polished production-art approval.
- [x] **D220 explicit user-facing final-art requirement documented** — all FIVE QA-simplified sprites must be fully repainted into approved Misdeal dark-fantasy pixel art and reviewed together on D209 at real scale before production registration and #38 release. See `docs/D220_BLACK_LANTERN_FINAL_SPRITE_REPLACEMENT_GATE.md`.
- [x] **D221 Sentinel final appearance chosen** — user accepted detailed heavy-armored long-spear Sentinel illustration in selected collective style B («отлично»). Design approval only; composite is not transparent 25-cel game art. `docs/D221_SENTINEL_FINAL_STYLE_APPROVAL.md`.
- [x] **D222 Bearer concept quality review:** three B-style illustration panels generated but all had **unapproved long staff + lantern on shield** rather than a separate hand lantern, so REJECTED in art QA; do not use as assets. `docs/D222_LANTERN_BEARER_FINAL_ART_REVIEW.md`.
- [x] **D223 corrected Bearer visual concept illustrated:** 388×386 character-only crop with broad wood barricade and **separate hand-held lantern**, no pole, style B; conversation asset (not in-game art). User artistic approval **PENDING**. `docs/D223_LANTERN_BEARER_CORRECTED_CONCEPT.md`.
- [x] **D223 Lantern Bearer appearance approved** («да все ок»), shield one hand and separate lantern other; no spear.
- [x] **D224 Bearer 25-pose art sheet approved** («подходит»): exact RGBA source converted to visibly-lossless WebP/B64 in GitHub, 25-cel 576×480 repack + reproducible author and machine-readable QC, strict isolated F6 scene; no live sprite switch. `docs/D224_LANTERN_BEARER_APPROVED_ART_QA.md`.
- [ ] **D224 user-native F6:** `res://scenes/dev/black_lantern_bearer_d224_art_preview.tscn`; check 5 animations at 3× and 1× for any missing pixels at seam, feet/lantern/shield movement, final corpse; only then production art readiness.
- [x] **D223 Lantern Bearer specific visual acceptance** — user confirms D223 or requests edits, then real full-quality 25-cel animated original sprite in correctly packed rows.
- [ ] **D222 Lantern Bearer corrected standalone character appearance** — shield plus separate HANDHELD lantern, absolutely no staff/spear or composite fake 25-frame sheet; show to user before true final atlas.
- [ ] **D221 Lantern Bearer appearance** — present in same B art direction with broad wooden defensive barrier and heavy hand lantern, obtain user look approval before 25-cel art.
- [ ] **D220 actual FIVE final atlases:** original repaint, not upscale/recolor. Art options → explicit approval → native gallery/combined scene → integrate battle→reward→table → release smoke.
- [x] **D219 final Lantern Archer QA-only atlas produced:** new original 25-frame archer bow, quiver and lantern, with proper bow draw and user-native gallery before battle.
- [ ] **D216 five-state art approval** — gallery **renders** (user screenshot shows 3×/1× and shield attack, no QA FAIL); idle/walk/hit/death motion not yet separately confirmed. Scene: `res://scenes/dev/black_lantern_bearer_animation_preview.tscn`, check stance/foot contact, shield attack and final collapse on approved D209 arena.
- [ ] After sprite approval: Godot animation F6, actual #38 five-enemy battle with encounter-only light, then real reward→table and release smoke before Act1 **38/45**.

## D219 — fifth original role, art integration/release still gated

- [x] D218 triple-lantern Guide standalone preview: user replied **«отлично»** after native F6 request. Positive user feedback; no independently supplied new screenshot/log, nor real battle validation.
- [x] D219 original Lantern Archer 25-pose alpha WebP/B64 and editable Pillow art source created and committed: curled bow, quiver, amber lamp, intentional draw→loose→recover; **25 distinct / 5 empty / 0 border flags** offline, GitHub content verified; native F6 pending.
- [ ] **D219 native F6:** `res://scenes/dev/black_lantern_archer_animation_preview.tscn`. Judge 3×/1× bowstring, arrow leftward, alternating feet, grounded death and health/HUD room on accepted forest.
- [ ] Joint animation-scale/orientation QA for all five roles on D209; D216 Bearer complete five-motion user check if needed.
- [ ] Only after art/native QA: register five distinct original enemy roles in animation library for **QA-only** real `black_lantern_road` encounter, wire moving light, verify real Battle→Reward→Table; 54-case regression and full-pool release smoke before live card #38/45.
- [ ] Preserve `backups/KARAMBA73-2026-10-16`, live 37-card deck and accepted older encounters.

## Next (strict order)

1. [x] **D199:** #38 `black_lantern_road` approved design — five original skeletal roles, 2×-height Guide, travelling light; no live enemy assets or gameplay.
2. [x] **D200:** exact third card illustration installed QA-only, user-native art review previously reported OK. Keep it unchanged.
3. [x] **D204 → D205 arena selection:** user chose geography **A dead forest bend** and then **third of three finished forest backdrops**, exact source `лунная_дорога_через_туманный_лес.png` (1672×941); image is conversation-only, not yet Godot scene or GitHub assets.
4. [x] **D205 tech staging:** convert five previously generated 5×5 source concept atlases into 6×5 96px **review-only** candidates (25 nonempty unique frames per role). Edge-cropped source poses and Sentinel spear/axe mismatch **BLOCK art sign-off**; never enable them as live animations. Stager and QC spec documented.
5. [x] **D206 QA-only encounter and scoped effect source:** five unique UnitData, 2 five-enemy formations and isolated +16% enemy-only travelling-lantern buff/reset logic; *not wired into a playable battle, no native QA yet*. See `docs/D206_BLACK_LANTERN_ENCOUNTER_STAGING.md`.
6. [x] **D206 Godot native contract PASS:** user screenshot confirms 5 original UnitData, two formations, enemy-only lantern buffs/reset after the typed-array fix. This is NOT actual combat QA.
7. [x] **D207 54-case real-combat matrix written QA-only:** `res://scenes/dev/black_lantern_road_battle_matrix.tscn`; uses original UnitData, BattleUnit AI, deterministic scoped light, 2 formations × 3 classes × 3 party sizes × 3 orders. No art switching/live card inclusion.
8. [x] **D207 native F6 matrix 54/54 functional PASS** (user screenshot): 0 defeats/timeouts, avg HP solo/duo/trio 80/70/74%, worst 52/30/44%, light buff observed; **balance not yet approved**. Baseline: `docs/D208_BLACK_LANTERN_BALANCE_PASS.md`.
9. [x] **D208 narrow candidate staged:** increase the #38 *lit-enemy-only* speed modifier 1.16 → 1.22; no generic enemy stat changes. Add actual light-buffed enemy attack counting to deterministic matrix.
10. [x] **D208 native F6 rerun PASS:** 54 wins, no defeat/timeout, HP and duration unchanged to display precision; 59 of 635 enemy attacks accelerated (9.3%). +22% bonus reverted to already-tested +16% in `cc624e3`. Keep actual-attack instrumentation; **do not call balance approved**. Full comparison: `docs/D208_BLACK_LANTERN_BALANCE_PASS.md`.
11. [ ] **D205 native light-cue F6:** run `res://scenes/dev/black_lantern_road_light_preview.tscn`, verify clear moving circles / warning / five enemy proxies and pause. It is explicitly not battle code.
12. [x] **D209 exact forest arena committed:** selected third source re-exported as 1280×720 WebP/Base64; GitHub stored SHA exactly matches local export. Existing authored-backdrop now supports `black_lantern_road`, other arenas unchanged.
13. [x] **D209 native visual F6 PASS** — user screenshot confirms approved original forest background, 3 hero and 5 enemy proxies, large Guide outline and moving lantern circles. Visual layout accepted; actual sprite foot contact not yet tested. See `docs/D209_BLACK_LANTERN_ARENA_NATIVE_QA.md`.
14. [ ] Finish/correct five genuinely distinct skeletal 25-frame atlases to the approved silhouettes; native animation gallery and sprite F6.
15. [ ] **Activate the staged encounter locally** only after art QA: wire #38 light into battle, then 54-case solo/duo/trio combat matrix, real battle→reward→table, and full-pool smoke. Only after approval release #38 to **38/45**.
16. [ ] Finish remaining seven cards without rewriting existing D151–D153 or D196 effects.

## Constraints

Godot 4.7.x + GDScript, data-driven focused additions, rapid playable vertical slice, no speculative global architecture. D143 new enemies for new combats; D167 credible world scene art; D168 user chooses from rendered variants before art integration.
