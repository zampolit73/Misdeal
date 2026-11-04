# D392 — Approved C3 hero art: isolated pose and scale QA

Date: 2026-11-04

## Design approval

User approved first rich C3 direction with one wardrobe correction, then explicitly approved revised trio:
- Knight: heavy dark steel, sword and red heraldic shield, **torn burgundy cape only for him**.
- Ranger: human hunter, realistic bow and quiver, **whole olive cloak with clean hem**.
- Male Mage: dark violet layered robes, staff, **whole finished robe and cape**, small restrained cold blue light.

This approval is **character visual design** only. It is NOT approval of alpha extraction, 96px production sprites, or 25-frame animation packs.

## Source provenance / what is staged

The last high-resolution 1672×941 three-hero illustration appears in this conversation and is the painterly reference. The entire high-res illustration is NOT committed as a repo source asset. D392 crops the three distinct figures from it and applies a local foreground mask at original image resolution; masks are imperfect around very dark hems and prop edges. The experimental downscale packs each into a 128×128 alpha cell; all three are encoded in a **384×128 WebP** at quality 72 for small-source QA, version-controlled as text at `assets/pixel/units/hero_c3_keyposes_qa/c3_d392_rich_128.webp.b64`. It is not a true source-pixel-authored native 128px sprite and it is **not** an animation frame sequence. Original extracted 128px figures are **NOT** guaranteed to be better than the currently shipped characters; look for halo/matte remnants, clipped fine details, inaccurate soles, bow or staff grip.

Binary check against locally prepared WebP: SHA-256 `8a36bbfa6df99c7228e9e80f98e8b9f1fb56ffec34bfffb3a2b841884d0ac2ea`; Base64 text 16,352 characters; 384×128 RGBA atlas, opaque alpha content between roughly 37% and 47% per cell. This is an experimental proof of source appearance, not preservation of all high-resolution details. No podium, painted labels, or setting was intentionally kept in the alpha file.

## Actual F6 comparison

Open `res://scenes/dev/d392_c3_hero_art_preview.tscn`. It places each live existing BattleUnit at the left of its C3 study on the actual approved Firing Square floor with aligned contact y455, no changes to actual BattleUnit loader. At launch C3 uses its **128px source cell at 1×**, and the button switches to an **approximate 96px display by scaling the 128px source to 0.75×**. The second mode is a simulation, NOT a true authored 96×96 source sprite or an approved new animation format.

Inspect in Godot at 1280×720 both button modes. Art acceptance questions: Is the Knight shield/helmet/boots intact; is the torn cape only his; does the Ranger have an uninterrupted hem and a recognizable bow/string/legs; can the Mage staff/orb/hand/robe read on the torchlit stone? Which variant actually matches existing characters more closely at true gameplay view? Reject if cutouts have dark halos, flat coloration, or lost fingers/feet. Bring one screenshot of each button mode only if needed to discuss flaws.

GUT `tests/unit/test_d392_c3_hero_art_preview.gd` validates WebP decode, dimensions, nonempty partially transparent cells, padded bounds, art preview contact and scale toggle. CI does NOT decide visual success.

## Art delivery gate

Keep all currently shipped hero sprites, animation library, combat mechanics, wave arenas, DS3 and enemies untouched. Native animation contract remains **25 original authored distinct frames per hero at 96px per cell** (six columns, five rows, 576×480 with five unused alpha cells). This D392 128px art experiment does **not** change that contract. If a larger source and smaller display is promising, explicitly evaluate source art strategy; DO NOT quietly change the battle loader or claim generated cutout stills are a production animation source.

Once the in-arena style is actually good, author a full coherent 25-pose packet per hero (not transforms/copies or storyboard fake frames), validate transparency/weapon grip/foot contact, playback and CI before enabling in production with rollback. If the look fails at 96, revisit art source rather than proceeding to 75 weak frames.
