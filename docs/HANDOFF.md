# CURRENT SESSION CHECKPOINT — Battle HUD/readability rework

Date: 2026-10-11

The latest local feedback rejected the battle screen presentation: the footer was too cramped, special tactics had no real room, and the overall battle UI read as low-quality.

A layout/readability pass is now implemented:
- battle footer expanded upward to 170 px;
- five fixed tactical slots with full **НЕПОВИНОВЕНИЕ** label;
- wide order-description area;
- separate target-preview and Fight column;
- side-objective panel moved into the right footer column;
- top encounter/status text placed on a framed plate;
- playable combat bounds moved above the footer;
- pixel-art fallback resize changed from Lanczos to nearest-neighbor.

Important safety note: no attack timing, spawn lifecycle, targeting rules, tactical effects, reward flow or encounter stats were changed. The earlier empty-arena regression guard still applies.

Immediate local check after `git pull`:
1. open a fight with only the normal three orders;
2. open a fight where **ЖЕРТВА** or **НЕПОВИНОВЕНИЕ** is available;
3. confirm all available tactics fit without abbreviations or overlap;
4. drag all heroes around the legal deployment area and confirm nobody can end up under the footer;
5. press **БОЙ** and verify units remain visible and fight normally;
6. send one screenshot if the arena art itself still looks muddy — that would require a separate native-HD asset redraw, not another UI squeeze.

---

# CURRENT SESSION CHECKPOINT — Combat Expansion art integrated

Date: 2026-10-11

This is the current continuation point for the next chat.

The user reported that Act 1 runs felt repetitive, so Combat Expansion v1 was added first, then the six new fights received approved dedicated visual concepts and those visuals were integrated into GitHub.

Current live expansion fights:
- `bone_swarm` — КОСТЯНОЙ РОЙ;
- `grave_crossfire` — МОГИЛЬНЫЙ ПЕРЕКРЁСТОК;
- `iron_wall` — ЖЕЛЕЗНАЯ СТЕНА;
- `last_bell` — ПОСЛЕДНИЙ ЗВОН;
- `firing_square` — РАССТРЕЛЬНАЯ ПЛОЩАДЬ;
- `bone_ritual` — КОСТЯНОЙ РИТУАЛ.

Dedicated production exports are already live:
- arenas: `assets/pixel/battle/arenas/combat_expansion_v1/*.webp` at 1280×720;
- table cards: `assets/pixel/ui/combat_expansion_v1/cards/*_card.webp` at 448×274;
- `scripts/battle/authored_backdrop.gd` routes each expansion `arena_id` to its own authored backdrop;
- `scripts/ui/card_art_catalog.gd` loads dedicated card art instead of the temporary semantic aliases;
- every new EncounterData now owns a matching dedicated `arena_id`.

The original approved generated composite concepts are archived under `assets/source_archive/combat_expansion_v1/*_composite_master.webp` so future recrops/exports do not require regenerating the scenes.

Important current gameplay state:
- the six new cards are in the real Act 1 random tier pools, two per tier;
- the act remains twelve resolved pre-boss cards;
- Bone Raider and Crypt Sentinel still intentionally reuse the Bone Thrall / Crypt Guard unit silhouettes. Their mechanics should be validated before commissioning dedicated unit art;
- battle spawning had a severe empty-arena regression earlier in the motion work. The stable battle core was restored and locally confirmed working. Do not reintroduce broad async attack/controller animation patches;
- current battle polish is isolated visual-only feedback (tactical tells, Sacrifice/Defiance state FX, hit readability).

Immediate next local action after `git pull`:
1. start a fresh run so the expanded random pool is rebuilt;
2. confirm the six new table cards show their new dedicated art rather than old aliases;
3. enter any new fight that appears and confirm the matching new arena backdrop loads, heroes/enemies still spawn, and deployment remains usable;
4. note which new encounters are fun/redundant/overtuned before adding more fights or creating dedicated Raider/Sentinel art.

Do not redesign the approved six arena/card concepts unless the user asks. They were explicitly approved and should now be treated as the visual source of truth for Combat Expansion v1.

---

### Combat Expansion v1 dedicated arenas/cards are live

All six new fights now have dedicated approved production art:
- `bone_swarm`;
- `grave_crossfire`;
- `iron_wall`;
- `last_bell`;
- `firing_square`;
- `bone_ritual`.

Implementation:
- native 1280×720 WebP backdrops: `assets/pixel/battle/arenas/combat_expansion_v1/`;
- dedicated 448×274 card art: `assets/pixel/ui/combat_expansion_v1/cards/`;
- encounter `.tres` files now use unique arena IDs;
- `scripts/battle/authored_backdrop.gd` selects exact expansion backdrops;
- `scripts/ui/card_art_catalog.gd` runtime-decodes exact expansion cards; the temporary alias map is removed;
- `battle_visual.gd` / `unit.gd` keep the closest validated atmosphere/tint families.

The only intentional visual reuse left in Combat Expansion v1 is enemy-unit silhouettes: Bone Raider still uses the Bone Thrall family, Crypt Sentinel the Crypt Guard family, pending gameplay validation.

Local check after pull:
1. start a fresh run;
2. inspect all six new cards when they appear — each must have unique art;
3. enter each new fight — each must show its matching unique arena;
4. verify heroes/enemies still render and remain on the floor;
5. report any arena whose playable floor visually disagrees with its current deployment bounds.

### Combat Expansion v1 is live

Six new combat cards are in the Act 1 random pool:
- tier 0: `bone_swarm`, `grave_crossfire`;
- tier 1: `iron_wall`, `last_bell`;
- tier 2: `firing_square`, `bone_ritual`.

New UnitData:
- `resources/units/bone_raider.tres` — fast fragile pressure, currently reuses `bone_thrall` visual_role;
- `resources/units/crypt_sentinel.tres` — lighter AOE guard, currently reuses `crypt_guard` visual_role.

New cards use semantic temporary art aliases in `scripts/ui/card_art_catalog.gd`:
- Bone Swarm → Bone Crush;
- Grave Crossfire → Graveyard Ambush;
- Iron Wall → Crypt Guard;
- Last Bell → Grave Bell;
- Firing Square → Gallows Volley;
- Bone Ritual → Ossuary Gate.

This is intentional gameplay-first reuse under D104. Do not generate a broad replacement art batch until run testing identifies the encounters worth keeping.

Local validation target:
1. start fresh runs so the expanded `ACT1_CARD_IDS` pool is rebuilt;
2. confirm new combat cards can appear in their intended tier;
3. check no card art is blank;
4. verify heroes/enemies spawn normally in each new fight;
5. pay special attention to Iron Wall / Last Bell / Firing Square / Bone Ritual difficulty in solo and duo;
6. report which fights actually feel different — redundant fights should be cut or redesigned before art investment.

### Safe combat-feedback pass is live

The user confirmed the restored battle core works again. New combat polish is intentionally isolated:

- `scripts/battle/battle_motion_fx.gd` is a visual-only overlay added to `battle.tscn`;
- it listens to tactical-order/Fight buttons directly and never calls spawn/controller/RunState logic;
- normal orders show short squad markers; Sacrifice/Defiance gain restrained persistent red/blue auras after Fight; Death Wager has a subtle red frame tell;
- `scripts/battle/unit.gd` only changes existing feedback functions: source-aware hit tint, stronger large-hit kick/number/sparks, slightly clearer ranged/magic tracers;
- `scripts/battle/battle.gd` is unchanged.

Regression guard:
- do not reintroduce async attack windup or broad battle-controller animation patches;
- do not move tactical FX into spawn/configure code;
- if anything disappears in battle, first disable/remove `BattleMotionFx` and compare `unit.gd` feedback-only changes before touching controller logic.

Local checks:
1. open a normal combat and confirm all heroes/enemies are present before Fight;
2. switch НАТИСК / ОХОТА / СТРОЙ and confirm only short markers appear;
3. when available, test ЖЕРТВА and НЕПОВИНОВЕНИЕ for restrained red/blue auras;
4. inspect melee/ranged/magic hits and one large hit;
5. open Death Wager and confirm the red frame is subtle.

### Event motion is partially restored, entry-only

Generic Act Choice and Whispering Well now have a safe entry-only choice-card stagger.

Important guardrails:
- no `button_down` commitment callbacks;
- no result-delay changes;
- no active-card initialization changes;
- no choice-art loader/source changes;
- no battle files touched.

The earlier broken wholesale event-motion patch must not be restored. Next local check is simple: open several generic events and Whispering Well, confirm all real text/art is present first, then verify the cards settle in without blank/template states.

### Motion Pass 5 — safe non-battle screens

While battle spawning is being protected after the empty-arena regression, motion work continued only on isolated UI controllers:
- `scripts/class_select/class_select.gd`: staggered three-card entry + chosen-card commit;
- `scripts/intro/intro.gd`: one-shot frame settle + initial hint/skip reveal;
- `scripts/table/squad_status.gd`: overlay open/close + role-switch focus.

No battle file was modified in this pass.

Local checks:
1. Main → Intro: click through all five frames and confirm there is no input delay/double advance;
2. Class Select: hover and choose each role once; selected card should focus before table transition;
3. Table → Squad [TAB]: switch 1/2/3 several times and close with TAB/Escape; portrait/stats must stay correct.

### Empty battle arena — full controller rollback applied

The first rollback of only `unit.gd` did not fix the user's local empty preparation arena. `scripts/battle/battle.gd` has now also been restored to the known-good pre-animation baseline `aa8f9d5ed05134b4a3507995c22d845191c237b7`.

This intentionally removes the recent battle tactical/result/Last Deal motion together with attack/death motion. Do not try to preserve those animation additions until local battle spawning is confirmed again. The next required check is simply: open Bone Patrol and confirm heroes + enemies render before pressing **БОЙ**.

### Battle units missing regression — hotfixed

The battle preparation screen was reported with zero visible heroes/enemies. `scripts/battle/unit.gd` has been restored to the known-good pre-Motion-Pass-2 version from commit `ddae81ca7e385cfc77767c7a5fbd190f001a624c`.

Keep the newer `battle.gd` tactical/result/Last Deal motion, but do not restore the prior async attack-windup/death-settle patch in `unit.gd` wholesale. First local check after pull must be that heroes and enemies render in preparation and can be dragged before battle.

### Motion Pass 4 — table ambience and outer shell is live

Key implementation:
- `scripts/table/table_spread_visual.gd` owns subtle candle halos and the event-driven ritual-circle reaction overlay. It does not replace/redraw the Variant C art.
- `pulse_deal()` reacts the deck and ritual area; `pulse_ritual(kind)` is called from existing deal/Hold/choice/Wizard state changes in `scripts/table/table.gd`.
- `scripts/core/scene_transition.gd` keeps the existing safe blackout swap, but chooses a very dark veil tint by destination path.
- `scripts/main.gd` has a one-shot entrance + Start commit.
- `scripts/run_end/run_end.gd` has a one-shot hierarchy reveal + New Run commit.

Do not increase candle halo opacity aggressively: the current overlay is meant to make authored flames feel alive, not draw new glowing blobs over the plate.
Do not convert ritual reactions into a permanent rotating/pulsing HUD circle.
Do not lengthen scene-transition timing; the tint is the polish, the fast swap is still the product requirement.

Local checks after pull:
1. stay on the table for several seconds and confirm candle flicker is barely perceptible rather than distracting;
2. deal, Hold, choose a card, accept/refuse a wager and trigger meddling if available — center-table reactions should be momentary;
3. traverse table → event/battle → reward/table and confirm transitions remain fast/dark;
4. view Main Menu and Run End once and confirm entry motion does not delay input materially.

### Motion Pass 3 — battle commands/results is live

Runtime changes are concentrated in `scripts/battle/battle.gd`:
- tactical order selection calls `_play_tactical_order_feedback()`;
- **БОЙ** awaits `_play_fight_commit_feedback()` before hiding deployment UI;
- side-objective success/failure calls `_play_side_objective_feedback()`;
- `_finish_battle()` defers `_animate_result_overlay(player_won)` after all result text/button visibility is configured;
- Last Deal gets one follow-up emphasis via `_pulse_last_deal_after_reveal()`;
- continue / Last Deal accept / Last Deal refuse await a tiny `_animate_result_choice_commit()` before navigation.

Do not add continuous result-panel breathing or repeated Last Deal pulsing. The current direction is a single clear reveal/commit sequence.

Local verification after pull:
1. switch between several tactical orders during deployment;
2. press **БОЙ** and confirm the short press beat does not feel laggy;
3. trigger a side-objective failure/success if convenient;
4. win a battle and take the reward;
5. lose a battle and inspect Last Deal, then test accept/refuse when possible.

### Motion Pass 2 is implemented — battle / Fate Spread / Wizard reactions

Current motion state:
- `scripts/battle/unit.gd`: attack impact is preceded by a tiny role-specific windup (melee ~0.08 s, ranged ~0.11 s, magic ~0.14 s). Cooldown is set before the windup, so do not additionally increase `attack_interval` to "compensate" — the presentation pass is not intended as a balance change.
- death feedback now staggers briefly before settle/fade.
- `scripts/battle/battle.gd`: Bone Warden Phase II pulses arena/backdrop color briefly; no generic camera shake.
- `scripts/table/fate_spread_overlay.gd`: visible ring cards stagger in, current position gets a focus beat, 4/8/12 milestone cards/counts/seal are emphasized. Do not move/redesign the frozen approved Fate Spread geometry.
- `scripts/table/table.gd`: Wizard wager/meddling/marked-card moments call `_pulse_wizard_reaction()`, which only tints the authored full-screen backdrop briefly. The Wizard painting itself remains static.

Animation regression guard:
- do **not** restore the previous wholesale `act_choice.gd` `button_down`/commit patch; it caused the raw template screen to appear.
- do **not** restore the previous Whispering Well commitment patch wholesale; it coincided with missing mini-art.
- Table Hold/discard and Reward motion remain active and locally accepted enough to continue from.

Immediate local checks after pull:
1. one melee-heavy battle and one ranged/magic battle;
2. a unit death on each side;
3. Bone Warden crossing 50% HP;
4. open Fate Spread at an ordinary point and at a 4/8/12 milestone if convenient;
5. trigger Wizard wager or meddling and confirm the backdrop tint is subtle, not a full-screen flash.

### Whispering Well choice art is restored

After the motion pass, the dedicated Well screen could render without its three choice images. `scripts/event/whispering_well.gd` is back on the stable pre-motion controller, and `get_whispering_well_texture()` uses the approved split-sheet source. Do not reapply the removed Well commitment-motion patch wholesale.

### Act Choice motion regression was rolled back

After Motion Pass 1, the generic Act Choice screen could show raw template placeholders instead of the selected event. The event-motion changes in `scripts/event/act_choice.gd` were rolled back to the known-good semantic-art state. Do not reapply the previous `button_down`/stagger commit patch wholesale. Table and Reward motion from the same pass remain enabled and should be tested independently.

### Motion language pass 1 is implemented

Table + Events + Rewards now share a more physical motion language.

Important runtime points:
- `scripts/table/table.gd`: Fate Hold has a card-to-hold stamp animation; card selection moves the chosen card toward the player and rejected cards toward discard.
- `scripts/table/table_spread_visual.gd`: discard stack has an explicit `pulse_discard()` impact reaction.
- Discard UI state is deliberately refreshed during the rejection travel near impact, not immediately when `RunState.choose_card()` succeeds.
- `scripts/event/act_choice.gd`: choice cards stage in and `button_down` starts commitment feedback before the resolver's `pressed` callback; result reveal is delayed slightly when that beat exists.
- `scripts/event/whispering_well.gd`: same committed-choice language on the dedicated Well screen.
- `scripts/reward/reward.gd`: staged card entrance plus an awaited ~0.18 s selected-reward focal beat; `_reset_buttons()` restores transforms/modulate so multi-stage rewards remain safe.

Do not turn this into floating/pulsing-everything UI. The accepted motion direction is object weight and short physical cause/effect.

Next suggested package is battle anticipation/death motion + Fate Spread ritual motion + restrained Wizard ambience.

### Broad Act 1 semantic mini-art pass complete for the main duplicate cases

Current runtime no longer relies on three copies of the event thumbnail for the main remaining duplicate-choice screens.

Now explicitly mapped in `scripts/event/act_choice.gd`:
- Lost Purse;
- Debtor Bones;
- Wizard Tithe;
- Blood Ledger;
- Bone Tax;
- Ash Rest recruitment;
- Last Camp recruitment;
- both Rattling Bridge states;
- Chained Prisoner states;
- Black Altar recruitment.

`scripts/ui/approved_event_choice_art.gd` exposes a small reusable semantic action library from already-approved assets: `rescue`, `bag`, `leave`, `whisper`, `coins`, `occult_card`, `chains`, `loot_body`, `blood`, `cursed_relic`.

Native 384×160 sources are preferred whenever available. Do not regress these screens to the generic event-image fallback just to make implementation simpler.

Remaining screenshot-driven exceptions should be handled individually. Faceless Card still has event-art fallback on choices without a truthful existing semantic image; shops/development cards already use the actual offered upgrade art and are not duplicate-thumbnail problems.

### Rattling Bridge mini-art wiring fix

The already-authored native bridge trio in `assets/pixel/event/choice/rattling_bridge_hd/` is now used for **both** Rattling Bridge states. The regular `rush / scavenge / careful` branch previously fell through to the generic event thumbnail, causing three duplicate bridge images. `act_choice.gd` now routes every `rattling_bridge` choice screen through `ApprovedEventChoiceArt.get_rattling_bridge_texture(index)`, and the loader uses the original 384×160 cells directly for quality.

### Approved event-choice mini-art sheet is canonical

The user approved the five-event mini-choice mockup as the visual target. Production now uses the cropped action-first illustrations from that sheet rather than duplicating the large event image or using schematic placeholders.

Canonical runtime source:
- `assets/pixel/event/choice/approved_choice_sheet_v2/part_00.txt`;
- `part_01a.txt`, `part_01b.txt`, `part_01c.txt`;
- `part_02.txt`, `part_03.txt`, `part_04.txt`;
- decoded by `scripts/ui/approved_event_choice_art.gd` into a 576×320 WebP sheet;
- each cell is 192×80 and intentionally displayed with nearest filtering.

Mapped states:
- Rattling Bridge recruitment;
- Whispering Well;
- Chained Prisoner recruitment;
- Black Altar recruitment.

Chained Prisoner's post-recruitment branch keeps the older dedicated semantic atlas. Curse Forge keeps the real artifact thumbnails, because its live options are three specific relics and those assets are more truthful than the concept-sheet generic forge actions.

Next visual targets are the remaining true duplicate-event-thumbnail cases: Lost Purse, Debtor Bones, Wizard Tithe, Ash Rest recruitment and Last Camp recruitment.

### Semantic choice-art continuation

After the approved Rattling Bridge trio, `black_altar` recruitment also received dedicated semantic mini-art. Runtime path:
- `assets/pixel/event/choice/black_altar_recruitment.svg`
- `ApprovedEventChoiceArt.get_black_altar_texture(index)`
- `act_choice.gd` applies it only while the Mage can still be recruited.

Do not redo Whispering Well / Chained Prisoner / Curse Forge: they already have semantically distinct choice imagery (dedicated atlas cells or actual artifact art). The next real duplicate-thumbnail targets are Lost Purse, Debtor Bones and Wizard Tithe, followed by the recruitment branches of Ash Rest and Last Camp.

### Semantic event-choice art benchmark

The next visual pass is now defined as: **context art describes the event; mini choice art describes the decision**. Do not keep reusing the same event illustration across all lower choice cards.

The first implementation is `rattling_bridge`:
- the rejected schematic SVG prototype has been removed;
- approved ranger-recruitment art lives in `assets/pixel/event/choice/rattling_bridge_hd/part_00.txt` + `part_01.txt`;
- loader/cell mapping: `scripts/ui/approved_event_choice_art.gd`;
- runtime selection: `scripts/event/act_choice.gd`;
- approved trio: rescue / bag / leave alone;
- the already-resolved branch still uses the generic fallback until its own dedicated trio is approved.

The art language is intentionally object/action-first and low-detail to reduce AI-like repetition. After local approval, continue the same language across the remaining event choice cards instead of regenerating whole event scenes.

## Continuation checkpoint — 2026-10-09 — screenshot cleanup committed — continue from here

This is the authoritative handoff for the next Project chat. GitHub is the source of truth for implemented code/state.

### Physical card-back solution is now canonical

After local screenshots showed that dark cleanup masks kept reading as holes, the user chose the physical-card solution.

`assets/pixel/table/card_back_runtime.svg` is now the shared neutral card back. On the normal Wizard table, two backs permanently occupy the baked offer positions beneath live cards, so a single centered live card reveals believable face-down cards rather than the baked sample events. The temporary cleanup panels and their table.gd visibility logic are gone.

In Fate Spread, empty Hold shows the same back with no dark title strip. Wizard Discard is completely absent when empty; when populated, its live top card sits on a card-back frame and is transformed to follow the authored painted stack.

Next local verification: one two-card deal, one single-card/retry state, empty Hold, populated Hold, empty discard and 2+ rejected-card discard. Only pixel alignment should remain.

### Latest refinement after local screenshots

The first cleanup attempt was rejected locally: the giant dark oval under the offers looked like a hole, and the Wizard-discard card in Fate Spread still floated off-angle.

Current `main` replaces that with two compact cloth-toned side cleanup patches that are visible only for single-card offers; two-card offers have no extra cleanup surface. The Fate Spread discard live-card layer is now 90% scale, lower, and rotated to the painted stack angle.

Next local check: pull `main`, inspect one normal two-card offer, one single-card/retry offer, and the Fate Spread discard with 2+ rejected cards. If anything remains, only small pixel offsets should be adjusted.

### Latest screenshot-driven fixes

The first local screenshot of the exact Variant C normal table exposed the baked sample offer cards when only one live card was present. `scenes/table/table.tscn` now has a restrained rounded dark cleanup layer directly beneath the live offers, covering that baked sample-card area without changing the approved table art direction.

The Fate Spread screenshot also exposed the Wizard-discard live card as axis-aligned over an angled painted stack, which made the dark backing visible. `scenes/table/fate_spread_overlay.tscn` now groups that live card/mask/title in a shared `CardLayer`, shifted and rotated to follow the physical stack; `scripts/table/fate_spread_overlay.gd` points at the new paths.

These are visual-only fixes. No gameplay, Fate Spread ring geometry or discard rules changed. Next step: `git pull`, verify both screenshots at 1280×720, then only nudge pixels if needed.

### What is visually locked

**Fate Spread / `РАСКЛАД СУДЬБЫ` is frozen.** The user explicitly accepted the current physical-table composition after several screenshot passes. Do not redesign it unless a concrete bug/leak appears.

Canonical Fate Spread files:
- `scenes/table/fate_spread_overlay.tscn`
- `scripts/table/fate_spread_overlay.gd`
- `scripts/table/fate_spread_reference_cleanup.gd`
- `assets/pixel/table/fate_spread/fate_spread_exact.webp`
- `assets/source_archive/fate_spread/fate_spread_exact_master.webp`

Important Fate Spread rules:
- I–XII/history/counts/Hold/Discard remain live run state.
- The approved sealed XIII skull/chain card is shown directly until the boss activates.
- Generic future card backs from the plate may remain visible when they truthfully represent future state.
- Live masks replace only baked run-specific/sample state.
- History hover is a compact cursor-adjacent tooltip.
- Do not move the ring, XIII, side holders or header without a concrete screenshot defect.

### Latest approved normal Wizard table

The user then approved a **cleaned-up Variant C** normal-table composition and explicitly asked to implement it almost exactly like the final art. This supersedes the earlier procedural oval-table approximation.

Canonical normal-table art:
- runtime: `assets/pixel/table/approved_variant_c/table_exact.webp` (1280×720)
- source master: `assets/source_archive/table/approved_variant_c/table_exact_master.webp`
- scene: `scenes/table/table.tscn`
- logic: `scripts/table/table.gd`
- loader: `scripts/ui/runtime_webp_texture.gd`

The approved visual language is:
- Wizard centered behind one broad oval red-black ritual table;
- restrained candle/brass/skull decoration, not dense AI-like micro-detail;
- physical deck stack on the left;
- physical rejected/discard stack on the right;
- two live offer cards near the player;
- Hold controls immediately above each live offer;
- `РАСКЛАД СУДЬБЫ [R]` centered between Wizard and cards;
- compact top HUD + live Wizard line;
- warm bronze/gold physical-card framing;
- no rectangular lower HUD slab and no duplicate compact progress map.

Current implementation:
- `WizardBackdrop` now runtime-decodes the exact approved full-screen Variant C plate.
- Old procedural `TableVisual`, compact `TableSpreadVisual`, and separate logo are hidden on the canonical normal table.
- Live offer cards are smaller/lower and use reduced rotation/hover motion to sit physically on the table.
- Deal origin is aligned to the left physical deck; discard destination is aligned to the right physical discard holder.
- Baked Hold text is covered by small live masks; live Hold buttons remain authoritative.
- Physical holder labels come from the art; only changing deck/discard numeric values are overlaid live.
- The old v6 Wizard crop remains in repository history/assets but is no longer the canonical table backdrop.
- No mechanics were intentionally changed by this visual pass.

### Immediate next action

The latest exact-art normal-table integration is committed but still needs the **first local 1280×720 screenshot after this exact plate was wired into runtime**.

After `git pull`, open the normal table with two offers and check only:
1. live offer cards align with/cover the baked sample-card zones cleanly;
2. Hold buttons do not double with baked Hold text;
3. deck/discard live numbers sit naturally on their physical plaques;
4. top HUD and Wizard line remain readable and do not feel like large black UI slabs;
5. live cards do not cover the Wizard's hands;
6. no hidden procedural table/logo/progress elements leak through;
7. wager overlay is still readable over the new full-screen plate.

If close, do **pixel-level alignment/mask/font fixes only**. Do not regenerate another table concept or return to the procedural oval-table version unless the user explicitly changes direction.

### Broader project state to remember

- Godot 4.7.x + GDScript.
- GitHub repo: `zampolit73/Misdeal`.
- Vertical-slice priority remains Act 1 through Bone Warden.
- All 25 active Act 1 table cards already have unique current art coverage.
- Dedicated current battle arenas exist for Crypt, Gallows, Graveyard, Ossuary, Warden and Bone Crush.
- Main menu, Class Select, Reward, Run End and all planned Act 1 event environments already have authored art passes.
- Solo/duo balance compensation is implemented and still benefits from full-run local validation; do not blanket-retune enemies before concrete test results.
- Pre-battle target intent lines are opt-in via the `ЦЕЛИ` toggle.
- Shared scene-transition veil is in place to avoid gray flashes; only revisit if a reproducible transition flash remains.
- Avoid broad architecture work or another global art replacement pass. The next phase after accepting the exact normal table should return to full vertical-slice validation, balance and concrete screenshot-driven fixes.


## Latest normal table exact-reference integration

## Current handoff — 2026-10-09 — continue from here

The user asked for the whole working context to be made durable in GitHub before moving to another chat.

### Do not revisit without concrete evidence

**Fate Spread is visually frozen.** The final approved physical-table composition is already in runtime and has gone through multiple local screenshot corrections. Only fix specific leaks/collisions if they appear.

### Latest approved normal table

The user's newest approved reference is the cleaned-up **Variant C** image with:
- Wizard centered behind the table;
- broad oval red-black ritual tabletop;
- relatively restrained edge props (candles/brass/skull, not dense generated clutter);
- physical deck stack at left and rejected stack at right;
- two offer cards centered near the player;
- Hold buttons immediately above each offer;
- `РАСКЛАД СУДЬБЫ [R]` centered under the Wizard;
- compact top status line + Wizard commentary.

That exact art is now the canonical runtime foundation at:
- `assets/pixel/table/approved_variant_c/table_exact.webp`
- source: `assets/source_archive/table/approved_variant_c/table_exact_master.webp`

Implementation:
- `scenes/table/table.tscn` uses `runtime_webp_texture.gd` to load the full 1280×720 plate;
- the old `TableVisual`, `TableSpreadVisual` and separate logo are hidden;
- live offer cards are ~230×278 and positioned around x=396 / 654, y=366;
- live Hold controls align to the art around y=334;
- live deck/discard animation points are near the physical side stacks;
- live deck/discard text now overlays only the changing numbers rather than redrawing the baked static labels;
- offer-card frames use a restrained brass/black physical-card treatment;
- dynamic run state remains authoritative despite the full-screen art.

### Next action in a new chat

First read the required project docs and current GitHub code, then ask for/inspect the **first local screenshot of this exact-art normal table** after the user pulls latest main.

Do not start a new broad visual generation pass. Fix only concrete alignment/masking problems from that screenshot. The likely first corrections, if needed, are tiny holder-number masks, Hold-button alignment, top-HUD width/opacity, and offer-card vertical position.

### Git access

GitHub access is available through the connected tools. Use it directly for implementation and fixes; do not repeatedly ask the user to copy files or claim Git is unavailable before checking the tools.


The user approved the final cleaned Variant C normal-table artwork and asked for it almost one-for-one. Runtime now uses `assets/pixel/table/approved_variant_c/table_exact.webp` as the full 1280×720 foundation, loaded through `runtime_webp_texture.gd`. The generated source master is archived at `assets/source_archive/table/approved_variant_c/table_exact_master.webp`.

`table.tscn` no longer relies on the old v6 upper-Wizard crop for the normal screen. The procedural tabletop and compact spread visual are hidden. Live HUD/Wizard text/buttons remain on top; offer cards are resized and aligned to the two card positions in the plate; only numeric deck/discard values are masked/replaced over the physical plaques; Hold text is masked so live Hold state remains authoritative. Deal/discard animation anchors match the physical side stacks.

Next local screenshot check: confirm there is no visible baked-card leakage around the two offer cards, deck/discard numbers do not double, Hold buttons line up with the art, and wager/memory overlays still read cleanly. Do not redesign the composition unless a concrete local screenshot exposes a mismatch.

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

## Latest main-table Variant C rebuild

The Fate Spread itself is now frozen. The user then approved a cleaner Variant C reference for the **normal deal table** and asked to eliminate the square/rectangular-table feel.

Current `main` now uses:
- the existing authored v6 Wizard backdrop for the upper scene;
- a live/procedural wide oval physical tabletop and red-black ritual cloth drawn by `scripts/table/table_visual.gd`;
- one large central ritual sigil instead of a second mini Fate-Spread/progress graphic;
- physical side holders with live deck/rejected stacks;
- live offer cards at y≈350 with Hold controls directly above;
- centered `РАСКЛАД СУДЬБЫ [R]` access above the cards;
- no old rectangular lower shade / offer-focus rectangle.

The deal and discard animation targets were moved to the physical side holders. The normal-table `SpreadProgress` label is intentionally hidden; detailed Act progress belongs to the Fate Spread overlay.

Next local check is screenshot-driven only: verify at 1280×720 that the oval table overlays the v6 Wizard backdrop cleanly without covering his hands, and that cards/holders look physically seated on the cloth. Fix geometry from that screenshot; do not redesign Fate Spread.

## Latest Fate Spread final polish

The latest screenshot is close enough that composition is now frozen. Final tweaks in `main`:
- future live replacement cards hide the footer/title and use a subdued physical card-back style;
- hover decision memory is a small cursor-adjacent tooltip clamped to screen bounds instead of a wide bottom strip;
- empty Hold/Discard card masks use dark leather/burgundy rather than pure black.

Do not move the ring, XIII, side holders or header unless a concrete screenshot exposes a real collision/leak.

## Latest Fate Spread screenshot alignment pass

Latest local screenshot was already close to target. Do not change the ring geometry. Fixes now in `main`:
- XII is a baked sample slot in the approved plate just like I–IV, so it is always masked and replaced by live state;
- static title is taken directly from the approved reference; only dynamic subtitle/count/chapter rows are masked/redrawn;
- right discard count is positioned inside its physical holder;
- empty side holders omit the floating `ПУСТО` text.

Next screenshot should be evaluated for tiny per-slot leaks/offsets only.

## Latest Fate Spread reference-preserving cleanup

The previous screenshot exposed over-masking: future slots had large black rectangles and the live sealed XIII covered the approved central skull/chain card. This has been corrected without moving the composition.

I–IV are always live-covered because the reference has sample cards there. V–XII use the reference's generic future backs until they become current/resolved, at which point a tight live mask/card replaces that position. The approved sealed XIII is now used directly until the boss becomes active; only then is the center masked for a live boss replacement. The header mask is fully opaque and wider.

Next screenshot should be checked for small alignment leaks only. Do not reintroduce broad full-slot masks unless a specific baked card edge is visibly leaking.

## Latest Fate Spread baked-state cleanup

The exact-reference screenshot exposed duplicate baked state from the concept plate behind live UI (old sample cards, Roman numerals, header text and XIII label). Do not move the layout again. A dedicated `scripts/table/fate_spread_reference_cleanup.gd` now paints only over those baked dynamic regions inside `SpreadArea`, while the approved physical-table art remains untouched.

The header mask is wider/opaque, all twelve slot regions use larger cloth masks that also cover the old Roman numerals, and XIII has its own cleanup patch. Empty Hold/Discard title plates are dark instead of parchment-colored.

Next local screenshot should be checked only for residual baked-state leakage or small mask alignment issues.

## Latest Fate Spread exact-reference rebuild

The user rejected approximation and asked for the Fate Spread almost exactly like the final approved reference. Runtime now uses `assets/pixel/table/fate_spread/fate_spread_exact.webp` as the full 1280×720 physical-table foundation. The live overlay was re-laid to the reference rather than keeping the previous modal geometry.

Important implementation details:
- live slot positions are explicit per-card coordinates matching the reference perspective, not an even mathematical ellipse;
- resolved cards use parchment/gold physical-card styling, current/future cards use dark backs;
- Hold/Discard rely on the artwork's ornate holders while live masks replace the baked sample card/count;
- the top baked title/stats are masked and redrawn from current `RunState`;
- runtime WebP loader now supports linear filtering for full-screen authored plates;
- old runtime edge plates / underlay were removed.

Next local check should focus on leakage: any baked reference card/title/count still visible beside a live replacement must be fixed with position/mask tweaks, not by darkening the whole scene.

## Latest Fate Spread edge-art pass

The full-screen reference plate is no longer used by the live Fate Spread. It was too constrained by masking/dimming and still read like a dark modal. The approved physical-table look is now supplied by three dedicated edge plates loaded through `runtime_webp_texture.gd`:

- top: candles, brass, books and gothic rail;
- left: candles, skull/ritual props, chains and red cloth;
- right: skull, goblet, candles, coins and red cloth.

The live center/ring/XIII/history remains unchanged and authoritative. Source masters are preserved under `assets/source_archive/fate_spread_edges/`. Validate screenshot brightness/overlap before changing geometry again.

## Latest Fate Spread underlay visibility fix

The first local screenshot after integrating the approved reference showed almost no visible authored table atmosphere because `Frame` was painting over the root-level underlay. The underlay is now inside `Frame`, above its panel background and below all live controls. The outer frame/scrim are lighter so candles, metal props and red cloth can actually read.

The central `SpreadArea/TableSurface` was simultaneously made much more opaque, and a dark header mask was added, so the concept image's baked cards/title/counters remain suppressed. Side panels continue to cover the concept's baked held/discard areas. Preserve this layering principle: authored physical-table atmosphere at the edges, live run data at the center.

## Latest approved Fate Spread visual target

The user approved the ornate Fate Spread reference (physical red ritual table, candles, skulls/metal props, stronger gold/red hierarchy). The runtime now blends a deliberately dark/blurred derivative at `assets/pixel/table/fate_spread/reference_underlay.webp` underneath the live overlay. The frame/scrim were made translucent enough for that atmosphere to read while the procedural central surface still suppresses baked reference details.

Important: do not replace live I–XII cards, XIII, counts, hold/discard state or history text with static image content. The approved art is an atmospheric plate only; the live UI remains the source of truth.

## Latest Fate Spread memory + milestone pass

The Fate Spread now also acts as a run diary. `RunState.fate_choice_history` records each resolved pre-boss chosen/rejected pair. Hovering a completed slot scales it up and shows a compact detail strip with the chosen card and rejected alternative. Existing runs fall back to aligned resolved/rejected history where possible.

The center is now grounded by a low-contrast procedural red-black table surface. Chapter boundaries IV/VIII/XII are one-shot ritual beats: once the normal table unlocks after crossing a boundary, the spread auto-opens, a dedicated ritual sound plays, and XIII/seal gets a short pulse/shake. `fate_spread_last_milestone_shown` prevents repeats.

Local verification priority: finish card 4, card 8 and card 12 in a fresh run; confirm each automatic reveal happens once, does not fight Wizard wager/meddling locks, closes normally with R/Esc, and hover memory displays the correct rejected partner.

## Latest Fate Spread reference polish

After the user confirmed the cleaned-up spread and explicitly asked to stay close to the approved concept, the screen received a reference-driven polish pass: live occult seal beneath the ring, visible fate-thread connecting I–XII, brighter completed path, milestone gates at IV/VIII/XII, inward ritual spokes, progressive blood/ember center intensity, and a dedicated XIII chain/seal overlay. XIII starts with two crossed chains, loses one entering the final chapter, and reveals an awakened mark when the boss becomes due. Side holders are shorter so the center owns the composition.

Next local check should capture the spread at roughly 0, 4, 8 and 12 resolved cards. Fix only concrete readability/collision issues from those screenshots; keep the reference's restrained ritual-table composition rather than adding generic HUD decoration.

## Latest Fate Spread screenshot fix

The first local Fate Spread screenshots showed the active deal cards and the table `РАСКЛАД СУДЬБЫ` button drawing over the inspection overlay. This is fixed in `main`: opening the spread now hides the live card layer and progress access, the overlay sits at the valid top CanvasItem z-index (4095), and the twelve ring cards were reduced/re-spaced to give XIII clear visual priority. Closing with `R`, `Esc` or the button restores the live deal.

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
