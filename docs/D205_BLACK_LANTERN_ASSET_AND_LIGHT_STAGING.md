# D205 — Black Lantern Road: selected arena and animation staging

Date: 2026-10-16. State: **D205 static staging / GitHub development preview; native Godot NOT RUN.** Ordinary Act1: **37/45**; card #38 remains QA-only.

## User visual selections

The user picked **A — Black Forest Bend** from the three D204 layout blockouts, then chose **option 3** among three properly rendered moonlit dead-forest backgrounds. The exact selected source is the conversation image `лунная_дорога_через_туманный_лес.png`, RGB, **1672×941**, generated as the last/third of the forest trio. Do not silently substitute the first or second alternative. The source depicts sparse orange lanterns to the sides, dark winding muddy road and clear forest depth; **no painted characters or interface**.

The selected arena image currently exists as a conversation artifact, **not in GitHub runtime assets**; no native Godot F6 background test or 1280×720 import. Only the art *selection* is approved, not Godot leg-contact/layout integration. Preserve the D200 selected THIRD **card illustration** independently; the new arena selection does not replace the card bitmap.

## Five new animation-sheet image inputs and evaluation

The previous turn generated five **1254×1254 RGBA, 5×5 sheet** images for the planned enemies:

| Role | Source (conversation only) | Source grid-edge warnings |
| --- | --- | ---: |
| `extinguished_guide` | `пиксельный_спрайт_лист_скелета_фонарщика.png` | 13 |
| `lantern_bearer` | `пиксельный_атлас_мрачного_фонарщика_нежити.png` | 20 |
| `road_sentinel` | `пиксельный_атлас_скелета_стража.png` | 24 |
| `oil_acolyte` | `спрайт_лист_скелета_аколита_с_фонарём.png` | 21 |
| `lantern_archer` | `пиксельный_атлас_скелета_лучника.png` | 13 |

Distinct from the existing battle animation contract: the live animation library requires **576×480 RGBA (6 columns × 5 rows, each 96px)**, with state pose counts **idle 4 / walk 6 / attack 6 / hit 3 / death 6** (25 authored frames, five blank cells). Directly using the 5×5 raw AI sheets in Godot would crop/misroute animation cells.

Staged all five **locally**, converted to the correct 6×5/96 format by reassigning each of 25 source poses exactly once across 4/6/6/3/6, scaling/cutting alpha, centering and aligning contact to y≈92. All five staging atlases are dimension-correct, have 25 nonempty/distinct cells, and five transparent unused cells. **This is NOT animation/art approval**: source-grid boundary contacts indicate likely trimmed limbs or weapon/effect spills; the staging converter cannot recover source art outside the original cells. Pose reassignment also creates cross-state transitional frames that require visual review.

Design-identity QA blockers: the proposed `road_sentinel` sheet carries a **large axe**, while the approved D199 identity specifies a **long spear**; the lantern bearer is missing a convincingly distinct defensive plank, and the acolyte needs a readable oil vessel/sickle. The Guide must look roughly 2× taller than all others *in battle* without oversized collision or clipped HUD. **Do not wire these unapproved candidates into production `MisdealUnitAnimationLibrary`.**

Created a conversation-only deliverable: `Misdeal_D205_Lantern_Animation_QA_Pack.zip` with the five exported PNG sheets, WebP/Base64 candidates, summary and QA contact sheet. Converter is also committed as `scripts/dev/stage_black_lantern_art.py`; it operates only on provided source images and writes **candidate** filenames. No candidate atlases have been committed to the game asset directory.

## D205 mechanical preview in GitHub

Added **QA-only** `res://scenes/dev/black_lantern_road_light_preview.tscn` backed by `scripts/dev/black_lantern_road_light_preview.gd`:
- Visualizes production floor envelope X110–1190 / Y380–538, three hero proxies, five enemy proxies with 175px tall Guide placeholder, and two moving pools **under** combatant silhouettes.
- Candidate only: **1.4 sec telegraph → 3.1 sec light-active movement → 1.8 sec rest**, alternating between two positions; a pause button and on-screen phase countdown. Previewing colors/positions, not claiming final encounter numbers.
- Absolutely **no attack-speed buffs, AI, damage, real card, sprites, scene routing or Act1 registration**. Existing `battle.gd`, `unit.gd`, RunState and frozen `backups/KARAMBA73-2026-10-16` untouched.
- Static source review only. Godot F6 has not been run. Run `res://scenes/dev/black_lantern_road_light_preview.tscn` in Godot after `git pull`, F6. Check warning is visible, pools do not hide five enemy silhouettes, countdown works, and pause button works. Send a screenshot only if something clips or is confusing.

## Next approved implementation order

1. Inspect native D205 *isolated light preview* F6; respond to concrete overlap or visibility feedback.
2. Integrate the **exact option-3 selected forest arena source** into a 1280×720 QA-only Godot preview (requires source asset transfer through an authorized GitHub-capable byte path, not a replacement illustration). Confirm feet, safe road and background/FX contrast.
3. Improve source-atlas art to meet per-role approved silhouettes and no edge clipping. Keep candidates out of production until actual visual acceptance and native animated F6.
4. Build separate `UnitData` ×5, `EncounterData` with two formations, encounter-local lanternlight controller, debug QA route, then run 54-case solo/duo/trio matrix and real battle→reward→table.
5. Only then enable card #38 in `ACT1_CARD_IDS`, reaching 38/45. No global redesign, no wave retune, no boss XIII changes.

The visual candidate pack and selected bitmap are **conversation artifacts**, not GitHub media. Source and specs should remain searchable through this document; next chat should not misclassify an atlas conversion, isolated cue preview or user art selection as a released encounter.
