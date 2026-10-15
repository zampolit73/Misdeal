# D153 — Local Balance D176 / D177 / D178
Updated: 2026-10-15. Post-tune Godot **54/54 FUNCTIONAL PASS** from user F6.

## Versioned original enemy stats

| Parameter | Puppeteer before → after | Bone Marionette before → after |
| --- | --- | --- |
| HP | 108 → **142** | 71 → **88** |
| Damage | 5.5 → **7.5** | 8.5 → **10.5** |
| Attack interval | 1.80 → **1.65s** | 1.33 → **1.22s** |
| Move speed | 51 → **55** | 73 → **78** |

One master + two marionettes; unchanged 32% tether protection within 285px. Only D153 `UnitData` modified. D177 removed extra resource-format comments that coincided with a `UnitData` load failure and made matrix diagnostics show exact resource paths. No other encounter rebalanced.

## Confirmed Godot measurements

| Metric | Pre-D176 | Post-D176/D177 |
| --- | --- | --- |
| Matrix | 54/54, 54 wins | **54/54, 54 wins** |
| Mean surviving HP, solo/duo/trio | 85/82–83/86% | **74/67/74%** |
| Worst surviving party HP | not reported | **39/15/37%** |
| Duration (s) | 11.2/12.2/11.5 | **13.0/15.1/13.3** |
| Individual hero deaths | 0/0/2 | **0/4/4** |
| Tethers: joins/normal breaks/master-death breaks | 123/92/54 | **123/91/54** |

Coverage: 2 enemy formations × 3 protagonists × 3 party sizes × 3 combat orders = 54 seeded cases. Functional PASS does **not** certify balance enjoyment or the full reward route. Pre-D176 user reported real battle→reward→table working. On revised stats, user said `пока все ок` and requested repository tidy-up; do not automatically release D153 without a clear final release decision.

**Next:** user confirms revised real battle feel; then release as card 36/45, update QA guards and verify normal random dealing. All detailed previous iterations preserved at [archived D153 balance file](archive/2026-10-15-pre-cleanup/docs/D153_BALANCE_D176.md).
