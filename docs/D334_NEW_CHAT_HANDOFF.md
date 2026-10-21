# Misdeal — D334 new-chat handoff (2026-10-21)

> **CURRENT / START HERE.** One-session authoritative handoff compiled after D333 native release. GitHub `zampolit73/Misdeal`, branch `main`, is the source of truth for actual code/assets. New chat MUST still read `AGENTS.md`, `docs/CONCEPT.md`, `docs/PROJECT_STATE.md`, `docs/ROADMAP.md`, `docs/DECISIONS.md`; then this file and `docs/DESIGN_SYSTEM.md` / `docs/VISUAL_ASSET_REGISTRY.md`.

## Exact checkpoint and user instruction

User's last request: **«давай весь контекс сохранишь. и начнем новый чат»**. Current task is NOT another approval or feature. All work through D333 is shipped, logged and native QA green. The next session should **continue the art-consistency initiative with the card `bone_ritual` («КОСТЯНОЙ РИТУАЛ»)**. First deliver THREE actually rendered, distinct, visually accessible standalone clean scene choices, and WAIT for the user's choice (D168); do not claim three samples are displayed until images are indeed present in the chat. User dislikes placeholder descriptions, missing previews, AI-art clutter, redundant ornament, excessive candles and illogical fortress detail. No automatic changes to card combat or to the already accepted DS3 layout.

## Technical and gameplay ground rules

- Engine **Godot 4.7.x**, GDScript, direct GitHub integration available through connected GitHub tools. **Never ask user to reconnect GitHub**, manually copy scripts, or repeatedly approve established visual choices.
- Misdeal: dark-fantasy cursed card-table roguelike, evil wizard as host/antagonist, compact tactical autobattler, data-driven resources. The table is the adventure; the Fate Spread is **12 resolutions I–XII and sealed XIII Bone Warden**; deal interface has **two live offers** (don't introduce three-offer mechanics via artwork).
- First act themes: abandoned castle and undead, mystery linking hero to castle; important story decisions belong to original design docs and user approvals. Do not alter fundamentals without discussion.
- D167 scene-first card art: convincing dark-fantasy place/action with readable silhouettes, grounded architecture/props, restrained details; no pasted-up character showcase, no decorative filler, no candles everywhere, no baked fonts/frame.
- D168 visual approval protocol: show 2–3 (prefer 3) **actual images** with meaningful composition differences BEFORE replacing any unapproved card art; commit exactly selected image to GitHub as a 448×274 standalone WebP runtime art override; preserve old fallback and update state/roadmap/changelog/decisions/handoff.
- User prefers batch execution and meaningful commits, minimal micro-approvals. Native QA and source image completeness before saying done. The six DARK FORGE ZIP skills were provided to this project; use relevant installed skills if available, but project `AGENTS.md` and actual GitHub code remain authoritative.

## Approved and FROZEN Card DS3 appearance (D319–D328)

- Card physical single ornate Gothic front frame, no double outline, inset artwork fully visible without cropping or over-darkening; neutral seamless matte; title, two-line description and CTA optically centered.
- D327 actual painted-frame optical axes: Table/gallery 272×338 copy x=147, top category tab x=150 (type inside plaque), 292×410 Reward text x=158, Fate Roman number separate and visible. User approved as D328 («утверждаю»). **Do not unilaterally redesign DS3.**
- Gallery is `scenes/dev/d315_card_ds3_gallery.tscn` (F6), 40 Run cards plus 15 other illustrations, genuine narrative via full-text reader, all original card mechanics untouched.
- Relevant code: `scripts/ui/card_ds3_skin.gd`, `scripts/ui/card_unification_v1.gd`, `scripts/ui/card_art_catalog.gd`, `scripts/dev/d315_card_ds3_gallery.gd`, `scripts/dev/d315_card_ds3_smoke.gd`, `scripts/dev/d316_card_surfaces_smoke.gd`.
- D332 fixed pre-existing Reward `BloodCoin` clipping: after DS3 sets CENTERED portrait, live reward/upgrade refresh must NOT override it back to COVERED. Code commit `08085a815fe6957a8781bba1a235298fcd178ca7`.
- Native Godot action for D315 + D316 **SUCCESS** [run 39662338488](https://github.com/zampolit73/Misdeal/actions/runs/39662338488). Earlier [run 39658979922](https://github.com/zampolit73/Misdeal/actions/runs/39658979922) also successful after Reward crop repair. This is verified automated QA, not a claim that every artistic decision has been visually checked after future changes.

## Selected illustrations, shipped and regression-checked

| Card ID / visible label | Exact selected composition | Runtime file (under `assets/pixel/card_unification_v1/run/`) | Last acceptance |
|---|---|---|---|
| `black_altar` — «ЧЁРНЫЙ АЛТАРЬ» | D319 **option 3**, already locked | `black_altar_d319_option3.webp` | Native contract and approved art |
| `blood_ledger` — «КРОВАВАЯ КНИГА» | Final edited **bone scribe** at bloody ledger, with restrained candles, banners and setting; not a new drawing | `blood_ledger_d331_approved_scribe.webp` | User selected final |
| `bone_crush` — «КОСТЯНАЯ ДАВКА» | Option 2 **«Прорыв ворот»**: skeleton assault breaking castle barricade; *middle* of approved concept triptych | `bone_crush_d331_approved_option2.webp` | User selected 2 |
| `bone_patrol` — «КОСТЯНОЙ ДОЗОР» | D333 option 3 watchtower, then user-directed EDIT removing implausible busy mid-ground fortifications/bridges; final shows skeleton with torn crimson banner on rough wooden lookout at left, moonlit gothic fortress right, simpler foggy forest valley between | `bone_patrol_d333_approved_tower.webp` | User: «отлично. утверждаем его» |

All four are mapped via `CardUnificationV1.RUN_CARDS`. `bone_patrol` published in [D333 asset import successful](https://github.com/zampolit73/Misdeal/actions/runs/39662185041), commit `25eff5c5e414c491bfa777f93d2f934d97d15548`; D315 extra individual-art assertions commit `794ab14070f8a30f7065bf4a8513577b9cd96409`. Last D333 one-time importer/workflow removed in commit `064802328568d4d23aa9ac75303a5b2fe70f173e`. D331 `blood_ledger` and `bone_crush` published commit `cb03e65ed8c28e9b9b93812a264c2072deda4e15`.

**Important fidelity caveat:** each of D331/D333 runtime WebPs is a valid **448×274 image**, but those binaries were produced via Canva signed **~200px preview** upscaling because full-resolution binary passthrough was not available to GitHub connectors. User saw D331 cards in live Godot and said «они появились» and «хорошо» (acceptable for now). The **high-quality approved original compositions** exist as past chat/source files, and should be substituted *only using the same exact artwork* when a safe binary bridge becomes available; do not silently replace with generic AI images. D333 final original `file_0000000084148246b7d6f138f8600dee`, local historical filename `a_dramatic_dark_fantasy_night_scene_a_cinematic.png` 1604×981, source pre-game WebP example `d333_bone_patrol_q50.webp`; D331 original references and crop coords in `docs/VISUAL_ASSET_REGISTRY.md`.

## NEXT — Bone Ritual / «КОСТЯНОЙ РИТУАЛ»

- `resources/cards/bone_ritual.tres` already exists. ID `bone_ritual`, `type_label = "БОЙ"`, combat tier 2, `resolution_type = "combat"`, original `target_path = "res://resources/encounters/bone_ritual.tres"`. Existing fallback art path: `res://assets/pixel/ui/combat_expansion_v1/cards/bone_ritual_card.webp`. **Do not change enemies, AI or balance when merely changing illustration.**
- Artwork new options are NOT approved and no catalog override for `bone_ritual` has been shipped.
- Intended 3 clearly distinct **SCENE** concepts (not the same image with different color): 1 **«Воззвание»**, skeletal priest/necromancer at an altar raising undead, 2 **«Жертва»**, close ritual sacrifice with a bloodied relic before kneeling armored skeletons, 3 **«Круг»**, wide moonlit ruined-courtyard ritual ring with clustered undead sorcerers. Strong atmosphere, readable at 448×274, grounded skeleton anatomy, much fewer repetitive AI details and ritual symbols, no text/card frame.
- **Correction to old D333 notes:** prior `docs/HANDOFF.md` / `docs/PROJECT_STATE.md` stated a finished ritual triptych was displayed, referring to image `file_000000002c888246b968180b5e2f339c`. This image/path **could not be verified in the available runtime or current user-visible turn**, and the last visible assistant action was only a **promise to create three ritual concepts**. Treat any earlier claim of delivered viewable options as **UNVERIFIED**. At the start of the new chat, **actually render and display the three ritual options anew** so the user can choose; do not ask them to pick unseen images. Never confuse the existing `a_dark_cinematic_gothic_fantasy_triptych_three_p.png` (that is Bone Patrol, NOT Bone Ritual) with a ritual triptych.
- Upon explicit selection: crop/export exact composition to runtime 448×274, publish binary to GitHub under `assets/pixel/card_unification_v1/run/bone_ritual_d###_approved.webp`, add exact `RUN_CARDS["bone_ritual"]` override; add native D315 catalog-size/image check; run native GitHub Actions and verify pass; update registry, state, roadmap, decisions and changelog. Keep D328 DS3 frozen.
- User expressly asked to carry **all context into a new chat**. No user-side source-editing or permission prompts; next assistant should progress on real images immediately.

## What was done in D334 handoff-only session

- No game code, image or UX modified. Authoritative `main` and successful [D333 native QA](https://github.com/zampolit73/Misdeal/actions/runs/39662338488) verified.
- Created this handoff and linked it from `docs/INDEX.md`; synchronized `docs/PROJECT_STATE.md`, `docs/ROADMAP.md`, `docs/DECISIONS.md`, `docs/HANDOFF.md`, `docs/VISUAL_ASSET_REGISTRY.md`, and `CHANGELOG.md`.
- Next chat simply begins with: **«Продолжаем Misdeal с D334. Прочитай docs/D334_NEW_CHAT_HANDOFF.md и актуальные проектные документы в GitHub. Покажи три реально отрисованных варианта карты „Костяной ритуал“ для выбора, затем внедри утверждённый арт прямо в GitHub. Не меняй утверждённую DS3.»**
