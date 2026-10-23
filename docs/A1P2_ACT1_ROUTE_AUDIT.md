# A1P2 — Act I Fate Spread route audit (2026-10-23)

## Scope and evidence

After the user's approval to audit the complete Act I progression, we used the **real Godot 4.7.2 `RunState`**, shipped `RunCardData` and actual encounter/scene resources. The GUT script `tests/unit/test_act1_full_route_audit.gd` drives **36 deterministic 12-card + XIII structural routes**: twelve each for solo/duo/trio, rotating Knight/Ranger/Mage protagonists. Companion recruitment to the target party size is a **QA fixture**, not an assertion that these characters will always join naturally. The script resolves each selected card via `complete_active_card()` to test progress and inspect selected resources: it **does not play battles, click event outcomes, purchase upgrades or deliver real loot**. The boss is also structurally marked complete, not fought. Existing original Battle, Reward, Table and specialist smoke tests cover separate real runtime mechanics; interactive pacing and subjective fun still need human play.

**GitHub verification:** [PR #12](https://github.com/zampolit73/Misdeal/pull/12), merged squash `c4501ee4797d4f220f50b3d7e468d09f7cf31933`; [final native CI run 39960631781](https://github.com/zampolit73/Misdeal/actions/runs/39960631781) **SUCCESS**, GUT 43/43 tests, 5,752 assertions, 8 original native smoke scripts and 3 real renderer screenshot previews. [Initial intentionally red reproduction 39960263665](https://github.com/zampolit73/Misdeal/actions/runs/39960263665) proved the real Fate-Hold bug before the implementation fix.

## Measured route breakdown

| Metric | Observed |
|---|---:|
| Structurally completed 12+XIII routes | 36 / 36 |
| Total nonboss card choices | 432 |
| Chosen combat cards | 177 (41.0%) |
| Chosen events | 255 (59.0%) |
| Two offered cards of different resolution types | 201 / 432 offers (46.5%) |
| Adjacent chosen cards with the same resolution type | 177 / 396 neighboring pairs (44.7%) |
| Verified mandatory combat slots | 108 (three per route) |
| Solo party: average combat choices per route | 5.00 |
| Duo party: average combat choices per route | 4.58 |
| Trio party: average combat choices per route | 5.17 |
| Boss XIII offered singly after position XII | 36 / 36 |

Every audited card points to a loadable shipped target resource with the correct type (combat `EncounterData`, event `PackedScene`), correct tier, two distinct offers, and no repeated chosen card IDs. Structural state transitions `choice → active card → completed card → XIII → run complete` passed. The numbers come from deterministic seeds, not a statistically representative player engagement study.

## Confirmed defect and narrow fix

**Before:** Fate Hold's noncombat event was required to return exactly two choices later; on a mandatory combat slot, it was placed into the two-card offer and could be chosen instead of battle, bypassing the authored three-combat gate. The initial red GUT reproduction explicitly failed the mandatory-combat assertion.

**After:** when a held *noncombat* event is due to return on a **forced combat** slot, it stays held for exactly one additional choice and returns on the following offer. A held combat card remains eligible on the forced slot; an ordinary held event still returns after the original two deals. `RunState._ensure_current_offers()` enforces this; Table Hold tooltip tells the player about the rare deferral. GUT `tests/unit/test_act1_fate_hold_gate.gd` checks both the collision and the unchanged ordinary two-deal behavior.

No changes to encounter stats, probability weights, deck composition, reward rules, wizard powers, approved images, Fate Spread 12+XIII, or other player controls.

## What merits further playtesting

- **Encounter rhythm:** almost 45% of sequential chosen cards had the same combat/event type. This is a **signal to review**, not proven boredom or a rationale to arbitrarily rebalance the deck.
- **Reward clarity:** scripted completion does not exercise reward selection or player decision comprehension. Check in actual runs across 1/2/3 person parties.
- **Boss XIII:** structural handoff is green, but winning or losing the actual end encounter must be experienced and assessed for difficulty/readability.
- **Manual checkpoint:** run actual F5 gameplay after `git pull`, optionally use `scenes/dev/qa_hub.tscn` (F6) for known Battle/Reward/visual paths. Specifically verify Fate Hold timing, major rewards and changes of difficulty by party composition. Do not declare the whole act human playtested on the basis of this state-level simulation.
