# Bone Warden XIII · throne intro

Open card XIII after XII and the last preparation stop in an F5 run. For a quick check, run `scenes/dev/living_warden.tscn` with F6 and use **Повтор · F9** to reopen the encounter.

1. Watch the seated Warden lean forward, plant his feet and rise. The throne clears, then the regular Combat Planning board opens.
2. Repeat and click or press Enter, Space or Esc during the intro. Planning should open with the empty throne and the actual Warden at the right of the arena. Start the fight from that board.
3. Allow a fight to resolve. A saved pending Last Deal should reopen directly at its choice. A paid retry opens XIII with the intro and the saved entry wounds. A victory still goes through Reward to the Act I ending.

## Presentation

`warden_intro.gd` runs for 1.95 seconds after the entry veil. It poses a cutout of the seated figure from the existing painting. The 306×337 throne patch uses a localized ImageGen repair of the same painting. Its position is (487, 0) in the 1280×720 authored backdrop. The floor and the original painting on disk remain intact. The restored throne uses the existing Living Arenas material, including the real Phase II reaction.

## Native QA

Godot 4.7.2 at 1280×720 captured the seated, rising, empty-throne and planning frames. `gameplay_meta_capture.gd` checks natural completion and mouse skip, keeps the original BattleUnit position, and exercises a real XIII victory, Phase II, Reward and defeat. `gameplay_core_smoke.gd` checks restoring Last Deal and the paid retry. The campaign planning smoke checks Esc skip, all 22 encounter entries and Iron Wall's second-wave planning.
