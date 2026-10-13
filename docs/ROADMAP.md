## D144 first user Godot screenshots — 2026-10-14 — smoke parser hotfix; 54 fights need rerun

- [x] User locally verified **art preview & genuine new battle launch**; unique Shepherd/Lamb sprites display, card image renders, normal Knight deployment versus 1 Shepherd+2 Lambs shows in the cemetery arena. These screenshots confirm import/render, not full animation/ability/balance approval.
- [x] Screenshot exposed **Godot compile error** `const EXPECTED_PATHS := PackedStringArray(...)` in `scripts/dev/bone_shepherd_smoke.gd`. Changed to `const EXPECTED_PATHS: Array[String] = [...]`, convert to PackedStringArray at runtime for authored-roster comparison. Also hide simulated arena while test writes PASS/FAIL. GitHub main hotfix committed.
- [ ] **User now:** `git pull` then **F6** `res://scenes/dev/bone_shepherd_smoke.tscn`; expect `DECK EXPANSION 01 — PASS` 54/54 only if native compiler/runtime works; share screenshot and Godot Output if more errors. No F6 54-case PASS recorded yet.
- [ ] **Visual art polish**: actual gallery/battle screenshots show extremely flat/vector-like creatures/card art compared with approved high-detail cemetery arena and blue Knight. Discuss desired rework direction; produce genuine denser but legible original pixel-art animation frames for both new species and consistent card illustration, without changing gameplay identity or reverting to old foes. Current art works as unapproved initial gameplay visuals only.
- [ ] Test visible Whistle warning, both Lambs rushing, floor contact and full reward path in actual live encounter; don't infer whistle success from static battle screenshot.
- [ ] Preserve D143 unique enemies, 31-card pool, old encounter rosters and existing Fate Spread; balancing HUNT/duo unrelated.

---

## D144 — Bone Shepherd Deck Expansion first playable source shipped (Godot QA NEXT) — 2026-10-14

- [x] User authorized full first new combat card after approved concept and production brief. **Implemented in GitHub main**, not merely a plan: Tier0 `bone_shepherd` registered as new Act1 card, 31 total pool / 11 Tier0; normal 12+XIII run length untouched.
- [x] Two entirely new enemy UnitData/visual roles `bone_shepherd` ×1 and `ossuary_lamb` ×2, fixed roster across two authored `EncounterData` formations; no old-enemy reskins/roster swaps. New pixel-shaped SVG 576×480 6×5 animation sheets with 25 frame positions/role and 448×274 unique card art SVG; load as Godot Texture2D, not binary WebP.
- [x] Whistle integration: encounter-only BoneShepherdWhistleController + data Resource, 5.5s first warning, 0.65s visual cue, 1.25s Lamb shared-target rush ×1.35 movement only, 8s cycle; role-gated temporary AI, kill-during-warning/kill-during-rush cancellation. No changes to old orders/party-size stats.
- [x] Three test/playtest entry points: `scenes/dev/bone_shepherd_art_preview.tscn`, `scenes/dev/bone_shepherd_smoke.tscn` (**54** real BattleUnit scenarios + whistle lifecycle), and `scenes/dev/bone_shepherd_playtest.tscn` (actual Knight vs new encounter in normal battle UI). Static SVG/role/registry/scene checks passed.
- [ ] **USER NEXT:** `git pull`, open Art Preview and F6; inspect readability, horns/hooves, no floating art, native animation; F6 Smoke should yield **DECK EXPANSION 01 — PASS** (54/54); F6 Playtest should open normal new battle and show shared Lamb rush after a visible cue. Send screenshots + error text if FAIL.
- [ ] Fix any actual Godot parse/import/runtime errors via connected GitHub, adjust visually approved original art only based on user QA, and measure tier0 solo/duo/trio balance. **Do NOT claim F6 PASS until user sees it**.
- [ ] After Card01 Godot acceptance, proceed with 14 additional proposed Act1 cards toward 45, every future combat variant with entirely new units and art per D143. D142 HUNT/duo remains separate.
  
---

## Deck Expansion Card 01 — production-ready specification COMPLETE — 2026-10-14

- [x] User approved preparing a production-ready package. Full design/implementation/QA plan committed in docs/DECK_EXPANSION_BONE_SHEPHERD_PRODUCTION.md. 1 brand-new bone_shepherd commander + 2 entirely new ossuary_lamb quadrupeds; unique 0.65s whistle warning + bounded 1.25s synchronized speed-boost rush (all preliminary combat timings/stats subject to F6).
- [x] Defined actual Russian card copy, both authored enemy placements, UnitData fields, small data-driven Whistle state logic, original sprite/frame dimensions + separate card art, deterministic death/interrupt handling, Godot 54-case smoke and live-play acceptance. Compatible with existing BattleUnit, UnitData, EncounterData, RunCardData and animation/art pipelines; preserves D143 original-enemy contract.
- [ ] Create original new 448×274 card art plus two genuinely animated 576×480 enemy sprite sheets (96×96 per cell; real idle/walk/attack/hit/death), confirm native 1280×720 readability, limb/hoof placement and correct orientation. NO reuse of old enemies.
- [ ] Implement and commit two new UnitData, one new EncounterData + two layouts, new card Resource, scoped Whistle data/AI/cue, animation registration/unique fallback and standalone F6 art+combat preview.
- [ ] Register card into RunState.CARD_PATHS and ACT1_CARD_IDS only after complete visual+behavioral package and Godot QA; pool becomes 31 Tier0=11, 12+XIII unchanged.
- [ ] Then expand toward 45-card pool; each new battle card requires own new enemies, without random roster swaps. Separate D142 old balance work is still pending.

---

## Deck Expansion Phase 1 — Bone Shepherd candidate design prepared (not implemented) — 2026-10-14

- [x] User said «отлично погнали» to starting the first new card **after** D143's genuine-new-enemy constraint. The first proposed card is Tier0 `bone_shepherd` / «КОСТЯНОЙ ПАСТУХ».
- [x] Draft and commit concept with **two original species**, `bone_shepherd` commander and `ossuary_lamb` bone ram, 1+2 fixed roster, distinctive nonlegacy visuals and original Whistle→short coordinated rush, `docs/DECK_EXPANSION_BONE_SHEPHERD_CONCEPT.md`.
- [ ] **Visual/mechanics approval:** show art concept and get specific signoff before shipping battle creatures. Don't confuse concept illustration with production sprite sheet.
- [ ] Produce authentic new character miniature animations/source art and own card illustration in locked DS2/Fate Spread style; not reused palette-swap sprites.
- [ ] Implement one card `bone_shepherd`, one unique EncounterData, two new UnitData creature types, data-driven commander/lamb charge behavior, clear cues and tests; verify solo/duo/trio Tier0, card truth and 12+XIII unchanged. **None implemented yet.**
- [ ] Then expand remaining noncombat and original-enemy combat cards toward 45-card Act1 pool after independent review.
- [ ] Keep unrelated D142 HUNT/party-size experiments separate.

---

## DESIGN GATE — 2026-10-14 — Act 1 Deck Expansion (+15) requires original enemies

- [x] User explicitly clarified rule for planned new cards: **any combat branch, including optional combat in an event, requires genuine NEW enemy types and custom enemy art/behavior/roster**. No old enemies passed off as fresh content. Canonical: **`docs/DECISIONS.md` D143**.
- [x] Baseline from `RunState.ACT1_CARD_IDS`: **30 existing nonboss cards**, tier 0/1/2 10 apiece; goal **45 pool cards**, while each run stays **12 resolutions + central boss XIII**.
- [ ] Resolve preliminary 15-card specification and cost. Previous proposal named **five** fight-bearing ideas, despite saying “3 combat cards”: Funeral Bell, Bone Shepherd, Executioner at Crossing, Vault Coin Guard (optional combat), Crimson Guard. Count every fight branch and design new enemy roster/resources/visuals accordingly.
- [ ] Build new authored card art and unique enemy sprites/animations for a **single first new combat encounter** before shipping further new combat cards; stage noncombat choice/echo cards separately to deliver variety early.
- [ ] Independently verify card pool selection, guaranteed fights by tier, unique encounter identity and end-to-end 12+XIII; no enemy-roster random substitutions. **No Deck Expansion code or art committed yet.**
- [ ] Continue separate D142 tactical balance experiment only after user direction; do not conflate new enemy content with tuning old HUNT and solo/duo/trio problems.

---

## CURRENT — 2026-10-14 — D141 measured trace review DONE; next decision D142

- [x] User uploaded both D141 trace CSVs: **126 scenario rows + 792 unit rows**, 66 wins/60 losses and 0 timeouts; complete source analysis in **`docs/TACTICAL_GAMEPLAY_V25_DIAGNOSTIC_REVIEW.md`**. No separate F6 screenshot received; files produced by Godot harness.
- [x] Exact join against actual D140 v24 CSV: **126/126 case outcomes and durations unchanged**; unit metrics sum exactly to case metrics.
- [x] `last_bell` HUNT **4/18** vs ASSAULT/FORMATION **18/18**, executing **12.78 vs 18.78** attacks, dealing **281.14 vs 394.69** effective damage, taking **233.93 vs 102.51** enemy damage and allowing more bellkeeper healing (**41.41 vs 25.71**). Chase seconds similar; do not assume chase distance alone is root cause.
- [x] Late Knight solo **24/24** vs Knight+Ranger **0/24** and trio **2/24**; duo heroes both die each time, inflicting **281.27 vs 467.81** solo effective damage in shorter fights. Solo compensations likely important but not isolated from role composition/spawn formation.
- [ ] **Get user approval for D142 isolated diagnostics**: matched fixed-seed HUNT ranged target access/near-threat strategy A/B using per-unit telemetry; separate one-factor party stat pressure vs placement experiments for Knight duo/trio.
- [ ] Check full **real** Act 1 path (12 cards + Bone Warden XIII) including Wizard bargains, earned upgrades, event/reward return, companion recruitment/loss and solo viability; tune only based on specific causal data plus live feedback.
- [ ] No changes to enemy rosters per card, DS2/Fate Spread or the 18 approved arts, and no blind global scaling revisions.

---

## D141 ACTIVE — Gameplay 2.5: diagnosis before balancing — 2026-10-14

- [x] User explicitly approved («Давай») diagnostic-first Gameplay 2.5 on D140 CSV findings.
- [x] Add optional `BattleUnit` signals for **executed attacks**, actual primary+splash HP damage and healing actually restored by bellkeepers. Signals fire only while a dev trace subscriber is connected; no balance/AI/tactic/card/arena/loot changes.
- [x] Add F6 `res://scenes/dev/tactical_gameplay_v25_combat_diagnostics.tscn` with **126 exact v24-matched cases**: all 54 Last Bell combinations, 72 Knight-led late battles (Ossuary Gate/Firing Square) across solo/duo/trio × 2 layouts × 3 orders × 2 seeds.
- [x] Export `misdeal_tactical_v25_trace_cases.csv` and `misdeal_tactical_v25_trace_units.csv` with attack counts, damage in/out, healer recovery, target pursuit/support focus time, movement, target changes, and normal W/L/seconds/survivors. Scope/interpretation in `docs/GAMEPLAY_V25_DIAGNOSTICS.md`.
- [ ] **User local Godot F6:** `git pull`, run `scenes/dev/tactical_gameplay_v25_combat_diagnostics.tscn`. Expect `TACTICAL GAMEPLAY 2.5 — PASS` when all 126 finish; report Godot Output on error and attach **both** `user://` CSVs.
- [ ] Verify v25 outcomes equal 126 corresponding old v24 cases; quantify Last Bell HUNT actual damage/healing/approach versus ASSAULT/FORMATION and Knight solo/duo/trio trace metrics before changing combat.
- [ ] **Actual Act 1 QA still pending:** play through card choice, deals/risks/upgrades/battle/rewards and Bone Warden XIII. Only propose narrowly supported game balance changes after diagnostic + live play.
- [ ] Do not alter global enemy/hero scalers, accepted enemy rosters/card identities/art/DS2 or Fate Spread on the basis of aggregate F6 win percentages alone.

---

## NEXT ACTIONS — 2026-10-14 — D140 CSV review complete, Gameplay 2.5 proposal awaiting approval

- [x] Download/parse user's `misdeal_tactical_v24_party_focus.csv`; **270 clean rows, 158W/112L, 0 timeouts**. Canonical measured report: **`docs/TACTICAL_GAMEPLAY_V24_BALANCE_REVIEW.md`**.
- [x] HUNT in D140 is **24/90** vs ASSAULT/FORMATION each **67/90**; HUNT wins in **zero** matched cases when ASSAULT loses. `last_bell` HUNT 4/18 vs other orders 18/18. Functional target test != viable tactical option.
- [x] With class-held comparisons, solo **82/90**, duo **30/90**, trio **46/90**; late equipped Knight solo 24/24 vs Knight+Ranger duo 0/24, Knight trio 2/24. This is a warning under illustrative deterministic builds, NOT proof a particular scaler is defective.
- [ ] **Wait for user approval** before any Gameplay 2.5 production retuning. Prefer dev-only matched-seed diagnostic instrumentation of HUNT target chasing, effective hits, healer heals, and Knight+Ranger duo behavior, prior to heuristic rewrites or global enemy/party stat changes.
- [ ] Use observed diagnostic + **real Act 1 run** rewards/Wizard wagers/combat/boss XIII to decide any narrowly targeted changes. Keep each combat card's authored enemy roster/art/layout and established DS2/Fate Spread/18 approved assets frozen.

---

## D140 local F6 acceptance — 2026-10-13

- [x] User screenshot confirms **TACTICAL GAMEPLAY 2.4 — PASS**: 270/270 controlled BattleUnit battles completed, **158 wins and 112 losses**; test-specific two-bellkeeper HUNT shared focus, wounded priority and melee intercept assertions passed.
- [ ] **Request the actual CSV** `user://misdeal_tactical_v24_party_focus.csv` through Godot Project > Open User Data Folder. Analyze 270 cases by card, formation, order, protagonist, companion roster, party size and seeded sample. Do not infer specific solo/duo/trio or HUNT balance from aggregate 158/112.
- [ ] Validate core live Act 1 path with real Wizard risk/rewards and Bone Warden XIII; tune only observed and measured outliers. Preserve all card-enemy rosters, visual approvals and party-size scalers until evidence supports a specific change.

---

## D140 ACTIVE — Gameplay 2.4 coordinated HUNT and controlled party benchmark — 2026-10-13

- [x] User approved («давай») further tactical support focus + fairer protagonist-fixed solo/duo/trio comparison; see `docs/DECISIONS.md` D140.
- [x] Implement common alive-party-center tie break and wounded-health-ratio focus for HUNT targets within the healer/ranged ranks, retaining nearest-melee fallback in `BattleUnit`. Retain D139 melee close-frontline interception and normal ranged support focus; no enemy/card/stat/art changes.
- [x] Add F6 `scenes/dev/tactical_gameplay_v24_focus_party_benchmark.tscn`: regression fixture for two bellkeepers, shared HUNT initial/wounded target, Knight proximity intercept and Ranger/Mage support priority.
- [x] Add **270 actual-unit controlled fights**: `last_bell` 54 bare; `ossuary_gate` and `firing_square` 216 equipped with two seeds, 2 layouts × every protagonist × 1/2/3 party sizes × three orders. Fixed cyclic companion order for each protagonist; new CSV `user://misdeal_tactical_v24_party_focus.csv` with explicit `party_roles` and match key.
- [ ] **User Godot F6:** `git pull`; run `res://scenes/dev/tactical_gameplay_v24_focus_party_benchmark.tscn`; expect `TACTICAL GAMEPLAY 2.4 — PASS`; attach screenshot and CSV; repair any engine errors in GitHub.
- [ ] Analyze v24 HUNT results for `last_bell` under 3 protagonists and all party sizes; compare with prior D139 baseline while accounting for changed sampling; check no dominant default order.
- [ ] Analyze late equipped party trajectories for **same protagonist**, using explicit party compositions, two seeds and fixed encounters/variants; avoid interpreting as an isolated test of scaler coefficients.
- [ ] Perform real Act 1 end-to-end play with meaningful upgrades/Wizard risks and rewards, boss XIII; defer global scaler/enemy nerfs until live observations justify them.

---

## LATEST — D139 measured v2.3 CSV analysis completed — 2026-10-13

- [x] User uploaded `misdeal_tactical_v23_balance.csv`: 180 rows, 79 W/101 L, no timeouts; full review in `docs/TACTICAL_GAMEPLAY_V23_BALANCE_REVIEW.md`.
- [x] Exact v22/v23 72-case regression: HUNT 5/24 -> 8/24 (four loss→win, one win→loss); ASSAULT and FORMATION remain 13/24 each with identical baseline outcomes.
- [x] Late-stage upgrade sensitivity: bare 6/72 -> built 42/72 (36 matched loss→win), indicating upgrade resources have major impact; **do not global-nerf enemies based on bare cases**.
- [x] Flag residual `last_bell` HUNT 1/6, and late equipped solo 22/24 vs duo/trio 10/24 each. Caution: hero roster/protagonist selection is not controlled independently for variant/party comparisons; two seeds showed no win/loss differences.
- [ ] **User approval needed for further balancing pass:** experiment with focused healer/support targeting for HUNT in `last_bell` while keeping role distinction; do not blindly buff hero damage or randomize card enemy rosters.
- [ ] Build better controlled late-tier benchmark varying party sizes with same protagonist/defined companions, seed/layout held fixed; compare accessible builds and validate live Act 1 battle progression.
- [ ] Only after real data and gameplay verification consider encounter-local tuning, never assume a F6 PASS proves actual solo/duo/trio balance.

---

## D139 verified in Godot — 2026-10-13

- [x] User screenshot confirms `TACTICAL GAMEPLAY 2.3 — PASS`: all **180/180** controlled battles ended, **79 wins / 101 losses**, Knight HUNT near-threat interception preview PASS.
- [ ] **Obtain the 180-row CSV** `user://misdeal_tactical_v23_balance.csv` via Godot Project > Open User Data Folder. Analyze card, order, solo/duo/trio, layout, seed, `bare` vs `tier2_built`. Compare matched old v22 bare cases to evaluate HUNT fix; aggregate 79/101 does not prove good/bad balance.
- [ ] Verify actual Act 1 battles with improvements, boss/rewards/return; propose further targeted encounter changes only if measurements warrant it.

---

## D139 — Gameplay 2.3 approved and source-committed — 2026-10-13

- [x] User explicitly approved balancing HUNT without discarding healer/archer priority, plus stage-aware late-Act tests using actual authored upgrades/artifacts.
- [x] **Production:** `BattleUnit._find_hunt_enemy()` now conditionally engages an immediate closest threat for melee hunters (within 165, support priority target beyond 165). Ranged Ranger/Mage HUNT unchanged; no enemies/card art/rosters/rewards/scalers altered.
- [x] **F6:** new `scenes/dev/tactical_gameplay_v23_balance_benchmark.tscn` with Knight HUNT near-threat preview regression and 180 BattleUnit fights: 36 tier-1 bare, 144 tier-2 bare/upgraded with 2 seeds; matched seeds per order/build; real RunState authored upgrade and artifact resources and combat stat sequence. Exports `user://misdeal_tactical_v23_balance.csv`.
- [ ] **Local Godot QA:** user `git pull`, F6 new scene, expect `TACTICAL GAMEPLAY 2.3 — PASS`, attach screenshot and resulting CSV; investigate any FAIL directly in repo.
- [ ] Analyze v23 per-card/variant/party/seed/order and equipped versus bare; compare corresponding v22 bare scenarios for HUNT delta. Pass only certifies completion, not win-rate quality.
- [ ] Play real `last_bell` / `ossuary_gate` / `firing_square` with typical upgrades and `HUNT`; tune card-local difficulty only if actual outcomes demand it. Keep original card identities, 12+XIII structure, approved art frozen.

---

## NEXT PROPOSAL — D138 measured balance follow-up (not yet implemented) — 2026-10-13

- [x] Obtain and inspect actual user CSV (72 valid rows). Full findings: `docs/TACTICAL_GAMEPLAY_V22_BALANCE_REVIEW.md`.
- [x] Confirm severe contrast between naked tier-1 vs tier-2 benchmarks: 28/36 vs 3/36 wins; source cannot certify real upgraded builds.
- [x] Identify HUNT 5/24 total versus ASSAULT and FORMATION 13/24 each; in `last_bell` 0/6 HUNT vs 6/6 for both others under matched conditions.
- [ ] **Await approval** to adjust HUNT's currently distance-unbounded support focus in `BattleUnit`. Test minimal distance/near-frontline-aware targeting without breaking its priority purpose; use identical benchmark inputs before/after.
- [ ] Add stage-aware benchmarking with actual upgrade/artifact resources before reducing `ossuary_gate` / `firing_square` difficulty.
- [ ] Inspect live Act 1 rewards/run flow and solo/duo/trio formation differences; only tweak specific encounters with evidence. Preserve all card rosters, visuals and gameplay pillars.

---

## CURRENT — D138 Gameplay 2.2 advanced card-faithful tactical formations — 2026-10-13

- [x] User **approved** the Gameplay 2.2 package after D137 favorable live feedback and D137 54-setup F6 PASS.
- [x] Authored two positions-only formations with unique positioning tells for four existing combat cards: `gallows_volley` (skeleton + 2 archers), `ossuary_gate` (guard + healer + archer + thrall), `last_bell` (2 raiders + 2 bellkeepers), `firing_square` (sentinel + 4 archers). No enemy roster substitutions or new cards/art.
- [x] Reuse the existing D137 formation selection/memoization and same-encounter retry stability without changing `battle.gd`, `run_state.gd`, `EncounterData` or core combat abilities.
- [x] Create new F6 real-BattleUnit `scenes/dev/tactical_gameplay_v22_battle_benchmark.tscn`: 72 controlled baseline fights (4 × 2 × 3 party sizes × 3 orders), virtual-time simulation of true movement/damage/healing, CSV outcome/time/survivors `user://misdeal_tactical_v22_battles.csv`; safe time cap/roster/formation checks.
- [x] **Godot 4.7.x F6 PASSED:** user screenshot shows 72/72 completed baseline BattleUnit fights (31 wins, 41 losses), no timeout. Next: obtain `user://misdeal_tactical_v22_battles.csv` to analyze by encounter, variant, party size, order; aggregate results alone do not establish balance.
- [ ] Compare solo/duo/trio and ASSAULT/HUNT/FORMATION baseline results. Inspect timeouts, unreasonably hard solo setups, and one dominant order; do not re-balance without concrete measurements or real combat feedback.
- [ ] Real Act 1 play: test all four new alternate formations, readable hints, target preview, victory/defeat, rewards, return to table; ensure D137 and boss XIII still work.
- [ ] Finish Act 1 full run gameplay/regression (Wizard Mark, Hold/Meddling/Wager and XIII), previously not exhaustively confirmed. Keep accepted DS2/Fate Spread/18 art frozen.

---

## ACTIVE — D137 Gameplay 2.1 / authored tactical encounters — 2026-10-13

- [x] User confirmed **D136 48-run F6 Gameplay 2.0 PASS** locally; real full Act 1 regression still open.
- [x] User approved tactical-first Gameplay 2.1: meaningful formation/order decisions and viable solo/duo/trio **while each battle remains true to its original card**.
- [x] Audit real `EncounterData`, `BattleUnit` targeting and existing 3+2 orders, three test-case enemy rosters/encounter cards.
- [x] Author two enemy **position-only** setups per `bone_swarm`, `iron_wall`, `grave_bell` in existing `.tres`, keeping the exact enemy unit paths, card imagery, names, rosters and arenas.
- [x] Select/memoize a random encounter layout per chosen card for the run; **retry preserves the same layout**; display the appropriate succinct formation tell using the existing placement hint.
- [x] Give solo `FORMATION` its missing defensive distinction (-10% incoming damage), without changing its duo/trio behavior or established party pressure multipliers.
- [x] Add new F6 `res://scenes/dev/tactical_gameplay_v21_smoke.tscn`: validate 54 formations/party/protagonist setups and 3 basic tactical targeting options using real unit script/resources. No claimed engine PASS or actual battle wins.
- [x] **User Godot 4.7.x F6 local QA PASSED on 2026-10-13:** screenshot `TACTICAL GAMEPLAY 2.1 — PASS`: 54 setups, 324 initial target checks, 72 HUNT vs ASSAULT differences; card roster fidelity and retry stability verified. This is NOT an end-to-end battle win-rate test.
- [ ] **Live combat QA:** do Bone Swarm, Iron Wall, Grave Bell in solo/duo/trio; compare ASSAULT/HUNT/FORMATION, target-preview accuracy, visible variant tells, ranged/healer accessibility, movement/overlaps, retreat and reward/return. Confirm that no formation makes solo unwinnable and no one default order dominates. Use actual observations before tuning.
- [ ] After verified outcomes: adapt remaining combat encounters only where preparation lacks significance. Keep 12 + XIII, enemy rosters/art, frozen DS2 and Fate Spread unchanged; no new buttons/classes/new cards.

---

## NEXT CHAT — D136 Gameplay 2.0 QA / first wave art closed — 2026-10-13

- [x] Confirm all 18 first-wave illustrated assets are approved and in GitHub (D131–D135); prior local pull conflict from older untracked D134 PNG-derived WebPs was resolved; user said «Все ок». Existing DS2 and Fate Spread Variant C are frozen.
- [x] User approved Gameplay 2.0 direction: greater deal variety, tactical interest from EXISTING authored fights, meaningful explicit stakes, contextual Wizard personality, respecting solo/duo/trio.
- [x] Inspect `main`: the initial **D136 gameplay implementation is already shipped**, with optional legal mixed combat/event two-card deals and recent-resolution preference; Wizard Mark +20/30/40 vs unchanged +15% next battle enemy damage; contextual Wizard lines; existing rules/art untouched.
- [x] Confirm committed smoke scene `res://scenes/dev/act1_gameplay_v2_smoke.tscn` and detailed next-chat plan `docs/GAMEPLAY_2_0_HANDOFF.md`.
- [ ] **NEXT IMMEDIATE STEP (not another implementation):** user `git pull`, run F6 `scenes/dev/act1_gameplay_v2_smoke.tscn` in Godot 4.7.x 1280×720, report PASS/FAIL with Output errors if needed.
- [ ] Play and verify one real Act 1 run: unconstrained mixed offers vs forced combat tiers; Mark 20/30/40 paid and next battle +15% penalty; Wizard text priorities; Meddling; Wager; Hold; reward/return; boss XIII after 12 choices.
- [ ] If actual problems arise, fetch latest `RunState`/`table.gd`/smoke code, fix with connected GitHub, commit and revise handoff. Otherwise mark D136 locally accepted and plan a second SMALL replayability/content pass after auditing remaining weak points.
- [ ] Do not redesign accepted art or invent new mechanics before discussing substantive changes with user.

## D136 — Act 1 Gameplay 2.0 replayability pass (2026-10-13)

- [x] Review current 30 authored regular cards (10/tier), encounter archetypes, tier rules, hold/meddling/wagers/marks and existing solo/duo/trio balance in GitHub before changing game rules.
- [x] Add recent-choice soft scoring and mixed combat/event two-card offers **within** legal candidate pool; preserve first noncombat beat, mandatory per-tier combat slots, 12 regular decisions and boss XIII.
- [x] Bias Wizard Meddling's same-tier/same-resolution replacement toward less repetitive eligible content without changing Wizard action counts.
- [x] Scale Wizard Mark's positive gold tradeoff to +20/+30/+40 by tier while preserving its explicitly signaled next-battle +15% enemy damage; update deal-card copy/tooltip/confirmation/memory.
- [x] Add optional contextual Wizard dialogue responding to recent battles/events and later solo/trio state while keeping existing special tell/wager precedence.
- [x] Leave all authored tactical encounter rosters, combat balance values, rewards, hero classes, approved screens and existing 18 art binaries unchanged.
- [x] Add F6 standalone regression `res://scenes/dev/act1_gameplay_v2_smoke.tscn`: 48 deterministic simulations of 12 choices across solo/duo/trio, forced combat windows, unique card selection, boss XIII and staged Mark sums.
- [ ] **Local Godot 4.7.x engine execution**: `git pull`, F6 gameplay smoke shows PASS, then play one real Act 1; check deals/Mark/Meddling/Hold/Wager/boss at 1280×720.
- [ ] If local gameplay shows problems, inspect actual current GitHub scripts and fix before further feature expansion; then tune fight/reward distributions from actual play feedback (rather than inventing more classes/mechanics).

## D135 — Complete first-wave 18/18 illustrated assets in main (2026-10-13)

- [x] User approved the last five standalone art originals: `gravedigger_shop`, `bone_swarm`, `grave_crossfire`, `candle_seller`, `last_camp`.
- [x] Ship three 448×274 card WebPs and two 1280×720 event WebPs as actual binary blobs in GitHub main (`ac860ad2`), verify all five remote files.
- [x] Wire three new `RUN_CARDS` + two new `EVENTS` mappings in `card_unification_v1.gd`, keep legacy fallbacks and do not restyle approved Shop.
- [x] Provide deterministic F6 gallery `res://scenes/dev/card_unification_final5_preview.tscn` for these five without needing to roll the encounters.
- [x] First-wave asset delivery `18/18` = D131 4 + D132 4 + D134 5 + D135 5, all art binaries on main.
- [ ] User `git pull` and Godot 4.7.x smoke at 1280×720: five F6 images, 3 live dealt cards, 2 live event backgrounds, Candle Seller/Last Camp choices and navigation, Gravedigger Shop preserved.
- [ ] If not yet done, local Godot review of the D134 5 upgrade/reward images plus complete reward behavior; asset delivery alone is NOT full runtime acceptance.
- [ ] After art smoke passes, continue the Act 1 vertical slice/replayability work without reopening approved D123–D135 art.

## Wave 1 remaining 5 candidate artworks (2026-10-13) — concept stage

- [x] Confirm previous 13 D130 illustrated art slots are binary-shipped on main; latest 5 D134 upgrade/reward screens still need local QA.
- [x] Identify the additional five original inventory IDs: `gravedigger_shop` (run/deal image ONLY), `bone_swarm`, `grave_crossfire` (run/deal combat), `candle_seller` and `last_camp` (large event backgrounds).
- [x] Prepare five precise source-backed candidate briefs in `docs/CARD_ART_WAVE1_REMAINING5_BRIEF.md`.
- [ ] Generate five genuinely distinct new standalone images (avoid replay of previously generated Knight/Ranger/Mage/Gold/Relic group).
- [ ] Obtain user visual approval; **not approved or active yet**.
- [ ] After approval commit WebPs and scoped `CardArtCatalog`/event-path mappings, preserving existing fallbacks and approved DS2 Shop screen.
- [ ] Godot review at actual game card/event size; finalize asset registry and handoff only then.

## D134 — Five hero upgrade/reward artworks delivered (2026-10-13)

- [x] User explicitly approved last individual illustrations (Knight Iron Oath, Ranger Arrowstorm, male bearded Mage Glass Heart, Gold Windfall, skeletal hand with ruby Relic Wager) and requested direct GitHub upload.
- [x] Export all five from exact accepted 1570×1002 PNG masters as 608×388 WebP without old contact-sheet cropping.
- [x] Commit five **binary WebPs** to `main` in `e3729a4a`, verify each remote blob SHA / WebP and exactly five changed paths.
- [x] Existing `CardArtCatalog` and `card_unification_v1.gd` load these automatically, preserving original art fallback and approved UI / gameplay.
- [x] Together with D131 & D132, **13 of 13 D130 approved pictured assets are now shipped to GitHub** (not equivalent to 18 of 18 early candidate inventory).
- [ ] **Local Godot QA** after `git pull`: F6 `scenes/dev/card_unification_v1_preview.tscn`, all 13 thumbnails, then live hero-upgrade and reward flows to validate new art, layout/readability and actual reward logic.
- [ ] Additional 5 original Wave 1 candidate artworks not on approved D130 image board need separate selection/approval if we decide to continue visual work.
- [ ] After successful QA prioritize Act 1 gameplay replayability/content while preserving accepted art.

## D133 completed event-art smoke / last five Wave 1 artwork prep — 2026-10-13

- [x] User accepted locally displayed four new D132 event scenes and deal-card art after the scoped visibility fix («все ок»).
- [x] Preserve D123–D132 approved layouts/art and avoid rework.
- [x] Write actionable single-subject briefs for the final 5 D130 art slots in `docs/CARD_ART_WAVE1_FINAL5_BRIEF.md`.
- [ ] Generate **five separate** large artwork masters: Knight Iron Oath, Ranger Arrowstorm, male gray-bearded Mage Glass Heart, Gold Windfall, skeletal hand grasping ruby in Relic Wager. Never reuse earlier wrong 4-event collages.
- [ ] Seek individual visual approval; export 608×388 WebP files and commit verified binary assets to mapped upgrade/reward paths.
- [ ] Review Reward/upgrade live visuals in Godot; only then mark 13/13 Wave 1 art shipped.
- [ ] Additional five originally proposed but not part of D130 picture list remain separate future candidates.

## D132 art appearance regression follow-up — 2026-10-13

- [x] Diagnose: D132 first rollout replaced full-screen event backdrops but did **not** replace the matching Fate Deal / table card thumbnails.
- [x] Use four already-shipped D132 images for both the real event backgrounds **and** corresponding live table card illustrations (center-cropped/cached, old atlas fallback).
- [x] Ease DS2 full-screen tint on four D132 event views only, without changing authored card geometry or mechanics.
- [ ] Local Godot smoke after `git pull`: confirm those four table deal cards have new illustrations and their event scenes display brighter D132 backgrounds.
- [ ] If new cards display but event scene does not, ask for screenshot/event ID and investigate actual render layer/texture loading from current GitHub.
- [ ] Keep approved 4 D131 table cards and all D123–D132 art/UI baselines frozen; five other approved artwork still outstanding.

## D132 event art batch — shipped to GitHub main 2026-10-13

- [x] User approved new standalone `curse_forge`, `black_altar`, `chained_prisoner`, `rattling_bridge` imagery and requested direct deployment.
- [x] Export exactly approved 1672×941 PNG scenes directly as 1280×720 WebP, quality 91, no low-res collage upscaling.
- [x] Upload all four **binary** WebPs to `main` in commit `1722d070`; verify every remote blob and four-file diff.
- [x] Existing event path overrides and legacy fallback already wired, preserve all gameplay/UI and D131 run cards.
- [ ] User Godot 4.7.x 1280×720 live test: Curse Forge, Black Altar, Chained Prisoner and Rattling Bridge background art visibility/readability behind DS2 cards and ability to choose/leave/continue.
- [ ] Complete remaining five **approved** D130 compositions: three standalone hero upgrade illustrations and two reward visuals. Male gray-bearded Mage and skeletal ruby hand required.
- [ ] Other five originally proposed Wave 1 targets were not shown in D130 approval; separate review needed.
- [ ] Do not extract older D130 ZIP event crops over newly tracked WebPs.

## D131 four approved card-illustration binaries — shipped 2026-10-13

- [x] Generate/source and user-approve the final distinct silhouettes for `bone_patrol`, `graveyard_ambush`, `gallows_volley`, `whispering_well` (D131).
- [x] Convert latest approved 1604×981 originals directly to 448×274 WebP and **commit four binary files into GitHub main** (commit `9d864113`).
- [x] Verify GitHub main contains the exact WebP blobs and existing RunCard texture resolver chooses them before previous atlas; no UI/gameplay edits.
- [ ] Godot 4.7.x 1280×720: inspect these four via F6 and table, legibility and missing/aliasing issues.
- [ ] Remaining nine originally pictured D130 compositions: prepare clean standalone binary assets and integrate, separate from this D131 acceptance.
- [ ] Remaining five original first-wave candidates not pictured: require visual review before authoring or deployment.
- [ ] Avoid unpacking obsolete old four cropped-image files from previous `misdeal_card_art_wave1_import.zip` over the new checked-in assets.

## D131 four fresh run-card art approvals — 2026-10-13

- [x] User approved latest four standalone full-resolution images of `bone_patrol`, `graveyard_ambush`, `gallows_volley`, `whispering_well` as the replacement standard for their blurry low-resolution D130 crops.
- [x] Lock distinct character roles, no repeated/cloned figures; Gallows Volley has three archers using bows, no guns.
- [ ] Export runtime 448x274 WebPs from four accepted PNGs without borders/labels, retain safe originals and fallbacks.
- [ ] Transfer WebP binary assets into GitHub under `assets/pixel/card_unification_v1/run/` and verify in Godot. Do not use old 13-art ZIP as final version of these four.
- [ ] Finish remaining nine D130 assets and five not shown in concept board separately; no change in their approval status.

## Wave 1 inspection convenience — 2026-10-13

- [x] Commit a standalone F6 gallery preview (scenes/dev/card_unification_v1_preview.tscn) for all 13 optional assets, displaying missing-file count without changing RunState.
- [ ] Use GitHub git pull + conversation ZIP extraction, F6 at 1280x720 and verify 13 assets without dependence on random deck offerings; review any visual repair artifacts.

## Wave 1 source art candidate delivery — 2026-10-13

- [x] Prepare first 13 WebP candidates from approved D130 concept and validate sizes/ZIP structure.
- [x] Add optional WebP override resolver + real legacy-fallback to CardArtCatalog and ActChoice.
- [x] Preserve untouched DS2 UI, previous atlases, shop/well/table/battle gameplay.
- [ ] Binary transfer to GitHub unresolved. ZIP is a conversation artifact, not committed assets: user local extraction is needed to activate the optional overrides.
- [ ] Inspect 13 resulting images in actual Godot 1280x720; specifically check reconstructed picture-in-picture corners and softness of large event artwork. If unacceptable, create new clean native-resolution originals faithful to D130.
- [ ] Complete remaining five previously planned art targets separately with new approval.

## Art direction sign-off — 2026-10-13 — approved final concept (D130)

- [x] User approved the last consolidated concept board, including reduced medieval archers in `gallows_volley`, gray-bearded male mage and skeletal hand holding ruby for `relic_wager`.
- [x] Map all **13 pictured compositions** to actual runtime art IDs in `docs/CARD_ART_UNIFICATION_WAVE1.md`; distinguish the remaining 5 unseen candidate assets.
- [ ] Preserve accessible high-resolution copy of approved concept art in GitHub or Project sources; current concept PNG is only attached to the conversation, not in repository.
- [ ] Produce 13 individually usable illustration textures matching approved board (no card frame, labels or inset previews baked into art).
- [ ] Review/approve remaining 5 Wave 1 target compositions separately, if still in scope.
- [ ] Integrate clean assets with keyed fallbacks and test at 1280x720 in Godot before declaring the **game art** shipped.

## Card Art Unification Wave 1 — inventory stage (2026-10-13)

- [x] Audited live `CardArtCatalog` selection priority, active atlas regions and non-shop event backdrop paths.
- [x] Documented 18 specific first-wave card-illustration targets and safe art replacement approach in `docs/CARD_ART_UNIFICATION_WAVE1.md`.
- [ ] Compare actual current art as a contact sheet at run-card size; choose which assets need redraw versus preservation.
- [ ] Draw/review a three-art reference sample before committing the batch; keep approved DS2 UI/screens untouched.
- [ ] Implement only approved asset replacements with fallback and verify in Godot 1280x720.
- [ ] Update visual registry and acceptance decisions after user approves changed art.

## Next milestone — 2026-10-13 — DS2 accepted, return to Act 1 gameplay

- [x] Consolidated Design System 2.0 rollout across non-shop events, hero selection, squad dossier, run-end, battle HUD and table/Wizard Wager.
- [x] User confirmed the full bulk visual pass looks good in local Godot («все хорошо»); **visual approval complete** (D129).
- [x] Preserve frozen Fate Spread Variant C, accepted Reward major-upgrade, Whispering Well and Gravedigger Shop visuals.
- [ ] Select next *gameplay/content* improvement to Act 1 after checking current deck/encounters, to make repeated runs more varied without expanding architecture prematurely.
- [ ] Functional regression coverage when practical: actual shop paid/leave and Lost Purse price, conditional event choices, selected reward grants/return, battle tactics/results. User's broad approval does not prove every branch was executed.
- [ ] Fix only reproducible defects, if any, without restarting a wholesale UI overhaul.

**Historical note:** earlier sections below saying bulk DS2 visual acceptance is "pending" are superseded by this milestone; branch-specific functional test checklists are not automatically complete.

## Bulk Design System 2.0 rollout — 2026-10-12

- [x] User explicitly authorized shipping the remaining UI as one large DS2 batch rather than requesting visual approval of each scene.
- [x] Apply DS2 event shells to all remaining non-shop shared `ActChoice` events while keeping real descriptions/disabled states/art and their existing button signals.
- [x] Apply scoped DS2 material pass to Class Select, TAB Squad Dossier, Run End, Battle HUD and Table HUD/Wizard Wager.
- [x] Preserve accepted Fate Spread, Reward, Well and Shop and existing main/intro art.
- [x] Static source audit of handlers and UI scene paths; no Godot test claimed.
- [ ] **Consolidated Godot 4.7.x 1280×720 smoke** of new multi-screen visual pass: text, alignment, missing art, different event choice count, hover, disabled, result, navigation.
- [ ] Check real Gravedigger Shop purchase/leave with sufficient/insufficient gold (previous stage's live QA is still open).
- [ ] Check battle tactical orders/target preview/fight overlays and main table wager; no gameplay regressions.
- [ ] Verify ActChoice recruitment, upgrades, one-choice and three-choice events, full-tooltips and state update correctly.
- [ ] Only after running the full flow, accept or repair observed issues (avoid speculative restyling and preserve approved art).

## DS2 production Gravedigger Shop — 2026-10-12

- [x] User approved the corrected independent F6 preview («все ок. внедряй»).
- [x] Add shop-only DS2 presenter `scripts/event/gravedigger_shop_ds2.gd` and call it from shared `act_choice.gd` only when `card_id == "gravedigger_shop"`.
- [x] Keep real `RunState.get_gravedigger_shop_price()`, actual party/extra-upgrade availability, Lost Purse consequences, existing purchase/leave/result/table handlers, and preserve complete offer tooltips.
- [x] Source diff confirms seven critical original gameplay functions unchanged.
- [ ] Godot 4.7.x 1280×720 LIVE shop smoke: all 3 texts/illustrations; price changes with Lost Purse; insufficient gold; absent party roles; limit/exhaustion.
- [ ] Confirm exactly one upgrade awarded and exact gold deduction; leaving awards nothing; resolved footer and Continue reach table.
- [ ] Fix only defects observed in live Godot, without altering unrelated `act_choice` events or approved screens.

## Gravedigger Shop F6 screenshot defect — 2026-10-12

- [x] Inspect user screenshot: static headings and detail labels absent while runtime-updated price/status text is visible.
- [x] Apply preview-only post-construction static text assignment (`f6bb46e`) and distinguish disabled/available cards.
- [ ] Validate corrected F6 scene in Godot 4.7.x at 1280×720; verify every Cyrillic heading/name/detail and both toggle states.
- [ ] Obtain visual acceptance before modifying production shop branch.

## Gravedigger Shop isolated DS2 preview — 2026-10-12

- [x] Create independent `design_system_v2_shop_preview` F6 scene + GDScript with existing role upgrade art and tabletop materials.
- [x] Simulate affordable/unaffordable gold and Mage present/absent; selection and leave are display-only.
- [ ] Review preview in Godot 4.7.x at 1280×720 and obtain user visual approval.
- [ ] After approval, migrate only `gravedigger_shop` branch in shared `act_choice` presentation, preserving actual dynamic price, Lost Purse, role restrictions, purchase grants and routing.

## DS2 event milestone — Whispering Well approved, Gravedigger Shop next (2026-10-12)

- [x] Live Whispering Well row centering, full rescue copy and disabled-gold warnings corrected in `1adc634`; user confirmed local result is good, **without a new screenshot** (D126).
- [x] Close **visual alignment QA** for the live Whispering Well; preserve accepted styling against unnecessary further passes.
- [ ] Separately verify all Whispering Well gameplay branches (blood/25g/leave, revisit upgrade/relic/refund and table return) when practical; not implicit in layout approval.
- [ ] Create **isolated F6 DS2 Gravedigger Shop preview**: three physical upgrade cards with dynamic price concepts and a leave option, using existing art and material tokens.
- [ ] Show preview at 1280×720, receive user sign-off before migrating production.
- [ ] In shared `act_choice.gd`, scope any production UI changes to `active_card.card_id == "gravedigger_shop"` so other event cards stay untouched.
- [ ] Preserve existing `RunState.get_gravedigger_shop_price()`, Lost Purse discounts/penalties, gold checks, upgrade grants and scene navigation.

## Whispering Well group-centering fix after detailed screenshot review (2026-10-12)

- [x] Recognize prior pass corrected card internals but **not** row-center alignment: `HBoxContainer` retained width constrained by previous 330px child minimums.
- [x] Set 292px button minimums before container resizing; set beginning alignment, explicit 928px row centered at x640 and deferred final bounds (`1adc634`).
- [x] Increase two-line enabled-card description space to restore hidden «МАГ ПРИСОЕДИНИТСЯ»; place disabled warning with bottom margin; top-align event narrative.
- [x] Confirm existing seven core choice/art/resolve methods unchanged.
- [ ] Local Godot 1280×720 screenshot: compare actual first/last card edges to header/footer edges, check description two lines and 0-gold warning margins.
- [ ] Test enabled coin choice and later revisit layout and actual branching; avoid further speculative pixel offsets without a screenshot.
- [ ] Keep DS2 art/backdrop, approved Reward layout and favorite Fate Spread unmodified.

## Whispering Well final alignment after live QA screenshot (2026-10-12)

- [x] Keep existing approved DS2 background, event choice illustrations, colors and three-card positions.
- [x] Align header type and three parchment title/effect/detail regions; reserve dedicated warning baseline for unavailable middle card (`c513b63`).
- [x] Render disabled copy without repeated warning; size displayed text after choice-state adjustment (`dd4b486`).
- [x] Confirm by source comparison original seven event branch/art/resolve/return handlers unchanged.
- [ ] **Local Godot screenshot QA:** test 20-gold disabled center choice and 25+-gold enabled option, check that all Russian text is visible within three cards and header, warnings do not overlap.
- [ ] Verify actual blood/coin/leave choice effects and return to table before declaring live event fully accepted; revisit branches remain outstanding.

## Whispering Well real-game header QA correction (2026-10-12)

- [x] Inspect first actual 1280×720 production screenshot: choice cards display but long story text collides with bronze header border; header obscures gold/party label.
- [x] Reposition header title/quote/story text and restore top counter draw order with GoldLabel z-index (`2a0baab`).
- [ ] Recheck live scene in Godot after `git pull`: complete story above border, visible gold/party counters, no text/card overlap in both recruit and revisit branches.
- [ ] Test blood / 25-gold / leave outcome effects, disabled insufficient-funds state and return to table; do not infer game logic from screenshot.
- [ ] Keep accepted Fate Spread and Reward art unaffected.

## DS2 production Whispering Well (2026-10-12)

- [x] User approved isolated Whispering Well three-choice event preview and authorized live migration (D125).
- [x] Update live scene's materials/background to canonical Variant C and DS2 parchment cards; retain approved original event choice artwork.
- [x] Show dynamic offers for both recruiting Mage and later revisit/extra-upgrade/relic states; preserve original action/cost/refund/route handlers exactly, confirmed by source comparison.
- [x] Show cost and disabled-reason text legibly, retain full offer tooltips and highlight choice on click.
- [ ] **Godot 4.7.x smoke:** live Whispering Well with/without 25g, recruitable Mage blood/coin/leave routes, later revisit with available/unavailable upgrades/artifacts, results and table return.
- [ ] Validate actual full-screen 1280×720 screenshot; tune only observed legibility/layout bugs, then request live event visual acceptance.
- [ ] Continue DS2 event/shop adoption only after this runtime gate; untouched Fate Spread and accepted Reward major-upgrade appearance stay frozen.

## DS2 next stage — isolated Whispering Well event (2026-10-12)

- [x] Inspect existing `whispering_well.gd` options, recruit and upgrade branches and approved event choice artwork.
- [x] Stage separate F6-only DS2 material event preview with canonical bronze/parchment aesthetic and original approved well background/choice images.
- [x] Allow harmless selection and simulate insufficient gold to demonstrate disabled choice; never touch RunState or production Well event.
- [ ] User review at 1280×720 Godot F6: visible all three choices, no clipping, hover, click, gold-disabled styling and legible Wizard line.
- [ ] Once approved, migrate the **real** Whispering Well event's visuals, keeping recruit/pay/leave and other upgrade/relic branches exactly intact.
- [ ] Then tackle other events and merchant/shop one screen at a time; full Reward flow checks remain required.

## DS2 Event screens — isolated Whispering Well preview (2026-10-12)

- [x] Inspect existing `whispering_well` scene and choice art loaders before proposing production edits.
- [x] Commit isolated F6 preview with three tactile Fate Spread-style outcome cards and harmless selection interaction.
- [ ] User `git pull`, run `res://scenes/dev/design_system_v2_event_preview.tscn` F6 at 1280×720, check Cyrillic, real art, selected focus, parchment and card alignment.
- [ ] Secure user sign-off on Event treatment before making any `scenes/event` production changes.
- [ ] Test production Reward gameplay modes (normal, upgrade chain, stake, elite) separately; do not infer from major-upgrade screenshot approval.

## DS2 live Reward visual approval — 2026-10-12

- [x] User approved **production Godot** screenshot at 1280×720 for `major_upgrade` / `РАЗВИТИЕ ОТРЯДА` with two heroes and three upgrade cards (D124).
- [x] Freeze approved visual hierarchy, parchment/bronze material treatment, illustration layout, wrapping, header and footer for this state.
- [ ] Smoke-test clicking an upgrade, then subsequent ordinary loot and correct return to table.
- [ ] Verify one-card normal loot, three-choice Death Wager, bonus upgrade and elite artifact rewards at 1280×720 for both art/text and actual reward grants.
- [ ] Once remaining reward flows pass, advance DS2 screen-by-screen to events and merchant UI, keeping the favorite Fate Spread unchanged.

## Design System 2.0: production Reward migrated (2026-10-12)

- [x] User approved reward-preview look and corrected parchment text-fit; authorized real game migration.
- [x] Apply DS2 material/bronze/parchment card chrome and Variant C visual backdrop to production `Reward` without modifying the canonical Fate Spread.
- [x] Preserve existing reward buttons, art catalogs, five reward modes and all `RunState` grant/claim/navigation paths.
- [x] Add text wrapping, dynamic effect rows and full-text tooltips for longer upgrade or artifact copy.
- [ ] **Godot 4.7.x runtime validation:** normal loot (one centered card), major upgrade followed by loot, Death Wager (three cards), bonus upgrade and elite artifacts; inspect long Cyrillic, art, button hover/click, exact reward effects and return to table.
- [ ] Fix only observed issues before considering Reward DS2 visually accepted and moving on to events/shop/battle HUD.
- [ ] Preserve original Fate Spread art and gameplay throughout.

## DS2 isolated Reward preview — text/layout acceptance follow-up (2026-10-12)

- [x] User approved DS2 reward preview art direction, materials, palette and three-card composition at 1280×720.
- [x] Fix overflowing card description labels with early wrapping, explicit sample line breaks, smaller card typography and parchment clipping (`dac4953`).
- [ ] Godot F6 screenshot recheck: all Russian text fully legible and stays within each parchment, selected/hover state works; avoid treating clipping as a replacement for text fit.
- [ ] Only after final approval, migrate the actual `scenes/reward/reward.tscn` screen without changing reward logic.

## Design System 2.0 Reward preview — local visual approval pending (2026-10-12)

- [x] Create isolated F6 reward preview scene/controller using approved Variant C tabletop image, actual reward art catalog and three representative Death Wager choices.
- [x] Add opt-in blackened-material, aged-bronze framed-card and parchment-panel \`MisdealUIKit\` helpers; no production style changes.
- [x] Make preview interaction real but harmless: hover/select/inspect feedback only, no reward grants or run-state writes.
- [ ] Godot 4.7.x at 1280×720: validate actual textures, card text, Cyrillic, hover/focus/selection, button and layout; screenshot to user.
- [ ] **User sign-off** before changing production Reward. Then migrate only Reward in a small reversible patch, with gameplay smoke.
- [ ] Continue additional screens only if approved. Favorite Fate Spread art stays untouched.

## Approved Fate Spread → Design System 2.0 (2026-10-12)

- [x] User selected the canonical Fate Spread Variant C as favorite whole-game visual reference; freeze its art/composition.
- [x] Document material grammar, provisional palette, safe migration and acceptance rules in `docs/DESIGN_SYSTEM.md` and binding decision D123.
- [x] Add opt-in color tokens in `MisdealUIKit` without touching existing screen styling.
- [ ] Create an **isolated** 1280×720 reward/event material treatment preview in Godot; use existing data/art and proper font/Cyrillic support.
- [ ] User approve screenshot before modifying any production screen.
- [ ] Migrate one approved UI screen at a time; verify interaction, contrast and no art/layout regressions.
- [ ] Keep original Fate Spread Variant C completely unchanged.

## Health bars compact gothic styling (2026-10-12)

- [x] Restyle live unit `ProgressBar` as smaller dark inset track with thin edge and subdued team-colored fill (`d744e61`).
- [x] Retain slightly wider Crypt Guard and boss-specific larger bar; unchanged combat HP logic.
- [ ] Local Godot screenshot check in Gallows Volley, Bone Swarm and boss fight: low health readability, overlapping crowd and labels, no clipped bars.

## Mage size recheck after new clean atlas (2026-10-12)

- [x] Correct Mage visual multiplier from 1.65 to 1.25 (`38831c0`); keep clean Mage art intact.
- [ ] Local battle screenshot QA alongside Ranger/Knight to confirm size and foot baseline.

## Elder Mage sprite quality repair deployed (2026-10-12)

- [x] User approved cleaner, solid elderly white-bearded Mage redraw.
- [x] Archive prior atlas (`089b9fd`) and replace production Mage WebP/Base64 (`9d72854`), verified remote equals source.
- [x] Play 6 real attack poses, retire old skipped fifth attack frame (`6ce91f9`).
- [x] Preserve user-approved Mage hero scale 1.65; Knight/Ranger unchanged.
- [ ] Review new Mage at actual 1280×720 Godot battle and F6 in all five states: no faint silhouette or cross-cell fragments, staff, boots and death.
- [ ] Continue local in-engine visual acceptance of earlier Pack 1/2 animation changes.

## Hero size adjustment after Firing Square screenshot — 2026-10-12

- [x] Increase Mage art-only factor 1.15 → 1.65 (`ab22b50`) to compensate small within-cell Mage pose.
- [ ] Confirm with new Godot 1280×720 screenshot that three heroes are comparably tall and grounded in placement and attack.

## Player trio battle sprite size pass (2026-10-12)

- [x] Hero-only art scale multipliers relative to Ranger: Knight 0.90, Ranger 1.00, Mage 1.15 (`24b3df1`).
- [x] Keep enemy/boss visual scale, battle hitboxes, stats, AI and placement unchanged; reuse animated sole grounding after final scale.
- [ ] Local Godot check: Iron Wall encounter with all three heroes at 1280×720; compare visible head/boot heights, animation states and floor contact.
- [ ] Refine only if screenshots demonstrate residual disparities; avoid shared camera/arena changes.

## Bearded Mage redraw delivered — local acceptance pending (2026-10-12)

- [x] User chose first of three concepts: older white-bearded male Mage with purple staff and robes.
- [x] Preserve old `mage.webp.b64` as `mage_archived_pre_oldbeard.webp.b64` (`4c0e94a`).
- [x] Commit new 576×480 transparent 25-pose Mage atlas to `combat_units_anim_v2/mage.webp.b64` (`3e23cc8`); remote content matched.
- [x] Use existing SpriteFrames loader without gameplay code changes.
- [ ] **Godot F6 + fight:** inspect all 5 states, staff/robe/boots, boundary scraps and attack spell alignment, death, 1280×720 scale; report visual defects before closure.
- [ ] Follow up on blue Knight and four Pack 2 roles' engine acceptance.

## Redesigned blue Knight animation integrated — local review pending (2026-10-12)

- [x] User approved visibly separated two-legged Knight in blue armor, cape and shield; authored transparent 576×480 atlas with all 25 real poses.
- [x] Archive previous flawed v2 Knight atlas at `combat_units_anim_v2/knight_archived_pre_blue.webp.b64`.
- [x] Replace production Knight sheet with approved blue version and re-enable Knight frame animation via existing SpriteFrames loader, retaining static-v4 fallback.
- [x] Offline transparency/cell/ground baseline checks passed; GitHub asset content matches approved source.
- [ ] **LOCAL Godot F6 + fight:** check Knight two boots and leg readability at actual 1280×720 size, walking grounded on blue team ring, attack/hit/death, no frame bleed, sprite orientation/scale.
- [ ] Validate all Pack 2 roles in engine; correct any animation defects found before closing animation polish.

## Pack 2 all four enemies hooked up — local acceptance gate (2026-10-12)

- [x] Approved genuine transparent 576×480 framesheets staged for Bone Thrall, Grave Bellkeeper, Crypt Guard and Bone Warden (25 used poses each).
- [x] Bone Warden atlas committed and remote content verified (`77a759d`); enabled `bone_warden` in production library with static-v4 fallback (`1238b3c`).
- [x] All four enemies now have production SpriteFrames lookup; no other roles switched.
- [ ] **Local Godot F6 acceptance:** check all 4 enemies, all 5 states, foot baseline, cropping, effects and visuals at 1280×720.
- [ ] **Live combat acceptance:** attack contact/VFX/HP/death, Bone Warden boss scale/movement/phase, enemy facing, no art clipping.
- [ ] **Knight remains static v4:** only replace after new independently readable 25-frame art and user approval.
- [ ] Fix any observed in-game issues before declaring Pack 2 final visual polish complete.

## Crypt Guard — Pack 2 integrated (2026-10-12)

- [x] User approved Crypt Guard look and 25-frame 576×480 sheet; offline asset validation: zero errors or warnings.
- [x] Upload and verify exact `crypt_guard.webp.b64` in `combat_units_anim_pack2_candidates/` (`5412b1d`).
- [x] Enable role in `unit_animation_library.gd` using existing static-v4 fallback (`fa78548`).
- [ ] Local Godot F6 and fight review: armor/shield/sword, feet, attack effects, facing, death.
- [ ] Create and approve Bone Warden genuine 25-frame atlas before activating last Pack 2 role.
- [ ] Knight remains static v4 until a readable new animation is approved.

## Grave Bellkeeper Pack 2 integration — 2026-10-12

- [x] Approved Grave Bellkeeper visual; prepared 576×480 transparent 6×5 atlas with 25 used poses, offline checks completed.
- [x] Upload `grave_bellkeeper.webp.b64` to `assets/pixel/units/combat_units_anim_pack2_candidates/` and verify exact GitHub content (commit `c28011d`).
- [x] Enable Grave Bellkeeper via production SpriteFrames library, keeping static v4 fallback (commit `9f32e4b`).
- [ ] **LOCAL GODOT F6 / BATTLE:** inspect Idle/Walk/Attack/Hit/Death, bell and chain, ground line, flip and death/targeting, against the existing v4 silhouette.
- [ ] Author, validate, approve and enable Crypt Guard and Bone Warden sheets separately. Knight stays static v4 pending redraw.

## Bone Thrall Pack 2 sheet in GitHub — local QA gate (2026-10-12)

- [x] User approved Bone Thrall 25-pose asset, transparent 576×480 grid.
- [x] Commit exact WebP Base64 candidate `assets/pixel/units/combat_units_anim_pack2_candidates/bone_thrall.webp.b64`; remote contents verified, commit `29d0725`.
- [x] Production SpriteFrames lookup for `bone_thrall` (commit `d25e471`) with static v4 fallback, only this Pack 2 role enabled.
- [ ] Run Godot F6 comparison preview and actual fight, check feet at the floor, attack/readability, death row, weapon/effects and enemy facing.
- [ ] Create / approve / import three remaining sheets: `grave_bellkeeper`, `crypt_guard`, `bone_warden`. No activation before QA.
- [ ] Keep Knight static v4 pending a leg-readable replacement.

## Bone Thrall approval and integration bridge (2026-10-12)

- [x] User approved RGBA 576x480 / 25-pose visual draft; offline alpha/pose-grid checks passed.
- [x] Generated lossless WebP/Base64 file in conversation artifact runtime; not yet present in GitHub.
- [x] Optional production lookup for Bone Thrall with static v4 fallback if candidate is missing.
- [ ] **BLOCKER:** commit `bone_thrall.webp.b64` bytes under `assets/pixel/units/combat_units_anim_pack2_candidates/`; no sheet currently exists in the GitHub path.
- [ ] Run F6 review and live BattleUnit validation in Godot 4.7.x before declaring Bone Thrall animation implemented.
- [ ] Author Bellkeeper/Guard/Warden original sheets later.

## NEXT ANIMATION ART STEP — frame production brief (2026-10-12)

- [x] Technical preparation: offline importer, Godot candidate-only validation, side-by-side F6 review; **no live models switched**.
- [x] Write per-role frame briefs and QA plan: `docs/UNIT_ANIMATION_PACK2_FRAME_BRIEFS.md`.
- [ ] Draw and approve Bone Thrall four-key-pose proof; then Bellkeeper, Guard and Warden key-pose proofs.
- [ ] Draw **four authentic 576×480 transparent spritesheets**, each with Idle4 / Walk6 / Attack6 / Hit3 / Death6 (25 authentic poses).
- [ ] Import/stage, validate and F6-review all five states for each role; reject merged legs, detached weapons, float/clipping and fake duplicate poses.
- [ ] Only after explicit approval, switch roles **one at a time** using existing animation library and static v4 fallback.
- [ ] Local Godot 4.7.x runtime/F6 acceptance still required; Knight stays static v4.

## NEXT-CHAT PRIORITY — Undead Pack 2 Stage B: prepared / awaiting real art (2026-10-12)

**Verified handoff gate:** toolchain and F6 preview committed; all four expected candidate atlas paths absent in GitHub. Next contributor should create and approve genuine role-specific sprite sheets rather than changing the production loader. No battle models were switched. See `docs/HANDOFF.md` and `docs/UNIT_ANIMATION_PACK2.md`.


- [x] **Technical preparation complete:** Python importer, candidate-only Godot validator, 1280x720 F6 side-by-side preview, staging folder README and full QA contract in GitHub.
- [x] **No live-model switch:** Knight remains static v4; Ranger/Mage/Skeleton/Bone Archer keep existing frame animation; four remaining undead keep static v4 and Stage A impact VFX.
- [x] **Context saved** in PROJECT_STATE, ROADMAP, HANDOFF, VISUAL_ASSET_REGISTRY, UNIT_ANIMATION_PACK2 and CHANGELOG. Important QA decision already captured as D121 in DECISIONS.
- [ ] **ART IS THE BLOCKER:** create four authentic transparent 576x480 pixel-art sheets, one per `bone_thrall`, `grave_bellkeeper`, `crypt_guard`, `bone_warden`, 25 distinct poses each (Idle 4 / Walk 6 / Attack 6 / Hit 3 / Death 6).
- [ ] Run `scripts/dev/import_animation_pack2_candidate.py` for each role, then F6 `res://scenes/dev/unit_animation_pack2_preview.tscn`; compare v4 with new animation frames and inspect legs, weapon and contact line. Until assets exist, F6 should show `ОЖИДАЕТ АРТ`.
- [ ] After explicit approval only, update the production animation loader with static-v4 fallback and test real battles/grounding/death. Keep Knight static until a genuinely readable replacement exists.
- [ ] Verify Godot 4.7.x F6 runtime locally (source checks alone are not enough).
## Undead Animation Pack 2 — Stage B QA gate implemented (2026-10-12)

- [x] Check GitHub and available assets: four remaining enemies have only static v4 art, not any role-specific 6×5 animated sheet.
- [x] Add offline `scripts/dev/import_animation_pack2_candidate.py` and test: real 6×5 transparent frames accepted; RGB opaque-background fake rejected; warning for unstable feet/edge bleed.
- [x] Add `scripts/dev/unit_animation_candidate_validator.gd` to inspect frames inside Godot without modifying live loader.
- [x] Add `scenes/dev/unit_animation_pack2_preview.tscn` side-by-side v4 vs prospective candidate, with Idle/Walk/Attack/Hit/Death review buttons and explicit `ОЖИДАЕТ АРТ` status.
- [x] Staging contract documented; only approved candidate art may be moved into production `SpriteFrames`.
- [ ] **GODOT F6:** inspect `unit_animation_pack2_preview.tscn` at 1280×720; without candidate files, all four panels should say `ОЖИДАЕТ АРТ`; no broken nodes or hover effects.
- [ ] **ASSET STEP:** author 25 genuinely different poses per enemy (Bone Thrall, Grave Bellkeeper, Crypt Guard, Bone Warden) with legs/weapon/ground contact obvious in 96px cells; source art isn't available yet.
- [ ] Validate candidates and stage WebP/Base64 files, review all five states in F6 at full arena scale. Reject malformed/floating frames; do not claim acceptance based solely on automatic checks.
- [ ] Upon visual approval, connect those four roles to the real combat library with static-v4 fallback and check actual targeting, movement, attack contact, corpse behavior.

## Undead Animation Pack 2 — Stage A attack accents (2026-10-12)

- [x] Confirm four enemy roles `bone_thrall`, `grave_bellkeeper`, `crypt_guard`, `bone_warden` currently have static v4 assets only; don't call wobbling/static tweens frame animation.
- [x] Implement per-role short action-contact FX with native Godot `Line2D`/Tween; no attack timing/damage change.
- [x] Connect FX at real `BattleUnit` attack trigger, not pre-hit/fake telegraph; automatically clean up ephemeral nodes.
- [x] Provide standalone F6 Godot gallery for four existing enemies and per-role effects.
- [x] Document actual shipped scope and Stage B quality gates in `docs/UNIT_ANIMATION_PACK2.md`.
- [ ] **LOCAL GATE:** `git pull`, F6 `scenes/dev/unit_undead_fx_preview.tscn`; inspect four cues at 1280×720, check UI text and node cleanup.
- [ ] Play relevant encounters with Bellkeeper, Thrall, Crypt Guard and Warden; check accents aren't too bright or too frequent, no hit timing/regression.
- [ ] **Stage B:** author *actual* distinct enemy `idle/walk/attack/hit/death` transparent frames, with clean feet/weapon/ground contact; review every row before activating roles in battle. The prior screenshot-style image cannot serve as a sprite sheet.
- [ ] Revisit Knight animation only after an acceptable leg-readable sprite sheet exists; continue using v4 static Knight until approved.

## Knight leg silhouette hotfix — static v4 fallback (2026-10-12)

- [x] Confirm on repeated user screenshots that Pack 1 animated Knight legs are not readable; vertical adjustment alone cannot fix authored silhouette.
- [x] Temporarily force **only Knight** to use the existing approved static v4 tile; all other four active Pack 1 character animations remain.
- [x] Recalibrate Knight-only static floor offset to -8px so v4 feet align with the existing combat floor ring; keep name/HP/world origin and hitboxes unchanged.
- [x] Preserve both Knight animation v1/v2 asset archives and the dev animation preview for a future redraw/rollback.
- [ ] **LOCAL GATE**: user `git pull`, check Knight leg visibility/contact/attack in Bone Swarm and Grave Crossroads; other active roles' animations unaffected.
- [ ] Before re-enabling Knight animation, **redraw and validate** all Knight sprite states with independent armored boots/clear negative space, shield moved away from legs, consistent ground contact; require real Godot screenshot approval.

## Unit floor contact visual pass — per-role offsets (2026-10-12)

- [x] Respond to user feedback: Pack 1 frame cleanup solved fragment/jitter defects but some feet still looked submerged.
- [x] Introduce per-role signed visual offsets in `BattleUnit`, including static-v4 enemy variants; animated + static sprites use one rest-position helper.
- [x] Ensure combat attack tweens, idle visuals, initialization and old static death path all respect calibrated rest positions.
- [x] Preserve world coordinates, shadow/arena layouts, collision and game balance; leave approved source art intact.
- [ ] **LOCAL VISUAL CHECK:** `git pull`, run Bone Swarm and Cemetery Ambush at placement and during actual movement/attack/death; verify boots no longer look buried, and shadow contact, HP bars and enemy flip still read correctly.
- [ ] If one archetype remains visually too low or appears to hover, tune only that role's `ROLE_FLOOR_OFFSETS` value based on new screenshot; do not move the entire arena or alter physics.

## Pack 1 animation hotfix — row-bleed, floor contact, startup jitter (2026-10-12)

- [x] Inspect source atlases; confirm detached legs from previous row in Knight Walk and smaller enemy cross-row fragments.
- [x] Generate versioned cleaned `combat_units_anim_v2` for Knight, Ranger, Mage, Skeleton and Bone Archer; align all 125 processed cells (124 active character frames) to consistent y=92 sole.
- [x] Switch SpriteFrames loader to v2, slow Idle 5→2.7 fps and Walk 9→7 fps.
- [x] Synchronize art (including attack tween return) to y=36 contact-shadow floor using actual role sprite scale.
- [x] Add randomized initial idle phase and short walk/idle hysteresis.
- [x] Verify exact GitHub payload match and frame contact-line metrics; preserve v1 rollback files.
- [ ] **LOCAL GATE**: `git pull` Godot 4.7.x, check Bone Swarm / Graveyard Ambush at start and when hitting/retreating. Confirm no extra floating Knight feet, no buried skeleton torsos and no idle strobe.
- [ ] F6 `scenes/dev/unit_animation_pack1_preview.tscn` and spot-check all 5 states for all 5 roles. Fix screenshots if any source frame remains visually malformed before proceeding to Pack 2.

## Unit Animation Pack 1 — five live frame-animated roles (2026-10-12)

- [x] Extract five generated 6×5 / 229px spritesheets to 96px transparent gameplay frames and package as GitHub-safe Base64 WebP text.
- [x] Commit `knight`, `ranger`, male `mage`, `skeleton`, `bone_archer` animation atlases.
- [x] Introduce cached `SpriteFrames` library and bind actual idle, walk, attack, hit, death animation frames to existing live `BattleUnit` Sprite2D without changing combat timing or team facing.
- [x] Skip Mage projectile-only raw attack cell, keep existing combat spell trace separate.
- [x] Add dedicated F6 animation review scene using real `AnimatedSprite2D` previews; keep static v4 fallback for missing/other roles.
- [ ] **LOCAL GATE:** F6 `res://scenes/dev/unit_animation_pack1_preview.tscn` at 1280×720. Test 5 states/5 characters, foot contact, weapon clipping, alpha, male Mage, enemy direction and Cyrillic labels.
- [ ] **GAMEPLAY GATE:** three protagonist classes; skeleton and bone archer battles; pre-fight idle/drag, movement, attack, hit, death; confirm HP bars, target changes and victory/reward flow.
- [ ] **Pack 2:** remaining role-specific assets/animation for Bone Thrall, Grave Bellkeeper, Crypt Guard and Bone Warden, after visual approval.
- [ ] After smoke tests: consider syncing damage contact to specific attack frames without altering balance, and clean frame silhouettes only where screenshots show defects.

## Design System 1.0 — Package 3 core screen pass implemented (2026-10-12)

- [x] Keep Main and Intro art intact while bringing hotspot text/focus state into shared `MisdealUIKit`.
- [x] Improve legibility of class-select instructions/rules/status and RunEnd recap copy without shifting approved layouts.
- [x] Move live Table card border states (ordinary, Boss, Wizard mark, held) into the shared component and improve quiet HUD text contrast.
- [x] Make Battle tactical selection visibly distinct for all unlocked 3–5 orders without changing logic or panel sizes.
- [x] Record the six-screen scope and exact component contracts in `docs/DESIGN_SYSTEM.md` Section 8.
- [ ] **LOCAL GATE STILL OPEN:** run Godot 4.7.x at 1280×720: Main → Intro → ClassSelect → Table → Battle → RunEnd; inspect transparency, art preservation, label clipping, card special states, 3/4/5 order highlighting, victory/defeat.
- [ ] Confirm Foundation and Components F6 previews if not previously reviewed; correct any errors or overly bright accents before any further screen polish.
- [ ] Next visual changes must be screenshot-driven and must not affect the playable vertical slice or approved art.

## Design System 1.0 — Package 2 Components implemented (2026-10-12)

- [x] Centralize exact active battle HUD panel/button styles in `MisdealUIKit`; remove local `StyleBoxFlat` duplication without redesigning the HUD.
- [x] Add reusable card surface, selected choice state, readable info/tooltip panel and opt-in native hover tooltip button.
- [x] Add separate interactive Godot Components gallery with state examples, including card selected/normal and tactical choice switching.
- [x] Document API/ownership/constraints in `docs/DESIGN_SYSTEM.md` Section 7.
- [ ] **LOCAL GATE:** `git pull`, F6 `res://scenes/dev/design_system_components_preview.tscn`: hover/pressed/disabled/selected states, Cyrillic text, styled native tooltip and no clipping at 1280×720.
- [ ] Play Main → Table → Battle to check unchanged layout/readability, all 3–5 tactical controls, cards, stakes, fight/rewards.
- [ ] **Package 3 / Screen Pass** only after preview approval, with approved art/geometry unchanged unless discussed.

## Design System 1.0 — scoped rollout (2026-10-12)

- [x] **Package 1 / Foundation:** document palette, type scale, spacing, borders, layering, readability and no-baked-HUD art rules in `docs/DESIGN_SYSTEM.md`.
- [x] Centralize new foundation constants and opt-in typography/minimum-button helpers in existing `MisdealUIKit`; preserve backwards compatibility.
- [x] Commit a standalone runnable Godot foundation specimen scene, not routed from gameplay.
- [ ] **LOCAL GATE:** run F6 on `res://scenes/dev/design_system_foundation_preview.tscn` and check 1280×720 styling, Cyrillic, no layout clipping, and no Main/Table/Battle regressions.
- [ ] **Package 2 / Components:** review unified visual states and shared Godot panel/button/card/tooltip implementation; migrate battle-local StyleBox duplication selectively.
- [ ] **Package 3 / Screen pass:** apply approved components selectively to table, battle, cards and menus while preserving the accepted visual compositions.
- [ ] Continue prior arena package-2 and local gameplay gates independently of this style-system effort.

## Current priority — Male Mage and enemy facing (2026-10-12)

- [x] Add male Mage 96×96 portrait-to-miniature cutout from approved roster, with alpha mask and lossless source archive.
- [x] Point Mage role alone at the new v4 WebP tile, retaining original atlas and safe fallback for other roles.
- [x] Face hostile miniatures toward heroes at spawn and toward their current target in combat; keep matching rim sprite oriented the same way.
- [ ] **Local Godot gate:** check Crypt Patrol, Iron Wall, Bone Warden: enemy facing before Fight and after crossing/switching targets, Mage male silhouette and transparency, HP/name overlays and completed combat.
- [ ] Continue to the remaining two arenas after validation.

## Current priority — Approved Unit Art v4 integration (2026-10-11)

- [x] Transform approved nine-character concept art into a transparent 288×288 atlas with exact 3×3 / 96px tile layout.
- [x] Integrate v4 Base64-WebP runtime art into `BattleUnit`, verify all nine visual-role indexes, cache decoded texture, preserve v3 fallback for rollback.
- [x] Archive lossless PNG sprite sheet master and checkpoint art sources in GitHub.
- [ ] **LOCAL GATE:** Godot 4.7.x screenshot in Grave Crossfire, Iron Wall, Bone Swarm and Warden to check in-game outline quality, missing pixels, transparent edges, silhouettes/weapon cropping, HP labels and attack/drag behavior.
- [ ] Optionally refine individual cutouts after screenshots. Bone Raider / Crypt Sentinel currently share archetype silhouettes.
- [ ] Resume remaining two arena arts once combat-unit readability is accepted.

## Current priority — Unit readability after arena redraw (2026-10-11)

- [x] Improve battle silhouette clarity on detailed Gothic backdrops with restrained rim contour and subtle value separation, not neon halos.
- [x] Increase only sprite presentation (heroes ~10%, enemies ~8%, boss ~5%) and relocate art/HP/name offsets without touching hitboxes or combat stats.
- [x] Widen solo/duo/trio initial party stagger across all encounter-specific placement profiles, while retaining actual legal floor regions.
- [x] Make the larger on-screen hero sprites easier to grab and drag without changing combat collision radii.
- [ ] **LOCAL GATE:** verify Grave Crossfire, Gallows Volley, Bone Swarm and Warden readability and 1/2/3-player drag plus complete fights in Godot 4.7.x; adjust if sprite/UI overlap remains.
- [ ] Return to arena package 2 only after readable miniature composition is accepted.

## Current priority — Drag-only floor UI polish (2026-10-11)

- [x] Remove persistent deployment rectangles and 3×2 decorative circles that obscured approved arena art.
- [x] Render a low-opacity glow of *real legal regions* only during hero drag; no fixed tile slots.
- [x] Suppress the additional hero placement ring while idle, preserving contact shadow/team allegiance ring.
- [ ] Validate default/drag/drop/Fight transitions on Crypt and Grave Crossfire; confirm two-pocket and split-lane variants still indicate legal areas.
- [ ] Only after visual approval, continue with the two unfinished arena background assets.

## Current priority — Battle floor grounding and tactical placement, 2026-10-11

- [x] Align all encounter spawns and combat movement with the new arena-floor plane, including boss reinforcements.
- [x] Show live engraved deployment guides linked to the actual draggable regions; hide them when combat begins.
- [x] Anchor contact shadows/rings under miniature feet and clamp preparation heroes into legal positions.
- [ ] **LOCAL GATE:** in Godot 4.7.x check solo/duo/trio, Bone Swarm, Last Bell, Iron Wall, Gallows, and Warden reinforcements for floor contact, legal drag, completed fight and tactics UI.
- [ ] Tune any specific new perspective/floor mismatch from gameplay screenshots; do not keep generating decorative baked grids.
- [ ] Complete arena art package 2 only after ground/layout acceptance.

## Current priority — Arena Redraw v2 package 1 integrated, 2026-10-11

- [x] Replace the ten approved pack-1 arena backdrops with native 1280×720 WebPs via `AuthoredBackdrop`.
- [x] Preserve the original twelve-arena v1 set for rollback and keep combat/HUD/deployment gameplay unchanged.
- [ ] Locally verify all ten backgrounds against unit contrast, deployment zones, and a completed combat.
- [ ] Generate/review and integrate remaining `firing_square` and `bone_ritual` with the same art constraints (package 2).
- [ ] Resume Act 1 solo/duo/trio balance validation after visual checks.

## Current continuation priority — 2026-10-11

- [x] Replace all 12 active battle backdrops with the unified `arena_redraw_v1` production set.
- [x] Preserve live Godot HUD, units and existing combat rules while changing arena art.
- [ ] **Next:** run several fights locally, especially Bone Swarm / Grave Crossfire / Firing Square / Bone Ritual, and check unit contrast plus usable floor.
- [ ] Fix only concrete arena/deployment mismatches found in screenshots.
- [ ] After arena validation, resume full Act 1 solo/duo/trio testing through Bone Warden.

## Current continuation priority — 2026-10-09

- [x] Freeze the accepted Fate Spread composition.
- [x] Make the final cleaned-up Variant C art the canonical full-screen normal Wizard table.
- [x] Preserve its source master and runtime WebP in GitHub.
- [x] Align live offers, Hold actions, deck/discard counts and deal/discard motion to the physical artwork.
- [ ] **Next:** local 1280×720 screenshot of the exact-art normal table; fix only concrete alignment/mask/readability defects.
- [ ] Verify the Wizard wager overlay over the exact-art normal table.
- [ ] Once accepted, resume full Act 1 vertical-slice validation (solo/duo/trio) through Bone Warden and tune only from concrete playtest failures.


# Misdeal — Roadmap

This roadmap is intentionally focused on reaching a playable vertical slice quickly.

## Phase 0 — Combat proof of concept

Status: complete

- [x] Godot project boots.
- [x] Main screen transitions into battle.
- [x] Spawn 3 heroes and 3 enemies.
- [x] Automatic target acquisition.
- [x] Automatic movement.
- [x] Automatic attacks.
- [x] HP and death.
- [x] Victory / defeat detection.
- [x] Restart encounter.
- [x] Pre-battle player unit placement.
- [x] Three pre-battle tactical orders that change hero target selection/engagement behavior without adding mid-fight micromanagement.

## Phase 1 — Tactical autobattler slice

Status: complete

Goal: make preparation meaningfully affect battle outcome.

- [x] Player can reposition party before combat.
- [x] Clear preparation phase and combat phase.
- [x] Prevent illegal placement outside the deployment zone and overlapping hero drops.
- [x] Improve combat-time unit spacing/readability with separation steering.
- [x] Move unit definitions toward data-driven Resources.
- [x] Add at least one distinct enemy behavior: Bone Archer keeps distance.
- [x] Add at least one simple unit ability or combat modifier: Mage splash damage.
- [x] Improve combat feedback enough to read hits and deaths.

## Phase 2 — First complete game loop

Status: complete

Goal: prove the Misdeal concept outside the battle sandbox.

- [x] Create cursed table scene.
- [x] Present three playable combat cards.
- [x] Choose among multiple encounter cards.
- [x] Launch combat from a card encounter.
- [x] Resolve victory/defeat back into persistent prototype run state.
- [x] Present a three-option reward choice.
- [x] Return to the table with reward effects persisted.
- [x] Add multiple playable cards and complete a three-victory sequence ending in a run result.

Target loop:

`table -> card -> combat -> reward -> table`

## Phase 3 — Build identity

- [x] Add first visible wizard host/antagonist presence at the table.
- [x] Wizard reactions and short commentary.
- [x] First active Wizard interference: two rare visible card substitutions per Act 1 run, one mid and one late.
- [x] First voluntary Wizard wager: accept +25% enemy damage on the next combat in exchange for x2 next ordinary loot, or refuse without mechanical punishment.
- [x] Wizard Memory v1: narrative-only memory of wagers, companion fates, debt-clearing, defeats/retries and greed-heavy choices with contextual table reactions.
- [x] Multiple encounter types: combat cards plus a non-combat event.
- [ ] More party archetypes.
- [x] Per-run protagonist class choice with solo start.
- [x] Hard-roguelike companion recruitment/loss through existing Act 1 cards.
- [x] Variable solo/duo/trio combat composition with visible incomplete-party compensation.
- [x] Restrict upgrade/relic offers to heroes actually recruited in the current run.
- [x] First artifacts that alter hero autobattle behavior.
- [x] First hero build-progression layer: nine role-specific upgrades with one guaranteed major choice per Act 1 tier.
- [x] Replace ordinary post-combat HP/damage reward choices with tier upgrades plus simple gold loot.
- [x] Rework Death Wager reward into gold / artifact / extra hero-upgrade choices.
- [x] Rework positive event-card stat rewards around hero upgrades, relics and build identity; retain raw stats mainly as costs/penalties.
- [x] First progression-economy balance pass: cap optional hero upgrades at 3 per run and retune Bone Warden for 4–6-upgrade builds.
- [x] Squad-status/build-inspection modal with effective stats, upgrades, relics and dynamic specialization names.
- [x] First risk/reward event card: Whispering Well.
- [x] First boss encounter: Bone Warden with an enrage phase.
- [x] Bone Warden two-phase gameplay rework with cleave and phase-two reinforcements.
- [x] Dedicated Bone Warden combat sprite, boss-card art and boss-arena treatment.
- [x] Expand the prototype run into a 12-card Act 1 plus boss.
- [x] Two-card offers with rejected cards removed from the current run.
- [x] Data-driven 24-card structural pool split into early/mid/late tiers.
- [x] Replace prototype card resolvers with real mechanics for the full 24-card Act 1 pre-boss pool.
- [x] First real recovery card: Ash Rest.
- [x] First functional shop: Gravedigger Shop.
- [x] First artifact-choice card: Curse Forge with three hero-specific artifacts.
- [x] First support enemy behavior: Grave Bellkeeper healing pulse.
- [x] First swarm encounter: Bone Crush with five Bone Thralls.
- [x] First elite encounter: Crypt Guard with guaranteed artifact reward.
- [x] Real Black Altar risk/reward event.
- [x] Real Chained Prisoner choice event.
- [x] Real Debtor Bones gamble event.
- [x] Wizard Tithe temporary-debt event with harder combat and doubled normal reward.
- [x] Late Faceless Card hidden-outcome event.
- [x] Late Blood Ledger resource-conversion event.
- [x] Source-locked Broken Crown party-wide artifact card.
- [x] Last Camp pre-boss preparation event.
- [x] Ossuary Gate mixed-archetype late combat encounter.
- [x] Rattling Bridge early traversal event.
- [x] Lost Purse greed event.
- [x] Candle Seller early micro-shop event.
- [x] Bone Tax forced payment event.
- [x] Death Wager late elite combat with enhanced reward.

## Phase 4 — Vertical slice polish

Only after the loop is fun:

- [x] First procedural visual blockout for table, cards, wizard and unit silhouettes.
- [x] Integrate first authored table, wizard, card-back and unit miniature assets.
- [x] First pixel-art combat readability redesign with larger silhouettes, ground rings and compact HP UI.
- [x] Pixel battle presentation pass with atmospheric arena decor, HUD chrome and attack motion.
- [x] Multi-arena Act 1 pass with data-driven crypt, graveyard, ossuary and Bone Warden lair families.
- [x] Replace weak procedural arena overlays with four authored pixel-art battle backdrops selected by `arena_id`.
- [x] Remove nearest-neighbor 2× arena presentation.
- [x] Package true native 1280×720 authored assets for crypt/graveyard/ossuary/warden through a repository-safe binary staging path.
- [x] Recompose live battle UI/arena toward the approved gothic pixel mockup.
- [x] Replace the procedural battle arena with the authored second-reference backdrop while keeping combat/UI layers live.
- [x] Replace the core Knight/Ranger/Mage/Skeleton/Bone Archer set with pixel sprites and scale the live unit presentation accordingly.
- [x] Complete high-detail sprite pass for all nine current combat roles: heroes, base undead, support, swarm, elite and boss.
- [x] Convert main menu, table/cards/wizard, event, reward and run-end UI to the same pixel-art language.
- [x] Rebuild the wizard table around an approved authored pixel concept while keeping live Godot HUD/cards.
- [x] Physical card-table staging pass: deck/discard zones, fate spread, dealt-card motion, fan/hover lift and choose/discard animation.
- [x] Rich procedural table-art dressing experiment rejected in local visual review and superseded.
- [x] Clean wizard-table art pass: remove procedural hands/heavy frames, retain physical deal motion with restrained deck/discard/progress dressing.
- [x] Table hierarchy polish: dim baked background cards, compact the top HUD/commentary and move the fate counter to the table edge.
- [x] Add a shared runtime gothic UI kit for main menu, Class Select, Wizard table/wager, Squad Dossier, Act 1 events, Whispering Well, Reward, Battle HUD/Last Deal and Run End while preserving live text/state.
- [ ] Locally verify the shared UI-kit pass at 1280×720 for card text margins, corner chrome, hover/disabled states and modal readability.
- [ ] Coherent visual language for table/cards/miniatures;
- [x] First lightweight combat animation/impact pass: idle motion, role-aware attack motion/tracers, hit kick and death fall/fade.
- [x] Combat presentation v2 pass: arena-integrated unit lighting/rims/shadows, hit-stop/sparks, distinct death treatment, gothic tactical HUD, Wizard battle commentary, dynamic arena atmosphere and cinematic fight start.
- [x] Unify protagonist select, all Act 1 event choices, reward/upgrade screens, fallback event cards and Wizard wager modal under the approved dark-gothic ritual UI language.
- [x] Replace temporary combat-sprite UI fallbacks with the accepted authored choice/development art for approved Development, Curse Forge and Chained Prisoner cards.
- [x] Integrate the approved full pixel-art set for all 25 active Act 1 table cards, all nine hero-development paths and six reward-state cards.
- [x] Fill the remaining generic Act 1 event choice-card art slots from the active card illustration while preserving dedicated Forge/Prisoner choice art.
- [x] Replace the rejected thumbnail-resolution card-art atlases with near-display-resolution approved-art atlases.
- [x] Polish Wizard wager and Curse Forge presentation, and replace generic relic imagery with object-centric artifact art across forge/reward surfaces.
- [x] Tighten Wizard Wager after local review: larger term art, stronger risk/reward separation, contract sigil and dedicated accept-button glow.
- [x] Fix shared event/footer overflow and Squad Dossier layering after local screenshot review; rebalance dossier portrait/stats/build columns.
- [x] Polish the shared Act 1 event-window hierarchy: framed context art, compact state chips, semantic risk/role accents and upgrade-specific choice illustrations; bring Whispering Well into the same card hierarchy.
- [x] Integrate the approved Whispering Well / Chained Prisoner card mockups: exact choice-art crops, taller art bands, semantic accents, medallion dividers and explicit disabled-state ribbons.
- [x] Add the first cross-card consequence set: Lost Purse → Gravedigger Shop, Debtor Bones → Wizard Tithe, Blood Ledger → Broken Crown.
- [x] Replace anonymous blood-rescue HP taxes with named protagonist rescue scars and surface them in effective stats / Squad Dossier.
- [x] Expand Wizard Memory for rescue scars, long solo runs and deliberate abandonment of both companions.
- [x] Add the one-battle cursed tactical order **ЖЕРТВА** as an optional follow-up to an accepted Wizard wager.
- [x] Add restrained Wizard table tells: wager-history deal cadence, pre-meddling card twitch and memory-linked card/commentary pulses.
- [x] Replace free combat retry with the one-use **ПОСЛЕДНЯЯ СДЕЛКА**: sacrifice an owned relic or take a -15 max-HP brand to retry the same fight; refusal or a later defeat ends the run.
- [ ] Locally verify the Last Deal branches: relic payment, no-relic brand payment, refusal, second defeat, boss defeat and run-end summary.
- [x] Run a static post-Last-Deal balance audit of baseline solo / duo / trio output and preserve the current fixed benchmark numbers rather than making speculative global retunes.
- [x] Split battle preparation HUD into concise encounter-threat text plus a separate run-condition block so party compensation/debt no longer collide with the card counter at 1280×720.
- [x] Turn the three rescue scars into situational Act 1 keys: Chains → Bone Tax, Road → Faceless Card, Whisper → Blood Ledger.
- [x] Add one-use **УДЕРЖАТЬ** fate control to the two-card table offer, returning the reserved card after two resolved cards.
- [x] Add two visible **ПЕЧАТЬ ВОЛШЕБНИКА** offers per run: +20 gold for accepting the marked card, with +15% enemy damage until the next combat victory.
- [ ] Locally verify fate hold return timing across tier boundaries, marked-card combat/event branches, mark + debt stacking and all three scar-key event variants.
- [x] Add encounter-specific deployment geometry for Gallows Volley, Bone Crush, Ossuary Gate and Bone Warden, including disconnected legal deployment regions.
- [x] Add compact combat-threat tags directly to Wizard-table card type lines (`РОЙ`, `ЛЕЧЕНИЕ`, `AOE`, ranged threat, phases).
- [x] Add a late **КАРТА БЕЗ ЛИЦА** reckoning that reads whole-run behavior instead of only a single earlier card.
- [ ] Locally verify the new deployment regions with solo/duo/trio parties and confirm the threat tags / Faceless reckoning fit cleanly at 1280×720.
- [x] Add three visible optional combat conditions with small gold rewards: Bellkeeper-first, stay-above-25%-HP and timed Bone Crush clear.
- [x] Add one-battle **НЕПОВИНОВЕНИЕ** after two explicit refusals of Wizard wagers/marks: -20% incoming damage, -15% own damage.
- [x] Personalize Bone Warden Phase II reinforcements from the Act 1 reckoning profile while keeping the boss's base benchmark stats fixed.
- [x] Locally verify the combat-condition / Defiance / personalized Bone Warden package at normal play level; user reported the package working. Keep edge-case retry/profile checks in the later full-run balance pass.
- [x] Implement first full-run party-size pressure pass: stronger solo baseline, transparent enemy HP/damage scaling for solo/duo, proportional support healing, and no forced combat on Act 1 card 1.
- [ ] Locally verify first forced combat, one mid fight, one late elite and Bone Warden with solo Ranger/Mage, duo and trio; retune only observed outliers.
- [x] Add live first-target intent arrows during battle preparation so hero placement and tactical orders expose their immediate targeting consequences.
- [x] Put target-intent arrows behind an explicit `ЦЕЛИ: ВКЛ/ВЫКЛ` preparation toggle; default off and remember the preference for the current app session.

- [ ] Locally verify target-intent readability on 1/2/3-hero parties and the five-enemy Death Wager without excessive visual clutter.
- [ ] Run fresh solo / duo / trio balance passes with rescue scars, event echoes and **ЖЕРТВА**, then retune only the concrete outliers.
- [x] First procedural combat SFX pass: attack/hit/death/heal/order/start/result cues.
- [ ] Authored sound replacement and battle/table music.
- [x] Skippable five-frame pixel-art comic prologue establishing the old pact and replayed-life premise;
- [ ] onboarding;
- [ ] local UI verification/polish for the new squad-status modal;
- [x] initial Act 1 combat-pacing / boss / Death Wager balance pass;
- [ ] follow-up balance pass after local solo/duo/trio recruitment runs against the fixed 700-HP Bone Warden;
- [ ] basic settings;
- [ ] save/run persistence if needed for the slice.

## Explicitly deferred

Do not prioritize these before the vertical slice works:

- large content library;
- elaborate meta progression;
- online features;
- procedural architecture for every possible future system;
- complex faction/synergy systems comparable to large auto-chess games;
- final production art.

## Art-direction follow-up

- [x] Define production visual rules in `docs/ART_DIRECTION.md`.
- [x] Add shared environment/card art-grade materials.
- [x] Apply the first pass to Wizard table, battle backdrops and Whispering Well.
- [ ] Review fresh screenshots for the first production art-direction pass and identify illustrations that still need true redraw.

## True art replacements

- [x] Replace the reused Ossuary art in **КОСТЯНАЯ ДАВКА** with the approved dedicated arena.
- [x] Replace blue deployment rectangles with subdued floor/chalk presentation and add authored two-band markings to Bone Crush.
- [ ] Locally verify the approved Bone Crush arena replacement at 1280×720 before using it as the template for the remaining arena redraws.

### Second production-art pass

- [x] Review local screenshots after the first art-grade pass and identify the strongest remaining generated-art tells.
- [x] Establish **КОСТЯНАЯ ДАВКА** as the first true redraw benchmark and approve a simpler low-detail crypt direction in chat.
- [x] Add a dedicated `bone_crush` arena id and production backdrop so the redraw does not alter other Ossuary encounters.
- [ ] Replace blue deployment-zone panels with subtle in-world floor markings based on the same legal placement rectangles.
- [x] Retune environment/card grade shadows and remove post-grade from authored table/wager art so dark-mid detail stays readable.
- [ ] Review the Bone Crush redraw locally at 1280×720 before propagating the style.
- [x] Integrate the first object-first card redraw batch: **ГРЕМУЧИЙ МОСТ**, **КОШЕЛЬ МЕРТВЕЦА** and **ШЕПЧУЩИЙ КОЛОДЕЦ**.
- [x] Correct the broad redraw integration after local quality review: 19 semantically matched card redraws now run at 224×137 source resolution with the existing approved 25-card atlas as fallback.
- [x] Finish the six remaining fallback cards: five matching 224×137 v5 redraws plus the exact object-centric Broken Crown artifact art for **СЛОМАННАЯ КОРОНА**.


### Full visual redraw rollout

- [x] First object-first card redraw batch is live: **ГРЕМУЧИЙ МОСТ**, **КОШЕЛЬ МЕРТВЕЦА**, **ШЕПЧУЩИЙ КОЛОДЕЦ**.
- [x] Replace 19 active Act 1 card illustrations with correctly mapped near-display-resolution v4 redraws; preserve unique approved fallback art for the other six.
- [x] Finish the six remaining card redraws without unrelated substitutions; all 25 active Act 1 table cards now resolve to current redraw/object-specific art.
- [x] Replace Crypt and Gallows Volley with native 1280×720 v4 arena redraws while retaining validated HD Graveyard/Ossuary/Warden and the dedicated Bone Crush benchmark.
- [x] Wire the latest native-HD Graveyard/Ossuary/Warden/Bone Crush redraws, remove post-grade darkening and floor-align Bone Crush deployment/combat.
- [x] Align Gallows Volley movement/spawn bounds to the authored stone floor and clamp unit positions immediately when combat bounds are assigned.
- [ ] Locally verify Gallows Volley retreat/separation with solo, duo and trio so ranged units never appear to move over background architecture.
- [ ] Continue any further arena replacement from native/high-resolution sources only. Thumbnail-scale full-screen arena upscaling is rejected.
- [x] Integrate the prepared v6 Wizard/table backdrop without baked live UI and reduce Wizard-wager/table dimming.
- [x] Rebuild the high-visibility remaining surfaces: Class Select portraits, Reward, Whispering Well, Curse Forge, Chained Prisoner, Black Altar and Run End now use dedicated authored v7 art while mutable values stay live.
- [ ] Continue lower-priority event/shop surfaces only where fresh local screenshots still show a meaningful visual mismatch.
- [x] Locally verify the corrected v4 cards and restored high-resolution arenas at 1280×720 before another broad visual rollout.


### V7 screen-art follow-up

- [x] Replace enlarged combat-sprite portraits on Class Select with dedicated Knight / Ranger / Mage portraits.
- [x] Replace the generic reward background with a dedicated treasure-altar scene.
- [x] Replace procedural Whispering Well and Run End backgrounds with authored full-screen scenes.
- [x] Give Curse Forge, Chained Prisoner and Black Altar dedicated full-screen event environments in the shared live-UI event scene.
- [ ] Review fresh 1280×720 screenshots before replacing any lower-priority art.


- [x] Replace the rejected low-quality main splash with the approved restrained Wizard/table redraw at native 1280×720 runtime resolution.
- [x] Add a persistent scene-transition veil and route active scene changes/reloads through it so runtime texture setup cannot expose a gray viewport frame.
- [x] Preload incoming scenes while the outgoing scene remains alive and manually swap them under an already-rendered veil, eliminating the empty SceneTree frame behind the intermittent gray flash.
- [x] Remove parse-time dependence on the `SceneTransition` autoload identifier so local `project.godot` conflicts cannot break compilation after pull.
- [ ] Locally stress-test repeated table ↔ event ↔ battle ↔ reward transitions for any remaining OS/editor-level flash.
- [ ] Locally verify table → battle, event → table, battle → reward and Last Deal reload transitions after a fresh Godot restart.

### Runtime art loading hardening

- [x] Harden v7 WebP loading against Godot import/parser timing by replacing direct new-asset preloads/ext_resources with runtime FileAccess + Image decoding.
- [ ] Confirm Class Select, Reward, Whispering Well, Curse Forge, Chained Prisoner, Black Altar and Run End all open cleanly after a fresh `git pull` and Godot restart.


### V8 secondary event-art pass

- [x] Reuse the accepted Class Select portraits in Squad Dossier instead of combat-sprite crops.
- [x] Wire dedicated V8 environments for Candle Seller, Gravedigger Shop, Blood Ledger and Faceless Card.
- [ ] Continue the remaining lower-priority generic Act 1 event screens after fresh screenshot review.


### V9 final generic-event environment pass

- [x] Integrate the final V9 generic-event environment batch for Rattling Bridge, Lost Purse, Debtor Bones, Bone Tax, Wizard Tithe, Ash Rest, Last Camp and Broken Crown.
- [x] Keep all V9 event text/state/choices live in the shared Act Choice UI and load the new WebPs through the runtime decoder.
- [x] Replace the main remaining duplicate event-thumbnail choice cards with semantic action art: Lost Purse, Debtor Bones, Wizard Tithe, Blood Ledger, Bone Tax, Ash Rest recruitment and Last Camp recruitment.
- [x] Prefer native 384×160 approved choice cells and reuse them as truthful action verbs instead of creating another broad generated-art batch.
- [ ] Review fresh local 1280×720 screenshots for targeted choice-art polish only; do not start another blanket visual redraw.


### Project continuity / source preservation

- [x] Save a durable GitHub handoff covering the current gameplay/visual state and exact next step.
- [x] Add a visual asset registry with runtime paths, version history, rejected approaches and source provenance.
- [x] Archive the final V9 generated masters at 1672×941 so future chats can recrop/re-export without recovering old chat attachments.

- [x] Replace abstract Act 1 progress with the live `РАСКЛАД СУДЬБЫ`: twelve historical card slots, sealed XIII boss, held-card area and Wizard rejected-card discard.
- [ ] Locally verify Fate Spread readability at 1280×720 after 0, 4, 8 and 12 resolved cards, including a held card and a populated rejected discard.

- [x] Bring Fate Spread closer to the approved reference with a live occult seal, fate-thread path, chapter gates, progressive XIII chains and stronger center hierarchy.
- [ ] Verify the reference-driven Fate Spread at 0/4/8/12 progress and confirm XIII chain break/reveal timing reads clearly at 1280×720.

- [x] Add physical table texture under the Fate Spread, hoverable chosen/rejected decision memory, and one-shot ritual reveals at IV/VIII/XII.
- [ ] Locally verify milestone auto-open timing after card 4/8/12 and hover-memory readability without blocking `R`/Esc close input.

- [x] Integrate the approved ornate Fate Spread reference as a dark atmospheric runtime underlay while keeping all run-state cards/counters live and data-driven.

- [x] Replace the dark full-screen Fate Spread underlay with bright top/left/right edge-art plates while keeping the center fully live.
- [ ] Locally verify that candles/metal/red cloth read clearly at 1280×720 without reducing card/title readability.

- [x] Rebuild `РАСКЛАД СУДЬБЫ` around the user-approved full reference plate, with live cards/masks aligned to its physical holders and ring.
- [ ] Local 1280×720 check: verify all I–XII live cards fully cover the baked concept cards, Hold/Discard masks hide stale concept state, and title/count masks do not expose duplicate text.

- [x] Rebuild the normal Wizard/card-selection screen around the approved Variant C oval ritual table instead of a rectangular lower UI panel.
- [x] Integrate the final approved Variant C full-table artwork as the canonical 1280×720 normal-table foundation while keeping live cards/counts/actions authoritative.
- [ ] Locally verify the exact-reference table at 1280×720: check live card coverage over the baked examples, Hold visibility, deck/discard numeric masks, hover/deal animation alignment and wager overlay readability.

## Current visual checkpoint — 2026-10-09

- [x] Freeze the approved Fate Spread composition after local screenshot verification; future changes are bug-fixes only.
- [x] Make the final cleaned-up Variant C art the canonical full-screen normal-table foundation.
- [x] Preserve the Variant C source master separately from the 1280×720 runtime WebP.
- [x] Align live two-card offers, Hold controls, Fate Spread access, deck/discard animation anchors and live counts to the approved full-screen table.
- [x] Hide the old procedural normal-table renderer / compact progress ring on the canonical table.
- [ ] **Immediate next check:** local 1280×720 screenshot of the exact-art normal table with two live offers; tune only concrete mask/position/readability defects.
- [ ] After the table screenshot is accepted, return to vertical-slice validation/balance rather than another broad art pass.


### Motion polish

- [x] Pass 1: physical table interactions — Hold stamp, chosen-card focus, rejected-card travel and discard impact feedback.
- [x] Pass 1 follow-up A: safe entry-only choice-card stagger restored for generic Act Choice and Whispering Well without commitment hooks.
- [ ] Pass 1 follow-up B: any choice-commit/result timing motion remains blocked until the entry-only patch is locally verified.
- [x] Pass 1: staged reward reveal and selected-reward confirmation beat.
- [ ] Pass 2 follow-up: attack anticipation/death settling was rolled back after a missing-unit regression; reintroduce only after local spawn/render verification.
- [x] Pass 2: Fate Spread ritual reveal/stagger and milestone emphasis without changing the frozen composition.
- [x] Pass 2: restrained Wizard wager/meddling reactions without skeletal/puppet-style animation of the painted character.
- [ ] Pass 2 local verification: confirm combat still reads fast, Fate Spread stagger does not feel slow, and backdrop reaction tints stay subtle.
- [ ] Pass 3 rework: battle controller motion was rolled back after the empty-arena regression; reintroduce only as isolated verified patches.
- [ ] Pass 3 local verification: confirm result overlays stay fast, Last Deal remains immediately readable, and battle controls never feel delayed.
- [x] Pass 4: subtle Variant C candle ambience, ritual reaction pulses, deal/deck response and destination-tinted safe scene veils.
- [x] Pass 4: staged Main Menu and Run End entry/commit motion.
- [ ] Motion cleanup: local verification and duration/intensity tuning only; avoid adding another broad animation layer before vertical-slice balance testing.
- [x] Pass 5: Class Select card reveal/commit, Intro frame settle, Squad dossier open/switch/close motion.
- [x] Battle recovery verified locally: heroes/enemies render again on the stable controller.
- [x] Safe combat-feedback pass: isolated tactical-order markers, Sacrifice/Defiance state FX, Death Wager framing and stronger source-aware hit feedback without touching battle controller/spawn.
- [ ] Combat polish follow-up: tune only intensity/readability from local screenshots; do not reintroduce async attack-windup/controller edits.


### Combat Expansion v1

- [x] Add six new combat cards, two per Act 1 tier, to increase run-to-run fight variety without extending act length.
- [x] Add fast Raider and lighter AOE Sentinel UnitData variants using existing validated combat families.
- [x] Give the new encounters distinct compositions, threat tags, preparation cues and proven deployment profiles.
- [x] Keep new combat rewards on the existing normal-loot path; Death Wager / Crypt Guard / Bone Warden special reward identities remain unchanged.
- [ ] Run several fresh Act 1 seeds and identify which new encounters feel redundant, overtuned or worth dedicated enemy/card art.
- [x] Create dedicated battle backdrops and table-card art for all six Combat Expansion v1 encounters.
- [ ] If Raider/Sentinel survive gameplay validation, create dedicated production unit silhouettes rather than keeping family-art reuse permanently.
