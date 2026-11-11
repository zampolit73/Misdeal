# Misdeal вЂ” current roadmap

## Cinematic Travel Scene03 — The Last Dressing Station

Own authored aftermath for `banner_seamstress`: exact approved PNG, seven depth planes, intact/stripped/ritual cloth states and one falling scrap. Real D412 party calibrated against the cot/seamstress; solo offset keeps clear of the wheel. Existing effects, saves, narration, Posthouse and original road unchanged. Native three-outcome/solo/trio/pause/skip and real Event → Travel → Table pass; full GUT288/288,72,235 assertions (19 existing warnings), selector18/18. Required final PR CI and user F6 artistic review remain authoritative. [Contract, sources and preview](TRAVEL_LAST_DRESSING_STATION.md).

## Cinematic Travel Scene02 - The Last Dawn Posthouse

Own authored location for unsent_letters, selected by a small card-to-resource catalog map. Exact approved PNG retained; only ordinary-bird removal and two distant heraldry corrections in derived layers. One skeletal pigeon with20 distinct poses; release carries one envelope and flies, read animates opened paper, passed keeps the bird with subtle shutter/lantern motion. Seven depth planes reuse V2 UI, party gait, pause, skip and router. No event effects, save fields, D412 or original road artwork changed. Native43-frame matrix,20 clean replay/free cycles and actual three-choice/save/old-route checks pass locally; final CI and user artistic review remain authoritative. [Contract and F6](TRAVEL_LAST_DAWN_POSTHOUSE.md).


## Cinematic Travel V2 - parallax and visual polish

Six independent depth planes retain PR #104 source pixels for the castle, close wall, valley and road over reconstructed occlusion plates. Local-clock gait/contact shadows/step dust, valley fog and cloth, compact serif narration, 360ms entrance and removal under the existing SceneTransition veil. No changes to story outcomes, rewards, saves, party balance or D412 atlases. Local full GUT279/279,71,900 assertions; native26-frame solo/duo/trio/pause/resize matrix and20 replay/free cycles. Final required CI and local artistic review remain authoritative. [V2 contract, evidence and F6](CINEMATIC_TRAVEL_V2.md).


## Cinematic Travel V1 — Тропа вдоль мёртвых стен

Presentation-only, skippable4s travel overlay through the existing SceneRouter after the five Siege Echo outcomes and completed victory rewards. Explicit pre-completion context; no RunState mutation/save stage/deal management. Real D412 walk sprites retain actual party roles, two original parallax layers, soft mist and restrained cloth motion. Space/Enter/ESC/button skip, pause, disabled-feature fallback, single-navigation guard. [Contract, QA and F6](CINEMATIC_TRAVEL_V1.md). Full RELEASE required before merge; update user's main project after green checks.

## Echo of the Siege — fifteen decision-specific illustrations

Player correction: each of the three choices in each of the five events now has a distinct illustration depicting its action. The prior shared image across three slots is superseded. `choices/<choice_key>.webp` maps through the existing stable choice key; 15 PNG originals/prompts and source/runtime hashes are retained. Approved cards and the five event backdrops stay intact. [Action matrix, QA and local F6](ECHO_SIEGE_CHOICE_ACTION_ART.md). Delivery [PR #102](https://github.com/zampolit73/Misdeal/pull/102), [required checks](https://github.com/zampolit73/Misdeal/pull/102/checks). Update the main user project after green RELEASE without resetting local files.

## Echo of the Siege — event choice illustration pass

Five dedicated event paintings extend the exact approved card references: bandaging seamstress, chest-closing postmaster with one skeletal pigeon, young half-undead squire fastening oversized boots, cheating quartermaster before straw soldiers, skeleton raising a cold signal basket. Source PNGs/prompts under `assets/pixel/events/final_five/sources/event_choice_v1/`; `event.webp` (448×274) appears in choices and `backdrop.webp` (1280×720) behind the existing UI. Approved `card.webp` and card source PNGs remain unchanged. Packer/manifest track separate event sources and prevent reverting backgrounds to the card scene. [Production/QA contract](ECHO_SIEGE_EVENT_ART.md). Delivery: [PR #101](https://github.com/zampolit73/Misdeal/pull/101); [required RELEASE checks](https://github.com/zampolit73/Misdeal/pull/101/checks).

## Echo of the Siege — Narrative V2

User-approved narrative implemented for all five events: undead seamstress tending a skeleton, postal clerk and one skeletal pigeon, young squire in oversized boots, quartermaster cheating straw soldiers, skeletal signal watchman. Short card hooks, compact event scenes with resident dialogue, exact Wizard lines and fifteen literary resolutions now match the approved paintings. All choice keys, numbers, gating, clues, debt and save contracts retained. Art hashes guarded; actual QA uses `scenes/dev/final_five_playtest.tscn` (F6), plus full GUT and native 45-frame capture. Delivery: [PR #100](https://github.com/zampolit73/Misdeal/pull/100); [native QA and F6](qa/echo_narrative_v2/README.md). Final-head CI is authoritative.

## Living Arenas — three production pilots

Implemented in [PR #99](https://github.com/zampolit73/Misdeal/pull/99): `firing_square` (castle courtyard), `black_crossing`, `threadbare_theatre`. Local masks animate existing light, distant haze/water and heavy curtain folds behind the unchanged combat actors/HUD. Original art hashes, source geometry, tide hazards, balance and silent audio are preserved. Godot 4.7.2: 265/265 full GUT tests; final focused 5/5 (22,365 assertions), 327 native frames plus three resize captures; protected-floor pixel audit passes. [Implementation, measurements and F6](LIVING_ARENAS_PILOT.md). [Required RELEASE checks](https://github.com/zampolit73/Misdeal/pull/99/checks) must pass before merge. Arena changes are committed; remaining unrelated local settings/imports are preserved. **Do not expand to other arenas before the user's artistic review of these three pilots.**

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
