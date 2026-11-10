# Misdeal вЂ” current roadmap

## Living Arenas — three production pilots

Local implementation: `firing_square` (castle courtyard), `black_crossing`, `threadbare_theatre`. Local masks animate existing light, distant haze/water and heavy curtain folds behind the unchanged combat actors/HUD. Original art hashes, source geometry, tide hazards, balance and silent audio are preserved. Godot 4.7.2: 265/265 GUT tests (71,284 assertions), 327 native frames plus three resize captures; protected-floor pixel audit passes. [Implementation, measurements and F6](LIVING_ARENAS_PILOT.md). Full RELEASE is required before merge. **Do not expand to other arenas before the user's artistic review of these three pilots.**

## Echo of the Siege — artwork deployed; native QA still pending (2026-11-10)

- [x] User approved five Siege Echo paintings; current `borrowed_boots` is **new squire v2**.
- [x] Commit five source PNGs, ten card/backdrop WebPs and their hashes to main: `56c7a70d`.
- [x] Replace **only** `borrowed_boots` approved PNG and two WebPs, update manifest: `3ce01ac1`.
- [x] Confirm via GitHub commit diff that the other four event paintings were not touched by the v2 replacement.
- [ ] Actual Godot 4.7.x F6 verification of all five cards and their event backdrops.
- [ ] Validate gameplay choice/return paths and RELEASE CI for the final binary head.

Prior unchecked "binary deployment" roadmap entries below are historical and superseded. [Rollout details](ECHO_SIEGE_ART_ROLLOUT.md).


## Echo of the Siege — boots-only revision (2026-11-10)

- [x] Preserve newly user-approved `borrowed_boots` art (young half-undead squire) as immutable PNG and two size-checked WebPs.
- [x] Prepare a self-contained, checksum-verified ZIP/installer that changes only the boots image and its manifest hashes.
- [ ] Push `borrowed_boots` v2 files to `main` and verify source/output hashes; four other cards must be unchanged.
- [ ] Run updated Godot F6 card/event visual check and CI; no success claim before evidence.

[Full handoff and safe import](ECHO_SIEGE_BOOTS_V2.md).


## Echo of the Siege — art selection complete, deployment outstanding (2026-11-10)

- [x] Approve all five final event paintings, including `last_signal` option 1.
- [x] Preserve full-resolution PNG sources in Library and produce five-card WebP integration ZIP.
- [ ] Commit all five approved source PNGs, ten runtime WebPs and reproducible packer/manifest updates in GitHub.
- [ ] Run 4.7.x GUT + actual F6/natural deal UI verification; only then declare runtime released.

See [art rollout](ECHO_SIEGE_ART_ROLLOUT.md).


## Final five Act I stories вЂ” 45 ordinary cards

Five new original noncombat events, fifteen art candidates with selected finals, existing DS3 and actual choices/ordinary tier dealing. Godot 4.7.2: 260/260 Linux GUT tests (48,919 assertions), 45 native frames on Windows and Linux. [PR #98](https://github.com/zampolit73/Misdeal/pull/98) carries the required full RELEASE checks. [Effects, sources, QA and F6](ACT1_FINAL_FIVE_CARDS.md). This task explicitly delegates art selection; PR89/90/92 remain independent.


## Memory Glass вЂ” enlarged inspection

Enlarge button opens fit/native zoom with wheel, LMB drag and bounded pan. Same original art/unlocked masks; ESC returns to the unchanged memory selection before closing Table overlay. [Controls and native QA](MEMORY_VIEWER_CHRONICLE.md). RELEASE required before merge.


## Memory viewer вЂ” approved Variant3

В«РҐСЂРѕРЅРёРєР° РѕСЃРєРѕР»РєРѕРІВ» integrated in production: original glass left, framed scrolling reader right, group tabs above, four fragment buttons/page below. Reuses dossier frame; all24 unlock/mask/save/reset rules retained. [Layout, native QA and F5/F6](MEMORY_VIEWER_CHRONICLE.md). RELEASE required before merge.


## New Game вЂ” clean memory (user correction)

Confirmed main В«РќРѕРІР°СЏ РёРіСЂР°В» starts at0/24 with archived prior data. The separate dialog action В«РќРѕРІС‹Р№ Р·Р°Р±РµРі вЂ” СЃРѕС…СЂР°РЅРёС‚СЊ РІРёС‚СЂР°Р¶В» and RunEnd preserve collection. Cancel/load/startup never clear it. Local245 GUT tests and native confirmationв†’Introв†’Table0/24 pass; RELEASE required before merge. [Reset contract and QA](RUN_SAVE_SYSTEM.md).

## Run save system

New Game/Continue/Exit and ESC Save/Load/Save & Exit/Main Menu; validated versioned slot plus backup,67-field audit, safe Table/Reward checkpoints and permanent-memory rewind protection. [Architecture, field inventory and QA](RUN_SAVE_SYSTEM.md). RELEASE checks required before merge; native screenshots under docs/qa/run_save. Local user settings preserved.


## A1V2 вЂ” В«Р’РёС‚СЂР°Р¶ РџР°РјСЏС‚РёВ»

24 persistent narrative fragments, approved immutable art, real completion hooks, cap8/run, protagonist gates, modal viewer and restrained Table apertures implemented. No combat/economy/clue carryover. Local234 GUT tests and native0/7/24/ESC/pixel-preservation/restart checks pass. RELEASE CI required before merge. [Contract, trigger matrix, evidence and F6](A1V2_MEMORY_STAINED_GLASS_QA.md).


## A1V1 вЂ” СЃР»РµРґСѓСЋС‰Р°СЏ С…СѓРґРѕР¶РµСЃС‚РІРµРЅРЅР°СЏ/СЃСЋР¶РµС‚РЅР°СЏ РїСЂРѕРІРµСЂРєР° (РќР• СЂРµР°Р»РёР·РѕРІР°РЅРѕ)

- [x] РћРґРѕР±СЂРµРЅРѕ РЅР°РїСЂР°РІР»РµРЅРёРµ В«Р’РёС‚СЂР°Р¶ РџР°РјСЏС‚РёВ» Рё СЂР°Р±РѕС‡Р°СЏ СЃС‚СЂСѓРєС‚СѓСЂР° 24 (12 РѕР±С‰РёС… + 4Г—3 Р»РёС‡РЅС‹С…); СЃРѕС…СЂР°РЅС‘РЅ [СЃРїРёСЃРѕРє 24 РѕСЃРєРѕР»РєРѕРІ](ACT1_MEMORY_STAINED_GLASS_CONCEPT.md).
- [ ] РџРѕРєР°Р·Р°С‚СЊ РЅР° **СЂРµР°Р»СЊРЅРѕРј СѓС‚РІРµСЂР¶РґС‘РЅРЅРѕРј С„РѕРЅРµ** РІРёР·СѓР°Р»СЊРЅС‹Рµ РІР°СЂРёР°РЅС‚С‹ СЂР°Р·РјРµС‰РµРЅРёСЏ, РІ С‚РѕРј С‡РёСЃР»Рµ РІРѕР·РјРѕР¶РЅС‹Р№ РІРёС‚СЂР°Р¶ Р·Р° СЃРїРёРЅРѕР№ Р’РѕР»С€РµР±РЅРёРєР°; РЅРµ РјРµРЅСЏС‚СЊ СЃСѓС‰РµСЃС‚РІСѓСЋС‰РёР№ СЃС‚РѕР»/Р»РёС†Рѕ/РєР°СЂС‚С‹. РћС‚РґРµР»СЊРЅС‹Р№ РїРѕР»РЅРѕСЌРєСЂР°РЅРЅС‹Р№ РѕСЃРјРѕС‚СЂ вЂ” РІРµСЂРѕСЏС‚РЅРµРµ РґР»СЏ 24 С‡РёС‚Р°РµРјС‹С… С„СЂР°РіРјРµРЅС‚РѕРІ.
- [ ] РћС‚СЂРµРґР°РєС‚РёСЂРѕРІР°С‚СЊ СЃС†РµРЅР°СЂРёР№ РєР°Р¶РґРѕРіРѕ РѕСЃРєРѕР»РєР° РїРѕРґ С‚СЂРё Р°Р»СЊС‚РµСЂРЅР°С‚РёРІРЅС‹С… РєР»Р°СЃСЃР° РіР»Р°РІРЅРѕРіРѕ РіРµСЂРѕСЏ, СЂР°СЃРїСЂРµРґРµР»РёС‚СЊ РѕСЃРЅРѕРІРЅС‹Рµ РѕС‚РєСЂРѕРІРµРЅРёСЏ, Р·Р°С‰РёС‚РёС‚СЊ С„РёРЅР°Р»СЊРЅС‹Р№ СЃРїРѕР№Р»РµСЂ XIII.
- [ ] РЎРѕРіР»Р°СЃРѕРІР°С‚СЊ С‚СЂРёРіРіРµСЂС‹ РѕС‚РєСЂС‹С‚РёСЏ, anti-duplicate Рё СЃРѕС…СЂР°РЅРµРЅРёРµ РјРµР¶РґСѓ Р·Р°Р±РµРіР°РјРё РЅРµР·Р°РІРёСЃРёРјРѕ РѕС‚ A1M1/A1M2 run-facts.
- [ ] РўРѕР»СЊРєРѕ РїРѕСЃР»Рµ Р°СЂС‚/РґРёР·Р°Р№РЅ-РѕРґРѕР±СЂРµРЅРёСЏ вЂ” РјР°Р»РµРЅСЊРєРёР№ РѕР±СЂР°С‚РёРјС‹Р№ Godot-РїСЂРѕС‚РѕС‚РёРї. РќРµ РїСѓС‚Р°С‚СЊ СЌС‚РѕС‚ РїСѓРЅРєС‚ СЃ СЂРµР°Р»РёР·Р°С†РёРµР№ 40в†’45 РѕСЃС‚Р°РІС€РёС…СЃСЏ РїСЏС‚Рё РєР°СЂС‚.

## Completed checkpoint

- D418 Ranger-only Jack event with three choices and complete animal combat pack; [QA and local F6](D418_JACK_EVENT.md).

- D412 approved hero animation pack and D413 dossier live; D414вЂ“D417 safely integrated.
- Autonomous visual VP1вЂ“VP7: native baseline/audit, Reward modifier/readout fixes, truthful merchant/event states and full effects, RunEnd scroll containment, result-button canvas ordering, approved-art guards and complete RELEASE QA.
- 224/224 GUT,13 selector tests,52 native states, Battleв†’Rewardв†’Table and solo/duo/trio motion. [Release evidence](VISUAL_POLISH_RELEASE_QA.md), [audit](VISUAL_POLISH_AUDIT.md).

## Priorities after this delivery

1. Fix only concrete new player/native regression evidence; preserve accepted Misdeal style and mechanics.
2. Separate technical P2 cleanup for pre-existing GUT type warnings, Windows certificate/log environment and route-runner shutdown resources. These are not visual blockers or proof of a failed game route.
3. Review legacy enemy stylistic consistency as a separately approved art task. No automatic sprite repaint, balance or architecture changes.
4. Continue the existing authored content/vertical-slice backlog toward45 Act1 cards from the current40 only after validating current GitHub and release gates. New combats still require original enemies (D143); future card artwork still requires D168 options. No new three-offer mechanic or replacement of IвЂ“XII/XIII.

Detailed historical backlog/approval context is preserved in [pre-polish roadmap archive](archive/2026-11-09-pre-visual-polish/ROADMAP.md). Historical pending checkboxes are not current technical truth; reconcile them with merged code before resuming. Current constraints remain in AGENTS.md, CONCEPT.md, DECISIONS.md and DESIGN_SYSTEM.md.
