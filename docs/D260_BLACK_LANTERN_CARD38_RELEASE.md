# D260 — RELEASED: Road of Black Lanterns (#38/45)

**Date:** 2026-10-19. **Branch:** `main`. **Status: RELEASED, headless native deal → Battle → Reward → Table PASS.**

## Release decision

User response `«Все ок»` after D259 staging was a no-blocker acceptance to proceed to the previously announced local balance and #38 release stage. The user had previously approved the original five distinct skeleton identities, D200 chosen card illustration, D209 forest battlefield, and D255/D257 three rich character directions. No claim is made that every pose was independently video-reviewed; original D257 machine warnings about 11 lower-source crop sites remain as historical art QA findings. Do not disguise these as resolved artwork from a pure frame export.

**D260 decision:** Keep the authored five-enemy stats and encounter-scoped moving lanternlight multiplier **1.16×**. The prior D208 attempt at 1.22× did not materially improve combat outcomes. Under normal solo/duo/trio compensation, new Godot 4.7.2 pre-release **54/54** deterministic functional cases produced:

| Party size | Wins | Mean hero remaining HP | Lowest hero remaining HP | Mean fight duration | Individual fallen heroes |
|---|---:|---:|---:|---:|---:|
| Solo | 18/18 | 79.69% | 52.95% | 13.19s | 0 |
| Duo | 18/18 | 69.23% | 29.79% | 14.63s | 2 |
| Trio | 18/18 | 74.55% | 44.07% | 13.53s | 4 |

The earlier tested D153 average remaining HP (74/67/74%) was close; these are short, survivable but consequential fights. No full-party defeats in 54 fixed scenarios does NOT establish perfect challenge across builds, difficulties and live runs. **Approve as first-release baseline, not a permanent tuning lock.** Follow-up user play can trigger a narrow adjustment if needed, preserving solo accessibility. After card release a separate Godot matrix CI also PASS 54/54; exact attack counts and some HP fractions vary slightly between runs and must not be presented as deterministic beyond tested outcomes.

## Technical work

- **Deliberate release commit:** [0d316dcd](https://github.com/zampolit73/Misdeal/commit/0d316dcd07fc72c1dff1752fc6adc72c172a4bc9) added `black_lantern_road` to `RunState.ACT1_CARD_IDS`, increasing normal Act 1 pool **37→38/45**. Encounter is Tier 1 and its `target_path` already points to `res://resources/encounters/black_lantern_road.tres`.
- Five unique 25-authored-frame enemies are loaded by the **unchanged real BattleUnit** through strict `MisdealUnitAnimationLibrary`, without temporary sprite swaps. D259 converted original D257 Guide/Oil/Archer runtime art retains the user-approved silhouettes and standard 96×96 cels; original accepted D244 Sentinel/D224 Bearer byte-equivalent.
- **Both real enemy formations** and encounter-scoped D253/D206 2-zone travelling light preserved. No generic HP/damage scaling change; no Fate Spread, 12-resolution + boss XIII, DS2, rewards or other encounter mechanic changed.
- Updated the original 54-case matrix contract to assert **38/45 live**, and relabelled the diagnostic scene as D260. D260 native Godot F6 preview `res://scenes/dev/black_lantern_d260_released_battle_preview.tscn` lets the user immediately select party size and March/Crossroads formation without waiting for random dealing. Its actual Battle/Reward/Table path still comes from normal project scenes.
- `scenes/dev/black_lantern_d260_release_route_runner.tscn` and companion observer are **headless CI only**, deliberately no user-facing presentation. They confirm release via the ordinary `RunState.get_offer_cards()` / `choose_card()` route with a *controlled Tier 1 eligible subset* so the particular card is guaranteed to appear in a short test. This verifies true deal/selection code, not its statistical draw frequency in unmodified long runs. They then instantiate actual Battle with five exact original library sprites, click real Fight, win, Continue, claim Reward and return to Table, confirming `black_lantern_road` resolved.

## Verified GitHub Actions runs

1. [D260 pre-release balance diagnostic, Godot 4.7.2 PASS](https://github.com/zampolit73/Misdeal/actions/runs/39207190779) — full metrics above, zero contract failures.
2. [D260 released native real-deal and end-to-end smoke PASS](https://github.com/zampolit73/Misdeal/actions/runs/39207610574) — 38-card pool, real Tier 1 offer + choose, Battle, all five original roles, win → Reward → Table.
3. [D260 released preview + end-to-end rerun PASS](https://github.com/zampolit73/Misdeal/actions/runs/39207937827) — extra released F6 preview parser/run check and repeat real route.
4. [D260 post-release 54-case diagnostic PASS](https://github.com/zampolit73/Misdeal/actions/runs/39207937886) — 54 wins, 0 timeouts; mean HP ~79.5%/69.4%/74.4%, 0/2/4 individual fallen heroes, duration ~13.2/14.6/13.5s. Exact random effects differ slightly; use metrics ranges, not bitwise identity.

**Headless navigation caveat:** only the external QA driver pumps a synthetic `RenderingServer.frame_post_draw` signal because native Godot SceneTransition waits for a frame rendered to screen. The shipping transition code is unchanged. This validates navigation and data, **not the rendered visual appearance of all game frames**. User reported no D259 blockers but future visual issues should be fixed from actual Godot F6 evidence.

**Known unrelated issue:** Godot editor import still logs an error for `res://assets/concepts/approved_battle_direction.jpg` (legacy concept image; no unapproved asset replacement). Older D258/D259 QA scenes hardcode `37/45` as intentional unreleased-stage historical checks; they are not the current post-release scene. Use D260 scenes for current tests.

## Next planned stage

**D261**: start the next Act 1 card (#39) as a distinct encounter or event, first validate the desired mechanical/design direction with user and show **2–3 genuinely distinct art options** before choosing or replacing card art (AGENTS.md D168). No fundamentals change without discussion. Remaining future Act 1 cards: **7 of target 45**. In a parallel polish pass, fix the unrelated legacy JPG import only after tracing whether referenced and without replacing approved art.

## Final handoff

Official released card count **38/45**. All five original sprite identities, D200 card artwork, D209 arena, 1.16× lanternlight mechanic, solo/duo/trio balancing, standard Battle → Reward → Table and combat bounds remain. **Frozen KARAMBA73 backup untouched**. Start a new chat by checking `AGENTS.md`, `docs/CONCEPT.md`, `docs/PROJECT_STATE.md`, `docs/ROADMAP.md`, `docs/DECISIONS.md`, and this document.
