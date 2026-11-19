# Misdeal — new chat handoff (2026-11-19)

> **Current source of truth:** GitHub `zampolit73/Misdeal`, branch `main`. Start by reading `AGENTS.md`, `docs/CONCEPT.md`, `docs/PROJECT_STATE.md`, `docs/ROADMAP.md`, `docs/DECISIONS.md`, and this document. User-approved designs in project chats are product requirements; GitHub owns implemented technical facts.

## Session outcome and player's acceptance

**The player explicitly reviewed Cinematic Travel coverage and said all scenes look good ("там все ок. меня устроило"). Treat ALL 24 Act 1 event Travel presentations as accepted and complete.** Do not restart a 10-scene art commission, reopen individual scene art, adjust Jack/hero scale, repaint approved locations, or request another artistic approval unless the player identifies a new concrete issue.

**Combat Planning 1.0 and Visual V4 are already shipped in `main`.** The player previously approved the gothic bronze/blackened-metal and parchment lower command board and authorized the campaign-wide rollout. Do not recreate the QA-only prototype or ask whether to merge PR #117.

The next recommended *new work* (not yet performed or authorized as code changes): **full Act 1 gameplay playtest and balance/UX audit**, from a fresh run through the Fate Spread and Bone Warden XIII. Focus on whether the game is fun, tactically varied and comprehensible rather than making decorative changes.

## What exists in main

### Cinematic Travel — 24/24 unique Act 1 event locations

- Earlier seven: `unsent_letters`, `banner_seamstress`, `borrowed_boots`, `false_weights`, `last_signal`, `gravedigger_shop`, `lost_purse`.
- Batch 02 seven: `candle_seller`, `blood_ledger`, `debtor_bones`, `wizard_tithe`, `broken_crown`, `curse_forge`, `rattling_bridge`. 31 choice-specific presentations; accepted crown prop size and up-right garden path are locked.
- Batch 03 ten: `black_altar`, `chained_prisoner`, `jack`, `whispering_well`, `last_camp`, `ash_rest`, `bone_tax`, `faceless_card`, `moon_seal`, `echo_crypt`. **72 outcome states**, 98 runtime plates. The player approved their scale, NPCs and reactions; PR [#119](https://github.com/zampolit73/Misdeal/pull/119) merged at `084c09a`. Native CI [44551061968](https://github.com/zampolit73/Misdeal/actions/runs/44551061968) passed all 72 production Event → Travel → Table routes and asset checks.
- Main registry: `scripts/travel/travel_catalog.gd` (Batch 03 uses `scripts/travel/batch_03_catalog.gd` and `resources/travel/batch_03/*.tres`). Event completion: `scripts/event/act_choice.gd`; separate Well: `scripts/event/whispering_well.gd`; shared travel routing: `scripts/core/scene_router.gd`.
- Event routes use actual committed player outcomes; no new rewards or RNG in presentation. Travel is skippable and disabled/invalid contexts fall back to Table. These 24 are **event cards**, not the 22 separate combat encounters. Do not assert that every combat victory has a unique authored Travel scene.
- Sources: `docs/TRAVEL_BATCH03_REVIEW.md`, `docs/TRAVEL_BATCH02_V2.md`, `docs/CINEMATIC_TRAVEL_V2.md`, QA `docs/qa/travel_batch03_review/README.md`.

### Combat Planning 1.0 — released

- [PR #117](https://github.com/zampolit73/Misdeal/pull/117) merged to `main`; the normal shared Battle has one-to-three independent, sequential, non-looping orders per living Knight, Ranger or Mage, with a persistent final order.
- Tactics Assault / Defense / Hunt; nearest / weakest / farthest / support priority; optional encounter-local concrete target; transition by time, damage dealt/taken, personal kill or own HP <=50%; 2–12-second event timeouts. Plans are editable before combat and between waves; actual BattleUnit remains the combat authority.
- Approved V4 dock: compact lower battle-planning area, gothic dark metal and bronze, light parchment order tiles, small role/tactic emblems, muted crimson Begin Combat button. Overview and single-order editor replace each other in the same bottom panel; target picker is transient. Preserve visibility of battlefield.
- `Классика` returns the original tactics (including one-use Sacrifice/Defiance), which are NOT programmable order stages. Survivor HP and special mechanics are preserved across waves; concrete enemy bindings do not carry between fights. Old save slots remain compatible.
- All 22 authored combat resources use the shared production path, including Bone Warden XIII and multi-wave Iron Wall; solo/duo/trio supported. Code: `scripts/battle/battle.gd`, `scripts/battle/planning/battle_plan_campaign.gd`, `scripts/battle/planning/battle_plan_ui.gd`. Source: `docs/COMBAT_PLANNING_ROLLOUT.md`.
- Godot 4.7.2 CI previously covered 313 GUT tests and 22-encounter smoke, with victory/Reward/Table, Last Deal choices and prior-version save continuation. This is NOT the same thing as a full manual random-run gameplay review.

### Other locked project foundations

- Dark-fantasy card-driven roguelike with evil Wizard as dealer; cursed table, exactly 12 Fate Spread resolutions plus sealed boss XIII. Solo/duo/trio party derives from the protagonist and recruited past-life companions; Jack is Ranger companion, not a full hero slot.
- Godot 4.7.x and GDScript only; data-driven `.gd`, `.tscn`, `.tres`; optimize for a playable vertical slice. No unapproved architectural rewrite, new combat engine, or fundamental redesign.
- Preserve approved DS2/DS3 card framing, artistic direction and C3/D412 hero silhouettes and animation. Knight's worn/torn cape is unique to Knight. Approved heraldry/banners must not be improvised; pigeons are skeletal in the first-act world. Avoid noisy AI-looking painting, excess detached props, duplicate bodies, weak depth/feet contact.
- Story: heroes' forgotten link to castle, villagers trapped in cycles of the past; Memory Glass / stained-glass fragments unlock over multiple runs. Core progression and existing saves are locked unless the player opens a new task.
- Art procedure: follow AGENTS.md and relevant decision records. Do not override the latest user's explicitly accepted reference because of historical conflicting notes.

## Next session — suggested first practical task

Conduct a **playability audit**, not an automatic mass rebalance. At first inspect live `main`, then determine how to reproduce a full fresh-run journey and gather grounded evidence:

1. New game/Continue → choose protagonist → Fate Spread cards I–XII → events and Travel → battles with per-hero plans → rewards → Bone Warden XIII → result; include a loss and Last Deal path when practical.
2. Assess solo Knight/Ranger/Mage, duo and trio; inspect win rates, battle times, strength of Assault/Defense/Hunt and event timeout settings; multi-wave Iron Wall; placement/target priority; how clear outcomes and Wizard conditions feel.
3. Check whether the event choices and visual consequences remain coherent, whether the full act is paced well, and whether a user can learn tactics without QA assistance.
4. Distinguish automated/native tests from actual human playtest. Record observable issues and reproducible steps; propose a prioritized list (P0 regressions, P1 gameplay blockers, P2 polish), smallest viable interventions first.
5. Do not modify approved artistic assets or balance without a concrete observed problem and user authorization. If the user explicitly asks to fix/implement, apply changes directly via connected GitHub, with tests, docs, changelog and meaningful commits.

For local user verification: from a clean/up-to-date local `main`, `git pull --ff-only origin main`; F5 for actual campaign. QA Hub: `scenes/dev/qa_hub.tscn` via F6; under Travel select “Batch 03 — 72 исхода”. Do not suggest resetting local `project.godot` or cleaning imports blindly; consult `docs/LOCAL_GIT_HYGIENE.md` if necessary.

## Session closeout

- User acceptance of full Travel Act 1 is **final** as of 2026-11-19.
- This handoff contains no new gameplay implementation or gameplay-tested acceptance; it records approved status and suggested follow-up only.
- New chat may start with: **“Продолжай Misdeal с docs/NEXT_CHAT_HANDOFF_2026-11-19.md. Travel первого акта утверждён; Combat Planning в main. Начни с аудита полного игрового цикла первого акта и плана плейтеста.”**
