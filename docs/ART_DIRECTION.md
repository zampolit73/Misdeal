# Misdeal — Production Art Direction

This document defines the production visual target for the vertical slice.

Existing generated illustrations can remain useful composition references, but player-facing art should converge on an authored low-resolution pixel-art language.

## Core target

- Large readable silhouettes before surface detail.
- Quiet negative space around focal subjects.
- Limited recurring color roles.
- Restrained, motivated lighting.
- Repeated world symbols with explicit meaning.
- Nearest-neighbor presentation.
- No detail added only to fill empty space.

## Palette roles

- Ink: near-black violet / brown-black.
- Stone: desaturated slate and cold gray.
- Bone: dirty beige for highlights and undead material.
- Rust: blood-red / oxidized orange for danger and Wizard pressure.
- Teal: rare supernatural accent.
- Gold: scarce reward / contract accent.

Strong saturated colors should communicate a gameplay or narrative role.

## Lighting

- Prefer one dominant light source and at most one secondary source.
- Avoid arbitrary rim light around every silhouette.
- Glows must have a visible source.
- Large dark areas are desirable.
- Important objects must read through silhouette and value before glow.

## Detail

- Do not texture every surface evenly.
- Backgrounds may contain large calm masses.
- Ornament is allowed only when it reinforces a known Misdeal symbol.
- Avoid meaningless pseudo-runes, pseudo-lettering and filigree.
- Chains, doors, weapons, tables and architecture should obey simple readable construction.

## Recurring symbols

Use a small repeated vocabulary: Wizard seal, debt mark, wager/contract mark, bone knot, chain and broken crown.

## Characters

Knight, Ranger, Mage and current enemy roles keep stable silhouettes and proportions. Combat sprites remain cleaner and simpler than card/event illustrations.

## Large scenes

Large table / arena / event backgrounds should behave as if authored around 640×360 and then presented at 1280×720. Physical asset resolution may remain higher when required by the runtime, but detail density should stay low and intentional.

The shared production grade compresses saturation, remaps values toward the Ink / Stone / Bone range, preserves Rust / Teal / Gold accents, reduces smooth gradients and reinforces pixel clusters. It is a consistency tool, not a replacement for redrawing malformed geometry.

## UI and cards

Gameplay values and mutable text remain live Godot controls. Card art should have one obvious focal subject. Borders and glow communicate state rather than decorate every card equally.

## First reference surfaces

1. Wizard table backdrop and table-card art.
2. Authored battle backdrops.
3. Whispering Well choice art and environment.

After local review, this language can be propagated to the remaining events, rewards, intro and main menu.

## Rejection test

Rework an asset if several of these are true:

- every part of the frame is equally detailed;
- architecture or props do not make physical sense;
- the image relies on several unrelated colored glows;
- ornament has no world meaning;
- silhouettes are unclear without lighting effects;
- it reads as generic dark fantasy rather than a specific Misdeal location;
- it only becomes pixel art after downsampling a painterly image.

## First true replacement

**КОСТЯНАЯ ДАВКА** is the first arena source replaced under this direction rather than merely graded. It should be used as the first runtime reference for desired background detail density: large floor masses, simple construction, restrained light sources and physical placement marks that belong to the arena.

## Local review findings — 2026-10-08

The first shared grade improved consistency but did not solve source-image composition. Use these findings when judging the next assets:

- A shader can unify palette, but cannot fix equal-frequency detail, impossible geometry or decorative clutter.
- Avoid the “gothic cathedral made of candles and bones” default. Fewer props and clearer construction are preferred even when the result is less spectacular.
- **Gallows Volley** is currently closer to the target than the ossuary-style arenas because it contains larger calm value masses.
- Preserve enough midtones that small wager/card art remains legible.
- Deployment affordances should look physically painted, scratched or inlaid into the floor, not like debug rectangles.

### Bone Crush production blueprint

Treat the approved in-chat redraw as the benchmark composition:

- 1280×720 runtime backdrop, but with detail density closer to a 640×360 authored source.
- One central rear focal point: throne/statue/warden silhouette on a short stair.
- Two dark stone side structures framing a large empty central combat floor.
- Two restrained vertical rust-red banners.
- Four to six motivated flame sources total, not dozens.
- Bones/rubble only along edges and wall bases; keep the playable floor mostly quiet.
- Central ritual circle is simple, readable and geometrically consistent.
- Two legal deployment bands are represented by worn stone inlays / scratched ritual lines; gameplay still owns the actual collision rectangles.
- No heroes, enemies, HP bars, tactical buttons, labels or other live UI baked into the backdrop.

### Card-art direction after arenas

For cards, prefer one readable subject over a miniature landscape:

- **ГРЕМУЧИЙ МОСТ**: bridge silhouette, abyss and moon / cold sky; remove incidental clutter.
- **КОШЕЛЬ МЕРТВЕЦА**: large purse + skeletal hand/bones + a few coins; avoid a whole graveyard scene just to communicate “purse”.
- Other event/combat cards should follow the same object-first test: the subject must still read at table-card size without zooming.
