# D183 — Black Crossing original combat sprite art gate

Date: 2026-10-15. **Card image user-approved in native Godot. Combat models are NOT approved or implemented yet.**

## Locked reference
D182 option 3 (diagonal collapsed pier) is the **approved** 448×274 card illustration, already in `assets/pixel/card_unification_v1/run/black_crossing_approved_v1.webp.b64`. Godot screenshot of `scenes/dev/black_crossing_card_preview.tscn` was supplied; user explicitly said «утверждено». Do not change or reinterpret the approved bitmap.

## New enemy visual identities
- `drowned_ferryman`: towering hunched **skeletal ferryman** in wet ragged charcoal cloak with restrained crimson tatters. Distinctive long **hooked boat pole**, not a bell, crown, scythe or Bone Shepherd crook. The hood partially hides the skull. One small warm amber lantern on the pier theme, without tiny noise.
- `drowned_hand`: smaller waterlogged dead person with torn soaked clothing, uneven shoulders, long reaching arms, scraps of riverweed or rope. Two copies appear in battle but require one original independently authored animated role, not borrowed generic skeleton or marionette art. Show knees/feet in all standing poses to preserve ground contact.
- Both roles must share readable **Misdeal combat pixel-art** language with existing approved 96px battle units, not detailed card-illustration cutouts. Dark silhouette separation against desaturated swamp stage. Combat direction source-facing right (Godot handles mirroring), scale consistent with existing role atlases.

## Next visual gate
Present several meaningfully different **combat-silhouette** options for both enemies before creating runtime atlases, then ask user which pair to use. Approval of the card illustration **does not** mean sprite silhouettes or animation production are approved.

Production gate after sprite choice: two independent transparent `576×480` WebP atlases (`.webp.b64` for Godot), 6 columns × 5 rows, `96×96` frame cells, each with real `idle4 / walk6 / attack6 / hit3 / death6` poses. **25 independently legible frames**, five empty unused cells, full feet, safe 2-pixel clear padding and no cropped poles/hands, distinct valid poses in final decoded WebP. **No automated duplication/filled holes.** First native F6 sprite gallery approval, then independent open-floor 1280×720 battle arena, scoped telegraphed push/slow wave, native 54-case battle QA and actual reward→table. Keep candidate `black_crossing` out of `CARD_PATHS` and `ACT1_CARD_IDS`; live Act1 stays **36/45**.
