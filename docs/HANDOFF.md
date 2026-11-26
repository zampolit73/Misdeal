## Final Visual Audit 1.0 · следующий шаг

Аудит завершён на `d4b94d2b`. Закрыть четыре P1 и провести один контрольный забег до XIII перед передачей издательской сборки. [Передача в новый чат и критерии приёмки](FINAL_VISUAL_AUDIT_1_0_HANDOFF.md).

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
