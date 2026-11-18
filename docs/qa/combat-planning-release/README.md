# Combat Planning 1.0 release evidence

Godot 4.7.2 on Windows, 1280×720. The shared campaign scenes rendered all captures during automated native runs.

| Capture | What it verifies |
| --- | --- |
| [Campaign plan](campaign_plan.png) | The ordinary Battle opens the approved V4 board and shows two independent Knight orders before combat. |
| [Campaign reward](campaign_reward.png) | A win from New Game reaches the normal reward sequence before returning to the table. |
| [Last Deal](campaign_last_deal.png) | The original acceptance and refusal controls remain available after a natural defeat. |
| [Bone Warden XIII](campaign_boss_phase_two.png) | The native fight crosses the boss HP threshold and spawns reinforcements. |
| [Court deployment](court_field.png) | The compact field view keeps the trio's low deployment positions and labels visible. |

The 22-encounter smoke exercised solo Knight/Ranger/Mage, duo, trio, Classic mode and an Iron Wall intermission. The separate campaign route supplied a deterministic combat offer and used a prior-version serializer for the Continue test. A controlled HP threshold exercised the boss phase. [Verification details and CI](../../COMBAT_PLANNING_ROLLOUT.md)
