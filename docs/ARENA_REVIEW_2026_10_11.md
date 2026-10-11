# Misdeal arena review — 2026-10-11, redraw package 1

## Status: user-approved; ten arena backdrops integrated into GitHub/Godot runtime (local test pending)

The user rejected the prior package because backgrounds repeated excessive, implausible gothic castles and towers across the entire horizon. They marked the overbuilt landscape behind the original Gallows image with a red outline. The user explicitly asked to redraw all ten package-1 arenas from scratch, keeping the current Misdeal style rather than simplifying it.

In the current chat, ten newly generated visuals were produced and shown, plus one alternative for Bone Swarm. The images were assembled into a user-visible ZIP attachment named `misdeal_arena_redraw_pack1_review.zip` and a contact sheet `misdeal_arena_redraw_pack1_contact_sheet.jpg`. **Their 1280×720 production WebPs are now committed** in `assets/pixel/battle/arenas/arena_redraw_v2/`. The original 1672×941 PNG masters remain only in the conversation ZIP; restore them from the attachment for future recropping if required.

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

## Integration and next local validation

User approved all ten. `scripts/battle/authored_backdrop.gd` now maps these ten IDs to `arena_redraw_v2/{arena_id}.webp` with direct binary WebP loading. All ten committed files are 1280×720. No combat logic, stats, spawn paths, placement bounds or HUD code changed. `firing_square` and `bone_ritual` remain active on v1 until pack 2. Earlier v1 assets were not deleted.

After `git pull`, open several normal and expansion fights, including Bone Swarm and Warden; validate matching arena, unit contrast, placement vs visible walkable floor and full Fight execution. If specific floor mismatches occur, inspect screenshots and adjust only the affected arena/profile after discussion. This session did not run local Godot.

The earlier review-only source ZIP remains available in this conversation; unlike the original PNG masters, the ten runtime WebPs are now durable GitHub assets.
