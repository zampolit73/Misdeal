# D206 — Black Lantern Road: QA-only enemy resources and light-controller candidate

Date: 2026-10-16. Status: **SOURCE-INTEGRATED QA-ONLY / GODOT NATIVE TEST PENDING**. Regular Act1 deal pool stays **37/45**.

## User-approved art, held apart from production code

Card #38 (`black_lantern_road`) continues to use the separately approved D200 **third card illustration**, installed QA-only. For its arena the user chose **D204 geography A**, then **the THIRD** rendered full-size forest scene, `лунная_дорога_через_туманный_лес.png` (1672×941). Exact source is available as a conversation artifact. The assistant resized the SAME pixels, preserving composition by tiny centered 16:9 crop and Lanczos downsampling, to a local **1280×720 WebP** at `/mnt/data/black_lantern_road_arena_selected_v1_1280x720.webp` (142,950 bytes). Full source SHA-256 `c7aa3d41432e890a41edfc0edcd0cad2bcd6ba93c8713c170082f0562ca4a569`; converted image SHA-256 `a091f1ca5a4fb40e1a62b203f3b6fd548d70e6907530aa9ef3827c6321b6c442`. **Neither asset has been copied into GitHub.** Do NOT fake import, quietly substitute another option, or force a low-quality raster; authoring the exact approved arena binary in GitHub remains a separate, unfinished step.

Five 5×5 source sprite candidates were QC-staged in D205 with source-frame cropping warnings and Sentinel's wrong axe (needs the D199 approved SPEAR). They remain **unapproved art**; no production animation library roles, sprite bytes, or battle models were replaced.

## D206 QA-only data

`resources/encounters/black_lantern_road.tres`: Tier1 candidate battle titled «Дорога чёрных фонарей», arena id `black_lantern_road`, **exactly five distinct enemy roles** in **two authored placements**; the encounter is not registered in live RunState and is not reachable in normal cards. Its road positions are in local `battle.gd` floor bounds x90–1170/y284–442, for the existing UnitsLayer offset. All combat stats are **unbalanced first-pass candidates**, not approved difficulty:

| New UnitData | HP | Damage | Attack interval (sec) | Attack range | Move speed |
|---|---:|---:|---:|---:|---:|
| `extinguished_guide` | 95 | 7.5 | 2.00 | 92 (min 40) | 45 |
| `lantern_bearer` | 69 | 5.5 | 1.75 | 44 | 56 |
| `road_sentinel` | 76 | 7 | 1.75 | 80 | 62 |
| `oil_acolyte` | 44 | 5 | 1.28 | 47 | 80 |
| `lantern_archer` | 46 | 6.5 | 1.75 | 202 (min 85) | 53 |

Total authored enemy HP 330 vs #37's prior 284 — not a difficulty claim. The giant Guide uses candidate `visual_scale=1.8` but **needs genuinely 2× tall approved authored animation frames and boot/HUD art QA** before using it in battle. Unique role identities are still governed by D199, including spear Sentinel, bearer defensive plank, oil acolyte and bow-mounted lantern. A UnitData does not itself prove distinct artwork/abilities.

## D206 encounter-local light component (STAGED, NOT ACTIVATED)

`scripts/battle/black_lantern_light.gd` — `BlackLanternLightController extends Node2D`. The scoped controller accepts battle unit references via `configure()`, snapshots enemy attack intervals, `start_light()`, `advance_battle(delta)` and `stop_light()`. It computes two moving light pools from a deterministic clock and applies a **candidate** +16% attack speed only to *alive enemy* units inside either active pool. Player units remain untouched. All original intervals restore on leaving a zone, in the rest phase and on stop; the calculation uses enemy boot-contact rather than air/sky coordinates. It draws warning rings and low-alpha circular light beneath units.

Time/geometry first-pass candidates: **1.4 s warning → 3.1 s active travelling light → 1.8 s rest**, two pools radius 93 px, alternating screen positions. These are not locked combat balance decisions until 54-case matrix and native visual approval.

**Critically: the controller is not connected to `battle.gd`, `unit.gd`, RunState, an active arena loader or any other live scene. It cannot affect released encounters.** D205 isolated light geometry preview remains separately F6-testable, after its parser hotfix.

## Contract smoke QA

New `res://scenes/dev/black_lantern_road_contract_smoke.tscn` and `scripts/dev/black_lantern_road_contract.gd` verify:
- Encounter loads, five unique matching UnitData roles, 2×5 placement points inside established combat bounds;
- Initial warning gives no speed bonus, active light accelerates an illuminated *enemy* but never a nearby hero, rest/stop reliably reset baseline.

The smoke uses temporary unparented BattleUnit instances; it does not run real AI, damage, sprites, RNG encounter selection, solo/duo/trio matrices or Battle→Reward→Table. **Native Godot 4.7 F6 result is not yet known.**

## Next

1. User `git pull`; F6 `res://scenes/dev/black_lantern_road_contract_smoke.tscn`. Report errors and screenshot if any. D205 `black_lantern_road_light_preview.tscn` still awaits re-test after its type-inference fix; run it if not already confirmed.
2. Transfer the EXACT chosen 1280×720 forest WebP to GitHub using a supported authenticated binary upload path; add only a QA-only backdrop preview, inspect characters' floor contact, HUD and moving-light contrast.
3. Correct five art sheets, produce 25 fully authored frames each, exact silhouettes/facing/boot contact; native animation preview and explicit visual approval.
4. Integrate `BlackLanternLightController` only into #38 encounter once original assets are ready; add combat regression and native 54-case solo/duo/trio matrix, route test, and ordinary-deal release smoke.
5. Only after successful user-approved gates register `black_lantern_road` and its resource in normal RunState, then Act1 becomes **38/45**.

Existing D151–D153, #37 D196 waves, DS2, 12+XIII and immutable `backups/KARAMBA73-2026-10-16` remain unchanged.
