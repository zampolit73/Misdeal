# Misdeal вЂ” current project state

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

## Echo of the Siege — live runtime assets on main (2026-11-10)

**Deployment verified via GitHub:** [56c7a70d](https://github.com/zampolit73/Misdeal/commit/56c7a70d) committed 5 approved source PNGs + 10 runtime WebPs + manifest. The user's second successful [3ce01ac1](https://github.com/zampolit73/Misdeal/commit/3ce01ac1) changed **only** `borrowed_boots`: new user-supplied partly undead squire fitting oversized boots (source PNG SHA256 `2ec39769890b2229255b62d46e7585186cf23b31b1c63a1da0c064c39f66d519`), card WebP and backdrop WebP, plus manifest hashes. The other four paintings were preserved. **Five/five artwork deployment complete.** No changes to cards' event outcomes, DS3, save, balance. Earlier "pending import" sections below are historical, overridden by this entry. Native Godot 4.7 F6 and RELEASE CI for this exact binary revision **remain unverified**. User's original Godot checkout has substantial uncommitted Living Arenas work, so use separate `Misdeal-Echo-Siege` worktree at latest `origin/main` for safe visual QA. See [visual rollout](ECHO_SIEGE_ART_ROLLOUT.md) and [boots update](ECHO_SIEGE_BOOTS_V2.md).


## Echo of the Siege — new final Borrowed Boots v2, rollout pending (2026-11-10)

Live GitHub `main` now already contains the prior first batch of five Echo of the Siege illustrations. User has **replaced only `borrowed_boots`** with a 1280×853 illustration of a young partly undead squire dressing in oversized boots. Full-resolution image and derived 448×274/1280×720 game WebPs are verified and persisted with a safe single-card patch ZIP. **This replacement has not yet been pushed to `main`**, whereas the other four already-approved scenes remain in place. Updated art source SHA256 `2ec39769890b2229255b62d46e7585186cf23b31b1c63a1da0c064c39f66d519`. See [ECHO_SIEGE_BOOTS_V2.md](ECHO_SIEGE_BOOTS_V2.md). Other effects, DS3 and save contracts are unchanged.


## Echo of the Siege — safe importer and asset pipeline prepared (2026-11-10)

`scripts/dev/install_echo_siege_art.ps1` now validates user-approved source PNG SHA256 and WebP SHA256 against the packaged manifest, copies exactly five approved sources and ten derived runtime assets, and records `manifest.approved_sources` during import. `scripts/dev/pack_final_five_assets.gd` recognizes those approved originals and never reverts them to previous option numbers once installed. **Files have not yet been imported to GitHub and Godot native QA remains pending.** The conversation ZIP is downloadable, and importing requires a local invocation because the connected GitHub text/object actions do not accept these binary files directly. See [ECHO_SIEGE_ART_ROLLOUT.md](ECHO_SIEGE_ART_ROLLOUT.md).


## Echo of the Siege — all five visuals approved; integration pending (2026-11-10)

Five user-approved art sources are preserved in Library /Misdeal/approved_art/; final `last_signal` option 1 has an undead watchman with an unlit signal brazier on a moonlit battlement. A five-PNG / ten-WebP 448x274 + 1280x720 ready-to-integrate ZIP has been produced in the project conversation. **These runtime images have NOT been committed to GitHub or verified in native Godot.** The old event candidate selection manifest/packer would overwrite new artwork if run unchanged. Exact SHA256/image constraints and safe integration checklist: [ECHO_SIEGE_ART_ROLLOUT.md](ECHO_SIEGE_ART_ROLLOUT.md). Keep gameplay effects/DS3/save unchanged.


## Echo of the Siege — visual approval status (2026-11-10)

**4/5 new illustrations explicitly approved; not yet integrated into runtime WebP.** Confirmed final sources for `banner_seamstress`, `unsent_letters`, `borrowed_boots`, `false_weights` in user's Library at `/Misdeal/approved_art/` and exact SHA256/compositions in [DECISIONS.md](DECISIONS.md). Most recent `false_weights`: undead keeper deceitfully weighs stones against grain before **empty-headed soldier scarecrows**, with exact gold ring/cross shaft on burgundy banner. Last illustration awaiting approval: `last_signal` («Погасший сигнал»). Once approved, batch-integration of all five should preserve existing events, choices, balance, DS3, rollback assets and native F6 QA. See [HANDOFF.md](HANDOFF.md).


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


## A1V1 вЂ” В«Р’РёС‚СЂР°Р¶ РџР°РјСЏС‚РёВ» (2026-11-10, narrative design only)

РџРѕР»СЊР·РѕРІР°С‚РµР»СЊ РїРѕР»РѕР¶РёС‚РµР»СЊРЅРѕ РїСЂРёРЅСЏР» РєРѕРЅС†РµРїС‚ РїРѕСЃС‚РѕСЏРЅРЅРѕРіРѕ СЃСЋР¶РµС‚РЅРѕРіРѕ РІРёС‚СЂР°Р¶Р° РЅР° **24** С„СЂР°РіРјРµРЅС‚Р°: 12 РѕР±С‰РёС…, РїРѕ4 Knight/Ranger/Mage; РЅРµ РІСЃРµ Р·Р° РѕРґРёРЅ Р·Р°С…РѕРґ, РёСЃС‚РѕСЂРёСЏ Р·Р°РјРєР° С‡РµСЂРµР· РїСЂРѕС‚РёРІРѕСЂРµС‡РёРІС‹Рµ СЃРІРёРґРµС‚РµР»СЊСЃС‚РІР°. РџРѕР»РЅС‹Р№ СЃРїРёСЃРѕРє/РіРµР№С‚С‹/РіСЂР°РЅРёС†С‹: [РєРѕРЅС†РµРїС‚](ACT1_MEMORY_STAINED_GLASS_CONCEPT.md). **РќРµС‚ РёР·РјРµРЅРµРЅРёР№ gameplay, СЃС†РµРЅС‹, 24 РєР°СЂС‚РёРЅРѕРє, save-СЃР»РѕСЏ, UI РёР»Рё РїРѕРґС‚РІРµСЂР¶РґС‘РЅРЅРѕРіРѕ РјРµСЃС‚Р° Р·Р° СЃРїРёРЅРѕР№ Р’РѕР»С€РµР±РЅРёРєР°**. РџСЂРµРґР»РѕР¶РµРЅРёРµ РїРѕР»СЊР·РѕРІР°С‚РµР»СЏ В«Р·Р° СЃРїРёРЅРѕР№В» РїРѕРєР° РІРёР·СѓР°Р»СЊРЅС‹Р№ РєР°РЅРґРёРґР°С‚, С‚СЂРµР±СѓРµС‚ РјР°РєРµС‚Р° РЅР° СЂРµР°Р»СЊРЅРѕРј СѓС‚РІРµСЂР¶РґС‘РЅРЅРѕРј С„РѕРЅРµ Рё СЃРѕРіР»Р°СЃРѕРІР°РЅРёСЏ. РћСЃРЅРѕРІРЅРѕР№ С‚РµРєСѓС‰РёР№ С‚РµС…РЅРёС‡РµСЃРєРёР№ baseline вЂ” D418 РЅРёР¶Рµ, 40/45 РєР°СЂС‚.

Delivery: [PR88](https://github.com/zampolit73/Misdeal/pull/88) В· [final-head RELEASE checks](https://github.com/zampolit73/Misdeal/pull/88/checks).

## D418 вЂ” Jack event

User chose gateway art option1. Added Ranger-only Tier1 event with exactly three outcomes:25 gold в†’ real animal companion, pass unchanged, or token в†’ Ranger damage+10% for this run.40/45 ordinary cards; hero count/compensation,12+XIII, approved heroes and old mechanics preserved. Complete25-pose dog, actual native event/combat/choice/wave evidence and regression tests. [Behavior, assets, QA and F6](D418_JACK_EVENT.md). Final PR RELEASE CI must pass before merge; native F6 launcher `scenes/dev/jack_event_playtest.tscn`. Earlier VP1вЂ“VP7 release below remains merged at d49d51a1.

Delivery: [PR87](https://github.com/zampolit73/Misdeal/pull/87) В· [final-head CI checks](https://github.com/zampolit73/Misdeal/pull/87/checks). Merge requires successful full RELEASE; current check conclusion is authoritative.

## Visual polish delivery вЂ” 2026-11-09

D414вЂ“D417 are merged: [#83](https://github.com/zampolit73/Misdeal/pull/83),[#84](https://github.com/zampolit73/Misdeal/pull/84),[#85](https://github.com/zampolit73/Misdeal/pull/85),[#86](https://github.com/zampolit73/Misdeal/pull/86). Integration baseline `d9613298` includes all four; final-head CI for integrated D414: [42596022608](https://github.com/zampolit73/Misdeal/actions/runs/42596022608). Merge order84в†’85в†’86в†’83 preserved ancestry and combined dossier/motion hooks; documentation conflicts resolved, no force push/reset.

The autonomous VP1вЂ“VP7 program implements concrete native-audit repairs: both Reward modifiers fit the painted strip; full original descriptions open via RMB/F with keyboard scrolling and correct modal focus; Reward/Shop reuse D416's exact clean tabletop and truthful passive counters; merchant pictures follow actual offered upgrades, full tradeoffs and resolved states are readable; long story choices fit without hiding penalties; RunEnd summaries scroll within their panel; the existing Battle victory action now draws above its scrim, at unchanged coordinates. No approved source artwork, D412 poses, mechanics, economy, card counts or timings changed.

Validation: Godot4.7.2 **224/224 GUT**,51 scripts,47,268 assertions;13/13 QA-selector tests. Native baseline48 states and final52-state matrix, identical seeded fixtures and explicit source SHAs. Actual ordinary Court Battleв†’Rewardв†’Table PASS (39/45 content); solo/duo/trio RELEASE motion and75 Court source poses PASS.20 critical approved image sources are guarded by decoded SHA256, with all original D412 pose/source regressions intact. Final PR CI includes complete RELEASE mode and full matrix; see [release QA](VISUAL_POLISH_RELEASE_QA.md) for verified run/PR links and limitations.

[Audit](VISUAL_POLISH_AUDIT.md) В· [before/after](qa/visual_polish/compare.html) В· [current handoff](HANDOFF.md) В· [current roadmap](ROADMAP.md). No confirmed in-scope P0/P1 remains in inspected states. No human full F5 playthrough claimed; existing19 GUT type warnings, Windows certificate-store diagnostic and route-runner shutdown leak diagnostics remain explicitly documented. Legacy enemy style differences are P2/out-of-scope, not authority to redraw accepted art.

## Product baseline

Godot4.7.x/GDScript;45 implemented Act1 cards, two normal offers, IвЂ“XII resolutions plus sealed Bone Warden XIII. Solo/duo/trio contracts and compensation, authored encounters/waves, nine hero upgrades and original relic catalog remain authoritative. D412 accepted full75-pose hero pack is live; prior art/fallback/checkpoints retained. D314 Battle, D328 card DS3 and Fate Spread art locks remain. Silent-first production audio unchanged.

Long prior session logs and older backlog context: [archived state](archive/2026-11-09-pre-visual-polish/PROJECT_STATE.md), [archived roadmap](archive/2026-11-09-pre-visual-polish/ROADMAP.md). Historical pending flags there are superseded by current GitHub/this release; do not repeat old D153/D410 redraw work.
