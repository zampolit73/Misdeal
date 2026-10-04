# Changelog

## Unreleased

### Fixed

- Fixed pre-battle dragging being blocked by fullscreen Control UI layers.
- BattleUnit placement input now uses the main input phase, while decorative battle UI ignores mouse events.

### Added

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
