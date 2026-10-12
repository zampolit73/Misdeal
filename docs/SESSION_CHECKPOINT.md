# Misdeal — Current Session Checkpoint

**As of:** 2026-10-12 (user confirmed local visuals)  
**Branch:** `main` in `zampolit73/Misdeal`  
**Read first:** `AGENTS.md`, `docs/CONCEPT.md`, this file, `docs/PROJECT_STATE.md`, `docs/ROADMAP.md`, `docs/DECISIONS.md`, `docs/HANDOFF.md`, `docs/DESIGN_SYSTEM.md`. GitHub is source of truth for code and implemented features.

## Game and visual baseline

Misdeal is a Godot 4.7.x / GDScript dark-fantasy card-driven roguelike with a compact tactical autobattler. The evil Wizard hosts a cursed tabletop. Act 1 uses a twelve-position **Fate Spread** plus central Bone Warden XIII. The player begins with one protagonist (Knight, Ranger or Mage), with other companions recruitable or permanently lost.

**Do not redesign or recolor** the user's favorite, approved **Fate Spread Variant C**. The approved **Design System 2.0** borrows its material vocabulary: blackened wood/obsidian, worn bronze, blood-red ritual markings, parchment cards and candlelight. Design decision: **D123**. Keep gameplay, card outcomes and existing approved art unchanged unless requested.

## Latest user acceptance — live Whispering Well

The user approved the production `ШЕПЧУЩИЙ КОЛОДЕЦ` look in local Godot after the centered-card-row fix `1adc634`. Their direct feedback was **«без скрина все хорошо»**. This is a **visual acceptance**, recorded in **D126**; do not request another screenshot simply to reconfirm it or keep fine-tuning without a reported issue.

- Production files: `scripts/event/whispering_well.gd`, `scenes/event/whispering_well.tscn`
- Approved three DS2 choice cards: blood, 25-gold coin, refusal; approved original art, framed parchment, top counters and warnings
- Final row fix: make all Button minimum widths **292px** before sizing the `HBoxContainer`, `BoxContainer.ALIGNMENT_BEGIN`, then apply a centered **928px** row at x=176 for the 1280px reference viewport; second rescue-result line and disabled-gold warnings now fit
- Original seven event decision/art/route methods remained unchanged after alignment source check
- **Still unverified in aggregate:** every gameplay branch (blood scar, paid rescue, refusal, revisit for relic/upgrade/refund and return-to-table). Keep these as separate functional smoke tests, not a blocker for the next design preview.

Other protected milestones: **D124** accepted the **production Reward major-upgrade** presentation (three cards). **D125** approved the Whispering Well design-preview direction and scoped migration; **D126** supersedes older notes that say its visual alignment still needs checking. Other Reward modes (ordinary loot, bonus upgrade, Death Wager, elite reward) still merit gameplay QA.

## Exact next task — Design System 2.0 Gravedigger Shop preview

**Next work is not yet implemented.** Create one isolated, non-gameplay **F6 preview** of the **Магазин могильщика** using existing art and DS2 material helpers. Show three purchasable role-upgrade cards (Knight, Ranger, Mage) with clear price/disabled affordability presentation, and a safe leave option. Use 1280×720. Ask the user to visually approve it **before** touching production presentation.

**Important architecture:** the shop is the `gravedigger_shop` branch in shared `scripts/event/act_choice.gd` / `scenes/event/act_choice.tscn`, **not** a dedicated scene. These resources also serve many unrelated events. Current shop setup lives in `_configure_shop()`. Any future live migration must be guarded explicitly to the shop card (`active_card.card_id == "gravedigger_shop"` or equivalent existing check), never applied to the full shared ActChoice UI.

Preserve all existing rules:
- `RunState.get_gravedigger_shop_price()` and Lost Purse history-adjusted price
- Correct party-role upgrade offers, affordability/disabled logic and gold deductions
- Existing selection, purchase, return-to-table handlers and persistence
- Original Fate Spread and accepted Reward / Whispering Well visuals

After isolated preview approval: implement a narrowly scoped production shop style pass, run local Godot QA, update `PROJECT_STATE`, `ROADMAP`, `HANDOFF`, `DECISIONS` if an additional binding decision is warranted, and `CHANGELOG`.

## Local developer workflow

User runs Godot locally and pulls GitHub commits with `git pull`. Connected GitHub tooling can edit/commit directly: **do not ask for GitHub access repeatedly and do not make the user copy patches manually**. Use Godot 4.7.x and GDScript, prioritize playable vertical slice and data-driven resources. No additional gameplay/art changes were requested with this handoff.
