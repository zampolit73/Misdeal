# Cinematic Travel Batch 02 V2

Seven new locations / 31 visual actions integrated through the existing Travel V2 panorama contract. This is one candidate PR, **not merged**; final player artistic review remains open. No card illustrations, old seven locations, hero atlases, prices, RNG probabilities, rewards or save fields are changed.

| Card | Visual actions |
|---|---|
| candle_seller | knight, ranger, mage, leave |
| blood_ledger | gold, blood, erase, leave |
| debtor_bones | gamble_success, gamble_failure, safe, break, leave |
| wizard_tithe | gold, blood, refuse |
| broken_crown | wear, break, melt, leave |
| curse_forge | dead_mans_shield, blind_quiver, cracked_focus, leave |
| rattling_bridge | rush_success, rush_failure, scavenge, careful, recruit, loot_recruitment, abandon |

## Current artistic review

All six other locations / 27 outcomes are approved. The user then approved a redrawn smaller crown/armour/sword/candles background and requested its use for all four crown outcomes. The exact image is retained in `broken_crown/small_props/source/approved_master.png` with SHA256 `a9128b4a0920ccf0f1aa8f11d56595c614ad1a30aff1118645b20720906f4a09`. Resource paths select its versioned folder; the compositor derives that folder from the supplied background path. Original V2 assets/provenance remain unchanged.

Taking removes the small crown; breaking leaves flat fragments; remelting leaves a matte gold trace; passing preserves the base. Generated edits are packed as local RGBA layers inside Rect2i(704,316,210,126), with a12px edge feather; no changes to walls, armour, sword, candles or garden between outcomes. Existing fades, actor near-height330, route, sole projection and mechanics are preserved. Rebuild with `scripts/dev/pack_crown_small_props.gd`; sources, prompts and checked hashes are included. [Native four-outcome evidence](qa/crown_small_props/README.md).

## Crown road adjustment

After approving the full smaller-prop result, the user requested only the marked route: lower paving → up-right into the garden gap. The crown Resource overrides the quadratic route with (230,680), (305,505), (345,385), formation lanes +45/-45/0, projected with depth. Solo/trio starting offsets leave enough path for every member to keep walking for the full duration; no stationary walking at clamped endpoints. Existing rear NE frames, near-height330, soles/contact effects, approved pixels, states and other six locations stay unchanged. [Midway](qa/crown_road/midway.jpg), [near the garden](qa/crown_road/far.jpg).

## Source and staging

Exact archive `MISDEAL_TRAVEL_PRODUCTION_BATCH_02_V2.zip`, SHA-256 `59069da6d72dd088def9774395ccafdce776f3e51975239cd6d28e4394a36e14`. `assets/pixel/travel/batch_02/provenance.json` records 279 retained original masters, runtime bases/state/release/haze layers, 31 final references and authored cropped phases/metadata. No ZIP, generation candidates, duplicate hero atlas or video is shipped. `scripts/ci/verify_travel_batch02.py` verifies every retained byte, outcome count and animation references.

The approved local compositor is ported without its offline viewer/party/veil. `batch_02_panorama.gd` implements build/configure/update_time/stage_party; the original V2 owner supplies dynamic actors, one entry fade, caption, skip, pause, duration, exit and router. Architecture/cloth/props stay in one rigid plane with overscan 1.008 and 1.2 px/s pan; only existing haze moves separately. No new effect library or audio dependency.

Each state's **actor_stage overrides** are applied before calculating positions and scale: all 11 V2 corrections retain their 310–330 px nominal near-height and adjusted roads/formation/depth span. Actual visible height follows sole depth, normalized against the maximum visible height of all six walk cells. Existing NE Scene04 and side D412 frames are reused; no original atlas is edited. Sole position, tint, y-sorting and contact FX share the same projected foot. Solo/duo/trio use actual supplied roles, never a baked movie.

No detached-hand assets or stretched sleeves enter this batch. Forge releases only the chosen source-pixel artifact 5 px right / 7 px up / 1.6 degrees, then locally fades it 0.70–1.06 s over its empty mount; the other two stay mounted. Coin/crown/bag actions retain V2 local state transitions. Seated bridge NPC stays in the foreground for leave/loot, and disappears at 0.90 s exactly when the one dynamic recruited Ranger becomes visible.

## Real event integration

`act_choice.gd` captures presentation-only values at successful resolution: bought candle role, actual forge artifact ID, the result of the **same one existing random draw**, and bridge recruitment mode/choice. `batch_02_catalog.gd` maps these explicitly; missing ambiguous purchase/random context never invents an outcome. Existing saved debtor outcome remains `gamble`; bridge/forge/candle acquire no new persisted outcome.

The existing `_finish` ordering remains context → completion → save → resolution screen → original router. Presentation code cannot mutate RunState, roll RNG, award anything or save a travel checkpoint. Failed purchases do not finish. Repeated buttons are guarded. Loading the ordinary saved Table bypasses Travel and does not reapply the choice. Missing/invalid panorama configuration uses the existing unavailable fallback; the owner now rechecks availability after configure.

## Local verification

- Godot **4.7.2 stable**, native Windows/OpenGL Compatibility, RTX 3050 Laptop / driver 610.91.
- Full GUT **298/298**, **77,300 assertions**, 65 scripts; 19 pre-existing warnings. Includes all old Travel tests and four new Batch02 tests: 31 actions across seven role subsets, feet, pause, finish once, read-only state, exact context mapping, V2 parameters and invalid-context fallback.
- Smart QA selector **18/18**; asset verifier **279/279 hashes**, seven scenes / 31 outcomes / 11 corrections.
- Native actual production event buttons **31/31 Event → Travel → Table**, with real deterministic success/failure branches, successful purchases, exact gold/HP/artifact/upgrade checks, duplicate-press guards, pause, keyboard/button skip, natural finish and existing snapshot validation/apply/load bypass. 93 full-resolution frames, six control times per route.
- Separate full-party native production overlay review: **31/31**, 93 frames at 0.65/1.15/2.50 s; [contact sheet and 22 corrected-action frames](qa/travel_batch02/README.md).
- Existing Pilot Batch01 **11/11 real native event routes** re-run successfully. Its assets/resources/panorama code and the four earlier unique locations remain unchanged. Existing required RELEASE CI still runs their native smokes.

The first unrestricted local test attempt could not write an existing test's `user://` temporary resource (Windows permissions). Re-running with process-local APPDATA under the external QA directory passed all 298 tests; no test was skipped and no game workaround was added. Native certificate-store diagnostics and the existing six production-route shutdown ObjectDB diagnostics are documented, not hidden. The isolated overlay review exits without new node diagnostics. No claim of a full manual random F5 campaign or player artistic acceptance.

Required final-head CI is authoritative. The RELEASE workflow additionally verifies assets and runs the full 31-route capture, retaining all PNGs/results/logs in its normal evidence artifact. Final PR/check links belong in the PR and current handoff.

## Player check

Open `scenes/dev/travel_batch02_playtest.tscn`, F6: left/right cycles all 31 actions; 1/2/3 changes party; P pauses; R replays; standard skip also replays in this fixture. Recruitment preview shows the post-choice composition: solo recruitment becomes duo, and leave/loot cannot show a party Ranger plus seated Ranger. The fixture does not resolve cards or alter a save.

Review at **1280×720, 1×**: feet, scale near NPCs, foreground depth, forge mounts and crown/coin actions at 0.65/1.15 s; bridge hire must never duplicate Ranger. In F5, finish the real corresponding event and continue; verify one reward/effect, correct scene, skip/return and Continue/load without replay. Do not merge until that artistic review.

Reproduce: `godot --headless --path . --script addons/gut/gut_cmdln.gd -gexit`; `python scripts/ci/verify_travel_batch02.py`; `python -m unittest discover -s scripts/ci -p test_smart_qa_select.py`; native `godot --path . --resolution 1280x720 --rendering-method gl_compatibility --script res://scripts/dev/travel_batch02_capture.gd -- <output-dir>`. Full-party images: `res://scripts/dev/travel_batch02_review_capture.gd` with the same output argument.
