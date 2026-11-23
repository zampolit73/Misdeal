# Living Arenas V4 Lite

Use **ЖИВЫЕ АРЕНЫ** in the F6 QA Hub to open the six live arenas. Start the battle to see the opening reactions. Iron Wall reacts after its second-wave title clears. The Court reaction appears on the victory frame.

| Arena | Cue | Reaction |
| --- | --- | --- |
| Graveyard / Grave Bell | Combat start | The left lantern briefly brightens. |
| Iron Wall | Wave II starts | Forge light rises briefly, alongside the existing smoke impulse. |
| Bone Ritual | Combat start | The painted altar fire brightens and returns to its V3 rhythm. |
| Court of the Mute | Victory | Stained-glass light dims on the frozen result frame. |
| Ossuary Gate | Combat start | Mist gathers briefly at the rear gate. |
| Bone Warden XIII | Combat start | Wall recesses brighten after preparation and the fight title. Phase II still uses its existing reaction. |

The existing shader and masks supply the light and haze. Each transient peaks at 0.23 seconds and fades by 1.5 seconds on the local, pausable backdrop clock. The shader bounds reaction pixels above Y=360. The Court freezes on the dimmed frame without a result delay.

Godot 4.7.2 ran all six through the QA Hub launch routes at 1280×720. Paused ON/OFF framebuffer comparisons detected each reaction and found identical pixels at Y≥360. Iron Wall reached the real second wave. The focused GUT test checked cue filtering, pause, decay, result and reload. The effect adds no rendering pass. Frame times were not benchmarked separately.

Native frames: [Iron Wall](qa/living_arenas_v4_lite/iron_wall.webp) · [Bone Ritual](qa/living_arenas_v4_lite/bone_ritual.webp) · [Bone Warden](qa/living_arenas_v4_lite/warden.webp)
