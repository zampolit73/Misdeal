# Misdeal — D336 new-chat handoff (2026-10-22)

Read **AGENTS.md**, **docs/CONCEPT.md**, **docs/PROJECT_STATE.md**, **docs/ROADMAP.md**, **docs/DECISIONS.md** first. GitHub `zampolit73/Misdeal` **main** is authoritative.

## What user just approved and what must ship

User chose #1 of the first shown "ЗАСАДА НА КЛАДБИЩЕ" image trio; they later corrected the assistant's redundant generated alternatives and **reattached the exact image** saying «мы уже утвердили этот арт». This approval is final. Original current-conversation source: file `file_00000000741082469e2501e8e688e34a`, `/mnt/data/image.png` (1604×981 RGBA). Visually: two front melee skeletons and **one real skeletal bowman drawn from elevated tomb on the RIGHT**, moon and twisted cemetery trees. No priests, altars, four melee combatants or banners. True 448×274 full-frame WebP exported from original PNG: `assets/pixel/card_unification_v1/run/graveyard_ambush_d336_approved_option1.webp`; exact SHA256 `834248781820752530662925c47569dd36ae67c0fdff115db0a9822f6b558ea3`.

Card ID `graveyard_ambush`, title «ЗАСАДА НА КЛАДБИЩЕ», existing tier-0 encounter with two fighters + bone archer. `scripts/ui/card_unification_v1.gd` RUN_CARDS override maps the exact image. `scripts/dev/d315_card_ds3_smoke.gd` now verifies SHA/decode/448×274/live image catalog. Legacy `run/graveyard_ambush.webp` remains tracked for rollback. **Never redo its art without explicit request.**

## Locked state from earlier work

- D335 approved Bone Ritual option 3 already live, source from original PNG, QA sha guard.
- D333 Bone Patrol sparse watchtower art; D331 Blood Ledger bone scribe and Bone Crush option 2 gate breach; D319 Black Altar #3. All mapped and approved. Known old thumbnail-derived binary quality in D331/D333, do not reconceptualize.
- Card DS3 D328 single ornate frame, true original art colors, optically centered labels, remains frozen. Two live table offers, 12+XIII Fate spread, compact tactical autobattler, no code/mechanics changes.
- Art language: restrained scene-first pixel-painterly dark fantasy, cold blue moonlight, one intentional warm accent, large legible silhouettes, minimal meaningless candles/ornament, one clear story per card.
- Real engine is Godot 4.7.x GDScript. GitHub connector works; do not ask for permission or code copy.
- D168 rule: future *unapproved* card illustrations require 2–3 **actually shown** distinct images in chat, then exact selected image committed directly to GitHub. No new selection is needed for previously approved cards.

## Next

After D336 commit: inspect new GitHub native Godot D315/D316 CI; do not claim PASS until checked. User: `git pull`, F6 `scenes/dev/d315_card_ds3_gallery.tscn`, check “ЗАСАДА НА КЛАДБИЩЕ”. If correct, next unapproved card artwork options, shown clearly to user, no extra variations for locked ones. If native CI issues appear, repair from GitHub and update docs/log. The assistant must ensure the selected #1 image is used in actual game, not any later generated alternatives.
