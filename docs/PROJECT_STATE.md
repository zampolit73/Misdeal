# Misdeal — Current Project State
Updated: 2026-10-15. Technical truth: `zampolit73/Misdeal` `main`.

## Playable baseline

Godot **4.7.x / GDScript** dark-fantasy tabletop roguelike with a 12-resolution Fate Spread and sealed boss XIII. The prototype supports protagonist Knight/Ranger/Mage, conditional companion recruitment/loss (solo, duo, trio), card choice/event flow, tactical deployment + autobattler, defeat, victory/rewards, wizard interference and return to the table. The table uses DS2 / Fate Spread Variant C. Preserve the balance compensations already implemented in `scripts/core/run_state.gd`.

**Act 1 random-deal pool: 36/45 cards.** `ACT1_CARD_IDS` contains 36 entries and includes `threadbare_theatre`; the boss XIII is separate. D151 Funeral Procession is live (#34), D152 Defiled Laboratory is live (#35), D153 Threadbare Theatre is live (#36).

## D153 — Threadbare Theatre (source released as #36, native ordinary-deal smoke pending)

- User-approved dark, asymmetric, ruined indoor **puppet theatre battle arena**, separate original scene-led card art (448×274) and two user-approved original **skeletal** enemy animation sets (25 poses each).
- `resources/encounters/threadbare_theatre.tres`: two authored formations; **one crowned Bone Puppeteer + two bone Marionettes**. `arena_id = "threadbare_theatre"`.
- `scripts/battle/thread_tether.gd` and `scripts/battle/battle.gd`: encounter-only threads reduce linked minion damage taken by **32% within 285px**; disconnections, master death and final battle cleanup restore baseline. No global BattleUnit damage changes.
- **D176 balance parameters are active**: Puppeteer HP 142, damage 7.5, interval 1.65s, movement 55; Marionette HP 88, damage 10.5, interval 1.22s, movement 78. D177 restored loadable `.tres` files and improved exact-path diagnostics.
- **Native Godot F6 matrix PASS (D178): 54/54 scenarios, 54 total victories, 0 entire-party defeats.** Solo/duo/trio 18/18/18; Knight/Ranger/Mage 18/18/18. Mean surviving HP **74/67/74%**, worst party-mean HP **39/15/37%**, mean durations **13.0/15.1/13.3s**, fallen individual heroes **0/4/4**, tether connections/breaks/master-death breaks **123/91/54**.
- Previous weaker D153 baseline was 54/54 victories with ~85/82–83/86% mean HP. The local buff added meaningful pressure and kept every scripted case winnable.
- User previously reported **real Battle → Reward → Fate Spread/Table works**; following D176, the user said `пока все ок` and explicitly asked to continue development after the D179 document cleanup. The D180 source release enables card #36.
- **Post-release Godot QA pending:** new F6 `scenes/dev/threadbare_theatre_release_smoke.tscn` runs the normal `RunState` Tier1 offer→choice→encounter→Fate Spread path and checks boss XIII at 12 resolutions. It uses a controlled two-card fixture (not a real randomized playthrough); a quick live table check is still useful. `threadbare_theatre_playtest.tscn` runs real battle; `threadbare_theatre_battle_smoke.tscn` runs 54 deterministic cases.

## Stable design and pending work

- D143: new combat cards must feature genuinely new enemies and mechanics.
- D167: cards are scene-driven illustrations; D168: render three image options before approval; accepted D153 imagery must not be substituted with generic sprite displays.
- No changes to accepted D151/D152/Fate Spread assets or global solo/duo/trio rules during D153 balancing.
- **Next product action:** validate native D180 ordinary-deal release smoke, then continue the remaining 9 Act1 cards toward 45. See `docs/HANDOFF.md`.

See `docs/INDEX.md` for current references and the **full pre-cleanup snapshot in `docs/archive/2026-10-15-pre-cleanup/`** for detailed historical QA/design notes.
