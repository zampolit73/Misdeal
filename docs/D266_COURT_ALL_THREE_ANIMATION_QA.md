# D266 — Court all-three 25-pose original animation QA

**2026-10-19 | GitHub main | STRUCTURAL 75/75 PASS, ARTISTIC/RELEASE HOLD.**

User said «все ок — продолжай» after D265. Created original role-specific transparent frame sheets, without changing the selected D261 second Court card, D264 lower-floor bounds, D262 verdict, D260 card #38 or KARAMBA73.

## Actual QA assets

Source generator: `tools/art/author_court_d266_three_atlases.py`. Each sprite uses role-specific body, costume, prop and joint animation across idle4/walk6/attack6/hit3/death6, packed in a **6×5×96 pixel / 576×480** alpha WebP with five totally blank spare cells. Not a recycled enemy sprite or annotated infographic.

- `assets/pixel/units/court_of_the_mute_qa/mute_magistrate_d266_qa.webp.b64` — ceremonial crowned skeletal judge, legal seal and scales staff.
- `assets/pixel/units/court_of_the_mute_qa/ash_scrivener_d266_qa.webp.b64` — hooded bony scribe with ledger and quill.
- `assets/pixel/units/court_of_the_mute_qa/bone_bailiff_d266_qa.webp.b64` — shield-bearing armored skeleton and swung hooked halberd.

[Source authoring CI PASS](https://github.com/zampolit73/Misdeal/actions/runs/39226926567), authoring report `docs/qa/D266_ORIGINAL_75_POSE_AUTHORING.json`. [Independent all-three alpha and duplicate structural QA PASS](https://github.com/zampolit73/Misdeal/actions/runs/39227098722), report `docs/qa/D266_THREE_ROLE_FULL25_AUDIT.json` confirms **75/75**: 25 distinct cells per role, 15 total unused alpha-clear cells, 2px borders free of art and no empty used poses.

[Official Godot 4.7.2 native F6 scene check PASS](https://github.com/zampolit73/Misdeal/actions/runs/39227508979): `res://scenes/dev/court_of_the_mute_d266_three_animation_preview.tscn` decodes all three candidate sheets through standard Godot `SpriteFrames`, verifies they are NOT registered as production art, and presents them simultaneously at real ×1 and enlarged ×2.1 with five animation selectors, facing LEFT/RIGHT and G lower-floor toggle. Existing unrelated `assets/concepts/approved_battle_direction.jpg` editor import warning persists.

## Honesty / what is NOT complete

The D266 original frames are **procedurally authored, stylized small-scale skeleton animation PROTOTYPES**. They are currently simpler and more schematic than the user's selected painterly D261 card illustration. Do **not** label them final rich approved artwork merely because all 75 pass technical validation or Godot loads them. Movement, foot contact, grip, texture richness, facing and continuity require a single human-native F6 visual review and likely further joint/costume refinements. D265 Court arena is also an empty QA candidate, not approved final scenic art.

None of these sprites were added to `MisdealUnitAnimationLibrary`; `court_of_the_mute.tres` card `target_path` is still empty and the live `RunState.ACT1_CARD_IDS` remains **38/45**. This is NOT a fully playable released card #39.

## Next (D267)

Improve all three sprites in **one coherent batch** toward the approved rich Court world (bronze mantle/seal, actual quill/ledger grip, shield/halberd, readable knees and soles at 1×). Make an actor-free, stylistically richer tribunal matching approved second card art and keep D264 bottom combat stone floor x40–1268/y532–710. Inspect the three animation packs together with F6, no micro-approvals. Only following art quality sign-off: production animation-library and arena hookup, 54-case Court balance, genuine Battle→Reward→Table and explicit card #39 release to 39/45. Preserve KARAMBA73, D260 #38, DS2 and Fate Spread 12+XIII.
