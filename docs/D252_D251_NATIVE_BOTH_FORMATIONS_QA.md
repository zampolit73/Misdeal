# D252 — User-native D251/D249 3v5 recorded both authored formations

Date: 2026-10-19. User video ~27.76 sec, 1920×1080 capture of actual Godot (the file title refers to Chrome/Skills, but visible content is D249 battle QA). Footage was submitted after D251 code/label improvements; private MP4 is kept only in conversation, not in the repository.

## Real native evidence

- New D251 UI is running: enemy labels are **hidden by default**, hero names and health bars remain; left formation button displays its **destination** ("ПЕРЕКРЁСТОК →" on МАРШ, "← МАРШ" on ПЕРЕКРЁСТОК). Video does NOT demonstrate toggling enemy labels ON, only their default OFF state.
- **Both formations actually run** (supersedes the previous D250 single-МАРШ limitation). First is **ПЕРЕКРЁСТОК**, visible ~12s: status `ПЕРЕКРЁСТОК · 7.8 сек · герои 3/3, враги 2/5`, light phase active and one buffed skeleton. By ~14.2s `ПЕРЕКРЁСТОК · 9.7 сек · герои 3/3, враги 0/5`, **ПОБЕДА ГЕРОЕВ**, 16 hero attacks / 6 enemy attacks.
- Then switched back to **МАРШ**, whose second real 3v5 resets with `МАРШ · 1.8 сек · герои 3/3, враги 5/5` around 16.6s, active light phase and three buffed skeletons. ~20.9s status `МАРШ · 6.1 сек · герои 3/3, враги 2/5`, light resting, zero buffed. Around 24.7s the second encounter ends `МАРШ · 9.7 сек · герои 3/3, враги 0/5`, **ПОБЕДА ГЕРОЕВ**.
- Both user-native 3v5 rounds completed without visible red QA error or crash; light's real active/rest and buff counters change. This proves *scene playback and local scope*, not actual damage/interval mathematics or entire Fate Spread route.

## Visual regression and remaining blockers

- Enemy names no longer obscure the melee. However the three heroes' default name labels can still overlap, and HP bars overlap inside melee. Remaining oversized gray **D218 geometric Guide** occupies the entire formation center and covers smaller art. These are presentation blockers, not core AI failures.
- The rich D251 Guide study still **FAILED internal ART QA**: matte fringes, flattened long-chain strikes, body scale inconsistency. It was **not** integrated in this video; this recording shows D218 original technical Guide. Do not claim the D251 Guide visually passed.
- **Both tests took 9.7s, all heroes alive.** This raises an early difficulty concern worth testing, but a QA-only 3v5 with no RunState modifiers or party configurations cannot certify difficulty/balance. Full solo/duo/trio 54-case matrix plus normal Battle→Reward→Table and 38/45 release remain open.

## Gate ledger

PASS (user-native): D249 isolated 3v5 both authored deployments, one full first victory in each, D251 enemy-name hiding/default and formation button clarity, existing D206 light phases/counter, all eight original roles visible before melee.

PENDING: enemy name toggle ON (minor QA UI), rich original Guide 25 motion poses, rich Oil Acolyte/Archer 25 poses, final multi-role readability, production Battle→Reward→Table, 54-case balance matrix, and card #38 live release. Act1 remains **37/45**; approved D209 art, D244 Sentinel/D224 Bearer, DS2, sealed XIII and KARAMBA73 unchanged.
