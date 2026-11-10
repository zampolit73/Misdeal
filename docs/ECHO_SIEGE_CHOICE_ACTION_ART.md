# Echo of the Siege — one illustration per choice

## Player correction and mapping

The previous delivery introduced five separate event scenes but repeated each scene across three choices. The actual request is **15 distinct decision images**. Existing card art and five event backdrops/reference illustrations are retained unchanged. No narrative, numeric effects, keys/gating, save, UI layout or timing changes.

| Event | A | B | C |
|---|---|---|---|
| banner_seamstress | bandages: hand over cloth rolls | standard: preserve gold-sigil banner | passed: leave seamstress/captain undisturbed |
| unsent_letters | release: skeletal pigeon carries letter | read: inspect suppressed dispatch | passed: turn key in chest lock |
| borrowed_boots | repair: buy light shoes | hobnails: lift heavy armored boots | passed: prepare boots for absent master |
| false_weights | fair: expose stone and claim full ration | silence: accept covert coins | passed: let straw queue continue |
| last_signal | truth: tear player's debt pledge | salvage: remove copper signal bowl | passed: leave watchman at cold signal |

## Files and pipeline

Built-in image_gen, one full final painting per decision. All references were the inspected `sources/event_choice_v1/<id>/source.png`, preserving exact scene/character identity, aged burgundy/gold heraldry and dark painterly language. Finals/prompts: `assets/pixel/events/final_five/sources/choice_actions_v1/<id>/<key>.png`, `prompts.json`. No UI baked into pictures. Each shot has its own framing/action, not a crop or recolor of the same image.

Runtime: `assets/pixel/events/final_five/<id>/choices/<key>.webp`, 448×274, lossless, same Lanczos contain-fit on #100e0e. `manifest.choice_sources` records all15 source SHA256; existing `manifest.files` records the runtime outputs. Existing packer supports `-- --choices-only` and normal repacking; prior images are preserved.

`act_choice.gd` iterates existing `FINAL_FIVE.CHOICES` keys and loads each corresponding image into the existing ChoiceA/B/C slot. There are three textures per open scene, never new per-frame work. No change to callbacks or selection logic. `event.webp` remains available as the prior reference/rollback image, but is no longer repeated in choice slots.

## Verification and reproduction

Regression checks verify source/output hashes, 448×274 dimensions, three distinct image hashes per event and pixel identity of each actual ChoiceArt to its correct key. Existing fifteen-button solo/duo/trio, effects, blocked choices, clues and save/load tests remain. A separate baseline locks **all15 pre-existing card/backdrop/event WebPs**; rollback/source art is untouched.

Run `scenes/dev/final_five_playtest.tscn` with F6 and inspect each event: all three pictures must differ and match the captions. Wallet0/debtOFF covers blocked conditions. Native capture is the existing `scripts/dev/final_five_capture.gd`, 45 states. Actual event screens are saved under `docs/qa/choice_actions/` and full RELEASE CI artifacts. No full manual randomized F5 run is claimed.

After required checks pass, merge and update `C:/Users/irlix/GodotProjects/Misdeal` without reset/stash/clean of unrelated user changes. Stop an old running preview before F5/F6. Final PR checks are authoritative for completion.

## Local verified result

Godot4.7.2: **268/268 full GUT**, **71,452 assertions**, 19 existing warnings. Native **45-state capture PASS** at1280×720; all five three-image event screens inspected directly. All15 old card/backdrop/event hashes retained; all15 decision routes/hash/dimension checks pass. Import/parse check and required RELEASE are verified separately before merge.
