# Wizard Archive Visual V3

2026-11-27: player approved the [design concept](../../../assets/source_archive/wizard_archive_v3/approved_reference.webp) and all-four-tab rollout. Runtime implementation uses the prior approved cabinet and live assets, not a flattened generated image. The exact concept's material direction is the target; existing production positions remain authoritative.

Godot 4.7.2: import PASS; **8/8 targeted GUT tests, 153 assertions**. Actual scene switches all four tabs, checks native detail/title/tab styles, 13 relics / 26 enemies, known/unknown art, Bestiary pagination, Chronicle victory/defeat and Last Deal, locked/open Challenges, retained selection, existing profile values and empty/Esc states. Six existing archive domain tests also pass. [Targeted log](godot_targeted.log).

Headless mode checks node geometry/resources/logic, not native pixels or GPU shader rendering. Native visual acceptance remains pending; F5 and browse the four tabs in the real Archive (no new game or special profile required). Source textures remain unchanged.
