# Act 1 — full gameplay audit and player playtest plan (2026-11-19)

**Status:** STATIC REVIEW + TEST PLAN ONLY; full human F5 runs and new controlled gameplay measurements are **NOT YET PERFORMED**.
**Baseline:** GitHub `zampolit73/Misdeal`, `main` at `28050652819c` before this docs-only commit.
**Locked:** 24/24 accepted Act 1 event Cinematic Travel scenes; Combat Planning 1.0 / Visual V4 in shared production Battle for 22 authored encounters. Do not change art, mechanics, card pool, scaling, saves or difficulty based on this plan alone.
**Related:** [Current handoff](NEXT_CHAT_HANDOFF_2026-11-19.md), [old human F5 checklist](A1P3_LOCAL_PLAYTEST.md), [planning matched pilot](COMBAT_PLANNING_PLAYTEST.md), [historical v25 diagnostics](TACTICAL_GAMEPLAY_V25_DIAGNOSTIC_REVIEW.md), [route audit](A1P2_ACT1_ROUTE_AUDIT.md), [campaign release](COMBAT_PLANNING_ROLLOUT.md).

## 1. Static review: confirmed behavior, not playability proof

- `RunState.ACT_CARD_TARGET = 12`; three four-card tiers I–IV, V–VIII, IX–XII; one scheduled forced combat slot in each tier (first tier starts with a noncombat choice); XIII is a single mandatory `bone_warden` offer. Two ordinary offers, rejected-card record, one Fate Hold, Wizard Mark, Wager, Meddling, and Last Deal are separate test surfaces.
- Historic 36 scripted full routes (A1P2) had 177 combat / 255 event choices, ~5 nonboss fights per run, and 44.7% adjacent chosen cards of identical kind. These are structural scripted routes, NOT human measures of boredom.
- Current combat uses one to three hero orders (Assault/Defense/Hunt), timed or event fallback, explicit target/priorities, and one-wave or rare two-wave fights; Classic retains one-use Sacrifice/Defiance. `iron_wall` and `firing_square` feature wave intermissions with surviving HP; do not count each wave as another card or reward.
- Party-size scaling in `run_state.gd`: solo 2.2× hero HP, 1.9× damage, 0.8× attack interval, enemies 0.82× HP/0.80× damage; duo 1.2× HP/1.15× damage, enemies 0.92× HP/0.90× damage; trio authored baseline. Earlier **isolated** equipped Knight-led v25 samples won 24/24 solo, 0/24 duo, 2/24 trio. Investigate whether real recruitment increases difficulty; no root cause or live win rate is proven.
- Earlier **isolated** `last_bell` v25 samples yielded Hunt 4/18 vs Assault 18/18 and Formation 18/18, prior to campaign planning rollout. Retest on current main with matched conditions before discussing tactic changes. Do not equate old global Hunt with new per-hero plans.
- `bone_warden.tres`: baseline boss 700 HP, splash radius 92, enrages at half HP with stronger/faster attacks and movement; `battle.gd` adds phase-two reinforcements and Wizard line based on `RunState.get_act1_reckoning_profile()` (`witnessless`, `scarred`, `riskbound`, or default). Verify telegraph, causal link, counterplay and the only reward/end transition.
- Latest pre-plan `main` push smoke: GitHub Actions run [44596993852](https://github.com/zampolit73/Misdeal/actions/runs/44596993852) SUCCESS at `28050652`. Prior production rollout cites 313 GUT and native 22-encounter smoke; neither equals an unscripted full playable win.

## 2. Execution order and test matrix

### A — real unscripted F5 runs: **three required first-pass runs**

Use actual New Game, no QA injections, no forced recruitment, no artificial boss unlock, no injected victories. Record real outcomes including failures. Use a clean/up-to-date local `main`; check `git status`, then `git pull --ff-only origin main` only if safe. Godot 4.7.x, F5.

| Run | Protagonist | Intention / observation | Required checkpoints |
| --- | --- | --- | --- |
| A1 | Knight | Try to stay solo where choices permit; record if events change it | New Game; every I–XII resolution; each tier's real fight; XIII or exact defeat point |
| A2 | Ranger | Try natural recruitment; test Jack if offered; actual 1/2-person difficulty | Event choice and companion consequence; plan targeting; rewards and saves |
| A3 | Mage | Aim for trio if naturally offered, do not force; record if inaccessible | Mixed spells/defense; planning workload; XIII phase/ending if reached |

At I, IV, VIII, XII and XIII record party, gold, upgrades, artifacts, Wizard Debt/Mark/Wager, and elapsed time. On every slot record chosen/rejected card, type, event-vs-combat rhythm, and whether the choice felt meaningful. Verify at least one forced fight in I–IV, V–VIII and IX–XII. Check tier-first combat's major upgrade, normal loot, Travel only after event resolutions, and reward→Table. At least one run should intentionally test Fate Hold where it appears, including the collision with mandatory combat. Check Continue from a real save in a separate checkpoint without overwriting an important run. The game can defeat the player before XIII: report it honestly; restart only as a distinct run.

A4 (separate genuine failure branch): lose a real battle, review one-time Last Deal **refuse** → defeat RunEnd; another genuine failed run should test **accept** → paid cost/retry → next defeat has no second offer. Do not pretend to cover both branches on a single normal run.

### B — controlled F6 combat comparisons (not equivalent to F5 progression)

Open `scenes/dev/qa_hub.tscn` with F6, use its isolated QA profile; for `last_bell`, the dedicated `scenes/dev/combat_planning_pilot.tscn` provides the documented initial seed **31017** for matched Classic/Planning comparison. Match encounter, party, positioning, upgrades, seed **where exposed**, and change one variable at a time. QA fixtures are allowed here only.

| Encounter / arena | Variation | Question |
| --- | --- | --- |
| `last_bell` | solo / duo / trio; Classic vs per-hero target orders | Does support focus outperform default orders without suicidal exposure? |
| `ossuary_gate` | Knight solo / Knight+Ranger / full trio | Is historic solo/duo/trio inversion still present under planning? |
| `firing_square` | same party sizes; wave I and crossfire wave II | Can relocation/orders counter flank shooters? |
| `iron_wall` | solo, duo, trio; wave change with injured survivor | Are HP preservation, survivor-only plans and one reward correct? |
| `bone_crush` or `grave_bell` | one planned focus vs default | Are Wizard side objectives legible and tactically achievable? |
| `defiled_laboratory` | chosen formation/order | Does arena hazard alter decisions rather than create unclear damage? |
| `court_of_the_mute` | positioning + order editor/field view | Are deployment and Verdict understandable without hidden rings? |
| `black_lantern_road` | ranged/mixed party, positioning | Is the five-role encounter distinct and readable? |
| `bone_warden` | solo/duo/trio (controlled), varied plans | Phase 50%, reinforcements, threats, result and no duplicate reward |

For every matched pair record outcome, combat duration, surviving hero HP, first target, actual role behavior and whether the planned stage transitioned for the stated reason. For wave fights record HP before/after intermission. To infer tactic causality, repeat ambiguous cases with stable input rather than extrapolating from one run; use existing v25 diagnostics only as a historical reference.

### C — event interest, decision consequences and travel pacing

In the actual F5 runs, note whether **cost/risk before click matches the real outcome after click** (gold, recruits/scars, upgrades, debt, memory), whether the Wizard reacts coherently and whether choices are meaningfully different. Track actual length of event→approved Travel→next offer and whether skipping Travel is clear; do not re-approve art. Focus conditional routes: `chained_prisoner`, `rattling_bridge`, `whispering_well`, `black_altar`, `curse_forge`, `blood_ledger`, `bone_tax`, `jack` (Ranger), plus simple events to detect repetitive stakes. Use QA Hub for **isolated outcome correctness** not encountered naturally, clearly labelled fixture-only. No requirement to see all 24 in one real run.

### D — boss XIII and endgame gate

1. At XII→XIII confirm only one final boss offer, correct party/build/penalties, and an understandable preparation interface.
2. Fight XIII **with real AI**; verify two starting guards, readable splash warning, phase II at 50% with actual reinforcements, surviving hero HP, and no skipped/doubled transition.
3. Observe default, `witnessless`, `scarred`, and `riskbound` variants where they naturally occur; use **clearly labelled dev-only QA** for otherwise inaccessible variants. Record which prior choices seem to explain each variant.
4. On victory check one reward then RunEnd with correct 12/12 summary and New Game. On defeat check Last Deal/RunEnd rules and possible retry; check that XIII is not silently counted as ordinary slot XIV.
5. Judge boss on readable threat, distinct second-phase counterplay, duration versus previous fights, and how frequently a well-prepared run fails. Do not tune boss HP from one isolated defeat.

## 3. Recording template (manual first; no runtime telemetry change)

**Per run:** date + tested commit, run ID, protagonist, final party, cards reached/12, chosen combats/events, elapsed real time, tier boundary gold/upgrades/artifacts, boss reached/won, save/resume result, worst three friction moments, willingness to immediately start another run (1–5).

**Per fight:** card/encounter, tier, party and upgrades, layout, Classic/Plan, brief plan (each hero: tactic, priority, transition), preparation seconds, combat seconds, victory, survivors/HP, side objective, 1 expected and 1 surprising event, clarity of cause (1–5).

**Per event:** event ID, offered options, chosen consequence as advertised, actual consequence (gold/party/debt/memory), reading+Travel seconds, perceived stakes (1–5), whether skip was used, mismatch/bug if any.

**For evidence:** screenshot before pressing Begin, result and phase-II boss, RunEnd, exact stuck card/button, Godot Output errors or short video on tactical confusion. The player can return just a concise observation sheet; do not request dozens of screenshots by default. No current user-facing automatic campaign analytics is implied.

## 4. Triage, decision gates and explicit non-goals

- **P0 (fix before further full runs):** softlock, wrong Act progress, loss of save, impossible choice, Battle→Reward→Table failure, broken Last Deal/boss ending.
- **P1 (verify with matched cases):** recurring recruitment penalty/inverted party difficulty, tactics with no discernible impact, repeated virtually identical fight patterns, unreadable boss spike, seriously misleading event cost/reward, slow pacing repeated across runs.
- **P2:** optional typography/wording or minor rhythm improvements; accepted artwork not in scope.
- **First-pass completion:** 3 genuine F5 runs attempted and fully logged up to actual win/defeat; mandatory gates and one XIII win/defeat route witnessed if reachable, A4 Last Deal branches when practical, B controlled encounter matrix sampled, no unresolved P0, issues have reproduction and supporting evidence. If no real XIII reached, do **not** label full-playthrough PASS.
- **Balance confidence:** three runs are exploratory and too few to estimate true win rates. If any tactical or party-size disparity persists, extend to at least **12 additional independent real runs** across protagonists plus focused matched comparisons before changing production multipliers or rewriting AI; number is an initial design-review sample, not a statistical guarantee.
- **Product signal:** score 1–5 for understanding of offers/tactics, meaningful decisions, encounter variety, pace and boss excitement. Collect comments and exact decisions rather than treating average score alone as proof.
- **No gameplay changes authorized by this audit plan.** Prioritize the smallest data/UX intervention only after actual observations and player authorization. Preserve all approved 24 Travel scenes, 22 encounters, Visual V4, C3 heroes, narrative foundation, save contract and one-boss structure.

## 5. Handoff

**Next action:** perform A1 real Knight F5 run from New Game, logging the chosen/rejected I–XII cards and each live fight. Then compare key anomalies with B, run A2/A3, and review XIII. Findings go into a dated QA result doc with `observed` vs `hypothesis` separated. Only then propose specific patches, tests and a minimal authorized release.
