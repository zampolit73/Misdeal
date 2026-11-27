## Cross-cutting License Compliance 1.0

For all future Misdeal imports follow [License Policy](LICENSE_POLICY.md). Run `python scripts/dev/check_licenses.py --inventory` after changed assets/addons/shaders/media and before committing. Registry is initialized from existing evidence; `--release` intentionally fails while the legacy rights audit and actual engine/export evidence are incomplete. Do not publish a player build until release preflight passes. No gameplay/visual changes; resume the previously active Travel V5 local review below.

## Cinematic Travel V5 · approved forge live, next batch

Player approved the HD Curse Forge scene. Pull main, play F5 and resolve «Проклятая кузня»: purchase/refuse, existing narration, intact 6.6 s movie, skip Esc/Space, return to Table once. The dedicated F6 `scenes/dev/travel_forge_v5_preview.tscn` remains the accepted reference; the old Travel Batch02 QA entry still shows V4 rollback. Production routing tests PASS (19 valid contexts / 229 checks, missing-atlas fallback 2/2); native integrated F5 playback not captured here. Other 23 Travel scenes retain V4. Next step: choose coherent batches, stage logical routes and scale, use native painted NPC detail and existing hero identity, retain real outcomes and fallback. No save reset. [Contract/QA](qa/travel_forge_v5/README.md).

## Travel Staging V4 · next local check

Player accepted the full V3 rollout and asked to improve unit routes and relative scale. V4 is implemented across all 24 event locations. Pull main, F6 `scenes/dev/qa_hub.tscn` → TRAVEL → `banner_seamstress`, `rattling_bridge`, `curse_forge`, `debtor_bones`, `black_altar`, `chained_prisoner`. Check party sizes 1/2/3, outcome arrows and R replay: feet inside the actual road, proportional near/far stature, clean rescue exit and no floating ground dust. Check real Ranger + Jack and normal Event→Travel→Table / skip in F5. No profile reset. Offline staging review and 39 targeted tests PASS; native shader/occlusion/stride feel still need player review. If necessary refine the affected scene's values in `resources/travel/staging_v4.json` or the two legacy curve resources. [QA and measured examples](qa/travel_staging_v4/README.md).

## Cinematic Travel V3 (superseded by V4 staging)

Player accepted the full 24-location rollout on 2026-11-27. See V4 above for current QA; V3 motion and effects remain the baseline. [Rollout](CINEMATIC_TRAVEL_V3_PILOT.md).

## Archive — Achievements UI V3 · next native acceptance

Pull main and F5 → Archive → Challenges. Overview: original four preview seals between three styles and five oaths, live clickable “Все достижения x/24”, overview x/32. Open collection: twelve niches per page, 1/2 and 2/2, 16 px labels (two lines), full title/condition and real unlock state; use arrows or PageUp/PageDown. Esc/“К испытаниям” returns to overview with former selection, second Esc returns to caller. Switch tabs and re-enter; verify Archive from both Main Menu and Table, preserving the active deal. No profile reset needed. Targeted Godot tests cover every ID, deferred label sizing, actual conditions, read-only profile, focus and navigation. Native Windows screenshot still needed; [QA](qa/achievement_system_v2/README.md#achievements-ui-v3). Do not reopen accepted archive art or achievement rules.

## Achievement System V2 · next native acceptance

Pull main, F5. Existing Archive profiles migrate by proven facts without old-achievement toasts; no reset needed. The achievement cabinet now uses the V3 overview + dedicated 12-seal collection described above; separate achievement and aggregate totals. New achievements from ordinary confirmed choices, collection or combat should show a short non-interactive bronze notice only once. At RunEnd inspect the top-left scrollable list of achievements first earned in that run (not earlier ones). Godot 4.7.2: 24/24 targeted tests, 518 assertions, including schema 1 migration, failed write/retry, all 24 predicates and pagination, RunEnd and old save contract. Native rendering/player acceptance not yet verified. [QA](qa/achievement_system_v2/README.md). Do not reset the player's profile just to test notices.

## Wizard Archive Visual V3 · next native acceptance

All four archive tabs use the player-approved V3 presentation. Pull main, F5 and open «АРХИВ ВОЛШЕБНИКА»; switch through Relics, Bestiary, Chronicle and Challenges. Check the subdued cabinet, dark detail plaque, legible actual copy, focused/selected states and Esc; from Table, Archive must return to the same deal. No new run or reset needed. Godot 4.7.2 headless: 8/8 targeted tests, 153 assertions. Native framebuffer not captured locally; visual acceptance remains open. [Concept and QA](qa/wizard_archive_v3/README.md).

## HUD Visual V2 · next native acceptance

Both localized header concepts were player-approved and are implemented. Pull main and F5: inspect Table's five live counters, Wizard dialogue and old baked contours; choose a fight and inspect encounter/guidance, progress, real modifier rows and their full hover tooltip. Check a conditional state or second wave if encountered naturally; no special run is required. The approved cards, artwork, D300 banner/medallion, arena and bottom V4 planner are unchanged. Godot 4.7.2: 13/13 targeted tests, 344 assertions; D289/D291 headless smoke PASS. Native framebuffer not captured locally; player acceptance remains open. [QA and references](qa/hud_visual_v2/README.md). Then continue any remaining concrete visual gates and Act I control run.

## Combat Intro Visual V1 · next native acceptance

Battle Result V2 is player-accepted on 2026-11-27. The next local check is the newly restyled short «СХВАТКА» / «ВОЛНА II» banner: start a fight and, if available, a second wave. It should share the menu/result's bronze frame, show the actual encounter and disappear before live orders. The original delay, scrim, Warden intro and combat are unchanged. Godot 4.7.2: 9/9 targeted tests (244 assertions); native capture is wired into existing planning CI, not run locally. [QA](qa/combat_hud_v1/README.md#combat-intro-visual-v1). After visual acceptance, avoid repainting approved systems; move to remaining concrete visual gates and the continuous Act I control run.

## Battle Result Visual V2 · accepted in production

The player confirmed the integrated result is OK and implemented on 2026-11-27. Preserve it. Optional regression route, not an outstanding acceptance task: F5: win a planned battle, open/close «РАЗБОР ПРИКАЗОВ», claim the reward; on a disposable run lose, inspect the actual Last Deal price, accept or refuse; a second defeat must present the final result and route to the separately approved RunEnd. Classic must omit the report. Keep real encounter/payout/cost text and all original rules. Targeted Godot 4.7.2: 25/25 tests, 469 assertions. Native screenshots are now wired into the existing gameplay-core release CI, not yet captured locally (headless stalls on renderer-dependent scene swaps). [QA and reference](qa/battle_result_v2/README.md). Continue outstanding native acceptance gates below and the Act I control run.

## System Dialog V1 · native acceptance

User approved the Main Menu V2 visual family for system dialogs. Both production confirmations are implemented. Player screenshot exposed escaped text due to zero-width automatic wrapping; fixed and verified with deferred-layout checks (17/17, 349 assertions). Player's subsequent native New Game screenshot confirms the text-layout repair. The remaining visible rectangular button corner matte and duplicate focus rim were addressed by dialog-only alpha derivatives and the matching bevel focus highlight. An isolated Godot 4.7.2 component test passed 49 checks with actual production script and textures; full project GUT and native framebuffer were not rerun for this cosmetic change. Recheck the clean corners and focus in both real dialogs; player visual acceptance remains pending. F5 with an existing save or Memory Glass → New Game → cancel; in-run Esc → «В главное меню» → cancel/Esc → pause → Esc → gameplay. Check both distinct new-run choices using a disposable profile only. Do not change the Archive, backups or restart rules. [QA and reference](qa/system_dialog_v1/README.md). Continue the outstanding native acceptance gates below and the Act I control run; no need to redesign approved screens without feedback.

## Camp Rest Black & Gold · native acceptance

Both rest stops (IV and XII) now use Cursed Deck V3; the old environment and illustrations remain unchanged, training selector and restrictions remain live. Godot 4.7.2: 29/29 targeted tests (572 assertions), including real panel selection, checkpoint save and duplicate guard. Native capture of both stops is included in card CI. Player check: F5 resolve IV/XII, switch trainee, inspect unavailable rite, choose once and return to Table. The separate merchant cabinet is unchanged. [QA](qa/camp_rest_v2/README.md#black--gold-v3).

## Cursed Deck V3 · Black & Gold — current visual acceptance gate

The player approved the dark-face colorway after reporting low contrast in V2 runtime. V3 is implemented in the unified card skin: dark matte face, pale gold titles/actions, ivory descriptions, brighter semantic colors, fitted Table text, revealed Fate titles. V2 backs/unknowns, actual art and all gameplay remain unchanged. Godot 4.7.2 headless: 26/26 tests (2605 assertions) and D315/D316/D274 smoke PASS; local native capture blocked by X11 socket permissions. [QA and concept](qa/cursed_deck_v3/README.md).

Next: F5 Table, R spread (including revealed/held/discard), RMB/F inspection, one 2–4-option event with unavailable state, development and reward. Confirm legibility; then resume the outstanding Combat Report visual check and Act I control run. Do not reopen previously accepted artwork or cinematic surfaces without concrete feedback.

## Cursed Deck V2 · historical baseline, front superseded by V3

The player rejected the gold-edged V1 runtime appearance as visually mediocre and approved the replacement [Cursed Deck V2 board](../assets/source_archive/cursed_deck_v2/approved_reference.webp) on 2026-11-26. The shared native skin now renders weathered gray-beige physical paper with thin printed ink borders; original illustrations and localized live text remain separate. The matching dark moon-seal back and unmarked unknown texture replace the old live backs. Cards use quiet ink-action rules and subdued hover/keyboard-focus/selected outlines instead of heavy buttons. Table, inspection, known/unknown live Fate cards, 24 event routes, normal/bonus development, elite trophies and death wager use the same family. The original printed generic future slots and sealed XIII remain in the established Fate background; empty discard uses the neutral back to cover the painted example in the live layer, hidden art wells are no longer visible, and small titles can use two lines. Merchant cabinet and Wizard Wager retain approved non-card surfaces. Existing hit areas, artwork, data, gameplay and confirmation semantics are unchanged. Godot 4.7.2: 25/25 targeted tests, 2061 assertions; D315/D316/D274 headless PASS. Native framebuffer/player acceptance pending. [QA](qa/cursed_deck_v2/README.md). Combat Report V1 visual acceptance remains separate.

V2 runtime readability was subsequently rejected by the player; the V3 acceptance gate above supersedes this historical gate.

## Combat Report Visual V1 · player visual acceptance pending

Concept approved on 2026-11-26 and implemented in the production campaign. Godot 4.7.2 targeted tests 19/19 (208 assertions). Open F5 → planned battle → result → «РАЗБОР ПРИКАЗОВ»; inspect actual hero rows, scroll down for later events, close by button/Esc, return to the unchanged outcome. Test a victory and defeat if convenient; no need to repeat previously accepted UI. Native frame capture is integrated into the existing CI planning runner (`campaign_combat_report_v1.png` and `_scrolled.png`); local workspace could not establish an X11 display, so do not label visual rendering or human acceptance passed until verified. Next concept after acceptance: Fate Spread, then auxiliary dialogs. [Reference and QA](qa/combat_report_v1/README.md).

## Interface Polish 2.0 · three packages accepted in production

Merged Pause Menu Visual V1 [#159](https://github.com/zampolit73/Misdeal/pull/159), Card Inspection Visual V1 [#160](https://github.com/zampolit73/Misdeal/pull/160) and Combat HUD Visual V1 [#161](https://github.com/zampolit73/Misdeal/pull/161) into main. Combined Godot 4.7.2 headless regression: 32/32 tests, 483 assertions, plus D274/D316 smoke. The reader layout test accepts insignificant subpixel anchor precision; runtime code unchanged by the integration follow-up.

On 2026-11-26 the player explicitly confirmed all three packages were integrated and accepted in local Godot. Release CI for #161 completed successfully (run 45836358193). Preserve the approved surfaces. The regression route remains:
1. F5 → Table → Escape: pause, resume, safe checkpoint save/load and disabled save in live combat. [QA](qa/pause_menu_v1/README.md).
2. Right-click both Table card and development upgrade: full parchment copy, notes when real, scrolling, close/return focus. [QA](qa/card_inspection_v1/README.md).
3. Start a planned fight, inspect the compact active-order HUD, countdown, stage transition and dead-row removal; verify wave break, Classic and result. [QA](qa/combat_hud_v1/README.md).

Combat Report Visual V1 concept was subsequently approved and implemented; see the current handoff above. Preserve all previously accepted art and mechanics.

## Wizard Wager Visual V1 · approved in main

PR #158 is merged, and the player confirmed acceptance on 2026-11-26. Preserve the approved optional contract and original mechanics; no further redesign is pending. In the full Act I control run, exercise the wager after II/III or VII when eligible. This is not the post-battle Death Wager reward. [Reference and validation](../assets/source_archive/wizard_wager_v1/README.md).

## Final Visual Audit 1.0 · следующий шаг

Аудит завершён на `d4b94d2b`; пакет четырёх P1 и P2-06/07 слит через PR #157. Следующий шаг: нативная приёмка остальных исправлений, решение по P2-05 (Last Camp) и непрерывный контрольный F5-забег до XIII перед передачей издательской сборки. [Передача в новый чат и критерии приёмки](FINAL_VISUAL_AUDIT_1_0_HANDOFF.md).

## Camp Rest Visual V2

Resolve card IV or XII and return to Table. Tab and Enter navigate and choose, and the training selector changes only the hero and preview. Hover a choice for its full effect. The action still saves through CampStop before returning to the same Table. [Native captures and checks](qa/camp_rest_v2/README.md)

## Intro Visual V2

Use F5 → «Новая игра» to watch the six frames. Click, Space and Enter advance. Skip or Esc opens the existing hero selection. [Native QA](qa/intro_v2/README.md)

## Hero Selection Visual V2

Start through F5 → New Game, or use QA Hub → «Игра» → «Выбор героя». Check a clean Archive and an unlocked profile with the combined style and oath copy. [Native QA](qa/hero_selection_v2/README.md)

## Main Menu Visual V2

Press F5 to inspect Main Menu Visual V2. Compare Continue with an empty and valid slot, and use the existing New Game dialog to verify reset choices. [Native QA](qa/main_menu_v2/README.md)

## Merchant Visual V2

To review the merchant, reach the stop after VIII. Use Enter on a price tag, then use the return button to continue the deal. [Native QA and source art](qa/merchant_v2/README.md)

## Event Choice Visual V3.2 · complete

PR #146 is merged into main and the player accepted the production rollout on 2026-11-25. Preserve the approved muted palette, layout, illustration and choice semantics across all 24 events. For future regression checks use QA Hub under «События». «Знамя на бинты» has three choices, «Лавка могильщика» has four and shows locked offers at zero gold, and «Шепчущий колодец» verifies the dedicated scene. All use the approved V3.1 palette through the shared presentation.

## Table Interface V5.1 · complete

PR #144 is merged and the player accepted the production result. Preserve the approved table, restrained palette, navigation, and same-deal Archive return. [Native evidence](qa/table_interface_v51/README.md)

## Run End Visual V2 · complete

PR #147 is merged into main and the player approved the production result on 2026-11-25. Preserve both result plates and existing run/save flow. For regression checks: In QA Hub, open «Интерфейс» and select «Конец забега — победа» or «Конец забега — поражение». Verify the actual scroll areas, relic tooltips and «Новый забег». [Native frames and QA](qa/run_end_visual_v2/README.md)

## Reward Cinematics 1.0 · Normal Loot complete

PR #148 is merged into main and the player approved the production result. Preserve the supplied plate, live gold amount, debt state, single claim and existing route. For regression checks, open «Награда — настоящая обычная добыча» under «Интерфейс» in QA Hub. [Native evidence](qa/reward_loot_v1/README.md)

## Reward Cinematics 1.0 · Elite Artifact complete

PR #149 is merged into main and the player approved the result. Preserve the supplied plate, actual relic art and confirm/claim behavior. For regression checks, review the production Reward scene after a Crypt Guard victory, including any due major upgrade. Use the original option order and economics. [Native evidence](qa/reward_elite_v1/README.md)

## Reward Cinematics 1.0 · Hero Development complete

PR #150 is merged into main and the player approved the result. Preserve live offers, signed modifiers and direct claim. For regression checks, review the real development reward in QA Hub under «Интерфейс». [Native evidence](qa/reward_development_v1/README.md)

## Reward Cinematics 1.0 · Death Wager V1.2

Win the Death Wager encounter and continue to rewards. Check the pending relic, the 60 gold choice and the transition to bonus development. Use ← / → and Enter to choose, or F / right click for the full description. The active debt survives the choice. [Native QA](qa/reward_death_wager_v12/README.md)

## Ossuary Gate · visual audit

Current Godot 4.7.2 frames on `d4b94d2b` show low haze around the rear portal during preparation and at combat start. The start frame also records an overlapping bellkeeper label. [Audit evidence and follow-up](FINAL_VISUAL_AUDIT_1_0_HANDOFF.md).

## Living Arenas V4.1

Use **ЖИВЫЕ АРЕНЫ** in the F6 QA Hub and watch the preparation field for several seconds. Check the altar, furnace and rear portal first, then start a fight and watch Iron Wall wave II or the Court victory. [Native sequences](LIVING_ARENAS_V4_1.md)

## Living Arenas V4 Lite

Open **ЖИВЫЕ АРЕНЫ** in the F6 QA Hub and start the listed battles. Watch Iron Wall when wave II starts and the Court when victory opens. [Reaction cues and native frames](LIVING_ARENAS_V4_LITE.md)

## Event Choice Visual V2

Run `scenes/dev/qa_hub.tscn` with F6. Under **СОБЫТИЯ**, open «Кости должника», then compare «Шепчущий колодец» with 24 and 25 gold. Check arrow-key focus, Enter, the choice result and the return through Travel. [Approved reference and native captures](qa/event_choice_visual_v2/README.md)

## Bone Warden XIII · throne intro

Use F5 and open card XIII after resolving XII and the last preparation stop. For a quick repeat, run `scenes/dev/living_warden.tscn` with F6. The restored Last Deal goes directly to the defeat screen. Accepting the deal starts a fresh attempt and replays the intro. [Verification and assets](WARDEN_INTRO.md)

## Gameplay 2.0 · Package C

`wizard_archive.gd` stores collections and terminal results independently of the run slot and stained glass. `run_charter.gd` defines difficulty and style rules. `gameplay_meta_capture.gd` checks real Phase II, win and loss, profile restore and a new run with unlocked settings. Next balance work should compare human routes with different builds and party sizes, especially Last Bell and XIII. [Gameplay 2.0](GAMEPLAY_2_0.md)

## Gameplay 2.0 · Package B

Nine additional ArtifactData resources bring the catalog to 13. `BattleUnit` applies bounded combat reactions, and Battle handles intermission healing and Wizard payout. `run_build_feedback.gd` reads the same effective stats as Battle. `scripts/dev/gameplay_builds_capture.gd` exercises purchase feedback, the dossier and a marked victory. [Rules and captures](GAMEPLAY_2_0.md#package-b--builds--rewards)

## Gameplay 2.0 · Package A

RunState holds persistent HP and a single pending stop. Victory heals each hero by 25% of maximum HP before the reward checkpoint. `run_camp_stops.gd` owns camp healing, eligible offers and purchases. Battle and the dossier share effective hero stats. Continue restores the paid Last Deal or the victory reward when present. Use `scripts/dev/gameplay_core_smoke.gd` with Godot 4.7.2 to cover the native route. [Rules, save migration and balance questions](GAMEPLAY_2_0.md)

## Combat Audio V2

In QA Hub compare the open graveyard, a crypt and an enclosed arena. The Warden has separate cues for combat start, attacks, phase two and defeat. [Sources](audio/THIRD_PARTY_AUDIO_LICENSES.md#combat-audio-v2)

## Act I sound cues

F5 checks use Table → Event → Travel and a regular fight. The original Oak deal and D368 attack palette still anchor the mix. [New sample sources](audio/THIRD_PARTY_AUDIO_LICENSES.md)

## Event Choice UI VNext

Use the existing event handlers for consequences and pass live prices and restrictions to the shared presentation. In QA Hub, check Whispering Well at 24 and 25 gold. In F5, play from the event through Cinematic Travel back to Table. [Implementation and native gallery](EVENT_CHOICE_UI_VNEXT.md)

## D420 V2

From `main`, launch with F5 and enter an ordinary combat encounter to see the new animations. For side-by-side review, open `scenes/dev/enemy_visual_review.tscn` with F6 or choose the enemy review under АНИМАЦИИ in QA Hub. The two Battle buttons compare the same encounter with the same seed. [Review and evidence](ENEMY_VISUAL_POLISH_V2_REVIEW.md)

## Living Arenas V3

Use F6 on `scenes/dev/qa_hub.tscn`, then **ЖИВЫЕ АРЕНЫ**. The tab exposes all 17 profiles with party selection, original/live comparison, pause and repeat. Use F5 and choose a combat card to review the same renderer in the campaign. The Iron Wall wave-II reaction and Warden enrage require their actual battle events. [Coverage, native evidence and reproduction](LIVING_ARENAS_V3.md)

## Living Arenas V2

From `main` after PR #124, use the ЖИВЫЕ АРЕНЫ tab in QA Hub or open the three direct F6 scenes. Compare the animated background in preparation and combat. Warden has a presentation-only phase switch during preparation and uses the real enrage trigger in combat. [Preview, evidence and reproduction](LIVING_ARENAS_V2.md)

## Act 1 gameplay audit — planned, not played (2026-11-19)

Live `main` and prior game-balance diagnostics were reviewed. Start the gameplay milestone using [`ACT1_GAMEPLAY_AUDIT_2026-11-19.md`](ACT1_GAMEPLAY_AUDIT_2026-11-19.md): three authentic F5 routes by protagonist, F6 matched tactical comparisons (Last Bell, Ossuary, waves, Court, boss), event interest, pacing, conditional XIII phase and Last Deal. **No manual campaign playtest or post-V4 rebalancing has been performed; do not state otherwise.** Preserve all 24 player-approved Travel scenes and the campaign V4 planner. Follow priority P0→P1→P2, ground fixes in evidence and secure user authorization before altering balance/art.

## Next-chat handoff — user-approved Act 1 Travel (2026-11-19)

The player finished reviewing the full Cinematic Travel set and explicitly confirmed: "там все ок. меня устроило". All **24/24 unique Act 1 event Travel scenes** (7 earlier + 7 Batch 02 + 10 Batch 03) are artistically accepted. Do not reopen approved art/scale or commission the same locations again without new concrete feedback. This is user feedback on visuals, not a claim of a complete manual campaign playthrough.

Combat Planning 1.0 and approved gothic Visual V4 are live in `main` via PR #117; the 10-scene Batch 03 package is live via PR #119. **Next recommended task**: full Act 1 gameplay playtest and balance/UX audit (12 Fate resolutions + Bone Warden XIII), not more Travel illustration. Read [complete next-chat handoff](NEXT_CHAT_HANDOFF_2026-11-19.md), [project state](PROJECT_STATE.md), [Travel review](TRAVEL_BATCH03_REVIEW.md) and [combat rollout](COMBAT_PLANNING_ROLLOUT.md). No new gameplay code was requested or changed in this handoff.


## Cinematic Travel Batch 03 on main

[PR #119](https://github.com/zampolit73/Misdeal/pull/119) shipped all ten locations and 72 resolved event outcomes at `084c09a`. From `main`, start the campaign with F5 or open `scenes/dev/qa_hub.tscn` with F6 and select **Travel → Batch 03 — 72 исхода**. [Runtime contract, visual evidence and QA controls](TRAVEL_BATCH03_REVIEW.md)

## Combat Planning 1.0 on main

PR #117 shipped the approved V4 planner in the shared campaign Battle. `battle_plan_campaign.gd` attaches it by default. The isolated F6 pilot explicitly opts out and remains available for comparison. [Rollout contract and release evidence](COMBAT_PLANNING_ROLLOUT.md)

From `main`, pull with `git pull --ff-only origin main` and start Godot with F5. Use «Новая игра» or «Продолжить», then choose a combat card. Move a hero, edit an order and start the fight. «Классика» restores the original orders before combat, and «Боевой план» reopens V4. In low deployment areas like Court of the Mute, «Открыть боевой план» opens the board and «Поле боя» returns to the floor. [Native captures](qa/combat-planning-release/README.md)

# Misdeal — current handoff

## Released and approved

The user approved the final crown route and authorized production. PR #114 and #115 are merged into `main`; runtime commit `c1bba4007198e1bac14fb9e4ae20f9d65ef1181c`, [green full RELEASE CI](https://github.com/zampolit73/Misdeal/actions/runs/44058109794). The seven Batch02 locations /31 outcomes, final crown artwork/staging and QA Hub are production. Old pending-art/approval/no-auto-merge notes for this delivery are superseded and archived.

## Local review

Primary project: `C:/Users/irlix/GodotProjects/Misdeal`. Stop an old running preview before starting again.

- F5 starts the real game.
- Open `scenes/dev/qa_hub.tscn`, F6 for the unified navigator. Search by title/Card ID; select party/gold and launch. F9 replay, F10 hub, F11 clean capture.
- Travel → «Пустое место последнего властителя»: ←/→ cycles wear/break/melt/leave; approved small props and up-right garden route apply to every outcome.
- General Batch02 F6: `scenes/dev/travel_batch02_playtest.tscn`,31 actions,1/2/3 party,P pause,R replay. Real choices continue through Event→Travel→Table.

## Safeguards

QA run and Memory Glass services are isolated under `user://qa_hub/`; normal player progress is preserved. Existing D412 frames, old Travel, Wizard/table, combat, balance and saves stay locked. Local `project.godot`, imports and player-authored files must not be reset/cleaned. Protected files were backed up and hash-checked before the production checkout update; the local worktree intentionally retains player settings.

## Validation and next task

Godot4.7.2 local GUT301/301 (77,821 assertions), selector18/18, original279 asset hashes and revised crown hashes. Full RELEASE verifies native QA hub startup/return, actual31 new /11 Pilot routes, party subsets, effects once, skip/pause/finish, save/load, UI/memory/combat/animations and Living Arenas. Native crown solo/trio route checks verify increasing X/decreasing Y, perspective and soles. Existing shutdown/type warnings are documented, not suppressed.

No unfulfilled task remains in this approved delivery. Continue with concrete user feedback; do not reopen accepted art, scales or routes without a new request. Old session notes remain in [the release archive](archive/2026-11-17-production-release/HANDOFF.md); [QA instructions](QA_HUB.md), [Travel contract](TRAVEL_BATCH02_V2.md), [evidence](qa/crown_small_props/README.md).
