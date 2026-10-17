# Misdeal Documentation Index
Updated 2026-10-18 — **D238 restored batch-first complete 25-frame unit animations**; current sprite task: one full rich Road Sentinel pack. No new complete pack has been produced yet; #38 stays QA-only, Act1 LIVE 37/45.

**LATEST D239 actual QA deliverable:** [Complete 25-cell Sentinel atlas and one full F6](D239_SENTINEL_FULL25_QA.md). Native artistic QA pending; no #38 release. 

**READ THIS FIRST FOR A NEW CHAT:** [D238 — complete current continuation checkpoint](D238_BATCH_ANIMATION_NEXT_CHAT.md). **One 25-frame character atlas per work batch; only ONE full Godot F6 visual review per character**, no approval requests for individual idle/walk/attack/hit/death. Permanent rule: [AGENTS.md](../AGENTS.md); design lock: [DECISIONS.md](DECISIONS.md); exact latest state: [HANDOFF.md](HANDOFF.md).

**LOCKED Road Sentinel art/animation:** [D234 — free-hand grip](D234_SENTINEL_HAND_LANTERN_ATTACHMENT_QA.md) user accepted; [D235 — rich long-SPEAR design](D235_SENTINEL_WALK_ART_APPROVAL.md) user approved; [D236R — six-phase walk](D236R_SENTINEL_GAIT_REPAIR_QA.md) user says «пойдет». D236 gait was rejected. D229 procedural library sprite is only a technical temporary for **unreleased** #38 and NOT final accepted art.

**#38 Black Lantern Road release:** five DISTINCT skeletal original units and accepted D209 moonlit forest; actual cast/combat/light/reward/balance/full-pool QA pending. Do not touch live 37-card pool or immutable [КАРАМБА73 checkpoint](checkpoints/KARAMBA73_2026-10-16.md). Main art reference/release contract: [D220 final sprite gate](D220_BLACK_LANTERN_FINAL_SPRITE_REPLACEMENT_GATE.md).

## Read first (current, short, authoritative)

1. [Development rules](../AGENTS.md) — project goals, GitHub workflow, engine, art gates.
2. [Concept](CONCEPT.md) — high-level design pillars and Fate Spread.
3. [Current Project State](PROJECT_STATE.md) — **what is implemented now**; live Act1 37/45; both D197 real Battle→Reward→Table and D198 ordinary-deal native release smoke user-reported PASS; next card #38.
4. [Roadmap](ROADMAP.md) — completed milestones and next priorities.
5. [Active Decisions](DECISIONS.md) — binding summarized requirements and links to original decisions.
6. [Canonical Handoff](HANDOFF.md) — only one active next-chat continuation pointer.

## Fixed project backups

- [КАРАМБА73 — full GitHub-tracked project checkpoint and safe restoration procedure](checkpoints/KARAMBA73_2026-10-16.md) — restore trigger, exact project status and immutable-branch policy.

## Specialist references

- [Design System](DESIGN_SYSTEM.md) — DS2/Variant C and historic UI patterns.
- [Visual Asset Registry](VISUAL_ASSET_REGISTRY.md) — accepted image paths and legacy inventory.
- [D153 encounter specification](DECK_EXPANSION_D153_THREADBARE_THEATRE.md).
- [Black Crossing #37 encounter, battle QA and release gates](D188_BLACK_CROSSING_ENCOUNTER.md).
- [D199 approved card #38: Road of Black Lanterns concept, five skeletons and production gates](DECK_EXPANSION_D199_BLACK_LANTERN_ROAD.md).
- [D219 Lantern Archer original bow animation F6 QA](D219_LANTERN_ARCHER_ANIMATION_QA.md) — current fifth-role gate, native Godot pending.\n- [D218 Extinguished Guide original 25-frame art / towering visual native F6](D218_EXTINGUISHED_GUIDE_ANIMATION_QA.md) — current QA stage; guide 1.8x vs bearer 1x, not combat live.
- [D217 Oil Acolyte original SVG animation QA and local raster source review](D217_OIL_ACOLYTE_ANIMATION_QA.md) — new Godot F6 gallery; not production art.
- [D216 original Lantern Bearer 25-pose atlas & isolated F6 gallery](D216_LANTERN_BEARER_ANIMATION_QA.md) — **current QA gate**; not live battle sprites.
- [D215 original spear Sentinel animation candidate and F6 gallery](D215_SENTINEL_NATIVE_ANIMATION_QA.md) — user-reported isolated F6 gallery OK, not live art.
- [D213 canonical five-skeleton animation master production brief](D213_BLACK_LANTERN_MASTER_ANIMATION_BRIEF.md) — **correct 6×5 Godot state-row layout, supersedes chat D212/D213 row-major layout**.
- [D214 Lantern Bearer art production specification](D214_LANTERN_BEARER_PRODUCTION_SPEC.md) — 25 original cel descriptions, shield/lamp identity, pixel QA; awaiting production sprites.
- [D211 long-spear Road Sentinel two illustration concepts](D211_ROAD_SENTINEL_SPEAR_CONCEPT_OPTIONS.md) — **user selected option A**, not yet animated sprites.
- [D210 five skeletal animation source QC and acceptance requirements](D210_BLACK_LANTERN_ANIMATION_ART_QA.md) — current #38 art stage.
- [D209 approved original forest scene and native lanternlight/footprint QA](D209_BLACK_LANTERN_ARENA_NATIVE_QA.md) — native composition F6 approved.
- [D208 54-case baseline and local lanternlight balance candidate](D208_BLACK_LANTERN_BALANCE_PASS.md) — historical D208 simulation comparison, both native functional PASS.
- [D207 54-case native BattleUnit matrix](D207_BLACK_LANTERN_BATTLE_MATRIX.md) — historical D207 native 54/54 functional PASS.
- [D206 staged encounter resources, isolated lanternlight and native contract smoke](D206_BLACK_LANTERN_ENCOUNTER_STAGING.md) — historical D206 isolated contract PASS.
- [D205 selected forest arena, sprite concept QA, and light preview](D205_BLACK_LANTERN_ASSET_AND_LIGHT_STAGING.md) — earlier art stage notes; D209 arena F6 already approved.
- [D153 D176 balance/QA](D153_BALANCE_D176.md).
- `UNIT_ANIMATION_PACK1.md`, `UNIT_ANIMATION_PACK2.md` — sprite frame contracts, where relevant.
- `NEXT_CHAT_HANDOFF.md`, `SESSION_CHECKPOINT.md`, `D153_NEXT_CHAT_START.md` — intentionally short compatibility pointers to canonical `HANDOFF.md`.

## Immutable pre-cleanup history

[Archive index](archive/2026-10-15-pre-cleanup/README.md) contains **12 original complete files unchanged**, including the long dated audit/handoffs and all historic D001–D178 decisions. Current working documents supersede obsolete status text in archived records; older accepted design requirements remain valid unless explicitly overridden.

## Maintenance convention

**One status update per session**, rather than pasting the same status paragraphs into six unrelated files:
- `PROJECT_STATE.md`: facts actually in `main`, observed/native QA results and unresolved gates.
- `ROADMAP.md`: next milestones/priority and checkbox state only.
- `DECISIONS.md`: important new decisions (and link to archive for existing rules).
- `CHANGELOG.md`: concise committed change summary.
- `HANDOFF.md`: exactly one updated next-step brief.
- `AGENTS.md`: permanent development/art rules **only**.
Retain commit history and add a dated archive when a working file again accumulates too much obsolete session narration.
