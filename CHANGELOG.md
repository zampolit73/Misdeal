# Changelog

## Unreleased

### Verified

- Final five-card Act 1 content batch confirmed locally: Rattling Bridge, Lost Purse, Candle Seller, Bone Tax and Death Wager.
- Late-game Act 1 escalation confirmed locally: Faceless Card, Blood Ledger, Broken Crown, Last Camp and Ossuary Gate.
- 12-card Act 1 offer/rejection/tier flow and boss handoff confirmed working locally.
- Bone Warden boss encounter and enrage behavior confirmed working locally.
- Final wizard-table composition/readability polish confirmed locally and accepted.
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

- Fixed Godot 4.7.2 parser failure in the new boss-arena chain/brazier drawing by replacing Variant-inferred loop values with typed Vector2 arrays and explicit local types.
- Clamp final hero max HP to 20 and damage to 1 so stacked late-run sacrifices cannot create invalid combat units.
- Split the battle result overlay into a large victory/defeat title and a separate compact wizard-reaction subtitle so post-battle text no longer overlaps the panel and units.
- Removed floating default tooltips from wizard-table combat cards so hover text no longer covers card illustrations.
- Replaced hover tooltips with wizard commentary in the dedicated upper strip and protected selection commentary from mouse-exit resets.
- Removed obsolete procedural table-side props and candles that conflicted with the authored pixel backdrop.
- Reworked combat readability after local feedback that painted miniatures were unreadable at tactical scale.
- Removed A/B/C suffixes from duplicate enemy display names.
- Added hard combat-arena bounds so retreating units and their pursuers cannot leave the battlefield.
- Bone Archer now fights when cornered instead of endlessly retreating into the arena boundary.
- Fixed pre-battle dragging being blocked by fullscreen Control UI layers.
- BattleUnit placement input now uses the main input phase, while decorative battle UI ignores mouse events.

### Changed

- Act 1 now guarantees at least one selected combat in each early/mid/late four-card tier while preserving two-card choice and rejection.
- The mandatory combat slot is randomized among the first three positions of each tier so combat pacing is controlled without becoming fully predictable.
- Death Wager enhanced reward reduced from +75 gold / +50 HP / +8 damage to +60 gold / +35 HP / +5 damage.
- Bone Warden retuned for twelve-card builds: 580 HP, 22 damage, faster base cadence/movement and a stronger enrage phase.
- Bone Warden final fight upgraded from a single stat/enrage check into a two-phase boss encounter; this new version is pending local verification.

### Added

- Dedicated 64×64 **Bone Warden** combat sprite instead of reusing the normal Skeleton sprite.
- Dedicated **Bone Warden** final-card illustration.
- Dedicated final-boss arena treatment with red ritual geometry, barred gate, chains and stronger braziers.
- Bone Warden melee cleave: 60% splash damage in a 92 px radius.
- Bone Warden Phase II at 50% HP with a visible transition cue and one Bone Archer + one Bone Thrall reinforcement wave.
- EncounterData optional reinforcement paths/names/positions for small phase-based encounter additions.
- Larger Bone Warden name/HP presentation and pulsing multi-ring boss aura.
- Completed the full 24-card pre-boss Act 1 pool with bespoke mechanics; active cards no longer use the generic prototype resolver.
- Real **ГРЕМУЧИЙ МОСТ** early traversal event with risky, mixed-cost and safe crossing choices.
- Real **КОШЕЛЬ МЕРТВЕЦА** greed event with escalating gold-for-HP trades.
- Real **ТОРГОВЕЦ СВЕЧАМИ** early micro-shop with cheap HP/damage purchases and a theft option.
- Real **КОСТЯНАЯ ПОШЛИНА** forced payment event with gold, HP and HP-for-damage branches.
- Real **СТАВКА НА СМЕРТЬ** late five-enemy elite encounter.
- Death Wager enhanced reward screen: +75 gold / +50 HP / +8 damage.
- Death Wager-specific **СТАВКА** battle framing and wizard reaction.
- Real late **КАРТА БЕЗ ЛИЦА** event with hidden random outcome, paid safe outcome and guaranteed low-risk burn choice.
- Real **КРОВАВАЯ КНИГА** event converting gold/HP/damage into late-run power or artifacts.
- Special source-locked **СЛОМАННАЯ КОРОНА** artifact: party-wide +22% damage for -10 max HP per hero.
- `ArtifactData.general_pool` and party-wide `target_role = "*"` support for named special relics.
- Real **ПОСЛЕДНИЙ ПРИВАЛ** preparation event with HP, damage or gold options.
- Real **ВРАТА ОССУАРИЯ** late combat combining Crypt Guard, Grave Bellkeeper, Bone Archer and Bone Thrall.
- Ossuary Gate-specific preparation and victory framing.
- Real **ЧЁРНЫЙ АЛТАРЬ** event with two HP-for-damage sacrifices, a gold-for-HP option and refusal.
- Real **ЗАКОВАННЫЙ ПЛЕННИК** event with rescue, forced-chain and loot branches.
- Real **КОСТИ ДОЛЖНИКА** event with a 50/50 high-stakes gamble plus two deterministic alternatives.
- Real **ДЕСЯТИНА ВОЛШЕБНИКА** event with gold payment, HP payment or refusal.
- Temporary **ДОЛГ ВОЛШЕБНИКУ** run condition: +25% enemy damage until the next normal reward.
- Doubled normal reward while wizard debt is active: +50 gold / +40 HP / +6 damage, clearing the debt when taken.
- Wizard-debt HUD and battle-preparation warnings.
- Real **МОГИЛЬНЫЙ ЗВОН** combat encounter with the first support enemy, **Могильный звонарь**.
- Grave Bellkeeper periodic ally-heal pulse with **ЗВОН!** feedback and green healing numbers.
- **Костяной раб** swarm enemy and real five-enemy **КОСТЯНАЯ ДАВКА** encounter.
- **Страж склепа** elite enemy with larger presentation, visible name and melee splash damage.
- Real **СТРАЖ СКЛЕПА** elite encounter with two Bone Thralls.
- Elite reward override: Crypt Guard victory guarantees an unowned artifact choice, or +50 gold if the artifact pool is exhausted.
- Encounter-specific preparation/status framing for Grave Bell, Bone Crush and Crypt Guard.
- Data-driven `ArtifactData` and persistent per-run artifact ownership.
- First three hero-specific artifacts: **ЩИТ МЕРТВЕЦА**, **СЛЕПОЙ КОЛЧАН**, **РАСКОЛОТЫЙ ФОКУС**.
- Artifact combat modifiers for HP, damage, attack interval, range, splash and movement.
- Real **ПЕПЕЛЬНЫЙ ПРИВАЛ** choices: party HP, gold, party damage or refusal.
- Functional **ЛАВКА МОГИЛЬЩИКА** with gold-gated HP, damage and random-artifact purchases.
- Real **КУЗНИЦА ПРОКЛЯТИЙ** artifact choice with already-owned artifacts disabled.
- Shared Act 1 choice-event scene showing current gold and acquired artifacts.
- Run-end artifact summary.
- Act 1 run structure expanded to 12 resolved pre-boss cards followed by **КОСТЯНОЙ НАДЗИРАТЕЛЬ** as the final boss card.
- Two-card wizard offers: choosing one permanently rejects the other card for that run.
- Data-driven `RunCardData` and a 24-card structural Act 1 pool: 8 early, 8 mid and 8 late cards.
- Generic prototype-card resolver so unimplemented card concepts can participate in real run pacing before bespoke mechanics are built.
- Active combat cards persist after defeat, so returning to the table offers the same fight as **ПОВТОРИТЬ**.
- First boss encounter: **КОСТЯНОЙ НАДЗИРАТЕЛЬ**, now reached after the 12-card Act 1 path.
- Lightweight boss tuning fields in `UnitData`: boss flag, visual scale and one-time HP-threshold enrage modifiers.
- Bone Warden boss presentation with larger sprite scale, visible boss name, wider HP bar, double ground ring and **ЯРОСТЬ!** feedback at 50% HP.
- Boss enrage increases damage, attack speed and movement speed without introducing a general ability framework.
- Boss-specific battle framing: **БОСС** enemy header, preparation warning and a unique wizard reaction after victory.
- Final wizard-table composition pass: compact HUD/commentary strip, slightly smaller and lower card row, wider breathing room around the wizard, and a subdued lower runner/sigil.
- Encounter-specific wizard reactions on card hover, including a dedicated Whispering Well teaser.
- Approved wizard-table concept archived at `assets/concepts/approved_table_direction.png`.
- Rebuilt wizard table using authored concept slices plus live Godot UI.
- Authored pixel wizard/room backdrop, Misdeal logo and four encounter/event card illustrations under `assets/pixel/table/`.
- Illustrated interactive cards now keep encounter text and state data-driven instead of baking gameplay values into the background.
- Dynamic table HUD remains live for deal count, gold, HP modifier and damage modifier.
- Cross-screen pixel-art UI pass for the main menu, wizard table, Whispering Well, reward screen and run-end screen.
- Procedural pixel wizard table with masonry, cursed wood, ritual sigil, candles and deck.
- Pixel wizard portrait used as the active table host visual.
- Pixel Whispering Well backdrop with stonework, glowing water and teal-lit choices.
- Pixel reward altar presentation with three visually distinct reward cards.
- Pixel run-end ritual summary screen and pixel main-menu title composition.
- Atmospheric pixel battle presentation pass with masonry ruins, banners, torches, bones, rubble, blood stains and stronger ritual markings.
- Framed pixel HUD chrome for encounter/status/command areas.
- Dynamic Act 1 card-progress indicator in table and battle HUD.
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
