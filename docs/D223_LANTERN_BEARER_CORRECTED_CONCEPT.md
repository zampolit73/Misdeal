# D223 — Lantern Bearer: correct shield + separate hand-lantern concept (USER ART APPROVED)

Date: 2026-10-17. Updated: **USER APPROVED D223 with «да все ок»; later selected D224 detailed 25-pose art with «подходит». D224 native atlas QA pending.** Live Act1 remains **37/45**, #38 `black_lantern_road` QA-only.

## Latest working context and purpose

The D220 five-enemy **style B** is the approved common visual language. D221 armored long-spear Road Sentinel detail illustration was explicitly user-approved («отлично»). D222 attempted **three** Lantern Bearer image panels but rejected all: each improperly added a pole/staff and mounted the lantern on the wooden shield, compromising the distinct role. The user asked «продолжай»; this D223 produces a NEW candidate that finally satisfies the two-hands/no-pole visual contract.

**Reference shown in conversation:** `Misdeal_D223_Lantern_Bearer_Concept_B_Portrait.png` (388×386 pixels), **SHA-256** `05eba5e00706e51abdab61d50026ca83bc38b5bfa421a68a4d53b9e995eff2cf`. The image is a **cropped character-only view** from the newly rendered style-B composition `a_dark_moody_concept_art_game_character_sheet_in.png` (1536×1024, source SHA-256 `6e1ea24aaffed172801318efbed7d0d1fecd7895001be04ba38e1d8957876298`), cropping source rectangle (388,45,776,431). This **conversation-visible preview is not yet stored as bytes in GitHub**, and cropped illustration includes the atmospheric forest background: it is not an alpha-transparent Godot sprite.

## What is now visibly correct

- Full-body wide, thick-boned, hunched **defensive skeleton** with cold bone and weathered iron armor, subdued faded oxblood/ragged cloak, readable feet.
- **One hand** carries a broad crooked wooden barricade built of planks and iron bands (forward defensive silhouette; no weapon shaft).
- **The other hand** visibly holds a **separate heavy iron-framed glowing amber lantern** by its short hanging top handle (freehand, not screwed to the board).
- **NO spear, long staff, pike, halberd or axe**. Does not duplicate D221 long-spear Sentinel; markedly smaller than Guide and broader than oil servant/archer.
- Appropriate cold blue-black moonlit mood with muted amber as one accent, consistent with approved D220 B art direction; previously accepted D209 ORIGINAL backdrop is still separate and unchanged.

## Quality gate and next action

**D223 ART DIRECTION ACCEPTED**: user replied «да все ок». A new detailed 25-pose sheet was subsequently generated and user explicitly chose it with «подходит». The approved source has been preserved losslessly in GitHub and its first 576×480 repack staged in an isolated QA F6 scene; see `docs/D224_LANTERN_BEARER_APPROVED_ART_QA.md`. Actual native animation approval and production registration are still pending. Required actual in-game source atlas remains exactly **576×480, 6×5×96px, 25 meaningful distinct cels + 5 fully transparent** in per-animation rows: idle4+2clear, walk6, attack6, hit3+3clear, death6. True alpha-safe 2px margins, no clipped board/lantern, boots grounded, full-body defensive walk, **shield bash, not spear thrust**, believable death; verify 1× native readability on EXACT D209 approved arena, native F6 animation gallery, and all-five lineup before registering final production assets. Current D216 simplified shield-bearer sprite remains a technical QA temporary candidate.

Neither D223 concept nor prior D222 boards have been transferred into production sprite library, no Godot scenes/UnitData/encounter mechanics/live card count changed. User requested final replacements for ALL FIVE characters before card #38 release (D220), preserved. Frozen branch `backups/KARAMBA73-2026-10-16` untouched. See D214, D220–D222 and `docs/HANDOFF.md`.
