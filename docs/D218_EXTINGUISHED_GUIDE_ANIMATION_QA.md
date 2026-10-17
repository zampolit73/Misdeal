# D218 — Extinguished Guide / Погасший проводник: original three-lantern animation QA

Date: 2026-10-17. Status: **25-CEL ORIGINAL QA ART SOURCE + WEBP/B64 + ISOLATED GODOT F6 SCENE COMMITTED, USER-NATIVE D218 F6 PENDING**. Act1 live pool **37/45**; #38 `black_lantern_road` is still QA-only.

## Native D217 follow-up: user confirmed fixed PASS

After receiving the user's native D217 screenshot with border failures at 0-based death row4 col4/5, code/art was fixed directly in `assets/pixel/units/black_lantern_road_qa/oil_acolyte_d217_vector_candidate.svg` at commit `a8a80f1` (removed two border-spilling low rib strokes, kept strict Godot QA). Asked the user `git pull` + F6 the SAME Oil Acolyte scene; the user's immediate reply was **«все ок»**. Treat it as **user-reported native post-fix D217 gallery functional PASS**. No fresh screenshot/log was supplied for the repeat, so avoid claiming independent per-frame/finished art approval. D216 earlier screenshot shows Bearer gallery render at x3 and x1 with shield attack, but full five-state motion still not explicitly tested by screenshots. D215 Sentinel gallery received prior verbal OK.

## D218 genuinely created and committed

1. `tools/art/author_extinguished_guide_d218.py`: original offline Python/Pillow source for individually staged **25 original alpha-transparent pixel-art poses**. No Godot Python dependency. Exact row-per-state contract `idle4+2empty / walk6 / attack6 / hit3+3empty / death6` for 576×480 WebP (6x5 cels × 96px), matching **actual** `unit_animation_library.gd`. Source defines distinct joint arrangements for each state, controlled chained lantern/metal yoke movement, heavy marching footwork, yoke ritual strike, stagger and multi-pose ground collapse. The source intentionally uses a taller actual drawn shape than regular escorts *and* existing `visual_scale=1.8`; source does not change collider radius or `UnitData` values.
2. `assets/pixel/units/black_lantern_road_qa/extinguished_guide_d218_candidate.webp.b64`: lossless WebP/Base64 candidate, no decorative backdrop/labels. SHA256 **`ad5c734e7df5d62baf5de1813086d1ae6759c5da819cc81181133bef1bf0cc06`** for decoded WebP bytes. Source and encoded text re-read from GitHub and verified equal to the generated source file payload.
3. `res://scenes/dev/black_lantern_guide_animation_preview.tscn` + `scripts/dev/black_lantern_guide_animation_preview.gd`: standalone F6 gallery uses the previously user-approved exact D209 moonlit forest via `authored_backdrop.gd`. After decoding the candidate WebP with Godot native Image, checks **25 nonempty distinct cel hashes, 5 fully transparent surplus cels and 2px material alpha-safe border**, then shows five selectable animations. Enlarged preview at **2.8×** and realistic Guide at **1.8×** alongside existing D216 Lantern Bearer at **1×**, with both character feet rendered near the same battle-floor y. No production role registered and no direct combat affected.

### Offline authoring QA (not equivalent to native Godot F6)

- 25/25 populated distinct original frames; 5/5 unused cells transparent, zero border-contact warnings. Earlier preview failed for four death-frame toes/ribs at bottom; corrected actual source by drawing the collapsing body on an expanded 96×104 canvas and lifting the complete pose by 3px into the cel before final native 96×96 crop. Therefore no low body detail is merely clipped away. Regenerated WebP, PNG contact board, hash and QC JSON with all checks green.
- Visual: tall hunching dark mantle, non-identical shoulder plates, visible skull and boots, **three amber lanterns on chains hung from a wide, heavy metal frame**. Deliberately role-distinct from one-shield Bearer, long-spear Sentinel, small flask+sickle acolyte. This is still a **simplified QA-quality native pixel rendition**, not an approved painterly production sprite or actual physical light effect.
- Conversation/downloadable artifacts: `Misdeal_D218_Guide_Animation_QA.zip` and `d218_guide/D218_guide_animation_contact_sheet.png` include local PNG, decoded lossless WebP, source author, B64 and offline QC. The PNG is local review material; **GitHub commits contain source Python and exact B64 game-QA candidate**.

## Native test requested

1. User `git pull`.
2. Godot F6: **`res://scenes/dev/black_lantern_guide_animation_preview.tscn`**.
3. Click `ОЖИДАНИЕ / ХОДЬБА / АТАКА / УРОН / СМЕРТЬ` and inspect the new large Guide with the nearby Bearer (1.8× vs 1×): legs stay grounded at the same road depth, no lantern collision/clipping, readable heavy yoke/three distinct swinging lamps, no suddenly invisible sprites or sky/HUD overlap.
4. On red QA error or parser error, inspect current GitHub source first, fix directly and request F6 again. A screenshot or «все ок» from the user establishes D218 native QA result; **do not declare it PASS in advance**.

## Next

After D218 user-native review, create the fifth unique 25-frame `lantern_archer` (bow with real draw→release and attached lamp) with an isolated Godot F6 gallery; run remaining D216 five-state review if requested. Then decide which originals meet final art requirements, and only afterward register 5 roles, wire #38 into the real scoped Battle→Reward→Table, retest 54-case combat and full-pool smoke, and unlock **38/45**. No global new movement/light/shield mechanics invented during art production.

Preserve D209 accepted forest, D200 chosen third #38 card art, D196 approved wave motion, current +16% encounter-only lanternlight modifier, live DS2 / Fate Spread 12+XIII, and frozen `backups/KARAMBA73-2026-10-16`. No production `MisdealUnitAnimationLibrary` changes were made.
