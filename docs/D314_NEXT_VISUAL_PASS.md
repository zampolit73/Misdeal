# D314 — Battle DS3 signed off; next visual screen: Reward (2026-10-21)

## Binding user decision

After D313 Wizard reward label placement fix, user explicitly stated: **«давай закончим. утверждаем. Перейдем мб к другим визульным улучшениям?»**. This **accepts the Battle DS3 screen as the project's current visual baseline** and ends the repeating Battle art-polish cycle. Do not require another screenshot or another art-approval gate for D313 just to consider it shipped aesthetically. Further battle edits should be actual bug fixes or a later explicit user decision.

**Freeze point:** `checkpoint/battle-ds3-approved-2026-10-21` at commit `25878ca7023874e9ca96f412470241cc5496b775`. Existing DS2 global rollback checkpoint `checkpoint/ds2-pre-ds3-2026-10-20` at `4cbd206` is unchanged. No final native Godot 4.7.x automated CI PASS or user screenshot *specifically after D313* was observed. That is a factual QA caveat, **not a reason to ignore the user's explicit artistic approval**.

Battle visual components are D303 complete painted command/fight modules plus D311 third Wizard medallion, D312 dynamic text hierarchy and D313 inlay bounds. Keep actual 3–5 tactics, target controls and placement, hero/enemy sprites, arena locations, progress cards and combat state intact.

## Recommended next visual milestone: Reward DS3

**Why now:** in the vertical slice, Victory -> Reward -> cursed tabletop repeats often. Production `scenes/reward/reward.tscn`, `scripts/reward/reward.gd` currently have a **working DS2 material skin** with tabletop backdrop, three real reward buttons, live illustrations, title/effect/description, and real states. Despite functioning, its panels are still predominantly `StyleBoxFlat` / procedural material frames, visually less richly painted than approved D303 Battle. The real `scripts/reward/reward.gd` has multiple modes: `major_upgrade`, `bonus_upgrade`, `normal_loot`, `death_wager`, `elite_artifact`. Do not replace them with a generic fake three-card mechanic.

Suggested **art-first** exploration, showing actual 2–3 meaningfully different **Reward** screen references before code migration:
1. **Cursed loot coffer** — three physical reward cards laid on a small open relic chest/table, candlelit bronze dividers.
2. **Wizard's prize offer** — blackwood tabletop and Wizard's gloved hand physically presenting three distinct cards, a restrained wax-sealed title.
3. **Spoils of the battle** — three small reliquaries under antique bronze recessed card holders, matching the existing cursed table material language.

The reference should improve material unity without changing reward counts/modes, descriptions, upgrade stats, relic chances, animations, real click/hover selection or return to table. New art modules must be separately drawn, text-free transparent/solid foundations and then composed under real Godot buttons and labels; avoid repeating Battle D298–D301's mistake of excessive flat procedural frames. Keep Fate Spread Variant C approved artwork **untouched**.

## Proposed work plan

1. Create visual baselines from current Reward F6/test screen and production Reward scene; check art catalog and actual three live Button geometry.
2. Show user 2–3 image concepts (this is a **new screen**, so user chooses an art direction); no unapproved auto-rollout.
3. After art choice, isolate independent proper-resolution panel/card-holder modules and commit binaries via connected GitHub, preserving names and imports.
4. Add an opt-in Reward DS3 presentation helper/preview scene, don't globally switch the UI kit; verify actual reward modes and Battle->Reward->Table in native Godot.
5. Present actual 1280×720 Reward screenshot to the user. Lock Reward only after explicit screenshot acceptance.

Alternative future visual targets: Gravedigger Shop DS2, ClassSelect DS2, Squad Dossier, RunEnd and optional ActChoice. Art-first Reward has the clearest near-term payoff.
