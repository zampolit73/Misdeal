# Living Arenas V4.1

The F6 QA Hub route is **ЖИВЫЕ АРЕНЫ**. Watch the preparation field before starting combat. Iron Wall also reacts as wave II starts, and the Court keeps its dimmed victory frame.

| Arena | Movement |
| --- | --- |
| Bone Ritual | The tips of the altar flames bend and stretch. Small embers rise from the altar. |
| Iron Wall | The furnace flame changes shape, with rising smoke and embers. Wave II amplifies the motion alongside the existing smoke pulse. |
| Ossuary Gate | Folds of cold mist cross the rear portal and gather briefly at the start of combat. |
| Graveyard | The left lantern flame bends, with short ember trails above it. |
| Court of the Mute | Bands of cool light travel down the stained glass. Victory still freezes the dimmed window. |
| Bone Warden XIII | The left brazier flame bends and throws embers. The existing start and Phase II cues remain in place. |

The existing shader uses local time and the original masks. Flame displacement samples warm parts of the painted source and falls off toward its base. The new pass clips all changes at Y=360. The Warden intro and battle routing use their existing code.

## Native sequences

Each sheet contains a 2× crop of genuine 1280×720 Godot frames. Read left to right, then top to bottom. The first frame is the V3 preparation baseline at 0.31 s. The next three are V4.1 at 0.31, 0.67 and 1.10 s.

[Bone Ritual](qa/living_arenas_v4_1/bone_ritual_sequence.webp) · [Iron Wall](qa/living_arenas_v4_1/iron_wall_sequence.webp) · [Ossuary Gate](qa/living_arenas_v4_1/ossuary_gate_sequence.webp)

[Graveyard](qa/living_arenas_v4_1/graveyard_sequence.webp) · [Court](qa/living_arenas_v4_1/court_of_the_mute_sequence.webp) · [Warden](qa/living_arenas_v4_1/warden_sequence.webp)
