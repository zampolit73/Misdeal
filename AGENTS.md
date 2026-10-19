# MISDEAL — Development Guide

## Source of truth and start of a new chat

Repository: `zampolit73/Misdeal`, branch `main`. **GitHub is the technical source of truth** for implemented features; user feedback and project chat supply visual/design decisions. Do not ask for access without checking connected GitHub tools.

Read in order: `AGENTS.md`, `docs/CONCEPT.md`, `docs/PROJECT_STATE.md`, `docs/ROADMAP.md`, `docs/DECISIONS.md`; consult `docs/HANDOFF.md` for exactly what happens next and `docs/INDEX.md` for navigation. When working on UI or visuals, read `docs/DESIGN_SYSTEM.md` and `docs/VISUAL_ASSET_REGISTRY.md`. Animation details live in `docs/UNIT_ANIMATION_PACK1.md`, `docs/UNIT_ANIMATION_PACK2.md`, and the D153-specific notes.

**Do not embed dated session history inside AGENTS.md.** Its historical pre-cleanup version is preserved at `docs/archive/2026-10-15-pre-cleanup/AGENTS.md`. The current project-specific status belongs in `docs/PROJECT_STATE.md`, not here.

## Product and gameplay constraints

Misdeal is a dark-fantasy card-driven roguelike with an evil wizard presiding over a cursed table and a compact tactical autobattler. The Fate Spread has exactly **12 resolutions (I–XII)** plus the sealed Bone Warden **XIII**. Parties may be solo, duo or trio; do not change the fundamental design without consulting the user. Priority: a playable vertical slice, not speculative architecture. New fight-bearing Act 1 cards require **genuinely new enemies** with original identities, combat sprites and a meaningful mechanic (D143).

## Technical workflow

- Godot **4.7.x**, **GDScript**. No C#/.NET migration, heavyweight frameworks, global rewrites or third-party dependencies without approval.
- Prefer typed, focused GDScript; data-driven `.gd`, `.tscn`, `.tres` and Resource contracts. Use English for file/node/class/resource names and code, Russian for conversations and game UI as applicable.
- On a bug, **inspect live GitHub code before fixing**. When the user requests implementation, make the change directly through connected GitHub, use a meaningful commit, and request only `git pull` and the specific Godot test.
- **GitHub is the default implementation path.** Use the connected GitHub actions first, even if the local container has no repository checkout or outbound network. A failed terminal `git clone`/`git ls-remote` does NOT imply that GitHub access is unavailable. Do not ask the user to reattach GitHub or upload source files before actually checking connected GitHub actions. Never promise perpetual access; report a connector-specific failure only after testing it.
- Preserve existing working combat flows, progression and DS2 while touching individual encounters. Treat native Godot user screenshots as evidence; never claim runtime PASS from static review alone.
- After meaningful work update `docs/PROJECT_STATE.md`, `docs/ROADMAP.md` when needed, `docs/DECISIONS.md` for new locked decisions, `CHANGELOG.md` and `docs/HANDOFF.md`. Keep current documents short; put lengthy historical notes in dated archives.

## Locked visual rules

- **D167 scene-first:** every card illustration portrays a convincing dark-fantasy place/event, not isolated sprites over a generic background; lighting, scale, contact, purposeful props and atmosphere must fit. Avoid repetitive generated artifacts and meaningless tiny decoration. Art bitmaps have **no baked UI/text**.
- **D168 options-first:** show **2–3 actually rendered and meaningfully distinct options (prefer 3)** before replacing card artwork. Wait for user selection, then integrate **exactly the approved image** into GitHub; preserve rollback history. Do not demand ZIPs/manual transfers.
- Combat unit sprites must match the accepted Misdeal small-scale pixel language, readable silhouettes, leg contact and correct facing. Card art and in-battle sprites are different media serving the same world.

### Batch-first character animation production (user instruction, 2026-10-18)

- **For approved character visuals, deliver the COMPLETE game-ready sprite animation set IN ONE WORK BATCH**, not one user approval per idle/walk/attack/hit/death. Existing per-unit contract: **25 genuinely distinct authored poses = idle4 + walk6 + attack6 + hit3 + death6**, packed 6 columns × 5 rows of 96×96 (576×480), five unused cells truly alpha-clear, unless a different contract is explicitly approved.
- **Do internal checkpoints yourself**: character consistency, silhouette/weapon identity, visible real hand-to-prop grip, planted soles, correct facing, motion at 1×, frame uniqueness, cell margins, Godot asset-format checks. Iterate internally without requesting user screenshots for each few frames. Preserve approved D234 lantern grip, D235 richer Style B Sentinel, D236R acceptable gait; do not use simplified D229 look as final.
- **User-facing review: ONE complete 25-frame character pack with actual Godot F6 preview**, then fix issues they report directly in GitHub. A technically passing atlas is not necessarily artistically acceptable: avoid fake infographic grids, repeated frames, poor background extraction, or claiming a procedural placeholder is beautiful final artwork.
- **No repeated micro-approval gates.** Only pause to ask the user when a materially new visual direction or fundamental gameplay/format change needs their choice, or when the finished full pack hits a concrete blocker. D168 multi-option art approval still applies to **new card illustration choices**, not to animation stages for an already-approved enemy design.
- Do not release incomplete sprite roles into live encounters: build and test in QA first, preserve old assets for rollback, and ship #38 only after the finished five-role cast and actual Battle→Reward→Table/matrix QA.
- **DS2 / Fate Spread Variant C** is the accepted interface aesthetic. Godot owns layout/text/chrome. Check native 1280×720 visuals and `docs/DESIGN_SYSTEM.md`; extend `scripts/ui/misdeal_ui_kit.gd` instead of rewriting styles globally.

## Project layout

`scripts/` gameplay logic; `scenes/` Godot scenes; `resources/` cards, units, encounters, upgrades, artifacts; `assets/` tracked runtime image packages and source/rollback images; `docs/` active and historical specifications. Generated `assets/*.webp.b64` and encoded chunks are intentionally text-backed for asset loading and **must not be bulk-deleted as apparent duplicates**.

Current priority and release gates: see `docs/HANDOFF.md`, never old copied D153 "pending" notes.
