# Changelog

Current implementation summaries only; the exhaustive pre-cleanup change history lives at [CHANGELOG archive](docs/archive/2026-10-15-pre-cleanup/CHANGELOG.md).

## 2026-10-16 — D199: Approve Black Lantern Road five-skeleton concept for card #38

- User selected **gameplay proposal 3**, «Дорога чёрных фонарей» (Tier1 combat), then first among 3 moonlit forest-road image options. Rejected artificial detail noise and required Act1's skeleton-first enemy theme and **more than 3** actual enemy combatants.
- User then approved a cleaner road-scene revision and requested a **roughly 2×-height, truly distinct giant Lantern skeleton**. Last generated encounter/character sheet features **5 new skeletal roles** (large Погасший проводник; Носильщик фонаря; Страж дороги; Масляный служка; Стрелок фонарей). User approved with «последняя концепция подходит».
- Locked these choices in `docs/DECK_EXPANSION_D199_BLACK_LANTERN_ROAD.md`, `docs/DECISIONS.md` and the active roadmap/handoff. Moving, telegraphed lanternlight zones are the unique planned local mechanic; timings/damage stats still not implemented or balanced.
- **Reference sheet contains labels, therefore is NOT an approved runtime card bitmap or animation atlas.** Next production: clean standalone text-free 448×274 scene, walkable arena and five 25-pose original enemy sprites, with explicit art and Godot QA gates.
- **No runtime code or images modified by this documentation phase.** Live Act1 stays **37/45**, D198 released; card #38 remains concept-approved but not live.

## 2026-10-16 — D198 closeout: user-native card #37 release PASS; next D199

- After the requested Godot F6 full-pool `black_crossing_release_smoke.tscn`, the user replied **«все ок»**. Record **user-reported native release PASS** (not an independent engine log/screenshot). D197 Battle→Reward→Table route was already user-confirmed.
- `black_crossing` #37 is fully released in the **37/45** Act 1 pool. D191 54/54 combat still applies; D196 wave VFX remains the user's accepted-for-now presentation. No runtime code/art modifications in this closeout.
- Reconciled active project state, roadmap, encounter QA spec, decisions, visual registry, index and canonical handoff; next task **D199 gameplay concept choices for card #38** (8 cards remaining to reach 45).

## 2026-10-16 — D198: Black Crossing released into the 37-card Act 1 pool

- User confirmed the D197 native route (preflight → real battle → reward → table) with «Все ок». D196 surf is the approved current baseline for continued development; D191 native battle matrix 54/54 remains valid.
- Registered `black_crossing` as live Act1 **#37/45** in `RunState.ACT1_CARD_IDS`; card/encounter resource, scene art, original Ferryman/Drowned animation atlases and scoped wave mechanics unchanged.
- Updated D151, D152, D153, Bone Shepherd, D188 diagnostic/battle/release smoke guards, and legacy card/playtest previews for a **37-card** pool.
- Added `scenes/dev/black_crossing_release_smoke.tscn`: checks 37 unique real cards, originals, real full-pool random Tier1 offers across 80 seeded samples (NOT a forced two-card fixture), choice/completion/Fate Spread and sealed boss XIII.
- **Native D198 release smoke pending** — code in `main`, not yet a Godot PASS. Next: F6 the new scene; upon native PASS move to card #38.

## 2026-10-16 — D197: Black Crossing #37 release-route preflight

- User elected to leave D196 wave VFX as the current baseline and continue progression rather than tune surf further. D196 rendering and D191 battle logic untouched.
- Audited real Battle victory → Reward screen → RunState.complete_active_card() → Table code path. This is a source review, **not** native route confirmation.
- Added `scenes/dev/black_crossing_release_preflight.tscn` with production RunState/asset/encounter/deck/XIII audits and one button to launch real Black Crossing Battle→Reward→Table. Updated the existing Black Crossing playtest to support both QA-only 36/45 and future released 37/45 without changing its encounter routing.
- Kept `black_crossing` outside the ordinary random pool until native real reward route sign-off; D197 Godot preflight/result still pending. No gameplay or approved art changes.

## 2026-10-16 — D196: Advance Black Crossing breakers farther onto intact pier

- User native D195 screenshot: smoother foam, but the waves look static; requested a much more substantial forward-moving storm surge.
- Rendering-only: warning waterline advances from -91 to -62px relative to the foot contact; 1.6s impact begins continuously at -62px, covers 94px on screen rather than 37px, and then spreads semi-transparent, physically bounded runoff with moving broken foam across planks.
- No hitbox, warning/rest/slow timing, 43px left push, -30% movement, encounter stats, sprites, approved art or deck changes; D191 native 54/54 gameplay PASS remains valid. D196 visual F6 + real reward→table still required. Act1 36/45.

## 2026-10-16 — D195: Organic storm foam and breaker decay

- User native D194 Godot screenshot: wave size is an improvement, but evenly spaced light-blue triangular peaks look artificial; requested a professional animation pass.
- Rebuilt **render-only** foam from continuous asymmetric wave contours and three soft rounded irregular clusters per breaker. Denser 72-sample geometry, multiple flowing frequencies, quieter cold-blue tones, foam flecks, and visible wash/recede phase replace repeated polygon teeth.
- No changes to storm art, character animations, encounter balance, floor, wave hit lanes, 43px push, 30%/1.6s slow, or battle results. D191 **native 54/54** remains valid; D195 visual F6 and real reward→table route still require user confirmation, so live Act1 stays 36/45.

## 2026-10-16 — D194: Replace rejected spray scratches with true rolling breaker silhouette

- User D193 Godot screenshot and feedback: prior fragmented foam looked like tiny pale scratches on the deck despite the massive storm; not approved. D192 long turquoise banner was also rejected.
- Rebuilt encounter-only wave rendering as three offset overlapping storm swells with tapered 3D-like faces, raised and curling pale foam tops, animated chop, impact spray and a 38px shoreward sliding wash. Warning is darker and smaller than the impact.
- Left gameplay hit lane, knockback 43px left, 30% slow/1.6s, floor, animations, approved scene backdrop and original enemies **unchanged**. D191 native **54/54 FUNCTIONAL PASS** continues to apply, but D194 still needs Godot visual approval and real reward→table check. Act1 remains 36/45.

## 2026-10-16 — D193: Ground Black Crossing surf on planks

- Native D192 screenshot rejected: prior full-width bright turquoise water band appeared suspended at the far side of the board, above the foot line and distant surf.
- Replaced **only wave drawing** with shallow segmented tapering stormwater washes placed at the animated sole-contact level (+36px from UnitsLayer origin); staggered breaking foamy tongues, restrained bubbles and desaturated low-alpha blues; visible deck gaps throughout.
- No `BlackCrossingFloor`, battle unit, hit lane, push, slow or other combat logic change. D191 native **54/54 gameplay PASS** remains valid; D193 Godot **visual** approval and real reward→table are still outstanding. Live Act1 36/45.

## 2026-10-16 — D192: Fuller breaking surf, native 54-case confirmation

- User native D191 F6 screenshot **54/54 wins, 0 full defeats**; 18 wins for every party size and protagonist, mean HP 86/74/77%, worst 58/42/50%; 78 warnings, 62 wave impacts, 66 pushes and 66 slow resets.
- User real-battle screenshot still showed D189 wave as thin artificial line. Replaced *only* Black Crossing's procedural drawing with layered sea-body polygons, an advancing lifting crest, irregular curled whitecaps, swells, broken wake and restrained spray.
- Left `BlackCrossingSurgeController` gameplay timings, damage, hit lane, push/slow, floor bounds, enemy stats and original approved artwork unchanged. D192 native **visual** F6 is pending; reward→table and #37 release not yet approved. Act1 remains 36/45.

## 2026-10-16 — D191: Black Crossing native-QA parity hardening
- Inspected current GitHub `main` and D190 handoff; D189 surf/floor source exists, native Godot still unavailable in assistant environment.
- Updated Black Crossing 54-case smoke to mirror real battle solo/duo/trio hero spawn positions, floor-depth mapping, and initial placement clamp; replaced artificial hero positions.
- Set explicit release gate of 54/54 wins (not merely 54 completed cases), preserving per-frame plank legality and post-combat slow reset checks.
- No arena/card/unit bitmap, enemy stats, wave behavior, party scaling, or live deck change. Await native F6 playtest + matrix + reward→table confirmation; 36/45 live.

## 2026-10-16 — D190: New-chat checkpoint after D189
- Rechecked live GitHub source; **D189 surf-animation and safe-pier movement correction already committed**, so no duplicate gameplay patch.
- Rewrote canonical `docs/HANDOFF.md` with pre-fix Godot screenshot metrics, the exact two visual issues, D189 code paths and the **post-fix F6 retest still required**.
- Corrected stale status in `PROJECT_STATE` (Black Crossing QA-only `CARD_PATHS` lookup) and stale D187 preview-pending wording. No gameplay, stats or approved art changed; Act1 remains 36/45.

## 2026-10-16 — D189: Black Crossing rolling surf and intact planks fix
- User's native D188 smoke screenshot: historical 54/54 functional PASS (85/78/84% average HP; 81 wave warnings, 58 strikes, 71 pushes and 71 cleanup resets). Separate battle screenshot shows amber rectangle wave and actor soles standing on broken forward beams.
- Replaced overlay rectangles with animated irregular sea foam, crest, water body and spray. Shared `BlackCrossingFloor` gives consistent intact-deck movement bounds for battle spawn/AI, hero drag zone, wave knockback, and 54-case matrix; wave lanes moved to the middle of the deck.
- Strictly local D188 art/geometry change; does not modify enemy HP, run pool or accepted original art. **Native Godot retest after D189 is pending**; prior 54/54 is not a substitute.

## 2026-10-16 — D188: Original Black Crossing battle & scoped wave QA
- User confirmed D187 arena Godot F6 OK; unchanged user-approved selected storm plate and original 25-frame Ferryman/Drowned art.
- Added two unique UnitData and two-placement 1+2 Ferryman/Drowned encounter, QA-only card lookup (not live in Act1), and neutral warned wave strip with bounds-safe push and temporary 30% movement slowdown.
- Added 54-seeded real BattleUnit matrix and isolated real Battle→Reward→Table playtest. Subsequent pre-D189 native matrix confirmed 54/54 functional PASS, but visual/off-floor defects required D189. Act1 remains 36/45.

## 2026-10-16 — D187: Black Crossing storm arena selected and source-integrated
- User approved final clean stormy "Последний причал" after removing the repeated left ruin and right background pier-frame; exported exactly this final image to 1280×720 WebP/Base64.
- Added unique `black_crossing` arena lookup/presentation in existing authored backdrop and visual scripts and clean 1280×720 F6 preview. No crypt atmosphere, no sprites or UI baked into the art.
- Native Godot arena check pending. No encounter waves, enemies/resource data, battle QA or Act1 pool change (36/45).

## 2026-10-15 — D186: Black Crossing original animation visual QA accepted
- User reported «все ок» after F6 for `scenes/dev/black_crossing_animation_preview.tscn`, accepting original Ferryman B and Drowned C five-state animations; no gameplay, art bytes or balance edits needed.
- Began D187 original arena art direction; three distinct 1280×720 battle backdrops to be reviewed before importing anything. Live pool remains 36/45.

## 2026-10-15 — D185: Original Black Crossing combat atlases installed
- Uploaded full Ferryman and Drowned 576×480 atlas WebPs into Godot-compatible tracked `.webp.b64` under `assets/pixel/units/deck_expansion_v1/`; each has 25 distinct/padded cells and 5 unused blank cells verified after local decode.
- Removed visibly disconnected Drowned pixel fragments; retained approved source design and documented one Ferryman derived attack-transition pose.
- Confirmed GitHub blob SHAs match the local encoded raster bytes. Native Godot F6 original-enemy animation acceptance still pending; no #37 encounter, waves, battle or live-pool change.

## 2026-10-15 — D184: Approved Black Crossing combat art and staged original role loader
- User confirmed Ferryman B / Drowned C and approved both generated original animation sprite-sheet previews.
- Locally created two 576×480 atlas candidates, checked 25 distinct alpha-padded poses, five unused transparent cells, documented the Ferryman's originally missing sixth attack pose. Remote raster upload was subsequently completed in D185; native F6 remains unverified.
- Added strict no-fallback D183 role support to MisdealUnitAnimationLibrary and an isolated F6 gallery; **the two `.webp.b64` files have not been committed**. All existing characters, encounters and live pool (36/45) remain untouched.

## 2026-10-15 — D183: Black Crossing card-art native acceptance
- User F6 screenshot + «утверждено»: original third D182 card illustration PASS in the intended 448×274 framing.
- Next combat models need separate silhouette approval, full original 25-frame sprite animation sheets and native QA; no changes to live cards or encounters.
- Current live Act1 **36/45**; release #37 remains gated by original enemies, independent arena, wave mechanic and battle/reward route.

## 2026-10-15 — D182: Black Crossing #37 direction approved, QA-only candidate staged
- User selected new drowned ferryman + two drowned corpse encounter with timed, telegraphed waves, and card-art option #3 (diagonal pier composition).
- Added standalone `resources/cards/black_crossing.tres` and detailed handoff spec; **no live registry/pool change**.
- Approved exact option-3 448×274 image now committed as `black_crossing_approved_v1.webp.b64`; strict loader and F6 art preview added. Remote text matched source export exactly. Native preview and enemies/arena/waves are pending; Act1 remains 36/45.

## 2026-10-15 — D181: D153 release-routing smoke confirmed in Godot
- User screenshot confirms F6 `D153 / ACT 1 RELEASE — PASS`: 36 unique cards, Tier1 controlled offer/choice, encounter routing, Fate Spread resolution, boss XIII gate.
- No gameplay or source edits required. Release #36 verified with this deterministic route fixture; randomized multi-run offer frequency remains untested.
- Next original #37 gameplay and art concept selection pending; D143/D167/D168 remain mandatory.

## 2026-10-15 — D180: D153 releases as Act1 card #36 (native smoke subsequently passed D181)
- Added `threadbare_theatre` to the normal Tier1 `ACT1_CARD_IDS` pool; now 36 unique nonboss cards.
- Fixed former 35-card assumptions in D151/D152/D153 smoke scenes and playtests, avoiding false failure after release.
- Added `threadbare_theatre_release_smoke.tscn`: tests real RunState offer, card selection, encounter routing, Fate Spread choice and boss XIII gating in a deterministic two-card Tier1 fixture.
- Previously confirmed native D176/D177 54/54 combat matrix remains valid for unchanged D153 values. Post-release deterministic normal-deal Godot F6 was subsequently confirmed PASS (D181).

## 2026-10-15 — Documentation hygiene (D179)
- Archived exact pre-cleanup copies of AGENTS, PROJECT_STATE, ROADMAP, DECISIONS, CHANGELOG, old handoffs, visual registry and D153 working docs.
- Consolidated current-state, release gates and next steps into a short canonical set with `docs/INDEX.md` and `docs/HANDOFF.md`; preserved full historical decision references.
- Updated README to the current playable game instead of the original early prototype; clarified Godot/dev test boundaries.
- No changes to gameplay, card pool, unit stats, mechanics, accepted art, or scenes.

## 2026-10-15 — D153 post-balance QA (D176–D178)
- D176: encounter-only Puppet Master/Marionette HP/damage/cadence/movement pass; no global balance changes.
- D177: restored resource serialization, added exact-path `UnitData` diagnostic.
- D178: user native Godot F6 54/54 FUNCTIONAL PASS; average survivor HP 74/67/74% solo/duo/trio, worst 39/15/37%; 123 link / 91 break / 54 master-death breaks.
- Historical D178 state: D153 was QA-only outside the 35-card pool. D180 has activated it; normal-deal regression check pending.

## 2026-10-15 — D153 original art and real battle
- User-approved skeletal marionettes, original crowned puppeteer, 25-pose original animations, selected gothic theatre card scene and moonlit ruined-stage battle arena committed.
- Encounter-local ThreadTether integrated into the real Battle flow (32% mitigation/285px); user previously confirmed battle→reward→table.
- Pre-balance matrix: 54/54 functional PASS with ~85/82–83/86% remaining HP, prompting localized D176 tuning.

## Previous released milestones
- D151 Funeral Procession: original skeletal units/Last Rite, live card **34/45**.
- D152 Defiled Laboratory: original toxic-hazard encounter, environment-led art, live card **35/45**.
- DS2 and Fate Spread Variant C established; earlier events, arenas, tactical cards, UI passes preserved in the archive.
