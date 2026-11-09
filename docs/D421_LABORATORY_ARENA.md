# D421 — Defiled laboratory arena

A dedicated Gothic alchemy workshop replaces the generic crypt background only for `defiled_laboratory`. Copper retorts, specimen jars, a chained rear slab and amber furnace frame an open stone battlefield. Poison-green light is restricted to apparatus/edges; the existing hazard controller remains the sole source of gameplay warnings. Enemy roster, positions, formations, stats, combat timing and rewards are unchanged.

## Assets and production

Built-in imagegen, reference-guided new arena using `assets/pixel/battle/arenas/arena_redraw_v2/crypt.webp` for the accepted environmental language. This is a combat arena, not a replacement card illustration (D168). Source: `assets/pixel/battle/arenas/defiled_laboratory_d421/source.png`; runtime: adjacent `arena.webp.b64`, lossless WebP at1280×720. Reproduce encoding with `godot --headless --path . --script res://scripts/dev/pack_laboratory_arena.gd`. Original crypt and card art retained.

Prompt: Misdeal production combat arena background,16:9. Unique defiled alchemy laboratory matching the reference dark Gothic painted pixel-art environment, perspective, textured stone and restrained bronze/vermilion palette. Ruined medieval workshop under Gothic vaults: corroded copper retorts, dim poisonous yellow-green vessels, cracked specimen jars, chained examination slab, amber furnace and drainage channels along the rear wall. Peripheral worktables and torn burgundy cloth. Localized chemical glow, warm fire/cool slate balance. Wide open flat floor across central lower two thirds, readable for small fighters and green hazard circles; no blocking props at x10–90%,y44–83%. Rear wall meets floor near y40%. Slightly elevated fixed camera. Purposeful equipment; subdued spills at edges only. No characters, bodies, text, baked UI, card borders, sci-fi or factory design.

## Verification and reproduction

Godot4.7.2 native production Battle captured preparation, intro,10 live timeline frames through6.6s and three natural enemy attack frames via `scripts/dev/laboratory_arena_capture.gd`. Reviewed `qa/d421/00-preparation.png` and `qa/d421/08-live-3600ms.png`: unobstructed floor, coherent figure scale, readable UI. Capture metadata and logs are adjacent. CI repeats this genuine encounter with Xvfb/Mesa and uploads all evidence.

Local GUT:235/235 tests,47882 assertions,19 existing warnings; no failing tests. New regression checks dedicated arena identity,1280×720 decoded texture, original roster and independent crypt fallback. Local Windows certificate-store/user-log permission diagnostics remain environmental limitations; native screenshots and successful exit are the runtime evidence.

F6: `scenes/dev/defiled_laboratory_playtest.tscn`, press БОЙ. Inspect retorts/furnace, figure contact with floor, and chemical danger indicators during combat. Or run `godot --path . --script res://scripts/dev/laboratory_arena_capture.gd -- <absolute-output-directory> extended`.

Branch stacks on D420/PR90; do not merge until required CI is green. Player-local settings/import changes are excluded.
