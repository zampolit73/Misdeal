# A1M1 — «Память замка» / Castle Memory pilot

**Status: IMPLEMENTED IN PR #45, awaiting latest native CI and local F5 review.** Direction C (story + real mechanical consequences) was chosen by the player on 2026-11-02; the player subsequently authorized implementation with «давай». This is the original pilot specification; actual branch implementation and test gates are in [A1M1 implementation and QA](A1M1_CASTLE_MEMORY_IMPLEMENTATION_QA.md). This does not authorize changes to XIII, more cards, canonical history or approved DS3 art.

## Source of truth and current foundation

- Read `AGENTS.md`, `docs/CONCEPT.md`, `docs/PROJECT_STATE.md`, `docs/ROADMAP.md`, `docs/DECISIONS.md`, `docs/ACT1_PROMISED_DAWN_STORY_BIBLE.md` and `docs/HANDOFF.md` first.
- Canon: the hero knowingly sacrificed the castle but sent an **honest** order; the Chancellor forged a promise; the Commandant later learned the truth and kept lying; the Commandant is XIII. Wizard's part in the original tragedy remains a mystery. Reveal this gradually; do not spoil XIII.
- Runtime in `main`: `scripts/core/run_state.gd` owns `event_outcomes`, `fate_choice_history`, `wizard_memory_counts`, deal/hold/mark and 12+XIII flow; `scripts/event/act_choice.gd` resolves existing event choices; `scripts/table/table.gd` shows Wizard memory on return.
- **Do not reimplement existing links:** `moon_seal` keep -> `echo_crypt` changes relic HP cost (0 vs -15), gold (40 vs 25), or listening HP (-5 vs -15); `lost_purse` -> `gravedigger_shop` alters price (30/35/45); `debtor_bones` -> `wizard_tithe` alters price (25/30/40). These are genuine existing mechanics, not new A1M1 work.
- There is already a small A1P1 Wizard commentary callback for rejected cards at resolved slots 3/7/11. Preserve its priority and avoid spam.

## Pilot goals

A short, replayable 4-card story thread using existing cards and approved art, plus an alternate clue source. The player should notice (1) a choice now affects a later interaction, (2) the Wizard explicitly remembers a relevant event, and (3) Knight/Ranger/Mage understand the same castle history through different details.

### Proposed cards

| Card | Tier/type | Existing gameplay stays | Proposed addition |
| --- | --- | --- | --- |
| `moon_seal` / «Лунная печать» | 0 / event | Keep +10, sell +30, burn damage/HP, leave; keep continues to alter Echo Crypt | One brief class-specific observation about a wax seal and the promised dawn, shown without asserting the Chancellor's guilt; optionally record `promise_heard` on actual resolution. Keep vs sell/burn remains an actual sacrifice of immediate resources for a possible future benefit. |
| `echo_crypt` / «Склеп отзвуков» | 1 / event | Original three choices, conditional free relic/HP/gold remain verbatim | On `relic` with `moon_seal=kept`, or on costly `listen` even without the seal, expose a contradiction between the promise and the military order and record `orders_conflict`. Taking `gold`/leaving does not grant it. |
| `court_of_the_mute` / «Суд безмолвных» | 1 / combat | Existing fight, sprites, target mark, loot and difficulty unchanged | **Independent alternative** to `echo_crypt`: after successful completion of the real combat card, find a court record referring to a disputed order, record `orders_conflict` once. No clue for a lost/aborted battle. Show only one short optional after-battle/return-to-table line; no reward-popup redesign. |
| `blood_ledger` / «Кровавая книга» | 2 / event | Gold -> least-developed upgrade; blood -> artifact/upgrade; erase last upgrade -> +70; Mage scar changes blood cost | **One proposed small mechanical payoff:** if `orders_conflict` is known, the ledger's existing **gold** option costs 35 rather than 40, justified by contesting a false entry. Use one authoritative `get_blood_ledger_gold_price()` in UI, affordability and resolver; no stacking/repeating. Blood and erase options, all effects, and no-clue gold price 40 are unchanged. Context text makes the reason explicit. The 5-gold difference is a balance candidate requiring QA, not a locked figure. |

This is **not a fixed four-card quest**. Random deals may omit all or some relevant cards. `court_of_the_mute` and `echo_crypt` are independent ways to reach `orders_conflict`; no forced draw, added offers or card duplicates. If neither occurs, `blood_ledger` still behaves like today's game and the final story is coherent.

### What differs by protagonist

- Knight: remembers the wording and rank of the castle garrison order.
- Ranger: recalls courier routes and why an army could not reach the castle at dawn.
- Mage: recognizes a mismatched sealing ritual or impression, without claiming the Wizard forged it.

Use **one short local variant** on the same card/event (not three new scenes or different canonical histories). Class selection remains `knight/ranger/mage` and the solo/duo/trio combat/recruitment rules stay untouched.

### Candidate example sequence (illustrative)

**Knight A:** `moon_seal` keep (+10 instead of +30) -> `echo_crypt` listen with saved seal (-5 HP rather than -15, +1.5 damage as already implemented), sees conflicting orders -> later `blood_ledger` gold choice shows 35 vs default 40, grants the same upgrade. Wizard briefly remarks on the remembered decision.

**Ranger B:** `moon_seal` sell (+30) -> `echo_crypt` take gold (+25), gains no proof -> `blood_ledger` remains 40; another run might win `court_of_the_mute` and gain independent evidence. No punishment for not drawing any specific card.

**Mage C:** no `moon_seal` drawn -> win `court_of_the_mute` -> `orders_conflict` available -> `blood_ledger` has contextual 35-gold option. Existing Mage rescue scar blood-cost behavior is unchanged.

## Implementation contract (approved and staged in PR #45)

1. Add a **small run-local** `castle_memory_facts: Dictionary` (or a typed equivalent) to `RunState`, with `record_castle_fact(fact_id, source_card_id)`, `has_castle_fact(fact_id)` and a safe one-time notification guard. Reset with `reset_run()`. Keep source id for deterministic QA; don't introduce a global singleton, metaprogression save or an elaborate narrative engine.
2. Record facts strictly from **committed outcomes** in `scripts/event/act_choice.gd` or from successful `court_of_the_mute` completion in `scripts/core/run_state.gd`. Never record from merely hovering/dealing/rejecting the card, losing combat, or opening inspector.
3. In `act_choice.gd`, add data-driven small presentation variants and a single central price getter for the ledger's gold path, shared by disabled state, caption and transaction. Do not alter the 3 existing buttons, their actual actions or the approved art.
4. Reuse `RunState`/Table's current Wizard response mechanism; **do not overwrite** higher-priority Mark, Wager, Meddling, companion loss or boss dialogue. One contextual line per fact/run; no extra autoplay sequences, audio or long overlays.
5. Prefer a tiny `scripts/story/act1_castle_memory_text.gd` containing short Russian text keyed by `fact_id` and protagonist role **if** more than a handful of variations are required. Keep runtime state in existing `RunState`; do not change `RunCardData` format or migrate current `.tres` until necessary.
6. No persistence across runs in A1M1. Any archive of discovered evidence or alternate XIII ending is a separate, future decision; the existing XIII boss and `run_end` remain untouched.

## QA acceptance

- Native Godot 4.7.x import, existing GUT suite, Table/Event/real Court Battle -> Reward -> Table, plus new targeted GUT scenario tests.
- `moon_seal=kept` vs sold/burned/left: exactly original Echo Crypt resources/HP; no second relic, no double credit, no duplicate fact.
- `echo_crypt` relic-with-seal or listen triggers fact once; gold/leave does not. Court genuine **win** triggers the same fact without seal; defeat does not. Finding both gives exactly one fact.
- Ledger preview, `RunState.gold` threshold (34/35/39/40) and resolver agree. With fact: price 35 candidate, without: 40. No breaking of blood/erase/empty-artifact/upgrade-capped/Mage-scar branches.
- Wizard message arrives once and never erases Mark, Wager, Meddling, party fate or rejected-card memory. No early spoiler of Chancellor or XIII Commandant.
- Knight/Ranger/Mage and solo/duo/trio all run. `reset_run()` clears evidence; no permanent cross-run bonus.
- Test randomized 12+XIII runs, forced fight windows, hold postponement, reject/discard, rewards, boss and restart; unchanged original deck weights.
- In genuine 1280×720 F5 check: text does not overflow cards/events, no new UI chrome or loud audio, player can notice causal link; new functionality is considered artistically accepted only after human play.

## Exclusions

No new enemies, scenes, card drawings or 13th preboss choice; no shuffled weights/forced narrative path; no bonus permanent stats, changes to equipment, rebalanced battles or redesigned XIII; no new sounds. Existing QA/audio tasks the player has already deemed closed are not prerequisites to this pilot.

## Delivery components

- **A1M1a**: run-local fact tracking + alternative Echo/Court sources + GUT.
- **A1M1b**: Ledger conditional price and readable cause/result + full economics regression.
- **A1M1c**: three protagonist memory lines + quiet Wizard callbacks + 1280×720 native/CI QA and F5 review.

After actual implementation: update `docs/PROJECT_STATE.md`, `docs/ROADMAP.md`, `docs/DECISIONS.md` for locked decisions, `docs/HANDOFF.md`, `CHANGELOG.md`, and merge with meaningful commits after Godot CI. Maintain compatibility with `main` and approved DS3.
