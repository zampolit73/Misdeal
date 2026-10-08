# Misdeal — Current Handoff

Last updated: 2026-10-08

This file is the compact continuation point for a new ChatGPT Project chat. GitHub remains the source of truth for implemented state.

## Current baseline

Functional/visual baseline commit before this handoff archive: `bdc9246421b6a2efdd75cb3be3e750d87c485a01` — **Integrate final v9 event environments**.

The user locally confirmed the v7/v8 rollout and the table/battle brightness fixes as working/acceptable. The newest V9 event-environment package has been integrated in GitHub and is the next screenshot-validation target.

Do not ask the user to re-explain the recent visual history. Read this file, `docs/VISUAL_ASSET_REGISTRY.md`, `PROJECT_STATE`, `ROADMAP` and `DECISIONS`.

## What is now visually replaced

Broad Act 1 art replacement is considered complete.

- Main menu: approved authored splash, live transparent CTA hotspot.
- Intro: five authored 1280×720 frames.
- Wizard table: accepted v6 Wizard/table backdrop, live UI/cards, corrected midtones.
- All 25 active table cards: current v4/v5/object-specific art; no intentional unrelated-art fallback.
- Class Select: dedicated Knight / Ranger / Mage portraits.
- Squad Dossier: reuses the same dedicated portraits, not combat-sprite crops.
- Reward: dedicated v7 reward backdrop.
- Run End: dedicated v7 ending backdrop.
- Whispering Well: dedicated v7 environment.
- Curse Forge, Chained Prisoner, Black Altar: dedicated v7 environments.
- Candle Seller, Gravedigger Shop, Blood Ledger, Faceless Card: dedicated v8 environments.
- Rattling Bridge, Lost Purse, Debtor Bones, Bone Tax, Wizard Tithe, Ash Rest, Last Camp, Broken Crown: dedicated v9 environments.
- Battles: native-HD authored Crypt/Gallows and v6 Graveyard/Ossuary/Warden/Bone Crush; Bone Crush deployment/combat bounds were aligned to the visible floor.

## V9 event mapping

The shared live event scene is `scenes/event/act_choice.tscn`, driven by `scripts/event/act_choice.gd`.

| card_id | Player-facing card | Runtime art |
| --- | --- | --- |
| `rattling_bridge` | ГРЕМУЧИЙ МОСТ | `assets/pixel/event/v9/rattling_bridge.webp` |
| `lost_purse` | КОШЕЛЬ МЕРТВЕЦА | `assets/pixel/event/v9/lost_purse.webp` |
| `debtor_bones` | КОСТИ ДОЛЖНИКА | `assets/pixel/event/v9/debtor_bones.webp` |
| `bone_tax` | КОСТЯНАЯ ПОШЛИНА | `assets/pixel/event/v9/bone_tax.webp` |
| `wizard_tithe` | ДЕСЯТИНА ВОЛШЕБНИКА | `assets/pixel/event/v9/wizard_tithe.webp` |
| `ash_rest` | ПЕПЕЛЬНЫЙ ПРИВАЛ | `assets/pixel/event/v9/ash_rest.webp` |
| `last_camp` | ПОСЛЕДНИЙ ПРИВАЛ | `assets/pixel/event/v9/last_camp.webp` |
| `broken_crown` | СЛОМАННАЯ КОРОНА | `assets/pixel/event/v9/broken_crown.webp` |

The original generated V9 compositions are also preserved as larger 1672×941 Q95 WebP masters under `assets/source_archive/visual_pass_v9/`. Those archive files are not runtime dependencies; they exist so later art work can crop/re-export from the approved generated source instead of regenerating from memory.

## Important runtime-art rule

Godot 4.7.2 locally failed when newly committed WebPs were referenced directly through `preload()` or new `Texture2D` scene ext_resources before import state was ready.

For new authored screen WebPs, use the established runtime path:

- `scripts/ui/runtime_webp_texture.gd`
- `FileAccess`
- `Image.load_webp_from_buffer()`
- cached `ImageTexture`

Do not reintroduce direct preloads for newly added WebP screen art unless locally proven safe.

## Visual lessons already learned

Do not repeat these rejected passes:

- 112×69 card cells enlarged to live card size: rejected as muddy/blocky.
- 320×180 arena cells enlarged to 1280×720: rejected as visibly low quality.
- strong environment/card post-grading on already-dark authored art: rejected because it crushed midtones to black.
- broad generic AI-fantasy density with equal-detail candles/bones/ornament everywhere: rejected as obviously generated and hard to read.
- full-screen generated UI screenshots with baked prices/buttons/stats: do not use as production UI; dynamic state stays native Godot controls.
- combat units placed over architecture rather than the painted floor: explicitly fixed for Bone Crush and should remain a layout check for future arenas.

Accepted direction:

- authored dark-gothic pixel look;
- large quiet masses and readable focal subjects;
- fewer decorative micro-details;
- native/near-display resolution;
- live UI over authored environment art;
- nearest presentation where appropriate;
- preserve dark midtones rather than crushing everything to black.

## Current gameplay state that must not be accidentally changed by visual work

- Godot 4.7.x + GDScript.
- Act 1: 12 resolved cards, then Bone Warden boss.
- Run starts with exactly one chosen protagonist.
- Companions can be recruited/lost; solo/duo/trio is real run state.
- Solo compensation: hero HP ×2.2, damage ×1.9, attacks/sec ×1.25, movement ×1.10; enemy HP ×0.82 and damage ×0.80.
- Duo: +20% HP, +15% damage.
- Bone Warden composition/mechanics remain the benchmark; its enemy HP/damage inherit the same transparent party-size pressure scaling as other encounters.
- Tactical orders: НАТИСК / ОХОТА / СТРОЙ plus temporary ЖЕРТВА / НЕПОВИНОВЕНИЕ when unlocked.
- Wizard wagers, debt, marks, holds, memory, rescue scars and Last Deal are implemented systems.
- Visual passes must not silently alter mechanics, prices, stats, card odds or encounter composition.

## Latest local-fix follow-up

A 2026-10-08 Gallows Volley screenshot showed units, especially retreating ranged roles, climbing into the authored background above the visible floor. The encounter now uses a tighter floor-aligned combat rectangle, matching deployment band and adjusted party start positions. This is a movement-space fix for every unit in Gallows Volley, not an archer-only workaround. It is pending local verification.

The current V9 event environments were also reviewed directly from the repository against `docs/ART_DIRECTION.md`. Several remain visually over-detailed and repeat the same candles / gothic skyline / red-banner language. Do not replace them blindly; prioritize object-first redraws where local event screenshots confirm the mismatch, while keeping live UI/text untouched.

## Latest targeted battle fix

A post-handoff screenshot exposed Gallows Volley units visually moving over the background architecture. `main` now lowers/tightens that encounter's legal combat floor, moves hero/enemy spawns onto the stone platform, and clamps all units immediately when combat bounds are assigned. This is pending local verification, especially ranged retreat and separation with solo/duo/trio parties.

## Latest UI-kit screenshot fixes

The first local screenshot pass after the shared UI-kit rollout is already folded into `main`: authored-image hotspots on the main menu and intro are transparent again, and resolved generic Act Choice screens now hide the obsolete leave action and give long result messages their own bottom strip above a single `К СТОЛУ` button. The screenshots otherwise validated the new event and Reward/development chrome direction as substantially more coherent.

## Shared UI-kit follow-up

A first shared gothic UI-kit pass is now in `main` through `scripts/ui/misdeal_ui_kit.gd`. It is applied to the main menu, intro, Class Select, Wizard table/wager, Squad Dossier, shared Act Choice, Whispering Well, Reward, Battle HUD/Last Deal and Run End. The pass keeps all existing authored art and live UI content, but replaces the previous screen-by-screen chrome with one runtime style language.

This is pending local 1280×720 verification. Check especially event/reward card text margins, hover/disabled states, corner marks over portrait/art regions, Wizard wager readability and Battle HUD density. Fix concrete screenshot defects; do not start a second competing UI framework.

## Latest target-preview UX fix

The first-target intent system is no longer permanently visible during preparation. A live `ЦЕЛИ: ВКЛ/ВЫКЛ` toggle now sits above the central `БОЙ` action. It starts off on a fresh app launch, remembers the player's preference between battles/new runs during that app session, and the lines still disappear automatically as soon as combat begins. This keeps the tactical information available without permanently cluttering five-enemy layouts such as Death Wager.

## Latest parse-order hotfix

A follow-up local screenshot exposed one rollout mistake in `scripts/run_end/run_end.gd`: `SCENE_ROUTER` had been inserted before `extends Control`, causing `Unexpected "extends" in class body`. The declaration order is fixed. A repository check of all active navigation scripts confirms they now begin with `extends ...` and contain **zero direct `SceneTransition.` references**; navigation goes only through `SCENE_ROUTER`.

The old battle error line mentioning `SceneTransition` may remain visible in Godot's output history until the next clean run, but current `main` no longer contains that identifier in `battle.gd`.

## Latest SceneTransition compile hotfix

A local screenshot showed `Identifier "SceneTransition" not declared in the current scope` after the user's `project.godot` had previously conflicted during pull. The repository's canonical `project.godot` does contain the autoload, but navigation no longer relies on that global symbol at parse time.

All active navigation now uses `scripts/core/scene_router.gd`. It resolves `/root/SceneTransition` when registered; otherwise it instantiates `scene_transition.gd` as a persistent root child at runtime. This means a stale/local `project.godot` can no longer prevent battle/event scripts from compiling, and the seamless dark transition remains available.

## Latest gray-frame root fix + battle intent improvement

The first transition veil still produced an intermittent full-gray frame locally. The root cause path has now been removed: `SceneTransition` no longer calls `change_scene_to_file()` for normal navigation. It threaded-loads the incoming PackedScene while the old scene remains visible, instantiates it before blackout, waits until a fully opaque veil frame has actually rendered, manually adds the new scene while the old one still exists, switches `current_scene`, queues the old scene for deletion, waits for incoming runtime-art/layout frames, then reveals the result. Runtime and project clear colors are both forced to the same near-black fallback.

Battle preparation now also shows live target intents using the existing combat AI: blue arrows are hero first targets under the current tactical order; red arrows are enemy first targets under the current placement. They update during dragging/order changes and vanish on `БОЙ`.

Local verification priority: repeatedly cycle table → event → table → combat → reward → table several times, then verify the intent arrows remain readable in solo, trio and Death Wager layouts.

## Latest start-screen + transition fix

The user approved the restrained replacement main splash after rejecting the previous low-quality version and two over-AI/off-model Wizard attempts. The canonical runtime image is now `assets/pixel/main/approved_splash_hd/main_splash.webp` at 1280×720. `scripts/main/approved_main_backdrop.gd` loads it with FileAccess + `Image.load_webp_from_buffer()`; do not restore the removed compressed chunk loader.

A brief gray screen was also reported when changing into battle and when returning to card selection/table after events. `SceneTransition` is now a persistent autoload CanvasLayer that covers the viewport before scene replacement, survives the replacement, waits through the incoming scene's first two frames, and fades out. Active main/intro/class-select/table/event/battle/reward/run-end transitions and battle reloads use it. The renderer clear color is the same near-black fallback.

Pending local check: fresh `git pull` + Godot restart, then inspect the main splash and specifically table → battle, event → table, battle → reward and Last Deal reloads for any remaining flash.

## Latest gameplay/balance pass

A first full-run party-size pressure rebalance is now in `main`. Solo keeps one hero but receives HP ×2.2, damage ×1.9, attacks/sec ×1.25 and movement ×1.10; enemy HP/damage are reduced to 82%/80%. Duo keeps +20% HP/+15% damage while enemy HP/damage are 92%/90%. Trio remains the authored 100% encounter baseline.

Enemy composition and boss mechanics are unchanged. Grave Bell/support healing scales with enemy HP. Debt/Mark danger multipliers stack relative to the party-size baseline. Tier 0 also cannot force combat on card 1 anymore: at least one non-combat decision occurs first.

This is pending real local verification. Highest-value checks are: solo Ranger and solo Mage first mandatory fight, one duo mid-tier support/ranged fight, one late elite, and Bone Warden in solo/duo/trio. Do not blanket-retune individual enemies before those checks unless a concrete regression appears.

## Latest Act 1 progression system

The user approved the **РАСКЛАД СУДЬБЫ** concept and it is now implemented in `main` as live UI.

The normal cursed table keeps a subtle 12-position occult ring behind the active deal. `РАСКЛАД СУДЬБЫ [R]` opens `scenes/table/fate_spread_overlay.tscn`, which shows chronological resolved cards I–XII with real card art, the current position, central sealed XIII/Bone Warden, the held card, and the most recent rejected card in the Wizard discard. The overlay also shows live counts and the three visual four-card chapters. Future slots intentionally remain `?` because current offer RNG does not pre-schedule route types.

Local verification should check the overlay at early/mid/late progress and specifically confirm that the 12-card ring remains readable at 1280×720, long Russian card titles do not collide, held/rejected art is correct, and `R` reliably closes the overlay without triggering table actions beneath it.

## Exact next step

Do not begin another broad art-generation pass.

1. User pulls latest `main`.
2. Start a fresh **solo Ranger or solo Mage** run and confirm card 1 is non-combat, then play the first mandatory fight without debug intervention.
3. Continue far enough to verify one mid-tier ranged/support encounter and one late elite; report only concrete difficulty spikes or trivial fights.
4. Re-run **ЗАЛП С ВИСЕЛИЦЫ** during that pass and verify retreat/chase/separation keep every unit on the stone floor.
5. When convenient, repeat a shorter duo/trio check and use Bone Warden as the final benchmark. Only then retune individual enemies or boss numbers.
6. Visual work remains screenshot-driven only: fix concrete event/UI defects instead of starting another blanket art batch.

## Git workflow

The assistant has connected GitHub access in Project chats and should use it directly when implementation/fixes are requested. Do not repeatedly tell the user Git access is unavailable without first checking the connected GitHub tools.

The user normally needs only:

`git pull`

then restart/run Godot and report screenshots/errors.
