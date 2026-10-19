# D261 — Approved second illustration for card #39 «СУД БЕЗМОЛВНЫХ»

Date: 2026-10-19. **Design: A «Суд безмолвных» selected. Visual: SECOND of three final portrait options selected, explicitly confirmed by user with «второй мне подходит арт».** No second/new art generated after this approval.

## User-approved exact source

- The selected **second** of three last rendered 1086×1448 portrait illustrations shows a frontal skeletal magistrate behind his ruined bench, thin parchment-wrapped ash scrivener with book/quill to the right, paired bone bailiffs with heavy shields/hooks at both sides, broken giant weighing scale and funeral banners above them. Preserve these exact enemy identities, materials and cardinal composition. This is **NOT** the first or third rendered image.
- Chat image snapshot: `мрачный_трибунал_у_трона_смерти.png`, 1086×1448 RGBA/RGB appearance; source SHA-256 `3b1abff4c637cb9fd1e862dde8210652b008f48f6d9024aa796fc2c7a67db2ea`. Original source is a generated chat attachment, not a GitHub bitmap; preserve the original project chat for source recovery. Do not substitute a freshly generated similar picture.
- **Live QA export committed on GitHub main:** `assets/pixel/card_unification_v1/run/court_of_the_mute_selected_v1.webp.b64`. Source-derived **exact rectangular crop** `(left=0, top=222, right=1086, bottom=886)` preserving the center figures and recognisable weighing scale; LANCZOS resize to **448×274**, WebP quality 82 with no restyling, repainting, generative inpainting, or UI/text. GitHub WebP binary SHA-256 **`704eef553a1ef528d2793b692462315048b06cf23ddaf17dff0c1fba0ed69d5c`**, 33,294 bytes. Source files retained as generated conversation imagery, original layout not replaced in GitHub by another portrait.
- The crop passes actual Godot 4.7.2 decoding, image size and card catalog/art-resource preview tests via [D261 CI run](https://github.com/zampolit73/Misdeal/actions/runs/39212443418), including exact raw WebP SHA test: **PASS**.
- **F6 user review:** `res://scenes/dev/court_of_the_mute_d261_card_preview.tscn`. Uses the original game `scripts/ui/card_art_catalog.gd` and `scripts/ui/card_unification_v1.gd` loader; shows 448×274 and the QA card description. Preview successfully loads headless; this is not an independently inspected GUI screenshot.

## Nonreleased addressable card

A new `resources/cards/court_of_the_mute.tres` (Tier 1, combat), and `RunState.CARD_PATHS["court_of_the_mute"]` were staged **only for QA**. Its `target_path = ""` intentionally prevents routing to a fake/stale combat. `RunState.ACT1_CARD_IDS` remains at **38/45**, with `court_of_the_mute` **NOT present**. A strict art-loader branch in CardUnification returns an error on missing/corrupt chosen WebP and never borrows another battle card illustration. Existing 38 cards and normal screen styles unchanged.

## Next D262 work (batch-first)

1. Establish a truly original **underground tribunal arena** that reproduces the source's stone bench, giant scales and actual walkable floor; no free-floating or background sprite mockups.
2. Prepare three DISTINCT combat roles with full original **25-frame 6×5 96px atlases in a complete work batch**: `mute_magistrate` (sealed-face towering judge/staff); `ash_scrivener` (quill+ledger/telegraph), `bone_bailiff` (hooked halberd+heavy square shield; two instances). All roles must have visible feet, real prop grips and target-facing motion. Do not ask for every separate state confirmation; QA one complete 3-character gallery in Godot.
3. Encounter-local `verdict_target`: a visibly telegraphed red wax mark on one hero and temporary bailiff targeting preference, without universal stun or guaranteed hits; counterplay through existing tactical formation/targeting/kill scribe. Use existing Godot/GDScript data-driven API, not global edits to combat.
4. Only once new art, mechanic, 1/2/3 party-size balance, **54-case tests**, genuine Battle→Reward→Table, card artwork and arena native QA pass should #39 be added to `ACT1_CARD_IDS` (39/45) in a separate intentional release commit.

**Unchanged:** D260 card #38 RELEASED, 38/45 Act1 cards, user-approved prior visuals, DS2/Fate Spread 12+boss XIII, frozen `КАРАМБА73`. The unrelated legacy `approved_battle_direction.jpg` import error may still appear in editor logs and was not introduced here.
