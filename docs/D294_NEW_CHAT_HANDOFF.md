# D294 — Misdeal: new chat handoff (2026-10-20)

**Read this first** when resuming. Source of truth: [zampolit73/Misdeal main](https://github.com/zampolit73/Misdeal). Last verified source HEAD before this handoff: `da3a28540d94b1c027a2ff0b7c3062026a2a5023`. This documentation commit will be newer.

## Current state — no guessing

D293 Battle DS3 **is implemented in main and official Godot 4.7.2 native test PASS**: [Actions 39399922113](https://github.com/zampolit73/Misdeal/actions/runs/39399922113). **USER HAS NOT YET VISUALLY ACCEPTED D293.** The user explicitly rejected the previous D292 screenshot of the "ЗАСАДА НА КЛАДБИЩЕ" battle as "не очень( ты же хотел под DS3 сделать": it was merely flat black boxes with tinted frames, not a designed DS3. D293 is a materially new physical-UI pass that has NOT yet been seen in a user screenshot.

**Next step (before any further implementation):** User performs `git pull`, opens a real battle in Godot, sends a new preparation screenshot. Critique D293 visually and fix any observed problems in GitHub. Specifically check whether inset panels obscure existing live labels (late-added Godot Controls can draw over older siblings even if mouse_filter is IGNORE), whether tactical controls are clickable/legible, primary ruby Fight seal, clipped copy, arena/actor feet and HP, and selected states. Do not move to rewards/shop until D293 actually approved.

## Technical files and exact rollback

- D293 runtime pass: `scripts/battle/battle_ds3_pass.gd`; production integration: `scripts/battle/battle.gd`. Only cosmetic Battle UI, no arena, actor, AI, placement or RunState changes.
- Test: `scripts/dev/d291_battle_ds3_smoke.gd`; workflow `.github/workflows/d291-battle-ds3.yml`. Final D293 CI PASS as above (the earlier D293 red run had a stale test expecting old border thickness; smoke was updated).
- Key D293 commits: `ee424e6` command tray, `0883274` art/selection smoke, `06d4e49` upper engraved ledgers, `e9b49be` and `da3a285` docs.
- Source decoration reused from **approved D287 Dossier**: `assets/pixel/ui/squad_dossier_d287/gilt_corner.webp`, `ruby_crest.webp`. D293 introduces real blackened wood/copper command tray, tactical inset holders/scroll, stateful selection tokens, lacquered crimson Fight control with ruby crest and engraved title/progress fields. All original click actions, 3 initial/5 possible tactics, card data and game mechanics remain live Godot nodes.
- **Immutable DS2 full-project backup branch:** `checkpoint/ds2-pre-ds3-2026-10-20` at SHA `4cbd206cc3739355a9d375a0752a6a840e35caa2`; verified unchanged. [Restoration instructions](DS2_CHECKPOINT.md). Do NOT force-reset shared main; selectively revert DS3 changes if necessary.

## Established project and design decisions

- Godot **4.7.x + GDScript**, GitHub directly for implementation. Talk to user in Russian. Favor playable vertical slice, data-driven Godot resources, correct source state over chat assumptions. Read `AGENTS.md`, `docs/CONCEPT.md`, `docs/PROJECT_STATE.md`, `docs/ROADMAP.md`, `docs/DECISIONS.md`, `docs/HANDOFF.md`, `docs/DS3_FOUNDATION.md`.
- Misdeal: cursed dark-fantasy tabletop, evil Wizard host and compact **tactical autobattler**. There are exactly **two normal offered cards**, 12 Fate Spread resolutions + XIII Bone Warden. Never adopt 3-card deal, manual skills, turn order or invented effects from exploratory DS3 mockups.
- DS3 develops established DS2 colors (obsidian `#100C0D`, crimson `#62201E`, bronze `#A66636`, parchment `#DFB77E`, moonlit steel `#334758`). DS3 must look like **crafted objects belonging to the cursed table**, not flat black boxes with thin orange outlines or busy AI decorations. Live values are always Godot Controls, not painted graphics.
- D283 approved **Bone Ritual**: moonlit cathedral, sparse bones; `assets/pixel/battle/arenas/approved_d283/bone_ritual.webp`. D283 approved **Firing Square**: first execution-yard variant; `assets/pixel/battle/arenas/approved_d283/firing_square.webp`. D284 **Grave Crossfire stays unchanged**, all other previously accepted arenas remain unchanged.
- D285–D287 user selected **third hybrid Squad Dossier design** (full-height class portraits, true stats, bronze ornament and ruby crest). Approved D287 fragments in `assets/pixel/ui/squad_dossier_d287/`.
- D289–D290 DS3 real Table work: `scripts/table/table_ds3_pass.gd`, 2 original painted cards and Wizard remain. User screenshot of D290 shows single real `КОЛОДА 37` (stale painted 22 masked), clean headers. Table is the stable DS3 pilot.
- D291–D292 Battle HUD technical tests passed but user **REJECTED its appearance**. Do not interpret its old passing CI as art acceptance. D293 replaces its styling materially. Full source and decisions in [D291 pilot notes](D291_DS3_BATTLE_PILOT.md), [DS3 foundation](DS3_FOUNDATION.md) and the first entries of ROADMAP/DECISIONS.
- User prefers fewer AI-looking art details, good composition, real battlefield floor and readable units, multiple actual art choices before replacing **approved art**, full 25-frame animation batch for new approved units rather than individual approvals, direct GitHub commits and concise local check instructions. Do not introduce unapproved Act 1 narrative/gameplay changes while working on DS3.

## Handoff boundary

The user explicitly said: "Сохрани весь контекст и пошли в новый чат". All D293 source/CI status is recorded. The next chat **must begin with the real D293 screenshot review, not another speculative refactor**. After visual approval, update `PROJECT_STATE`, `ROADMAP`, `DECISIONS`, `HANDOFF`, `CHANGELOG`, and then consider another DS3 screen.

New-chat prompt: **"Продолжаем Misdeal с D294. Прочитай docs/D294_NEW_CHAT_HANDOFF.md и актуальные документы в GitHub. D293 уже в main, CI PASS, ждём визуальную проверку в Godot. Начни с этого места."**
