# MISDEAL — Development Guide

## Card art approval workflow — show options BEFORE finalizing

**User-approved mandatory rule (2026-10-15):** Before producing/replacing final card illustrations, **show the user multiple distinct visual options (normally 3)** as actual image previews, not just written descriptions. Distinguish composition, framing, scene emphasis or lighting; avoid minor palette-only variations masquerading as options. **Wait for the user to choose/approve one** before replacing any live card art in GitHub. Iterate on the selected option if requested. Every option must already satisfy the scene-first dark-fantasy quality bar (D167), DS2 and text-free illustration rules. After approval, the assistant itself commits the approved image into GitHub (prefer versioned export-safe 448×274 WebP/base64), switches the runtime art pointer, keeps the previous file for one-step rollback, and asks the user only to `git pull` and inspect the Godot F6 card preview. Never require users to unzip assets, manually paste code or upload approved pictures for the assistant.

**Already-approved exception:** The user explicitly approved the scene-driven D152 replacement illustration on 2026-10-15. Transfer that exact image now; **do not ask for additional D152 concept choices retroactively**. Apply the options-first rule to D153 and all future card art passes.

## Card art quality bar — illustrated world scenes, never sprite showcases

**Mandatory for all new and revised encounter-card illustrations in Misdeal.** A card must look like a moment in the game's dark-fantasy world, **not a demonstration of character/unit sprites**.

- Depict an actual authored **place, situation or event**. Environmental storytelling must be visible: grounded architecture, functional props, ritual residue, worn materials, weather/smoke/magic and purposeful lighting.
- Give characters a **physical relationship to the scene**: matched light direction, cast/contact shadows, coherent scale and perspective, occlusion and action that communicates why they are present.
- Prioritize **scene composition and atmosphere** over showcasing complete character silhouettes. Approved enemy designs can inform the illustration, but simply placing sprite cutouts over a blurred/empty backdrop is not an acceptable final card.
- Preserve the accepted DS2 / Fate Spread Variant C materials, restrained dark-fantasy palette and clean 448×274 card-art slot. Do **not** bake UI buttons, titles, card frames, Russian text or choices into the illustration; Godot owns interface chrome and text.
- Review at **native displayed card size in Godot**, not just at source size. Require immediate read of place and encounter, good focal hierarchy, legible silhouettes, and no obvious repeated/generative detail noise.
- Apply this to **every future encounter card**; existing approved cards may be audited and improved opportunistically without indiscriminate redesign or replacing their gameplay.

**Explicit anti-pattern:** characters presented like two pasted game sprites on a soft/blurred background with no credible world scene.

## New-chat bootstrap

**NEW CHAT PRIORITY — D153 HANDOFF (2026-10-15):** Read **[`docs/D153_NEXT_CHAT_START.md`](docs/D153_NEXT_CHAT_START.md)** first. User explicitly paused this session to start the next development stage in a fresh chat. **Actual Godot F6 thread smoke PASS** (32% protection, 285px, break/reconnect/death/cleanup), approved chosen third skeletal theatre card art displayed in Godot. Original **two full 25-frame animation atlas files are absent from GitHub** (both exact file paths and next steps documented in handoff); animation loader and F6 gallery are already committed but have NOT passed native art QA. Next task: assistant produces and commits authentic skeleton Puppeteer + Marionette animation atlases, then user only `git pull` + gallery F6. No gameplay/card activation, live pool **35/45**. New chat must verify repository `main` and honor D143/D167/D168. Do not re-ask GitHub access.


**CURRENT D153 STATUS (2026-10-15): NATIVE SKELETAL STRINGS F6 PASS.** User's actual Godot screenshot shows `D153 / SKELETAL STRINGS — PASS` and debugger error count 0: 32% linked marionette protection within 285px, out-of-range break, master-death instant break, multiplier cleanup, distinct skeleton roster/two deployments all pass. D153 original moonlit theatre card picture was shown rendering in Godot earlier. Next in repository: `scripts/battle/unit_animation_library.gd` now has STRICT role branches for `threadbare_puppeteer` and `bone_marionette` refusing absent, edge-cropped, repeated or partially empty 576x480 25-frame `.webp.b64` sprites. `scenes/dev/threadbare_theatre_art_preview.tscn` was added for five-state Godot art QA. **Actual D153 original 25-frame atlases have NOT been committed**; image concept boards are NOT game atlases, so do not ask user to run the gallery yet. After genuine original assets are committed and verified, use gallery F6, then original combat arena, real battle wiring, 54-case matrix, reward/table QA. **NOT LIVE**; Act1 still 35/45, only source/data/art-card + isolated tether logic available. Newest details in `docs/DECK_EXPANSION_D153_THREADBARE_THEATRE.md` and `docs/NEXT_CHAT_HANDOFF.md`. GitHub access is working; make changes directly; user should never manually unzip or edit code.


**LATEST D153 2026-10-15 — SKELETAL THEATRE QA PACKAGE IN MAIN:** User chose the **third** displayed moonlit ruined puppet-theatre concept and corrected the whole roster to **undead skeleton marionettes**, not wooden dolls. Exact selected 448×274 illustration is in GitHub `assets/pixel/card_unification_v1/run/threadbare_theatre_approved_v1.webp.b64`, verified against source after refetch. D153 has ORIGINAL `threadbare_puppeteer` + `bone_marionette` UnitData, authored two-formation EncounterData, QA-only RunCardData; local tether controller `scripts/battle/thread_tether.gd` protects linked puppets by 32% within 285px, restores protection on separation or master death. Only F6 **ART PREVIEW** `scenes/dev/threadbare_theatre_card_preview.tscn` and isolated **MECHANIC SMOKE** `scenes/dev/threadbare_theatre_smoke.tscn` are currently staged; **NATIVE GODOT PASS NOT YET RECEIVED**. Missing original 25-frame/role animations, actual theatre arena, production battle wiring & 54-case QA: D153 is **NOT live** and absent from both CARD_PATHS and ACT1_CARD_IDS; current Act1 stays **35/45**. User next only `git pull`, F6 these two D153 scenes and send screenshots. Other mechanics DS2/Fate Spread/12+XIII unchanged. Canonical `docs/DECK_EXPANSION_D153_THREADBARE_THEATRE.md` and `docs/DECISIONS.md` D169; do not resurrect abandoned ordinary wooden marionette concept. All GitHub changes owned by assistant.


**LATEST 2026-10-15 — D152 V2 NATIVE USER ACCEPTED; D153 VISUAL CONCEPTS FIRST:** User explicitly replied «все ок, погнали дальше» after F6 inspecting the approved scene-led 448×274 `defiled_laboratory_scene_v2.webp.b64` illustration. Mark D152 world-scene art native-accepted, live Act1 **35/45**, gameplay untouched. D153 is *only proposed*, NOT implemented and NOT in live deck. Proposed unique encounter: `Threadbare Theatre / Театр оборванных нитей` with genuinely original puppet master + wooden marionettes and candidate thread-link tactics (not finalized). Per D168 show **THREE distinct actual image concepts before user approval**: A frontal crimson stage, B oblique eerie backstage with hanging strings/shadows, C diagonal broken stage with severed strings. Image generation attempted in this conversation; don't assume selected or generated assets are stored in GitHub. Previous unrelated chapel/caravan generations were **rejected**, not viable D153 art. Do not implement D153 combat/commit artwork until user approves direction. For updates use GitHub connected writes directly; do not request permission or user-side code copying. Canonical `docs/NEXT_CHAT_HANDOFF.md` and `docs/DECISIONS.md` D143/D167/D168.


**LATEST 2026-10-15 — D152 APPROVED V2 IMAGE INSTALLED:** User approved the distinct environment-led laboratory illustration shown in chat. Exact authored **448×274** WebP is now in GitHub at `assets/pixel/card_unification_v1/run/defiled_laboratory_scene_v2.webp.b64`; `scripts/ui/card_unification_v1.gd` points to it. Its GitHub bytes match the original, and the old `run/defiled_laboratory.webp.b64` remains unchanged for rollback. Card 35/45, AI, animations, DS2 and 12+XIII unchanged. **User native F6 V2 art review still pending.** Only user action: `git pull`, F6 `scenes/dev/defiled_laboratory_card_preview.tscn`. **D168 mandatory new art workflow:** next time (D153+), create and SHOW 2–3 meaningfully different IMAGE concepts (default 3), await explicit user choice, and ONLY THEN commit the chosen art and switch runtime. This D152 image was already chosen by user, so no new variants required for it. Read `docs/NEXT_CHAT_HANDOFF.md` and `docs/DECISIONS.md` D167/D168. Connected GitHub edits remain assistant-owned.

**LATEST D167 / D152 ART CANDIDATE (2026-10-15):** Scene-driven encounter card art is NOW A MANDATORY USER-APPROVED RULE in this file and `docs/DECISIONS.md` D167. A new illustrated Gothic laboratory candidate with real environment/props/lighting and the original Alchemist + Homunculus was generated and locally downsampled to **448×274**, visually inspected, but **NOT uploaded to GitHub yet**: the Library container-path bridge returned `Container session expired`. The live D152 card (35/45) STILL loads the older blurred-sprite visual from `assets/pixel/card_unification_v1/run/defiled_laboratory.webp.b64`. Do not claim the new image is live or user-approved. Next objective: transfer versioned new art through connected GitHub without asking user for ZIP/PowerShell/manual edits; preserve old art for rollback, update loader, and obtain F6 native screenshot. `docs/NEXT_CHAT_HANDOFF.md` has details.\n\n
**POST-RELEASE NATIVE PREVIEW CONFIRMATION:** User provided Godot screenshot showing the now-live D152 card art preview opening without visible errors, with original 448x274 art, title, description, Act1 status and playtest button. This confirms the F6 preview, NOT randomized normal dealing. User-facing visual issue noted: the actual shipped card illustration looks like two character sprites over a blurred green background, not an environment-led painted alchemy laboratory. An optional original environment art polish has been proposed but NOT implemented/approved; respect DS2 and no embedded UI controls. Newest notes in `docs/NEXT_CHAT_HANDOFF.md`.\n\n**LATEST 2026-10-15 D152 RELEASE TO MAIN — LIVE ACT1 35/45:** `defiled_laboratory` is now the **35th nonboss Act1 card** in `scripts/core/run_state.gd::ACT1_CARD_IDS`. Original 448×274 card art is in `assets/pixel/card_unification_v1/run/defiled_laboratory.webp.b64`; original Plague Alchemist and Unstable Homunculus 25-frame atlases, two formations and local toxic zones remain unchanged. Godot screenshot of the **post-D152-balance F6 matrix** gave **54/54 technical PASS**, 54 wins/0 losses, solo/duo/trio avg surviving HP **70/57/60%**, casualties **0/4/4**, tactics ASSAULT/HUNT/FORMATION surviving HP **70/49/69%**, warning/hit/spill counts **73/512/108**, max combat **16.6s**. This justified a Tier1 playable release, NOT a final balance certificate. Previous user feedback accepted original card visual and dev win→reward→table. Release updated 35-card smoke guards and retired obsolete 33-/34-card assertions. **The new LIVE 35-card pool has NOT YET been rerun in native Godot since activation.** Next user action is only `git pull` and a normal Godot run or a quick relevant F6 scene; assistant must fix new errors directly in connected GitHub, no code copying/ZIP/PowerShell. Run still **12 cards + sealed XIII**. Next card target **36/45** (10 remaining) with D143 genuinely new enemies and art. Canonical detail: `docs/NEXT_CHAT_HANDOFF.md`, `docs/DECK_EXPANSION_D152_BALANCE_V1.md` and `docs/DECISIONS.md` D166. Older D152 text below describing 34/45 and art staged is historical.

**Latest canonical restart snapshot:** [`docs/NEXT_CHAT_HANDOFF.md`](docs/NEXT_CHAT_HANDOFF.md), with long-form context in [`docs/SESSION_HANDOFF_2026_10_15.md`](docs/SESSION_HANDOFF_2026_10_15.md) and verified native QA in [`docs/DECK_EXPANSION_D151_FINAL_SMOKE_QA.md`](docs/DECK_EXPANSION_D151_FINAL_SMOKE_QA.md). **LATEST 2026-10-15: D151 Funeral Procession is live card 34/45, user screenshot in Godot shows FINAL 54/54 PASS (54 wins/0 losses; 58 Last Rite warnings, 38 revivals, 14 buffs). Previously-freed target crash is no longer reproduced in latest F6 run; old crash/pending notes are historical.** Original D151 art/facing accepted. Smoke is **not** balance certification (100% wins) and **not** full fight→reward→table confirmation; those remain separate later QA. Preserve 12+XIII, D143 original enemy/art requirement for remaining 11 cards, DS2/Variant C, unresolved D142 tactics. GitHub access is connected: implement and commit yourself, do not ask again. This latest statement overrides older pending instructions in prior documents.

GitHub is the source of truth for the current technical state of Misdeal.

At the start of a new chat, before proposing architecture or code changes, read:

1. `AGENTS.md`
2. `docs/CONCEPT.md`
3. `docs/SESSION_CHECKPOINT.md` (short, current restart brief)
4. `docs/PROJECT_STATE.md`
5. `docs/ROADMAP.md`
6. `docs/DECISIONS.md`
7. `docs/HANDOFF.md`
8. `docs/VISUAL_ASSET_REGISTRY.md`
9. `docs/DESIGN_SYSTEM.md` (when working on UI or visual presentation)
10. `docs/UNIT_ANIMATION_PACK1.md` and `docs/UNIT_ANIMATION_PACK2.md` (when working on unit art or animation)

For implemented code and current project state, prefer GitHub over remembered chat context.

Do not ask the user to repeat information that is already captured in these files.

At the end of a meaningful development session, leave the repository in a state from which another fresh chat can continue without reading the full conversation history.

## Product

Misdeal is a dark-fantasy card-driven roguelike with a compact tactical autobattler.

The player sits across from an evil wizard who controls a cursed game table. Exploration is represented by cards. Combat encounters resolve as short tactical autobattles.

Core loop:

1. Reveal or choose a card.
2. Resolve an event.
3. If combat: inspect enemies and arrange the party.
4. Run a short autobattle.
5. Receive consequences and rewards.
6. Continue the run.

## MVP direction

Build the smallest playable vertical slice first:

- card/event flow;
- one combat encounter;
- 3 player units vs 3 enemies;
- pre-battle placement;
- automatic targeting, movement and attacks;
- win/lose state;
- reward screen;
- return to the table.

## Tech

- Godot 4.7.x
- GDScript only
- Prefer text-based `.gd`, `.tscn` and `.tres` resources.
- Avoid third-party addons unless explicitly approved.
- Keep systems data-driven with Godot Resources where practical.

Do not migrate to C#/.NET without an explicit project decision.

## Code rules

- Use typed GDScript where it improves clarity.
- Prefer small focused scripts over one large manager.
- Use signals for cross-system communication when appropriate.
- Avoid hard-coded content values when they belong in data resources.
- Keep file names, node names, class names, resources and code in English.
- Keep code comments concise and useful.
- Do not introduce networking, ECS, dependency injection frameworks, or premature abstractions.
- Optimize for a playable vertical slice, not hypothetical future scale.

## Working with the user

The user runs Godot locally and pulls changes through Git.

When the user explicitly asks to implement or fix something:

- inspect the current GitHub code first;
- when connected GitHub tools are available in the session, use them directly;
- do not claim GitHub write access is unavailable without first checking the connected repository/tool state;
- make the changes directly in the repository when possible;
- do not make the user manually copy code that can be committed;
- use meaningful commit messages;
- after the change, tell the user only what they need to do locally, normally `git pull`, run the project, and what to verify.

When an error is reported, inspect the current repository before suggesting manual edits.

## Documentation maintenance

After a substantial implementation:

- update `docs/PROJECT_STATE.md`;
- update `docs/ROADMAP.md` when priorities or completed milestones change;
- record important technical or game-design decisions in `docs/DECISIONS.md`;
- update `CHANGELOG.md`.

`docs/PROJECT_STATE.md` must describe what actually exists in the repository, not intended future behavior.

## Project structure

- `scenes/` — Godot scenes
- `scripts/` — gameplay code
- `resources/` — unit/card/item/encounter data
- `assets/` — art/audio/fonts
- `docs/` — game and technical notes

## Art direction

Dark-fantasy pixel art, cursed tabletop, theatrical evil wizard, tactile cards and readable tactical miniatures.

Combat readability comes before detail: units must be recognizable by silhouette, team color is secondary, and UI should not overpower sprites.

Use nearest-neighbor presentation for pixel assets. Avoid mixing realistic painted unit portraits into the combat field.

For UI work, extend the existing `scripts/ui/misdeal_ui_kit.gd` and follow `docs/DESIGN_SYSTEM.md`. Do not restyle approved game screens solely to unify components; validate against actual 1280×720 Godot screenshots.

The prototype may still use simple shapes and text where needed, but new player-facing art should move toward one coherent pixel-art language.

## Current priority

Make a playable vertical slice before polishing visuals.

Do not change the fundamental game design without discussing it with the user first.
