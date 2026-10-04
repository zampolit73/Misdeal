# Changelog

## Unreleased

### Verified

- Pixel battle presentation pass confirmed visually acceptable locally.
- First pixel-art combat readability pass confirmed locally: larger sprites, ground rings and compact HP presentation read clearly.
- Whispering Well event choices and one-time-per-run lockout confirmed working locally.
- Three-card encounter selection, three-victory finite run, run-end summary and new-run reset confirmed working locally.
- First `table -> battle -> reward -> table` loop confirmed working locally.
- Bone Archer arena-bound retreat fix confirmed working locally.
- Data-driven `UnitData` refactor confirmed working locally.
- Hit/death combat feedback confirmed working locally.
- Combat-time unit separation confirmed working locally.
- Pre-battle hero dragging confirmed working locally.

### Fixed

- Reworked combat readability after local feedback that painted miniatures were unreadable at tactical scale.
- Removed A/B/C suffixes from duplicate enemy display names.
- Added hard combat-arena bounds so retreating units and their pursuers cannot leave the battlefield.
- Bone Archer now fights when cornered instead of endlessly retreating into the arena boundary.
- Fixed pre-battle dragging being blocked by fullscreen Control UI layers.
- BattleUnit placement input now uses the main input phase, while decorative battle UI ignores mouse events.

### Added

- Cross-screen pixel-art UI pass for the main menu, wizard table, Whispering Well, reward screen and run-end screen.
- Procedural pixel wizard table with masonry, cursed wood, ritual sigil, candles and deck.
- Pixel wizard portrait used as the active table host visual.
- Pixel Whispering Well backdrop with stonework, glowing water and teal-lit choices.
- Pixel reward altar presentation with three visually distinct reward cards.
- Pixel run-end ritual summary screen and pixel main-menu title composition.
- Atmospheric pixel battle presentation pass with masonry ruins, banners, torches, bones, rubble, blood stains and stronger ritual markings.
- Framed pixel HUD chrome for encounter/status/command areas.
- Dynamic `РАЗДАЧА X/3` battle indicator.
- Framed victory/defeat result panel.
- Short attack-lunge motion for combat sprites.
- First dark-fantasy pixel-art combat sprite set for Knight, Ranger, Mage, Skeleton and Bone Archer.
- Pixel-stone battle arena renderer with restrained ritual markings.
- Ground-level team rings, compact team-colored HP bars and larger nearest-neighbor unit sprites.
- Pixel-styled battle buttons and reduced combat text clutter.
- First authored dark-fantasy art asset pack under `assets/art/`.
- Painted cursed-table background and authored evil-wizard portrait integrated into the table scene.
- Authored cursed card-back art added to the table composition.
- Authored Knight, Ranger, Mage, Skeleton and Bone Archer miniature textures integrated into combat.
- Procedural unit silhouettes retained as fallback visuals while gameplay rings/HP/feedback stay readable.
- First procedural visual blockout for the cursed table with wood grain, ritual markings and candle accents.
- Styled combat/event card frames with hover depth and distinct event-card treatment.
- Expanded wizard portrait blockout with stronger silhouette, crown details and pulsing orb.
- Data-driven unit visual roles and distinct prototype miniatures for Knight, Ranger, Mage, Skeleton and Bone Archer.
- First non-combat event card: **ШЕПЧУЩИЙ КОЛОДЕЦ**.
- One-time run event state and three event choices: risk/reward stat trade, gold spend, or refusal.
- First meaningful gold spend: 25 gold for a party HP bonus at the Whispering Well.
- Animated placeholder wizard portrait with pulsing eyes on the table.
- Data-driven `EncounterData` Resource type.
- Three playable combat cards: Bone Patrol, Graveyard Ambush and Gallows Volley.
- Selected encounters now drive enemy composition and spawn positions in the generic battle scene.
- Three-victory finite run structure.
- Run-end summary scene with a new-run action.
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
