# Misdeal — D153 next-chat checkpoint, 2026-10-15

## Current repo and accepted visual

Read `AGENTS.md`, `docs/CONCEPT.md`, `docs/PROJECT_STATE.md`, `docs/ROADMAP.md`, `docs/DECISIONS.md`. Repository is `zampolit73/Misdeal` on `main`. GitHub is technical truth and the connected assistant does repository edits itself.

**MOST RECENT USER FEEDBACK:** After the first 25-frame D153 atlas pair was committed, user said the generic small sprites did NOT resemble the accepted skeletal theatre card illustration. The assistant generated two much richer, deep-crimson pixel character sprite sheets; user saw them and said **«Подходит)»**. This is approved new artistic direction, not acceptance of the final native Godot animation.

**IMPLEMENTED NOW:** Both approved redraws have been correctly repacked into **actual strict production atlases** and committed under the paths read directly by `MisdealUnitAnimationLibrary`:
- `assets/pixel/units/deck_expansion_v1/threadbare_puppeteer_frames.webp.b64` — SHA-256 (decoded WebP) `93f8839a778709f3c144a97eb3bef51e0b16944dc796e7cf9ec690896d23b846`, 44,426 bytes.
- `assets/pixel/units/deck_expansion_v1/bone_marionette_frames.webp.b64` — SHA-256 (decoded WebP) `eb51e5d13968921bfa4ee4e9adef65c9c1939fb15a91f9e10a1c88e37633c755`, 43,114 bytes.

576×480 each, 6×5 grid of 96×96, **25 unique nonempty poses**, idle4/walk6/attack6/hit3/death6, unused cells blank, per-cell padding validated after WebP export. Early naïve resized redraws FAILED these contracts; these newly individually recropped/cleaned/quantized assets passed automated alpha/cell/uniqueness checks. Rejected old V1 runtime files are preserved as `*_frames_rejected_v1.webp.b64`. Do not revive V1 or change the user-approved card illustration.

## Next exact action

**User:** `git pull`, run F6 `res://scenes/dev/threadbare_theatre_art_preview.tscn`, inspect both skeletons over five states and send screenshot or feedback. **Native animation F6 not yet performed or accepted after replacing sprites.** Assistant fixes any art or GDScript issue in connected GitHub directly, not by user copy-paste.

**Already passed in user Godot:** D153 selected theatrical 448×274 card art renders. Isolated `threadbare_theatre_smoke.tscn` F6 **PASS** with zero reported errors: 32% thread protection within 285px, range break/reconnect, master-death break and cleanup. This controller still is not production battle-wired.

**Next after native art approval:** author dedicated ruined puppet-theatre battle arena, scope thread controller to D153 `battle.gd`, 54-case matrix, real fight→reward→table, then and ONLY then register card #36.

**Frozen:** D153 NOT in `RunState.CARD_PATHS` nor `ACT1_CARD_IDS`, live Act1 35/45, 12 Fate Spread + sealed XIII, D143 original enemies, D167 illustrated world-scene card art, D168 concept options before choosing card illustration (D153 already chosen), DS2/Variant C and existing D151/D152.
