## CURRENT CHECKPOINT — 2026-10-12 — Isolated Design System 2.0 Reward preview added

Implemented in GitHub main an **F6-only, non-production** reward-material preview: \`scenes/dev/design_system_v2_reward_preview.tscn\` + \`scripts/dev/design_system_v2_reward_preview.gd\`. It reuses approved Variant C tabletop background and real existing reward card textures via \`CardArtCatalog\`; static Death Wager example with three cards (gold/relic/extra upgrade), click/hover/selected style and inspect feedback. Added opt-in DS2 material/card/parchment helpers to \`scripts/ui/misdeal_ui_kit.gd\`. Existing \`scenes/reward/reward.tscn\`, reward gameplay/RunState, the Fate Spread itself, battle HUD and character assets are **unchanged**.

**Local visual gate OPEN:** Godot 4.7.x was not available to run the scene. User should \`git pull\`, run \`res://scenes/dev/design_system_v2_reward_preview.tscn\` with F6 at 1280×720, test art/labels/hover/selection/button and send a screenshot. Only after explicit visual approval should this style be migrated into production Reward; keep DS2 materials opt-in.

---

## CURRENT CHECKPOINT — 2026-10-12 — Fate Spread canonical Design System 2.0 direction approved

The user explicitly confirmed the existing Fate Spread Variant C screenshot as the **favorite art** and canonical style/color/material reference for the whole Misdeal UI. This does NOT authorize altering that art; its composition, cards, ring, ritual crimson, aged metal, candlelight and parchment should be preserved. `docs/DESIGN_SYSTEM.md` now starts with an approved Design System 2.0 visual/material direction, safe staged migration plan and provisional reference palette. `scripts/ui/misdeal_ui_kit.gd` gained **opt-in only** material constants `TABLE_OBSIDIAN`, `RITUAL_CRIMSON`, `AGED_BRONZE`, `PARCHMENT_WARM`, `MOONLIT_STEEL`; existing UI token values and callsites unchanged. Decision D123 records this binding style priority.

**No production screen redesign or artwork migration performed.** Next: isolated reward/event surface style preview at 1280×720 in Godot, get user's approval, then migrate one screen at a time. No alteration of active Fate Spread/table scene, combat stats, card state or run flow. Prior compact-HP-bar Godot review remains pending.

---

## CURRENT CHECKPOINT — 2026-10-12 — Compact health bar visual pass

After the user's Gallows Volley screenshot, the solid neon-green/red health bars were redesigned in `scripts/battle/unit.gd` (`d744e61`). Smaller 58px-wide/7px-high standard tracks with dark background, thin bronze borders and muted green/red fill replace thick flat strips; Crypt Guard remains slightly wider (66px) and boss has a distinct 114px/9px track. The style uses existing `ProgressBar` and health update logic; no mechanics, UI scene node hierarchy, sprite art or player/enemy positioning were changed. Local Godot 4.7.x battle/screenshot QA pending; examine readable HP, bar overlap at crowded positions, team contrast and boss presentation.

---

## CURRENT CHECKPOINT — 2026-10-12 — Mage visual scale reduced after clean art replacement

User screenshot of Bone Swarm showed the latest clean Mage art too tall at multiplier 1.65 compared to Ranger. Changed only `HERO_ROLE_VISUAL_SCALES["mage"]` in `scripts/battle/unit.gd` from 1.65 to **1.25** (commit `38831c0`); Knight remains 0.90, Ranger 1.00. Asset, combat physics, enemy scales and gameplay unchanged. New Godot screenshot validation pending.

---

## CURRENT CHECKPOINT — 2026-10-12 — Clean elderly Mage atlas deployed

After screenshot feedback: Mage height was accepted with hero-only scale **1.65**, but the previous atlas showed weak/transparent silhouette and extraction artifacts. User approved a newly generated elder bearded Mage with solid purple cloak and staff. Production `assets/pixel/units/combat_units_anim_v2/mage.webp.b64` is replaced by the cleaner transparent 576×480 / 25-pose sheet (commit `9d72854`), verified remote text equals approved 414688-character Base64 file. Former atlas archived at `mage_archived_pre_dark_clean.webp.b64` (commit `089b9fd`).

The new Mage attack row has six authored poses, so `scripts/battle/unit_animation_library.gd` was corrected to play all 6 instead of the obsolete projectile-only skip (commit `6ce91f9`). Existing gameplay projectile FX, attack timing implementation, balance, AI and all other roles unchanged. **Mage scale stays 1.65**, Knight 0.90, Ranger 1.00. Offline image dimension, occupied frames and sole checks passed; **Godot F6 and actual battle QA still pending**. At combat scale verify alpha edges, no leaked neighboring frames, Mage staff, death fall, feet and visible height; correct art if necessary rather than changing arena.

---

## CURRENT CHECKPOINT — 2026-10-12 — Elder Mage scaled to match hero trio

On user's 1280×720 Firing Square screenshot the old-beard Mage was still noticeably shorter than Knight and Ranger after first pass. Increased hero-only `HERO_ROLE_VISUAL_SCALES["mage"]` from 1.15 to 1.65 in `scripts/battle/unit.gd` (commit `ab22b50`). Knight stays 0.90, Ranger 1.00. Animation grounding is recomputed from final sprite scale; enemy dimensions, stats, AI and placement untouched. Local Godot screenshot recheck pending. This is an empirical art-scale calibration, not a gameplay change.

---

## CURRENT CHECKPOINT — 2026-10-12 — Hero silhouette scale normalization

Following the 1280×720 Iron Wall battle screenshot, hero sprite sizes were inconsistent: blue Knight visually largest, new bearded Mage smallest, Ranger in between. Production `scripts/battle/unit.gd` now applies **hero-only role visual multipliers** relative to Ranger (Knight 0.90, Ranger 1.00, Mage 1.15) to existing `HERO_DISPLAY_SCALE * visual_scale` (commit `24b3df1`). Enemy/boss scaling, combat collision/movement/AI/stat parameters, art assets and scene layout are unchanged. `base_sprite_scale` is assigned from final scale before the animated sole-based `_art_rest_position()` calculation, preserving current ground-contact logic.

**Local Godot screenshot QA pending:** `git pull`, inspect Knight/Ranger/Mage in Iron Wall trio setup and walking/attack, compare head height/visible boots and floor rings. Adjust values only if actual full-size screenshot still looks uneven; avoid moving entire arena or modifying physics. This change does not certify engine-tested size parity.

---

## CURRENT CHECKPOINT — 2026-10-12 — Bearded elder Mage atlas replaced, Godot QA pending

The user selected the **first** of the last three Mage visual variants: an older male archmage with long white beard, dark-purple robes and violet-orb staff. The former live Pack 1 v2 Mage atlas was preserved at `assets/pixel/units/combat_units_anim_v2/mage_archived_pre_oldbeard.webp.b64` (commit `4c0e94a`). The approved replacement is now `assets/pixel/units/combat_units_anim_v2/mage.webp.b64` (commit `3e23cc8`), with remote content verified identical to the 123144-character Base64 source.

The new 576×480 transparent 6×5 / 25-pose sheet passed offline 25-cell transparency/contact checks (0 errors, 0 warnings). The live animation library ALREADY supports Mage, so no battle scripts, timing, damage, targeting, projectile FX or other roles were modified. **No Godot 4.7.x F6 or actual battle review completed**: visually inspect idle/walk/attack/hit/death, staff and head/hair clarity, unwanted frame lines/bleed, effect alignment, grounding and attack pose in the existing `res://scenes/dev/unit_animation_pack1_preview.tscn`. Replace or clean artwork if any borders or isolated projectile effects show at combat scale.

All 5 Pack 1 roles (Knight, Ranger, Mage, Skeleton, Bone Archer) and 4 Pack 2 enemies still have animation resources. Blue Knight and Pack 2 runtime visual QA remain open.

---

## CURRENT CHECKPOINT — 2026-10-12 — Blue Knight reanimated; in-engine QA pending

**GitHub main:** User-approved leg-readable blue Knight 576×480 transparent 6×5 atlas (Idle4/Walk6/Attack6/Hit3/Death6) replaced `assets/pixel/units/combat_units_anim_v2/knight.webp.b64` (commit `6afd288`). The former problematic v2 atlas was archived as `assets/pixel/units/combat_units_anim_v2/knight_archived_pre_blue.webp.b64` (commit `0101679`) for exact rollback. `scripts/battle/unit.gd` now has an empty `STATIC_COMBAT_ART_ROLES` list and uses normal `MisdealUnitAnimationLibrary.get_frames("knight")` again, with existing static v4 fallback on missing/unreadable atlas (commit `dffa7ee`).

The new atlas passed offline frame-grid, alpha corner and sole-position checks (0 errors/0 warnings); remote Base64 matches the approved source exactly (456632 chars). **Godot F6 and actual combat visual acceptance still pending**. Critical checks: both boots separated at 1280×720, walking contact on blue team ring, shield not hiding shins, slash/hit/death texture boundaries, art baseline/scale. Do not further nudge Y offsets as a substitute for artwork corrections. No battle stats, AI or encounter changes.

Pack 1 now has all five roles frame-enabled: Knight, Ranger, Mage, Skeleton, Bone Archer. Pack 2 four enemies frame-enabled: Bone Thrall, Grave Bellkeeper, Crypt Guard, Bone Warden. Full in-engine art QA of recent changes remains necessary.

---

## CURRENT CHECKPOINT — 2026-10-12 — Pack 2 four enemies enabled; local runtime QA pending

**Actual GitHub main:** the approved Bone Warden 576×480 transparent WebP/Base64 atlas with 25 used poses (Idle4/Walk6/Attack6/Hit3/Death6) is now committed at `assets/pixel/units/combat_units_anim_pack2_candidates/bone_warden.webp.b64` (asset commit `77a759d`), and fetched remote text matches the approved source exactly (379148 Base64 characters). `scripts/battle/unit_animation_library.gd` routes `bone_warden` together with `bone_thrall`, `grave_bellkeeper`, and `crypt_guard` to the Pack 2 directory (commit `1238b3c`), all preserving static v4 missing/invalid asset fallback.

**Pack 2 implementation complete in GitHub, NOT Godot-accepted:** all four enemy sheets and code lookup are present. Offline Pillow frame/grid/alpha/sole QA passed (Bone Warden: zero errors, zero warnings), but local Godot 4.7.x F6 and real battle verification STILL REQUIRED. Confirm boss scale, heavy staff swing, flash/fx alignment, grounded death, mirrored direction, and transitions before calling the visual pass accepted. No combat mechanics, AI, stats or encounter content changed.

**Current roles:** Knight intentionally static v4 until readable replacement; Ranger/Mage/Skeleton/Bone Archer animated Pack 1 v2; Bone Thrall, Grave Bellkeeper, Crypt Guard, Bone Warden animated Pack 2 with v4 fallback. Next gameplay action: `git pull`, F6 `res://scenes/dev/unit_animation_pack2_preview.tscn`, then Bone Warden and other enemy encounters. Only remaining core animation replacement backlog is Knight redesign; do not blindly enable archived broken Knight frames.

---

## CURRENT CHECKPOINT — 2026-10-12 — Crypt Guard sprite animation committed and enabled

**GitHub main implementation:** approved Crypt Guard 576×480 transparent sheet (6×5 grid, 25 poses) stored at `assets/pixel/units/combat_units_anim_pack2_candidates/crypt_guard.webp.b64` (commit `5412b1d`), exact remote Base64 text compared with the supplied asset. `scripts/battle/unit_animation_library.gd` includes `crypt_guard` in Pack 2 path alongside Bone Thrall and Grave Bellkeeper (commit `fa78548`), with existing v4 fallback. Previous offline grid/alpha/grounding validation: 0 errors/0 warnings. **Godot F6 and live-combat runtime validation remain pending**; do not imply engine-tested animation.

Knight intentionally static v4; Ranger/Mage/Skeleton/Bone Archer remain Pack 1 v2 animated; Bone Thrall/Grave Bellkeeper/Crypt Guard Pack 2 animated; Bone Warden static v4 plus Stage A attack-contact effects. Next sheet is Bone Warden, requiring separate user visual approval before enabling. No combat balance or AI changes.

---

## CURRENT CHECKPOINT — 2026-10-12 — Grave Bellkeeper Pack 2 atlas committed and enabled

**Implemented in GitHub main:** approved transparent 576×480 Grave Bellkeeper atlas `assets/pixel/units/combat_units_anim_pack2_candidates/grave_bellkeeper.webp.b64` (commit `c28011d`), remote file verified byte-for-byte against the prepared Base64 export (362748 characters). The production library now includes `grave_bellkeeper` beside `bone_thrall`, using the Pack 2 directory and existing static-v4 fallback (commit `9f32e4b`). The 25 active poses are Idle4 / Walk6 / Attack6 / Hit3 / Death6.

**Godot acceptance STILL PENDING:** offline extraction/alpha/grid checks were run earlier; full F6 and real battle have not been executed in this environment. User should verify actual silhouettes, bell chain/weapon continuity, footing, facing and death. No stat, AI, targeting, tactical or encounter changes.

**Active roles:** Knight static v4. Ranger/Mage/Skeleton/Bone Archer animated Pack 1 v2. Bone Thrall + Grave Bellkeeper animated Pack 2 with v4 fallback. Crypt Guard and Bone Warden still static v4 with existing Stage A contact VFX and need authored 25-frame sheets. Next asset: Crypt Guard.

---

## CURRENT CHECKPOINT — 2026-10-12 — Approved Bone Thrall sprite sheet uploaded and loader enabled

**ACTUAL GitHub asset uploaded and verified:** `assets/pixel/units/combat_units_anim_pack2_candidates/bone_thrall.webp.b64` is in `main`, commit `29d0725c3bd2c1ae8b07f6de2df2cf9095c01637`; fetched Base64 bytes were checked against approved conversation export (exact match, 254064 Base64 characters). It is a transparent 576×480 6×5, 25-used-pose asset. The previously committed production `MisdealUnitAnimationLibrary` optional `bone_thrall` path now resolves this real file, so **Bone Thrall is switched to SpriteFrames on asset-present builds**, with static-v4 fallback if unavailable. Stage A attack FX remain.

**Runtime acceptance pending:** no Godot 4.7.x local F6 or actual combat smoke done here; verify frame boundaries, feet/ground, animation timing, flip and death. Do not infer visual polish from successful asset transport.

**Other characters unchanged:** Knight static v4; Ranger/Mage/Skeleton/Bone Archer Pack 1 v2 frames; Bellkeeper, Crypt Guard and Bone Warden static v4 plus attack FX. Those three new sheets still required.

NEXT LOCAL: `git pull`, run `scenes/dev/unit_animation_pack2_preview.tscn` F6, inspect Bone Thrall five states and combat encounters; report problems before treating it as final-quality. Continue creating real art for remaining three enemies.

---

## CURRENT CHECKPOINT — 2026-10-12 — Bone Thrall approved, export prepared, repository asset transfer pending

User approved the Bone Thrall 576x480 RGBA 25-pose draft. Local source passed alpha/grid/filled-frame checks; a lossless WebP Base64 candidate was produced in the conversation runtime as `bone_thrall.webp.b64` (254065 bytes). **This file has NOT been uploaded to GitHub** because the connector only accepts directly supplied UTF-8 content, while the production image currently exists in the local artifact runtime; do not claim the combat animation is visually tested or fully deployed.

The production animation library now has an **optional** `bone_thrall` candidate lookup with a strict missing-file static-v4 fallback (commit `d25e471`). Until the encoded candidate is placed at `assets/pixel/units/combat_units_anim_pack2_candidates/bone_thrall.webp.b64`, Bone Thrall remains static v4 with existing contact FX. Other roles and battle mechanics unaffected. Godot F6 still untested.

NEXT: transfer the already-exported candidate asset to that exact repository path; visually verify in `scenes/dev/unit_animation_pack2_preview.tscn` and production battle, then record QA and activate only if the art reads correctly. Do not regenerate a different image silently.

---

## ANIMATION PRODUCTION UPDATE — 2026-10-12 — Pack 2 frame briefs prepared, artwork still outstanding

**Preparation COMPLETE:** existing importer, candidate validator and F6 comparison preview remain the approved technical route. Added `docs/UNIT_ANIMATION_PACK2_FRAME_BRIEFS.md` with per-role 25-frame shot lists, 96px contact rules, four-frame key-pose review and staged acceptance gates.

**Actual spritesheets STILL REQUIRED:** none of the four new 576×480 candidates (`bone_thrall`, `grave_bellkeeper`, `crypt_guard`, `bone_warden`) has been authored, approved, imported or committed in this update. Key-pose proof images are also pending. The next work is **art**, not loader rework.

**Live combat models NOT SWITCHED:** Knight remains static v4 (-8 px); Ranger/Mage/Skeleton/Bone Archer retain Pack 1 v2 animations; all four Pack 2 targets remain static v4 with Stage A attack-contact VFX. No combat art, gameplay scripts or battle behavior changed. Local Godot F6 verification is outstanding.

**Resume:** create and review four Bone Thrall key poses first, then complete 25 real frames; use importer + F6 QA and seek approval before connecting any Pack 2 sprites to live combat. See `docs/UNIT_ANIMATION_PACK2_FRAME_BRIEFS.md`.

---

# Misdeal — Project State

## CURRENT CHECKPOINT — 2026-10-12 — Pack 2 Stage B preparation finished; animation artwork missing

**GitHub verification at handoff (2026-10-12):** confirmed `scripts/dev/import_animation_pack2_candidate.py`, `scripts/dev/unit_animation_candidate_validator.gd`, `scripts/dev/unit_animation_pack2_preview.gd`, `scenes/dev/unit_animation_pack2_preview.tscn` and the staging README all exist. Direct checks of the four intended `{role}.webp.b64` candidate paths returned **not found**. `scripts/battle/unit.gd` and `scripts/battle/unit_animation_library.gd` are unchanged by this staging work. **Development can resume from art creation, not more loader/architecture work.** Real Godot F6 acceptance is still outstanding.


**Preparation COMPLETED and committed:** the Python/Pillow importer (`scripts/dev/import_animation_pack2_candidate.py`), Godot candidate validation (`scripts/dev/unit_animation_candidate_validator.gd`), v4-vs-candidate F6 preview (`res://scenes/dev/unit_animation_pack2_preview.tscn`), staging README and `docs/UNIT_ANIMATION_PACK2.md` are available. The importer was tested on real Pack 1 art and a deliberately invalid opaque sample. The Godot F6 scene has not yet been locally tested.

**Art STILL REQUIRED:** genuine transparent 576x480 sheets (6 columns x 5 rows, 96px cells, 25 used poses) for `bone_thrall`, `grave_bellkeeper`, `crypt_guard` and `bone_warden`. Rows: Idle 4, Walk 6, Attack 6, Hit 3, Death 6. Each frame needs clearly separate feet, recognizable weapon and consistent sole position; no previous-row bleed, repeated fake frames or opaque arena background. The candidates folder contains only `README.md`; **zero new spritesheets were approved or added**.

**Live combat models NOT SWITCHED by Stage B:** `scripts/battle/unit.gd` and `scripts/battle/unit_animation_library.gd` still load the existing assets. Knight is intentionally **static v4** (current offset -8px) after the bad animated Knight leg silhouette; Ranger, male Mage, Skeleton and Bone Archer use their existing Pack 1 v2 frame animations. The four remaining undead are **static v4** with the already implemented Stage A short attack-contact VFX. All combat mechanics, unit placement and art are unchanged.

**Next chat:** acquire real frames, validate/export into `assets/pixel/units/combat_units_anim_pack2_candidates/`, compare the five states with v4 via F6 at 1280x720, and **only after explicit visual approval** activate each role via the existing `SpriteFrames` library with v4 fallback. Without candidates the F6 scene must say `ОЖИДАЕТ АРТ`. Do not treat full battle illustrations as atlases. For details read `docs/HANDOFF.md`, `docs/ROADMAP.md`, `docs/UNIT_ANIMATION_PACK2.md` and decision D121. Historical states below may be superseded.

---

## Latest implemented state — 2026-10-12 — Pack 2 Stage B candidate art validation + comparison gallery

After shipping the four distinct undead attack impact FX (Stage A), the user said "давай дальше". Confirmed that valid new animation **sheets do not exist** for `bone_thrall`, `grave_bellkeeper`, `crypt_guard`, `bone_warden`. Image-generation attempts produced full battle screenshots instead of separated actor frames and were **not** integrated. Connected OpenArt model list showed insufficient credits, so that path was not used.

**Committed a safe technical Stage B art intake/review gate** without changing the live combat:
- `scripts/dev/import_animation_pack2_candidate.py` — developer offline Python/Pillow importer: validates true 576×480 RGBA 6×5 96px frame grids with required state counts (4/6/6/3/6), rejects empty/opaque/repeated Walk and Attack/cropped corners, warns if alpha sole is outside y87–94 or art hits horizontal cell bounds; writes **lossless WebP Base64** files for Godot. Tested via existing grounded pack-1 image (accepted, warnings for some cell edges) and an opaque fake sheet (rejected).
- `assets/pixel/units/combat_units_anim_pack2_candidates/README.md` — staging folder conventions, no fake candidate assets stored.
- `scripts/dev/unit_animation_candidate_validator.gd` — Godot-only role-specific candidate loader with structured validation errors/warnings and standalone `SpriteFrames`, independent of the game loader.
- `scripts/dev/unit_animation_pack2_preview.gd` + `scenes/dev/unit_animation_pack2_preview.tscn` — new F6 preview displaying approved static v4 models next to *optional* staged candidate frames and state-switch buttons. Without valid candidate assets, it deliberately displays `ОЖИДАЕТ АРТ`.
- `docs/UNIT_ANIMATION_PACK2.md` — Stage B commands, QA gates and honest boundary between prepared infrastructure and uncreated artwork.

**Live combat unchanged:** Knight is intentionally v4 static with readable boots and -8px floor offset; Ranger, Mage, Skeleton, Bone Archer have existing v2 frame animation; Thrall, Bellkeeper, Crypt Guard and Warden stay static v4 plus Stage A attack FX. No new candidate assets enabled and no balance/art/UI changes. Godot editor unavailable in this environment; F6 smoke of both Pack 2 review scenes still pending.

**Next meaningful work:** actual authored distinct poses (including two readable boots and role-specific weapons) for the four enemies, staged and visually inspected *before* adding to `MisdealUnitAnimationLibrary`. Do not simulate 25 fake frames by stretching one v4 sprite or cropping a full-scene screenshot. GitHub is source of truth.

---


## Latest implemented state — 2026-10-12 — Undead Animation Pack 2 Stage A, role-specific contact VFX

Following the static Knight v4 fix, the user said to continue. **Direct GitHub commits** added distinct *brief attack-contact* effects for the four remaining static enemy roles without pretending we have authored animation frames. See `docs/UNIT_ANIMATION_PACK2.md` for the precise scope and local tests.

- `scripts/battle/unit_attack_visuals.gd`: transient `Line2D` + Tween accents tied to a valid attack target: Bone Thrall dual claw lines (0.17–0.21 s), Grave Bellkeeper small green-gold ripples (0.27–0.36 s), Crypt Guard bronze crossed clash (0.19–0.23 s), Bone Warden red/orange floor pulses and heavy slash (0.19–0.36 s). Each visual effect automatically frees its nodes, touches no health/stat code, and does not telegraph future damage.
- `scripts/battle/unit.gd`: preloads this helper and invokes `ATTACK_VISUALS.spawn(visual_role, get_parent(), primary_target.position)` inside the existing `_play_attack_feedback()`; `_attack_target()` still immediately applies all original damage, hitstop and optional splash. Other roles no-op.
- `scripts/dev/unit_undead_fx_preview.gd` + `scenes/dev/unit_undead_fx_preview.tscn`: standalone F6 gallery instantiates real `scenes/battle/unit.tscn` for four enemy roles using existing static v4 art, and provides per-role `ПОКАЗАТЬ УДАР` buttons that invoke the identical VFX helper without changing HP.
- **Unchanged:** Knight static v4, animated Ranger/Mage/Skeleton/Bone Archer, all unit silhouettes/floor offsets, arena/card art, table, playable combat rules and HUD. **NO new frame sprite sheets** for four enemies — Pack 2 **Stage B** still requires bespoke pixel-art animation assets with verified leg/weapon silhouettes before any live art switch.

**Static verification passed** for all GitHub files and shared helper hooks. Godot 4.7.x unavailable; user local smoke: `git pull`, F6 preview, then fight Bellkeeper, Thrall, Crypt Guard and Bone Warden to check effect duration/grounding/performance. Do not declare Pack 2 fully animated.

---


## Latest implemented state — 2026-10-12 — Knight temporarily restored to static v4 artwork

**User requested an immediate art replacement after screenshots showed Knight's legs are unreadable, despite repeated upward Y-offset changes.** Implemented in GitHub `main`, code commit `1a1141d7e33c32f5ef3c8aa8da94acfc4bcec6c5`. The current `scripts/battle/unit.gd` uses `STATIC_COMBAT_ART_ROLES := ["knight"]`: `BattleUnit._ready()` skips `ANIMATION_LIBRARY.get_frames("knight")` and renders `_get_art_texture()`, which loads the existing approved **v4 Knight** tile at index (0,0). This old tile has separate visible boots, unlike the Pack 1 animated Knight whose legs/pose are not legible. All Ranger, male Mage, Skeleton, Bone Archer animations remain ACTIVE. Knight attack/hit tweens, HP bar, facing, team, targeting, placement, stats and fight logic remain active on the static art.

**Knight-only floor baseline was reset** from animated `-16 px` correction to `-8 px` for v4 static: v4 alpha boots reach tile y≈94 in a 96px cell; with scale 1.28 and static base art Y -16, an extra -8 brings pixel soles close to the existing floor contact y≈36. This is sprite positioning only; combat world position and ring remain unchanged. Existing animated Knight `combat_units_anim_v1`/`v2` atlas files are retained for preview/rollback and later complete replacement, not deleted. The 5-role F6 animation gallery intentionally still displays the archived animated Knight; the live fight no longer does.

**LOCAL CHECK PENDING**: `git pull`, enter Bone Swarm / Grave Crossroads. Knight should show **two distinct boots/legs** in preparation and on attack, touching the blue contact ring without clipping into the ground. Ranger, Mage, Skeleton and Bone Archer still switch frames. Godot runtime cannot be launched from GitHub connector. Don't resume role-offset pixel nudging as a substitute for redrawing the bad animated Knight frames.

---


## Latest implemented state — 2026-10-12 — Knight visual floor offset −16 px

User explicitly requested a further **4 px upward** Knight lift. Committed to `main` in `scripts/battle/unit.gd`: `ROLE_FLOOR_OFFSETS["knight"]` changed from `-12.0` to **`-16.0`** (code commit `11f904b003430f43e6d785a2b1bd4ed80fcc666b`). All other roles, art, animation, combat logic, positioning and UI unchanged. Local Godot check: `git pull`, inspect Knight boots relative to blue floor ring on the Bone Swarm arena.

---


## Latest implemented state — 2026-10-12 — Knight visual floor offset −12 px

Following another in-game Bone Swarm screenshot, the user requested lifting the Knight by 2 more pixels. Implemented in GitHub `main`, code commit `6a5ac695c12a13de73860113e101618a499f026d`: `scripts/battle/unit.gd` now sets `ROLE_FLOOR_OFFSETS["knight"] = -12.0` (previously `-10.0`). Ranger stays `-6.0`, all other units unchanged. This only affects the existing `_art_rest_position()` visual offset; it does not change world coordinates, collisions, attacks, animation frames, arenas or HUD. Godot runtime test pending. Next: `git pull`, compare Knight boots with its blue contact ring in Bone Swarm before and during combat.

---


## Latest implemented state — 2026-10-12 — Knight visual floor offset −10 px

User approved another two-pixel upward adjustment for Knight after a three-hero Cemetery Ambush screenshot. Committed code directly to `main`: `scripts/battle/unit.gd` now sets `ROLE_FLOOR_OFFSETS["knight"] = -10.0` (previously −8.0), code commit `8d69a5812d98483f7c78c7fc800d50bcb7d09ee7`. Ranger remains −6.0, Mage −4.0, Skeleton and Bone Archer −7.0. Only the existing `_art_rest_position()` visual sprite offset changes; no world coordinates, collisions, animation assets, AI, tactics, scene layout or other roles changed. User should `git pull`, check Knight's boots against its blue contact ring in Cemetery Ambush and while attacking. No local Godot test was run.

---


## Latest implemented state — 2026-10-12 — Knight sprite raised another 2 px

User requested another 2 px upward optical adjustment for Knight after comparing live arena screenshots. Changed only `ROLE_FLOOR_OFFSETS["knight"]` from `-6.0` to `-8.0` in `scripts/battle/unit.gd` (commit `2452e6945396c257ce8ce5b71df15f012a1e7aca`). Ranger remains `-6.0`; other roles, the animated v2 assets, physical unit positions, battle rules and UI are unchanged. The change flows through existing `_art_rest_position()` for idling, moving and combat feedback. Local Godot review remains: `git pull` and check Knight boots relative to its contact ring in Bone Swarm and Grave Crossroads.

---


## Latest implemented state — 2026-10-12 — Knight floor calibration refinement

User compared Knight and Ranger in two updated in-game screenshots and suggested the same floor alignment. Adjusted only `ROLE_FLOOR_OFFSETS["knight"]` in `scripts/battle/unit.gd` from **−4 px to −6 px**, matching the Ranger. The renderer's existing `_art_rest_position()` applies it to idle/movement/attack recovery without modifying position, attack mechanics, shadow drawing, scale, art assets or UI. Knight and Ranger now share a −6 px visual lift. Code commit: `61c3cc291c9a0197fdce065af7385871b1bb348e`. **Godot local visual review pending**: `git pull`, view Bone Swarm and Grave Crossroads during placement and battle; check Knight boots against its ground ring and Ranger, no new hovering.

---


## Latest implemented state — 2026-10-12 — Per-role unit floor calibration

After the user confirmed that Pack 1 animations look good but **feet still appear buried in the floor** (new screenshots of Bone Swarm and another arena), we committed a targeted **visual-only** height correction to `scripts/battle/unit.gd` on `main` (code commit `53c998cd7cd8cd124a21e26d074b9a7d3a201695`).

- Added a data-driven `ROLE_FLOOR_OFFSETS` table and `_get_role_floor_offset()`: Knight -4px, Ranger -6px, Mage -4px, Skeleton -7px, Bone Archer -7px, Bone Thrall -6px, Grave Bellkeeper -5px, Crypt Guard -6px, Bone Warden -6px.
- `_art_rest_position()` now applies the role correction **after** its existing scale-aware animated 96px/sole-y=92.5 contact computation; the same table also visually lifts v4-static enemy silhouettes that do not use `SpriteFrames`. Each value is local to the sprite, not the `BattleUnit` world position.
- Applied the common rest position immediately in `_ready()`, and in static idle/breathing and static death tween; animated idle, hit displacement and every attack tween already reference that same helper. Thus no snap back to buried feet when changing animation state, finishing an attack or starting the battle.
- **Unchanged:** arena art and ground shadow ring at local y=36, unit world coordinates, physics/spacing, targeting and attack rules, HP bar/name offsets, team facing and animation frame assets. Pack 1 v2 still active, no new spritesheets.
- **Verification:** repository source checks pending. No Godot executable available here; local `git pull` and screenshots in Bone Swarm and Cemetery Ambush before/after Fight are still required to confirm optical height and flag if any role needs another 1–2px adjustment.

---


## Latest implemented state — 2026-10-12 — Animation Pack 1 grounding/jitter hotfix

**Implemented directly in GitHub `main` after the user's screenshots of Bone Swarm and Graveyard Ambush:** the first animation atlas produced **orphan legs/heads from adjacent sheet rows**, and unit soles were not consistently aligned to the existing battlefield floor contact. The old v1 atlases remain intact for rollback.

Five cleaned v2 assets are now in `assets/pixel/units/combat_units_anim_v2/{knight,ranger,mage,skeleton,bone_archer}.webp.b64`. Each asset is a transparent 576×480 WebP (6×5 x 96px cells). Reprocessing removes detached border fragments mistakenly imported from adjacent sprite-sheet rows (including the first four Knight walk frames), preserves character pose/weapon, and normalizes the final opaque sole contact to atlas y=92 across **all 125 processed frame cells (124 live character frames; the detached Mage projectile cell remains excluded)**. Exact Base64 content equality against generated source exports and per-frame sole min/max (92/92) were checked for each of five assets. Original v1 remains untouched.

`scripts/battle/unit_animation_library.gd` now prefers v2 assets and reduces idle 5→2.7 fps and walk 9→7 fps; attack/hit/death fps and the Mage projectile skip remain unchanged. `scripts/battle/unit.gd` determines the resting sprite position from its real art scale and the existing local-floor ring y=36, so boots meet floor regardless of the role's `visual_scale`. Attack position tweens return to this grounded rest, rather than legacy constant (-16). Each unit begins idle at a slightly different frame phase. A 0.18s walk-hold prevents strobing idle/walk at tight separation or arena edges.

**Unchanged:** art of the arena/card game, combat rules and damage timing, AI, physical placement and unit coordinates, silhouette facings, HP/name offsets, role definitions, unsupported-unit v4 static fallback. **Local Godot 4.7.x playtest still pending.** Next: user `git pull`, check Bone Swarm and Graveyard Ambush idle before Fight, movement/attack at melee contact and corpse-grounding; also test F6 gallery. See `docs/UNIT_ANIMATION_PACK1.md`, section `Grounding / start-motion repair`.

---


## Latest implemented state — 2026-10-12 — Unit Animation Pack 1 ACTIVE

The user approved connecting the five freshly generated animation sprite sheets. Five **actual frame-by-frame animations** are now wired into production `BattleUnit` on `main`: `knight`, `ranger`, `mage` (male), `skeleton`, `bone_archer`. Each role has a 576×480 transparent Base64/WebP atlas containing 6×5 cells at 96px, stored at `assets/pixel/units/combat_units_anim_v1/{role}.webp.b64`. Sprite action rows: idle (4), walk (6), attack (6; male Mage skips projectile-only cell and uses 5), hit (3), death (6).

- New `scripts/battle/unit_animation_library.gd` lazily decodes/validates each atlas, constructs one cached `SpriteFrames` Resource per role from `AtlasTexture` cells and sets state framerates/loops.
- `scripts/battle/unit.gd` now selects the role's frame resource when present, advances `ArtSprite.texture` through idle/walk/attack/hit/death while retaining its existing Sprite2D properties and all existing combat feedback; `RimSprite.texture` synchronizes on frame changes. Animated roles no longer use the previous fake squeeze/stretch idle. Pre-combat state idle, movement measured from actual computed step, one-shot attacks and hits, death holds last frame.
- No change to attack timing/damage resolution, AI, battlefield layout, targeting, tactical orders, sprite facing, rewards or the approved arena artworks. Characters without animation assets and invalid/missing role atlases **fall back to approved static v4**.
- New standalone `res://scenes/dev/unit_animation_pack1_preview.tscn` with actual `AnimatedSprite2D` test sprites, five-state buttons and all role names for F6 visual review. The production node intentionally remains `Sprite2D` to avoid disrupting its tween/outline code.
- `docs/UNIT_ANIMATION_PACK1.md` records source and frame order, role mappings, compatibility, local smoke tests and Pack 2 next steps.

**Verification status:** all five committed Base64 atlas files were compared for exact content equality against the generated assets; source/role/state paths and preview links passed static checks. No Godot binary was available here; **user must `git pull` and run F6 gallery plus real fights** to validate code parsing, transparency, grounding, alignment, flips, HP labels and combat flow.

---


## Latest implemented state — 2026-10-12 — Design System 1.0 Package 3 / core Screen Pass

The user explicitly requested Package 3 following Foundation and the shared Component Library. **Committed in `main`: focused production-screen migration**, not a new interface redesign. It covers `scripts/main.gd`, `scripts/intro/intro.gd`, `scripts/class_select/class_select.gd`, `scripts/table/table.gd`, `scripts/battle/battle.gd` and `scripts/run_end/run_end.gd`.

- `MisdealUIKit` now owns four extra helpers: `apply_screen_copy` (contrast/shadow without changing authored size/position), `apply_splash_hotspot` (font states without touching transparent splash/skip area), `apply_offer_card_frame` (the prior normal/hover/pressed frame math including boss/wizard mark/held priority) and `apply_battle_order_choice` (visible selected highlight for current tactical toggle).
- **Table:** moved the real offer-card framing from local `StyleBoxFlat` constructors into `MisdealUIKit`; frame colors, border thickness, boss, held and marked states are preserved; top HUD stats and deck/discard copy have shared text contrast.
- **Battle:** adds an explicit accented selected tactical button on order changes, while retaining the order availability/layout, toggle state and attack/stat logic. Shared contrast updates to run condition, battle description, placement hint, objective and run metadata without resizing or covering the arena.
- **Main / Intro:** transparent interactive hotspots are still transparent over the approved illustrated screens. **ClassSelect / RunEnd:** longer contextual instructions, rule/status and summary text are easier to distinguish from richly painted backgrounds; class color identities and original animations remain.
- **UNCHANGED:** `.tscn` geometry, battle floor, unit sprites, enemies and tactics rules, card deal/held semantics, painted table and arena art, Fate Spread, end-game outcomes and existing transition timings.

Design contract and smoke matrix: `docs/DESIGN_SYSTEM.md` Section 8. Static checks confirm updated methods and callsites in all six scripts, and no `RunState` dependency in UIKit. **No Godot runtime available here, so run/visual tests remain pending** at 1280×720, especially five available tactic buttons and the three special card borders. Only make screenshot-driven adjustments next; no mass re-layout was approved.

---


## Latest implemented state — 2026-10-12 — Design System 1.0 Package 2 / Components

**Committed to `main`: reusable visual components and a working review scene in Godot source (not yet locally run).** The single canonical `scripts/ui/misdeal_ui_kit.gd` now provides `apply_battle_panel` and `apply_battle_button` (migrated pixel-compatible from `scripts/battle/battle.gd`), `apply_card_surface`, `apply_selected_button`, `apply_tooltip_panel`, and `make_tooltip`. Original `apply_panel` / `apply_chip` / `apply_action_button` / `apply_card_button` / Foundation roles remain available. Selection styling is visual-only and does not mutate gameplay button logic. Existing battle's six modular panel surfaces and seven compact button style callsites now use the shared kit; the numeric layout, opacity, colors, borders, and 2px corner radii are retained.

- New **opt-in** native hover tooltip button: `scripts/ui/misdeal_tooltip_button.gd`, which returns an actual styled `PanelContainer` to Godot's tooltip pipeline.
- Standalone interactive gallery: `res://scenes/dev/design_system_components_preview.tscn` with `scripts/dev/design_system_components_preview.gd`; sample enabled/disabled/hover/pressed buttons, visually selected tactical options, sample card surfaces, chip, custom hover tooltip, and the same low-opacity battle chrome. **The gallery is not routed from live gameplay.**
- `docs/DESIGN_SYSTEM.md` Section 7 contains exact component APIs, states, usage boundaries and Godot F6 test instructions. This is the confirmed Component Library implementation, not merely future planning.

**Scope safeguard:** no environment/card/unit artwork, combat mechanics, tactical order availability, encounter definitions, or scene layout was changed. Table UI has not been restyled, and native tooltips in existing game scenes remain as before. No new global Theme or autoload was introduced.

Verification: GitHub source/static references reviewed. The development environment had no installed Godot binary; user must run F6 Components Preview and smoke test Main → Table → Battle for visuals/parse errors. **Package 3 / Screen Pass is not started; wait for local Component preview review.**

---


## Latest implemented state — 2026-10-12 — Design System 1.0 Foundation

**Foundation committed to `main`; existing production screen layouts are unchanged.** The current `MisdealUIKit` is the one canonical runtime source of UI colors, with additional semantic background/text/status tokens, typography sizes, 4px-based spacing scale, 1/2/3px border weights, square corners, button minimum heights, reference 1280×720 viewport and advisory UI layering bands. The opt-in helpers `apply_text_role` and `apply_button_minimum` allow future/migrated Godot controls to consume these tokens without resizing current authored battle/table controls.

Source of truth for usage and visual rules: `docs/DESIGN_SYSTEM.md`. Separate runnable visual specimen: `res://scenes/dev/design_system_foundation_preview.tscn` + `scripts/dev/design_system_foundation_preview.gd`. It renders palette swatches, live kit-styled action buttons/panels and Cyrillic text roles. This is not in navigation, and adds no autoload, plugin or gameplay dependency.

**Not implemented yet:** wholesale migration of combat/table/menu layouts, reusable `.tres` Theme architecture, new fonts, UI animations/motion settings or responsive scaling beyond current Godot viewport. These remain Package 2/3 and require visual review; the accepted Variant C table, Gothic v2 arenas, v4 unit art and combat mechanics remain untouched.

Verification: GitHub paths/source text and helper call-sites are reviewed. **Godot editor/runtime unavailable here**; local smoke: `git pull` then open `res://scenes/dev/design_system_foundation_preview.tscn` and press F6, and confirm normal Main → Table → Battle remains unchanged.

---


## Latest implemented state — 2026-10-12 — Male Mage + enemy facing correction

The user reported that undead units looked as if they were fighting with their backs to the heroes, and asked for the approved **male** version of the Mage. Both corrections are now committed to `main`.

- `assets/pixel/units/combat_units_v4/mage_male.webp.b64` is a transparent 96×96 WebP cutout from the most recently approved nine-character roster (male mage with beard, purple robe/hat and glowing staff); the lossless PNG tile is archived at `assets/source_archive/unit_art_v4/mage_male_tile.png.b64`. These are text-packaged image bytes consistent with the existing v4 system.
- `scripts/battle/unit.gd` now uses the separate male Mage texture only for `visual_role == "mage"`, with size/format validation and fallback to its previous v4 atlas cell if missing. Other eight characters still use the exact approved v4 288×288 atlas; the v3 fallback remains intact.
- At preparation/spawn, enemy `ArtSprite.flip_h` is set true to face screen-left (the hero side). During combat both teams face their current live target based on relative global X (with 12px deadzone), while `RimSprite.flip_h` stays synchronized. This avoids flipping toward the wrong side after units cross each other. Hit boxes, stats, targeting, move speeds, mechanics, placement, arena art and tactical orders are unchanged.

**Static checks:** the GitHub binary-text tile and code were committed, PNG/WebP tile dimensions (96×96) and transparency checked locally, loader/resource refs verified. **Godot runtime test pending:** `git pull`, check mage is visibly male and the undead face left before Fight / toward their enemies during movement, attacks and target-switches in Crypt Patrol, Iron Wall and Warden. Godot binary unavailable in the development environment.

---


## Latest implemented state — 2026-10-11 — Approved Unit Art v4 replaces nine combat miniatures

**Implemented in `main`** after user approval of the new nine-role concept atlas. Production 288×288 transparent RGBA WebP artwork is stored as Base64 text in `assets/pixel/units/combat_units_v4/atlas.webp.b64`, with 96×96 cells arranged by the existing BattleUnit tile indices (row 0: knight / ranger / mage; row 1: skeleton / bone_archer / grave_bellkeeper; row 2: bone_thrall / crypt_guard / bone_warden). The generated concept cutouts were reworked into tiles and stray disconnected fragments removed before committing.

`scripts/battle/unit.gd` now loads this v4 WebP first with `Marshalls.base64_to_raw` + `Image.load_webp_from_buffer`, validates the expected 288×288 dimensions and caches the shared ImageTexture to avoid decoding per combatant. The prior v3 Base64-PNG parts are retained intact and loaded only if v4 cannot decode, providing simple rollback. The exact lossless 288×288 source master is archived as `assets/source_archive/unit_art_v4/combat_units_v4_master.png.b64` for future edits.

**No combat stats, AI, arena art, floor/deployment rules or tactical HUD changed.** Bone Raider and Crypt Sentinel still intentionally share the Bone Thrall and Crypt Guard silhouettes respectively through their authored `.tres` visual_role values; those archetype assets have not yet been uniquely drawn.

**Local Godot 4.7.x verification still required:** `git pull`, enter a battle with Knight/Ranger/Mage and Bone Archers, visually check transparent sprite edges, feet/shadows, z-order, HP/name labels, initial placement, drag, combat animations and Warden boss (including reinforcements). Godot executable was not available in this environment. This implements the approved concept-derived 96px atlas; it is not a high-resolution rigged animation set.

---


## Latest implemented state — 2026-10-11 — Unit Readability Pass

Local screenshots of Grave Crossfire and Gallows Volley showed miniatures disappearing into high-detail arena backgrounds despite improved ground placement. **Implemented in `main`:**

- `scripts/battle/unit.gd`: hero pixel-art sprites grow from 1.16× to 1.28× (about +10%); regular enemies from 1.16× to 1.25× (about +8%); Bone Warden from 1.18× to 1.24×, preserving its special `visual_scale`. Combat body radii/stats are unchanged.
- Brighter restrained team silhouette outlines using existing `RimSprite` at 1.06× art scale (cool for heroes, warm for foes) instead of heavy neon; very subtle layered localized darkening behind each silhouette helps contrast with busy cobblestones. Cold/amber arena tint no longer dims art as much.
- Adjusted art pivot (baseline `ART_BASE_POSITION=-16`) to keep sprites planted at the established foot shadow Y=36; resized unit HP/name offsets to avoid clipping into enlarged art, with separate boss treatment. Existing ground shadows, colored team rings, and drag-only deployment visualization remain.
- `BattleUnit` hero clicking uses a sensible silhouette-sized pickup rectangle plus the old body-radius fallback, so the enlarged art is draggable from its visible upper body.
- `scripts/battle/battle.gd`: widened initial **hero** positions for all solo/duo/trio deployment profiles (deep line, split cave lanes, two pockets, Warden and default), preserving their legal `Rect2` ranges. After existing floor projection/clamping, the tightest trio starts about 115 px apart. Enemy spawn Resources and enemy tactics are unchanged; initial hero tactical geometry deliberately changes slightly.

No backdrop replacements, combat stat rebalancing, AI/attacks, rewards, tactics, or card flow changes. This is visual readability plus initial party-layout/picking polish.

**Static check completed:** inspected committed source and simulated floor projection + legal-placement clamps for all five spawn profiles and party sizes 1–3. Minimum pair separation for each trio is above 110 px; no local Godot 4.7 runtime available, so Godot parse/runtime and visual legibility still require user verification.

**Next local check:** `git pull`, examine trio at Grave Crossfire and Gallows Volley; confirm hero/archer/mage distinct silhouettes with clean HP/name labels, no spawn overlap, correct drag and placement glow; run a full battle including a swarm and the Warden.

---



## Latest implemented state — 2026-10-11 — Drag-only deployment highlight

The latest screenshots of Grave Crossfire and the Crypt arena rejected the gold slot grid and bounding rectangles as ugly/debug-like. **The always-visible deployment UI is superseded in code**:
- `scripts/battle/deployment_floor_markers.gd` uses the same legal `Rect2` regions, but draws nothing while idle. It polls the few live hero units, and only while one is being dragged draws four translucent feathered ellipses as a restrained warm floor glow (no rectangle edge, no 3×2 slot circles or baked marks). The overlay stops processing and hides when battle begins.
- `scripts/battle/unit.gd` now shows its extra drag marker around a hero only during that hero's drag. The ordinary contact shadow/team ring remains for grounding and identification.
- No arena WebP was changed, and no battle spawn geometry, stats, target logic, rewards or tactics were modified by this follow-up. The prior v2-grounding and legal placement region changes remain in force.

**Local test pending:** after `git pull`, enter a battle without touching units (no rectangular/circle slot overlay), grab/drag a hero (soft glow shows both legal pockets/lanes and follows legal interaction), release (glow goes away), press Fight (no overlay), verify all 3–5 tactical orders still display correctly. Godot runtime has not been run here.

---


## Latest implemented state — 2026-10-11 — Battle floor and deployment correction

Local screenshots from Bone Swarm, Last Bell and Iron Wall showed units apparently hovering above the new v2 backgrounds: legacy encounter spawn Y positions (some as high as 145–165 in UnitsLayer coordinates) placed figures on distant scenery instead of the stone floor. The previous translucent deployment panels were also nearly invisible.

**Implemented in main:**
- `scripts/battle/battle.gd` maps old authored spawn-depth Y values into arena-floor coordinates while preserving encounter-specific X positions and relative front/back ordering; this path also applies to boss reinforcements and every other call to `_spawn_unit`.
- Each unit's movement clamp and the hero drag regions now use a floor-only Y range (approximately local 279–442, cave slightly lower); headings, the battle controller, attack timings, tactics, enemy counts and stats remain unchanged. This DOES change battlefield depth geometry intentionally to match the new art.
- Existing split-band/deep-line/two-pocket/Bone Warden deployment profiles are preserved conceptually but moved down onto the real floor; freshly enabled heroes are clamped into the actual legal placement regions.
- `scripts/battle/deployment_floor_markers.gd` draws subtle parchment/chalk ellipse guides and region outlines from **those same regions**; no hardcoded decorative slots and no blue debug panels. Markers disappear when Fight starts. The circles are guidance for free dragging within legal regions, not a locked tile grid.
- `scripts/battle/unit.gd` anchors contact shadows and team rings near sprite soles and uses a matching floor-plane placement ring.

The approved v2 backdrop WebPs remain intact. **The newly illustrated experimental arena plates with painted circles from the chat were NOT uploaded**: live Godot floor guides are authoritative and avoid future divergence between backdrop art and actual legal movement. `firing_square` and `bone_ritual` retain their v1 art and use the same runtime floor correction.

**Pending local Godot validation:** check no parse errors after `git pull`; test one/two/three heroes, drag into/around every allowed lane, verify the rings match valid drag areas, no unit hanging over rocks/architecture at spawn or during combat, and full battle resolution in Bone Swarm, Last Bell, Iron Wall, Gallows and Bone Warden (including reinforcements). No headless Godot executable was available in the connector runtime; no runtime claim is made.

---


## Latest implemented state — 2026-10-11 — Arena Redraw v2 package 1

The user approved the corrected 10-arena concept pack after rejecting castle-saturated horizons. **All ten images are now committed as native 1280×720 WebP assets** under `assets/pixel/battle/arenas/arena_redraw_v2/`, and `AuthoredBackdrop` resolves the corresponding arena IDs directly to those files.

Updated IDs: `crypt`, `graveyard`, `gallows`, `ossuary`, `warden`, `bone_crush`, `bone_swarm`, `grave_crossfire`, `iron_wall`, `last_bell`. Unchanged IDs: `firing_square`, `bone_ritual`, still using `arena_redraw_v1/*.webp.b64` until package 2. The loader now accepts both native WebP bytes and existing Base64-WebP text; old v1 assets are preserved for safe rollback.

Approved visual constraints: one recognizable environment/landmark per scene, no repeated distant Gothic castles, restrained edge decor, quiet floor, existing Misdeal moonlight/fire/crimson palette. No spawning, placement rules, battle controller, combat stats, tactical orders, encounter compositions or UI geometry were changed.

**Local verification pending:** `git pull`, open each of the ten battles, check matching background, unit legibility, legal deployment vs visible floor, and full fight completion. Specifically inspect the final Warden arena for unit contrast and the Bone Swarm cave for ground placement. No local Godot run was possible in this session.

See `docs/ARENA_REVIEW_2026_10_11.md` for the design map and `docs/VISUAL_ASSET_REGISTRY.md` for exact runtime paths. Package 2 (`firing_square`, `bone_ritual`) remains outstanding.

---


## Session closeout / next-chat entry point — 2026-10-11

The arena-redraw and battle-HUD context is fully checkpointed in GitHub. The next chat should begin by reading `docs/HANDOFF.md` first, then validating the new 12-arena set locally rather than proposing another speculative visual rewrite.

Current source of truth:
- modular battle HUD is the accepted current code direction after the rejected full-width slab version;
- all 12 active arena IDs resolve through `assets/pixel/battle/arenas/arena_redraw_v1/*.webp.b64`;
- `AuthoredBackdrop` base64-decodes those native 1280×720 WebPs at runtime;
- gameplay/spawn/balance logic was intentionally left unchanged by the arena replacement.

## Unified arena redraw v1 — all 12 battle arenas — 2026-10-11

All active battle environments now use one coherent 1280×720 authored set under `assets/pixel/battle/arenas/arena_redraw_v1/`.

The full active arena roster is covered: `crypt`, `graveyard`, `gallows`, `ossuary`, `warden`, `bone_crush`, `bone_swarm`, `grave_crossfire`, `iron_wall`, `last_bell`, `firing_square`, and `bone_ritual`.

The visual goal is combat readability: broader quiet floors, stronger large landmarks, and less fine detail directly behind units. `scripts/battle/authored_backdrop.gd` now routes every active arena ID through this single production set.

Combat logic, encounter composition, placement rules, tactical orders, rewards and balance were not changed. Next validation is local: verify unit contrast and report only concrete visible-floor / deployment mismatches.

## Battle HUD modular cleanup — 2026-10-11

The first readability fix solved tactical-button capacity but was locally rejected as visually ugly because it replaced the screen with two large black slabs. That pass is superseded.

Current battle composition:
- the full-width top bar is gone; encounter text and run status live in two compact translucent plates;
- the full-width bottom footer is gone; preparation uses three separate islands: tactics, Fight/target preview, and an optional Wizard-condition plate;
- when only the three baseline orders are available, they expand to fill the tactical plate; four/five-order states redistribute the same width without abbreviating **НЕПОВИНОВЕНИЕ**;
- battle-only panels/buttons use lighter one-pixel chrome instead of the heavy shared menu/event treatment;
- the authored arena remains visible between and around the HUD islands;
- the Fight island disappears with the rest of preparation UI when combat begins.

No combat rule, spawn path, attack timing, targeting behavior, reward or encounter stat changed.

## Battle readability / tactics footer rework — 2026-10-11

The live battle screen was rejected locally because the command footer was cramped and unlocked tactics could collapse into tiny abbreviated buttons. The battle presentation has been repacked without touching spawn/combat timing:

- a dedicated 170 px footer now owns commands instead of fighting the arena for the same pixels;
- the tactical area reserves five full slots, so **НАТИСК / ОХОТА / СТРОЙ / ЖЕРТВА / НЕПОВИНОВЕНИЕ** never need the old 72 px squeeze;
- **НЕПОВИНОВЕНИЕ** is shown by its full name;
- the order explanation gets a wide dedicated text area;
- target preview and the primary **БОЙ** action have their own center column;
- Wizard side objectives live in the right footer column instead of floating over the battlefield;
- the top encounter/status text now sits on a subtle framed plate rather than directly over busy arena art;
- the live unit/combat floor is moved upward and its vertical bounds reduced so units do not disappear beneath the footer;
- fallback arena resizing now uses nearest-neighbor rather than Lanczos to avoid softening pixel art.

This is a presentation/layout pass only. Encounter composition, stats, tactical effects, targeting, attack cadence, spawn lifecycle, results and rewards are unchanged.

## Session checkpoint — Combat Expansion art/source masters archived — 2026-10-11

The six approved Combat Expansion v1 arena/card concepts are not just generated mockups anymore: dedicated production exports are wired live, and the original composite masters are archived in GitHub under `assets/source_archive/combat_expansion_v1/` for future recrops.

Next verification is local only: fresh run, new card art, matching arena art, normal unit spawn/deployment. No additional combat-controller changes are required for this checkpoint.

## Combat Expansion v1 dedicated visual pass — 2026-10-11

The six recently added combat encounters have graduated from temporary art reuse to dedicated production visuals approved in the current session.

Dedicated battle backdrops (native 1280×720 WebP):
- `bone_swarm` — rib-cage/bone-yard arena;
- `grave_crossfire` — moonlit graveyard crossfire lane;
- `iron_wall` — shielded crypt corridor;
- `last_bell` — twin-bell necropolis;
- `firing_square` — gallows firing yard;
- `bone_ritual` — ossuary ritual chamber.

Dedicated table-card illustrations (448×274 WebP) live under `assets/pixel/ui/combat_expansion_v1/cards/` and are loaded through `CardArtCatalog` via runtime WebP decoding. The former semantic aliases are removed.

Each encounter now owns a unique `arena_id`. `AuthoredBackdrop` selects the exact image, while `battle_visual.gd` and `BattleUnit.set_arena_presentation()` deliberately map those unique IDs back to the closest validated atmosphere/tint family. This preserves readable unit presentation and avoids introducing a second environment style layer.

Gameplay is unchanged by this visual pass: encounter compositions, stats, deployment geometry, targeting, rewards and the twelve-card Act 1 length remain as in Combat Expansion v1.

## Combat Expansion v1 — six new random fights — 2026-10-11

The Act 1 random card pool now contains six additional combat cards, distributed two per tier so full runs can see materially different enemy compositions without changing the twelve-card act length.

Tier 0:
- **КОСТЯНОЙ РОЙ** — four fast, fragile Bone Raiders; tests early anti-swarm/AOE readiness.
- **МОГИЛЬНЫЙ ПЕРЕКРЁСТОК** — central melee blocker plus two archers on separated angles; introduces crossfire pressure earlier than Gallows Volley.

Tier 1:
- **ЖЕЛЕЗНАЯ СТЕНА** — two lighter AOE Crypt Sentinels with a protected archer; rewards target-priority choices rather than pure nearest-target attrition.
- **ПОСЛЕДНИЙ ЗВОН** — two Bellkeepers plus fast Raiders; prolonged combat strongly favors the enemy because the healers sustain each other.

Tier 2:
- **РАССТРЕЛЬНАЯ ПЛОЩАДЬ** — four archers behind a Sentinel; late ranged-pressure check with deep-line deployment.
- **КОСТЯНОЙ РИТУАЛ** — Sentinel + Bellkeeper + three Raiders; mixed late encounter with frontline, sustain and rush pressure simultaneously.

New UnitData prototypes:
- `bone_raider.tres`: faster/harder-hitting derivative of the Bone Thrall combat family, lower durability than a normal Skeleton;
- `crypt_sentinel.tres`: lighter Crypt Guard derivative with smaller AOE and lower HP/damage than the elite Guard.

Both deliberately reuse existing production silhouettes (`bone_thrall` / `crypt_guard`) for this gameplay-first pass. Dedicated new enemy art should only be commissioned after local runs show the archetypes are fun enough to keep.

Pool integration:
- all six cards are in `RunState.CARD_PATHS` and `ACT1_CARD_IDS`;
- each keeps the existing tier-forced-combat rules, so the act remains twelve resolved pre-boss cards rather than becoming longer;
- all six expansion cards now use dedicated approved 448×274 art; no temporary card-art alias remains;
- table threat tags and battle preparation text identify the encounter's actual tactical pressure before commitment.

Battle-safety note:
- spawn lifecycle, attack timing and result flow were not redesigned;
- `battle.gd` changes are limited to content-specific spawn/deployment profile aliases, preparation cues and Wizard start lines for the six new encounter IDs.

## Safe combat-feedback reintroduction — 2026-10-11

The user locally confirmed that the battle arena/units were restored after the full battle rollback. Combat polish has therefore resumed, but only through isolated presentation paths.

New safe layer:
- `scripts/battle/battle_motion_fx.gd` is mounted as a non-interactive full-screen overlay in `battle.tscn`;
- it connects directly to the existing tactical-order/Fight button signals and never calls spawn, encounter resolution, combat start/stop or RunState mutation;
- НАТИСК / ОХОТА / СТРОЙ show a short icon above each living hero when selected;
- ЖЕРТВА shows the same selection tell plus a restrained persistent red ground aura once combat is committed;
- НЕПОВИНОВЕНИЕ uses a restrained cold-blue defensive aura;
- Death Wager gets a very low-alpha red corner-frame tell so the arena reads as a wager state without changing the authored backdrop.

Existing stable `BattleUnit` combat timing remains intact. Only existing non-blocking feedback functions changed:
- ranged/magic tracers are slightly clearer;
- hit tint now reflects melee/ranged/magic source type;
- a purely visual "strong hit" threshold (>= 18 damage or >= 18% max HP) enlarges the damage number, kick and spark count;
- damage amount, cooldown, target selection, attack timing, movement, spawn and death logic are unchanged.

Safety invariant:
- `scripts/battle/battle.gd` was not modified by this pass;
- no `await` was introduced into attack/damage logic;
- future battle polish should follow this same isolated visual-only pattern unless a separate gameplay change is explicitly requested.

## Safe event-motion reintroduction — 2026-10-11

Event motion has been reintroduced in the smallest safe form after the earlier Act Choice template-screen and Whispering Well mini-art regressions.

Current implementation:
- `scripts/event/act_choice.gd`: after the event is fully initialized/configured/themed and the existing panel entrance starts, visible choice cards get a short ~0.17 s staggered settle;
- `scripts/event/whispering_well.gd`: the same entry-only stagger is applied after the stable Well text/art setup;
- no `button_down` commitment callbacks were added;
- no resolver timing, `RunState` calls, active-card initialization, art-source routing or result reveal code changed;
- battle files remain untouched.

This is intentionally less ambitious than the rejected Motion Pass 1 event patch. If local verification passes, further event motion should still be added one isolated behavior at a time.

## Motion polish pass 5 — Class Select + Intro + Squad dossier — 2026-10-11

A safe non-battle motion pass is live while the battle core remains on the stable pre-animation controller.

Class Select:
- the three protagonist cards reveal with a short stagger after the frame enters;
- choosing a protagonist focuses the chosen card and dims the alternatives for ~0.18 s before table navigation;
- protagonist selection logic remains unchanged.

Intro:
- frame-to-frame blackout timing remains unchanged;
- each loaded frame gets a very small one-shot settle (about 1.2% scale back to 100%) and neutral-color recovery;
- hint/skip controls fade in once on entry;
- there is no continuous camera drift or Ken Burns loop.

Squad dossier:
- overlay dim + dossier frame reveal once on open;
- switching hero tabs gives the selected tab, portrait frame and hero name a small focus beat;
- closing fades/scales the dossier out before freeing it;
- all displayed stats/fates/relic data are unchanged.

Battle safety:
- `battle.gd` and `unit.gd` were not touched in this pass;
- the empty-arena regression is now locally confirmed gone; battle polish may proceed only through isolated visual-only patches that do not alter spawn/controller flow.

### Full battle controller rollback after empty-arena regression

Restoring only `scripts/battle/unit.gd` did not recover locally: the preparation screen still showed no heroes or enemies. The battle controller itself has now been restored to the same last known-good pre-animation baseline (`aa8f9d5ed05134b4a3507995c22d845191c237b7`).

Current safety state:
- `scripts/battle/battle.gd` and `scripts/battle/unit.gd` are back on the stable pre-motion versions;
- battle unit spawning/deployment/tactics/objectives/Last Deal/result logic should therefore match the version that worked before the animation passes;
- battle-specific Motion Pass 2/3 additions are temporarily removed;
- Table, Reward, Fate Spread, Wizard/table ambience, scene transitions, Main Menu and Run End motion remain active.

Do not reintroduce battle motion as a broad controller patch. First verify that heroes/enemies render again; then add battle animation only in isolated functions with a local check after each patch.

### Battle unit spawn hotfix

A local screenshot after Motion Pass 4 showed the battle preparation screen with the entire party/enemy roster missing. The safest recovery was to restore `scripts/battle/unit.gd` from commit `ddae81ca7e385cfc77767c7a5fbd190f001a624c`, the last known-good version before the attack-windup/death-settle experiment.

Current state:
- hero/enemy unit rendering/spawn path is back on the stable pre-windup controller;
- attack anticipation and the new death-settle sequence from Motion Pass 2 are temporarily removed;
- battle tactical-order/result/Last Deal motion in `battle.gd` remains active;
- Fate Spread, Wizard/table ambience, reward motion and shell transitions remain active.

Do not reapply the previous `BattleUnit._play_attack_windup()` patch wholesale. Reintroduce combat-unit motion only as a smaller locally verified patch after confirming units render again.

## Motion polish pass 4 — Table ambience + shell transitions — 2026-10-10

Pass 4 is live in `main` and stays inside the accepted D099/D101 motion language.

Wizard table:
- `table_spread_visual.gd` now adds tiny translucent flicker halos aligned to the candle flames already painted into the exact Variant C plate;
- no procedural candle bodies/flames are redrawn, so authored art remains visually authoritative;
- a short ritual reaction overlay wakes the existing center-circle area on deal, Hold, card choice and Wizard reactions;
- the ritual overlay uses restrained semantic tints: warm red/orange for deal/choice/pleased, cold blue for refusal, stronger red for meddling;
- the physical deck stack gets a tiny scale/alpha response when a fresh deal starts;
- all ritual/deck reactions are presentation-only.

Scene transitions:
- the persistent blackout veil still performs the same safe old-scene/new-scene swap and keeps the same fast timings;
- destination scenes now tint that near-black veil very subtly: battle red-black, reward warm-black, event wine-black, run-end violet-black;
- no white flash or long cinematic transition was introduced.

Main menu:
- approved splash fades from ~84% to full alpha once on entry;
- Start appears with a short settle and gets a physical commit beat before Intro.

Run End:
- authored backdrop, title, Wizard line, summary panel and New Run action reveal in a compact hierarchy;
- New Run gets one commit beat before resetting the run;
- no looping ending-screen animation is used.

Animation safety:
- generic Act Choice and Whispering Well commitment motion remain intentionally rolled back;
- Table/Reward/Battle/Fate Spread/Wizard/Shell motion is currently active;
- next work should be local tuning or isolated missing-state polish, not another blanket animation framework.

## Motion polish pass 3 — Battle commands + Results + Last Deal — 2026-10-10

The next battle-interface motion pass is live in `main`.

Preparation / tactical UI:
- selecting a tactical order now compresses/releases the chosen button and lightly pulses the live order description;
- the underlying order logic, stats and targeting behavior are unchanged;
- pressing **БОЙ** now gets a ~0.18 s physical commit beat before the preparation HUD is hidden and the existing combat intro starts.

Side objectives:
- an objective success/failure now gives the side-objective panel one short scale/tint reaction;
- this is presentation only; objective evaluation and reward logic are unchanged.

Battle result:
- the result scrim/backdrop/title/subtitle now reveal in a compact staged sequence;
- visible result actions appear after the headline instead of being fully present on frame one;
- victory gets a restrained warm/positive title beat, defeat a restrained red beat;
- **ЗАБРАТЬ НАГРАДУ**, Last Deal accept/refuse and final-run exit now get a short button commit before navigation.

Last Deal:
- the offer gets one extra price/backdrop pulse after the base result reveal;
- no continuous pulsing is used;
- Last Deal availability, price, acceptance/refusal and retry logic are unchanged.

Animation safety remains:
- generic Act Choice commitment motion stays rolled back;
- Whispering Well commitment motion stays rolled back;
- future motion changes should keep using small isolated patches and local verification.

## Motion polish pass 2 — Battle + Fate Spread + Wizard reactions — 2026-10-10

Pass 2 is live in `main` and follows D099: motion communicates cause/effect and weight without becoming a delay tax.

Battle:
- `BattleUnit._attack_target()` now waits through a short role-specific anticipation before applying the existing hit.
- melee windup is ~0.08 s, ranged ~0.11 s, magic/support ~0.14 s;
- attack cooldown starts before the windup, so repeated attack cadence/DPS remains governed by the same `attack_interval`; this adds readable first-contact anticipation rather than a new balance modifier;
- melee pulls back, ranged draws back, and magic compresses/charges before the existing strike/tracer feedback;
- dead units now make a ~0.07 s stagger reaction before the existing settle/fade, making deaths less like instant sprite deletion;
- Bone Warden Phase II briefly warms the authored backdrop and arena overlay while the existing phase label appears. No generic screen shake was added.

Fate Spread:
- approved geometry, Hold/Discard layout and I–XIII composition remain frozen;
- opening the overlay now reveals visible cards around the ring with a short stagger;
- after entry, the current fate position (or XIII when boss-due) gets one restrained focus beat;
- 4/8/12 milestones now emphasize the milestone card, phase/count labels and ritual seal in addition to the existing XIII reaction;
- no history/progression rules changed.

Wizard table:
- the painted Wizard is still static art;
- wager offer/accept/refuse, Wizard meddling and accepting a Wizard-marked card trigger a brief authored-backdrop tint pulse;
- there is no continuous bobbing, face warping or skeletal animation of the painting.

Known animation safety state:
- Table Hold/discard motion and Reward motion remain enabled from Pass 1.
- Generic `act_choice.gd` commitment motion remains rolled back after its template-screen regression.
- Whispering Well commitment motion remains rolled back after its mini-art regression.
- Event animations should only return later as small screen-specific patches after local verification.

### Whispering Well mini-art hotfix

The dedicated Whispering Well screen lost its choice illustrations after Motion Pass 1. Its controller has been restored to the last stable pre-motion version. `ApprovedEventChoiceArt.get_whispering_well_texture()` now uses the approved split-sheet cells again instead of the raw legacy atlas path, restoring the three mini-arts reliably in local/editor runs. Event mechanics are unchanged.

### Act Choice motion hotfix

The first event-choice animation implementation caused a regression where the generic `act_choice.tscn` template could remain visible with placeholder text instead of the active event. `scripts/event/act_choice.gd` has been restored to the last known-good pre-motion version from the semantic-choice-art pass. Table/Hold/discard and Reward motion remain active. Event-choice motion should be reintroduced later in a smaller, testable patch.

## Motion polish pass 1 — Table + Events + Rewards — 2026-10-09

The first broad animation pass is live in `main`. The goal is not "more effects"; motion now reinforces the cursed physical table metaphor.

Table:
- Fate Hold is no longer an instant state toggle. The card moves into the corresponding Hold control, compresses into a short stamp beat, then returns to its deal position carrying the held state.
- Choosing a deal moves the selected card slightly toward the player and gives it a warm focus beat.
- Rejected cards travel to the discard side. The logical discard pile/count now refreshes near visual impact rather than before the moving card reaches the pile.
- The drawn discard stack and count pulse on impact.
- Existing deal, hover, Wizard meddling and wager animations remain intact.

Generic Act Choice events:
- the first commitment/stagger animation attempt was rolled back after it exposed the raw template screen;
- semantic choice art and all event mechanics remain active/stable;
- no generic event commitment animation is currently enabled.

Whispering Well:
- the first commitment animation attempt was rolled back after choice mini-art disappeared locally;
- the stable dedicated screen and three approved choice illustrations are active;
- no Well commitment animation is currently enabled.

Rewards:
- header and reward cards enter with a short stagger;
- selected reward becomes the focal card while alternatives recede;
- portrait/choose bar receive a small acceptance beat;
- reward resolution begins after ~0.18 s so a valuable reward no longer feels like an instant UI state change;
- reset paths restore scale/modulate/z-order before the next reward tier.

Current motion principle: short physical reactions, readable anticipation and object weight. Avoid permanent bobbing, excessive screen shake, particles on every click, or decorative motion that slows repeated runs.

Next motion target after local verification:
1. keep Pass 2 only if attack readability still feels fast in live combat;
2. tune exact durations/intensity from screenshots/video rather than adding more systems;
3. reintroduce event commitment motion only as isolated, locally verified patches.

## Broad semantic choice-art rollout — 2026-10-09

The next large Act 1 choice-card pass is live in `main`.

New semantic mappings:
- `lost_purse`: take coins / take bag / search the corpse;
- `debtor_bones`: occult gamble / safe coins / violent break;
- `wizard_tithe`: pay gold / pay blood / refuse and leave;
- `blood_ledger`: sign with gold / sign with blood / erase from the book;
- `faceless_card`: reveal uses occult-card art, paid fate uses the actual offered upgrade art, while the burn choice deliberately keeps the event illustration because there is no truthful approved burn-card mini-art yet;
- `bone_tax`: pay gold / show chains scar or pay blood / force through with the actual offered upgrade art;
- `ash_rest` ranger-recruitment branch: rescue / loot supplies / leave;
- `last_camp` knight-recruitment branch: free/raise the knight / pay / loot the fallen.

Existing semantic branches remain:
- both Rattling Bridge states use the native 384×160 bridge trio;
- Whispering Well now uses the original native 384×160 approved well cells instead of the compact upscaled copies;
- Chained Prisoner recruitment now uses native chain/loot cells plus the native walk-away cell;
- Chained Prisoner post-recruitment keeps its native approved atlas;
- Black Altar recruitment uses semantic blood / payment / offering art, with the payment cell now coming from the native coin atlas;
- Curse Forge still shows the three real relic illustrations;
- role-development choices continue to show the actual offered upgrade illustrations.

Implementation:
- reusable action vocabulary lives in `ApprovedEventChoiceArt.get_action_texture()`;
- shared rendering is centralized in `act_choice.gd::_apply_choice_texture_set()`;
- the fallback event thumbnail is now reserved for choices that still have no truthful semantic or upgrade-specific source, rather than being the default visual strategy.

This pass changes presentation only. Costs, RNG, recruitment, scars, rewards and event outcomes are unchanged.

### Rattling Bridge regular-choice fallback fixed

The regular `ПЕРЕБЕЖАТЬ / СОБРАТЬ МОНЕТЫ С ПЕРИЛ / ИДТИ МЕДЛЕННО` state was still falling through to the generic event-art fallback. It now uses the already-authored bridge mini-art trio. For this event, runtime loading was switched back to the native `assets/pixel/event/choice/rattling_bridge_hd/` atlas so the live cards use the original 384×160 cells directly rather than an upscaled 192×80 copy.

## Approved semantic choice sheet integrated — 2026-10-09

The user selected the five-event mockup sheet as the visual benchmark for event mini-choice cards.

The approved mockup remains the semantic benchmark, but runtime now prefers the highest-quality already-approved source for each action:
- native Rattling Bridge cells: 384×160 from `assets/pixel/event/choice/rattling_bridge_hd/`;
- native Well/Prisoner cells: 384×160 from `assets/pixel/ui/approved_event_choice_polish/event_choice_atlas.bin`;
- compact 192×80 cells from `assets/pixel/event/choice/approved_choice_sheet_v2/` only where no native approved equivalent exists;
- runtime decoder/mapping: `scripts/ui/approved_event_choice_art.gd`;
- live cards use linear sampling for fractional UI fitting.

Mapped live states:
- `rattling_bridge` both recruitment and regular branches now use the existing semantic bridge trio; the regular branch no longer falls back to the large event thumbnail. The bridge uses its native `rattling_bridge_hd` 1152×160 atlas (384×160 per choice) for maximum quality;
- Whispering Well — whisper/well / coins / leave;
- `chained_prisoner` recruitment — break chains / loot / leave;
- `black_altar` recruitment — blood sacrifice / 35-gold ritual payment / take the offering.

Black Altar deliberately maps the approved coin-hand image to the current 35-gold ritual payment and the approved altar-offering image to the current +40-gold abandon/loot choice. Live text and mechanics remain authoritative.

`curse_forge` is intentionally unchanged: its three current options already show the actual artifact illustrations (Dead Man's Shield / Blind Quiver / Cracked Focus), which communicate the real choices more accurately than the concept-sheet forge placeholders.

The Rattling Bridge split HD atlas is active again as the canonical bridge source because it preserves the original 384×160 choice cells without the quality loss of the compact unified-sheet copy. The standalone Black Altar SVG remains superseded. Chained Prisoner's post-recruitment branch keeps its older dedicated semantic atlas because those choices differ from the recruitment branch.

Next true duplicate-thumbnail targets: `lost_purse`, `debtor_bones`, `wizard_tithe`, then the recruitment branches of `ash_rest` and `last_camp`.

### Choice-card quality hotfix

Local feedback immediately after the approved mini-art rollout identified the 192×80 nearest-neighbor presentation as visibly low quality. Runtime handling now reconstructs the approved sheet to 1152×640 (384×160 per cell) with Lanczos once after WebP decode, then uses linear sampling for the live card fit. The composition/semantic mapping is unchanged; only presentation quality changed.


## Semantic event-choice pass — Black Altar added — 2026-10-09

The semantic mini-art rule is now active beyond Rattling Bridge.

Implemented:
- `black_altar` recruitment branch now has three dedicated mini illustrations for blood sacrifice / paying the ritual / taking the offering;
- art source: `assets/pixel/event/choice/black_altar_recruitment.svg`;
- loader: `scripts/ui/approved_event_choice_art.gd`;
- runtime selection: `scripts/event/act_choice.gd`;
- the normal non-recruitment Black Altar branch continues to use live hero-upgrade art, which is already semantically tied to the three role choices.

Audit of the original benchmark five:
- Whispering Well already uses a dedicated three-cell event-choice atlas;
- Chained Prisoner already uses its dedicated three-cell event-choice atlas;
- Curse Forge deliberately uses the three actual artifact illustrations;
- Rattling Bridge recruitment uses its approved painted trio;
- Black Altar recruitment now uses its own semantic trio.

Next duplicate-art targets: `lost_purse`, `debtor_bones`, `wizard_tithe`, then recruitment branches of `ash_rest` and `last_camp`. Do not regenerate the already-semantic benchmark screens just to make them different.

## Semantic event-choice art pass started — 2026-10-09

The user approved replacing duplicated event thumbnails inside choice cards with dedicated mini illustrations that communicate the **decision**, while the large event art continues to communicate the **scene/context**.

First implemented benchmark: **ГРЕМУЧИЙ МОСТ / `rattling_bridge`**.

Current implementation:
- the first schematic SVG prototype was rejected locally and removed;
- the approved ranger-recruitment trio is stored as a 1152×160 WebP atlas split into `assets/pixel/event/choice/rattling_bridge_hd/part_00.txt` and `part_01.txt`;
- the three 384×160 cells are: rescue the ranger / take the bag / cross alone;
- `scripts/ui/approved_event_choice_art.gd` decodes the atlas at runtime;
- `scripts/event/act_choice.gd` uses these semantic mini illustrations only for the ranger-recruitment branch;
- both the recruitment branch and the regular `rush / scavenge / careful` branch use this existing semantic trio, so the regular bridge no longer repeats the large event thumbnail.

Art rule for this pass: one dominant object/action per choice, restrained palette, large readable shapes, low micro-detail, and no duplicate crop of the context image. Mechanics and option text remain unchanged.

Next step after local approval is to roll the same pattern through Whispering Well / Curse Forge / Chained Prisoner / Black Altar, then the remaining generic Act 1 events.

## Physical card-back foundation pass — 2026-10-09

The user rejected further dark masking and chose a physical-card solution.

Current `main` now includes `assets/pixel/table/card_back_runtime.svg`, a restrained black-leather/brass neutral card back used as a shared physical placeholder.

Normal Wizard table:
- the previous temporary cleanup panels are removed;
- two neutral card backs are permanently seated beneath the live offer positions;
- normal two-card deals cover them completely;
- single-card/retry states expose logical face-down cards rather than baked sample event faces or a dark "hole";
- no offer-selection mechanics changed.

Fate Spread:
- an empty Hold slot now shows the shared card back and hides the old dark title plate;
- a non-empty Hold overlays the live card art/title on that physical back;
- the Wizard discard card layer is hidden when empty;
- when non-empty, the live top discard uses the same physical back as its frame and is shifted/rotated/scaled to follow the painted stack instead of sitting on a dark rectangular mask.

Pending local 1280×720 verification only. If alignment is close, future changes should be pixel nudges rather than another masking approach.

## Latest durable checkpoint — 2026-10-09

The first local screenshot of the exact Variant C table exposed two concrete composition leaks. Both are now fixed in `main`: the baked sample offer cards are suppressed beneath a restrained oval cleanup layer, and the Fate Spread Wizard-discard live card is rotated/shifted onto the painted discard stack so its rectangular backing no longer peeks out. Fate Spread remains visually frozen apart from bug fixes. Next step is local 1280×720 verification of these two corrections; after acceptance, return to vertical-slice validation/balance.


## Screenshot cleanup refinement — 2026-10-09

The first masking fix was locally rejected because the single large dark cleanup shape read as a literal hole in the normal table, and the Fate Spread discard card still sat too large/high on its painted stack.

Current `main` now:
- removes the large `BakedOfferCleanup` panel;
- uses two narrow red-black cloth-toned cleanup patches only when the table has a single centered live offer, leaving normal two-card deals untouched;
- keeps those patches beneath the centered live card so only the baked sample-card side slivers are covered;
- scales the Fate Spread discard live card layer to 90%, lowers it and rotates it to roughly 6.9° so it follows the authored physical stack more closely.

These changes are visual only. Card choice, Hold, discard state and Fate Spread progression are unchanged. Pending local 1280×720 verification.

## Screenshot-driven table cleanup — 2026-10-09

The first post-integration local screenshots showed two specific defects without invalidating the approved compositions:

- On the normal Wizard table, a single live offer could expose the two baked sample cards that are part of `table_exact.webp`. `table.tscn` now places a rounded, dark cloth-like cleanup layer beneath live offers so the baked samples no longer read as extra cards.
- In `РАСКЛАД СУДЬБЫ`, the live top card in the Wizard discard was axis-aligned while the painted physical discard stack is angled. The live discard card/mask/title are now grouped, shifted and rotated together to follow the stack.

No card rules, progression, Hold behavior, discard logic or Fate Spread ring geometry changed.

## Continuation checkpoint — 2026-10-09 — Fate Spread frozen + exact normal-table Variant C live

This is the current visual/gameplay handoff for the next Project chat.

### Fate Spread

The user has explicitly **frozen the Fate Spread composition** after repeated local screenshot passes. Treat it as done unless a concrete rendering bug appears.

Canonical runtime:
- scene: `scenes/table/fate_spread_overlay.tscn`
- logic: `scripts/table/fate_spread_overlay.gd`
- approved full plate: `assets/pixel/table/fate_spread/fate_spread_exact.webp`
- source master: `assets/source_archive/fate_spread/fate_spread_exact_master.webp`
- cleanup/masking: `scripts/table/fate_spread_reference_cleanup.gd`

Important final behavior:
- I–XII remain live run history;
- the approved sealed XIII/skull-chain card is visible directly until the boss becomes active;
- generic future backs from the reference remain visible where they are truthful;
- live masks replace only baked sample/run-specific state;
- history hover is a compact cursor-adjacent tooltip;
- Hold/Discard and counters remain live;
- do **not** redesign the ring/side holders/header from scratch.

### Normal Wizard deal table

The user rejected the earlier procedural oval-table approximation and approved the **latest cleaned-up Variant C full-screen art almost one-for-one**.

Canonical runtime foundation:
- `assets/pixel/table/approved_variant_c/table_exact.webp` — 1280×720 runtime WebP
- `assets/source_archive/table/approved_variant_c/table_exact_master.webp` — preserved larger source
- `scenes/table/table.tscn`
- `scripts/table/table.gd`
- full-screen art is decoded through `scripts/ui/runtime_webp_texture.gd`

The old procedural `TableVisual`, compact `TableSpreadVisual`, and separate logo are still present in files for safety/history but are hidden on the canonical normal table.

Current live layout follows the approved art:
- Wizard/room/table/logo/physical deck/discard holders come from the plate;
- compact top HUD and Wizard line remain live;
- `РАСКЛАД СУДЬБЫ [R]` is centered below the Wizard;
- two live offer cards sit lower on the physical oval table;
- Hold buttons sit immediately above the two cards;
- deck/discard counts are live numeric overlays on the physical holder labels;
- deal/discard animation origins point to the physical side stacks;
- offer-card hover/deal motion was reduced to preserve the physical-card feel;
- card frames use restrained warm brass rather than the earlier bright cyan/red split;
- old rectangular lower-table shade / focus panel are disabled;
- detailed I–XIII progress is intentionally **not** duplicated on this screen.

The most recent code pass replaced the previous v6 Wizard backdrop with the exact approved full-screen plate and aligned the live UI to it. This specific build has not yet had a fresh local screenshot after the exact-art integration, so **the immediate next task is visual verification only**, not another redesign.

### Immediate next check

After `git pull`, open the normal table at 1280×720 with two offer cards and verify:
1. live cards cover the baked sample-card area cleanly;
2. live Hold controls cover/reuse the baked Hold area without doubled text;
3. deck/discard numeric overlays sit on the physical holders without visible stale baked numbers;
4. top HUD/Wizard line are readable without feeling like a separate large black rectangle;
5. cards do not cover the Wizard's hands and remain fully inside the visible table;
6. no old procedural table/ring/logo leaks through.

If the screenshot is close, only tune masks/offsets/font sizes by a few pixels. Do not return to the procedural oval-table version and do not regenerate a new visual direction unless the user explicitly asks.


Last updated: 2026-10-09

## Normal table exact-reference integration — 2026-10-09

The user approved the final cleaned-up Variant C table artwork as the canonical normal card-selection screen and requested implementation almost one-for-one.

The live table now uses the full approved 1280×720 plate at `assets/pixel/table/approved_variant_c/table_exact.webp` as its authored foundation. A 1672×941 source master is archived at `assets/source_archive/table/approved_variant_c/table_exact_master.webp`.

Runtime integration keeps gameplay state live:
- `WizardBackdrop` now runtime-decodes the approved full-screen plate;
- the old procedural `TableVisual`, duplicate compact `TableSpreadVisual` and separate logo are hidden on the normal deal screen;
- live HUD, Wizard line, Squad button, Fate Spread button, Hold actions and offer cards are aligned to the artwork;
- offer cards were reduced/re-laid to the approved physical-card proportions and use one warm bronze/gold frame language instead of teal-versus-red outer chrome;
- the physical deck/discard plaques remain from the art while only their changing numeric counts are masked/replaced live;
- baked Hold labels are covered so Hold availability remains authoritative;
- deal/discard animation anchors now originate from the physical left deck and terminate at the physical right discard.

The previous v6 upper-Wizard crop is no longer a runtime dependency of `table.tscn`. No gameplay rules changed.


## Main table Variant C visual rebuild — 2026-10-09

The user froze the Fate Spread composition and then approved a cleaner **Variant C** target for the normal Wizard/card-selection table: a large oval ritual tabletop, one deliberate central sigil, Wizard centered behind it, two live offer cards near the player, and physical deck/discard holders at the left/right edges. The goal is to eliminate the old rectangular lower-table/UI-panel read without reintroducing dense generated-art prop noise.

The normal table now implements that composition with live Godot layers rather than baking gameplay values into a screenshot:

- `scripts/table/table_visual.gd` now draws a wide physical oval table and red-black ritual cloth over the lower part of the existing authored Wizard scene;
- the old rectangular lower shade, offer-focus rectangle and top shade are disabled;
- the duplicated compact progress-ring graphic was removed from the normal table; detailed progress remains owned by `РАСКЛАД СУДЬБЫ`;
- physical deck/discard stacks are aligned inside new side holders;
- the two live offer cards and Hold controls moved down onto the ritual cloth, while the Fate Spread button moved to the center above them;
- deal/discard animation endpoints were moved to the physical left/right holders;
- the old `SpreadProgress` label remains in the scene only for compatibility but is hidden in Variant C.

The Fate Spread overlay itself is intentionally unchanged by this pass.

## Fate Spread final visual polish — 2026-10-09

The latest screenshot is now very close to the approved reference. Final polish focused only on UI elements that still read too much like HUD:

- the live future replacement card (notably XII) no longer shows a footer/title strip; it renders as a plain dark physical card-back with subdued border, matching the reference's future slots;
- the run-history hover memory is no longer a wide fixed bar across the bottom of the screen. It is now a compact floating tooltip positioned beside the cursor and clamped to the viewport;
- empty Hold/Discard card masks were softened from pure black to a dark leather/burgundy tone so the ornate holders read as physical objects rather than empty UI rectangles.

No ring geometry, slot positions or reference composition were changed.

## Fate Spread screenshot alignment pass — 2026-10-09

The latest local screenshot confirmed that the approved reference composition is now working, with only three alignment/state issues remaining. They were corrected without changing the ring geometry:

- the baked XII sample card (`КУЗНИЦА ПРОКЛЯТИЙ`) is now treated like the baked I–IV samples and always replaced by live state;
- XII therefore uses the live future/current/resolved card panel instead of incorrectly showing the baked sample;
- the static approved `MISDEAL — РАСКЛАД СУДЬБЫ` title now comes directly from the reference plate; the large live black header was reduced to a narrow dynamic-data mask covering only subtitle/count/chapter rows;
- Wizard Discard count was moved down into the physical holder area;
- empty Hold/Discard states no longer print a separate `ПУСТО` label over the holder.

## Fate Spread reference-preserving cleanup — 2026-10-09

The next local screenshot showed that the cleanup masks themselves had become the visual problem: oversized black rectangles were covering too much of the approved table art, and the live XIII replacement hid the strongest central card from the reference.

The cleanup is now state-aware:
- positions I–IV are always live-covered because the approved plate contains baked example cards there;
- positions V–XII keep the approved generic future card-backs visible until that slot becomes current/resolved;
- once a later slot becomes live, only a tight card-sized cloth mask plus a small Roman-numeral patch is drawn behind it;
- the approved chained XIII/skull card remains fully visible while sealed;
- XIII is masked only when the live boss card actually replaces it;
- the baked header is now suppressed with a fully opaque, wider mask.

This preserves substantially more of the approved composition while keeping run-specific history authoritative.

## Fate Spread baked-state cleanup — 2026-10-09

Local verification of the exact-reference rebuild showed the remaining mismatch clearly: the full approved concept plate still exposed its baked sample cards, Roman numerals and title beneath the live run state. The composition itself was correct, so geometry was kept intact.

A dedicated `fate_spread_reference_cleanup.gd` layer now masks only those baked dynamic regions before the live cards are drawn. The header mask was widened/strengthened, all twelve baked slot/card+numeral regions are covered with reference-matched cloth patches, and the baked XIII card/label area is suppressed beneath the live boss card. The physical table, ritual circle, candles, hand, books, skulls, brass and red cloth remain visible.

Empty Hold/Discard states also no longer show parchment-colored title strips; those plates switch to dark material until a real card exists.

## Fate Spread exact-reference rebuild — 2026-10-09

The user explicitly chose the final ornate Fate Spread reference as the target **almost one-for-one**, so the intermediate edge-art composition has been superseded.

The approved full 16:9 plate is now stored at `assets/pixel/table/fate_spread/fate_spread_exact.webp` and displayed at full 1280×720 behind live UI. A high-quality source master is archived at `assets/source_archive/fate_spread/fate_spread_exact_master.webp`.

The runtime overlay was rebuilt around the reference geometry rather than placing a generic modal on top:
- the physical table, cloth, candles, skulls, books, brass props, hand and ritual circle come directly from the approved plate;
- live I–XII card panels now occupy reference-matched positions around the circle and use parchment/dark physical-card styling;
- XIII is aligned to the reference center and still receives live boss/seal state;
- the left Hold and right Wizard Discard use the ornate holders already present in the art, while small live masks replace only the run-specific card/count contents;
- the baked title/stat strip is masked and replaced by live title/subtitle/count/chapter text;
- hover choice-memory and milestone behavior remain live.

The previous runtime `edge_top.webp`, `edge_left.webp`, `edge_right.webp`, and `reference_underlay.webp` were removed because they are no longer used. Their source concepts remain archived where useful.

## Fate Spread edge-art integration — 2026-10-09

The full-screen reference-underlay approach was retired after local review because it had to be darkened so aggressively that the approved physical-table atmosphere disappeared. The approved direction is now implemented as **edge-art plates** instead:

- `assets/pixel/table/fate_spread/edge_top.webp` — candle/brass/gothic top rail;
- `assets/pixel/table/fate_spread/edge_left.webp` — left ritual props and red cloth;
- `assets/pixel/table/fate_spread/edge_right.webp` — right skull/candle/brass props.

These plates are loaded through the established `runtime_webp_texture.gd` path, not direct Texture2D imports. They sit behind live UI at near-full brightness while the center remains the authoritative procedural Fate Spread. High-quality source masters are archived under `assets/source_archive/fate_spread_edges/`.

The old `reference_underlay.webp` is no longer a runtime dependency.

## Fate Spread underlay visibility fix — 2026-10-09

Local screenshots showed that the approved ornate reference plate was technically present but visually crushed by the opaque Frame panel, so the screen still read as a flat black modal. The underlay is now a child of `Frame`, drawn above the frame background but beneath all live UI. The outer frame and global scrim are much lighter, making candle/metal/red-cloth edge props visible.

To prevent baked concept-state from leaking into gameplay, the live central `TableSurface` is now much more opaque and masks the reference plate across the whole ring area, while a dedicated dark header shade suppresses the concept image's baked title/counters. Live side panels likewise cover the concept's side-card state. The goal is: visible physical-table atmosphere at the edges, authoritative live data in the center.

## Fate Spread approved-reference integration — 2026-10-08

The user approved the ornate physical-table Fate Spread reference with candles, brass/iron props, red ritual cloth and a stronger carved-gothic tabletop presentation. The game does **not** bake that screenshot's run-specific cards/counters into gameplay. Instead, a darkened/blurred derivative is stored at `assets/pixel/table/fate_spread/reference_underlay.webp` and blended beneath the live Fate Spread UI.

`scenes/table/fate_spread_overlay.tscn` now exposes the underlay through a translucent frame/scrim while the procedural central surface, live I–XII cards, XIII seal, counters, hold/discard state and hover memory remain data-driven. This keeps the approved atmosphere without making the current run visually lie.

## Fate Spread physical-table + memory pass — 2026-10-08

The Fate Spread now gains the three follow-up layers requested after local screenshot review:

1. **Physical table presence.** The central spread area sits over a restrained procedural red-black table surface with worn grain, scratches, ritual staining and a soft vignette. It stays intentionally quiet beneath the existing seal/cards instead of turning the inspection view into another full-screen illustration.
2. **Run-choice memory.** `RunState` now records the chosen/rejected pair for each resolved pre-boss card. Hovering a completed Fate Spread card enlarges it and opens a compact memory strip showing the chronological slot, chosen card and the alternative rejected at that decision. Existing in-progress runs have a compatibility fallback based on resolved/rejected order.
3. **Act milestones.** IV, VIII and XII are now one-shot ritual beats. After the table unlocks following those thresholds, the Fate Spread automatically opens once, plays a dedicated low ritual sound and pulses/shakes the central seal/XIII. The shown milestone is persisted in `RunState` so reopening the spread does not replay it.

The existing XIII chain rules remain: two chains early, one chain from VIII onward, awakened/unsealed presentation when the boss becomes due.

## Fate Spread reference-driven polish — 2026-10-08

A second visual pass now follows the approved Fate Spread reference more closely instead of treating the screen as a plain radial menu. The live spread has a dedicated occult seal layer beneath I–XII, a dim fate-thread connecting the twelve positions, brighter completed path segments, chapter gates after IV/VIII/XII, inward ritual spokes and a central sigil whose blood/ember intensity increases with run progress.

XIII now has its own live chain/seal overlay. Two crossed chains hold the boss card early in the act; one visually breaks away entering the final chapter, and the seal disappears into an awakened mark once the Bone Warden is due. Side holders were shortened to return visual priority to the central ritual composition. Chapter typography also escalates from gold to ember/red as the act advances.

All of this remains procedural/live UI; no progress values or run history are baked into static art.

## Fate Spread local screenshot correction — 2026-10-08

The first local 1280×720 screenshots confirmed the progression concept but exposed a presentation defect: the live two-card offer and the table access button could render above the inspection view, obscuring the historical ring and XIII. The inspection overlay now uses a valid top CanvasItem z-index, explicitly hides the live deal/progress access while open, restores them on close, and uses smaller historical-card slots with a wider ring so the central boss card reads as the focal point.

## Fate Spread Act progression — 2026-10-08

The user-approved **РАСКЛАД СУДЬБЫ** progression concept is now implemented as live Godot UI rather than a baked screenshot.

The cursed table now keeps a restrained 12-position occult progress ring behind the active deal, with the central mark reserved for XIII / Bone Warden. A new `РАСКЛАД СУДЬБЫ [R]` action opens a full inspection overlay showing:

- positions I–XII populated in chronological order with the actual resolved card art and titles;
- the current unresolved position highlighted separately;
- central XIII sealed until the boss is due, then revealing the Bone Warden art;
- current act chapter label: **ПЕРВАЯ РАЗДАЧА**, **СТОЛ ПОМНИТ**, **ПОСЛЕДНЯЯ РАЗДАЧА**, then **ПРИГОВОР**;
- live counts for resolved, rejected and currently held cards;
- the held-card area using the real held card art/status;
- the Wizard discard showing the most recently rejected card and rejected-card count.

The table's ordinary right-side discard now counts rejected cards only; resolved cards are represented by the Fate Spread itself. Future slots remain genuine unknowns instead of pretending that future card types are already scheduled. This is currently a progression/readability system only; it does not change offer RNG, Act 1 length or encounter rules.

## Current status

Misdeal has a working tactical autobattle slice and a first finite run structure.

Confirmed locally by the user:

- base autobattle and restart;
- pre-battle hero placement;
- combat-time unit separation;
- hit/death feedback;
- data-driven `UnitData`;
- Bone Archer keep-distance behavior;
- hard combat-arena bounds;
- first `table -> battle -> reward -> table` loop;
- cleaned-up victory/defeat result overlay.

The original three-victory finite run was implemented and confirmed working locally, then deliberately replaced by the longer Act 1 structure described below.

Phase 3 identity work is underway. The first non-combat event card and one-time event flow are confirmed working locally.

The earlier painted-art integration was locally judged too hard to read in combat. The user chose a dark-fantasy pixel-art direction.

The first pixel-art combat readability redesign is implemented and confirmed working locally.

The second battle presentation pass is implemented and confirmed visually acceptable locally.

The same pixel-art visual language is now applied across the main menu, Whispering Well event, reward screen and run-end screen.

The user-approved full **card-art set** is now integrated in GitHub and pending local verification. All 25 active Act 1 table cards, including Bone Warden, use their own authored pixel-art illustration from the approved generation pass instead of reusing the old five-image pool. All nine hero-development paths now have distinct approved art, and the six generated reward-state illustrations are wired into ordinary loot, Death Wager and elite-reward cards. Generic Act 1 choice events also reuse the active card's approved illustration in the upper half of each choice card while Forge and Chained Prisoner keep their dedicated per-option art. The first integration was locally rejected for image quality because it had downsampled these illustrations to only 88×54 px for table cards and 80×48 px for development/rewards before scaling them back up. That thumbnail atlas has now been superseded by near-display-resolution runtime-decoded WebP atlases: 224×137 px per table-card cell and 304×194 px per development/reward cell, stored as raw `.bin` bytes so Godot decodes the WebP directly without importer fragility. Gameplay values and text remain live Godot UI.

A focused **special-event / artifact presentation polish** pass is now in `main` and pending local verification. The Wizard wager modal now presents its price and reward as two illustrated framed terms instead of a single text block, with a larger ceremonial panel and stronger accept/refuse hierarchy. Curse Forge now layers a high-resolution forge scene behind the approved blacksmith decor, uses a tighter header, larger artifact cards and a dedicated object-centric artifact atlas. The same artifact atlas is also used by Death Wager and Crypt Guard artifact rewards, and Broken Crown event choices now show the crown itself rather than only the generic event illustration. Mechanics, prices, artifact stats and wager rules are unchanged.

A broader **event-window hierarchy polish** pass is also now in `main` and pending local verification. Generic Act 1 event windows now use the active event's pixel art as a framed context image in the header instead of leaving the upper body as empty black space; gold and run-state information sit in compact framed chips; role-development choices use the actual next upgrade illustration instead of repeating the event image; and several risk/reward events use semantic border accents so safe, costly and dangerous choices separate at a glance. This directly affects Candle Seller, Gravedigger Shop, Ash Rest, Last Camp, Black Altar and the other shared Act 1 choice screens without changing their mechanics. Whispering Well received the same treatment: each choice now has an illustrated upper band using the relevant well, upgrade or relic art while keeping all live text and disabled-state logic native.

The first local pull of that pass exposed a Godot 4.7.2 parser-inference failure in the new semantic style loop (`disabled` / `active` were inferred from an untyped loop value). The style-name arrays, styleboxes and boolean flags are now explicitly typed in both `act_choice.gd` and `whispering_well.gd`; no presentation behavior was changed by the fix.

Wizard Wager received a second local-review polish pass: the modal is shorter and tighter, risk/reward cards use larger art, red-vs-gold separation is stronger, a central contract sigil visually binds the two sides of the deal, and the accept button now has its own stronger ember hover/glow style instead of borrowing generic card hover chrome. Mechanics and wager values are unchanged.

A final local-review refinement reduced the outer orange frame emphasis, extended the contract line beneath the two terms, brightened/enlarged the reward illustration, promoted the `x2` value and pulled both action buttons closer to the offer cards. This is intended as the final Wizard Wager presentation pass unless new local screenshots expose a concrete defect.

A local Gallows Volley screenshot exposed a battle-floor mismatch: ranged retreat and ordinary unit separation could legally push any unit into the authored background above the stone floor because the encounter still used the old full-height combat rectangle. **ЗАЛП С ВИСЕЛИЦЫ** now has an encounter-specific combat floor and matching deployment band; its solo/duo/trio default positions were moved onto that same playable plane. The fix applies to every unit type in the encounter, including retreating Ranger/Bone Archer units, rather than special-casing archers. Pending local verification.

The next local screenshot pass fixed two concrete layout defects. Shared Act 1 event cards now keep their bottom action inside the 1280×720 viewport instead of letting merchant/choice footers clip below the screen; Chained Prisoner has its header moved upward, a dedicated 230 px choice row and a separate bottom leave action so its three illustrated cards no longer collide with the footer. Squad Dossier now renders above all table content and temporarily hides the live offer-card layer while open, preventing an encounter card from punching through the dossier. The dossier portrait was enlarged and the center/right columns rebalanced for more readable stats, development and relic sections.

The approved 2026-10-07 full-screen mockups for **ШЕПЧУЩИЙ КОЛОДЕЦ** and **ЗАКОВАННЫЙ ПЛЕННИК** are now implemented as a dedicated choice-card polish pass. Their exact approved top-card illustrations were cropped into a 384×160-per-cell runtime WebP atlas and wired back into the live scenes, while titles, costs, disabled states and outcomes remain Godot controls. Chained Prisoner now uses blue/red/amber semantic card accents, larger illustrated bands and a higher compact header; Whispering Well uses distinct well/treasure/leave art, larger card illustrations, divider medallions and explicit disabled-state ribbons such as **НЕДОСТАТОЧНО ЗОЛОТА**. The same divider/medallion treatment is available across the shared Act 1 choice shell, improving card readability without creating bespoke event logic.

A first **cross-card consequence / rescue-scar** pass is now in `main` and pending local verification. Act 1 events can store explicit outcomes and later cards read them: Lost Purse changes Gravedigger Shop prices (careful handling lowers them to 30, greedy handling raises them to 45), Debtor Bones changes Wizard Tithe's gold price (25 after caution, 40 after gambling/breaking the bones), and resolving Blood Ledger before Broken Crown adds a +15 gold knowledge bonus to the crown-melting route. Companion rescues by sacrifice now create named protagonist scars instead of anonymous party-wide HP loss: Knight rescue creates **ШРАМ ЦЕПЕЙ** (-10 max HP), Ranger rescue creates **ШРАМ ДОРОГИ** (-8 max HP), and Mage rescue creates **ШЁПОТ ПОД КОЖЕЙ** (-12 max HP). These scars affect effective protagonist stats and are listed in Squad Dossier. Wizard Memory also reacts to receiving scars, surviving at least six cards alone, and deliberately abandoning both possible companions.

The **cursed tactical order / Wizard tell** pass is now in `main` and has been locally confirmed working. Accepting a voluntary Wizard wager grants exactly one opportunity in the next combat to choose the fourth tactical order **ЖЕРТВА**. It gives the whole party +40% damage and +20% attack speed for that battle, while every living hero continuously loses 2% of their own max HP per second. The order is consumed when that next combat begins whether selected or not, so it cannot be banked through retries. Wizard Memory records actually choosing the order. The same battle pass also fixes rescue-scar HP penalties in live combat spawning so the dossier and autobattle now use the same protagonist max-HP cost.

The first **meaningful defeat / Last Deal** pass is now in `main`; the user has confirmed the flow is working locally. Free combat retry after defeat has been removed. On the first defeat of a run, the result overlay becomes **ПОСЛЕДНЯЯ СДЕЛКА**: the Wizard offers exactly one paid retry of that same active combat. If the player owns relics, one owned relic is selected and shown as the explicit price; accepting permanently removes it. If no relic is available, the price becomes **КЛЕЙМО ПОСЛЕДНЕЙ СДЕЛКИ**, a persistent -15 max-HP penalty on the protagonist. The deal can be accepted only once per run and is consumed immediately; losing again after using it ends the run. Refusing the offer also ends the run. Defeat now routes to a real failed-run end screen instead of returning to the table for a free retry. The Last Deal HP brand is included in effective protagonist stats, live battle spawning, Squad Dossier and the final run summary.

The table now has restrained Wizard tells without adding new decorative clutter: deal motion becomes slower/smoother when accepted wagers outnumber refusals and sharper when refusals dominate; a card gives a brief physical twitch before a scheduled Wizard meddling swap; and companion-loss / deliberate-loner memory lines briefly dim the live card layer while rescue-scar remarks warm the commentary line. These are presentation reactions only and do not alter offer RNG.

A **battle HUD readability + static balance audit** pass is now in `main`. The long preparation line has been split into two responsibilities: the left side shows a concise encounter-specific threat/tactical cue, while a dedicated right-side condition label shows solo/duo compensation, Wizard debt, Sacrifice availability or prior Last Deal use. This fixes the 1280×720 overlap seen around `КАРТА 9/12` on Death Wager and makes dangerous encounters easier to parse before pressing **БОЙ**. The current combat numbers were audited against baseline solo/duo/trio aggregate HP/DPS and intentionally left broadly unchanged: solo and duo remain close in baseline total output while trio retains a meaningful full-party advantage, and the fixed 700-HP Bone Warden / late elite compositions stay as benchmark encounters until actual full-run evidence identifies a concrete outlier. `docs/CONCEPT.md` has also been corrected to match the implemented solo compensation (`HP ×2`, `damage ×1.8`, attacks ×1.25, movement ×1.10).


A targeted **Gallows floor-alignment** fix is now in `main` and pending local verification. The Gallows Volley encounter now uses a lower, tighter combat floor rectangle that matches the authored stone platform; solo/duo/trio starting positions and enemy spawns were moved onto that floor, and `BattleUnit.set_combat_bounds()` now clamps immediately so any spawn/reinforcement position outside the legal floor cannot remain visibly suspended during preparation or the combat intro. The fix is systemic at the unit-boundary layer but intentionally retunes only Gallows geometry until fresh screenshots identify another arena mismatch.

A new **Act 1 fate/table-depth** pass is now in `main` and pending local verification. Rescue scars are no longer pure penalties: **ШРАМ ЦЕПЕЙ** gives free passage at Bone Tax instead of another blood payment, **ШРАМ ДОРОГИ** cuts the Faceless Card's deterministic-development price from 30 to 15 gold, and **ШЁПОТ ПОД КОЖЕЙ** reduces Blood Ledger's blood-signing cost from 25 to 10 party HP. The cursed table also gains one **УДЕРЖАТЬ** action per Act 1: while a normal two-card offer is visible before the final stretch, the player may reserve one card, must choose the other now, and the held card is guaranteed to return after two resolved cards. Finally, two scheduled offers per run may carry a visible **ПЕЧАТЬ ВОЛШЕБНИКА**. Choosing the marked card immediately grants +20 gold but makes enemies deal +15% damage until the next combat is won; declining it has no mechanical penalty. Mark risk cannot overlap with a second mark, but it can stack additively with Wizard debt because both are visible self-authored risks.

A follow-up **Act 1 tactical/readability consequence** pass is also now in `main` and pending local verification. Four combat encounters now change the legal pre-battle deployment geometry instead of sharing one universal rectangle: Gallows Volley uses a deep vertical line, Bone Crush splits the player into two horizontal bands, Ossuary Gate provides two separated deployment pockets with the center closed, and Bone Warden compresses the party into a tighter starting zone. The legal regions are shown as subtle live panels and drag-clamping supports multiple disconnected regions. Combat cards on the Wizard table now surface compact threat tags such as `РОЙ`, `ЛЕЧЕНИЕ`, `AOE`, `2 ЛУЧНИКА` and `ФАЗЫ`, so the two-card decision can be made with current party/build context instead of art/title alone. Finally, **КАРТА БЕЗ ЛИЦА** can now perform a late-act reckoning on the whole run: deliberately losing both companions, carrying at least two rescue scars, or repeatedly accepting Wizard-authored risks unlocks a distinct fourth resolution through the existing leave action. The three profiles are **БЕЗ СВИДЕТЕЛЕЙ**, **ИСПИСАН ШРАМАМИ** and **ЛЮБИМЕЦ СТАВОК**; each gives a different concrete payoff without adding a hidden morality meter.

A new **combat temptation / resistance / boss-verdict** pass is now in `main` and has been locally confirmed working by the user. Three encounters can carry visible optional combat conditions from the Wizard for +15 gold on victory: **Могильный звон** asks the player to kill the Bellkeeper first, **Залп с виселицы** asks that no hero fall below 25% HP, and **Костяная давка** asks for a clear within 16 seconds. These conditions are shown in a compact live panel during preparation/combat and fail visibly when the requirement is broken. Refusing two visible Wizard-authored offers across wager refusals and marked-card refusals now unlocks the one-battle tactical order **НЕПОВИНОВЕНИЕ**: the party deals 15% less damage but takes 20% less incoming damage. Like `ЖЕРТВА`, the option is consumed when the next combat begins whether selected or not. Finally, Bone Warden Phase II now reads the same aggregate Act 1 reckoning used by Faceless Card without changing the boss's base 700 HP or baseline damage: **БЕЗ СВИДЕТЕЛЕЙ** summons two Bone Thralls, **ИСПИСАН ШРАМАМИ** summons a Grave Bellkeeper who can heal the boss, **ЛЮБИМЕЦ СТАВОК** summons two Bone Archers, and an untyped run keeps the existing Archer + Thrall reinforcement pair. The verdict is surfaced before and during the boss fight rather than hidden.

The first two main-menu rebuilds were rejected in local visual review. A dedicated dark-fantasy pixel-art splash was then generated, explicitly selected by the user, and is now the approved production start screen. It shows the Wizard looming over a five-card cursed table, the large MISDEAL title, the line **«Проклятая партия уже разложена.»** and a painted **ВОЙТИ В ИГРУ** button. Runtime reconstructs the approved 1280×720 WebP from three repository-safe base64 chunks and renders it at native project resolution with linear filtering; the corrected Wizard card hand now has five fingers, and only a transparent native Godot button hotspot remains live over the painted CTA.

A skippable five-frame pixel-art story prologue is now implemented in GitHub and pending local verification. It establishes the old pact, the aged protagonist and the Wizard's offer to replay a life whose corrections will rewrite the fates of everyone the protagonist once saved.

The wizard table has since been rebuilt again around an approved authored pixel-art concept.

The final composition/readability polish pass has been locally verified and accepted:

- encounter hover no longer uses floating tooltips over card art;
- hovering a combat card now swaps the upper wizard-commentary line to that encounter's wizard reaction;
- the Whispering Well has its own hover commentary;
- the HUD and commentary strip are more compact;
- the four cards are slightly smaller, lower and more evenly spaced so the wizard remains visible;
- obsolete procedural skull/goblet/hourglass/books/candle overlays were removed;
- the lower runner/sigil treatment was simplified and subdued.

The original Bone Warden boss encounter, including its 50% HP enrage, was confirmed working locally. After full Act 1 playtesting the user reported that the boss was too easy and visually insufficiently distinct from ordinary combat.

A Bone Warden gameplay + visual rework is implemented in GitHub and pending local verification. The first local pull exposed a Godot 4.7.2 type-inference parser error in the new procedural boss-arena chains; that parser issue was fixed.

After comparing the live battle screenshot against the approved richer pixel mockup, the procedural battle renderer was replaced by an authored full-screen battle backdrop matching the second approved reference much more closely. The first local pull exposed two wiring faults: a truncated 8.7 KB WebP and a negative z-index that placed the backdrop behind the black fallback. Both faults were fixed, and the user has now confirmed the authored battle backdrop looks correct locally.

The full combat-unit sprite art pass is now locally confirmed working. All nine currently used combat roles have dedicated high-detail dark-fantasy pixel sprites in one 96×96 atlas; special enemies no longer reuse tinted Skeleton art. The final v3 atlas is stored as ten base64 PNG chunks under `assets/pixel/units/combat_units_v3/` and decoded by `BattleUnit`. The obsolete v2 preload/fallback was removed after it caused a Godot parser/import failure.

A first real **hero build progression** layer is implemented in GitHub and pending full-run local verification. Ordinary post-combat +HP/+damage choices are no longer the main progression path.

A follow-up **build-aware event pass** is also implemented in GitHub and pending local verification. Positive permanent event rewards now primarily use hero development, artifacts or gold; raw global HP/damage changes remain mainly as costs, penalties or legacy named artifact effects.

The longer Act 1 structure is now confirmed working locally: 12 resolved pre-boss cards followed by the Bone Warden as card 13.

The first real post-structure content batch is implemented: **ПЕПЕЛЬНЫЙ ПРИВАЛ**, **ЛАВКА МОГИЛЬЩИКА** and **КУЗНИЦА ПРОКЛЯТИЙ** have real choices instead of the generic prototype resolver.

The first new combat-content batch is also implemented in GitHub and pending local verification: **МОГИЛЬНЫЙ ЗВОН**, **КОСТЯНАЯ ДАВКА** and **СТРАЖ СКЛЕПА** are real combat cards.

A second real event batch is implemented in GitHub and pending local verification: **ЧЁРНЫЙ АЛТАРЬ**, **ЗАКОВАННЫЙ ПЛЕННИК**, **КОСТИ ДОЛЖНИКА** and **ДЕСЯТИНА ВОЛШЕБНИКА** no longer use the prototype resolver.

The late-game escalation batch is implemented and locally confirmed working: **КАРТА БЕЗ ЛИЦА**, **КРОВАВАЯ КНИГА**, **СЛОМАННАЯ КОРОНА**, **ПОСЛЕДНИЙ ПРИВАЛ** and **ВРАТА ОССУАРИЯ** are real cards.

The final five-card content batch is locally confirmed working: **ГРЕМУЧИЙ МОСТ**, **КОШЕЛЬ МЕРТВЕЦА**, **ТОРГОВЕЦ СВЕЧАМИ**, **КОСТЯНАЯ ПОШЛИНА** and **СТАВКА НА СМЕРТЬ** all have bespoke mechanics. The full 24-card pre-boss Act 1 pool is content-complete with no active prototype-card routes.

The first Act 1 balance/readability pass is implemented in GitHub and pending local verification. It focuses on combat pacing, Death Wager reward inflation and final-boss difficulty rather than broad retuning of every event.

Local hard-roguelike testing then exposed that the original solo compensation (+50% HP / +35% damage) was not enough to survive the first mandatory combat encounters. This was a real action-economy problem rather than a placement-only issue.

A solo rebalance is now implemented in GitHub and pending local verification:

- solo max HP multiplier: x2.0;
- solo damage multiplier: x1.8;
- solo attack interval multiplier: x0.80, equivalent to +25% attacks/second;
- solo move-speed multiplier: x1.10;
- duo remains +20% HP / +15% damage;
- trio remains unmodified;
- early enemy resources and encounter compositions were deliberately left unchanged;
- Bone Warden remains a fixed benchmark and still does not scale dynamically to party size.

A follow-up UI-overlap polish pass was implemented after local screenshots exposed three readability faults:

- protagonist class cards no longer use multiline `Button.text` underneath the portrait; portrait, class name, stats, role and description now occupy separate fixed regions;
- wizard-table offer cards have a taller clipped description region and a dedicated bottom hint/action region, preventing long event copy from colliding with **ВЫБРАТЬ**;
- battle result UI now lives in a dedicated high-layer `CanvasLayer` with a dim fullscreen scrim, so unit sprites/HP bars cannot render over the victory/defeat modal;
- the result panel was moved upward and given more vertical breathing room, while tactical-order controls are hidden once combat ends;
- the finished **БОЙ** button is hidden when **ЗАБРАТЬ НАГРАДУ / ВЕРНУТЬСЯ К СТОЛУ** appears, removing duplicated bottom text.

The first combat-feel / audio pass is implemented in GitHub and has been confirmed locally:

- all living units have a subtle sprite-only idle/breathing motion without moving their actual combat position;
- melee attacks use a stronger forward lunge, ranged attacks use recoil plus a brief tracer, and Mage/Bellkeeper attacks use a colored magical tracer/pulse;
- hit feedback keeps the existing flash/pulse and adds a tiny sprite kick without changing navigation position;
- death hides combat UI immediately, tilts/drops the miniature and fades it as a corpse silhouette;
- battle SFX are generated at runtime as lightweight deterministic 16-bit PCM placeholders: melee, bow, magic, hit, death, heal, boss phase, tactical-order click, combat start and victory/defeat stingers;
- the SFX system uses a small polyphonic voice pool and short cooldowns so swarm fights do not become an audio wall;
- no external audio asset pack or generalized animation framework was added; authored sound/music can replace the placeholders later without changing combat rules.




A **choice / event / reward presentation pass** is now implemented in GitHub and pending local verification. It unifies the non-combat decision screens with the approved dark-gothic table language without changing event logic:

- protagonist selection now uses the authored Wizard/table backdrop, Misdeal logo, ritual frame, subtle ambient effects and hover/entrance motion instead of a flat black frame;
- the generic Act 1 event-choice scene now covers all current event cards with one ornate layout, larger decision cards, explicit disabled states, animated hover feedback and card-specific accent/atmosphere families (forge, chains, altar, bridge fog, candle glow and bone dressing);
- **Whispering Well** keeps its teal identity but now shares the logo/HUD hierarchy, framed header and large card-like choices used elsewhere;
- reward / hero-development screens now sit over the authored Wizard backdrop with a compact run HUD, stronger header frame, richer role-colored reward cards and hover feedback;
- the hero-development state now uses the exact accepted screen-art illustrations for **ЖЕЛЕЗНАЯ КЛЯТВА**, **СТЕКЛЯННОЕ СЕРДЦЕ** and **ПАЛАЧ**; the mistaken combat-atlas portrait fallback has been removed. The same accepted art source now feeds **КУЗНИЦА ПРОКЛЯТИЙ** and **ЗАКОВАННЫЙ ПЛЕННИК** choice cards where matching approved illustrations exist;
- prototype/fallback event cards use the same ritual shell instead of the old isolated black panel;
- the table's **СТАВКА ВОЛШЕБНИКА** modal is larger, darker and more ceremonial, with stronger accept/refuse hierarchy and heavier dimming behind it;
- these are presentation-only changes: event costs, rewards, recruitment outcomes, upgrade logic, Wizard wager rules and scene transitions are unchanged.

A **large combat presentation pass (v2)** is now implemented in GitHub and pending local verification. It deliberately keeps combat rules/AI unchanged while polishing the live battle layer:

- every unit now gets an arena-aware ambient tint, a low-alpha team rim silhouette and a softer two-stage contact shadow so miniatures sit inside the authored background instead of reading as pasted sprites;
- successful attacks add short combat-simulation hit-stop, directional sprite kick and three-ray impact sparks without changing actual navigation positions;
- undead deaths now burst into lightweight bone fragments before the existing fade/drop, while heroes use a slower fall so ally defeat reads differently from enemy cleanup;
- the lower preparation HUD is rebuilt as one coherent dark gothic panel with stronger pressed-state order buttons, a larger central **БОЙ** control and the unused restart control hidden until battle end;
- a dedicated Wizard commentary strip now reacts to combat start, the first critically wounded hero, a surviving hero death and Bone Warden phase II;
- dynamic arena atmosphere now sits over the authored backdrops but under units: graveyard fog/crow drift, crypt fire glow, ossuary dust/haze and Warden red haze/embers; Bone Warden runes remain intact;
- pressing **БОЙ** now removes the preparation controls, shows a short **СХВАТКА / encounter title** transition, then starts the autobattle and Wizard commentary;
- these changes are presentation-only: tactical orders, target selection, damage values, attack intervals, combat bounds, placement and encounter compositions are unchanged.

A first **active Wizard interference** pass is now implemented in GitHub and pending local verification:

- the Wizard now secretly schedules two meddling moments per Act 1 run: one during the mid tier and one during the late tier;
- when one triggers, the current two-card offer is shown first, selection locks briefly, and the Wizard visibly flips one card edge-on and replaces it;
- replacement stays inside the same tier and the same resolution family (combat replaces combat, event replaces event), preserving the run's mandatory-combat pacing while still allowing a normal combat to become an elite combat or one event to become a harsher event;
- the swapped-away card is not consumed and can still appear later, while the replacement becomes part of the real current offer;
- active/retry cards and the Bone Warden boss offer are never meddled with;
- this is intentionally theatrical offer manipulation, not hidden stat cheating or a new generalized curse system.

The first **voluntary Wizard wager** layer is implemented and has been confirmed locally:

- the Wizard schedules up to two wager offers in Act 1: an early offer around cards 3-4 and another after card 7;
- the wager appears as a blocking table modal before the player chooses the next card;
- accepting activates the existing **ДОЛГ ВОЛШЕБНИКУ** state: the next combat deals +25% enemy damage and the next ordinary loot reward is doubled;
- refusing has no mechanical punishment; the Wizard only comments on the refusal;
- an existing debt suppresses scheduled wager prompts so debt states never stack;
- the existing Wizard Tithe refusal still uses the same debt mechanic, and Faceless Card can still clear it;
- accepted/refused wager counts are stored in `RunState`.

A first **Wizard Memory v1** layer is now implemented in GitHub and pending local verification:

- `RunState` records eight player-behavior memories: accepting a wager, refusing a wager, recruiting a companion, abandoning a companion, clearing Wizard debt through a special escape, losing a battle, retrying the same battle and choosing greed-heavy gold outcomes;
- memory is narrative-only: it does not alter stats, card odds, combat rules, rewards or hidden difficulty;
- the table consumes one pending contextual memory line when no higher-priority Wizard interaction is active;
- priority is explicit: boss/table-critical states and active meddling/wager modals take precedence, then remembered behavior, then generic progress commentary;
- companion memories are role-aware for Knight, Ranger and Mage;
- repeated behavior gets different follow-up lines, so repeated wager acceptance/refusal, defeat and greed do not always repeat the same text;
- current hooks cover companion fate resolution, voluntary wagers, Faceless Card debt-clearing, battle defeat/retry, Lost Purse greed, Broken Crown greed and Death Wager gold selection;
- the system intentionally stores compact event/count state instead of a dialogue graph so future hero-story chains can reuse it without creating a second narrative-state architecture.

The **physical card-table staging pass** is implemented and has been confirmed locally:

- the two-card offer is no longer presented as a flat HBox menu; live cards sit in a loose fan with slight opposing rotations;
- a visible deck pile and discard pile frame the central offer, with live counts derived from `RunState`;
- a 12-card fate track plus a separate XIII boss marker makes the Act 1 layout read as an unfolding spread rather than a sequence of menus;
- each new offer is visibly dealt from the deck with a short staggered slide/flip-in motion and procedural card-slap audio;
- hover lifts and straightens a card without changing selection rules;
- selecting a card pulls it toward the center while the rejected card physically flies into the discard pile before scene transition;
- Wizard card substitution now waits for the deal animation and uses the same physical staging, so his interference reads as taking a card back and replacing it;
- single-card retry/boss states collapse to one central table slot instead of preserving a fake two-choice layout;
- the pass adds no card physics, drag-to-play interaction or 3D table system; it is presentation-only and keeps the existing two-choice run rules intact.

A richer procedural **table-art dressing experiment** was implemented and immediately rejected in local visual review because it overlaid the authored Wizard/table art with a second, incompatible visual language. The gray procedural dealer hands, large inlaid zones, dense orange geometry and extra props made the table feel like a debug/HUD layer rather than a dark-fantasy card scene.

That experiment has been superseded by a **clean table-art pass**, implemented and confirmed locally:

- the procedural dealer hands are removed entirely; the authored Wizard art remains the only visible character/hand treatment;
- large side inlays, heavy orange frames, extra coins/wax props, stitched borders and dense rune geometry are removed;
- the central cloth/sigil is reduced to a very faint grounding treatment rather than a second UI frame;
- deck and discard remain as small physical card stacks with understated labels, preserving the useful "real table" read without side panels;
- the 12-card progress spread remains, but is reduced to tiny low-contrast diamond marks plus a restrained boss marker;
- all successful physical behavior from the previous pass remains: deal-from-deck motion, card fan, hover lift, choose/discard animation, Wizard substitution timing and centered single-card states;
- the guiding rule is now **authored background first, live cards second, supporting table UI last**.

A follow-up **table hierarchy polish pass** is now implemented in GitHub and pending local verification after screenshot review:

- the painted background-card row is pushed back with a quiet lower-table veil so it reads as authored scenery rather than a second interactive card layer;
- the top stats HUD is shorter, lighter and less opaque;
- the Wizard commentary strip is also reduced in height/opacity so more of the authored character art stays visible;
- the squad button is reduced to the same quieter chrome instead of reading as a separate heavy panel;
- the fate track moves to the top edge of the table, becomes lower-contrast, and the text is reduced from **РАСКЛАД СУДЬБЫ • 02/12** to the compact **02/12** counter;
- live cards, deck/discard piles and all physical deal/hover/selection animations remain unchanged.

A first **multi-arena battle pass** is now implemented in GitHub and pending local visual verification:

- `EncounterData` now carries a data-driven `arena_id`;
- Act 1 combat encounters are distributed across four arena families instead of sharing one presentation:
  - **crypt** — warm underground stone, arches and braziers;
  - **graveyard** — cold moonlit tint, tombstones, dead trees and low fog;
  - **ossuary** — bone arches, bone piles and warmer sepulchral light;
  - **warden** — a dedicated Bone Warden lair built on the ossuary family with chains, a sealed gate and the existing phase rune treatment;
- arena dressing is rendered below units inside the existing live `Arena` layer, so combat readability, placement bounds and unit logic are unchanged;
- the same authored base battle backdrop is intentionally reused for vertical-slice cohesion, while family-specific lighting/silhouettes/foreground structures make encounters read as different locations;
- current mapping: Bone Patrol/Crypt Guard -> crypt; Graveyard Ambush/Gallows Volley/Grave Bell -> graveyard; Bone Crush/Ossuary Gate/Death Wager -> ossuary; Bone Warden -> warden.
- the initial Godot 4.7.2 parser conflict with the built-in `CanvasItem.draw_ellipse()` name was fixed by renaming the local arena ellipse helper; multi-arena visuals remain pending local verification.
- follow-up screenshot review exposed visible softness from presenting the original 640×360 arena derivatives at the 1280×720 battle viewport;
- production now uses **true native 1280×720 WebP backdrops** rebuilt from the preserved 1672×941 authored source renders for **crypt**, **graveyard**, **ossuary** and **warden**;
- the HD assets are encoded at high WebP quality and were committed through a repository-safe staged base64 path, avoiding the earlier binary truncation failure;
- `authored_backdrop.gd` continues to bypass Godot's compile-time texture importer: it reads the WebP bytes with `FileAccess`, decodes them via `Image.load_webp_from_buffer()`, and caches the resulting `ImageTexture`;
- because the production sources are already 1280×720, the Lanczos resize path is now only a defensive fallback rather than the normal presentation path;
- linear texture filtering is retained only for fractional window scaling; at the 1280×720 prototype viewport the authored arena art is displayed at native resolution;
- combat geometry, unit positions, `arena_id` mappings and Bone Warden dynamic rune effects are unchanged.

## Player-facing language

All player-facing UI text, card text, reward text, wizard lines and unit display names are Russian.

Technical identifiers, file names, node names, class names and code remain English.

## Engine

- Godot 4.7.x
- GDScript
- Main scene: `res://scenes/main/main.tscn`
- First-run story scene: `res://scenes/intro/intro.tscn`
- Rendering method: GL Compatibility
- Prototype resolution: 1280×720
- `RunState` is registered as an autoload singleton.

## Current playable flow

### 1. Main screen

`scenes/main/main.tscn`  
`scripts/main/approved_main_backdrop.gd`

The production main menu is now a dedicated, user-approved authored pixel-art splash rather than a live recomposition of the wizard-table scene.

Visual content baked into the approved splash:

- the Wizard looming behind the cursed table;
- large MISDEAL title;
- **«Проклятая партия уже разложена.»**;
- five cards across the table;
- player hands in the foreground;
- candles, skulls, moonlit gothic architecture and an hourglass;
- painted **ВОЙТИ В ИГРУ** CTA.

Runtime art is reconstructed from:

- `assets/pixel/main/approved_splash_hd/part_00.txt`;
- `part_01.txt`;
- `part_02.txt`.

The source image is a native 1280×720 WebP encoded across those chunks and rendered with linear filtering. A transparent native Godot `StartButton` sits over the painted CTA so hover/focus/click remain interactive without duplicating the artwork. Pressing it resets the run and opens the story intro.

The previous `main_visual.gd` / reused table-art menu composition is no longer active.

### 2. Story intro

`scenes/intro/intro.tscn`

The game now opens with a five-frame authored pixel-art comic prologue before the first wizard-table deal.

Narrative premise:

- the player character is old and looking back on a long life of rescues, losses and consequences;
- the Wizard is returning because of an old pact rather than meeting the player for the first time;
- he offers the impossible: replay the key decisions of that life;
- changing one saved life can erase or rewrite another life that existed because of the original choice;
- the final frame reveals the cursed cards and leads into protagonist-class selection before the first deal.

Runtime intro art lives under `assets/pixel/intro/frame_01.webp` … `frame_05.webp`, authored at 1280×720 in the same dark-fantasy pixel language as the battle/table presentation.

Controls:

- left click, **Space** or **Enter** advances;
- the painted **ПРОПУСТИТЬ** area in the top-right is backed by a real Godot button;
- **Esc** also skips;
- the final frame advances to `scenes/class_select/class_select.tscn`;
- short black fades separate frames.

Starting another run from the run-end screen skips the prologue but still opens class selection, because protagonist class is a per-run decision.

### 3. Protagonist class selection

`scenes/class_select/class_select.tscn`

Each run now begins with one protagonist rather than a guaranteed trio.

- choose **РЫЦАРЬ**, **СЛЕДОПЫТ** or **МАГ**;
- the chosen role becomes `RunState.protagonist_role` and the only initial member of `party_roles`;
- the other two roles begin with fate **НЕ РАЗЫГРАНА**;
- the scene uses the same production combat atlas as battle/status UI;
- consecutive new runs skip the story comic but return here before the table.

### 4. Wizard table

`scenes/table/table.tscn`

Act 1 now uses a two-card offer flow:

- the player resolves 12 pre-boss cards;
- before each card, the wizard offers two cards from the current difficulty tier;
- choosing one card removes the rejected alternative from that run;
- cards do not repeat inside the run;
- after cards 1-4 the pool moves from early to mid tier;
- after cards 5-8 it moves from mid to late tier;
- each 4-card tier now guarantees one combat selection: at run start each tier randomly chooses one of its first three slots as the mandatory combat slot, non-combat offers are protected before it, and that slot offers two combat cards;
- later slots in mid/late can still surface the tier's remaining combat card, so a run can contain more than the guaranteed minimum;
- after card 12 the only remaining progression card is **КОСТЯНОЙ НАДЗИРАТЕЛЬ**.

A selected combat card remains active after defeat. Returning to the table shows that same card as **ПОВТОРИТЬ**, rather than generating a fresh offer.

The structural Act 1 pool contains 24 unique pre-boss card definitions: 8 early, 8 mid and 8 late. This is intentionally large enough for twelve two-card offers where the rejected alternative leaves the run.

Currently fully implemented card mechanics:

- **КОСТЯНОЙ ДОЗОР** — three melee Skeleton units;
- **ЗАСАДА НА КЛАДБИЩЕ** — two Skeleton units plus one Bone Archer;
- **ЗАЛП С ВИСЕЛИЦЫ** — one Skeleton plus two Bone Archers;
- **ШЕПЧУЩИЙ КОЛОДЕЦ** — risk blood for hero development, pay 25 gold for a relic/build fallback, or walk away;
- **ПЕПЕЛЬНЫЙ ПРИВАЛ** — freely prepare one specific hero by taking that role's next available upgrade, or leave;
- **ЛАВКА МОГИЛЬЩИКА** — buy the next available Knight/Ranger/Mage development for 35 gold;
- **КУЗНИЦА ПРОКЛЯТИЙ** — choose one of three hero-specific artifacts, or refuse;
- **МОГИЛЬНЫЙ ЗВОН** — two Skeletons protect a Grave Bellkeeper support enemy;
- **КОСТЯНАЯ ДАВКА** — five weak Bone Thralls pressure the party through numbers and reward splash damage;
- **СТРАЖ СКЛЕПА** — elite Crypt Guard with melee splash plus two Bone Thralls; victory uses a guaranteed-artifact reward flow;
- **ЧЁРНЫЙ АЛТАРЬ** — sacrifice party HP to unlock the next Knight/Ranger/Mage upgrade, or refuse;
- **ЗАКОВАННЫЙ ПЛЕННИК** — pay to train the least-developed hero, trade blood for a relic, loot the prisoner, or leave;
- **КОСТИ ДОЛЖНИКА** — a true 50/50 gold gamble alongside safer deterministic choices; failure still uses raw stat penalties as a curse;
- **ДЕСЯТИНА ВОЛШЕБНИКА** — pay gold, pay party HP, or refuse and take a temporary wizard debt;
- **КАРТА БЕЗ ЛИЦА** — hidden outcome now yields gold, a relic or hero development; bribing guarantees development and burning can clear wizard debt;
- **КРОВАВАЯ КНИГА** — buy development with gold, trade blood for a relic/build fallback, or erase the latest hero upgrade for 70 gold;
- **СЛОМАННАЯ КОРОНА** — source-locked party-wide artifact, 40-gold break option, or melt the crown into development for the least-developed hero;
- **ПОСЛЕДНИЙ ПРИВАЛ** — late pre-boss choice to develop Knight, Ranger or Mage directly;
- **ВРАТА ОССУАРИЯ** — heavy late combat combining Crypt Guard, Grave Bellkeeper, Bone Archer and Bone Thrall;
- **ГРЕМУЧИЙ МОСТ** — early traversal risk with a 50/50 sprint, a small guaranteed gold/HP trade, or a safe crossing;
- **КОШЕЛЬ МЕРТВЕЦА** — deterministic greed ladder: more gold costs progressively more party HP;
- **ТОРГОВЕЦ СВЕЧАМИ** — early build shop: buy the next Knight/Ranger/Mage development for 25 gold;
- **КОСТЯНАЯ ПОШЛИНА** — forced mid-run payment choice: gold, blood, or a harsher confrontation that costs HP but develops the least-developed hero;
- **СТАВКА НА СМЕРТЬ** — late five-enemy elite combat against Crypt Guard, two Bone Archers and two Bone Thralls, followed by +60 gold / relic / extra hero-upgrade reward choice.

All 24 pre-boss cards now have bespoke mechanics. `scenes/event/prototype_card.tscn` remains only as unused legacy prototype infrastructure and is no longer referenced by the active Act 1 card pool.

The table displays:

- current card progress out of 12, or **БОСС**;
- gold;
- current party size out of 3;
- current hero-development count;
- current relic count;
- **ДОЛГ ВОЛШЕБНИКУ** when active;
- an **ОТРЯД [TAB]** control that opens the squad-status modal over the current deal.

Selecting a card stores it as the active run card. Combat cards also select their `EncounterData`; event/prototype cards route to their configured scene.

The wizard table now uses a hybrid authored-art + live-UI composition based on the approved concept stored at:

- `assets/concepts/approved_table_direction.png`

The battle screen now follows its own approved pixel-art direction stored at:

- `assets/concepts/approved_battle_direction.jpg`

The battle remains live Godot UI/combat rather than a baked screenshot; the reference is used for composition, density, scale and palette.

Runtime table assets derived from that concept:

- `assets/pixel/table/table_wizard_layer.png` — wizard/room backdrop;
- `assets/pixel/table/misdeal_logo.png` — title logo;
- `assets/pixel/table/cards/bone_patrol.png`;
- `assets/pixel/table/cards/graveyard_ambush.png`;
- `assets/pixel/table/cards/gallows_volley.png`;
- `assets/pixel/table/cards/whispering_well.png`;
- `assets/pixel/table/cards/bone_warden.png` — dedicated final-boss card art.

The lower tabletop, ritual runner and sigil remain procedural so the layout can stay responsive to live UI. Earlier procedural side props and candles were removed after local visual review because they conflicted with the authored backdrop.

The table still uses real Godot `Button` controls. Two existing card slots are now populated dynamically from `RunCardData`, including title, type, description, wizard hover line and art path.

The top HUD remains dynamic and now emphasizes Act 1 progress, gold, **РАЗВИТИЕ** count and **РЕЛИКВИИ** count. If wizard debt is active, **ДОЛГ ВОЛШЕБНИКУ** is also shown.

### Squad status

`scenes/table/squad_status.tscn`  
`scripts/table/squad_status.gd`

The table now has a read-only **ДОСЬЕ ОТРЯДА** modal for inspecting the current run build.

The dossier also represents companion fate. Heroes outside the current party remain selectable as faded entries:

- **СУДЬБА НЕ РАЗЫГРАНА** — recruitment is still possible if a relevant card is actually played;
- **ПОТЕРЯН** — the player personally reached a recruitment scene and chose not to save that companion;
- joined companions immediately switch to normal stat/build presentation.

It opens on the currently chosen protagonist.

- Tab or **ОТРЯД [TAB]** opens/closes it without changing the current card offer;
- Esc closes it;
- 1 / 2 / 3 switches between Knight, Ranger and Mage;
- portraits are sliced from the same production 3×3 combat-unit atlas used in battle;
- each hero shows final HP, damage, attacks/second, range, move speed and damage/second;
- Ranger/minimum-range and Knight/Mage splash stats appear only when relevant;
- changed values are compared against the hero's base `UnitData` value;
- the right side lists the hero's acquired upgrades and every relic currently affecting that hero, including party-wide relics;
- the footer shows legacy party HP/damage effects, optional-upgrade progress and wizard debt;
- the hero subtitle becomes a lightweight dynamic build name such as **ЖЕЛЕЗНАЯ СТЕНА**, **СНАЙПЕР**, **ЗАЛПОВИК**, **ПИРОМАНТ** or **СТЕКЛЯННАЯ ПУШКА**.

`RunState.get_effective_hero_stats()` mirrors battle spawning: global party bonuses -> hero upgrades -> artifacts -> solo/duo compensation -> minimum HP/damage clamps. The status UI does not store a second copy of character stats.

The earlier painted assets under `assets/art/` remain in the repository as historical/reference material.

### 4. Whispering Well event

`scenes/event/whispering_well.tscn`

The dedicated event now has two modes.

If Mage is still an unresolved companion fate:

- pay blood (-20 party HP) and recruit Mage;
- pay 25 gold and recruit Mage safely;
- walk away and mark Mage **ПОТЕРЯН** for this run.

If Mage is already the protagonist/joined/lost, the card falls back to its build/relic event behavior.

The event remains one-time because its card leaves the run after being offered. Resolving it completes the current Act 1 card and advances card progress.

### 5. Combat

`scenes/battle/battle.tscn`

Player party is now variable:

- the run always starts with exactly one chosen protagonist;
- recruited companions are added permanently for the rest of that run;
- combat can therefore be solo, duo or trio.

Enemy composition and spawn positions still come from the selected `EncounterData` Resource.

Before combat, the player can drag every currently recruited hero within the deployment zone.

Implemented combat behavior:

- three pre-battle tactical orders: **НАТИСК**, **ОХОТА**, **СТРОЙ**;
- **НАТИСК** preserves nearest-enemy focus and gives heroes +15% movement speed for faster engagement;
- **ОХОТА** continuously prioritizes support enemies first, then ranged enemies, then the nearest remaining target;
- **СТРОЙ** continuously focuses the enemy closest to the currently most vulnerable living ally, causing the party to collapse onto immediate threats instead of scattering;
- orders can be changed freely during preparation and lock when **БОЙ** is pressed;
- automatic movement and attacks;
- melee and ranged attack ranges;
- Bone Archer keeps distance and retreats when enemies get too close;
- all combat movement is clamped to the visible arena;
- Mage attacks deal 50% splash damage to nearby secondary enemies;
- separation steering prevents units from stacking into one point;
- HP bars;
- hit flash, impact pulse and floating damage numbers;
- death shrink/fade feedback;
- victory and defeat detection;
- boss units can use data-driven visual scale and a one-time enrage threshold;
- Bone Warden uses its own dedicated high-detail `bone_warden` atlas sprite instead of an enlarged normal Skeleton;
- Bone Warden has 700 HP, 24 base damage, a 60%-damage melee cleave in a 92 px radius, and a larger boss HP/name treatment;
- at 50% HP Bone Warden still enrages, increasing damage, attack speed and movement speed, but now also triggers **Phase II** and summons one Bone Archer plus one Bone Thrall;
- the phase transition changes the boss label to **БОСС • ЯРОСТЬ**, shows a centered **ФАЗА II — ПРИЗЫВ** cue and switches the arena into its stronger phase-two ritual state;
- Grave Bellkeeper is the first support enemy: every 4.5 seconds it heals damaged allied undead within 210 px for 18 HP and shows a visible **ЗВОН!** cue;
- Bone Thrall is a smaller, faster, low-HP swarm enemy;
- Crypt Guard is a slower elite melee enemy with a larger silhouette, visible name and 35% splash damage around its primary target.

Hero stats receive persistent run bonuses from `RunState`. After upgrades and relics, incomplete parties receive visible compensation: solo x2.2 HP, x1.9 damage, x0.80 attack interval and x1.10 movement speed; duo +20% HP/+15% damage; trio none. Enemy HP/damage pressure is also party-size-aware (solo 82%/80%, duo 92%/90%, trio 100%/100%) while encounter composition and AI remain authored. Final spawned hero max HP is clamped to at least 20 and damage to at least 1.

After victory, **ЗАБРАТЬ НАГРАДУ** opens the reward scene.

After defeat, **ВЕРНУТЬСЯ К СТОЛУ** returns to the same run without increasing the victory count.

**ПЕРЕИГРАТЬ** remains available as a prototype/testing convenience.

### 6. Reward

`scenes/reward/reward.tscn`

The first combat victory in each early/mid/late tier opens **РАЗВИТИЕ ОТРЯДА** when at least one hero upgrade remains. The player chooses one offered Knight/Ranger/Mage upgrade; this guaranteed tier choice does **not** consume the optional-upgrade cap.

After that:

- ordinary combat loot is **+25 gold**;
- if **ДОЛГ ВОЛШЕБНИКУ** is active, that normal gold loot becomes **+50 gold** and clears the debt;
- Crypt Guard keeps its unowned-artifact reward;
- Death Wager offers **+60 gold / a shown available relic / one extra hero-upgrade choice**;
- if the run has already used all 3 optional hero-upgrade slots, Death Wager's extra-upgrade option becomes **+45 gold** instead of opening an empty selection.

Choosing the final reward completes the active combat card.

Normal combat victories return to the table and advance Act 1 card progress.

After defeating Bone Warden and resolving its reward flow, `boss_defeated` becomes true and the player goes to the run-end screen.

### 7. Run end

`scenes/run_end/run_end.tscn`

After 12 resolved pre-boss cards plus the Bone Warden, the run ends and displays:

- pre-boss cards completed;
- combat victories;
- gold;
- accumulated HP bonus;
- accumulated damage bonus.

**НОВЫЙ ЗАБЕГ** resets `RunState` and returns to the wizard's table.

## Current architecture

### Unit data

Reusable combat stats are stored in `UnitData` Resources:

- `scripts/data/unit_data.gd`
- `resources/units/knight.tres`
- `resources/units/ranger.tres`
- `resources/units/mage.tres`
- `resources/units/skeleton.tres`
- `resources/units/bone_archer.tres`
- `resources/units/bone_warden.tres`
- `resources/units/grave_bellkeeper.tres`
- `resources/units/bone_thrall.tres`
- `resources/units/crypt_guard.tres`

Runtime combat state remains on `BattleUnit`.

`UnitData.visual_role` now selects dedicated 96×96 regions from the unified combat atlas:

- `assets/pixel/units/combat_units_v3/part_00.txt` … `part_09.txt` — final v3 PNG atlas data, decoded at runtime by `BattleUnit`;
- `assets/pixel/units/combat_units_v3/part_00.txt` … `part_09.txt` — the sole production atlas source; `BattleUnit` validates the reconstructed 288×288 PNG before use

Atlas layout:

- row 1: Knight, Ranger, Mage;
- row 2: Skeleton, Bone Archer, Grave Bellkeeper;
- row 3: Bone Thrall, Crypt Guard, Bone Warden.

All nine roles use authored transparent pixel art. Grave Bellkeeper, Bone Thrall and Crypt Guard no longer reuse tinted Skeleton art. The older per-unit PNG files remain in the repository as historical/reference assets but are no longer loaded by combat.

Combat presentation now uses the approved second gothic mockup as an authored static backdrop while keeping all gameplay layers live:

- all current combat roles use the new unified high-detail transparent pixel atlas;
- combat sprites remain substantially larger so silhouettes read like characters rather than small board icons;
- thin blue/red team rings, HP bars, names, drag placement, combat movement and targeting remain live Godot elements;
- the cathedral/crypt architecture, throne/altar, pillars, banners, chains, braziers, skull piles, ritual floor, outer frame and command-panel art are baked into the authored backdrop;
- the authored backdrop is reconstructed at runtime by `scripts/battle/authored_backdrop.gd` from five validated base64 WebP chunks under `assets/pixel/battle/authored_backdrop/`; the decoded image is 1280×720 and uses nearest-neighbor presentation;
- `scripts/battle/battle_visual.gd` no longer draws the general arena and now only adds lightweight dynamic boss-phase overlays;
- the obsolete procedural `scripts/battle/battle_hud_visual.gd` renderer was removed;
- encounter title/status, card progress, faction labels, buttons and result text remain native Godot controls layered over the art;
- **БОЙ** and **ПЕРЕИГРАТЬ** now sit directly over the painted command frames from the backdrop instead of drawing a second competing UI frame.

The older painted unit assets under `assets/art/units/` remain in the repository for reference but are no longer used by combat.

### Encounter data

`scripts/data/encounter_data.gd`

Encounter Resources currently define:

- encounter id;
- Russian title and card text;
- wizard line;
- enemy UnitData paths;
- enemy display names;
- enemy spawn positions;
- optional phase/reinforcement unit paths, names and spawn positions.

Current encounter files:

- `resources/encounters/bone_patrol.tres`
- `resources/encounters/graveyard_ambush.tres`
- `resources/encounters/gallows_volley.tres`
- `resources/encounters/bone_warden.tres` — final-deal boss encounter;
- `resources/encounters/grave_bell.tres`;
- `resources/encounters/bone_crush.tres`;
- `resources/encounters/crypt_guard.tres` — elite encounter with guaranteed artifact reward;
- `resources/encounters/ossuary_gate.tres` — late mixed-archetype combat before the boss;
- `resources/encounters/death_wager.tres` — late five-enemy elite wager encounter.

### Run-card data

`scripts/data/run_card_data.gd`

Act cards are data-driven Resources containing:

- card id;
- Russian title/description/wizard line;
- display type;
- early/mid/late tier;
- resolution type;
- target encounter/event scene;
- art path;
- temporary prototype-result text.

Act 1 card resources live under `resources/cards/`.

### Artifacts

`scripts/data/artifact_data.gd`

The first artifact layer is data-driven and persists for the current run through `RunState.artifact_ids`.

Current artifacts:

- **ЩИТ МЕРТВЕЦА** — Knight +40 HP, -15% move speed;
- **СЛЕПОЙ КОЛЧАН** — Ranger attacks 22% faster but gains +55 minimum range;
- **РАСКОЛОТЫЙ ФОКУС** — Mage deals 15% less primary damage but gains +55 splash radius and +0.25 splash multiplier;
- **СЛОМАННАЯ КОРОНА** — special party-wide artifact: all heroes +22% damage and -10 max HP.

`ArtifactData.general_pool` separates normal shop/elite/random artifacts from source-locked special artifacts. **СЛОМАННАЯ КОРОНА** has `general_pool = false`, so it can only be acquired from its named card. Party-wide artifacts use `target_role = "*"`.

Artifacts are applied to hero runtime stats when combat units spawn. The run-end summary now lists acquired artifacts.

### Hero upgrades

`scripts/data/hero_upgrade_data.gd`

Act 1 now has nine unique persistent hero upgrades, three for each party member:

- Knight: **ЖЕЛЕЗНАЯ КЛЯТВА**, **ПАЛАЧ**, **РАЗМАШИСТЫЙ УДАР**;
- Ranger: **ДАЛЬНИЙ ВЫСТРЕЛ**, **ГРАД СТРЕЛ**, **ЗВЕРИНАЯ ТРОПА**;
- Mage: **ПОЖАР**, **СТЕКЛЯННОЕ СЕРДЦЕ**, **ПЕРЕГРУЗКА**.

Each early/mid/late tier guarantees one major hero-upgrade choice after the first combat victory in that tier. The reward screen offers one available upgrade for Knight, Ranger and Mage, so the player can spread growth across the party or specialize the same hero in all three tiers.

Optional event/Death Wager development is now capped at **3 extra upgrades per run**. These extra slots are tracked separately from the three guaranteed tier upgrades, so a normal strong run should reach roughly 4–6 total upgrades instead of exhausting all nine. If Blood Ledger erases an upgrade that came from an extra slot, that extra slot becomes available again.

Hero upgrades persist for the current run in `RunState.hero_upgrade_ids` and are applied when player units spawn, before artifacts. They can modify HP, damage, attack cadence, range, minimum range, splash and move speed.

Special combat rewards remain intact after the tier upgrade:

- Crypt Guard still grants an artifact reward;
- Death Wager now offers **+60 gold / a shown unowned artifact / one extra hero-upgrade choice**;
- normal combat loot is now gold-only instead of another permanent party-wide HP/damage choice;
- wizard debt still doubles the next normal gold loot and is not consumed by major upgrades or special rewards.

The wizard-table HUD now emphasizes **РАЗВИТИЕ** and **РЕЛИКВИИ** instead of treating global HP/damage counters as the primary build identity.

A read-only **ДОСЬЕ ОТРЯДА** modal is now implemented on the wizard table and pending local verification. It opens from the new **ОТРЯД [TAB]** button or the Tab key without regenerating the current card offer.

The shared `scenes/event/act_choice.tscn` scene handles the implemented choice-driven events. Its progression-facing cards now query the live hero build and show the actual next upgrade name on the choice button when relevant. The scene still intentionally avoids a generalized event-effect framework.

### Hard-roguelike party composition and companion fates

The two non-protagonist heroes are no longer guaranteed party members.

Recruitment routes:

- **Knight** — primary: **ЗАКОВАННЫЙ ПЛЕННИК**; fallback: **ПОСЛЕДНИЙ ПРИВАЛ**;
- **Ranger** — primary: **ГРЕМУЧИЙ МОСТ**; fallback: **ПЕПЕЛЬНЫЙ ПРИВАЛ**;
- **Mage** — primary: **ШЕПЧУЩИЙ КОЛОДЕЦ**; fallback: **ЧЁРНЫЙ АЛТАРЬ**.

Important fate rule:

- if a recruitment card is merely not offered or is rejected at the two-card table choice, that companion remains **НЕ РАЗЫГРАНА** and can still appear through the fallback route;
- if the player actually enters a recruitment scene and chooses a branch that abandons the companion, that role becomes **ПОТЕРЯН** and cannot be recruited later in the run.

Upgrade and general-pool artifact offers only target heroes currently in the party. A solo major reward can show all three remaining upgrade paths for that one hero; duo/trio offers are built only from recruited roles.

Solo compensation is now x2.2 HP, x1.9 damage, x0.80 attack interval (+25% attacks/second) and x1.10 move speed. Duo compensation remains +20% HP/+15% damage. Enemy pressure now also scales transparently by party size (solo 82% HP/80% damage, duo 92% HP/90% damage), while authored compositions stay fixed.

### Run state

`scripts/core/run_state.gd`

The current prototype run state stores:

- gold;
- combat victories in `deals_survived` for backward compatibility;
- resolved pre-boss card count;
- remaining, offered, rejected and resolved card ids;
- active selected card id;
- global party HP bonus;
- global party damage bonus;
- last battle result;
- selected encounter path;
- boss completion state;
- persistent artifact ids;
- per-run protagonist role;
- current `party_roles`;
- companion fate state + fate notes for all three hero roles;
- persistent hero-upgrade ids;
- derived effective hero-stat inspection for the squad-status UI;
- claimed major-upgrade tier indices;
- stable pending major/bonus upgrade offers;
- temporary `wizard_debt_active` state;
- randomized per-tier mandatory-combat slot indices in `forced_combat_slots`.

Act 1 ends after 12 resolved pre-boss cards plus Bone Warden.

## Not implemented yet

- follow-up Act 1 balance pass after local full-run feedback on the capped progression economy and retuned boss;
- broader shop inventory/economy beyond the current Candle Seller and Gravedigger Shop implementations;
- more artifacts beyond the first three;
- attack projectiles/animations;
- broader ability/status-effect system;
- richer evil wizard presentation;
- deck building / card unlocks;
- meta progression;
- save/load.

## Immediate next milestone

- approved main-menu splash must decode cleanly, fill the 1280×720 viewport and show no duplicated live title/tagline layers;
- painted **ВОЙТИ В ИГРУ** area must remain clickable/focusable through the transparent Godot hotspot and route to the comic intro;


Locally verify the full card-art integration first:

- every table card in the 24-card Act 1 pool plus **Bone Warden** must show its own matching approved illustration;
- **ГРЕМУЧИЙ МОСТ**, **КОШЕЛЬ МЕРТВЕЦА**, **КРОВАВАЯ КНИГА**, **СТРАЖ СКЛЕПА**, **КОСТЯНАЯ ДАВКА** and the other formerly repeated cards must no longer reuse unrelated art;
- all nine **РАЗВИТИЕ ОТРЯДА** paths must have distinct illustrations, especially Ranger paths that previously fell back to repeated role art;
- ordinary loot, Death Wager and elite rewards must show the approved Blood Coin / Gold Windfall / Relic Wager / Bonus Upgrade / Empty Cache / Elite Relic art without text overlap;
- card art should remain crisp under nearest filtering and no procedural icon placeholders should appear.

Locally verify the new hard-roguelike party flow end to end:

- main menu -> story intro -> class selection -> table;
- after choosing a class, battle must spawn only that protagonist;
- solo battle/status must show x2.2 HP, x1.9 damage, x1.25 attacks/second and x1.10 movement compensation plus the visible enemy-pressure reduction;
- recruiting one companion must immediately switch future battles to duo and compensation to +20% HP/+15% damage;
- recruiting both must produce a normal trio with no compensation;
- major/bonus upgrade offers and general-pool relics must only target heroes currently in the party;
- **Knight** recruitment: Chained Prisoner or, if still unresolved, Last Camp;
- **Ranger** recruitment: Rattling Bridge or, if still unresolved, Ash Rest;
- **Mage** recruitment: Whispering Well or, if still unresolved, Black Altar;
- rejecting a recruitment card at the table must leave fate unresolved;
- entering a recruitment event and deliberately abandoning the companion must mark them **ПОТЕРЯН** and block the fallback recruitment later;
- **ДОСЬЕ ОТРЯДА** must show unresolved/lost companions as faded fate entries and open on the protagonist;
- class-selection cards must keep portraits and all text in separate non-overlapping regions at 1280×720;
- long wizard-table card descriptions must remain inside their clipped description area and never touch **ВЫБРАТЬ**;
- victory/defeat result panels and bottom actions must remain above all unit sprites, HP bars, names and floating combat text;
- run-end summary must list final party and companion fates;
- Bone Warden must remain a fixed benchmark and be tested solo, duo and trio before changing boss stats again;
- verify all three tactical orders in normal, elite and Bone Warden combat: **НАТИСК** should visibly engage faster, **ОХОТА** should retarget to Bellkeeper/Archers including spawned reinforcements, and **СТРОЙ** should react to the ally currently under the most pressure.

Do not add more companion classes until this three-role recruitment loop is locally validated.

## Local workflow

The browser-side assistant edits the GitHub repository.

The user keeps a local clone and normally updates with:

`git pull`

`UPDATE_MISDEAL.bat` is also present as a one-click pull helper.

- Hero development, Curse Forge, Chained Prisoner and Wizard Wager were re-aligned to their approved visual mockups with taller illustrated cards and stronger ceremonial framing.

- Curse Forge and Chained Prisoner now use the same tall illustrated choice-card proportions as their approved mockups, with approved atlas art occupying the upper half of each choice; the Wizard Wager modal is enlarged and gains a central ritual sigil/divider treatment.

- the approved Forge and Chained Prisoner references now also contribute dedicated character/environment decor (blacksmith / chained prisoner) through a runtime-decoded WebP atlas stored as raw .bin, so these two event scenes no longer read as the generic Wizard table with different text;

- 2026-10-07 screenshot correction: Curse Forge, Chained Prisoner and the Wizard wager were re-laid out against the approved attached references rather than merely sharing generic event chrome; this is presentation-only and leaves their mechanics unchanged.

## UI-kit screenshot correction — 2026-10-08

Fresh 1280×720 local screenshots confirmed the shared chrome direction is working well on the Act Choice and Reward/development screens, but exposed two first-pass regressions. The main-menu and intro controls are authored-image click hotspots and must stay transparent; applying generic action-button chrome produced empty dark rectangles over the art. Those two hotspots now keep their original transparent treatment.

Resolved shared Act Choice screens now hide the obsolete leave button, reserve a dedicated result strip, and present a single centered `К СТОЛУ` action. This specifically fixes Candle Seller result text overlapping the bottom actions after a purchase.

## Act 1 party-size balance pass — 2026-10-08

A first full-run-oriented party-size pressure pass is now in `main` and pending local solo/duo/trio verification.

The previous approach only amplified incomplete-party heroes while every enemy pack retained full trio-authored durability and damage. That left solo Ranger/Mage openings too close to a raw action-economy loss, especially when the first forced combat arrived before a useful event.

Current baseline:
- **solo hero:** HP ×2.2, damage ×1.9, attack interval ×0.80 (+25% attacks/sec), movement ×1.10;
- **solo enemies:** HP ×0.82, damage ×0.80;
- **duo heroes:** HP ×1.20, damage ×1.15;
- **duo enemies:** HP ×0.92, damage ×0.90;
- **trio:** authored 100% enemy baseline, no party compensation.

Enemy composition, AI, ranges, attack cadence and boss mechanics are unchanged. Enemy support healing scales with the same enemy-HP factor so Grave Bell-style healing does not become disproportionately strong in incomplete-party runs. Wizard Debt / Wizard Mark danger bonuses multiply on top of the party-size damage baseline rather than bypassing it.

Act 1 opening pacing also changed conservatively: the tier-0 forced-combat slot is now 1 or 2 instead of 0–2, guaranteeing at least one non-combat decision before the first mandatory fight. Mid/late tiers retain the previous 0–2 forced-combat timing.

This supersedes the earlier static-balance assumption that enemies/bosses never scale by party size; the authored encounter compositions and full-trio numbers remain the reference baseline.

## Target-intent visibility toggle — 2026-10-08

Local review confirmed the new pre-battle target lines are useful but too visually heavy when always enabled. Battle preparation now has a dedicated centered `ЦЕЛИ: ВКЛ/ВЫКЛ` toggle above the `БОЙ` button. Target intents are **off by default**, can be enabled only when the player wants to inspect focus, and still disappear automatically when combat begins.

The preference is stored on the persistent `RunState` autoload but deliberately not reset by `reset_run()`, so the player's choice persists between battles and new runs for the lifetime of the current app session. The underlying preview logic and combat AI are unchanged.

## SceneTransition autoload resilience hotfix — 2026-10-08

Local Godot 4.7.2 compilation exposed a project-file edge case: a user-local `project.godot` conflict could leave the new `SceneTransition` autoload entry absent even though the transition script and all navigation call sites had already been pulled. Direct references such as `SceneTransition.change_to(...)` then fail at parse time before the project can run.

Scene navigation now goes through `scripts/core/scene_router.gd`. The router uses the registered `/root/SceneTransition` singleton when available, but if the editor/local project file has not registered it yet, it creates the same persistent transition node dynamically under the root and routes navigation through that instance. Active main/intro/class-select/table/event/battle/reward/run-end call sites no longer require the autoload identifier to exist at parse time.

This keeps the seamless-transition system functional while making pulls robust against local `project.godot` divergence. The canonical repository project file still registers `SceneTransition` normally.

## Empty-frame transition elimination + target-intent preview — 2026-10-08

Local testing still exposed an intermittent full-gray frame despite the first persistent veil. The transition system no longer delegates the actual swap to `SceneTree.change_scene_to_file()`. `SceneTransition` now starts threaded loading while the outgoing scene remains alive, instantiates the incoming PackedScene before blackout, renders at least one fully opaque transition frame, manually adds the new scene while the old scene still exists, switches `current_scene`, frees the old scene, waits for the new runtime-art/layout frames to render, then reveals the result. The renderer clear color is also forced to the same near-black tone at runtime.

This removes the actual empty-scene interval instead of only masking it. All existing call sites continue to use the same `SceneTransition.change_to()` / `reload_current()` API.

Battle preparation also gains a lightweight **target-intent preview**. While placement is active, blue intent arrows show each hero's current first target under the selected tactical order and red intent arrows show each enemy's current first target. The preview updates live while heroes are dragged or the order changes and disappears when combat begins. It reads the existing targeting AI rather than adding a second prediction system, so placement now exposes real tactical information without changing combat rules or stats.

## Main splash replacement + seamless scene transitions — 2026-10-08

The locally rejected low-quality first splash has been replaced by the user-approved restrained dark-gothic redraw with the Wizard brought back into the current Misdeal visual language. Runtime art is now a native **1280×720 WebP** at `assets/pixel/main/approved_splash_hd/main_splash.webp`, loaded through `FileAccess + Image.load_webp_from_buffer()` in `scripts/main/approved_main_backdrop.gd`. The old three-part compressed splash representation is no longer the runtime source.

The brief gray viewport flash seen when moving into battle or returning to the table after events is also addressed globally. `SceneTransition` is now a persistent autoload CanvasLayer with a dark veil: it fades over the outgoing scene, survives the actual scene replacement, keeps the viewport covered while the incoming scene finishes runtime-art setup, then fades away. All active scene changes and battle reloads route through this helper. The project default clear color is also set to the same near-black tone as a final safety net.

This pass changes presentation/loading only; card choice, encounter selection and run state are unchanged. Pending local verification after a fresh pull/restart.

## Shared gothic UI-kit pass — 2026-10-08

A first shared runtime **Misdeal UI kit** is now in `main` and pending local screenshot verification. `scripts/ui/misdeal_ui_kit.gd` unifies live Godot panels and buttons without baking mutable text or values into images: square pixel-gothic borders, bronze/gold/ember/steel semantic accents, compact corner marks, stronger ceremonial frames and consistent normal/hover/pressed/disabled button states.

The kit is wired into the main menu, intro skip action, Class Select, Wizard table, Wizard wager, Squad Dossier, shared Act 1 event choices, Whispering Well, Reward, Battle HUD / Last Deal and Run End. Existing authored choice art, artifact art, event backdrops and live mechanics are preserved; this pass changes presentation chrome only.

This intentionally answers the earlier visual mismatch where authored environments and approved choice illustrations sat under mostly independent StyleBoxFlat treatments. Further changes should come from fresh 1280×720 screenshots rather than inventing another parallel UI system.

## Production art-direction consistency pass

A first production art-direction consistency pass is now in `main` and pending local screenshot review. `docs/ART_DIRECTION.md` defines the authored low-resolution target. A shared CanvasItem shader now reduces painterly smoothness and pushes large source art toward a tighter Ink / Stone / Bone palette while preserving restrained Rust / Teal / Gold accents. The first reference surfaces are the Wizard table, authored battle backdrops and Whispering Well. Battle backdrops also use nearest filtering/resampling, and Whispering Well's procedural background has fewer candles and quieter glow. This is a consistency layer; visibly malformed source geometry still requires actual redraw.

## Approved Bone Crush arena redraw

The first true source-art replacement from the production art-direction pass is now in `main` and pending local screenshot verification. **КОСТЯНАЯ ДАВКА** no longer reuses the dense Ossuary backdrop. It has a dedicated lower-detail gothic hall derived from the approved concept: fewer lights, simpler readable architecture and larger quiet floor masses. The source is stored as split base64 WebP parts, matching the existing combat-unit atlas pattern, and is intentionally exempt from the corrective environment grade because it was authored directly toward the new target. Placement zones also moved away from blue debug rectangles toward faint warm floor/chalk markings.

## Visual checkpoint — 2026-10-08

The user locally reviewed the first production art-grade pass on the Wizard table and several battle arenas and confirmed the game still works. The screenshots made the remaining visual problem clearer: grading alone cannot remove the strongest generated-art tells.

Observed problems from the local screenshots:

- **Bone Crush / ossuary-style arenas are still the strongest offender**: too many candles, bone ornaments and cathedral details competing at the same visual frequency. They read as a fantasy wallpaper rather than an authored game arena.
- **Gallows Volley is a better direction reference** because it has large readable masses (sky/moon, architecture, floor) and more negative space.
- The Wizard table is more coherent after grading, but some **card illustrations still read as tiny generic fantasy landscapes** instead of one clear object/subject.
- The current environment grade can crush dark card/wager images too far toward black; future tuning should preserve more midtone information.
- The translucent blue deployment rectangles read as **debug UI**, not part of the world.
- UI hierarchy is functional, but the clean modern panels and the very ornate source art still feel like two different visual languages.

The user approved moving to a real redraw/replacement pass rather than trying to solve this with stronger shaders.

The first redraw target is **КОСТЯНАЯ ДАВКА**. The approved direction shown in-chat uses:
- simpler, physically readable crypt architecture;
- roughly one third of the current candle count;
- large dark wall/floor masses and deliberate negative space;
- two red hanging banners and a single central throne/statue focal point;
- a broad readable combat floor with one central ritual circle;
- deployment lanes represented as worn/etched floor markings rather than blue panels;
- no baked heroes, enemies, health bars, labels or gameplay text in the background.

Important: the newly drawn Bone Crush direction is **concept/reference only and is not yet wired into runtime**. The next implementation should add a dedicated Bone Crush arena id/asset rather than replacing the shared Ossuary backdrop used by other encounters.

After Bone Crush is proven locally, the same redraw language should be propagated selectively to the worst remaining arenas and then to object-first card art.


## Visual redraw pass — first object-first card batch

The broader production-art replacement pass has moved from arena-only work into table-card art. The first object-first card redraw batch is now wired into runtime for **ГРЕМУЧИЙ МОСТ**, **КОШЕЛЬ МЕРТВЕЦА** and **ШЕПЧУЩИЙ КОЛОДЕЦ**. These three cards bypass their old atlas cells and decode dedicated 224×137 WebP art from repository-safe base64 text assets. The shared card grade is deliberately lighter so authored midtones survive instead of collapsing toward black.

This is the first runtime batch of the user-approved full visual redraw direction. Existing card mechanics, titles, descriptions, prices and event logic remain live Godot UI and are unchanged.


## Visual redraw rollout — 2026-10-08

The first object-first table-card batch is live in main. **ГРЕМУЧИЙ МОСТ**, **КОШЕЛЬ МЕРТВЕЦА** and **ШЕПЧУЩИЙ КОЛОДЕЦ** now use dedicated 224×137 authored WebP overrides instead of their old atlas cells. The card-grade strength was reduced from 0.58 to 0.30 so the new dark pixel art keeps readable midtones.

This is the start of the user-approved broader visual redraw. Mechanics, prices, descriptions and choice state remain live Godot controls.


## Visual redraw hotfix — 2026-10-08

A runtime integration mistake in the first redraw batch was corrected. The dedicated assets for **ГРЕМУЧИЙ МОСТ**, **КОШЕЛЬ МЕРТВЕЦА** and **ШЕПЧУЩИЙ КОЛОДЕЦ** existed in the repository but CardArtCatalog still returned the old atlas cells. CardArtCatalog now checks dedicated overrides first and decodes the repository text assets into runtime WebP textures.

The Bone Crush atmosphere script also failed to parse in Godot 4.7 because loop values from an untyped array made x/y inference ambiguous. The band array and marker coordinates are now explicitly typed.


## Visual redraw quality correction — 2026-10-08

The broad low-resolution v3 redraw integration was locally rejected after screenshot review and has been removed from runtime. Its 112×69 table-card cells and 320×180 battle-arena cells were too small for their actual display sizes and produced visibly blocky/muddy results when enlarged.

The corrected v4 card pass keeps the generated redraws at the existing near-display runtime size of 224×137 per table-card cell and maps each source by semantic subject rather than generation order. Nineteen active Act 1 cards now use this correctly mapped v4 atlas: Bone Patrol, Graveyard Ambush, Gallows Volley, Rattling Bridge, Lost Purse, Whispering Well, Ossuary Gate, Grave Bell, Bone Warden, Faceless Card, Black Altar, Blood Ledger, Gravedigger Shop, Last Camp, Debtor Bones, Crypt Guard, Wizard Tithe, Curse Forge and Chained Prisoner.

The six cards without a trustworthy matching redraw source — Ash Rest, Bone Crush, Broken Crown, Candle Seller, Bone Tax and Death Wager — deliberately fall back to the already-approved 224×137 full card atlas. This means every one of the 25 active cards still has unique art; no card is allowed to borrow an unrelated generated image just to claim redraw coverage.

Battle arenas no longer use the rejected 320×180 atlas. Crypt now uses a dedicated native 1280×720 v4 redraw, and Gallows Volley has its own native 1280×720 moon/gallows arena instead of sharing Graveyard. Graveyard, Ossuary and Warden keep their validated authored high-resolution sources; Bone Crush keeps its dedicated benchmark backdrop.


## Act 1 card redraw coverage complete — 2026-10-08

The user locally confirmed the corrected v4 quality pass looks acceptable. The last six cards have now been removed from the intentional legacy-art fallback path.

Five cards use a supplementary v5 atlas at the same near-display 224×137 source size as the accepted v4 pass: **ПЕПЕЛЬНЫЙ ПРИВАЛ**, **КОСТЯНАЯ ДАВКА**, **ТОРГОВЕЦ СВЕЧАМИ**, **КОСТЯНАЯ ПОШЛИНА** and **СТАВКА НА СМЕРТЬ**.

**СЛОМАННАЯ КОРОНА** deliberately uses the already-approved object-centric Broken Crown artifact illustration. This makes the source card and the source-locked relic visually identical instead of inventing an unrelated scene.

All 25 active Act 1 table cards now resolve to current redraw/object-specific art before the legacy approved run atlas fallback. The v5 sheet is split into repository-safe base64 WebP text parts and decoded at runtime; gameplay text, prices and state remain live Godot UI.


## Battle arena v6 correction — 2026-10-08

The latest arena redraws from the current review are now the production sources for the scenes that were still visually wrong:

- graveyard: latest moonlit bell-mausoleum arena;
- ossuary: latest bone-gate crypt arena;
- warden: latest red throne / ritual-circle arena;
- bone_crush: latest broad-floor dark crypt arena;
- Bone Warden table card: latest dedicated Warden character redraw.

All four new battle sources are native 1280×720 WebP assets. Authored arena art is no longer passed through the legacy environment-grade material; that extra grade was the main cause of the crushed-black Grave Bell and Ossuary screenshots.

Bone Crush also uses floor-safe deployment/combat bounds and adjusted spawn lanes so units start and move on the visible floor plane instead of the architectural upper area.

Crypt and Gallows keep the accepted native-HD v4 sources. Gameplay rules are unchanged; this correction is visual/layout only.


## Table/wager midtone correction — 2026-10-08

Local screenshots showed that the remaining crushed-black presentation was on the Wizard table rather than the corrected battle arenas.

The table no longer applies the legacy environment grade to the authored Wizard backdrop, and live card/wager art is no longer post-darkened by the shared card grade. The Wizard wager scrim is reduced from 0.82 to 0.52 alpha and the three passive table shade layers are halved, preserving focus without hiding the table and cards.

A previously prepared Wizard/table illustration is now actually used in runtime as assets/pixel/table/visual_pass_v6/table_wizard.webp. It is a clean 1280×398 crop from the approved table direction with no baked gameplay text or buttons, so all HUD/card state remains live Godot UI.

For any older event/reward surface that still uses the shared grade materials, environment grade strength is reduced from 0.78 to 0.30 and card grade strength from 0.30 to 0.14. This is a safety correction for dark-mid readability, not a palette redesign.


## Reward/event midtone follow-up — 2026-10-08

The brightness correction was propagated one step beyond the Wizard table. The reward screen no longer tints its table backdrop brown/dark and its backdrop shade is reduced from 0.54 to 0.24 alpha. Whispering Well choice illustrations now render authored art directly instead of receiving another card-grade pass. This keeps the already-prepared reward/event art readable while all labels, prices and choices remain live UI.


## V7 screen-art rollout — 2026-10-08

The next authored-art package is now live across the remaining high-visibility legacy screens.

- **Class Select** now uses dedicated 640×480 authored portraits for Knight, Ranger and Mage instead of enlarging 96×96 combat sprites. The existing live class stats/descriptions remain native Godot UI.
- **Reward** now uses a dedicated 1280×720 treasure-altar backdrop instead of the old generic `assets/art/table_background.webp`.
- **Whispering Well** now uses a dedicated 1280×720 moonlit-well environment and no longer shows the procedural brick/well renderer behind the choice UI.
- **Curse Forge**, **Chained Prisoner** and **Black Altar** now use dedicated 1280×720 environment art through the shared `act_choice` scene. Their buttons, costs, state and consequences remain live.
- **Run End** now uses a dedicated 1280×720 Wizard-at-the-table ending illustration and disables the old procedural Wizard silhouette/table drawing.

The shared cursed-choice overlay was also softened so authored backgrounds keep readable midtones instead of being hidden under another heavy table shade.

All v7 art was exported as production WebP at near-display or full-screen resolution. No generated screen with baked gameplay labels/buttons was used as runtime UI.


## V7 WebP loader hotfix — 2026-10-08

Godot 4.7.2 local validation exposed a parser failure when the newly committed v7 WebP files were referenced directly through `preload()` or as `Texture2D` scene resources before the editor had a usable imported resource.

The v7 rollout now follows the already-proven battle-backdrop pattern: `scripts/ui/runtime_webp_texture.gd` reads the source file with `FileAccess`, decodes it with `Image.load_webp_from_buffer()`, caches the resulting `ImageTexture`, and assigns it to the live `TextureRect`.

Direct v7 WebP resource references were removed from Class Select, shared Act Choice, Reward, Whispering Well and Run End. The art itself is unchanged; this is a loading-path fix only.


## V8 event-art + dossier pass — 2026-10-08

The next secondary visual package is now integrated.

- **Торговец свечами / Candle Seller** gets a dedicated moonlit candle-market environment.
- **Лавка могильщика / Gravedigger Shop** gets a dedicated graveyard-market environment.
- **Кровавая книга / Blood Ledger** gets a dedicated gothic altar / forbidden ledger environment.
- **Карта без лица / Faceless Card** gets a dedicated ritual chamber with the floating faceless card.
- **Досье отряда / Squad Dossier** no longer enlarges 96×96 combat sprites. It now reuses the accepted 640×480 Knight / Ranger / Mage portraits from Class Select through the same runtime WebP path.

All four event environments are native 1280×720 WebP sources and are loaded through the runtime decoder to avoid Godot import/preload timing failures. Event text, prices, choices and consequences remain live UI.


## V9 final generic-event environment pass — 2026-10-08

The last planned batch of generic Act 1 event environments is now integrated into the shared live Act Choice screen.

Dedicated native 1280×720 authored environments now exist for:

- **ГРЕМУЧИЙ МОСТ / Rattling Bridge** — moonlit rope/chain bridge over the cursed ravine;
- **КОШЕЛЬ МЕРТВЕЦА / Lost Purse** — grave road with corpse, bones and spilled gold;
- **КОСТИ ДОЛЖНИКА / Debtor Bones** — moonlit ritual dice/debt altar;
- **КОСТЯНАЯ ПОШЛИНА / Bone Tax** — bone-tithe gate and skeletal scales;
- **ДЕСЯТИНА ВОЛШЕБНИКА / Wizard Tithe** — ceremonial tithe altar under the full moon;
- **ПЕПЕЛЬНЫЙ ПРИВАЛ / Ash Rest** — ruined cemetery camp and dying fire;
- **ПОСЛЕДНИЙ ПРИВАЛ / Last Camp** — lonely late-run camp beneath the gothic city;
- **СЛОМАННАЯ КОРОНА / Broken Crown** — ruined shrine with the broken crown as the focal object.

These sources use the same runtime WebP decoding path as the v7/v8 event art, so Godot does not depend on import-time Texture2D recognition. All event text, prices, recruit/fate state, artifact state and choice consequences remain live Godot UI.

Together with the v7/v8 packages, all of the high-priority and planned secondary Act 1 non-combat event screens now have dedicated authored environment art. Further visual work should be screenshot-driven polish rather than another broad art-replacement batch.


## Continuation checkpoint — 2026-10-08

A durable handoff is now stored in `docs/HANDOFF.md` and the complete current visual mapping/provenance is stored in `docs/VISUAL_ASSET_REGISTRY.md`.

The eight final V9 generated event compositions are additionally archived as larger 1672×941 Q95 WebP masters under `assets/source_archive/visual_pass_v9/`, separate from the 1280×720 runtime exports.

Broad Act 1 art replacement is complete. The next visual step is screenshot-driven correction only; the next product step is full vertical-slice validation through Bone Warden in solo/duo/trio runs.
