# D291 — DS3 Battle HUD visual-only pilot (2026-10-20)

## Context and approvals

The user sent a new actual **D290 Table** screenshot after `git pull`. Observed: original painterly table and two game cards are present, **single truthful `КОЛОДА 37`** under the left deck, no duplicated baked "22", and thin top panels without the doubled orange corner-bracket issue. This is a **successful screenshot check of the D290 corrections**, not an explicit blanket acceptance of all DS3 art.

With the previously requested sequential DS3 rollout, D291 now applies only to the actual Battle HUD while keeping the DS2 rollback branch `checkpoint/ds2-pre-ds3-2026-10-20` untouched.

## Technical scope (live `main`)

- `scripts/battle/battle_ds3_pass.gd` — opt-in muted blackened metal and steel/aged-bronze styling for **existing** TopHudPanel, RunHudPanel, BottomHudPanel, FightHudPanel, SideObjectivePanel, WizardCommentaryPanel. No node repositioning, no added arena overlay; high enough contrast for tactical text.
- Five existing tactical-order Buttons use a new DS3 stateful chrome, **without changing position, size, tooltip, toggle_mode, unlock availability or the actual tactic calculations**. The code reapplies DS3 decoration *after* the old `apply_battle_order_choice` whenever the original `_select_tactical_order()` changes which option is selected; Sacrifice crimson and Defiance cool steel identity retained.
- Original Fight/Continue/Restart/TargetPreview Buttons receive restrained style-only overrides. Original Godot input event handlers, pressed signals and disabled states retained. Hero/enemy HP and gameplay-owned visible status labels remain live; no invented turn order, manual ability keys, damage or health changes.
- Production `scripts/battle/battle.gd` adds just the DS3 pass integration after `MISDEAL_DS2_ROLLOUT.battle(self)` and dynamic option-style refresh. No changes to `scenes/battle/battle.tscn`, `scripts/battle/unit.gd`, `RunState`, encounter/arena/resources, animation, units or combat data.
- Art remains the same on all 16 Battle arenas, including approved `bone_ritual` and `firing_square` and retained `grave_crossfire`.

## Native verification and visual gate

- Added `scripts/dev/d291_battle_ds3_smoke.gd` and official 4.7.2 workflow `.github/workflows/d291-battle-ds3.yml`. Headless smoke registers RunState, loads **actual** Battle and verifies original arena position/size, real units, all tactical widgets and actions, correct dynamic Hunt→Formation switching, six panel material layers and button interaction skins.
- First CI attempts found **test initialization order** (Battle was loaded before RunState in `--script`), then a typed-GDScript inference for the DS3 style script. Both corrected in commits `1d3ad92` and `fabc51a`. Final test: **PASS**: [D291 native Battle regression](https://github.com/zampolit73/Misdeal/actions/runs/39397929958). Do not misreport initial red builds as green; the referenced passing run is authoritative.
- **User-local visual acceptance PENDING:** `git pull`, open any regular Battle with at least 3 tactical orders on screen, screenshot real 1280×720 game; inspect whether arena/units remain unobscured and the bottom panels and tactics remain readable. Godot headless structural PASS does not prove unit foot contact, whole battle→reward→table, or aesthetic fidelity.

## Rollback

Frozen pre-DS3 checkpoint SHA `4cbd206cc3739355a9d375a0752a6a840e35caa2` under `checkpoint/ds2-pre-ds3-2026-10-20`. For scoped rollback D291 can be reverted without rewriting all of DS3; see `docs/DS2_CHECKPOINT.md`.
