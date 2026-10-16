# Misdeal Documentation Index
Updated 2026-10-16 — D205 forest arena #3 selected; dev-only light F6 scene committed; five skeletal atlases art-QA blocked; live Act1 37/45.

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
- [D205 selected forest arena, sprite concept QA, and light preview](D205_BLACK_LANTERN_ASSET_AND_LIGHT_STAGING.md) — current card #38 gate; exact F6 scene and asset blockers.
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
