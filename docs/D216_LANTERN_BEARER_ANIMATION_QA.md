# D216 — Lantern Bearer: original shield + lantern animation atlas (QA candidate)

Date: 2026-10-17. **QA CONTENT COMMITTED / STATIC IMAGE AND GITHUB BYTE COMPARISON PASS / NATIVE GODOT F6 PENDING.** Act1 normal random deck **37/45**; card #38 is still unreleased. The current D215 Road Sentinel F6 scene has a **user-reported native PASS**: in response to "F6, click five buttons, inspect feet/spear/death", the user replied **«все ок продолжай дальше»**. Treat D215's simple draft as accepted for continued QA development, not as evidence #38 battle/art/route is released.

## Art output genuinely committed

- `assets/pixel/units/black_lantern_road_qa/lantern_bearer_d216_candidate.webp.b64`: 576×480 lossless WebP/Base64, true RGBA 6×5 of native 96px tiles; **25 different authored sprites, 5 fully transparent surplus cells**. The entire board contains no labels/UI/forest; character is a broad skeletal escort with **distinct giant weathered wooden shield/barricade and separate amber iron lantern**. Short forward shield-check, two-step march and shield-first ground collapse are painted per frame. No copied original 5×5 AI sheet, no recycled enemy sprites. QA candidate uses restrained flat-pixel simplified silhouette similar to D215, not guaranteed finished AAA/painterly illustration.
- `tools/art/author_lantern_bearer_d216.py`: editable, deterministic offline Python/Pillow pixel-authoring source. It imports drawing helpers from `tools/art/author_road_sentinel_d215.py`. When executed, exports PNG, WebP/B64, QC JSON and contact sheet in its source directory. Offline authoring only; Godot remains GDScript, no new runtime library.
- `res://scenes/dev/black_lantern_bearer_animation_preview.tscn` and `scripts/dev/black_lantern_bearer_animation_preview.gd`: **isolated F6 gallery**, decodes exact GH WebP asset, verifies required 25 nonempty unique cels, unused slots and two-pixel safety margin. Shows a 3× animated magnification and a 1× sprite on the **user-approved D209 third forest arena**, five Russian state buttons `ОЖИДАНИЕ, ХОДЬБА, АТАКА, УРОН, СМЕРТЬ`. Does not register `lantern_bearer` in live `MisdealUnitAnimationLibrary.ROLES` or alter battle nodes, stats, encounters or RunState.
- Conversation artifacts: `Misdeal_D216_Lantern_Bearer_Animation_QA.zip` and `d216_bearer/D216_bearer_animation_contact_sheet.png` with checkerboard only in review image, not underlying atlas.

## Actual technical verification

Offline Pillow build: 576×480 RGBA; per-state **row0 idle4+2blank, row1 walk6, row2 attack6, row3 hit3+3blank, row4 death6**; exactly 25 visible and different cells; five empty; **0 alpha boundary warnings** after adjusting final collapsing shield/lantern poses 3px upward. WebP lossless b64 source 16,584 encoded characters; the GitHub UTF-8 B64 file was re-fetched and matched the source byte-for-byte at encoded-text level. Source file and gallery script also committed independently.

**Unknown until user-native Godot review:** whether leg animation, shield slam and death remain physically readable at both 3× and 1×, whether enemy faces heroes properly, whether the simple low-detail draft is artistically acceptable alongside D209, and whether the 3× preview panel overlaps HUD. Do not describe this as a native F6 PASS until user replies with screenshot or explicit confirmation.

## User action

1. `git pull`.
2. In Godot open **`res://scenes/dev/black_lantern_bearer_animation_preview.tscn`**, F6.
3. Click the five state buttons, confirm both sizes. Look specifically for **planted feet, convincing shield-check (not spear motion), separate swinging lantern and intact final body+shield on the road**.
4. Report errors/skips with screenshot if visible; otherwise a simple "всё ок" is enough for D216 QA gallery visual acceptance.

## Remaining production

After D216 native review, create `oil_acolyte` original 25-frame atlas with visible flask+sickle, then giant `extinguished_guide` and `lantern_archer`; each isolated user-checked native art gallery. Then real #38 Battle→Reward→Table with five original enemies + local two-pool lantern buff, 54-case native balance matrix (D207/D208 simulations already passed at +16% control but not real scene), full-pool release smoke and only then Act1 38/45. Do not add unapproved passive shield block/taunt, modify `resources/units/lantern_bearer.tres`, alter the existing D196 storm, DS2, Fate Spread I–XII/XIII, accepted D200 artwork or D209 arena, or frozen `backups/KARAMBA73-2026-10-16`.
