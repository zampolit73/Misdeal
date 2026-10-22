# D338 — Misdeal handoff (2026-10-22)

Read `AGENTS.md`, `docs/CONCEPT.md`, `docs/PROJECT_STATE.md`, `docs/ROADMAP.md`, `docs/DECISIONS.md` at next-chat start. GitHub `zampolit73/Misdeal` main is source of truth.

## Latest explicit user-approved artwork

**`bone_swarm` / «КОСТЯНОЙ РОЙ»**: user requested lots of variations because generic blue moon and castle rushes resembled other approved cards. Eventually two standalone illustrations were displayed, and the user explicitly chose **«2 вариант»**. It refers to **second of these LAST TWO images**, not any earlier numbered options. Exact local source: `/mnt/data/скелетный_рейд_в_туманном_болоте.png` (1536×1024, source attachment `file_000000001a848246bde220ade4d36923`). Visual: **four** skeleton bone raiders charging through shallow muddy swamp with water splashes and wooden planks; front center-left scarlet rag cloak wielding a curved blade, front right dark gray cloak, rear left spear skeleton, rear center hooded skeleton with flail; dim lamps, slate fog and warm amber glows. Different from the other first illustration's four more armored fighters under torches and gravestones. The user explicitly ordered «заливай в гит» — integrate directly, no more artwork selection.

Runtime WebP `assets/pixel/card_unification_v1/run/bone_swarm_d338_approved_option2.webp`, 448×274, Lanczos resized from crop (0,0,1536,939) of the approved original; top crop preserves hanging mace/weapon; SHA256 `6100162c8d1cab6e1a9d7131c0f856180fff3f36008e45c16755ab191eeb8592`. `scripts/ui/card_unification_v1.gd` mapped `RUN_CARDS["bone_swarm"]` to that precise image. `scripts/dev/d315_card_ds3_smoke.gd` enforces hash, decode, 448×274 and live catalog image consistency. Old `run/bone_swarm.webp` stays for rollback. `resources/cards/bone_swarm.tres`, `resources/encounters/bone_swarm.tres` (4 bone_raider enemies) and all gameplay, DS3 D328 art/text/frame untouched.

## Prior approvals frozen

D337 `gallows_volley` first wide wall/gallows concept, exact scene crop; D336 `graveyard_ambush` first two fighters + archer; D335 `bone_ritual` final third priest + 3 acolytes; D333 `bone_patrol` sparse lookout; D331 `blood_ledger` skeletal scribe and `bone_crush` breach variant 2; D319 `black_altar` third. Godot 4.7.x GDScript, 12 Fate slots + XIII boss, physical table 2 choices, compact tactical autobattler. All unchanged.

## Test and next tasks

Check actual native D315/D316 GitHub Actions/CI post D338; do not equate static verification with a Godot PASS. User: `git pull`, open `scenes/dev/d315_card_ds3_gallery.tscn` F6, inspect «КОСТЯНОЙ РОЙ». If successful, next choose ANOTHER unapproved card and show 2–3 actually visible visually distinct candidate illustrations before replacement; never replace previously approved illustration without explicit request. Favor meaningful different composition and locale, not repetitive 4 skeletons straight toward the viewer and large full moons.
