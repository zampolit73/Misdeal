# Misdeal — Decisions

This file records decisions that future chats should not casually reverse.

## D001 — Project name: Misdeal

Date: 2026-10-04  
Status: accepted

The game is named **Misdeal**.

The name evokes both an invalid/unfair card deal and a bad deal or bargain, matching the cursed-game premise.

## D002 — Godot + GDScript

Date: 2026-10-04  
Status: accepted

Use Godot 4.7.x and GDScript.

Do not move to C#/.NET without an explicit discussion and decision.

## D003 — Combat is a compact tactical autobattler

Date: 2026-10-04  
Status: accepted

Misdeal does not use Hand-of-Fate-style direct action combat.

Combat encounters become short autobattles where the player's primary agency comes from preparation, party composition, positioning, equipment and limited tactical choices.

The autobattler should remain compact and support the card roguelike rather than becoming a separate giant auto-chess game.

## D004 — Evil wizard replaces the dealer archetype

Date: 2026-10-04  
Status: accepted

An evil wizard is the host, antagonist and master of the cursed table.

He deals encounters, comments on the player's choices and provides the personality tying the run together.

## D005 — Vertical slice before architecture polish

Date: 2026-10-04  
Status: accepted

The primary development goal is to prove the playable loop quickly.

Prefer simple working implementations over speculative abstractions.

Refactor toward data-driven Resources when the next playable feature benefits from it.

## D006 — GitHub is the technical source of truth

Date: 2026-10-04  
Status: accepted

Repository: `zampolit73/Misdeal`

ChatGPT Project conversations provide useful design context, but the repository defines what is actually implemented.

Every fresh development chat should read the continuity documents listed in `AGENTS.md` before proposing code or architecture changes.

Significant sessions should update the repository documentation so work can continue from a new chat without reconstructing history manually.

## D007 — Browser assistant edits, user validates locally

Date: 2026-10-04  
Status: accepted

The assistant should make implementation changes directly through the connected GitHub repository when asked.

The user pulls those commits to the local Godot project and validates behavior in the editor/runtime.

Do not require manual code copying when the repository can be updated directly.


## D008 — Unit definitions use Godot Resources

Date: 2026-10-04  
Status: accepted

Reusable combat stats for heroes and enemies are stored in `UnitData` `.tres` resources.

Battle scenes and encounter logic should reference these resources rather than duplicating unit stat blocks in GDScript.

Runtime state such as team, current HP, target and position remains on the instantiated `BattleUnit`.


## D009 — Minimal autoload RunState for vertical-slice scene flow

Date: 2026-10-04  
Status: accepted

Use a small `RunState` autoload to carry prototype run values between the table, battle and reward scenes.

For the first vertical slice it stores only the state required to prove the loop: gold, deals survived, party-wide HP/damage bonuses and the last battle result.

Do not turn it into a large global game manager. Move domain-specific data into dedicated Resources/systems when the vertical slice requires it.

Current reward values and defeat behavior are prototype tuning, not permanent game-design commitments.


## D010 — Player-facing language is Russian

Date: 2026-10-04  
Status: accepted

All player-facing Misdeal content should be written in Russian:

- menus and buttons;
- card names and descriptions;
- wizard dialogue;
- combat status text;
- reward names and descriptions;
- unit display names.

Technical identifiers remain English, including file paths, node names, class names, resource IDs and code symbols.


## D011 — Combat encounters use EncounterData Resources

Date: 2026-10-04  
Status: accepted

Combat-card content is stored in `EncounterData` Resources rather than hard-coded encounter branches in `battle.gd`.

For the vertical slice an encounter defines its player-facing card text, wizard line, enemy UnitData references, enemy names and spawn positions.

The battle scene remains generic and loads whichever encounter path was selected at the table.

## D012 — Vertical-slice run length is three victories

Date: 2026-10-04  
Status: accepted for prototype

The first finite Misdeal run ends after three rewarded victories.

This is a vertical-slice pacing value, not a commitment for the final game's run length.

Defeat currently returns the player to the table without advancing the victory count; this is also prototype behavior and may change with later run-design work.


## D013 — Non-combat events can modify the current run

Date: 2026-10-04  
Status: accepted for prototype

The table can contain non-combat event cards alongside combat encounters.

The first event, Whispering Well, is one-time-per-run and demonstrates self-authored risk: the player may trade party health for damage, spend gold for health, or refuse the offer.

Non-combat events do not currently count toward the three victories required to finish the vertical-slice run.

## D014 — Visual development starts with a stylized blockout after the core loop

Date: 2026-10-04  
Status: accepted

With the finite vertical-slice loop working, visual development can begin during Phase 3.

Start with a coherent stylized blockout for the cursed table, cards, wizard presence and combat miniatures. Use lightweight prototype visuals to establish composition and mood before committing to final production assets.

Final art polish remains a later Phase 4 task.


## D015 — Misdeal uses dark-fantasy pixel art

Date: 2026-10-04  
Status: accepted

The player-facing visual direction is dark-fantasy pixel art.

Combat readability is the first constraint:

- units should be recognizable by silhouette rather than by labels;
- unit sprites are the primary visual element;
- team color appears as a restrained ground marker instead of a thick portrait circle;
- HP and names should remain compact;
- nearest-neighbor texture presentation is preferred for pixel assets.

The earlier realistic/painted combat miniatures were judged too small and visually muddy when shown at tactical scale. Painted concept assets may remain as reference material, but new in-game visuals should converge on the pixel-art language.


## D016 — Approved pixel concepts may be sliced into live game assets

Date: 2026-10-04  
Status: accepted

Approved generated pixel-art concepts can be used as source material for production-facing prototype assets.

For the wizard table, keep run-dependent information and interaction in native Godot UI rather than using a full static mockup with baked values.

The approved table concept is archived at `assets/concepts/approved_table_direction.png`.

The active table uses extracted authored layers/illustrations from that concept plus live Godot controls for:

- deal/gold/party modifier HUD;
- wizard commentary;
- encounter titles/descriptions;
- card hover/disabled states;
- card selection and scene transitions.

Use the same approach for previous generated battle/table concepts: extract reusable art pieces when useful, but do not embed screenshots whose UI or gameplay state would become stale.

## D017 — Final vertical-slice deal is the first boss fight

Date: 2026-10-04  
Status: accepted for prototype

The third and final combat deal of the current three-victory vertical slice is a mandatory boss encounter against **Костяной надзиратель**.

Normal combat-card choices are replaced on the final deal so the run has a clear climax. If the one-time Whispering Well event has not yet been resolved, it may still be used before accepting the boss fight.

The first boss deliberately uses a small extension of `UnitData` rather than a general ability framework: optional boss scale plus a one-time HP-threshold enrage modifier. This is enough to test boss pacing and readability without introducing a broad status/ability system before the vertical slice needs one.

The boss currently reuses the Skeleton pixel sprite at a larger scale as a temporary gameplay placeholder. A unique authored boss sprite/card illustration should follow only after the fight is locally validated.

## D018 — Act 1 uses twelve resolved cards before the boss

Date: 2026-10-04  
Status: accepted for prototype; supersedes D012 pacing

The three-victory run was a vertical-slice pacing scaffold. Act 1 now targets **12 resolved cards followed by the Bone Warden boss**.

The wizard normally presents two cards. Choosing one commits the player to that card and removes the rejected alternative from the current run. A selected combat card remains active after defeat so returning to the table offers the same fight again rather than silently consuming another choice.

Because twelve two-card choices consume twenty-four unique cards when rejected alternatives leave the run, the Act 1 structural pool contains **24 unique pre-boss card definitions**, split into eight early, eight mid and eight late cards. This intentionally corrects the earlier rough idea of a 15-card pool, which was too small for twelve pairwise choices without repeats.

Only the already-existing encounters and Whispering Well are fully implemented mechanically in the first structural pass. The remaining new card definitions use a generic prototype resolver so the complete 12-card pacing, tier transitions, rejection behavior and boss handoff can be tested before building every card mechanic.

The Bone Warden remains the thirteenth/final card and completes the run only after its post-combat reward is taken.
