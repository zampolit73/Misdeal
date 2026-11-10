> **Choice-slot correction:** the player rejected repeating one scene across all three decisions. Current choice slots use fifteen separate action illustrations; see [current contract](ECHO_SIEGE_CHOICE_ACTION_ART.md). This document remains the provenance record for the five retained backgrounds/event reference images.

# Echo of the Siege — event illustrations

## Assets and scope

Exactly five final built-in image_gen paintings, each derived from the corresponding inspected immutable approved source under `sources/echo_siege_approved/<id>/approved_source.png`. Full prompts/reference roles in `assets/pixel/events/final_five/sources/event_choice_v1/prompts.json`; full final source PNGs in its five ID subdirectories. No baked UI/text, new characters, changed event mechanics or reauthored card art.

| ID | Continuation |
|---|---|
| banner_seamstress | Same elderly half-undead seamstress wraps the skeleton captain's ribs; scissors and cut garrison cloth remain on the table |
| unsent_letters | Same postmaster holds the unsent letter and closes the chest; exactly one skeletal pigeon |
| borrowed_boots | Same young half-undead squire fastens the huge boot, same camp/helmet/shield/banner |
| false_weights | Same undead quartermaster adds stone to left pan, grain in right, helmeted straw dummies waiting |
| last_signal | Same armored skeleton lifts the cold basket above a silent moonlit valley |

Runtime per ID: `event.webp` 448×274 for the three actual choice cards, `backdrop.webp` 1280×720 for full-screen scene. Lanczos contain fit, centered on #100e0e, no destructive crop, original contract. `card.webp` remains exact approved bytes and continues serving tabletop/Fate/card inspection. The old backdrops are available in parent Git history (Narrative V2 baseline 20d4b1b6).

## Pipeline and guards

`manifest.event_sources` records source PNG SHA256, separate from immutable `approved_sources`; `manifest.files` tracks runtime event/backdrop hashes. `pack_final_five_assets.gd -- --event-only` repacks only event/backdrop resources. Once event_sources exists, ordinary packing also preserves approved card bytes and uses dedicated event source instead of reverting the background to card art. No ad hoc generation SDK or game dependency introduced.

`act_choice.gd::_apply_approved_choice_art` reads each ID's event.webp once per scene, assigns the same texture to its three existing choice slots. Existing full-screen backdrop path remains intact. No DS2/DS3 layout, typography, callbacks, text, timing, state, save or other events changed.

Tests preserve the five old card hashes, validate source/runtime event hashes/dimensions, compare all real choice TextureRects against their correct event image, and retain all fifteen choices across solo/duo/trio, costs, debt, clues, save/load and progression. Native capture: existing `scripts/dev/final_five_capture.gd`, 45 states covering tabletop, event, outcomes, return and unavailable cases. Complete evidence is included in required RELEASE CI.

## Local review

Use `scenes/dev/final_five_playtest.tscn`, F6: open each of the five events; compare tabletop picture to the new event scene and three choice thumbnails, confirm readability of descriptions/buttons, choose outcomes and return. Wallet 0/debt OFF cover blocked choices. Also F5 ordinary tier dealing. Original main project is updated after green CI without resetting unrelated local settings/imports.

Production source files/prompts and runtime outputs live in the project, never only the generator cache. Expansion to any other art is outside this task. Complete random human F5 playthrough is not claimed; actual automated route/native evidence is recorded separately. Final-head RELEASE must be green before merge.

## Verified local evidence

Godot 4.7.2 GL Compatibility: **267/267 GUT, 71,356 assertions**, 19 pre-existing warnings; native **45/45 states** captured and all five event screens visually inspected at 1280×720. Card WebP resource diffs are empty. Representative actual frames in [qa/echo_event_art](qa/echo_event_art/). Import/parse check passed. Complete manual randomized F5 run is not claimed. Full RELEASE CI and PR link are authoritative for delivery.

Delivery: [PR #101](https://github.com/zampolit73/Misdeal/pull/101), [final-head checks](https://github.com/zampolit73/Misdeal/pull/101/checks).
