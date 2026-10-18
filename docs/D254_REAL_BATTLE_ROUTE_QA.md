# D254 — Real Battle → Reward → Table QA launcher (card #38 still unreleased)

Date: 2026-10-19. User asked to continue following D253. **New Godot F6 integration launcher staged, native Godot test NOT RUN here.**

## Why this stage

D249/D252 proved two isolated original 3v5 formations; D253 wired existing D206 `BlackLanternLightController` into **actual** `Battle`, but no ordinary Battle startup/result had been exercised. D254 introduces a **standalone QA launcher** instead of releasing card #38 prematurely.

## Contents and isolation

- Scene: `res://scenes/dev/black_lantern_d254_real_battle_route_qa.tscn` (F6). Interactive party size **solo/duo/trio** (Knight / +Ranger / +Mage) and formation **МАРШ / ПЕРЕКРЁСТОК**.
- Exactly one new entry `"black_lantern_road": "res://resources/cards/black_lantern_road.tres"` in **`RunState.CARD_PATHS`** for resolving a QA card ID in Reward. **`RunState.ACT1_CARD_IDS` remains 37 entries** and never includes #38, and the card's actual `.tres` resource is unchanged.
- On click, strict guard that #38 is not in live pool; validate all 3 existing original 25-cel technical animations via the D249 helper; then `RunState.reset_run()`, choose Knight, temporarily add the selected companions with JOINED fates, set a QA-only `active_card_id` and exact `selected_encounter_path`, and select desired authored formation. All state is **in the separate F6 game process**, not an existing user's normal run. No game save file is written by these calls.
- The launcher **instantiates the unchanged real `scenes/battle/battle.tscn`**, including its full preparation/deployment/tactics/Fight/intro, normal RunState party/enemy stat multipliers, D253 scoped D206 lanternlight (1.16× on illuminated enemies), victory/defeat and continue to real `Reward`. Because card ID is now addressable, `Reward` can complete the QA card and enter real `Table` (within this isolated F6 session). Does NOT bypass real battle UI.
- The main unit library retains staged D244 Sentinel and D224 Bearer. The **three unfinished original** Guide D218, Oil Acolyte D217 and Archer D219 25-pose sources are **only injected into their three enemy BattleUnit instances AFTER the Battle scene is constructed, BEFORE the player can click Fight**. No registration, release, or generic sprite replacements.
- When the QA Battle is replaced by Reward, the real light controller's existing `_exit_tree` restoration backs up its `stop_light()` result cleanup. No changes to the controller, hero stats, actual encounter UnitData, existing battles or reward code.

## Native QA procedure

Run `git pull`, open the QA launcher scene, press **F6**, choose one party size and formation, then click `ЗАПУСТИТЬ НАСТОЯЩИЙ БОЙ`. Inspect actual Battle deployment and tactics, active/receding lantern pools, enemy contact, win/lose. After a victory, click `ЗАБРАТЬ НАГРАДУ`, choose reward, verify actual `Table` loads. For second mode/repeat, STOP F6 and start it anew. No claims of a completed native run or passed 54-case balance matrix until user logs are seen.

## Remaining art and release gates

A newly generated 2026-10-19 Guide reference still included opaque illustrated backing/labels and duplicated directional rows, unsuitable as game-ready 25-frame transparent source; do **not** integrate it or substitute for D218. The last D251 rich candidate remains structurally valid but failed motion/matte quality. Keep agreed identity: heavy rigid shoulder-mounted transverse iron yoke with exactly THREE separately chain-suspended lanterns; original rich B-style 25 genuinely distinct full-body cels required. Acolyte and Archer also unfinished. Live deck **37/45**, #38 not released; KARAMBA73, D209 arena, D244/D224, DS2, XIII untouched.
