---
name: misdeal-vfx
description: Use when working on pixel-art VFX, hit impacts, spell effects, status auras, combat feedback, rewards, environment particles, or reusable effect sprite sheets in Misdeal (Godot 4.7/GDScript). Inspect existing game feedback first, optionally adapt patch-gg/pixelfx, preserve approved art and gameplay, and validate visually in Godot. Not for replacing character animation packs or changing combat rules.
---

# Misdeal VFX — project skill

This is a **workflow skill**, not an installed Godot plugin or a runtime dependency. Read `AGENTS.md` and `docs/PIXELFX_WORKFLOW.md` before using it. Do not execute this skill just because a task mentions "art": invoke it when the requested change involves effects, transient visual feedback, particles, sprite sheets, or animation timing. For card illustrations and character animation packs, obey their separate approval contracts.

## Non-negotiable boundaries

- Godot 4.7.x / GDScript only at runtime. Never add JavaScript, Node, PixelFX itself, or a new plugin to the shipped game merely to use an effect. Generate/bake VFX offline as PNG + JSON where applicable.
- No implicit changes to gameplay, combat damage/AI, cooldowns, card outcomes, save format, unit dimensions, battle layering, or accepted visual art. No bulk changes to scenes, assets, or existing animation atlases.
- Preserve the 25-frame 96×96 combat-unit contract, approved hero/enemy sprites, existing floor contact, facing, and `unit.gd` hit-stop. PixelFX's sample character, `act` timing, freeze, and camera shake are **reference data only**, never authoritative replacements.
- Respect `docs/ART_DIRECTION.md`, `docs/DESIGN_SYSTEM.md`, `docs/VISUAL_ASSET_REGISTRY.md` and any more specific approved art rules. Palette: near-black ink, desaturated stone, bone, rust for threat; teal and gold sparingly. A coherent silhouette and meaningful light beat extra sparks.
- Do not use or ship PixelFX's Patch Pixel gallery font; it is excluded from MIT. If shipping adapted upstream code/effects, retain required MIT copyright/license notices and attribution; track the upstream commit and any relevant NOTICE text.

## Default task procedure

1. **Read the live implementation and scope.** Inspect `scripts/battle/unit.gd`, `scripts/battle/unit_attack_visuals.gd`, `scripts/battle/battle_motion_fx.gd` and `scripts/battle/battle_visual.gd` as relevant. Identify the current behavior, owner of the visual event, coordinates, front/back layer, hit-stop, and rollback path. Prefer the smallest adjustment; PixelFX is optional, not mandatory.
2. **Search before inventing.** Consult the PixelFX catalog at `https://github.com/patch-gg/pixelfx/blob/main/docs/CATALOG.md`; inspect 2–3 candidate effects and the original `SKILL.md`/`docs/AUTHORING.md` when needed. Try existing IDs and palette/seed/light parameters before writing a new effect.
3. **Produce offline, isolated from Misdeal.** Use a separate PixelFX checkout and Node >= 18 only during asset authoring. Record its commit hash and effect ID. Preview rendered contact sheets and animation in motion; for custom effects iterate render → inspect → revise and run `node tools/check.mjs <id>`.
4. **Prepare a Godot-friendly asset.** Export with `node tools/render.mjs <id> --sheet`, yielding transparent PNG and Aseprite-style JSON. Preserve metadata (fps, loop, frame bounds, pivot); ensure nearest filtering, transparency, position and scale in a dedicated Godot preview. Do not assume imported sheets match Misdeal's 96×96 character atlas.
5. **Isolated validation first.** Use an F6-only developer preview when implementation is separately authorized. Compare actual 1280×720 Godot visuals with the current effect, checking legibility at native scale, limited saturation/glow, anchor alignment, no UI occlusion, no leaked nodes, performance and loop/ending behavior. Never claim native PASS based only on source inspection.
6. **Integrate only after separate approval.** Reuse existing visual hooks and layer conventions. No new combat behavior; no double hit-stop, damage delay or duplicate trace. Preserve previous resources for rollback. Run relevant GUT/native smoke tests and required GitHub checks, then report before/after evidence and provenance.

## Practical starting candidates (not approvals)

- Knight block: `impacts/shield-block` — add a restrained contact accent only if existing defense feedback supports it.
- Mage charge: `arcane/spell-charge` — avoid moving damage resolution or re-timing the existing hero animation.
- Undead death: `spawn/soul-rise` — ambient death accent, not a replacement for the unit's death poses.

No effect is automatically authorized for a live encounter. The present skill installation changes **documentation/instructions only**, not scenes, gameplay scripts, or sprites. See `docs/PIXELFX_WORKFLOW.md` for commands, import guidance and acceptance criteria.
