# Misdeal — D335 new-chat handoff (2026-10-22)

**Authoritative:** main GitHub `zampolit73/Misdeal`. Read AGENTS.md, CONCEPT, PROJECT_STATE, ROADMAP, DECISIONS and this file at new-chat start. Earlier D334 is superseded.

## Current accepted work

D335: user chose third *newer, pixelated* Bone Ritual candidate. Selected illustration: skeleton necromancer stands in center with staff and raised palm; 3 kneeling skeletons in courtyard; lonely fire at left, blue moonlit castle on right. Original artifact ID `file_000000008e1c82468d5abc5d04c95cfa`, 1604×981 `лунный_ритуал_некроманта_в_руинах.png`. Game runtime full-original-resized `assets/pixel/card_unification_v1/run/bone_ritual_d335_approved_option3.webp` 448×274, SHA256 `2ba5743f2a49a961e6fa05e663fafe7359838c1c9b53e608fb63bf7eea04ac93`. This is the **approved third image**, NOT prior old draft art/first or second candidate. D315 smoke binds exact image to `bone_ritual` through `CardUnificationV1.RUN_CARDS`, with SHA/decode/pixel assertion. Do not seek another vote or regenerate it.

D333 Bone Patrol approved edited sparse-watchtower concept; D331 Blood Ledger approved skeletal scribe, Bone Crush option 2 gate assault; D319 Black Altar #3. All shipped, remain unchanged. Card DS3 D328 frame/colors/optical text center are FROZEN. User favors coherent cold-blue moonlight vs a few warm crimson/orange accents, painterly 2D/pixel edge, uncluttered purposeful scene props and no fake IA ritual decoration. Existing old ~200px runtime thumbs for D331/D333 are a documented fidelity issue; D335 uses actual source artwork via GitHub binary blob.

Godot 4.7.x + GDScript. The game is two-offer cursed tabletop, 12 Fate + sealed XIII, solo/duo/trio, compact tactical autobattler. Do not change fundamental gameplay. For new unapproved RunCard art always show 2–3 **rendered actual images**, get user choice, then commit exact chosen art. Future art list in ROADMAP; do not assume all 55 paintings have been remade.

## Immediate validation

GitHub commit D335 includes exact game WebP, mapping, native regression and doc updates. **Verify GitHub Actions D315/D316** and if green record it; no claim of native PASS until observed. User action: `git pull`, run F6 `scenes/dev/d315_card_ds3_gallery.tscn`, check «КОСТЯНОЙ РИТУАЛ». If imagery shows wrong/cropped/low-res, inspect the actual source/catalog first and fix directly in GitHub. Next approved art batch must preserve this series' restraint and avoid unnecessary extra candles/banners/moons or repetitious ritual symbols.
