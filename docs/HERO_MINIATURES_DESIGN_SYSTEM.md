## Selected art direction — C3 «Тёмный орден» (2026-11-04)

Player explicitly selected **C3** from the playable-style C1/C3 comparison, following earlier selection of the broader C direction. **C3 is the chosen aesthetic direction for a reversible hero-art pilot, not acceptance of a finished animation pack or permission to silently replace production artwork.**

C3 identity: wounded heavy Knight with scarred steel and desaturated burgundy rag-cloth, rugged Ranger with frayed moss/olive hood and clear bow profile, male Mage in ripped ash-violet layered robe with a low-intensity cold-blue staff tip. Shared charcoal, dead bronze, weathered fabrics, top-left soft cold moonlight; characters must still read at approximately 96px cell/native battlefield scale. Darker and rougher than C1, but NOT so underlit that Knight boots merge, Ranger bow vanishes or Mage's free hand/feet disappear.

**Critical reference limitation:** AI-generated C3 **comparison boards**, including pictures labeled “25 frames,” are *illustrations*, **not valid 576×480 transparent RGBA atlases or 25 genuinely authored frames**. Their background, podiums, typography and varied frame spacing cannot be sliced directly into live textures. A local 1280×720 96px reduction mockup was prepared for visual legibility only; it is not a Godot F6 screenshot or a final sprite. Never assert C3 is already implemented/animated on main.

**Next production step:** independently author three clean transparent still key poses (no podium, background or text); test leg separation, prop grip, silhouette and correct scale on a real arena. Then create **all 25 distinct frames for each approved hero in one work batch** (idle4 / walk6 / attack6 / hit3 / death6), 576×480 (6×5 at 96px), validate and view true F6 playback before changing the live loader. If art generation cannot produce valid distinct poses/alpha, stop at art-preview stage and report the blocker rather than invent frames with transformations or copies. Preserve current live animated Ranger/Mage and static v4 Knight throughout candidate development.

# Misdeal — Hero Miniatures Design System (proposal v0.1)

Status: **C3 «Тёмный орден» selected for all three heroes as the art direction; actual sprites/animation and live replacement NOT approved or implemented**.
Date: 2026-11-03

## Purpose and compatibility

Create three cohesive dark-fantasy **living tabletop miniatures** at actual battle size, belonging to the cursed table and Act I castle setting. Match existing arena pixel-language and DS3's aged bronze/obsidian/ivory/crimson world, but **do not paste DS3 card frames onto units**. This is the visual brief for review, not a gameplay or shader migration. Preserve existing accepted art until an actual three-character comparison is reviewed by the player.

## Shared visual grammar

- **Silhouette first:** readable at 1× in a native 1280×720 Battle screenshot, both with and without background detail. Knight = broad shield + sword / separate boots; Ranger = narrow offset hood, bow and quiver; Mage = vertical staff + robe with readable legs. No costume overlap that makes a weapon disappear.
- **Materials:** used dark steel, aged bronze, coarse wool, scuffed leather, dry wood and occasional dull bone. Material identity comes from a few clean value clusters, **not** tiny decorative noise or photo textures.
- **Rendering:** restrained, hand-authored pixel clusters, fixed coherent light direction (upper-left suggested), hard silhouettes, deliberate minimal highlights and warm/cold contrast. Avoid blurred scaling, noisy dithering, neon bloom, shiny clean fantasy armor or three different line weights.
- **Palette:** shared base below is a **candidate art-guide palette**, not mandatory shader constants or replacement of the real game colors. Stay within the current game's visible value hierarchy. Accents should occupy a small part of each sprite, never become bright class-color uniforms.
- **Miniature identity:** sculptural weight, grounded stance, controlled poses. A unified *sense* of carved/painted tabletop pieces; **do not bake a literal raised pedestal underneath characters**. Existing Godot ground/contact shadow and legal positioning must continue to work.
- **Story:** all three are human veterans of the same fallen world, not three pristine heroic fantasy archetypes. Male Mage stays male. The evil host Wizard is NOT one of the three hero minis.

## Palette chips (reference, subject to in-game visual comparison)

| Role/use | Candidate HEX | Purpose |
| --- | --- | --- |
| Shared charcoal | `#202127` | silhouette/deep recess |
| Shared slate steel | `#444B53` | armor/staff fittings |
| Shared old leather | `#554338` | boots, belts, quiver |
| Shared dull bronze | `#887257` | sparse metal edge |
| Shared faded bone | `#B6AB98` | sparse readable highlight |
| Shared oxblood | `#633A3E` | tiny cloth/world connection |
| Knight cold steel | `#687C87` | shield/armor focal accent |
| Ranger muted olive | `#626950` | hood/cloak focal accent |
| Mage ash-blue | `#677587` | staff/rune focal accent |

Do not apply these exact HEX values blindly to current game textures: compare with screenshot sampling from live DS3 arenas and the three existing heroes first.

## Role contracts

| | Knight | Ranger | Mage |
| --- | --- | --- | --- |
| Main read | shield + sword + wide shoulders | bow + hood + narrow asymmetrical body | staff + vertical robe + intentional free hand |
| Stance | two independently visible boots, low center of mass | staggered light feet, bow clear of torso | grounded shoes under split robe hem |
| Primary materials | battered plate, dark gambeson, worn shield | rough cloth, leather, wood bow | rough dark wool, wood staff, small bone/iron |
| Accent | cold steel | dry moss/olive | low-value ash-blue |
| Motion | heavy and economical | quick but controlled | quiet, precise gestures |
| Forbidden | shiny paladin, giant sword, gold trim, legless armor | elf prince, fluorescent green, tangled straps/bow | neon spell halo, fireworks, oversized sleeves, hovering feet |

## Scale, construction and constraints

- The **existing technical production contract** for a complete new animation pack is a 576×480 RGBA atlas with a 6×5 grid of 96×96 cells: 25 real authored poses (idle 4, walk 6, attack 6, hit 3, death 6), with the five unused cells truly transparent, unless separately approved. This is a *file contract*, **not** a requirement for the character to fill the entire 96px cell.
- Keep consistent visual body heights and sole contact across the three sprites, allowing natural stance variation. Compare side-by-side at **native live battle scale**, not only enlarged portrait previews. Every weapon, hand-to-prop grip and leg must survive 1× viewing.
- Protect sprite margins, edge transparency and row boundaries; no pieces of legs from adjacent rows or disconnected attack props. Set all frames on the same visible ground contact; natural death frames may lower after the fall.
- Ensure the ranger's arrow/bow is identifiable, Mage hand grips the staff, Knight shield reads as a solid shield and sword does not merge into the arm. No detached visual accessory masquerading as a complete character frame.
- Existing BattleUnit floor shadow, sprite facing/flip, HP bars, click/drag placement, battle scale, hitboxes and combat timing are **not to be redesigned** by this art pass.
- Existing animated Mage/Ranger stay live pending approved replacements; **Knight remains on its current legible static v4 fallback** until a genuinely better 25-frame character is approved. The legacy animation preview alone is not proof of live readiness.

## Animation QA contract

1. **Idle:** restrained 4-frame breathing/weight adjustment without rubber bounce or synchronized mechanical wobble.
2. **Walk:** 6 distinctive, grounded poses with discernible left/right foot phases and constant prop attachment. Knight weighty; Ranger lean; Mage precise with robe opening visibly revealing ground contact.
3. **Attack:** 6 distinctive frames with clean anticipation/contact/recovery: shield/sword, draw/release, staff/hand casting. Gameplay damage timing stays governed by existing BattleUnit code.
4. **Hit:** 3 distinctive readable recoil frames, no disappearing parts or extreme squash.
5. **Death:** 6 genuinely different falling/settling poses ending at the floor; no floating corpse or mirroring glitches.
6. Run native F6 `res://scenes/dev/unit_animation_pack1_preview.tscn` for legacy comparison and live Battle in solo/duo/trio. Always inspect mage/ranger/knight all together, with enemy silhouettes and the actual arena background. Frame-by-frame QA plus motion at native speed; a valid atlas is not proof of beautiful art.

## Art review / approval gates

**Gate A — exploratory concept:** produce **three meaningfully different cohesive trios** (each concept includes all three heroes), shown against the current arena/table color language, before choosing a direction. Concept images are references, not runtime sprite approvals.

**Gate B — source sprite look:** one comparative line-up at real 1× arena display size, with a second enlarged pixel-exact crop. Approve anatomy, feet, props and silhouette before final animation work.

**Gate C — full batch:** produce all 25 genuinely authored poses for each approved hero **without requesting micro-approval for each state**. Validate atlas sizes, clipping, alpha, limb coherence, contact and real F6 motion.

**Gate D — implementation:** after explicit art approval only, stage assets with rollback paths, use current `MisdealUnitAnimationLibrary` and BattleUnit contract, native GUT/CI + screenshots, F6 signoff, then release. No automatic global replacements.

## Explicit non-goals

No AI/code changes, balance changes, new character classes, painted UI text, new class-colored VFX, raised physical pedestal that breaks floor contact, changes to Firing Square/Iron Wall waves, DS3 locked cards, audio or Fate Spread. Preserve prior approved sprite files and ability to revert.

Related sources: `AGENTS.md`, `docs/DESIGN_SYSTEM.md`, `docs/UNIT_ANIMATION_PACK1.md`, `docs/UNIT_ANIMATION_PACK2.md`, `scripts/battle/unit_animation_library.gd`.
