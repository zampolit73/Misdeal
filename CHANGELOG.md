# Changelog

## Unreleased

### Verified

- First `table -> battle -> reward -> table` loop confirmed working locally.
- Bone Archer arena-bound retreat fix confirmed working locally.
- Data-driven `UnitData` refactor confirmed working locally.
- Hit/death combat feedback confirmed working locally.
- Combat-time unit separation confirmed working locally.
- Pre-battle hero dragging confirmed working locally.

### Fixed

- Added hard combat-arena bounds so retreating units and their pursuers cannot leave the battlefield.
- Bone Archer now fights when cornered instead of endlessly retreating into the arena boundary.
- Fixed pre-battle dragging being blocked by fullscreen Control UI layers.
- BattleUnit placement input now uses the main input phase, while decorative battle UI ignores mouse events.

### Added

- Russian player-facing text across the main menu, wizard table, battle, rewards and unit display names.
- First wizard-table scene with a playable Graveyard Ambush card and two face-down placeholders.
- Persistent prototype `RunState` autoload.
- Post-victory reward scene with Blood Coin, Iron Ward and Tempered Steel choices.
- Persistent party-wide HP and damage reward bonuses applied to later battles.
- Post-battle flow from victory to rewards and back to the table.
- Defeat return path to the table.
- Bone Archer enemy with ranged keep-distance behavior.
- Mage splash damage that hits nearby secondary enemies.
- Data-driven `UnitData` Resource type.
- Separate Knight, Ranger, Mage and Skeleton `.tres` unit definitions.
- Battle spawning now reads unit stats from Resources instead of hard-coded stat arguments.
- Hit flash and impact scale pulse when units take damage.
- Floating damage numbers.
- Short shrink/fade feedback on unit death.
- Combat-time separation steering so living units no longer stack into a single point.
- Pre-battle preparation phase.
- Drag-and-drop repositioning for player heroes.
- Deployment-zone bounds.
- Rejection of overlapping hero placement.
- Placement guidance in the battle UI.
- Placement automatically locks when **FIGHT** is pressed.

### Project workflow

- Added persistent project-state documentation for continuity across ChatGPT Project chats.
- Established GitHub as the source of truth for implemented technical state.
- Added roadmap and decision log maintenance rules.

## 2026-10-04 — First playable combat prototype

### Added

- Initial Godot 4.7.x project.
- Misdeal title/main scene.
- Transition from the main screen into a test battle.
- Test encounter with Knight, Ranger and Mage versus three Skeletons.
- Automatic nearest-enemy targeting.
- Automatic movement and attacks.
- Melee/ranged attack ranges and attack cooldowns.
- Health bars, death state, victory and defeat detection.
- Battle restart.
- `UPDATE_MISDEAL.bat` helper for pulling repository updates.
- Initial game concept and development guide.

### Verified

- User confirmed the autobattle completes successfully locally.
- User confirmed **RESTART** correctly reloads the encounter.
