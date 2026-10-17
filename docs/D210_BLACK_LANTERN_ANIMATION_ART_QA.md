# D210 — Five original skeleton animation roles: art QA and correction gate

Date: 2026-10-17. Status: **SOURCE CONCEPTS INSPECTED — 5/5 PRODUCTION ATLASES BLOCKED.** No new sprites activated in `unit_animation_library.gd`; normal Act1 pool still **37/45**.

## Previous gate: D209 user-native visual PASS

The user sent a screenshot from `res://scenes/dev/black_lantern_road_arena_visual_preview.tscn` and replied **«все ок»**. Screenshot confirms the exact accepted D209 third moonlit forest background displays in Godot, three left-side blue clearance silhouettes, five right-side bronze silhouettes, larger Guide, moving amber light circles and readable stage labels. Record this as **D209 native visual composition/layout PASS**. This does NOT establish real sprite footwork, active combat effect, or battle→reward→table.

The approved forest image and `authored_backdrop.gd` mapping are in GitHub; do not substitute a new arena.

## Actual available art input

The earlier D205 image batch exists in this conversation as five **1254×1254 RGBA 5×5 pose sheets**. They have been locally remapped to five **576×480, 6×5, 96px/cell** _concept-stage_ candidates; the D205 images were not approved as original final animation. These candidates are conversation artifacts, not GitHub runtime sprites. New QA board `Misdeal_D210_Animation_Review.png`, report `Misdeal_D210_Animation_Review.json` and `Misdeal_D210_Art_QA.zip` display representative idle/walk/attack/hit/death frames for all five roles. These outputs are **for review only**, not commit-ready animation atlases.

| Role | 5×5 source border-contact warnings / 25 | Visual/art blocking checks |
|---|---:|---|
| `extinguished_guide` / Погасший проводник | 13 | Need convincing **2× battle silhouette**, original chained lantern rig, grounded motion/falling pose, no arm/lantern-frame clipping |
| `lantern_bearer` / Носильщик фонаря | 20 | Make the role silhouette readable and distinguish its approved defensive board/shield from the other lantern handlers |
| `road_sentinel` / Страж дороги | 24 | **Incorrect axe/halberd silhouette must become the approved long SPEAR**; source pose overlap and clipping risk highest |
| `oil_acolyte` / Масляный служка | 21 | Oil flask and sickle should be recognizable; ensure falling animation doesn't cut off lamp/flask |
| `lantern_archer` / Стрелок фонарей | 13 | Preserve clear bow, quiver and hung lantern; arrow/lantern effect must not bleed across frames |

A “border warning” means source silhouette alpha touches a 5×5 region edge and **requires visual inspection**, not that the frame is proven broken. But the source has visible pose/weapon crossing and cannot be safely corrected just by centering/cropping. The remap's 25 nonempty distinct cells DO NOT confirm fluid walk, accurate attacks, or role-specific actions. At production stage NEVER synthesize missing motions by repeating frames or use old undead sprites disguised as new roles.

## Contract before Godot gallery / battle

- Five **original, approved** characters with exactly **idle 4, walk 6, attack 6, hit 3, death 6 = 25 meaningful animation frames per role**; Godot bitmap **576×480 RGBA, six columns × five rows, 96px cells**; five unused cells genuinely transparent. Frame anchoring near sole **y=87..94** where appropriate, no cropped boots, weapons, capes or effects at cell edges; stable orientation and source pixel density.
- Staged art to be matched against the accepted D199 character designs: leader substantially bigger (Guide around twice escort height), Sentinel uses **spear**, archer bow, acolyte flask+sickle, bearer defensive rig. Do not make all five into the same hooded skeleton.
- Run independent role-by-role visual motion review **before** authorizing runtime additions to `MisdealUnitAnimationLibrary`. In Godot, verify walk foot contact/foot sliding, attack impact frames, hit feedback, death final frame, facing, health bars and foreground layering on **the D209 exact accepted 1280×720 arena**.
- The D205 converter `scripts/dev/stage_black_lantern_art.py` is a *technical staging tool* only; it does not approve an art asset or fix genuine drawing errors.
- After image gate PASS, integrate only approved WebP/Base64 exports to GitHub, create standalone F6 animation gallery/scene; then wire five UnitData + two formations + lantern controller into QA-only real battle and run real Battle→Reward→Table and full-pool release smoke before adding #38.

## Next art production

Start with `road_sentinel` (wrong weapon and 24/25 border contacts): recreate **authentic long-spear** distinct frames, not an axe with its handle recolored. Then address `lantern_bearer` and `oil_acolyte`; finish Guide large frame anchor/rig and archer projectile. Keep DS2/Fate Spread, selected D200 card art, D209 backdrop, D196 surf and immutable `backups/KARAMBA73-2026-10-16` unchanged.

D207 (+16%) and D208 (+22%) both passed 54-case simulated battles; +22% did not change displayed outcomes/HP and was reverted. D209 preview contains **visual-only** moving light. Card #38 **NOT RELEASED**, regular Act1 remains **37/45**.
