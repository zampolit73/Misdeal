# Misdeal — Final five Wave 1 art production briefs

Date: 2026-10-13
Status: **story/composition directions approved through D130; clean standalone art NOT generated or integrated yet**
Dependencies: D123–D133, `docs/DESIGN_SYSTEM.md`, `scripts/ui/card_art_catalog.gd`, `scripts/ui/card_unification_v1.gd`.

## Purpose and absolute boundaries

Finish the last five of 13 D130-approved card art compositions after eight D131/D132 assets have been committed and D132 local display verified. These are **individual landscape paintings**, not a grid or concept sheet. Each future generation must target **exactly one subject**. Do not reuse/extract the low-resolution collage, do not repaint accepted live RunCards or events, and do not change interface layout. Art is for 608×388 WebP with an aspect around 1.57; generate at least 1216×776 (or higher) and scale down directly from individual master. No words, UI frame, border, watermarks, insets, duplicate figures, self-similar props, rifle/gunpowder weapons, or meaningless microdetail.

Aesthetic: dark-fantasy illustrated card art with tactile pixel-painted / deliberate brushed silhouettes, obsidian/chiaroscuro, aged bronze, moonlit steel, warm candle or ritual red focal light. Avoid glossy 3D photoreal CGI and cliché AI detail repetition; readable at 304×194.

## Separate art #1 — Knight Iron Oath

Live lookup key `knight_iron_oath`, destination `assets/pixel/card_unification_v1/upgrade/knight_iron_oath.webp`.

**One kneeling knight** wearing battleworn dark steel armor in an empty ruined chapel; the knight grips one long sword planted vertically in stone before him, head bowed in a solemn vow. A single cracked window sends cold moonlight across his silhouette while a small candle gives warm bronze-edged contrast. Intentional pose, plausible sword length and grip, readable closed contour. No crowd, clones, floating limbs, extra weapons or huge ornate details. D130 knight was black armored kneeling with sword, worn brass glow.

## Separate art #2 — Ranger Arrowstorm

Live lookup key `ranger_arrowstorm`, destination `assets/pixel/card_unification_v1/upgrade/ranger_arrowstorm.webp`.

**One hooded ranger** braced on a stone parapet in moonlit woodland, bow clearly drawn in a believable two-hand grip. Several arrows fly *away toward a distant target* along coherent trajectories, but no duplicate copy-pasted ranger figures, disembodied hands or physically nonsensical dozens of nocked arrows. Silhouette and fletching read at card size; cool green-blue light and one subtle warm ember highlight. No firearms, crossbows or crowds. D130 ranger was hooded bowman with distinct arrow trajectory.

## Separate art #3 — Mage Glass Heart

Live lookup key `mage_glass_heart`, destination `assets/pixel/card_unification_v1/upgrade/mage_glass_heart.webp`.

**One visibly older male Mage with a LONG GRAY/WHITE BEARD and weathered male face**, wearing dark violet/black robes, holding one large bright cyan crystalline glass heart between his correctly shaped hands. A handful of **distinct** jagged shards hover around it, no repeated concentric fake magic shapes, no extra fingers, no female mage. Background hints of dark ancient library/ruins, cool blue glass illumination with muted candle bronze. User explicitly corrected earlier female mage; this is binding in D130.

## Separate art #4 — Gold Windfall

Live lookup key `gold_windfall`, destination `assets/pixel/card_unification_v1/reward/gold_windfall.webp`.

**One weathered medieval wooden treasure chest open in a dark stone alcove**, containing a clearly readable but restrained pile of antique gold coins and a single larger embossed coin at focal point. Low warm candles and a cold blue shadow, no endless identical coins, random jeweled junk, text or extra treasure chests. Material should feel ancient, cursed and tactile, not brightly cartoonish.

## Separate art #5 — Relic Wager

Live lookup key `relic_wager`, destination `assets/pixel/card_unification_v1/reward/relic_wager.webp`.

**A single anatomically recognizable skeletal hand, made of finger and palm bones, visibly GRASPING and HOLDING one large faceted RED GEMSTONE (ruby)** above a dark stone pedestal. Every finger should read as bone and curl around the gem; no flesh, glove, cup, chalice, goblet, metal object masquerading as hand, extra fingers or repeated jewels. Strong deep crimson glow, small warm candles, nearly black background. User's last explicit correction to D130 was the skeletal hand holding the red ruby; do not deviate.

## Production/QA gate

1. Produce each individual art separately and show the exact unbordered master for user approval; DO NOT treat output that depicts the old four event scenes or a collage as valid.
2. Following approval, export **exactly** 608×388 WebP and upload raw binary assets to GitHub `main` under the paths above. `CardArtCatalog.get_upgrade_texture()` and `.get_reward_texture()` are already wired through `CARD_UNIFICATION_V1`; verify files are actually checked in, not merely copied into a ZIP.
3. Verify via `res://scenes/dev/card_unification_v1_preview.tscn` (F6) and relevant Reward/live card screens in Godot; original D130 atlas fallback remains valid for missing files.
4. Update `docs/VISUAL_ASSET_REGISTRY.md`, `docs/PROJECT_STATE.md`, `docs/SESSION_CHECKPOINT.md`, `docs/HANDOFF.md`, `docs/ROADMAP.md` and `CHANGELOG.md`; record a new binding art decision after actual user approval.
5. A prior image tool call on 2026-10-13 generated **the earlier four event scenes twice** despite instructions for these five new subjects. Both erroneous outputs were rejected and NOT integrated. The next generation must be narrowly anchored to just **one new named art** in the user's current request, and visually verified before generating the others.

