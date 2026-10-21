# D315 — Card DS3 actual repository audit (2026-10-21)

## Art direction: USER APPROVED (not a generated mockup gameplay specification)

The user explicitly selected the **first brighter black / vermilion / antique-gold DS3 Card Design System image**, requested **all** cards use it, and authorized direct GitHub implementation. Approved appearance:
- weathered black stone / obsidian, thin occult red astrolabe geometry, restrained red candles, lived-in dark-fantasy scene illustrations;
- worn, engraved **warm bronze-gold** front border, parchment ink-black uppercase title plate and dark readable effect text well;
- a distinct actual card-back with a gilded compass-ward; ornamental Roman numbering only where it is meaningful;
- real independent scene-specific illustrations in the same warm-red/black grade. No single baked whole-card mockup reused for different card text;
- preserve full Russian narrative text, authored art IDs, dynamic reward amounts and all gameplay/button interactions.

Approved designs are a **visual standard** across tabletop / reveal / Fate Spread / prizes. Never turn 12 Fate resolutions or the XIII boss seal into a larger number of selectable gameplay cards.

## Verified from GitHub `main` before this audit

On 2026-10-21, HEAD `a61934d6eecc245ddf0e83ff33d88c8267e22f54`, verified by GitHub files/tree, not an assumption:

| Surface | Actual entry point | Finding |
| --- | --- | --- |
| Physical card-front art | `assets/pixel/ui/card_ds3_locked/front_frame.webp` | **Exists** |
| Card back & dark substrate | `card_back.webp`, `ink_substrate.webp` | **Exist** |
| Shared style & grade | `scripts/ui/card_ds3_skin.gd`, `shaders/card_ds3_ink.gdshader` | **Exist** |
| Two live Table offer cards | `scripts/table/table_offer_skin.gd`, `table.gd` | **DS3 apply_table wired**, DS2 safe fallback |
| Back of undealt cards | `table.gd` | **DS3 apply_table_backs wired** |
| 12 Fate slots, XIII, held & discard | `scripts/table/fate_spread_overlay.gd` | **DS3 frame code wired** |
| Reward (three original buttons) | `scripts/reward/reward.gd` | **DS3 apply_reward and live labels wired**, DS2 safe fallback |
| All authored RunCardData | `resources/cards/*.tres` | **40 files** in `main`, gallery loads via resource directory |
| Upgrades & rewards | `scripts/ui/card_art_catalog.gd` | **9 upgrade / 6 reward illustration catalog IDs**, gallery includes them |
| Inspection gallery | `scenes/dev/d315_card_ds3_gallery.tscn`, controller | **Exists**, F6 scroll/inspect preview |
| Automated QA definition | `.github/workflows/d315-card-ds3.yml`, smoke script | **Exists**; CI success has **not** been confirmed. Commit-status returned no checks and GitHub Actions run listing wasn't available from the connector. |

### What "all" does and does not mean yet

The 40 existing `.tres` RunCardData, 9 upgrade and 6 reward art catalog keys **use the shared card frame through their relevant surfaces/gallery**, and the originals remain available. This is visual-skin/tonal-unification **not evidence that 55 distinct card illustrations have each been manually repainted in the selected palette**; the shared shader grades the independent original illustration. Do not claim otherwise.

**Still to verify or improve:**
- real Godot 4.7.x import/F6 screenshots: table, Fate Spread (future, revealed, held, discarded, XIII), multiple reward modes and all-40 scroll gallery; compare actual visual against approved first reference;
- other explicitly CARD-SHAPED inspection/reveal controls, beginning with `scripts/table/card_lore_inspect.gd`, which still has original freeform bronze picture mount;
- confirm actual proper card titles and complete effects at small, 272×338 and 88×126 screen sizes; do not bury live text under the front border;
- optionally redraw remaining original *scene illustrations* in deliberate individually approved batches if the shared grade cannot match the original art direction. This is distinct from simply applying a skin.

## Safe implementation sequence

1. **Verify existing D315 files**; lock above inventory and style decisions; preserve current `main` as checkpoint before extra edits.
2. **Finish remaining true card views** (inspection/reveal) using the shared front/back with real independent art and labels; do NOT skin non-card event choice buttons, Wizard character or whole background just because a menu has choices.
3. Add actual native Godot smoke coverage for Table, Fate Spread and lore-inspect (rather than gallery + Reward only), check missing portraits/title and button signals.
4. Ask user to run F6 full gallery `scenes/dev/d315_card_ds3_gallery.tscn`, then actual Table/Reward/Spread, and share screenshots. Art-direction approval is already recorded; do not make them re-approve each card with repeated micro-gates.
5. Update STATUS/HANDOFF with exact progress, not intent.

## Locks
- 12 Fate resolutions and one sealed XIII, original two tabletop offers, originally three Reward buttons/modes, authentic enemy/hero/art catalogs.
- DS2 prior checkpoint `checkpoint/ds2-pre-ds3-2026-10-20` (sha `4cbd206`); Battle DS3 approved checkpoint `checkpoint/battle-ds3-approved-2026-10-21` (sha `25878ca`).
- No change to game mechanics or auto-awarding; all decorations `mouse_filter=IGNORE`, original Button handles input.
