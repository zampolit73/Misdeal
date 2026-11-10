# Cinematic Travel V1

## Production route

One4-second scene: «Тропа вдоль мёртвых стен». `SceneRouter.after_resolution` places a temporary TravelTransition CanvasLayer127 above the completed Event/Reward, below existing transition veil128. It guards repeated requests, snapshots explicit context, waits for finish then calls the original SceneTransition to Table, retaining the travel picture until its swap completes. No second router/manager, no travel state in RunState/save, no award/completion/deal inside the viewer. Skip starts existing navigation immediately, with no remaining travel timer wait. Ordinary navigation/loading/menu/defeat/XIII never calls this entry point.

Event._finish captures ID/outcome/party/Wizard before the existing completion/save; continue triggers travel. Catalog maps all15 Echo choices to different past-facing text with no future offers/spoilers. Reward captures the combat ID before completion, applies existing reward/save first, then travels only for actual victory/combat and non-final run. Reward commit/completion guards prevent rapid duplicate transactions. The generic reward text concerns the completed fight only.

`TravelTransitionData` resource points to the one original painting and transparent foreground. Scene follows viewport scaling and actual role list. Background moves6px/s, foreground22px/s; local cloth offset below1px and soft procedural mist have delta-driven local time. Explicit PAUSABLE D412 walk sprites pause with the game; presentation clock freezes; skip remains handled before game ESC menu. No sound added or SoundDirector call; original router chooses Table ambience normally.

Feature flag: `scripts/travel/travel_catalog.gd::enabled` (session), or `ProjectSettings.set_setting("misdeal/travel/enabled",false)` override. Disabled/missing presentation falls back to original Table routing. No serialized flag or travel checkpoint; existing v1 save schema stays unchanged.

## Art and prototype limits

Two built-in image_gen paintings using the approved Misdeal firing_square image as world/style/heraldry reference; assets/provenance/hashes under `assets/pixel/travel/ruined_castle_road`. No text baked in. D412 atlases and timing untouched: real walk frames reused at travel scale, not newly authored travel-specific side views. This is the explicitly allowed V1 limitation, with the actor setup isolated for future replacement. No placeholder silhouettes.

## Verification

Initial full GUT271/271,71,556 assertions before final extra checks/guards; final focused6/6,118 assertions. Dedicated native4.7.2 GL Compatibility capture: five1280×720 sequential frames; actual Event choice→Travel→Skip→Table; actual Battle result handler (injected victory, not a combat win-rate test)→real Reward buttons→Travel→Skip→Table; direct applied-save load bypass. Completed cards/HP/gold asserted once. All five final event gallery states retain separate native QA with optional travel disabled in that old static-gallery process; dedicated travel test exercises the feature ON. No full manual random F5 run claimed. Existing19 GUT warnings and Windows sandbox certificate/log diagnostics are not hidden.

New GUT checks all15 context texts, party snapshot isolation, disabled flag, defeat/boss exclusion, paused clock, read-only state, duplicate skip/navigation, actual Event completion and save-stage exclusion. RELEASE selector includes travel and router changes; CI captures the native route and rejects script/assert failures.

F6: `scenes/dev/travel_transition_playtest.tscn`. It loops an explicit QA trio without touching run/save; Space/Enter/ESC/button skips. F5: complete any Echo event, inspect result, press К СТОЛУ;4s travel or skip. Verify solo/duo/trio, role order, readable caption, footsteps/contact, foreground depth, pause/resume, one completion, save/continue no old travel. After victory claim upgrade AND loot first, then travel. Defeat/XIII/menu/load bypass. Main project is updated only after green required checks, preserving local settings.

Native reproduction: `godot --path . --windowed --resolution 1280x720 --rendering-method gl_compatibility --audio-driver Dummy --script res://scripts/dev/travel_capture.gd -- <absolute-output-dir>`. Representative frames: docs/qa/travel_v1. Required final PR CI is authoritative.
