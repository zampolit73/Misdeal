# D151 Funeral Procession — Native Godot smoke QA — PASS

**Verified:** 2026-10-15, from the user's screenshot of **Godot 4.7.2** executing `res://scenes/dev/funeral_procession_smoke.tscn` (F6).

## Measured result (not inferred)

The latest user-provided screenshot visibly reports:

> DECK EXPANSION 03 / FUNERAL PROCESSION — PASS  
> 54/54 боёв завершено • 54 побед / 0 поражений.  
> Предупреждений: 58 • воскрешений: 38 • усилений: 14.  
> Оригинальные ресурсы и оба атласа загрузились.  
> Это диагностический боевой smoke, НЕ оценка баланса.  
> Реальный бой → награда → стол проверяется отдельно.

The 54 diagnostic cases cover **2 formations × 3 starting archetypes (Knight, Ranger, Mage) × 3 party sizes (1, 2, 3) × 3 tactical orders (ASSAULT, HUNT, FORMATION)**. The test also exercises the D151 art/resources and scoped `LastRiteController`, and includes facing and freed-target regression checks. All 54 combats finish; zero runtime failure was displayed in this successful screenshot.

**Supersedes previous D151 smoke blocker:** two earlier user screenshots showed a "previously freed" target error in `BattleUnit._is_valid_target(target)`. Repository fixes included `candidate: Variant` with validity/type check, immediate simulation fixture disposal, stale-reference safety on the unit's process tick (later protective commit `a59a9d9`), and dedicated smoke regression. The current native PASS means this latest F6 run did **not** reproduce the crash. **Do not continue treating the D151 smoke as blocked.** Keep the older error reports only as incident history.

## Technical/game-design state to carry forward

- Current code in GitHub `main`: **34 / 45 nonboss Act 1 cards**, including Tier1 `funeral_procession`. There are still **11 cards to create** to reach the content goal. Each run stays **12 resolved Fate Spread cards + sealed Bone Warden XIII**.
- Encounter includes one genuinely original `funeral_priest` with grimoire and ritual censer and two `pallbearer` coffin carriers, with two authored formations. The **Last Rite** is distinct from the existing `grave_bellkeeper` and from Bone Shepherd's Whistle: telegraph, one revival of dead carrier at 40% HP, alternatively temporary fury for living carriers, cancelled on the priest's death.
- Original cinematic **448×274** card art and two **576×480** genuine **25-frame** enemy atlases are in `main`. User approved the corrected sprite visuals (feet/coffin no longer cropped) and fixed left-facing orientation. Do **not** resurrect rejected Mourning Bell / Grave Toll design or redo approved art without reason.
- D151 dedicated gameplay and art details: `docs/DECK_EXPANSION_D151_FUNERAL_PROCESSION.md`, `docs/DECK_EXPANSION_D151_ART_QA.md`. The accumulated context is in `docs/SESSION_HANDOFF_2026_10_15.md`; most current restart is `docs/NEXT_CHAT_HANDOFF.md`. Main battle source: `scripts/battle/battle.gd`, `scripts/battle/last_rite.gd`, `scripts/battle/unit.gd`.
- Prior D148 Bone Shepherd F6 smoke was also **54/54 PASS**; D149 event choices worked in Godot and D150 two original event card WebPs displayed correctly. Keep those earlier approvals distinct.
- A previous diagnostic D142 HUNT/duo imbalance investigation remains separate; do not silently change global combat scaling.

## What this PASS does *not* certify

1. **Balance**: 54 wins and 0 losses across this smoke suite is not evidence that the encounter is challenging or appropriately fair. Later check normal progression, earned rewards, equipment, Wizard meddling, solo/duo/trio difficulty and boss.
2. **Full UX/navigation**: the isolated F6 suite explicitly says **real fight → reward → table is checked separately**. The user saw the real prebattle and approved facing, but a complete normal-run victory/reward/Fate Spread return has **not** been independently confirmed in the latest QA report. This is a follow-up acceptance task, not a blocker on the already completed isolated smoke.
3. **Godot CI**: no local automated test runner was used by the assistant; native success is demonstrated by the **user's screenshot**, not by simulated claims.

## Next session (user requested handoff, no more development in this turn)

Read `AGENTS.md`, `docs/CONCEPT.md`, `docs/NEXT_CHAT_HANDOFF.md`, `docs/SESSION_HANDOFF_2026_10_15.md`, `docs/PROJECT_STATE.md`, `docs/ROADMAP.md`, `docs/DECISIONS.md` (plus `docs/HANDOFF.md` as needed). Then **offer a concrete next task**, preferably (a) one normal Funeral Procession fight through reward back to the cursed table and a focused balance check, or (b) content expansion **D152**, preserving D143's **genuinely new enemy, new animations, distinct art, mechanics** requirement for every new fight-bearing card. Do not rerun the same 54-case suite reflexively; it has a valid screenshot PASS. User expects the assistant to edit/commit via connected GitHub independently, keeping user actions minimal (normally only `git pull` and F6).
