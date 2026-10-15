# Misdeal — D153 animation checkpoint (2026-10-15)

**Repository:** `zampolit73/Misdeal`, branch `main`. Continue the project from GitHub, without re-asking access or asking the user to transfer art/code. This document **supersedes historical entries elsewhere saying D153 atlases are missing**.

## Already confirmed by native Godot screenshots
- The user-selected third ruined **skeletal** theatre card illustration renders in the 448×274 QA preview.
- `res://scenes/dev/threadbare_theatre_smoke.tscn` shows **D153 / SKELETAL STRINGS — PASS** with 0 errors: unique skeleton roster/two formations, 32% protection within 285px, break/reconnect, master-death break and cleanup. This was isolated mechanics QA, not a production battle.

## D153 animation work now in GitHub
- `assets/pixel/units/deck_expansion_v1/threadbare_puppeteer_frames.webp.b64`: original crowned bone puppeteer with marionette rig, moving limbs/crossbar and thread-whip.
- `assets/pixel/units/deck_expansion_v1/bone_marionette_frames.webp.b64`: original jointed undead skeleton in worn crimson theatre costume, shoulder strings and bone-claw attacks.
- Both are **genuine raster** lossless WebP (576×480, 6×5, 96px cells); **25 different rendered poses per role**, idle 4 / walk 6 / attack 6 / hit 3 / death 6. No substitutes/repeats.
- Alpha/full-frame/uniqueness/unused-cell checks passed after WebP decoding. Actual decoded GitHub WebP hashes match the produced sources. Detailed hashes and QA: `docs/D153_ANIMATION_ATLASES.md`.
- Strict D153 `scripts/battle/unit_animation_library.gd` loader and `res://scenes/dev/threadbare_theatre_art_preview.tscn` gallery were prepared beforehand; source assets now occupy their exact expected paths.

## Immediate continuation
**User only:** `git pull`, F6 `res://scenes/dev/threadbare_theatre_art_preview.tscn`, review the five state cycles of both new characters; send screenshot/feedback about motion, feet, direction and silhouettes. **Gallery has not yet been executed by user in native Godot; no art acceptance or native PASS claimed.** The assistant owns any corrections via GitHub.

**After gallery acceptance:** design a unique ruined skeletal puppet-theatre **battle arena** (existing crypt is a placeholder); scope `ThreadTetherController` to D153 production battle; verify real fight→reward→table and full 54-case battle matrix, tune encounter-only if necessary. **Do not activate card #36** before gates.

**Unchanged:** D153 QA only, NOT in `RunState.CARD_PATHS` or `ACT1_CARD_IDS`; live Act1 35/45; 12 cards + sealed XIII. D143 new enemy originality, D167 world-scene card art, D168 image options before future card-art replacements. D153 selected card art already approved direction; no new concept choice needed. DS2/Fate Spread Variant C and D151/D152 stay intact.

