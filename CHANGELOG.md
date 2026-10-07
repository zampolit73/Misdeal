# Changelog

## Unreleased

### Added

- Integrated the user-approved full pixel-art card set: unique illustrations for all 25 active Act 1 table cards, all nine hero-development paths, and six reward states.
- Added repository-safe runtime-decoded WebP atlases for table-card art and development/reward art under `assets/pixel/ui/approved_card_art/`.

### Changed

- Wizard-table offers now resolve art by `card_id`, so Rattling Bridge, Lost Purse, Blood Ledger, Crypt Guard, Bone Crush, Bone Warden and every other active card show their own approved scene instead of sharing the old five-image pool.
- Hero development now uses nine distinct approved illustrations; Ranger and alternate Knight/Mage paths no longer fall back to repeated role portraits.
- Ordinary loot, Death Wager and elite rewards now use the approved Blood Coin, Gold Windfall, Relic Wager, Bonus Upgrade, Empty Cache and Elite Relic art while keeping reward text live.
- Generic Act 1 event choices now show the active event's approved illustration in their upper art band instead of leaving Rattling Bridge and similar choice cards as flat black placeholders; Curse Forge and Chained Prisoner retain their dedicated option art.

### Verified

- Clean wizard-table art pass confirmed locally after screenshot review: removing the procedural hands/heavy frames restored the authored Wizard art and live cards as the main visual focus.
- Physical wizard-table staging pass confirmed locally: deal animation, fan/hover behavior, discard motion and spread layout are working acceptably.
- Voluntary Wizard wager flow confirmed locally: wager modal, debt state and doubled ordinary loot are working acceptably.
- First combat-feel and prototype-SFX pass confirmed locally: attack motion, hit/death response and runtime combat cues are working acceptably.
- Complete nine-role combat sprite atlas confirmed locally after the v2 fallback preload fix.
- Authored gothic battle backdrop confirmed locally after backdrop import/z-order fixes.
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

- Replaced the first card-art atlas pass that crushed approved illustrations to 88×54 px (table) and 80×48 px (development/reward). The same approved images are now stored at 224×137 and 304×194 per cell respectively, with WebP bytes decoded directly from repository-safe `.bin` blobs instead of enlarging thumbnail art.
- Replaced the incorrect combat-unit portraits on non-combat UI with the exact accepted screen-art crops. Hero development now uses the approved Iron Oath / Glass Heart / Executioner illustrations, and matching approved art is wired into Curse Forge and Chained Prisoner choices. Ranger paths deliberately remain text-led until matching art is approved rather than reusing unrelated battle sprites.
- Fixed Godot 4.7.2 parser failure in `act_choice.gd` from Variant-returning theme-style lookups by giving the duplicated `StyleBoxFlat` values explicit types.
- Replaced the temporary low-resolution arena rollback with repository-safe native-HD blobs for crypt, graveyard, ossuary and Warden; the earlier binary-truncation path is no longer used.
- Removed compile-time WebP `preload()` calls from the arena backdrop selector after Godot 4.7.2 still rejected the arena textures during script parsing on a clean pull. Arena WebPs are now read as raw bytes and decoded at runtime with `Image.load_webp_from_buffer()`, matching the already-validated main-menu splash loading path and preventing importer failures from crashing startup.
- Fixed the arena startup crash after the HD-quality pass: the crypt/graveyard/ossuary WebP blobs in GitHub were truncated to ~15 KB and could not be imported by Godot. Restored the last validated authored arena blobs and now Lanczos-resample/cache every arena family to 1280×720 at runtime with linear filtering.
- Fixed the HD arena parser regression: `authored_backdrop.gd` and related notes had been serialized with literal escape sequences instead of physical line breaks, causing Godot 4.7.2 to parse the whole script as one invalid line.
- Removed nearest-neighbor 2× arena presentation; validated authored sources are now resampled once with Lanczos to cached 1280×720 runtime textures and shown with linear filtering.

- Fixed Godot 4.7.2 parser failure in the multi-arena visual layer: renamed the local ellipse helper so it no longer overrides the built-in CanvasItem `draw_ellipse(...)` method with an incompatible signature.
- Reverted the rejected wizard-table dressing layer after local visual review: removed the procedural dealer hands, oversized side inlays, dense orange frames/runes and extra tabletop props that clashed with the authored pixel background.
- Rebalanced the table presentation around the live cards: small deck/discard stacks and a low-contrast fate track remain, while deal/hover/choose/discard/substitution animations are preserved.
- Moved the victory/defeat result UI into a dedicated high-layer `CanvasLayer` with a dim scrim so combat-unit sprites, names and HP bars can no longer render over the result panel; the modal is also positioned higher and tactical-order controls hide on battle end.
- Corrected the Wizard's card-hand anatomy on the production main-menu splash to five fingers.
- Removed the obsolete compile-time `preload()` of `combat_units_v2.png` that prevented `unit.gd` from parsing in Godot 4.7.2. The validated v3 atlas is now the only production unit-art source.
- Removed the obsolete/broken `assets/pixel/units/combat_units_v2.png` fallback asset.

- Fixed the authored battle backdrop being invisible: the direct WebP committed to GitHub was truncated to 8.7 KB and the backdrop node also sat behind the fullscreen black fallback via `z_index = -100`.
- Battle now reconstructs the validated 1280×720 authored WebP from five repository chunks through `authored_backdrop.gd`, and the backdrop is drawn above the black fallback.
- Removed the broken truncated `assets/pixel/battle/battle_backdrop.webp` file.
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

- Reworked the four user-approved reference screens against the actual screenshots: hero development now removes the invented diamond/quick-stat chrome and uses taller illustrated cards with in-card choose bars; Curse Forge and Chained Prisoner now use dedicated absolute compositions around their approved character art; the Wizard wager is enlarged and reveals more of the cursed table behind it.
- Re-aligned **РАЗВИТИЕ ОТРЯДА**, **КУЗНИЦА ПРОКЛЯТИЙ**, **ЗАКОВАННЫЙ ПЛЕННИК** and **СТАВКА ВОЛШЕБНИКА** to the approved mockup compositions: taller illustrated cards, dominant art windows, in-card choose bars, stronger header framing and a larger ritual wager modal.
- Hero-development cards now use approved art when available and a role-specific art fallback only for upgrade paths that do not yet have a dedicated approved illustration; combat-atlas sprites are not used on this screen.
- Polished **РАЗВИТИЕ ОТРЯДА** beyond the shared shell: upgrade cards now show live hero portraits, separate role/path/description regions, concise tradeoff summaries, three-step fate markers, stronger backdrop suppression and tighter card proportions.
- Reworked reward/development screens around the authored Wizard backdrop with a compact run HUD, stronger role-card presentation and hover feedback; reworked the Wizard wager into a larger ceremonial modal with clearer accept/refuse hierarchy.
- Restyled protagonist selection and fallback event screens to match the same approved Misdeal table language instead of isolated flat-black prototype panels.
- Rebuilt the battle preparation controls into one darker gothic bottom HUD with clearer pressed tactical-order states, a larger central fight button and restart hidden until results.
- Combat-polish v2 remains presentation-only: movement positions, targeting rules, tactical orders, stats and encounter compositions are unchanged.
- Rebuilt all four authored battle arenas from the preserved 1672×941 source renders into high-quality native 1280×720 WebP assets, removing the visible softness caused by 640×360 source upscaling. Runtime WebP byte decoding remains in place for importer robustness.
- Replaced the visually weak procedural arena-family overlays with four dedicated authored pixel-art battle backdrops: crypt, moonlit graveyard, ossuary and Bone Warden lair. `EncounterData.arena_id` now selects the actual backdrop texture.
- Reduced `battle_visual.gd` back to dynamic boss effects only, removing static procedural environment drawing that competed with authored art.
- Refined wizard-table hierarchy after screenshot review: added a subtle lower-table veil over the baked background-card row, compacted/lightened the stats and Wizard-commentary chrome, quieted the squad button and moved the fate progress to a tiny table-edge counter/marker row.
- Replaced the rejected live/table-art main-menu composition with the user-approved dedicated main-menu pixel splash: Wizard, five-card table, MISDEAL title and painted **ВОЙТИ В ИГРУ** CTA.
- Upgraded the production main-menu splash from the 640×360 fallback to a native 1280×720 WebP reconstructed from three repository-safe chunks and rendered with linear filtering; only a transparent native Godot hotspot is layered over the painted CTA.
- Rebuilt the main menu around the production Wizard/table art and real MISDEAL logo instead of the old centered prototype panel.
- Replaced the generic **ВОЙТИ В ИГРУ** presentation with a single in-world **СЕСТЬ ЗА СТОЛ** action on the cursed tabletop.
- Removed the old procedural candles/eyes/card mockup from the active main-menu composition.
- Rebalanced **СИЛА ОДИНОЧКИ** after local playtest feedback that early three-enemy encounters were nearly impossible: solo now gets x2 HP, x1.8 damage, x1.25 attacks/second and x1.10 movement speed.
- Kept early enemy stats/encounter compositions and Bone Warden fixed rather than introducing party-size enemy scaling.
- Rebuilt protagonist class cards with dedicated portrait/title/stat/role/description regions instead of multiline button text under the sprite.
- Expanded and clipped wizard-table card description regions and moved **ВЫБРАТЬ / ПОВТОРИТЬ / ПРИНЯТЬ ВЫЗОВ** into a separated bottom strip.
- Raised battle result panels and command buttons above unit Y-sorting/floating combat feedback.
- Hide the finished **БОЙ** button when the post-battle continue action appears, removing duplicate overlapping button text.
- Combat now spawns only the current recruited party instead of always spawning Knight/Ranger/Mage.
- Major/bonus hero-upgrade offers are generated only from current party roles; solo runs can see multiple upgrade paths for the protagonist.
- General-pool hero-specific relics are filtered to current party roles, and Curse Forge disables relics for absent heroes.
- Squad dossier now shows unresolved/lost companions as faded fate entries and opens on the protagonist.
- Prologue now leads to class selection; **НОВЫЙ ЗАБЕГ** skips the comic but still requires a new protagonist choice.
- Existing event cards dynamically switch into recruitment scenes when the corresponding companion fate is still unresolved.
- Wizard table now exposes the current party build without leaving or regenerating the active card offer.
- Effective hero-stat calculation is centralized in `RunState.get_effective_hero_stats()` for the status UI and mirrors battle modifier order/clamps.
- Main-menu **ВОЙТИ В ИГРУ** now resets the run and opens the story intro before the wizard table; consecutive new runs from the run-end screen still go straight to the table.
- Capped optional hero development from events and Death Wager at 3 upgrades per run; the three guaranteed tier upgrades remain separate.
- Blood Ledger now restores an optional-upgrade slot when it erases an upgrade that came from the optional pool.
- Event HUD exposes the optional progression counter as **ДОП. X/3** and build-upgrade event choices disable cleanly at the cap.
- Death Wager converts its extra-upgrade branch to +45 gold when optional development is already 3/3.
- Retuned Bone Warden for the capped 4–6-upgrade target curve: 700 HP, 24 damage, 1.0 s cadence, 60 move speed and stronger phase-II enrage multipliers.
- Reworked progression-facing event cards so positive permanent rewards primarily grant hero development, relics or gold instead of generic party-wide HP/damage.
- Ash Rest and Last Camp now let the player develop a chosen hero directly.
- Gravedigger Shop and Candle Seller now sell the next concrete Knight/Ranger/Mage upgrade.
- Black Altar now trades party HP for a concrete role-specific hero upgrade.
- Chained Prisoner, Broken Crown and Bone Tax now include least-developed-hero progression paths.
- Faceless Card now rolls between gold, relic and hero-development outcomes; burning it can clear wizard debt.
- Blood Ledger now buys development, trades blood for relic/build progression, or erases the latest acquired hero upgrade for +70 gold.
- Whispering Well now trades blood/gold for hero development or relics instead of positive global stat buffs.
- Event HUD now shows compact development/relic counts and build-choice buttons wrap longer upgrade descriptions.
- Replaced ordinary post-combat gold / party HP / party damage choices with a build-progression flow: one guaranteed major hero upgrade per Act 1 tier, followed by normal or special loot.
- Normal non-special combat loot is now gold-only; permanent party HP/damage is no longer the default combat progression reward.
- Death Wager reward changed from raw +HP/+damage options to +60 gold / a visible available artifact / one additional hero-upgrade choice.
- Wizard-table HUD now emphasizes hero progression count and relic count instead of global HP/damage counters.
- Reward cards now use Knight/Ranger/Mage visual accents and wrapped text for build choices.
- Replaced all current combat-unit rendering with the final v3 unified 3×3 high-detail 96×96 pixel atlas covering Knight, Ranger, Mage, Skeleton, Bone Archer, Grave Bellkeeper, Bone Thrall, Crypt Guard and Bone Warden.
- Production v3 unit art is reconstructed from ten repository PNG-base64 chunks under `assets/pixel/units/combat_units_v3/`; `BattleUnit` validates the decoded 288×288 atlas before use.
- Grave Bellkeeper, Bone Thrall and Crypt Guard now have unique authored sprites instead of tinted Skeleton fallback art.
- Retuned unit sprite scale and HP/name offsets for the new detailed atlas: Thrall smaller, support near standard size, Crypt Guard elite-sized, Bone Warden boss-sized.
- Replaced the procedural battle wall/floor/HUD rendering with an authored full-screen gothic battle backdrop based on the user's second approved reference.
- General battle architecture, throne, candles, banners, chains, skull piles, ritual floor and UI frames are now painted into the backdrop; live units, HP, labels and buttons remain native Godot layers.
- Added the authored battle backdrop as five validated base64 WebP chunks under `assets/pixel/battle/authored_backdrop/`, decoded at runtime by `scripts/battle/authored_backdrop.gd`.
- Reduced `battle_visual.gd` to lightweight dynamic boss overlays so ordinary combat no longer gets a second procedural arena drawn over the authored art.
- Removed the obsolete procedural `battle_hud_visual.gd` renderer so the painted HUD chrome is not doubled.
- Re-aligned title/status/progress/faction labels and bottom command buttons to the painted frames in the authored backdrop.
- Rebuilt the live battle composition around the approved gothic pixel reference: denser crypt architecture, larger ritual floor, faction lighting split, heavy HUD framing and stronger command hierarchy.
- Replaced the core Knight, Ranger, Mage, Skeleton and Bone Archer textures with a new transparent 64×64 pixel set and increased live sprite scale/HP/name spacing.
- Expanded the live arena from 1200 to 1240 px and adjusted the hero deployment bounds to match the new composition.
- Restyled **БОЙ** as the dominant red primary action while keeping **ПЕРЕИГРАТЬ** visually secondary.
- Act 1 now guarantees at least one selected combat in each early/mid/late four-card tier while preserving two-card choice and rejection.
- The mandatory combat slot is randomized among the first three positions of each tier so combat pacing is controlled without becoming fully predictable.
- Death Wager enhanced reward reduced from +75 gold / +50 HP / +8 damage to +60 gold / +35 HP / +5 damage.
- Bone Warden first twelve-card retune to 580 HP / 22 damage was superseded by the 3+3 progression-economy balance pass: 700 HP / 24 damage with stronger enrage.
- Bone Warden final fight upgraded from a single stat/enrage check into a two-phase boss encounter; this new version is pending local verification.

### Added

- Added runtime-decoded approved event character decor for **Curse Forge** and **Chained Prisoner**, bringing the blacksmith and prisoner/environment silhouettes from the approved mockups into the live dynamic event screens without baking gameplay text or values into the background.
- Added a unified dark-gothic ritual presentation layer for non-combat choices: protagonist select, all generic Act 1 event cards, Whispering Well, reward/hero-development screens, prototype/fallback events and the Wizard wager modal now share the same visual hierarchy, framed choices and restrained motion.
- Added event-specific atmosphere variants to the generic event shell (forge sparks, chains, altar rings, bridge fog, candle glow and bone dressing) without changing event mechanics.
- Added combat presentation v2: arena-aware unit tint/rim/contact shadows, short hit-stop, impact sparks, undead bone-fragment deaths, Wizard combat commentary, dynamic arena atmosphere and a cinematic `СХВАТКА` start transition.
- Added data-driven battle arena families via `EncounterData.arena_id`: crypt, graveyard, ossuary and a dedicated Bone Warden lair.
- Distributed all current Act 1 combat encounters across the new arena families, adding distinct lighting, silhouettes, fog/stone/bone dressing and boss-lair chains/gate while preserving the existing combat layer and authored base backdrop.
- Added a richer cursed-table dressing pass: denser wood/runner detail, inlaid deck/discard zones, ritual marks, coins, wax seal and warmer light pools.
- Added stylized five-finger Wizard dealer hands below the live-card layer; they react to deals and visibly reach/glow during card substitution without intercepting input.
- Reworked the wizard table into a physical card spread: visible deck/discard piles, live counts, a 12-card fate track with XIII boss marker, staggered dealing, fan rotation, hover lift and choose/discard motion.
- Added lightweight procedural table-card audio for dealing, selection, discard and Wizard substitution; single-card retry/boss offers now use one centered slot.
- Added Wizard Memory v1: the Wizard now remembers eight behavior families across the run and can reference wagers, companion fates, debt-clearing, battle defeats/retries and greed-heavy gold choices at the table.
- Added role-aware and repeat-aware contextual Wizard lines while keeping memory narrative-only; it does not alter stats, card odds, encounter selection or rewards.
- Added the first voluntary Wizard wager modal at the cursed table: accept +25% enemy damage on the next combat for x2 next ordinary loot, or refuse with no mechanical penalty.
- Scheduled up to two wager opportunities per Act 1 run, suppressed while a Wizard debt is already active; accepted/refused counts are retained for future Wizard-memory dialogue.
- Added the Wizard's first active table cheat: two rare visible card substitutions per Act 1 run, one in the mid tier and one in the late tier.
- A meddling offer briefly locks, the targeted card flips edge-on, and the Wizard replaces it with another same-tier card from the same resolution family; the removed card remains eligible to appear later.
- Added a first combat-feel pass: subtle idle/breathing, role-aware melee/ranged/magic attack motion, ranged/magic tracers, stronger hit response and a falling/fading death presentation.
- Added lightweight runtime-generated combat SFX for melee, ranged and magic attacks, impacts, deaths, Bellkeeper healing, Bone Warden phase change, tactical-order selection, combat start and victory/defeat stingers.
- Three pre-battle tactical orders: **НАТИСК**, **ОХОТА**, **СТРОЙ**.
- **НАТИСК** adds +15% hero movement while keeping nearest-target behavior.
- **ОХОТА** dynamically prioritizes support and ranged enemies, including reinforcements that appear after combat has started.
- **СТРОЙ** dynamically focuses threats nearest the most vulnerable living ally.
- Tactical orders can be switched during deployment and lock when **БОЙ** starts.

- Per-run **КЕМ ТЫ БЫЛ, КОГДА ВСЁ НАЧАЛОСЬ?** class-selection scene after the story prologue.
- Runs now start with exactly one protagonist: Knight, Ranger or Mage.
- Persistent per-run companion fate states: **НЕ РАЗЫГРАНА / В ОТРЯДЕ / ПОТЕРЯН**.
- Knight recruitment through **ЗАКОВАННЫЙ ПЛЕННИК**, with **ПОСЛЕДНИЙ ПРИВАЛ** as fallback if fate remains unresolved.
- Ranger recruitment through **ГРЕМУЧИЙ МОСТ**, with **ПЕПЕЛЬНЫЙ ПРИВАЛ** as fallback.
- Mage recruitment through **ШЕПЧУЩИЙ КОЛОДЕЦ**, with **ЧЁРНЫЙ АЛТАРЬ** as fallback.
- Solo/duo compensation: solo +50% HP/+35% damage, duo +20% HP/+15% damage.
- Run-end party/fate summary.
- **ДОСЬЕ ОТРЯДА** modal on the wizard table, opened by **ОТРЯД [TAB]** or Tab.
- Knight / Ranger / Mage status tabs with portraits from the production combat atlas.
- Derived effective-stat view for HP, damage, attacks/second, range, movement, DPS, minimum range and splash when relevant.
- Base-stat comparison coloring so run changes are immediately visible.
- Per-hero lists of acquired upgrades and currently applicable relics, including party-wide relics.
- Dynamic presentation-only build names such as **ЖЕЛЕЗНАЯ СТЕНА**, **СНАЙПЕР**, **ЗАЛПОВИК**, **ПИРОМАНТ** and **СТЕКЛЯННАЯ ПУШКА**.
- Five-frame skippable dark-fantasy pixel-art comic prologue between the main menu and the first wizard-table deal.
- Intro narrative establishes the aged protagonist, the old pact with the Wizard and the offer to replay a life whose corrected choices rewrite the fates of everyone previously saved.
- Intro controls: click/Space/Enter to advance, painted top-right **ПРОПУСТИТЬ** button and Esc to skip, with short fades between frames.
- Five production 1280×720 WebP intro frames under `assets/pixel/intro/`.
- Data-driven `HeroUpgradeData` run-progression layer.
- Nine unique hero upgrades: three each for Knight, Ranger and Mage.
- Stable per-tier major-upgrade offers stored in RunState so each early/mid/late tier guarantees one build-defining choice after its first combat victory.
- Optional bonus-upgrade reward flow used by Death Wager.
- Hero upgrades apply to runtime HP, damage, attack cadence, range, minimum range, splash and movement before artifacts.
- Run-end summary now lists acquired hero upgrades.
- Dedicated **Bone Warden** combat art instead of reusing the normal Skeleton sprite.
- Dedicated **Bone Warden** final-card illustration.
- Dedicated final-boss arena treatment with red ritual geometry, barred gate, chains and stronger braziers.
- Bone Warden melee cleave: 60% splash damage in a 92 px radius.
- Bone Warden Phase II at 50% HP with a visible transition cue and one Bone Archer + one Bone Thrall reinforcement wave.
- EncounterData optional reinforcement paths/names/positions for small phase-based encounter additions.
- Larger Bone Warden name/HP presentation and pulsing multi-ring boss aura.
- Completed the full 24-card pre-boss Act 1 pool with bespoke mechanics; active cards no longer use the generic prototype resolver.
- Real **ГРЕМУЧИЙ МОСТ** early traversal event with risky, mixed-cost and safe crossing choices.
- Real **КОШЕЛЬ МЕРТВЕЦА** greed event with escalating gold-for-HP trades.
- Real **ТОРГОВЕЦ СВЕЧАМИ** early build shop selling role-specific hero development.
- Real **КОСТЯНАЯ ПОШЛИНА** forced payment event with gold, blood or HP-for-least-developed-hero progression.
- Real **СТАВКА НА СМЕРТЬ** late five-enemy elite encounter.
- Death Wager enhanced reward screen (now +60 gold / visible relic / extra hero-upgrade choice).
- Death Wager-specific **СТАВКА** battle framing and wizard reaction.
- Real late **КАРТА БЕЗ ЛИЦА** event with hidden random outcome, paid safe outcome and guaranteed low-risk burn choice.
- Real **КРОВАВАЯ КНИГА** build-manipulation event: buy development, trade blood for relic/progression, or sell the latest upgrade for gold.
- Special source-locked **СЛОМАННАЯ КОРОНА** artifact: party-wide +22% damage for -10 max HP per hero.
- `ArtifactData.general_pool` and party-wide `target_role = "*"` support for named special relics.
- Real **ПОСЛЕДНИЙ ПРИВАЛ** preparation event choosing a final Knight/Ranger/Mage development.
- Real **ВРАТА ОССУАРИЯ** late combat combining Crypt Guard, Grave Bellkeeper, Bone Archer and Bone Thrall.
- Ossuary Gate-specific preparation and victory framing.
- Real **ЧЁРНЫЙ АЛТАРЬ** event trading party HP for concrete Knight/Ranger/Mage development.
- Real **ЗАКОВАННЫЙ ПЛЕННИК** event with paid least-developed-hero training, blood-for-relic chain breaking, loot and refusal branches.
- Real **КОСТИ ДОЛЖНИКА** event with a 50/50 high-stakes gamble plus two deterministic alternatives.
- Real **ДЕСЯТИНА ВОЛШЕБНИКА** event with gold payment, HP payment or refusal.
- Temporary **ДОЛГ ВОЛШЕБНИКУ** run condition: +25% enemy damage until the next normal reward.
- Wizard debt doubles the next normal gold loot to +50 gold and clears when that loot is taken.
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
- Real **ПЕПЕЛЬНЫЙ ПРИВАЛ** choices: directly develop Knight, Ranger or Mage, or refuse.
- Functional **ЛАВКА МОГИЛЬЩИКА** selling the next role-specific hero development for gold.
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
- Approved battle composition reference archived at `assets/concepts/approved_battle_direction.jpg`.
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
- First dark-fantasy pixel-art combat sprite set for Knight, Ranger, Mage, Skeleton and Bone Archer (superseded by the new 64×64 set in the approved battle-visual rebuild).
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
- One-time Whispering Well state and three choices: blood-for-development, gold-for-relic/build fallback, or refusal.
- Whispering Well gold spend now buys a relic/build fallback rather than raw party HP.
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
