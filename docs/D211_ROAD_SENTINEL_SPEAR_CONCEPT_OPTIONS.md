# D211 — Road Sentinel spear silhouette options (concept gate, NOT engine art)

Date: 2026-10-17. Status: **USER SELECTED OPTION A — armored spear Sentinel silhouette LOCKED; production sprite NOT YET MADE.** Normal Act1 cards remain **37/45**, #38 unreleased. No new character atlases, battle scripts, unit loader, card routing or frozen backup changed.

## Why D211 is a concept step, not fake production completion

The five D205 5×5 art concepts were inspected in D210; `road_sentinel` wielded an axe instead of its D199 LOCKED LONG SPEAR, had 24/25 source grid-border contacts and 96px cell-fit problems. User requested continuation, so this pass produced two **different visually illustrated spear guard silhouettes** and cropped the standing figures out of generated *presentation/concept sheets*. The larger generated sheets themselves **are not correctly authored source atlases** (contain labels, layouts, unstructured miniatures, backgrounds, mis-specified frame counts), and **must never be wired into MisdealUnitAnimationLibrary**.

The exact cropped options are in conversation:
- **A — Armored Spear Guard:** `d211_option_A_crop.png` from `a_dark_moody_pixel_art_concept_sprite_sheet_style.png` (350×223 crop). Heavy bone-and-metal pauldron, low aggressive feet-apart posture, diagonal long spear and small hanging lantern. Distinct from the towering Guide and from the board-bearing Lantern Bearer; **proposed favorite for next illustration pass**.
- **B — Hooded Road Warden:** `d211_option_B_crop.png` from `a_wide_dark_pixel_art_concept_sheet_sprite_shee.png` (410×319 crop). Ragged hood/cloak, long upward spear and small suspended lantern; potentially too similar to cloaked Guide, not automatically approved.
- **Comparison + honest native-grid check:** `Misdeal_D211_Road_Sentinel_Concept_Options.png`, 1320×740. Both concepts shown enlarged and in a **96×96 bounding-cell preview**. These scaled previews reveal that keeping a long diagonal spear inside a native 96px cell makes the skeleton smaller than desired.

**Neither is a usable production sprite**, and neither has isolated RGBA transparency: both include dark reference backdrops. No authentic per-state pose animation has been produced in D211. The two concept crops are **conversation-only**, not GitHub runtime assets. Do not label any option "final" until user selection, new 25-frame original pixel production and Godot native QA.

## Next decision and hard animation constraints

**User explicitly replied «а» to A/B review. Option A is therefore selected; do NOT ask again or substitute hooded B.** This accepts the armored long-spear direction ONLY, not the image crops as atlas cels or a Godot-native sprite.

After user selection, paint an ORIGINAL full-body pixel spearman for Misdeal, preserving user-chosen silhouette but **angle spear more upright / tighten hand grip** to fit a 96×96 cel *while keeping skeletal height legible*. Make **25 purposeful, individually distinguishable poses** in exactly 576×480 RGBA 6 columns × 5 rows:
- idle 4, walk 6, attack 6, hit 3, death 6;
- five transparent unused cells;
- near-fixed boot baseline y=87..94;
- no cut spear tip, cloak, limbs, lantern strings, no overlaps at cell margins; all poses must read as one rig/faction;
- spear thrust is genuinely readable on attack poses, not axe art repainted as a spear;
- no repeated/retimed static cels or rubbery fake limb-wobble;
- use the **exact approved D209 third forest art** and three-versus-five encounter for visual native F6 review before making this new `road_sentinel` sprite available in any battle.

If source generation cannot reliably create original 25 clean cels, keep art blocked, do not manually fake battle sprites. Use the artist D210 gate in `docs/D210_BLACK_LANTERN_ANIMATION_ART_QA.md`.

After Road Sentinel visual choice/production, continue Bearer defensive board, Acolyte oil flask and sickle, Guide truly 2× authored large skeletal shape, Archer bow/lantern. The selected D200 card picture, D209 arena, D196 sea wave and immutable `backups/KARAMBA73-2026-10-16` remain untouched.
