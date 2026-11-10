# Mountain valley correction

Five sequential native Godot 4.7.2 / NVIDIA Compatibility frames, captured with `scripts/dev/travel_capture.gd`. The left/central repeated bridge ruins are replaced with natural ridges and mist. The same actors, walking road and close banner remain readable in motion. No gameplay code changed.

Focused GUT: 6/6, 118 assertions. Native fixture reported `TRAVEL_NATIVE_PASS` for Event → Travel → Table, Battle(result) → Reward → Travel → Table and direct saved Table loading. This local capture also reported 11 ObjectDB instances / one resource still in use at process exit; no script/parse/assert failures. Required CI is authoritative for integration.

Art: built-in image_gen edit; prompt and SHA256 in `assets/pixel/travel/ruined_castle_road/`. The original painting is preserved in Git history at d4fead3f / PR #103.
