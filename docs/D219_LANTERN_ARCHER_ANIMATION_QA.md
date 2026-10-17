# D219 — Lantern Archer / Стрелок фонарей: 25 original pixel animation frames, QA-only

Date: 2026-10-17. **ART SOURCE + 25-CEL WEBP/B64 + ISOLATED GODOT F6 SCENE COMMITTED. D219 STANDALONE GODOT F6 USER REPORTED «все ок»; FINAL ART APPROVAL PENDING.** Act1 live **37/45**, #38 `black_lantern_road` remains QA-only.

## D219 2026-10-17 user report and D220 final replacement clarification

After being asked to `git pull` and F6 `black_lantern_archer_animation_preview.tscn`, user replied **«все ок»**, then asked if all character sprites would later be replaced. **Yes:** accepted this as a **positive user-native isolated Archer QA response**, NOT a final-art acceptance. The present D219 simplified archer and all other D215–D218 candidates are explicitly technical, to be **replaced by full-quality original dark-fantasy art** for all five roles before #38 ships. Do not simply enlarge, recolor, or adopt previous undead sprites; see `docs/D220_BLACK_LANTERN_FINAL_SPRITE_REPLACEMENT_GATE.md`. No user screenshot of all Archer motion states; ordinary Battle→Reward→Table remains untested.

## Latest user feedback / predecessor gate

After D218 Guide atlas and F6 scene were presented, the user replied **«отлично»** (2026-10-17). Record this as positive **user-reported D218 standalone preview feedback** and proceed. It is not a native screenshot/log or proof all 25 Guide motion states were inspected; **no ordinary battle or release QA was performed**. D215 Sentinel was previously verbally approved after QA preview; D216 Bearer native screenshot loaded and showed shield attack, but idle/walk/hit/death full-motion review remains incompletely evidenced; D217 SVG death-margin native error was fixed and verbally confirmed OK.

## D219 original role / art implementation

- `tools/art/author_lantern_archer_d219.py`: standalone deterministic **original** Python/Pillow authoring script, editable, NO new Godot runtime dependency. All 25 poses are drawn separately by distinct skeletal joints, bow position/string pull, arrow/nock positions, legs, quiver and amber lantern. No presentation-sheet cutouts, reused Sentinel/Bearer atlases or cached legacy sprites.
- `assets/pixel/units/black_lantern_road_qa/lantern_archer_d219_candidate.webp.b64`: actual **576×480 lossless WebP/Base64** in correct 6×5, 96px cells, alpha transparent. Source/text exact-content match checked by GitHub fetch against locally tested export. 25 visible and distinct authored frames and 5 fully transparent surplus cels. Correct state row packing **idle4+2 empty / walk6 / attack6 / hit3+3 empty / death6** per D213 and actual Godot loader.
- Original visual identity: **light-boned skeleton, clearly CURVED WOODEN BOW, THREE-arrow QUIVER and small iron-caged AMBER LANTERN at waist**. Unlike Sentinel, it has no spear; unlike Guide, no huge chain yoke; unlike Bearer, no barricade shield; unlike Acolyte, no oil flask/sickle. Restrained cold-bone/wood/iron/amber palette, standing bootline ~90px.
- Attack frames deliberately change upper and lower limb positions plus bowstring pull across **six visual phases:** (1) set arrow, (2) raise bow, (3) half draw, (4) full tension, (5) release/arrow streak, (6) recover. The arrow graphic is painted **only within a cel** and is not an approved projectile/attack-timing mechanic; the existing ranged BattleUnit attack remains unchanged. Distinct walk foot plants, controlled hit recoil, corpse collapse with knocked-over quiver and dim lantern. No arrows are fired by D219 preview in game.
- Full D219 conversation QA artifacts: `D219_lantern_archer_animation_contact_sheet.png`, transparent PNG, WebP, base64 export, original author script, QC JSON and `Misdeal_D219_Lantern_Archer_QA.zip`. The checkerboard is in the contact sheet only, NOT the in-game atlas.

## Quality checks performed / limitations

The first locally authored death frames had five bottom-border contacts. The second review also found the quiver remaining implausibly vertical on grounded corpse frames. **Both repaired in source art**: late death frame art shifted upward to preserve 2px alpha-safe margin and a horizontal fallen quiver with loose arrows was redrawn. **No QA threshold was weakened.** New offline Pillow result:

| Check | Result |
|---|---|
| Atlas dimensions | 576×480 RGBA WebP |
| Frames present & alpha nonempty | 25/25 |
| Pixel-distinct full cels | 25/25 |
| Correct state rows | 4 / 6 / 6 / 3 / 6 |
| Fully clear surplus cells | 5/5 |
| 2px border warnings | 0 |
| Native Godot animation QA | **NOT RUN** |
| User final art approval | **PENDING** |

Python QC alone does not prove projectile direction, good walk timing, foot slide, frame orientation or visual readability over the fully detailed D209 moonlit road at battle scale. This is an **original QA candidate** rather than a production-registered `MisdealUnitAnimationLibrary` animation.

## Standalone Godot viewer / NEXT USER ACTION

New `res://scenes/dev/black_lantern_archer_animation_preview.tscn` + `scripts/dev/black_lantern_archer_animation_preview.gd` adapted from the already working D216 gallery. It:

1. Loads **exact approved D209 third forest background** via unchanged `scripts/battle/authored_backdrop.gd`.
2. Base64-decodes committed D219 WebP and runs strict per-cel 25-frame / distinct / 5 clear / 2px-alpha-edge validation `_inspect` (no disabled checks).
3. Creates SpriteFrames on the correct five state rows and shows archer **3× for animation anatomy**, **1× for authentic battle readability**, with `ОЖИДАНИЕ / ХОДЬБА / АТАКА / УРОН / СМЕРТЬ` buttons.
4. Stays independent of `battle.gd`, `RunState.ACT1_CARD_IDS`, unit data stats, production sprite library, actual ranged projectile and reward routing.

**User:** `git pull`, F6 `res://scenes/dev/black_lantern_archer_animation_preview.tscn`. Check especially **bow string draw/release and arrow facing to the left toward heroes**, quiver/lantern visibility, foot grounding in walk, and grounded death pose. Send error screenshot if FAIL; otherwise verbal `всё ок` suffices for D219 standalone art-preview acceptance. No Godot runtime PASS should be inferred before user response.

## Next after D219 native QA

A fifth art QA role is staged, **not yet five accepted production-registered sprites**: D215 Sentinel user-reported OK, D216 Bearer visible attack only, D217 Oil Acolyte verbal OK after source fix, D218 Guide positive feedback, D219 archer pending. Review the five at once on *accepted* D209 arena at battle scale, verify foot lines, consistent pixel scale, leftward facing, Guide true ~1.8x visual height, distinct melee/ranged attacks and two moving lantern pools readability. Only after accepted art, register these five original roles in `MisdealUnitAnimationLibrary`, wire encounter-local lantern controller into QA-only real `Battle` scene and verify battle→reward→table, 54-case matrix and full 37→38-card pool release smoke before unlocking card #38.

Keep D200 accepted third card art, D209 original forest, D196 approved surf, DS2/12 Fate Spread resolutions + sealed XIII, +16% original light bonus and `backups/KARAMBA73-2026-10-16` frozen untouched.
