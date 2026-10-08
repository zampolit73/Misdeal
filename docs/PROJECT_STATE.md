# Misdeal — Project State

Last updated: 2026-10-09

## Fate Spread edge-art integration — 2026-10-09

The full-screen reference-underlay approach was retired after local review because it had to be darkened so aggressively that the approved physical-table atmosphere disappeared. The approved direction is now implemented as **edge-art plates** instead:

- `assets/pixel/table/fate_spread/edge_top.webp` — candle/brass/gothic top rail;
- `assets/pixel/table/fate_spread/edge_left.webp` — left ritual props and red cloth;
- `assets/pixel/table/fate_spread/edge_right.webp` — right skull/candle/brass props.

These plates are loaded through the established `runtime_webp_texture.gd` path, not direct Texture2D imports. They sit behind live UI at near-full brightness while the center remains the authoritative procedural Fate Spread. High-quality source masters are archived under `assets/source_archive/fate_spread_edges/`.

The old `reference_underlay.webp` is no longer a runtime dependency.

## Fate Spread underlay visibility fix — 2026-10-09

Local screenshots showed that the approved ornate reference plate was technically present but visually crushed by the opaque Frame panel, so the screen still read as a flat black modal. The underlay is now a child of `Frame`, drawn above the frame background but beneath all live UI. The outer frame and global scrim are much lighter, making candle/metal/red-cloth edge props visible.

To prevent baked concept-state from leaking into gameplay, the live central `TableSurface` is now much more opaque and masks the reference plate across the whole ring area, while a dedicated dark header shade suppresses the concept image's baked title/counters. Live side panels likewise cover the concept's side-card state. The goal is: visible physical-table atmosphere at the edges, authoritative live data in the center.

## Fate Spread approved-reference integration — 2026-10-08

The user approved the ornate physical-table Fate Spread reference with candles, brass/iron props, red ritual cloth and a stronger carved-gothic tabletop presentation. The game does **not** bake that screenshot's run-specific cards/counters into gameplay. Instead, a darkened/blurred derivative is stored at `assets/pixel/table/fate_spread/reference_underlay.webp` and blended beneath the live Fate Spread UI.

`scenes/table/fate_spread_overlay.tscn` now exposes the underlay through a translucent frame/scrim while the procedural central surface, live I–XII cards, XIII seal, counters, hold/discard state and hover memory remain data-driven. This keeps the approved atmosphere without making the current run visually lie.

## Fate Spread physical-table + memory pass — 2026-10-08

The Fate Spread now gains the three follow-up layers requested after local screenshot review:

1. **Physical table presence.** The central spread area sits over a restrained procedural red-black table surface with worn grain, scratches, ritual staining and a soft vignette. It stays intentionally quiet beneath the existing seal/cards instead of turning the inspection view into another full-screen illustration.
2. **Run-choice memory.** `RunState` now records the chosen/rejected pair for each resolved pre-boss card. Hovering a completed Fate Spread card enlarges it and opens a compact memory strip showing the chronological slot, chosen card and the alternative rejected at that decision. Existing in-progress runs have a compatibility fallback based on resolved/rejected order.
3. **Act milestones.** IV, VIII and XII are now one-shot ritual beats. After the table unlocks following those thresholds, the Fate Spread automatically opens once, plays a dedicated low ritual sound and pulses/shakes the central seal/XIII. The shown milestone is persisted in `RunState` so reopening the spread does not replay it.

The existing XIII chain rules remain: two chains early, one chain from VIII onward, awakened/unsealed presentation when the boss becomes due.

## Fate Spread reference-driven polish — 2026-10-08

A second visual pass now follows the approved Fate Spread reference more closely instead of treating the screen as a plain radial menu. The live spread has a dedicated occult seal layer beneath I–XII, a dim fate-thread connecting the twelve positions, brighter completed path segments, chapter gates after IV/VIII/XII, inward ritual spokes and a central sigil whose blood/ember intensity increases with run progress.

XIII now has its own live chain/seal overlay. Two crossed chains hold the boss card early in the act; one visually breaks away entering the final chapter, and the seal disappears into an awakened mark once the Bone Warden is due. Side holders were shortened to return visual priority to the central ritual composition. Chapter typography also escalates from gold to ember/red as the act advances.

All of this remains procedural/live UI; no progress values or run history are baked into static art.

## Fate Spread local screenshot correction — 2026-10-08

The first local 1280×720 screenshots confirmed the progression concept but exposed a presentation defect: the live two-card offer and the table access button could render above the inspection view, obscuring the historical ring and XIII. The inspection overlay now uses a valid top CanvasItem z-index, explicitly hides the live deal/progress access while open, restores them on close, and uses smaller historical-card slots with a wider ring so the central boss card reads as the focal point.

## Fate Spread Act progression — 2026-10-08

The user-approved **РАСКЛАД СУДЬБЫ** progression concept is now implemented as live Godot UI rather than a baked screenshot.

The cursed table now keeps a restrained 12-position occult progress ring behind the active deal, with the central mark reserved for XIII / Bone Warden. A new `РАСКЛАД СУДЬБЫ [R]` action opens a full inspection overlay showing:

- positions I–XII populated in chronological order with the actual resolved card art and titles;
- the current unresolved position highlighted separately;
- central XIII sealed until the boss is due, then revealing the Bone Warden art;
- current act chapter label: **ПЕРВАЯ РАЗДАЧА**, **СТОЛ ПОМНИТ**, **ПОСЛЕДНЯЯ РАЗДАЧА**, then **ПРИГОВОР**;
- live counts for resolved, rejected and currently held cards;
- the held-card area using the real held card art/status;
- the Wizard discard showing the most recently rejected card and rejected-card count.

The table's ordinary right-side discard now counts rejected cards only; resolved cards are represented by the Fate Spread itself. Future slots remain genuine unknowns instead of pretending that future card types are already scheduled. This is currently a progression/readability system only; it does not change offer RNG, Act 1 length or encounter rules.

## Current status

Misdeal has a working tactical autobattle slice and a first finite run structure.

Confirmed locally by the user:

- base autobattle and restart;
- pre-battle hero placement;
- combat-time unit separation;
- hit/death feedback;
- data-driven `UnitData`;
- Bone Archer keep-distance behavior;
- hard combat-arena bounds;
- first `table -> battle -> reward -> table` loop;
- cleaned-up victory/defeat result overlay.

The original three-victory finite run was implemented and confirmed working locally, then deliberately replaced by the longer Act 1 structure described below.

Phase 3 identity work is underway. The first non-combat event card and one-time event flow are confirmed working locally.

The earlier painted-art integration was locally judged too hard to read in combat. The user chose a dark-fantasy pixel-art direction.

The first pixel-art combat readability redesign is implemented and confirmed working locally.

The second battle presentation pass is implemented and confirmed visually acceptable locally.

The same pixel-art visual language is now applied across the main menu, Whispering Well event, reward screen and run-end screen.

The user-approved full **card-art set** is now integrated in GitHub and pending local verification. All 25 active Act 1 table cards, including Bone Warden, use their own authored pixel-art illustration from the approved generation pass instead of reusing the old five-image pool. All nine hero-development paths now have distinct approved art, and the six generated reward-state illustrations are wired into ordinary loot, Death Wager and elite-reward cards. Generic Act 1 choice events also reuse the active card's approved illustration in the upper half of each choice card while Forge and Chained Prisoner keep their dedicated per-option art. The first integration was locally rejected for image quality because it had downsampled these illustrations to only 88×54 px for table cards and 80×48 px for development/rewards before scaling them back up. That thumbnail atlas has now been superseded by near-display-resolution runtime-decoded WebP atlases: 224×137 px per table-card cell and 304×194 px per development/reward cell, stored as raw `.bin` bytes so Godot decodes the WebP directly without importer fragility. Gameplay values and text remain live Godot UI.

A focused **special-event / artifact presentation polish** pass is now in `main` and pending local verification. The Wizard wager modal now presents its price and reward as two illustrated framed terms instead of a single text block, with a larger ceremonial panel and stronger accept/refuse hierarchy. Curse Forge now layers a high-resolution forge scene behind the approved blacksmith decor, uses a tighter header, larger artifact cards and a dedicated object-centric artifact atlas. The same artifact atlas is also used by Death Wager and Crypt Guard artifact rewards, and Broken Crown event choices now show the crown itself rather than only the generic event illustration. Mechanics, prices, artifact stats and wager rules are unchanged.

A broader **event-window hierarchy polish** pass is also now in `main` and pending local verification. Generic Act 1 event windows now use the active event's pixel art as a framed context image in the header instead of leaving the upper body as empty black space; gold and run-state information sit in compact framed chips; role-development choices use the actual next upgrade illustration instead of repeating the event image; and several risk/reward events use semantic border accents so safe, costly and dangerous choices separate at a glance. This directly affects Candle Seller, Gravedigger Shop, Ash Rest, Last Camp, Black Altar and the other shared Act 1 choice screens without changing their mechanics. Whispering Well received the same treatment: each choice now has an illustrated upper band using the relevant well, upgrade or relic art while keeping all live text and disabled-state logic native.

The first local pull of that pass exposed a Godot 4.7.2 parser-inference failure in the new semantic style loop (`disabled` / `active` were inferred from an untyped loop value). The style-name arrays, styleboxes and boolean flags are now explicitly typed in both `act_choice.gd` and `whispering_well.gd`; no presentation behavior was changed by the fix.

Wizard Wager received a second local-review polish pass: the modal is shorter and tighter, risk/reward cards use larger art, red-vs-gold separation is stronger, a central contract sigil visually binds the two sides of the deal, and the accept button now has its own stronger ember hover/glow style instead of borrowing generic card hover chrome. Mechanics and wager values are unchanged.

A final local-review refinement reduced the outer orange frame emphasis, extended the contract line beneath the two terms, brightened/enlarged the reward illustration, promoted the `x2` value and pulled both action buttons closer to the offer cards. This is intended as the final Wizard Wager presentation pass unless new local screenshots expose a concrete defect.

A local Gallows Volley screenshot exposed a battle-floor mismatch: ranged retreat and ordinary unit separation could legally push any unit into the authored background above the stone floor because the encounter still used the old full-height combat rectangle. **ЗАЛП С ВИСЕЛИЦЫ** now has an encounter-specific combat floor and matching deployment band; its solo/duo/trio default positions were moved onto that same playable plane. The fix applies to every unit type in the encounter, including retreating Ranger/Bone Archer units, rather than special-casing archers. Pending local verification.

The next local screenshot pass fixed two concrete layout defects. Shared Act 1 event cards now keep their bottom action inside the 1280×720 viewport instead of letting merchant/choice footers clip below the screen; Chained Prisoner has its header moved upward, a dedicated 230 px choice row and a separate bottom leave action so its three illustrated cards no longer collide with the footer. Squad Dossier now renders above all table content and temporarily hides the live offer-card layer while open, preventing an encounter card from punching through the dossier. The dossier portrait was enlarged and the center/right columns rebalanced for more readable stats, development and relic sections.

The approved 2026-10-07 full-screen mockups for **ШЕПЧУЩИЙ КОЛОДЕЦ** and **ЗАКОВАННЫЙ ПЛЕННИК** are now implemented as a dedicated choice-card polish pass. Their exact approved top-card illustrations were cropped into a 384×160-per-cell runtime WebP atlas and wired back into the live scenes, while titles, costs, disabled states and outcomes remain Godot controls. Chained Prisoner now uses blue/red/amber semantic card accents, larger illustrated bands and a higher compact header; Whispering Well uses distinct well/treasure/leave art, larger card illustrations, divider medallions and explicit disabled-state ribbons such as **НЕДОСТАТОЧНО ЗОЛОТА**. The same divider/medallion treatment is available across the shared Act 1 choice shell, improving card readability without creating bespoke event logic.

A first **cross-card consequence / rescue-scar** pass is now in `main` and pending local verification. Act 1 events can store explicit outcomes and later cards read them: Lost Purse changes Gravedigger Shop prices (careful handling lowers them to 30, greedy handling raises them to 45), Debtor Bones changes Wizard Tithe's gold price (25 after caution, 40 after gambling/breaking the bones), and resolving Blood Ledger before Broken Crown adds a +15 gold knowledge bonus to the crown-melting route. Companion rescues by sacrifice now create named protagonist scars instead of anonymous party-wide HP loss: Knight rescue creates **ШРАМ ЦЕПЕЙ** (-10 max HP), Ranger rescue creates **ШРАМ ДОРОГИ** (-8 max HP), and Mage rescue creates **ШЁПОТ ПОД КОЖЕЙ** (-12 max HP). These scars affect effective protagonist stats and are listed in Squad Dossier. Wizard Memory also reacts to receiving scars, surviving at least six cards alone, and deliberately abandoning both possible companions.

The **cursed tactical order / Wizard tell** pass is now in `main` and has been locally confirmed working. Accepting a voluntary Wizard wager grants exactly one opportunity in the next combat to choose the fourth tactical order **ЖЕРТВА**. It gives the whole party +40% damage and +20% attack speed for that battle, while every living hero continuously loses 2% of their own max HP per second. The order is consumed when that next combat begins whether selected or not, so it cannot be banked through retries. Wizard Memory records actually choosing the order. The same battle pass also fixes rescue-scar HP penalties in live combat spawning so the dossier and autobattle now use the same protagonist max-HP cost.

The first **meaningful defeat / Last Deal** pass is now in `main`; the user has confirmed the flow is working locally. Free combat retry after defeat has been removed. On the first defeat of a run, the result overlay becomes **ПОСЛЕДНЯЯ СДЕЛКА**: the Wizard offers exactly one paid retry of that same active combat. If the player owns relics, one owned relic is selected and shown as the explicit price; accepting permanently removes it. If no relic is available, the price becomes **КЛЕЙМО ПОСЛЕДНЕЙ СДЕЛКИ**, a persistent -15 max-HP penalty on the protagonist. The deal can be accepted only once per run and is consumed immediately; losing again after using it ends the run. Refusing the offer also ends the run. Defeat now routes to a real failed-run end screen instead of returning to the table for a free retry. The Last Deal HP brand is included in effective protagonist stats, live battle spawning, Squad Dossier and the final run summary.

The table now has restrained Wizard tells without adding new decorative clutter: deal motion becomes slower/smoother when accepted wagers outnumber refusals and sharper when refusals dominate; a card gives a brief physical twitch before a scheduled Wizard meddling swap; and companion-loss / deliberate-loner memory lines briefly dim the live card layer while rescue-scar remarks warm the commentary line. These are presentation reactions only and do not alter offer RNG.

A **battle HUD readability + static balance audit** pass is now in `main`. The long preparation line has been split into two responsibilities: the left side shows a concise encounter-specific threat/tactical cue, while a dedicated right-side condition label shows solo/duo compensation, Wizard debt, Sacrifice availability or prior Last Deal use. This fixes the 1280×720 overlap seen around `КАРТА 9/12` on Death Wager and makes dangerous encounters easier to parse before pressing **БОЙ**. The current combat numbers were audited against baseline solo/duo/trio aggregate HP/DPS and intentionally left broadly unchanged: solo and duo remain close in baseline total output while trio retains a meaningful full-party advantage, and the fixed 700-HP Bone Warden / late elite compositions stay as benchmark encounters until actual full-run evidence identifies a concrete outlier. `docs/CONCEPT.md` has also been corrected to match the implemented solo compensation (`HP ×2`, `damage ×1.8`, attacks ×1.25, movement ×1.10).


A targeted **Gallows floor-alignment** fix is now in `main` and pending local verification. The Gallows Volley encounter now uses a lower, tighter combat floor rectangle that matches the authored stone platform; solo/duo/trio starting positions and enemy spawns were moved onto that floor, and `BattleUnit.set_combat_bounds()` now clamps immediately so any spawn/reinforcement position outside the legal floor cannot remain visibly suspended during preparation or the combat intro. The fix is systemic at the unit-boundary layer but intentionally retunes only Gallows geometry until fresh screenshots identify another arena mismatch.

A new **Act 1 fate/table-depth** pass is now in `main` and pending local verification. Rescue scars are no longer pure penalties: **ШРАМ ЦЕПЕЙ** gives free passage at Bone Tax instead of another blood payment, **ШРАМ ДОРОГИ** cuts the Faceless Card's deterministic-development price from 30 to 15 gold, and **ШЁПОТ ПОД КОЖЕЙ** reduces Blood Ledger's blood-signing cost from 25 to 10 party HP. The cursed table also gains one **УДЕРЖАТЬ** action per Act 1: while a normal two-card offer is visible before the final stretch, the player may reserve one card, must choose the other now, and the held card is guaranteed to return after two resolved cards. Finally, two scheduled offers per run may carry a visible **ПЕЧАТЬ ВОЛШЕБНИКА**. Choosing the marked card immediately grants +20 gold but makes enemies deal +15% damage until the next combat is won; declining it has no mechanical penalty. Mark risk cannot overlap with a second mark, but it can stack additively with Wizard debt because both are visible self-authored risks.

A follow-up **Act 1 tactical/readability consequence** pass is also now in `main` and pending local verification. Four combat encounters now change the legal pre-battle deployment geometry instead of sharing one universal rectangle: Gallows Volley uses a deep vertical line, Bone Crush splits the player into two horizontal bands, Ossuary Gate provides two separated deployment pockets with the center closed, and Bone Warden compresses the party into a tighter starting zone. The legal regions are shown as subtle live panels and drag-clamping supports multiple disconnected regions. Combat cards on the Wizard table now surface compact threat tags such as `РОЙ`, `ЛЕЧЕНИЕ`, `AOE`, `2 ЛУЧНИКА` and `ФАЗЫ`, so the two-card decision can be made with current party/build context instead of art/title alone. Finally, **КАРТА БЕЗ ЛИЦА** can now perform a late-act reckoning on the whole run: deliberately losing both companions, carrying at least two rescue scars, or repeatedly accepting Wizard-authored risks unlocks a distinct fourth resolution through the existing leave action. The three profiles are **БЕЗ СВИДЕТЕЛЕЙ**, **ИСПИСАН ШРАМАМИ** and **ЛЮБИМЕЦ СТАВОК**; each gives a different concrete payoff without adding a hidden morality meter.

A new **combat temptation / resistance / boss-verdict** pass is now in `main` and has been locally confirmed working by the user. Three encounters can carry visible optional combat conditions from the Wizard for +15 gold on victory: **Могильный звон** asks the player to kill the Bellkeeper first, **Залп с виселицы** asks that no hero fall below 25% HP, and **Костяная давка** asks for a clear within 16 seconds. These conditions are shown in a compact live panel during preparation/combat and fail visibly when the requirement is broken. Refusing two visible Wizard-authored offers across wager refusals and marked-card refusals now unlocks the one-battle tactical order **НЕПОВИНОВЕНИЕ**: the party deals 15% less damage but takes 20% less incoming damage. Like `ЖЕРТВА`, the option is consumed when the next combat begins whether selected or not. Finally, Bone Warden Phase II now reads the same aggregate Act 1 reckoning used by Faceless Card without changing the boss's base 700 HP or baseline damage: **БЕЗ СВИДЕТЕЛЕЙ** summons two Bone Thralls, **ИСПИСАН ШРАМАМИ** summons a Grave Bellkeeper who can heal the boss, **ЛЮБИМЕЦ СТАВОК** summons two Bone Archers, and an untyped run keeps the existing Archer + Thrall reinforcement pair. The verdict is surfaced before and during the boss fight rather than hidden.

The first two main-menu rebuilds were rejected in local visual review. A dedicated dark-fantasy pixel-art splash was then generated, explicitly selected by the user, and is now the approved production start screen. It shows the Wizard looming over a five-card cursed table, the large MISDEAL title, the line **«Проклятая партия уже разложена.»** and a painted **ВОЙТИ В ИГРУ** button. Runtime reconstructs the approved 1280×720 WebP from three repository-safe base64 chunks and renders it at native project resolution with linear filtering; the corrected Wizard card hand now has five fingers, and only a transparent native Godot button hotspot remains live over the painted CTA.

A skippable five-frame pixel-art story prologue is now implemented in GitHub and pending local verification. It establishes the old pact, the aged protagonist and the Wizard's offer to replay a life whose corrections will rewrite the fates of everyone the protagonist once saved.

The wizard table has since been rebuilt again around an approved authored pixel-art concept.

The final composition/readability polish pass has been locally verified and accepted:

- encounter hover no longer uses floating tooltips over card art;
- hovering a combat card now swaps the upper wizard-commentary line to that encounter's wizard reaction;
- the Whispering Well has its own hover commentary;
- the HUD and commentary strip are more compact;
- the four cards are slightly smaller, lower and more evenly spaced so the wizard remains visible;
- obsolete procedural skull/goblet/hourglass/books/candle overlays were removed;
- the lower runner/sigil treatment was simplified and subdued.

The original Bone Warden boss encounter, including its 50% HP enrage, was confirmed working locally. After full Act 1 playtesting the user reported that the boss was too easy and visually insufficiently distinct from ordinary combat.

A Bone Warden gameplay + visual rework is implemented in GitHub and pending local verification. The first local pull exposed a Godot 4.7.2 type-inference parser error in the new procedural boss-arena chains; that parser issue was fixed.

After comparing the live battle screenshot against the approved richer pixel mockup, the procedural battle renderer was replaced by an authored full-screen battle backdrop matching the second approved reference much more closely. The first local pull exposed two wiring faults: a truncated 8.7 KB WebP and a negative z-index that placed the backdrop behind the black fallback. Both faults were fixed, and the user has now confirmed the authored battle backdrop looks correct locally.

The full combat-unit sprite art pass is now locally confirmed working. All nine currently used combat roles have dedicated high-detail dark-fantasy pixel sprites in one 96×96 atlas; special enemies no longer reuse tinted Skeleton art. The final v3 atlas is stored as ten base64 PNG chunks under `assets/pixel/units/combat_units_v3/` and decoded by `BattleUnit`. The obsolete v2 preload/fallback was removed after it caused a Godot parser/import failure.

A first real **hero build progression** layer is implemented in GitHub and pending full-run local verification. Ordinary post-combat +HP/+damage choices are no longer the main progression path.

A follow-up **build-aware event pass** is also implemented in GitHub and pending local verification. Positive permanent event rewards now primarily use hero development, artifacts or gold; raw global HP/damage changes remain mainly as costs, penalties or legacy named artifact effects.

The longer Act 1 structure is now confirmed working locally: 12 resolved pre-boss cards followed by the Bone Warden as card 13.

The first real post-structure content batch is implemented: **ПЕПЕЛЬНЫЙ ПРИВАЛ**, **ЛАВКА МОГИЛЬЩИКА** and **КУЗНИЦА ПРОКЛЯТИЙ** have real choices instead of the generic prototype resolver.

The first new combat-content batch is also implemented in GitHub and pending local verification: **МОГИЛЬНЫЙ ЗВОН**, **КОСТЯНАЯ ДАВКА** and **СТРАЖ СКЛЕПА** are real combat cards.

A second real event batch is implemented in GitHub and pending local verification: **ЧЁРНЫЙ АЛТАРЬ**, **ЗАКОВАННЫЙ ПЛЕННИК**, **КОСТИ ДОЛЖНИКА** and **ДЕСЯТИНА ВОЛШЕБНИКА** no longer use the prototype resolver.

The late-game escalation batch is implemented and locally confirmed working: **КАРТА БЕЗ ЛИЦА**, **КРОВАВАЯ КНИГА**, **СЛОМАННАЯ КОРОНА**, **ПОСЛЕДНИЙ ПРИВАЛ** and **ВРАТА ОССУАРИЯ** are real cards.

The final five-card content batch is locally confirmed working: **ГРЕМУЧИЙ МОСТ**, **КОШЕЛЬ МЕРТВЕЦА**, **ТОРГОВЕЦ СВЕЧАМИ**, **КОСТЯНАЯ ПОШЛИНА** and **СТАВКА НА СМЕРТЬ** all have bespoke mechanics. The full 24-card pre-boss Act 1 pool is content-complete with no active prototype-card routes.

The first Act 1 balance/readability pass is implemented in GitHub and pending local verification. It focuses on combat pacing, Death Wager reward inflation and final-boss difficulty rather than broad retuning of every event.

Local hard-roguelike testing then exposed that the original solo compensation (+50% HP / +35% damage) was not enough to survive the first mandatory combat encounters. This was a real action-economy problem rather than a placement-only issue.

A solo rebalance is now implemented in GitHub and pending local verification:

- solo max HP multiplier: x2.0;
- solo damage multiplier: x1.8;
- solo attack interval multiplier: x0.80, equivalent to +25% attacks/second;
- solo move-speed multiplier: x1.10;
- duo remains +20% HP / +15% damage;
- trio remains unmodified;
- early enemy resources and encounter compositions were deliberately left unchanged;
- Bone Warden remains a fixed benchmark and still does not scale dynamically to party size.

A follow-up UI-overlap polish pass was implemented after local screenshots exposed three readability faults:

- protagonist class cards no longer use multiline `Button.text` underneath the portrait; portrait, class name, stats, role and description now occupy separate fixed regions;
- wizard-table offer cards have a taller clipped description region and a dedicated bottom hint/action region, preventing long event copy from colliding with **ВЫБРАТЬ**;
- battle result UI now lives in a dedicated high-layer `CanvasLayer` with a dim fullscreen scrim, so unit sprites/HP bars cannot render over the victory/defeat modal;
- the result panel was moved upward and given more vertical breathing room, while tactical-order controls are hidden once combat ends;
- the finished **БОЙ** button is hidden when **ЗАБРАТЬ НАГРАДУ / ВЕРНУТЬСЯ К СТОЛУ** appears, removing duplicated bottom text.

The first combat-feel / audio pass is implemented in GitHub and has been confirmed locally:

- all living units have a subtle sprite-only idle/breathing motion without moving their actual combat position;
- melee attacks use a stronger forward lunge, ranged attacks use recoil plus a brief tracer, and Mage/Bellkeeper attacks use a colored magical tracer/pulse;
- hit feedback keeps the existing flash/pulse and adds a tiny sprite kick without changing navigation position;
- death hides combat UI immediately, tilts/drops the miniature and fades it as a corpse silhouette;
- battle SFX are generated at runtime as lightweight deterministic 16-bit PCM placeholders: melee, bow, magic, hit, death, heal, boss phase, tactical-order click, combat start and victory/defeat stingers;
- the SFX system uses a small polyphonic voice pool and short cooldowns so swarm fights do not become an audio wall;
- no external audio asset pack or generalized animation framework was added; authored sound/music can replace the placeholders later without changing combat rules.




A **choice / event / reward presentation pass** is now implemented in GitHub and pending local verification. It unifies the non-combat decision screens with the approved dark-gothic table language without changing event logic:

- protagonist selection now uses the authored Wizard/table backdrop, Misdeal logo, ritual frame, subtle ambient effects and hover/entrance motion instead of a flat black frame;
- the generic Act 1 event-choice scene now covers all current event cards with one ornate layout, larger decision cards, explicit disabled states, animated hover feedback and card-specific accent/atmosphere families (forge, chains, altar, bridge fog, candle glow and bone dressing);
- **Whispering Well** keeps its teal identity but now shares the logo/HUD hierarchy, framed header and large card-like choices used elsewhere;
- reward / hero-development screens now sit over the authored Wizard backdrop with a compact run HUD, stronger header frame, richer role-colored reward cards and hover feedback;
- the hero-development state now uses the exact accepted screen-art illustrations for **ЖЕЛЕЗНАЯ КЛЯТВА**, **СТЕКЛЯННОЕ СЕРДЦЕ** and **ПАЛАЧ**; the mistaken combat-atlas portrait fallback has been removed. The same accepted art source now feeds **КУЗНИЦА ПРОКЛЯТИЙ** and **ЗАКОВАННЫЙ ПЛЕННИК** choice cards where matching approved illustrations exist;
- prototype/fallback event cards use the same ritual shell instead of the old isolated black panel;
- the table's **СТАВКА ВОЛШЕБНИКА** modal is larger, darker and more ceremonial, with stronger accept/refuse hierarchy and heavier dimming behind it;
- these are presentation-only changes: event costs, rewards, recruitment outcomes, upgrade logic, Wizard wager rules and scene transitions are unchanged.

A **large combat presentation pass (v2)** is now implemented in GitHub and pending local verification. It deliberately keeps combat rules/AI unchanged while polishing the live battle layer:

- every unit now gets an arena-aware ambient tint, a low-alpha team rim silhouette and a softer two-stage contact shadow so miniatures sit inside the authored background instead of reading as pasted sprites;
- successful attacks add short combat-simulation hit-stop, directional sprite kick and three-ray impact sparks without changing actual navigation positions;
- undead deaths now burst into lightweight bone fragments before the existing fade/drop, while heroes use a slower fall so ally defeat reads differently from enemy cleanup;
- the lower preparation HUD is rebuilt as one coherent dark gothic panel with stronger pressed-state order buttons, a larger central **БОЙ** control and the unused restart control hidden until battle end;
- a dedicated Wizard commentary strip now reacts to combat start, the first critically wounded hero, a surviving hero death and Bone Warden phase II;
- dynamic arena atmosphere now sits over the authored backdrops but under units: graveyard fog/crow drift, crypt fire glow, ossuary dust/haze and Warden red haze/embers; Bone Warden runes remain intact;
- pressing **БОЙ** now removes the preparation controls, shows a short **СХВАТКА / encounter title** transition, then starts the autobattle and Wizard commentary;
- these changes are presentation-only: tactical orders, target selection, damage values, attack intervals, combat bounds, placement and encounter compositions are unchanged.

A first **active Wizard interference** pass is now implemented in GitHub and pending local verification:

- the Wizard now secretly schedules two meddling moments per Act 1 run: one during the mid tier and one during the late tier;
- when one triggers, the current two-card offer is shown first, selection locks briefly, and the Wizard visibly flips one card edge-on and replaces it;
- replacement stays inside the same tier and the same resolution family (combat replaces combat, event replaces event), preserving the run's mandatory-combat pacing while still allowing a normal combat to become an elite combat or one event to become a harsher event;
- the swapped-away card is not consumed and can still appear later, while the replacement becomes part of the real current offer;
- active/retry cards and the Bone Warden boss offer are never meddled with;
- this is intentionally theatrical offer manipulation, not hidden stat cheating or a new generalized curse system.

The first **voluntary Wizard wager** layer is implemented and has been confirmed locally:

- the Wizard schedules up to two wager offers in Act 1: an early offer around cards 3-4 and another after card 7;
- the wager appears as a blocking table modal before the player chooses the next card;
- accepting activates the existing **ДОЛГ ВОЛШЕБНИКУ** state: the next combat deals +25% enemy damage and the next ordinary loot reward is doubled;
- refusing has no mechanical punishment; the Wizard only comments on the refusal;
- an existing debt suppresses scheduled wager prompts so debt states never stack;
- the existing Wizard Tithe refusal still uses the same debt mechanic, and Faceless Card can still clear it;
- accepted/refused wager counts are stored in `RunState`.

A first **Wizard Memory v1** layer is now implemented in GitHub and pending local verification:

- `RunState` records eight player-behavior memories: accepting a wager, refusing a wager, recruiting a companion, abandoning a companion, clearing Wizard debt through a special escape, losing a battle, retrying the same battle and choosing greed-heavy gold outcomes;
- memory is narrative-only: it does not alter stats, card odds, combat rules, rewards or hidden difficulty;
- the table consumes one pending contextual memory line when no higher-priority Wizard interaction is active;
- priority is explicit: boss/table-critical states and active meddling/wager modals take precedence, then remembered behavior, then generic progress commentary;
- companion memories are role-aware for Knight, Ranger and Mage;
- repeated behavior gets different follow-up lines, so repeated wager acceptance/refusal, defeat and greed do not always repeat the same text;
- current hooks cover companion fate resolution, voluntary wagers, Faceless Card debt-clearing, battle defeat/retry, Lost Purse greed, Broken Crown greed and Death Wager gold selection;
- the system intentionally stores compact event/count state instead of a dialogue graph so future hero-story chains can reuse it without creating a second narrative-state architecture.

The **physical card-table staging pass** is implemented and has been confirmed locally:

- the two-card offer is no longer presented as a flat HBox menu; live cards sit in a loose fan with slight opposing rotations;
- a visible deck pile and discard pile frame the central offer, with live counts derived from `RunState`;
- a 12-card fate track plus a separate XIII boss marker makes the Act 1 layout read as an unfolding spread rather than a sequence of menus;
- each new offer is visibly dealt from the deck with a short staggered slide/flip-in motion and procedural card-slap audio;
- hover lifts and straightens a card without changing selection rules;
- selecting a card pulls it toward the center while the rejected card physically flies into the discard pile before scene transition;
- Wizard card substitution now waits for the deal animation and uses the same physical staging, so his interference reads as taking a card back and replacing it;
- single-card retry/boss states collapse to one central table slot instead of preserving a fake two-choice layout;
- the pass adds no card physics, drag-to-play interaction or 3D table system; it is presentation-only and keeps the existing two-choice run rules intact.

A richer procedural **table-art dressing experiment** was implemented and immediately rejected in local visual review because it overlaid the authored Wizard/table art with a second, incompatible visual language. The gray procedural dealer hands, large inlaid zones, dense orange geometry and extra props made the table feel like a debug/HUD layer rather than a dark-fantasy card scene.

That experiment has been superseded by a **clean table-art pass**, implemented and confirmed locally:

- the procedural dealer hands are removed entirely; the authored Wizard art remains the only visible character/hand treatment;
- large side inlays, heavy orange frames, extra coins/wax props, stitched borders and dense rune geometry are removed;
- the central cloth/sigil is reduced to a very faint grounding treatment rather than a second UI frame;
- deck and discard remain as small physical card stacks with understated labels, preserving the useful "real table" read without side panels;
- the 12-card progress spread remains, but is reduced to tiny low-contrast diamond marks plus a restrained boss marker;
- all successful physical behavior from the previous pass remains: deal-from-deck motion, card fan, hover lift, choose/discard animation, Wizard substitution timing and centered single-card states;
- the guiding rule is now **authored background first, live cards second, supporting table UI last**.

A follow-up **table hierarchy polish pass** is now implemented in GitHub and pending local verification after screenshot review:

- the painted background-card row is pushed back with a quiet lower-table veil so it reads as authored scenery rather than a second interactive card layer;
- the top stats HUD is shorter, lighter and less opaque;
- the Wizard commentary strip is also reduced in height/opacity so more of the authored character art stays visible;
- the squad button is reduced to the same quieter chrome instead of reading as a separate heavy panel;
- the fate track moves to the top edge of the table, becomes lower-contrast, and the text is reduced from **РАСКЛАД СУДЬБЫ • 02/12** to the compact **02/12** counter;
- live cards, deck/discard piles and all physical deal/hover/selection animations remain unchanged.

A first **multi-arena battle pass** is now implemented in GitHub and pending local visual verification:

- `EncounterData` now carries a data-driven `arena_id`;
- Act 1 combat encounters are distributed across four arena families instead of sharing one presentation:
  - **crypt** — warm underground stone, arches and braziers;
  - **graveyard** — cold moonlit tint, tombstones, dead trees and low fog;
  - **ossuary** — bone arches, bone piles and warmer sepulchral light;
  - **warden** — a dedicated Bone Warden lair built on the ossuary family with chains, a sealed gate and the existing phase rune treatment;
- arena dressing is rendered below units inside the existing live `Arena` layer, so combat readability, placement bounds and unit logic are unchanged;
- the same authored base battle backdrop is intentionally reused for vertical-slice cohesion, while family-specific lighting/silhouettes/foreground structures make encounters read as different locations;
- current mapping: Bone Patrol/Crypt Guard -> crypt; Graveyard Ambush/Gallows Volley/Grave Bell -> graveyard; Bone Crush/Ossuary Gate/Death Wager -> ossuary; Bone Warden -> warden.
- the initial Godot 4.7.2 parser conflict with the built-in `CanvasItem.draw_ellipse()` name was fixed by renaming the local arena ellipse helper; multi-arena visuals remain pending local verification.
- follow-up screenshot review exposed visible softness from presenting the original 640×360 arena derivatives at the 1280×720 battle viewport;
- production now uses **true native 1280×720 WebP backdrops** rebuilt from the preserved 1672×941 authored source renders for **crypt**, **graveyard**, **ossuary** and **warden**;
- the HD assets are encoded at high WebP quality and were committed through a repository-safe staged base64 path, avoiding the earlier binary truncation failure;
- `authored_backdrop.gd` continues to bypass Godot's compile-time texture importer: it reads the WebP bytes with `FileAccess`, decodes them via `Image.load_webp_from_buffer()`, and caches the resulting `ImageTexture`;
- because the production sources are already 1280×720, the Lanczos resize path is now only a defensive fallback rather than the normal presentation path;
- linear texture filtering is retained only for fractional window scaling; at the 1280×720 prototype viewport the authored arena art is displayed at native resolution;
- combat geometry, unit positions, `arena_id` mappings and Bone Warden dynamic rune effects are unchanged.

## Player-facing language

All player-facing UI text, card text, reward text, wizard lines and unit display names are Russian.

Technical identifiers, file names, node names, class names and code remain English.

## Engine

- Godot 4.7.x
- GDScript
- Main scene: `res://scenes/main/main.tscn`
- First-run story scene: `res://scenes/intro/intro.tscn`
- Rendering method: GL Compatibility
- Prototype resolution: 1280×720
- `RunState` is registered as an autoload singleton.

## Current playable flow

### 1. Main screen

`scenes/main/main.tscn`  
`scripts/main/approved_main_backdrop.gd`

The production main menu is now a dedicated, user-approved authored pixel-art splash rather than a live recomposition of the wizard-table scene.

Visual content baked into the approved splash:

- the Wizard looming behind the cursed table;
- large MISDEAL title;
- **«Проклятая партия уже разложена.»**;
- five cards across the table;
- player hands in the foreground;
- candles, skulls, moonlit gothic architecture and an hourglass;
- painted **ВОЙТИ В ИГРУ** CTA.

Runtime art is reconstructed from:

- `assets/pixel/main/approved_splash_hd/part_00.txt`;
- `part_01.txt`;
- `part_02.txt`.

The source image is a native 1280×720 WebP encoded across those chunks and rendered with linear filtering. A transparent native Godot `StartButton` sits over the painted CTA so hover/focus/click remain interactive without duplicating the artwork. Pressing it resets the run and opens the story intro.

The previous `main_visual.gd` / reused table-art menu composition is no longer active.

### 2. Story intro

`scenes/intro/intro.tscn`

The game now opens with a five-frame authored pixel-art comic prologue before the first wizard-table deal.

Narrative premise:

- the player character is old and looking back on a long life of rescues, losses and consequences;
- the Wizard is returning because of an old pact rather than meeting the player for the first time;
- he offers the impossible: replay the key decisions of that life;
- changing one saved life can erase or rewrite another life that existed because of the original choice;
- the final frame reveals the cursed cards and leads into protagonist-class selection before the first deal.

Runtime intro art lives under `assets/pixel/intro/frame_01.webp` … `frame_05.webp`, authored at 1280×720 in the same dark-fantasy pixel language as the battle/table presentation.

Controls:

- left click, **Space** or **Enter** advances;
- the painted **ПРОПУСТИТЬ** area in the top-right is backed by a real Godot button;
- **Esc** also skips;
- the final frame advances to `scenes/class_select/class_select.tscn`;
- short black fades separate frames.

Starting another run from the run-end screen skips the prologue but still opens class selection, because protagonist class is a per-run decision.

### 3. Protagonist class selection

`scenes/class_select/class_select.tscn`

Each run now begins with one protagonist rather than a guaranteed trio.

- choose **РЫЦАРЬ**, **СЛЕДОПЫТ** or **МАГ**;
- the chosen role becomes `RunState.protagonist_role` and the only initial member of `party_roles`;
- the other two roles begin with fate **НЕ РАЗЫГРАНА**;
- the scene uses the same production combat atlas as battle/status UI;
- consecutive new runs skip the story comic but return here before the table.

### 4. Wizard table

`scenes/table/table.tscn`

Act 1 now uses a two-card offer flow:

- the player resolves 12 pre-boss cards;
- before each card, the wizard offers two cards from the current difficulty tier;
- choosing one card removes the rejected alternative from that run;
- cards do not repeat inside the run;
- after cards 1-4 the pool moves from early to mid tier;
- after cards 5-8 it moves from mid to late tier;
- each 4-card tier now guarantees one combat selection: at run start each tier randomly chooses one of its first three slots as the mandatory combat slot, non-combat offers are protected before it, and that slot offers two combat cards;
- later slots in mid/late can still surface the tier's remaining combat card, so a run can contain more than the guaranteed minimum;
- after card 12 the only remaining progression card is **КОСТЯНОЙ НАДЗИРАТЕЛЬ**.

A selected combat card remains active after defeat. Returning to the table shows that same card as **ПОВТОРИТЬ**, rather than generating a fresh offer.

The structural Act 1 pool contains 24 unique pre-boss card definitions: 8 early, 8 mid and 8 late. This is intentionally large enough for twelve two-card offers where the rejected alternative leaves the run.

Currently fully implemented card mechanics:

- **КОСТЯНОЙ ДОЗОР** — three melee Skeleton units;
- **ЗАСАДА НА КЛАДБИЩЕ** — two Skeleton units plus one Bone Archer;
- **ЗАЛП С ВИСЕЛИЦЫ** — one Skeleton plus two Bone Archers;
- **ШЕПЧУЩИЙ КОЛОДЕЦ** — risk blood for hero development, pay 25 gold for a relic/build fallback, or walk away;
- **ПЕПЕЛЬНЫЙ ПРИВАЛ** — freely prepare one specific hero by taking that role's next available upgrade, or leave;
- **ЛАВКА МОГИЛЬЩИКА** — buy the next available Knight/Ranger/Mage development for 35 gold;
- **КУЗНИЦА ПРОКЛЯТИЙ** — choose one of three hero-specific artifacts, or refuse;
- **МОГИЛЬНЫЙ ЗВОН** — two Skeletons protect a Grave Bellkeeper support enemy;
- **КОСТЯНАЯ ДАВКА** — five weak Bone Thralls pressure the party through numbers and reward splash damage;
- **СТРАЖ СКЛЕПА** — elite Crypt Guard with melee splash plus two Bone Thralls; victory uses a guaranteed-artifact reward flow;
- **ЧЁРНЫЙ АЛТАРЬ** — sacrifice party HP to unlock the next Knight/Ranger/Mage upgrade, or refuse;
- **ЗАКОВАННЫЙ ПЛЕННИК** — pay to train the least-developed hero, trade blood for a relic, loot the prisoner, or leave;
- **КОСТИ ДОЛЖНИКА** — a true 50/50 gold gamble alongside safer deterministic choices; failure still uses raw stat penalties as a curse;
- **ДЕСЯТИНА ВОЛШЕБНИКА** — pay gold, pay party HP, or refuse and take a temporary wizard debt;
- **КАРТА БЕЗ ЛИЦА** — hidden outcome now yields gold, a relic or hero development; bribing guarantees development and burning can clear wizard debt;
- **КРОВАВАЯ КНИГА** — buy development with gold, trade blood for a relic/build fallback, or erase the latest hero upgrade for 70 gold;
- **СЛОМАННАЯ КОРОНА** — source-locked party-wide artifact, 40-gold break option, or melt the crown into development for the least-developed hero;
- **ПОСЛЕДНИЙ ПРИВАЛ** — late pre-boss choice to develop Knight, Ranger or Mage directly;
- **ВРАТА ОССУАРИЯ** — heavy late combat combining Crypt Guard, Grave Bellkeeper, Bone Archer and Bone Thrall;
- **ГРЕМУЧИЙ МОСТ** — early traversal risk with a 50/50 sprint, a small guaranteed gold/HP trade, or a safe crossing;
- **КОШЕЛЬ МЕРТВЕЦА** — deterministic greed ladder: more gold costs progressively more party HP;
- **ТОРГОВЕЦ СВЕЧАМИ** — early build shop: buy the next Knight/Ranger/Mage development for 25 gold;
- **КОСТЯНАЯ ПОШЛИНА** — forced mid-run payment choice: gold, blood, or a harsher confrontation that costs HP but develops the least-developed hero;
- **СТАВКА НА СМЕРТЬ** — late five-enemy elite combat against Crypt Guard, two Bone Archers and two Bone Thralls, followed by +60 gold / relic / extra hero-upgrade reward choice.

All 24 pre-boss cards now have bespoke mechanics. `scenes/event/prototype_card.tscn` remains only as unused legacy prototype infrastructure and is no longer referenced by the active Act 1 card pool.

The table displays:

- current card progress out of 12, or **БОСС**;
- gold;
- current party size out of 3;
- current hero-development count;
- current relic count;
- **ДОЛГ ВОЛШЕБНИКУ** when active;
- an **ОТРЯД [TAB]** control that opens the squad-status modal over the current deal.

Selecting a card stores it as the active run card. Combat cards also select their `EncounterData`; event/prototype cards route to their configured scene.

The wizard table now uses a hybrid authored-art + live-UI composition based on the approved concept stored at:

- `assets/concepts/approved_table_direction.png`

The battle screen now follows its own approved pixel-art direction stored at:

- `assets/concepts/approved_battle_direction.jpg`

The battle remains live Godot UI/combat rather than a baked screenshot; the reference is used for composition, density, scale and palette.

Runtime table assets derived from that concept:

- `assets/pixel/table/table_wizard_layer.png` — wizard/room backdrop;
- `assets/pixel/table/misdeal_logo.png` — title logo;
- `assets/pixel/table/cards/bone_patrol.png`;
- `assets/pixel/table/cards/graveyard_ambush.png`;
- `assets/pixel/table/cards/gallows_volley.png`;
- `assets/pixel/table/cards/whispering_well.png`;
- `assets/pixel/table/cards/bone_warden.png` — dedicated final-boss card art.

The lower tabletop, ritual runner and sigil remain procedural so the layout can stay responsive to live UI. Earlier procedural side props and candles were removed after local visual review because they conflicted with the authored backdrop.

The table still uses real Godot `Button` controls. Two existing card slots are now populated dynamically from `RunCardData`, including title, type, description, wizard hover line and art path.

The top HUD remains dynamic and now emphasizes Act 1 progress, gold, **РАЗВИТИЕ** count and **РЕЛИКВИИ** count. If wizard debt is active, **ДОЛГ ВОЛШЕБНИКУ** is also shown.

### Squad status

`scenes/table/squad_status.tscn`  
`scripts/table/squad_status.gd`

The table now has a read-only **ДОСЬЕ ОТРЯДА** modal for inspecting the current run build.

The dossier also represents companion fate. Heroes outside the current party remain selectable as faded entries:

- **СУДЬБА НЕ РАЗЫГРАНА** — recruitment is still possible if a relevant card is actually played;
- **ПОТЕРЯН** — the player personally reached a recruitment scene and chose not to save that companion;
- joined companions immediately switch to normal stat/build presentation.

It opens on the currently chosen protagonist.

- Tab or **ОТРЯД [TAB]** opens/closes it without changing the current card offer;
- Esc closes it;
- 1 / 2 / 3 switches between Knight, Ranger and Mage;
- portraits are sliced from the same production 3×3 combat-unit atlas used in battle;
- each hero shows final HP, damage, attacks/second, range, move speed and damage/second;
- Ranger/minimum-range and Knight/Mage splash stats appear only when relevant;
- changed values are compared against the hero's base `UnitData` value;
- the right side lists the hero's acquired upgrades and every relic currently affecting that hero, including party-wide relics;
- the footer shows legacy party HP/damage effects, optional-upgrade progress and wizard debt;
- the hero subtitle becomes a lightweight dynamic build name such as **ЖЕЛЕЗНАЯ СТЕНА**, **СНАЙПЕР**, **ЗАЛПОВИК**, **ПИРОМАНТ** or **СТЕКЛЯННАЯ ПУШКА**.

`RunState.get_effective_hero_stats()` mirrors battle spawning: global party bonuses -> hero upgrades -> artifacts -> solo/duo compensation -> minimum HP/damage clamps. The status UI does not store a second copy of character stats.

The earlier painted assets under `assets/art/` remain in the repository as historical/reference material.

### 4. Whispering Well event

`scenes/event/whispering_well.tscn`

The dedicated event now has two modes.

If Mage is still an unresolved companion fate:

- pay blood (-20 party HP) and recruit Mage;
- pay 25 gold and recruit Mage safely;
- walk away and mark Mage **ПОТЕРЯН** for this run.

If Mage is already the protagonist/joined/lost, the card falls back to its build/relic event behavior.

The event remains one-time because its card leaves the run after being offered. Resolving it completes the current Act 1 card and advances card progress.

### 5. Combat

`scenes/battle/battle.tscn`

Player party is now variable:

- the run always starts with exactly one chosen protagonist;
- recruited companions are added permanently for the rest of that run;
- combat can therefore be solo, duo or trio.

Enemy composition and spawn positions still come from the selected `EncounterData` Resource.

Before combat, the player can drag every currently recruited hero within the deployment zone.

Implemented combat behavior:

- three pre-battle tactical orders: **НАТИСК**, **ОХОТА**, **СТРОЙ**;
- **НАТИСК** preserves nearest-enemy focus and gives heroes +15% movement speed for faster engagement;
- **ОХОТА** continuously prioritizes support enemies first, then ranged enemies, then the nearest remaining target;
- **СТРОЙ** continuously focuses the enemy closest to the currently most vulnerable living ally, causing the party to collapse onto immediate threats instead of scattering;
- orders can be changed freely during preparation and lock when **БОЙ** is pressed;
- automatic movement and attacks;
- melee and ranged attack ranges;
- Bone Archer keeps distance and retreats when enemies get too close;
- all combat movement is clamped to the visible arena;
- Mage attacks deal 50% splash damage to nearby secondary enemies;
- separation steering prevents units from stacking into one point;
- HP bars;
- hit flash, impact pulse and floating damage numbers;
- death shrink/fade feedback;
- victory and defeat detection;
- boss units can use data-driven visual scale and a one-time enrage threshold;
- Bone Warden uses its own dedicated high-detail `bone_warden` atlas sprite instead of an enlarged normal Skeleton;
- Bone Warden has 700 HP, 24 base damage, a 60%-damage melee cleave in a 92 px radius, and a larger boss HP/name treatment;
- at 50% HP Bone Warden still enrages, increasing damage, attack speed and movement speed, but now also triggers **Phase II** and summons one Bone Archer plus one Bone Thrall;
- the phase transition changes the boss label to **БОСС • ЯРОСТЬ**, shows a centered **ФАЗА II — ПРИЗЫВ** cue and switches the arena into its stronger phase-two ritual state;
- Grave Bellkeeper is the first support enemy: every 4.5 seconds it heals damaged allied undead within 210 px for 18 HP and shows a visible **ЗВОН!** cue;
- Bone Thrall is a smaller, faster, low-HP swarm enemy;
- Crypt Guard is a slower elite melee enemy with a larger silhouette, visible name and 35% splash damage around its primary target.

Hero stats receive persistent run bonuses from `RunState`. After upgrades and relics, incomplete parties receive visible compensation: solo x2.2 HP, x1.9 damage, x0.80 attack interval and x1.10 movement speed; duo +20% HP/+15% damage; trio none. Enemy HP/damage pressure is also party-size-aware (solo 82%/80%, duo 92%/90%, trio 100%/100%) while encounter composition and AI remain authored. Final spawned hero max HP is clamped to at least 20 and damage to at least 1.

After victory, **ЗАБРАТЬ НАГРАДУ** opens the reward scene.

After defeat, **ВЕРНУТЬСЯ К СТОЛУ** returns to the same run without increasing the victory count.

**ПЕРЕИГРАТЬ** remains available as a prototype/testing convenience.

### 6. Reward

`scenes/reward/reward.tscn`

The first combat victory in each early/mid/late tier opens **РАЗВИТИЕ ОТРЯДА** when at least one hero upgrade remains. The player chooses one offered Knight/Ranger/Mage upgrade; this guaranteed tier choice does **not** consume the optional-upgrade cap.

After that:

- ordinary combat loot is **+25 gold**;
- if **ДОЛГ ВОЛШЕБНИКУ** is active, that normal gold loot becomes **+50 gold** and clears the debt;
- Crypt Guard keeps its unowned-artifact reward;
- Death Wager offers **+60 gold / a shown available relic / one extra hero-upgrade choice**;
- if the run has already used all 3 optional hero-upgrade slots, Death Wager's extra-upgrade option becomes **+45 gold** instead of opening an empty selection.

Choosing the final reward completes the active combat card.

Normal combat victories return to the table and advance Act 1 card progress.

After defeating Bone Warden and resolving its reward flow, `boss_defeated` becomes true and the player goes to the run-end screen.

### 7. Run end

`scenes/run_end/run_end.tscn`

After 12 resolved pre-boss cards plus the Bone Warden, the run ends and displays:

- pre-boss cards completed;
- combat victories;
- gold;
- accumulated HP bonus;
- accumulated damage bonus.

**НОВЫЙ ЗАБЕГ** resets `RunState` and returns to the wizard's table.

## Current architecture

### Unit data

Reusable combat stats are stored in `UnitData` Resources:

- `scripts/data/unit_data.gd`
- `resources/units/knight.tres`
- `resources/units/ranger.tres`
- `resources/units/mage.tres`
- `resources/units/skeleton.tres`
- `resources/units/bone_archer.tres`
- `resources/units/bone_warden.tres`
- `resources/units/grave_bellkeeper.tres`
- `resources/units/bone_thrall.tres`
- `resources/units/crypt_guard.tres`

Runtime combat state remains on `BattleUnit`.

`UnitData.visual_role` now selects dedicated 96×96 regions from the unified combat atlas:

- `assets/pixel/units/combat_units_v3/part_00.txt` … `part_09.txt` — final v3 PNG atlas data, decoded at runtime by `BattleUnit`;
- `assets/pixel/units/combat_units_v3/part_00.txt` … `part_09.txt` — the sole production atlas source; `BattleUnit` validates the reconstructed 288×288 PNG before use

Atlas layout:

- row 1: Knight, Ranger, Mage;
- row 2: Skeleton, Bone Archer, Grave Bellkeeper;
- row 3: Bone Thrall, Crypt Guard, Bone Warden.

All nine roles use authored transparent pixel art. Grave Bellkeeper, Bone Thrall and Crypt Guard no longer reuse tinted Skeleton art. The older per-unit PNG files remain in the repository as historical/reference assets but are no longer loaded by combat.

Combat presentation now uses the approved second gothic mockup as an authored static backdrop while keeping all gameplay layers live:

- all current combat roles use the new unified high-detail transparent pixel atlas;
- combat sprites remain substantially larger so silhouettes read like characters rather than small board icons;
- thin blue/red team rings, HP bars, names, drag placement, combat movement and targeting remain live Godot elements;
- the cathedral/crypt architecture, throne/altar, pillars, banners, chains, braziers, skull piles, ritual floor, outer frame and command-panel art are baked into the authored backdrop;
- the authored backdrop is reconstructed at runtime by `scripts/battle/authored_backdrop.gd` from five validated base64 WebP chunks under `assets/pixel/battle/authored_backdrop/`; the decoded image is 1280×720 and uses nearest-neighbor presentation;
- `scripts/battle/battle_visual.gd` no longer draws the general arena and now only adds lightweight dynamic boss-phase overlays;
- the obsolete procedural `scripts/battle/battle_hud_visual.gd` renderer was removed;
- encounter title/status, card progress, faction labels, buttons and result text remain native Godot controls layered over the art;
- **БОЙ** and **ПЕРЕИГРАТЬ** now sit directly over the painted command frames from the backdrop instead of drawing a second competing UI frame.

The older painted unit assets under `assets/art/units/` remain in the repository for reference but are no longer used by combat.

### Encounter data

`scripts/data/encounter_data.gd`

Encounter Resources currently define:

- encounter id;
- Russian title and card text;
- wizard line;
- enemy UnitData paths;
- enemy display names;
- enemy spawn positions;
- optional phase/reinforcement unit paths, names and spawn positions.

Current encounter files:

- `resources/encounters/bone_patrol.tres`
- `resources/encounters/graveyard_ambush.tres`
- `resources/encounters/gallows_volley.tres`
- `resources/encounters/bone_warden.tres` — final-deal boss encounter;
- `resources/encounters/grave_bell.tres`;
- `resources/encounters/bone_crush.tres`;
- `resources/encounters/crypt_guard.tres` — elite encounter with guaranteed artifact reward;
- `resources/encounters/ossuary_gate.tres` — late mixed-archetype combat before the boss;
- `resources/encounters/death_wager.tres` — late five-enemy elite wager encounter.

### Run-card data

`scripts/data/run_card_data.gd`

Act cards are data-driven Resources containing:

- card id;
- Russian title/description/wizard line;
- display type;
- early/mid/late tier;
- resolution type;
- target encounter/event scene;
- art path;
- temporary prototype-result text.

Act 1 card resources live under `resources/cards/`.

### Artifacts

`scripts/data/artifact_data.gd`

The first artifact layer is data-driven and persists for the current run through `RunState.artifact_ids`.

Current artifacts:

- **ЩИТ МЕРТВЕЦА** — Knight +40 HP, -15% move speed;
- **СЛЕПОЙ КОЛЧАН** — Ranger attacks 22% faster but gains +55 minimum range;
- **РАСКОЛОТЫЙ ФОКУС** — Mage deals 15% less primary damage but gains +55 splash radius and +0.25 splash multiplier;
- **СЛОМАННАЯ КОРОНА** — special party-wide artifact: all heroes +22% damage and -10 max HP.

`ArtifactData.general_pool` separates normal shop/elite/random artifacts from source-locked special artifacts. **СЛОМАННАЯ КОРОНА** has `general_pool = false`, so it can only be acquired from its named card. Party-wide artifacts use `target_role = "*"`.

Artifacts are applied to hero runtime stats when combat units spawn. The run-end summary now lists acquired artifacts.

### Hero upgrades

`scripts/data/hero_upgrade_data.gd`

Act 1 now has nine unique persistent hero upgrades, three for each party member:

- Knight: **ЖЕЛЕЗНАЯ КЛЯТВА**, **ПАЛАЧ**, **РАЗМАШИСТЫЙ УДАР**;
- Ranger: **ДАЛЬНИЙ ВЫСТРЕЛ**, **ГРАД СТРЕЛ**, **ЗВЕРИНАЯ ТРОПА**;
- Mage: **ПОЖАР**, **СТЕКЛЯННОЕ СЕРДЦЕ**, **ПЕРЕГРУЗКА**.

Each early/mid/late tier guarantees one major hero-upgrade choice after the first combat victory in that tier. The reward screen offers one available upgrade for Knight, Ranger and Mage, so the player can spread growth across the party or specialize the same hero in all three tiers.

Optional event/Death Wager development is now capped at **3 extra upgrades per run**. These extra slots are tracked separately from the three guaranteed tier upgrades, so a normal strong run should reach roughly 4–6 total upgrades instead of exhausting all nine. If Blood Ledger erases an upgrade that came from an extra slot, that extra slot becomes available again.

Hero upgrades persist for the current run in `RunState.hero_upgrade_ids` and are applied when player units spawn, before artifacts. They can modify HP, damage, attack cadence, range, minimum range, splash and move speed.

Special combat rewards remain intact after the tier upgrade:

- Crypt Guard still grants an artifact reward;
- Death Wager now offers **+60 gold / a shown unowned artifact / one extra hero-upgrade choice**;
- normal combat loot is now gold-only instead of another permanent party-wide HP/damage choice;
- wizard debt still doubles the next normal gold loot and is not consumed by major upgrades or special rewards.

The wizard-table HUD now emphasizes **РАЗВИТИЕ** and **РЕЛИКВИИ** instead of treating global HP/damage counters as the primary build identity.

A read-only **ДОСЬЕ ОТРЯДА** modal is now implemented on the wizard table and pending local verification. It opens from the new **ОТРЯД [TAB]** button or the Tab key without regenerating the current card offer.

The shared `scenes/event/act_choice.tscn` scene handles the implemented choice-driven events. Its progression-facing cards now query the live hero build and show the actual next upgrade name on the choice button when relevant. The scene still intentionally avoids a generalized event-effect framework.

### Hard-roguelike party composition and companion fates

The two non-protagonist heroes are no longer guaranteed party members.

Recruitment routes:

- **Knight** — primary: **ЗАКОВАННЫЙ ПЛЕННИК**; fallback: **ПОСЛЕДНИЙ ПРИВАЛ**;
- **Ranger** — primary: **ГРЕМУЧИЙ МОСТ**; fallback: **ПЕПЕЛЬНЫЙ ПРИВАЛ**;
- **Mage** — primary: **ШЕПЧУЩИЙ КОЛОДЕЦ**; fallback: **ЧЁРНЫЙ АЛТАРЬ**.

Important fate rule:

- if a recruitment card is merely not offered or is rejected at the two-card table choice, that companion remains **НЕ РАЗЫГРАНА** and can still appear through the fallback route;
- if the player actually enters a recruitment scene and chooses a branch that abandons the companion, that role becomes **ПОТЕРЯН** and cannot be recruited later in the run.

Upgrade and general-pool artifact offers only target heroes currently in the party. A solo major reward can show all three remaining upgrade paths for that one hero; duo/trio offers are built only from recruited roles.

Solo compensation is now x2.2 HP, x1.9 damage, x0.80 attack interval (+25% attacks/second) and x1.10 move speed. Duo compensation remains +20% HP/+15% damage. Enemy pressure now also scales transparently by party size (solo 82% HP/80% damage, duo 92% HP/90% damage), while authored compositions stay fixed.

### Run state

`scripts/core/run_state.gd`

The current prototype run state stores:

- gold;
- combat victories in `deals_survived` for backward compatibility;
- resolved pre-boss card count;
- remaining, offered, rejected and resolved card ids;
- active selected card id;
- global party HP bonus;
- global party damage bonus;
- last battle result;
- selected encounter path;
- boss completion state;
- persistent artifact ids;
- per-run protagonist role;
- current `party_roles`;
- companion fate state + fate notes for all three hero roles;
- persistent hero-upgrade ids;
- derived effective hero-stat inspection for the squad-status UI;
- claimed major-upgrade tier indices;
- stable pending major/bonus upgrade offers;
- temporary `wizard_debt_active` state;
- randomized per-tier mandatory-combat slot indices in `forced_combat_slots`.

Act 1 ends after 12 resolved pre-boss cards plus Bone Warden.

## Not implemented yet

- follow-up Act 1 balance pass after local full-run feedback on the capped progression economy and retuned boss;
- broader shop inventory/economy beyond the current Candle Seller and Gravedigger Shop implementations;
- more artifacts beyond the first three;
- attack projectiles/animations;
- broader ability/status-effect system;
- richer evil wizard presentation;
- deck building / card unlocks;
- meta progression;
- save/load.

## Immediate next milestone

- approved main-menu splash must decode cleanly, fill the 1280×720 viewport and show no duplicated live title/tagline layers;
- painted **ВОЙТИ В ИГРУ** area must remain clickable/focusable through the transparent Godot hotspot and route to the comic intro;


Locally verify the full card-art integration first:

- every table card in the 24-card Act 1 pool plus **Bone Warden** must show its own matching approved illustration;
- **ГРЕМУЧИЙ МОСТ**, **КОШЕЛЬ МЕРТВЕЦА**, **КРОВАВАЯ КНИГА**, **СТРАЖ СКЛЕПА**, **КОСТЯНАЯ ДАВКА** and the other formerly repeated cards must no longer reuse unrelated art;
- all nine **РАЗВИТИЕ ОТРЯДА** paths must have distinct illustrations, especially Ranger paths that previously fell back to repeated role art;
- ordinary loot, Death Wager and elite rewards must show the approved Blood Coin / Gold Windfall / Relic Wager / Bonus Upgrade / Empty Cache / Elite Relic art without text overlap;
- card art should remain crisp under nearest filtering and no procedural icon placeholders should appear.

Locally verify the new hard-roguelike party flow end to end:

- main menu -> story intro -> class selection -> table;
- after choosing a class, battle must spawn only that protagonist;
- solo battle/status must show x2.2 HP, x1.9 damage, x1.25 attacks/second and x1.10 movement compensation plus the visible enemy-pressure reduction;
- recruiting one companion must immediately switch future battles to duo and compensation to +20% HP/+15% damage;
- recruiting both must produce a normal trio with no compensation;
- major/bonus upgrade offers and general-pool relics must only target heroes currently in the party;
- **Knight** recruitment: Chained Prisoner or, if still unresolved, Last Camp;
- **Ranger** recruitment: Rattling Bridge or, if still unresolved, Ash Rest;
- **Mage** recruitment: Whispering Well or, if still unresolved, Black Altar;
- rejecting a recruitment card at the table must leave fate unresolved;
- entering a recruitment event and deliberately abandoning the companion must mark them **ПОТЕРЯН** and block the fallback recruitment later;
- **ДОСЬЕ ОТРЯДА** must show unresolved/lost companions as faded fate entries and open on the protagonist;
- class-selection cards must keep portraits and all text in separate non-overlapping regions at 1280×720;
- long wizard-table card descriptions must remain inside their clipped description area and never touch **ВЫБРАТЬ**;
- victory/defeat result panels and bottom actions must remain above all unit sprites, HP bars, names and floating combat text;
- run-end summary must list final party and companion fates;
- Bone Warden must remain a fixed benchmark and be tested solo, duo and trio before changing boss stats again;
- verify all three tactical orders in normal, elite and Bone Warden combat: **НАТИСК** should visibly engage faster, **ОХОТА** should retarget to Bellkeeper/Archers including spawned reinforcements, and **СТРОЙ** should react to the ally currently under the most pressure.

Do not add more companion classes until this three-role recruitment loop is locally validated.

## Local workflow

The browser-side assistant edits the GitHub repository.

The user keeps a local clone and normally updates with:

`git pull`

`UPDATE_MISDEAL.bat` is also present as a one-click pull helper.

- Hero development, Curse Forge, Chained Prisoner and Wizard Wager were re-aligned to their approved visual mockups with taller illustrated cards and stronger ceremonial framing.

- Curse Forge and Chained Prisoner now use the same tall illustrated choice-card proportions as their approved mockups, with approved atlas art occupying the upper half of each choice; the Wizard Wager modal is enlarged and gains a central ritual sigil/divider treatment.

- the approved Forge and Chained Prisoner references now also contribute dedicated character/environment decor (blacksmith / chained prisoner) through a runtime-decoded WebP atlas stored as raw .bin, so these two event scenes no longer read as the generic Wizard table with different text;

- 2026-10-07 screenshot correction: Curse Forge, Chained Prisoner and the Wizard wager were re-laid out against the approved attached references rather than merely sharing generic event chrome; this is presentation-only and leaves their mechanics unchanged.

## UI-kit screenshot correction — 2026-10-08

Fresh 1280×720 local screenshots confirmed the shared chrome direction is working well on the Act Choice and Reward/development screens, but exposed two first-pass regressions. The main-menu and intro controls are authored-image click hotspots and must stay transparent; applying generic action-button chrome produced empty dark rectangles over the art. Those two hotspots now keep their original transparent treatment.

Resolved shared Act Choice screens now hide the obsolete leave button, reserve a dedicated result strip, and present a single centered `К СТОЛУ` action. This specifically fixes Candle Seller result text overlapping the bottom actions after a purchase.

## Act 1 party-size balance pass — 2026-10-08

A first full-run-oriented party-size pressure pass is now in `main` and pending local solo/duo/trio verification.

The previous approach only amplified incomplete-party heroes while every enemy pack retained full trio-authored durability and damage. That left solo Ranger/Mage openings too close to a raw action-economy loss, especially when the first forced combat arrived before a useful event.

Current baseline:
- **solo hero:** HP ×2.2, damage ×1.9, attack interval ×0.80 (+25% attacks/sec), movement ×1.10;
- **solo enemies:** HP ×0.82, damage ×0.80;
- **duo heroes:** HP ×1.20, damage ×1.15;
- **duo enemies:** HP ×0.92, damage ×0.90;
- **trio:** authored 100% enemy baseline, no party compensation.

Enemy composition, AI, ranges, attack cadence and boss mechanics are unchanged. Enemy support healing scales with the same enemy-HP factor so Grave Bell-style healing does not become disproportionately strong in incomplete-party runs. Wizard Debt / Wizard Mark danger bonuses multiply on top of the party-size damage baseline rather than bypassing it.

Act 1 opening pacing also changed conservatively: the tier-0 forced-combat slot is now 1 or 2 instead of 0–2, guaranteeing at least one non-combat decision before the first mandatory fight. Mid/late tiers retain the previous 0–2 forced-combat timing.

This supersedes the earlier static-balance assumption that enemies/bosses never scale by party size; the authored encounter compositions and full-trio numbers remain the reference baseline.

## Target-intent visibility toggle — 2026-10-08

Local review confirmed the new pre-battle target lines are useful but too visually heavy when always enabled. Battle preparation now has a dedicated centered `ЦЕЛИ: ВКЛ/ВЫКЛ` toggle above the `БОЙ` button. Target intents are **off by default**, can be enabled only when the player wants to inspect focus, and still disappear automatically when combat begins.

The preference is stored on the persistent `RunState` autoload but deliberately not reset by `reset_run()`, so the player's choice persists between battles and new runs for the lifetime of the current app session. The underlying preview logic and combat AI are unchanged.

## SceneTransition autoload resilience hotfix — 2026-10-08

Local Godot 4.7.2 compilation exposed a project-file edge case: a user-local `project.godot` conflict could leave the new `SceneTransition` autoload entry absent even though the transition script and all navigation call sites had already been pulled. Direct references such as `SceneTransition.change_to(...)` then fail at parse time before the project can run.

Scene navigation now goes through `scripts/core/scene_router.gd`. The router uses the registered `/root/SceneTransition` singleton when available, but if the editor/local project file has not registered it yet, it creates the same persistent transition node dynamically under the root and routes navigation through that instance. Active main/intro/class-select/table/event/battle/reward/run-end call sites no longer require the autoload identifier to exist at parse time.

This keeps the seamless-transition system functional while making pulls robust against local `project.godot` divergence. The canonical repository project file still registers `SceneTransition` normally.

## Empty-frame transition elimination + target-intent preview — 2026-10-08

Local testing still exposed an intermittent full-gray frame despite the first persistent veil. The transition system no longer delegates the actual swap to `SceneTree.change_scene_to_file()`. `SceneTransition` now starts threaded loading while the outgoing scene remains alive, instantiates the incoming PackedScene before blackout, renders at least one fully opaque transition frame, manually adds the new scene while the old scene still exists, switches `current_scene`, frees the old scene, waits for the new runtime-art/layout frames to render, then reveals the result. The renderer clear color is also forced to the same near-black tone at runtime.

This removes the actual empty-scene interval instead of only masking it. All existing call sites continue to use the same `SceneTransition.change_to()` / `reload_current()` API.

Battle preparation also gains a lightweight **target-intent preview**. While placement is active, blue intent arrows show each hero's current first target under the selected tactical order and red intent arrows show each enemy's current first target. The preview updates live while heroes are dragged or the order changes and disappears when combat begins. It reads the existing targeting AI rather than adding a second prediction system, so placement now exposes real tactical information without changing combat rules or stats.

## Main splash replacement + seamless scene transitions — 2026-10-08

The locally rejected low-quality first splash has been replaced by the user-approved restrained dark-gothic redraw with the Wizard brought back into the current Misdeal visual language. Runtime art is now a native **1280×720 WebP** at `assets/pixel/main/approved_splash_hd/main_splash.webp`, loaded through `FileAccess + Image.load_webp_from_buffer()` in `scripts/main/approved_main_backdrop.gd`. The old three-part compressed splash representation is no longer the runtime source.

The brief gray viewport flash seen when moving into battle or returning to the table after events is also addressed globally. `SceneTransition` is now a persistent autoload CanvasLayer with a dark veil: it fades over the outgoing scene, survives the actual scene replacement, keeps the viewport covered while the incoming scene finishes runtime-art setup, then fades away. All active scene changes and battle reloads route through this helper. The project default clear color is also set to the same near-black tone as a final safety net.

This pass changes presentation/loading only; card choice, encounter selection and run state are unchanged. Pending local verification after a fresh pull/restart.

## Shared gothic UI-kit pass — 2026-10-08

A first shared runtime **Misdeal UI kit** is now in `main` and pending local screenshot verification. `scripts/ui/misdeal_ui_kit.gd` unifies live Godot panels and buttons without baking mutable text or values into images: square pixel-gothic borders, bronze/gold/ember/steel semantic accents, compact corner marks, stronger ceremonial frames and consistent normal/hover/pressed/disabled button states.

The kit is wired into the main menu, intro skip action, Class Select, Wizard table, Wizard wager, Squad Dossier, shared Act 1 event choices, Whispering Well, Reward, Battle HUD / Last Deal and Run End. Existing authored choice art, artifact art, event backdrops and live mechanics are preserved; this pass changes presentation chrome only.

This intentionally answers the earlier visual mismatch where authored environments and approved choice illustrations sat under mostly independent StyleBoxFlat treatments. Further changes should come from fresh 1280×720 screenshots rather than inventing another parallel UI system.

## Production art-direction consistency pass

A first production art-direction consistency pass is now in `main` and pending local screenshot review. `docs/ART_DIRECTION.md` defines the authored low-resolution target. A shared CanvasItem shader now reduces painterly smoothness and pushes large source art toward a tighter Ink / Stone / Bone palette while preserving restrained Rust / Teal / Gold accents. The first reference surfaces are the Wizard table, authored battle backdrops and Whispering Well. Battle backdrops also use nearest filtering/resampling, and Whispering Well's procedural background has fewer candles and quieter glow. This is a consistency layer; visibly malformed source geometry still requires actual redraw.

## Approved Bone Crush arena redraw

The first true source-art replacement from the production art-direction pass is now in `main` and pending local screenshot verification. **КОСТЯНАЯ ДАВКА** no longer reuses the dense Ossuary backdrop. It has a dedicated lower-detail gothic hall derived from the approved concept: fewer lights, simpler readable architecture and larger quiet floor masses. The source is stored as split base64 WebP parts, matching the existing combat-unit atlas pattern, and is intentionally exempt from the corrective environment grade because it was authored directly toward the new target. Placement zones also moved away from blue debug rectangles toward faint warm floor/chalk markings.

## Visual checkpoint — 2026-10-08

The user locally reviewed the first production art-grade pass on the Wizard table and several battle arenas and confirmed the game still works. The screenshots made the remaining visual problem clearer: grading alone cannot remove the strongest generated-art tells.

Observed problems from the local screenshots:

- **Bone Crush / ossuary-style arenas are still the strongest offender**: too many candles, bone ornaments and cathedral details competing at the same visual frequency. They read as a fantasy wallpaper rather than an authored game arena.
- **Gallows Volley is a better direction reference** because it has large readable masses (sky/moon, architecture, floor) and more negative space.
- The Wizard table is more coherent after grading, but some **card illustrations still read as tiny generic fantasy landscapes** instead of one clear object/subject.
- The current environment grade can crush dark card/wager images too far toward black; future tuning should preserve more midtone information.
- The translucent blue deployment rectangles read as **debug UI**, not part of the world.
- UI hierarchy is functional, but the clean modern panels and the very ornate source art still feel like two different visual languages.

The user approved moving to a real redraw/replacement pass rather than trying to solve this with stronger shaders.

The first redraw target is **КОСТЯНАЯ ДАВКА**. The approved direction shown in-chat uses:
- simpler, physically readable crypt architecture;
- roughly one third of the current candle count;
- large dark wall/floor masses and deliberate negative space;
- two red hanging banners and a single central throne/statue focal point;
- a broad readable combat floor with one central ritual circle;
- deployment lanes represented as worn/etched floor markings rather than blue panels;
- no baked heroes, enemies, health bars, labels or gameplay text in the background.

Important: the newly drawn Bone Crush direction is **concept/reference only and is not yet wired into runtime**. The next implementation should add a dedicated Bone Crush arena id/asset rather than replacing the shared Ossuary backdrop used by other encounters.

After Bone Crush is proven locally, the same redraw language should be propagated selectively to the worst remaining arenas and then to object-first card art.


## Visual redraw pass — first object-first card batch

The broader production-art replacement pass has moved from arena-only work into table-card art. The first object-first card redraw batch is now wired into runtime for **ГРЕМУЧИЙ МОСТ**, **КОШЕЛЬ МЕРТВЕЦА** and **ШЕПЧУЩИЙ КОЛОДЕЦ**. These three cards bypass their old atlas cells and decode dedicated 224×137 WebP art from repository-safe base64 text assets. The shared card grade is deliberately lighter so authored midtones survive instead of collapsing toward black.

This is the first runtime batch of the user-approved full visual redraw direction. Existing card mechanics, titles, descriptions, prices and event logic remain live Godot UI and are unchanged.


## Visual redraw rollout — 2026-10-08

The first object-first table-card batch is live in main. **ГРЕМУЧИЙ МОСТ**, **КОШЕЛЬ МЕРТВЕЦА** and **ШЕПЧУЩИЙ КОЛОДЕЦ** now use dedicated 224×137 authored WebP overrides instead of their old atlas cells. The card-grade strength was reduced from 0.58 to 0.30 so the new dark pixel art keeps readable midtones.

This is the start of the user-approved broader visual redraw. Mechanics, prices, descriptions and choice state remain live Godot controls.


## Visual redraw hotfix — 2026-10-08

A runtime integration mistake in the first redraw batch was corrected. The dedicated assets for **ГРЕМУЧИЙ МОСТ**, **КОШЕЛЬ МЕРТВЕЦА** and **ШЕПЧУЩИЙ КОЛОДЕЦ** existed in the repository but CardArtCatalog still returned the old atlas cells. CardArtCatalog now checks dedicated overrides first and decodes the repository text assets into runtime WebP textures.

The Bone Crush atmosphere script also failed to parse in Godot 4.7 because loop values from an untyped array made x/y inference ambiguous. The band array and marker coordinates are now explicitly typed.


## Visual redraw quality correction — 2026-10-08

The broad low-resolution v3 redraw integration was locally rejected after screenshot review and has been removed from runtime. Its 112×69 table-card cells and 320×180 battle-arena cells were too small for their actual display sizes and produced visibly blocky/muddy results when enlarged.

The corrected v4 card pass keeps the generated redraws at the existing near-display runtime size of 224×137 per table-card cell and maps each source by semantic subject rather than generation order. Nineteen active Act 1 cards now use this correctly mapped v4 atlas: Bone Patrol, Graveyard Ambush, Gallows Volley, Rattling Bridge, Lost Purse, Whispering Well, Ossuary Gate, Grave Bell, Bone Warden, Faceless Card, Black Altar, Blood Ledger, Gravedigger Shop, Last Camp, Debtor Bones, Crypt Guard, Wizard Tithe, Curse Forge and Chained Prisoner.

The six cards without a trustworthy matching redraw source — Ash Rest, Bone Crush, Broken Crown, Candle Seller, Bone Tax and Death Wager — deliberately fall back to the already-approved 224×137 full card atlas. This means every one of the 25 active cards still has unique art; no card is allowed to borrow an unrelated generated image just to claim redraw coverage.

Battle arenas no longer use the rejected 320×180 atlas. Crypt now uses a dedicated native 1280×720 v4 redraw, and Gallows Volley has its own native 1280×720 moon/gallows arena instead of sharing Graveyard. Graveyard, Ossuary and Warden keep their validated authored high-resolution sources; Bone Crush keeps its dedicated benchmark backdrop.


## Act 1 card redraw coverage complete — 2026-10-08

The user locally confirmed the corrected v4 quality pass looks acceptable. The last six cards have now been removed from the intentional legacy-art fallback path.

Five cards use a supplementary v5 atlas at the same near-display 224×137 source size as the accepted v4 pass: **ПЕПЕЛЬНЫЙ ПРИВАЛ**, **КОСТЯНАЯ ДАВКА**, **ТОРГОВЕЦ СВЕЧАМИ**, **КОСТЯНАЯ ПОШЛИНА** and **СТАВКА НА СМЕРТЬ**.

**СЛОМАННАЯ КОРОНА** deliberately uses the already-approved object-centric Broken Crown artifact illustration. This makes the source card and the source-locked relic visually identical instead of inventing an unrelated scene.

All 25 active Act 1 table cards now resolve to current redraw/object-specific art before the legacy approved run atlas fallback. The v5 sheet is split into repository-safe base64 WebP text parts and decoded at runtime; gameplay text, prices and state remain live Godot UI.


## Battle arena v6 correction — 2026-10-08

The latest arena redraws from the current review are now the production sources for the scenes that were still visually wrong:

- graveyard: latest moonlit bell-mausoleum arena;
- ossuary: latest bone-gate crypt arena;
- warden: latest red throne / ritual-circle arena;
- bone_crush: latest broad-floor dark crypt arena;
- Bone Warden table card: latest dedicated Warden character redraw.

All four new battle sources are native 1280×720 WebP assets. Authored arena art is no longer passed through the legacy environment-grade material; that extra grade was the main cause of the crushed-black Grave Bell and Ossuary screenshots.

Bone Crush also uses floor-safe deployment/combat bounds and adjusted spawn lanes so units start and move on the visible floor plane instead of the architectural upper area.

Crypt and Gallows keep the accepted native-HD v4 sources. Gameplay rules are unchanged; this correction is visual/layout only.


## Table/wager midtone correction — 2026-10-08

Local screenshots showed that the remaining crushed-black presentation was on the Wizard table rather than the corrected battle arenas.

The table no longer applies the legacy environment grade to the authored Wizard backdrop, and live card/wager art is no longer post-darkened by the shared card grade. The Wizard wager scrim is reduced from 0.82 to 0.52 alpha and the three passive table shade layers are halved, preserving focus without hiding the table and cards.

A previously prepared Wizard/table illustration is now actually used in runtime as assets/pixel/table/visual_pass_v6/table_wizard.webp. It is a clean 1280×398 crop from the approved table direction with no baked gameplay text or buttons, so all HUD/card state remains live Godot UI.

For any older event/reward surface that still uses the shared grade materials, environment grade strength is reduced from 0.78 to 0.30 and card grade strength from 0.30 to 0.14. This is a safety correction for dark-mid readability, not a palette redesign.


## Reward/event midtone follow-up — 2026-10-08

The brightness correction was propagated one step beyond the Wizard table. The reward screen no longer tints its table backdrop brown/dark and its backdrop shade is reduced from 0.54 to 0.24 alpha. Whispering Well choice illustrations now render authored art directly instead of receiving another card-grade pass. This keeps the already-prepared reward/event art readable while all labels, prices and choices remain live UI.


## V7 screen-art rollout — 2026-10-08

The next authored-art package is now live across the remaining high-visibility legacy screens.

- **Class Select** now uses dedicated 640×480 authored portraits for Knight, Ranger and Mage instead of enlarging 96×96 combat sprites. The existing live class stats/descriptions remain native Godot UI.
- **Reward** now uses a dedicated 1280×720 treasure-altar backdrop instead of the old generic `assets/art/table_background.webp`.
- **Whispering Well** now uses a dedicated 1280×720 moonlit-well environment and no longer shows the procedural brick/well renderer behind the choice UI.
- **Curse Forge**, **Chained Prisoner** and **Black Altar** now use dedicated 1280×720 environment art through the shared `act_choice` scene. Their buttons, costs, state and consequences remain live.
- **Run End** now uses a dedicated 1280×720 Wizard-at-the-table ending illustration and disables the old procedural Wizard silhouette/table drawing.

The shared cursed-choice overlay was also softened so authored backgrounds keep readable midtones instead of being hidden under another heavy table shade.

All v7 art was exported as production WebP at near-display or full-screen resolution. No generated screen with baked gameplay labels/buttons was used as runtime UI.


## V7 WebP loader hotfix — 2026-10-08

Godot 4.7.2 local validation exposed a parser failure when the newly committed v7 WebP files were referenced directly through `preload()` or as `Texture2D` scene resources before the editor had a usable imported resource.

The v7 rollout now follows the already-proven battle-backdrop pattern: `scripts/ui/runtime_webp_texture.gd` reads the source file with `FileAccess`, decodes it with `Image.load_webp_from_buffer()`, caches the resulting `ImageTexture`, and assigns it to the live `TextureRect`.

Direct v7 WebP resource references were removed from Class Select, shared Act Choice, Reward, Whispering Well and Run End. The art itself is unchanged; this is a loading-path fix only.


## V8 event-art + dossier pass — 2026-10-08

The next secondary visual package is now integrated.

- **Торговец свечами / Candle Seller** gets a dedicated moonlit candle-market environment.
- **Лавка могильщика / Gravedigger Shop** gets a dedicated graveyard-market environment.
- **Кровавая книга / Blood Ledger** gets a dedicated gothic altar / forbidden ledger environment.
- **Карта без лица / Faceless Card** gets a dedicated ritual chamber with the floating faceless card.
- **Досье отряда / Squad Dossier** no longer enlarges 96×96 combat sprites. It now reuses the accepted 640×480 Knight / Ranger / Mage portraits from Class Select through the same runtime WebP path.

All four event environments are native 1280×720 WebP sources and are loaded through the runtime decoder to avoid Godot import/preload timing failures. Event text, prices, choices and consequences remain live UI.


## V9 final generic-event environment pass — 2026-10-08

The last planned batch of generic Act 1 event environments is now integrated into the shared live Act Choice screen.

Dedicated native 1280×720 authored environments now exist for:

- **ГРЕМУЧИЙ МОСТ / Rattling Bridge** — moonlit rope/chain bridge over the cursed ravine;
- **КОШЕЛЬ МЕРТВЕЦА / Lost Purse** — grave road with corpse, bones and spilled gold;
- **КОСТИ ДОЛЖНИКА / Debtor Bones** — moonlit ritual dice/debt altar;
- **КОСТЯНАЯ ПОШЛИНА / Bone Tax** — bone-tithe gate and skeletal scales;
- **ДЕСЯТИНА ВОЛШЕБНИКА / Wizard Tithe** — ceremonial tithe altar under the full moon;
- **ПЕПЕЛЬНЫЙ ПРИВАЛ / Ash Rest** — ruined cemetery camp and dying fire;
- **ПОСЛЕДНИЙ ПРИВАЛ / Last Camp** — lonely late-run camp beneath the gothic city;
- **СЛОМАННАЯ КОРОНА / Broken Crown** — ruined shrine with the broken crown as the focal object.

These sources use the same runtime WebP decoding path as the v7/v8 event art, so Godot does not depend on import-time Texture2D recognition. All event text, prices, recruit/fate state, artifact state and choice consequences remain live Godot UI.

Together with the v7/v8 packages, all of the high-priority and planned secondary Act 1 non-combat event screens now have dedicated authored environment art. Further visual work should be screenshot-driven polish rather than another broad art-replacement batch.


## Continuation checkpoint — 2026-10-08

A durable handoff is now stored in `docs/HANDOFF.md` and the complete current visual mapping/provenance is stored in `docs/VISUAL_ASSET_REGISTRY.md`.

The eight final V9 generated event compositions are additionally archived as larger 1672×941 Q95 WebP masters under `assets/source_archive/visual_pass_v9/`, separate from the 1280×720 runtime exports.

Broad Act 1 art replacement is complete. The next visual step is screenshot-driven correction only; the next product step is full vertical-slice validation through Bone Warden in solo/duo/trio runs.
