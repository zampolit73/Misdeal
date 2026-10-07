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
