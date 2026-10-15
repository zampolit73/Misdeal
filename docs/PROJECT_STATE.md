# Misdeal — Current Project State
Updated: 2026-10-15. Technical truth: `zampolit73/Misdeal` `main`.

## Playable baseline

Godot **4.7.x / GDScript** dark-fantasy tabletop roguelike with a 12-resolution Fate Spread and sealed boss XIII. The prototype supports protagonist Knight/Ranger/Mage, conditional companion recruitment/loss (solo, duo, trio), card choice/event flow, tactical deployment + autobattler, defeat, victory/rewards, wizard interference and return to the table. The table uses DS2 / Fate Spread Variant C. Preserve the balance compensations already implemented in `scripts/core/run_state.gd`.

**Act 1 random-deal pool: 35/45 cards.** `ACT1_CARD_IDS` contains 35 entries and does **not** contain `threadbare_theatre`; the boss XIII is separate. D151 Funeral Procession is live (#34), D152 Defiled Laboratory is live (#35). `CARD_PATHS` already has `threadbare_theatre` for a **dev-only** Reward→Table test, *not* random dealing.

## D153 — Threadbare Theatre (QA candidate, NOT released)

- User-approved dark, asymmetric, ruined indoor **puppet theatre battle arena**, separate original scene-led card art (448×274) and two user-approved original **skeletal** enemy animation sets (25 poses each).
- `resources/encounters/threadbare_theatre.tres`: two authored formations; **one crowned Bone Puppeteer + two bone Marionettes**. `arena_id = "threadbare_theatre"`.
- `scripts/battle/thread_tether.gd` and `scripts/battle/battle.gd`: encounter-only threads reduce linked minion damage taken by **32% within 285px**; disconnections, master death and final battle cleanup restore baseline. No global BattleUnit damage changes.
- **D176 balance parameters are active**: Puppeteer HP 142, damage 7.5, interval 1.65s, movement 55; Marionette HP 88, damage 10.5, interval 1.22s, movement 78. D177 restored loadable `.tres` files and improved exact-path diagnostics.
- **Native Godot F6 matrix PASS (D178): 54/54 scenarios, 54 total victories, 0 entire-party defeats.** Solo/duo/trio 18/18/18; Knight/Ranger/Mage 18/18/18. Mean surviving HP **74/67/74%**, worst party-mean HP **39/15/37%**, mean durations **13.0/15.1/13.3s**, fallen individual heroes **0/4/4**, tether connections/breaks/master-death breaks **123/91/54**.
- Previous weaker D153 baseline was 54/54 victories with ~85/82–83/86% mean HP. The local buff added meaningful pressure and kept every scripted case winnable.
- User previously reported **real Battle → Reward → Fate Spread/Table works** on the original D153 setup; after D176, the user stated `пока все ок`, then requested a **repository file cleanup**, not explicit activation of card #36. Do not infer an ordinary-card release from test success.
- **Release still gated** by short user acceptance of revised live battle difficulty and subsequent ordinary-card pool smoke. `scenes/dev/threadbare_theatre_playtest.tscn` exercises the real battle. `scenes/dev/threadbare_theatre_battle_smoke.tscn` tests 54 deterministic combat cases but does not measure fun or the complete player journey.

## Stable design and pending work

- D143: new combat cards must feature genuinely new enemies and mechanics.
- D167: cards are scene-driven illustrations; D168: render three image options before approval; accepted D153 imagery must not be substituted with generic sprite displays.
- No changes to accepted D151/D152/Fate Spread assets or global solo/duo/trio rules during D153 balancing.
- **Next product action:** see `docs/HANDOFF.md`. After D153 release, continue the remaining Act 1 expansion toward 45 nonboss pool cards; prioritize a playable vertical slice.

See `docs/INDEX.md` for current references and the **full pre-cleanup snapshot in `docs/archive/2026-10-15-pre-cleanup/`** for detailed historical QA/design notes.
