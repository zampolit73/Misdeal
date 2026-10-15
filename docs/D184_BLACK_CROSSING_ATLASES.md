# D185 — Source-derived sprite atlas GitHub transfer completed (2026-10-15)

**STATUS (D186): both approved-role sprite atlases in GitHub and user-reported native Godot F6 gallery PASS («все ок»).**

The previous upload blocker in D184 is resolved. The transfer used an internal temporary text-file bridge and GitHub blob objects; no manual user ZIP upload or copy/paste was necessary. Git object SHA for each committed base64 text file was matched against the local bytes.

| Original role | Final GitHub production file | WebP bytes | WebP SHA-256 | Git blob SHA |
| --- | --- | ---: | --- | --- |
| Ferryman B | `assets/pixel/units/deck_expansion_v1/drowned_ferryman_frames.webp.b64` | 76,662 | `1326ad61f106fd97a38c3a54659a6d2d38676faeb991f933f7247acd3817c03c` | `a07f5efc54e18a473846c0d4fa7424fbb41c3ca8` |
| Drowned C | `assets/pixel/units/deck_expansion_v1/drowned_hand_frames.webp.b64` | 76,168 | `139d97e25bd95e64ae9acb4a9e87d9da27842238a1b48295679be2c149e3cbcd` | `9a6f2ce4ba15374a7a74bdac082d6ff94242e72d` |

Both assets were decoded and validated in the assistant's container: exact 576×480, 6×5 cells of 96×96, **4/6/6/3/6 = 25 nontransparent, distinct and 2px padded poses**, 5 fully unused transparent cells. Removed 14 visually detached lateral fragments in the Drowned source cells, without changing the approved character identity. Ferryman source was actually 24 poses (5 attacks); one source-derived distinct attack follow-through was constructed for the sixth required attack cell. This technical completion is disclosed, not disguised as a newly hand-drawn frame.

Runtime `scripts/battle/unit_animation_library.gd` supports these two roles in strict no-fallback D183 branch. F6 gallery `scenes/dev/black_crossing_animation_preview.tscn` cycles idle→walk→attack→hit→death and reports any missing atlas rather than substituting old enemies.

**Latest user QA:** the user confirmed «все ок» after being instructed to run the animation gallery and check movement/full-body poses; consider the native visual QA accepted, without inventing diagnostic screenshots. **What is NOT done:** No original black-crossing 1280×720 battle arena, authored enemy UnitData, encounter-only wave controller, 54-case suite, real battle/reward/table QA or #37 release exists. Act1 remains **36/45**.

Original art source IDs and historical upload issue: [D184 preceding notes](D184_BLACK_CROSSING_ATLASES.md) (superseded above). Source concept details: `docs/D183_BLACK_CROSSING_UNIT_ART.md`.

