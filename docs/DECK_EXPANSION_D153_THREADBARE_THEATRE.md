# D153 — Threadbare Theatre / Театр оборванных нитей
Updated: 2026-10-15. **Released as live card #36/45; post-release Godot routing smoke D181 PASS.**

## Accepted visual identity
The user chose the **skeletal** crowned puppet master and two original skeletal marionettes in worn crimson gothic theatre costumes; no wooden dolls or generic existing enemy sprites. Card art depicts an actual ruined moonlit puppet theatre; battle arena is a **separate** asymmetric indoor collapsed stage with open readable combat floor. Both character atlases have **25 frames** per role (idle 4, walk 6, attack 6, hit 3, death 6) and were accepted in Godot.

## Data & implementation
- `resources/cards/threadbare_theatre.tres` is registered in both `CARD_PATHS` and live `ACT1_CARD_IDS` (#36/45).
- `resources/encounters/threadbare_theatre.tres` contains two deployments of **1 Puppeteer + 2 Marionettes** and a unique arena id `threadbare_theatre`.
- `scripts/battle/thread_tether.gd` is a D153-only controller: linked bone marionettes take **32% less incoming damage** within **285px** of the living master; distance separates/relinks them, master death severs all, finish restores base multipliers.
- Original encounter assets: `assets/pixel/card_unification_v1/run/threadbare_theatre_approved_v1.webp.b64` (card 448×274); `assets/pixel/battle/arenas/threadbare_theatre_approved_v1.webp.b64` (battle 1280×720); `assets/pixel/units/deck_expansion_v1/threadbare_puppeteer_frames.webp.b64` and `bone_marionette_frames.webp.b64` (576×480 atlases).

## Balance/QA
D176 tuned the master to **142 HP, 7.5 damage, 1.65s attacks, speed 55**, and each minion to **88 HP, 10.5 damage, 1.22s attacks, speed 78**. The D177 `.tres` load fix is in `main`.

Native 54-case deterministic test (D178) returned **54/54 functional PASS**, 54 victories, 0 entire-party defeats, average solo/duo/trio surviving HP **74/67/74%**, worst **39/15/37%**, average durations **13.0/15.1/13.3s** and **123/91/54** tether joins/separations/master-death breaks. User had already confirmed actual battle→reward→table prior to tuning; revised battle feel should be accepted before pool release.

## Release gate
D180 activated D153 as card #36; the user then provided an in-engine screenshot of the D181 deterministic release-routing smoke **PASS** (36 cards, controlled Tier1 offer/choice, Fate Spread and boss XIII). Randomized multi-run offer frequency and any future regression test are separate; see `docs/HANDOFF.md`.

Historical planning/initial stat values remain intact at [D153 pre-cleanup archive](archive/2026-10-15-pre-cleanup/docs/DECK_EXPANSION_D153_THREADBARE_THEATRE.md). This current page supersedes staged/pending claims found in that historic version.
