# Act I — пять историй осады

Baseline: main `5e12bf17`, 40 ordinary cards. This branch adds five event cards, reaching45. Two offers, twelve resolutions and XIII retain their original rules. PR89/90/92 remain separate. User explicitly delegated selection of all fifteen art candidates; no individual approval gate is pending for this batch.

## Cards and outcomes

| ID / title | Tier | Situation | Choice A | Choice B | Choice C |
|---|---:|---|---|---|---|
| banner_seamstress / Знамя на бинты | 0 | A seamstress must divide the last banner between wounded and defenders | HP+12, damage−0.5 | Damage+0.75, HP−6 | Leave unchanged |
| unsent_letters / Запертая почта | 1 | Pigeons wait for permission to carry suppressed news | 10 gold: prepare existing one-battle Defiance; unavailable if already ready | Read copies: existing southern-march evidence, no money/stats | Leave unchanged |
| borrowed_boots / Чужие сапоги | 0 | Repaired boots await soldiers who never returned | 18 gold: hero movement×1.08 | Hero HP+8, movement×0.96 | Leave unchanged |
| false_weights / Неверные гири | 1 | A hollow ration weight conceals the shortfall | 12 gold: HP+16 and existing ration evidence | Gold+18, HP−6 | Leave unchanged |
| last_signal / Погасший сигнал | 2 | A signal station waits for an answer from an empty horizon | With active Wizard Debt:20 gold cancels danger and doubled future reward together | Salvage frame:22 gold | Leave unchanged |

HP/damage are existing additive party modifiers before compensation; effective final values follow existing solo/duo/trio and upgrade/relic formulas. Movement is a run-local multiplier shared by Battle and dossier. Bonuses and penalties last this run; no permanent power or fourth hero. Costs are transaction-checked, no negative wallet or repeated payment, every event has an always-available neutral choice. The new small rewards are below an ordinary20HP/3damage reward; no extra upgrade/relic slots or guaranteed recruit. Five events broaden noncombat decisions; no new enemies required by D143.

These are independent encounters, not a mandatory sequence. Existing clues receive two alternative sources; no added shard, changed collection requirement, early XIII identity, or new explanation of undead. MemoryProfile's existing source deduplication/cap observes normal successful completion.

## Art production and selection

Built-in imagegen, fifteen independently rendered compositions. References inspected: actual Jack gateway and approved Last Camp, plus existing card catalog. No prior image replaced. No UI/text painted into new illustrations. All original PNG candidates retained in [sources](../assets/pixel/events/final_five/sources/); selected originals are the following exact files:

| Card | Candidates | Selected / rationale |
|---|---|---|
| Seamstress | courtyard eye level; overhead cutting; infirmary sewing | [2](../assets/pixel/events/final_five/sources/banner_seamstress/option_2.png): scissors/banner/bandages communicate the tradeoff |
| Mail | loft shutter; rooftop release; pigeon carrier | [3](../assets/pixel/events/final_five/sources/unsent_letters/option_3.png): clearest bird/message silhouette, no crowded skyline |
| Boots | working cobbler; doorway still-life; overhead bench | [2](../assets/pixel/events/final_five/sources/borrowed_boots/option_2.png): footwear foreground and waiting master remain readable |
| Weights | queue and counter; pouring lead; low weighing view | [3](../assets/pixel/events/final_five/sources/false_weights/option_3.png): hollow weight and meager slice give a distinct conflict |
| Signal | keeper beside lens; keeper turns lens; abandoned roof | [3](../assets/pixel/events/final_five/sources/last_signal/option_3.png): open empty horizon, absent keeper, restrained reflected ember |

Prompt family: original Misdeal landscape3:2, grounded medieval dark-fantasy painterly scene, worn wood/stone/iron/cloth, muted slate-blue/brown/burgundy and localized amber illumination, asymmetrical readable silhouettes at448×274, purposeful props, correct anatomy; no text/UI/frame/ornament clutter/neon/magic. Each candidate uses the scene and camera composition in the table. No CLI/API fallback, no stock image or procedural placeholder. Source sizes1536×1024. Native Godot lossless WebP packing preserves full composition with narrow dark side margins: card448×274 and backdrop1280×720. Existing DS3 optics, frame, title/description/CTA remain live Godot nodes. Event options use the same final narrative painting and separate truthful effects.

## Existing-content comparison

Existing battle themes: patrol/ambush/crossfire/volley, bells/procession, laboratory, theatre, crossing, lantern road, mute court, gates/guard/wall/crush/swarm, ritual and death wager. New additions do not add another skeleton roster or ruin corridor. Existing event subjects: moon seal, echo crypt, camp/bridge/well recruitment, altar, prisoner, candle seller/gravedigger/forge, dice/debt/tithe, purse, blood ledger, crown and faceless card, Ranger-bound dog. New subjects are textile medicine versus morale, suppressed civil post, absent owners' footwear, ration fraud and abandoned signal duty. They reuse established bounded stat/evidence/order/debt contracts rather than adding a new subsystem. The full old resource inventory and hashes are in [baseline inventory](qa/final_five/baseline_cards.json).

## Validation

- Godot 4.7.2: Linux CI 260/260 GUT, 56 scripts, 48,919 assertions, 19 pre-existing GUT warnings. Local full suite: 259/259 before the final preservation test; final focused suite: 9/9 tests, 864 assertions. Eight integration tests include 45 real event button resolutions across solo/duo/trio, insufficient funds/existing-order/no-debt, repeats, ordinary tier deals, hold return, effect values, actual Battle movement, disk save/load of every outcome. Existing full-route audit:36/36 runs reach12+XIII,108 forced windows preserved.
- Native GPU:45 production-scene screenshots: each ordinary deal, event, all three outcomes, all three returns, unavailable state. [Manifest](qa/final_five/manifest.json). Fixture disables unrelated wager/mark/automatic milestone overlays; it samples actual ordinary offers in a non-forced slot without injecting the five table deals. F6 launcher uses explicit offers for convenient manual review.
- [Five physical cards together](qa/final_five/comparison.png). Review is native framebuffer output, not a generated UI mockup. No new enemy/animation pack is claimed or required.
- RELEASE workflow includes full GUT, existing real battles/reward routes/animation matrix, general52-state render matrix and new45-frame capture. Merge gate: full RELEASE on the final head of [PR #98](https://github.com/zampolit73/Misdeal/pull/98). The first [CI run](https://github.com/zampolit73/Misdeal/actions/runs/42782301262) passed all 260 tests and 45 new native frames but failed the strict log check on the runner's missing ALSA device. The new visual capture now explicitly uses the Dummy audio driver; error checks remain strict. Existing GUT orphan warnings and a 67-object exit warning from repeated production scene traversal remain documented, not counted as test failures. Windows root certificate diagnostic is also recorded.

## Local playtest

Open `scenes/dev/final_five_playtest.tscn`, F6: choose solo/duo/trio, wallet and debt, then a card. Click the real table offer, resolve a choice, continue, inspect Fate Spread and save/load. F5 ordinary runs deal events in their tiers; they are not guaranteed in a single run. Inspect the boots speed in dossier and in the next fight. The QA launcher does not write the player's normal save/profile.

Native reproduction: `godot --path . --script res://scripts/dev/final_five_capture.gd -- <absolute-output-dir>`.
