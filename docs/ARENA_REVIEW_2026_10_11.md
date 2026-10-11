# Misdeal arena review — 2026-10-11, redraw package 1

## Status: ten new visual concepts generated, NOT APPROVED, NOT INTEGRATED

The user rejected the prior package because backgrounds repeated excessive, implausible gothic castles and towers across the entire horizon. They marked the overbuilt landscape behind the original Gallows image with a red outline. The user explicitly asked to redraw all ten package-1 arenas from scratch, keeping the current Misdeal style rather than simplifying it.

In the current chat, ten newly generated visuals were produced and shown, plus one alternative for Bone Swarm. The images were assembled into a user-visible ZIP attachment named `misdeal_arena_redraw_pack1_review.zip` and a contact sheet `misdeal_arena_redraw_pack1_contact_sheet.jpg`. **These source images are currently conversation artifacts, not committed GitHub assets.** New chats must not assume those images exist inside the repository; obtain/attach the ZIP again before integration if needed.

## Concept manifest

| Arena ID | Compositional landmark |
| --- | --- |
| `gallows` | One castle on a distant cliff above river valley; wooden gallows in foreground |
| `crypt` | Sealed, monumental double door with cold light, enclosed chamber |
| `graveyard` | One small chapel and a single enormous dead tree in a moonlit cemetery |
| `ossuary` | Ossuary niches on a single rear wall; one central carved funerary shrine |
| `warden` | Dark crimson-lit throne room with one massive skeletal throne effigy |
| `bone_crush` | Underground stone-crushing wheel and timber mineworks, no castles |
| `bone_swarm` | Natural cavern with one huge buried rib cage and skyshaft; two variants made |
| `grave_crossfire` | Muddy rural crossroads, a single stone watchtower and farm shelter; hills instead of skyline |
| `iron_wall` | Closed iron portcullis, chains, forge/furnace, enclosed fortress yard |
| `last_bell` | One immense cracked bell in a ruined single belfry, foggy sunset river plain |

Review goals: one legible landmark per arena; believable geography; dark-gothic painterly/pixel-inflected Misdeal visual language with blue-black midtones, warm fire and selective crimson; clean playable center; no cloned castles/towers; no baked HUD or player/enemy units. Avoid repeated symmetric candles, banners, and floor sigils becoming a new visual cliché.

Each generated original was 1672×941 PNG, with an additional export resized/cropped to 1280×720 WebP (Godot-ready only after artistic and floor/bounds approval).

## Next action

Wait for the user's approval or new criticism of this package. On approval, add the selected actual image files to a permanent source archive in GitHub, then integrate the ten production exports using the current verified `AuthoredBackdrop` pipeline, leaving combat/spawn/tactics rules untouched. Update `docs/VISUAL_ASSET_REGISTRY.md`, `docs/PROJECT_STATE.md`, `CHANGELOG.md`, and `docs/HANDOFF.md` with precise paths and validation status. Do not commit placeholder binaries or pretend concept assets were already integrated.
