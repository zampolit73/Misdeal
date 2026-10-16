# Misdeal — Active Design & Technical Decisions
Updated: 2026-10-16.

This file is an **active index**, not a replacement for the full decision history. The complete D001–D178 records (including intermediate and superseded numeric versions) are preserved unchanged at [DECISIONS archive](archive/2026-10-15-pre-cleanup/docs/DECISIONS.md). **Older accepted rules remain binding unless a newer decision supersedes them.** Never treat outdated "pending" text as latest project status; `docs/PROJECT_STATE.md` and code win.

## D205 — Third forest arena option chosen; original skeletal roles remain binding

Date: 2026-10-16. After selecting D204 environment **A — black forest bend**, user selected the **third** of three finished moonlit forest backgrounds. Exact source: conversation image `лунная_дорога_через_туманный_лес.png` (1672×941). Preserve this *arena selection* separately from the D200 third **card art**. Background has no built-in enemies/UI. User selection is authoritative, but GitHub import and native Godot preview still pending.

The five D199 roles retain their agreed silhouettes and weapons (**Road Sentinel must have a spear**, not the axe visible in the newer unapproved concept sheet). Remapping 5×5 raw concept images into 6×5 format is **QA staging only**, never acceptance of clipped/repeated or wrongly designed art. New 1.4/3.1/1.8s travelling-light timing is an **unapproved isolated visual prototype**, not final combat balance. See `docs/D205_BLACK_LANTERN_ASSET_AND_LIGHT_STAGING.md`.

## D202 — Fixed disaster-recovery bookmark КАРАМБА73

Date: 2026-10-16. The user explicitly requested a **full-project/context backup** and a recovery trigger **КАРАМБА73**. Capture the GitHub-tracked `main` snapshot after adding a short manifest at `docs/checkpoints/KARAMBA73_2026-10-16.md`; keep its backup branch `backups/KARAMBA73-2026-10-16` unchanged. A later user message containing the exact recovery key explicitly instructs the assistant to **restore the saved tree as the current game version**, while preserving newer history via a fresh `backups/pre-KARAMBA73-restore-...` branch and using a new non-force forward Git commit. Do not use `git reset --hard` or force-update `main`. Uncommitted local files and unselected D201 concept PNGs are outside the tracked-project snapshot. Card #38 remains QA-only, Act1 37/45. Full manifest controls the procedure.

## D201 — Native D200 card art approved; arena selection requires separate render

Date: 2026-10-16. In response to the Godot F6 QA request for the exact user-selected THIRD 448×274 `black_lantern_road` card illustration, user replied **«вск ок»**. Record **user-reported native card-art approval**; do not relabel a code-only check as an independently captured Godot run. D201 must design a **separate, actor-free, full-width 1280×720 battle arena** with unobstructed road combat surface, 2–3 actual visual options before importing one. Existing D200 card artwork and five original skeleton enemy design are locked. Card #38 is still QA-only and Act1 live is 37/45.

## D200 — Lock THIRD standalone production illustration, stage only QA card

Date: 2026-10-16. After the D199 approval of the Lantern Road concept and five-role sheet, the user was shown **three NEW scene-first card illustrations**, and selected **the THIRD** («третий арт лучше всего подходит»). This later explicit selection supersedes the earlier FIRST background concept moodboard for final production-card artwork. Exact chosen image: `лунный_марш_скелетного_легиона.png`, generated ID `f1821747-a46a-4e58-9fd9-9fd2b0f0a214`, five original skeleton silhouettes with ~2× tall Guide. D200 converts that chosen composition to **448×274 WebP/Base64** with no new generation, attaches it to existing unified card loader and a dedicated QA-only F6 scene. Keep the five-role concept, dark road, no embedded UI. **The staged card has no playable encounter yet**; `ACT1_CARD_IDS` stays 37 and `CARD_PATHS` remains unchanged. User must still judge the 448×274 native Godot crop before releasing the visual. Details `docs/DECK_EXPANSION_D199_BLACK_LANTERN_ROAD.md`.

## D199 — Approved card #38: Road of Black Lanterns, five original skeletal enemies

Date: 2026-10-16. User explicitly selected the **third gameplay concept** for #38 (**«Дорога чёрных фонарей»**), then the **first moonlit forest-road visual** from 3 images; rejected AI-looking noise, insisted that Act 1 remain skeleton-driven and the encounter contain **more than 3 opponents**. User asked for an imposing **approximately 2×-height lead Lantern Guide**, distinctly designed (not just a scaled-up skeleton). The final five-role character/encounter concept sheet was then explicitly approved with «последняя концепция подходит». Lock the visual direction and five unique skeletal identities **Погасший проводник**, **Носильщик фонаря**, **Страж дороги**, **Масляный служка**, **Стрелок фонарей**. Draft gameplay: two telegraphed moving pools of lantern light grant localized temporary advantage to illuminated enemies; numbers, balance and sprites are still pending. Final concept sheet is a **reference image with text**, not a production card, scene, nor animation atlases. Keep card #38 **concept-only / not live** until separate text-free art, unique atlases, localized Godot implementation, native battle matrix, reward route and random-pool release QA pass. Details and image reference: `docs/DECK_EXPANSION_D199_BLACK_LANTERN_ROAD.md`. Live pool unchanged at **37/45**.

## D198 — Release Black Crossing as Act1 card #37, preserve release QA

Date: 2026-10-16. User confirmed D197 real preflight and battle→reward→table with **«Все ок»**. The user earlier elected to leave D196 as the current wave visual. Enable `black_crossing` as the 37th normal Tier1 combat card in `RunState.ACT1_CARD_IDS`, without changing its user-approved art, enemy roster, wave mechanics or 54-case battle benchmark. Update preexisting diagnostic 36-card guards to expect **37**, preserving their encounter-specific behavior. Add a separate native **full-pool** ordinary Tier1 deal release smoke, not merely the D197 controlled two-card fixture. **Code release is distinct from native release-smoke PASS.** Completion status (2026-10-16): after the D198 full-pool F6 smoke request, user replied **«все ок»**; native QA was user-reported PASS and card #37 is closed. Card #38 is next. D196 waves and core game rules remain unchanged.

## D197 — Freeze D196 visually; verify native reward route before release #37

Date: 2026-10-16. User said **«давай пока оставим этот. продолжай»** after D196 visual work. Keep D196 as provisional accepted rendering for forward progress; do not continue polishing it unless a real regression is seen or user requests. D191's 54/54 combat matrix is confirmed, but the **real Black Crossing victory → Reward UI → Fate Spread/Table** has not yet been explicitly witnessed or reported. Preserve the release gate: create a D197 pre-release scene using production RunState card registration/offer/selection/completion APIs and a button that opens the **real** Battle UI and Reward path. The preflight only establishes technical route readiness; it cannot substitute for a native playthrough. Stay **36/45 QA-only** until the user confirms actual reward→table; then activate #37 and update legacy 36-card smoke tests in GitHub. No gameplay/visual changes during D197.

## D196 — Breakers must travel onto the deck, not merely swell in place

Date: 2026-10-16. User's native D195 screenshot still reads as small stationary water pools although D195 softened the foam. A convincing storm-surge hazard requires **visible seaward→landward movement** across the actual intact wooden planks: warning gradually approaches, impact starts at the warning's exact final waterline, water travels substantially farther, and ebbing foam spreads after the crest falls. D196 only updates local rendering coordinates/shape in `BlackCrossingSurgeController`: visual travel **94px during impact, instead of 37px**, an aligned -91→-62px warning approach and a shallow runoff zone clipped at the safe foreground deck edge. Keep existing hit lane, physics push of 43px left, 30% temporary movement slow, all durations, foot placement bounds, artwork and 36-card live deck unchanged. **Native D196 visual approval and real reward→table check are still required before release #37.**

## D195 — Foam motion must be organic, not repeating triangles

Date: 2026-10-16. User's native D194 screenshot confirms the larger rolling storm wave is **closer to the desired scale** but still has an unmistakable artificial sawtooth row of pale blue triangles across the crest. Remove repeated high-contrast polygonal 'teeth' and use **smooth wave envelope, non-uniform rounded whitewater clusters, uneven swell motion, breakup/receding foam, and a restrained storm-blue palette**. The underlying 3-breaker structure, legal deck/soles alignment and accepted background stay. This is an **encounter-local render-only** change, with no modifications to timing, push, slow, geometry, party balance or approved source art. Await native D195 visual acceptance and real reward→table confirmation before releasing #37.

## D194 — Storm breaker must be a rising, curling mass, not scraps or a box

Date: 2026-10-16. User explicitly rejected D193 Godot F6: barely visible scratches on the pier cannot compete with the background storm; also rejected D192's 1000px-wide floating cyan ribbon. Replace **both** failed approaches with three overlapping, asymmetrically staggered large storm swells that rise, curl, break, and wash shoreward across the intact plank surface. Tall curved water silhouettes, a dark body and recognizable foamy breaking lips are necessary; edges must taper naturally so water never becomes a flat rectangle. Anchor at visible soles (UnitsLayer origin + 36 px), under sprites. Keep warning readable but quieter than the crashing impact. D194 VFX is **drawing-only**, no changes to live combat, card art, accepted backdrop, balance scaling, hit lanes, push/slow, or D191 matrix results. Native F6 visual approval is still a release gate.

## D193 — Surf must meet the pier deck and remain visually fragmented

Date: 2026-10-16. The user's native D192 screenshot **does not approve the effect**. The full-width cyan breaker hovers above the actual floor, obscures the distant coastline and reads as a floating rectangular banner, despite more elaborate line work. **Unit positions in UnitsLayer are body origins, whereas their visible soles touch y+36.** Keep gameplay hit lane and walkable combat bounds unchanged, but render shallow surge wash at the boot-contact depth instead: staggered, nonuniform semi-transparent slate-blue pools with interrupted gray-white crests, curling tongues and restrained spray. Never bring back an all-screen opaque cyan strip. This drawing-only D193 iteration requires a new Godot screenshot/visual approval; it is **not** permission to release #37.

## D192 — Breaking sea wave must read as moving volume, not HUD lines

Date: 2026-10-16. User's **D191 post-floor-fix native functional matrix PASSED 54/54**, but the actual combat screenshot shows the D189 surf was still visually a thin, lifeless line. For the approved stormy Last Pier, a readable ocean breaker requires **a moving shaded mass of water, a curling uneven foam lip, wave-height variation, trailing turbulence and spray**. Implement in the isolated `BlackCrossingSurgeController` drawing code, using procedural polygons and deterministic phase animation (not new/unauthorized art replacements). The telegraph must stay clear, miniatures remain legible and the foot-floor lock stays unchanged. **Gameplay timings/lanes, knockback and slow, art assets, solo/duo/trio balance and 36-card pool remain unchanged.** D192 code in GitHub; **native visual acceptance is still required before card #37 releases**.

## D189 — Replace rectangular surf and lock D188 fighters to the intact pier

Date: 2026-10-16. User screenshot confirms D188 native **54/54 FUNCTIONAL PASS** with 54 victories, 0 entire-party defeats, 85/78/84% solo/duo/trio mean HP and 81 warned/58 active waves/71 pushes/71 slowdown resets. The **real battle screenshot also demonstrates two unacceptable presentation bugs**: orange `draw_rect()` warning is not a sea wave, and sprites stand on the foreground broken beams rather than whole central planks. Functional PASS does not override visual/geometry defects.

**D189 specific fix in source:** introduce shared `BlackCrossingFloor` with UnitsLayer-local legal `Rect2(110,240,1060,128)`, player placement `Rect2(145,250,390,112)` and two tide lanes at y284/330, 25px half width. Feet visibly land on the central intact deck (UnitsLayer y offset 96 + animated sole/rim y offset 36); AI, drag placement, seed-based smoke and wave impulse use the same legal bounds. Replace both debug filled/stroked rectangles with moving, irregular water polygons, foam crests and sprays, with a subtle **advance warning** still visually distinct. Keep previous 3.2s delay, 1.4s warning, 43px left push, 30% temporary slow for 1.6s, both factions, no direct damage. Keep art bytes untouched; no new global mechanics. After this change previous 54/54 is **historical only** and does not validate the D189 coordinate revision; native F6 retest and visual feedback remain necessary. `black_crossing` stays QA-only and Act1 36/45.

## D188 — Storm surge is a neutral, telegraphed encounter-local repositioning hazard

Date: 2026-10-16. Status: **source-integrated in main, untested in native Godot**.

After the user approved the final storm arena and confirmed its F6 preview, implement Black Crossing with one **original Drowned Ferryman + two Drowned**, two formations and original user-approved combat sprites. Wave controller is encounter-local: alternate two visible horizontal bands, wait **3.2s**, warn **1.4s**, push caught fighters **43px left** (bounds-clamped) then slow movement **30% for 1.6s**, rest **4.5s**. Both sides are affected, with no poison/damage/stun. Preserve other enemy mechanics, global party scaling and approved art. `BattleUnit.wave_move_speed_multiplier` defaults to 1 and is reset upon stop. Register `black_crossing` **only** in `CARD_PATHS` to allow a QA-only real Reward→Table route; keep it out of `ACT1_CARD_IDS` (36/45). F6 matrix (54 actual unit combats) and live playtest have been committed but not executed in Godot. Do not claim combat balance or release approval until user checks. See `docs/D188_BLACK_CROSSING_ENCOUNTER.md`.

## D187 — Stormy Last Pier final arena accepted and integrated for isolated preview

Date: 2026-10-16. User explicitly approved the **final** clean "Последний причал" storm artwork, after iterative removals of repetitive left-background stone structures and the right-background wooden frame. The accepted 1672×941 source image is `a_wide_cinematic_highly_detailed_pixel_art_digit.png`; its full composition is exported to 1280×720 WebP and bound to new `arena_id = "black_crossing"` as a unique battle-only backdrop, not a repainted card image. **Do not restore removed ruins, replace with prior drafts or overlay decorative UI.** The normal/crypt fallback atmosphere is not painted over this backdrop. The scripted wave telegraph will be a distinct, restrained effect added only when the new D187/D188 encounter exists. User has *not* yet run native Godot F6 on this integrated background; no battle or deck release approval is implied. Act1 stays 36/45.

## D186 — D183 original animation gallery accepted; original arena next

Date: 2026-10-15. The user confirmed **«все ок»** after being asked to run `res://scenes/dev/black_crossing_animation_preview.tscn` and check the two 25-frame original sprites. Record **user-reported native visual QA acceptance** of Ferryman B and Drowned C animations, not independently produced engine logs. Do not redo sprite art or demand the same F6 unless a concrete regression appears.

For D187, present **three genuinely different 1280×720 combat arena backdrop concepts** *before* committing any bitmap. The previously approved third `black_crossing` card image is not a battle arena and must remain untouched. Arena requirements: level and readable central combat floor for small hero/enemy groups, plausible broken wooden pier over black water, cold steel-blue moonlight, restrained lantern accent, **asymmetric** architecture without repeated towers/castles or clutter, one clean recognizable strip where the wave warning/knockback will be drawn by Godot. The chosen backdrop is environment art **without combat characters, wave UI, card labels or baked HUD**; only on user selection integrate it and then create a separate scoped surge controller. `ACT1_CARD_IDS` remains 36/45 until #37 encounter and reward tests.

## D185 — Black Crossing animation bitmap transfer complete, native QA pending

Date: 2026-10-15. Ferryman B and Drowned C remain the user-approved original characters. Their new actual 576×480 WebP/Base64 assets are now in GitHub and bound to the D183 no-fallback 25-frame loader, with a separate Godot preview gallery. Local decoded structural QA passed (25 distinct/padded frames, five empty), and exact UTF-8 Git blob SHA checks match. Drowned atlas minor disconnected visual fragments were cleaned; Ferryman attack required a sixth distinct source-derived transition (original art only supplied 24 frames). This **does not** constitute native F6 visual approval or battle QA. Preserve existing D151–D153 and keep #37 outside live Act1 36/45 until battle, reward, and deal gates pass.

## D184 — Black Crossing original combat appearances approved, production byte transfer still pending

Date: 2026-10-15. User explicitly approved Ferryman B / Drowned C, then accepted both original generated motion sheets. Existing approved card art remains unchanged. Animation production must use the 96px/25-pose contract with fully visible feet and hooked pole. The Ferryman image actually contains 24 source poses (5 attack); one distinct additional transition pose must be documented, never presented as pre-existing artwork. Local image conversion/cell QA is NOT a committed GitHub bitmap or Godot run. A strict loader and F6 gallery have been added but must fail clearly until actual new `.webp.b64` files are uploaded and remotely verified. D153 and live 36/45 remain unaffected. See `docs/D184_BLACK_CROSSING_ATLASES.md`.

## D183 — D182 selected card art accepted in native Godot

Date: 2026-10-15. Status: **native visual F6 approved; original enemy art pending**.

User supplied a screenshot from `black_crossing_card_preview.tscn` and wrote **«утверждено»**. This confirms the already selected **third** diagonal pier scene at the intended 448×274 display. Preserve this exact image. Do not conflate this with approving original combat sprites; next produce distinct Ferryman and Drowned silhouette options consistent with 96px Misdeal pixel-art units. After user chooses, package authentic 25-pose transparent atlases per role with padded frames before native gallery QA. Original arena, scoped water-wave battle and reward tests still pending. Live pool **36/45**.

## D182 — Black Crossing (#37) art option 3 and encounter direction selected

Date: 2026-10-15. **User chose the encounter and third rendered card illustration. Implementation staged, not live.**

The 37th Act1 candidate is `black_crossing` / `ЧЁРНАЯ ПЕРЕПРАВА` (Tier1): one new drowned skeletal ferryman with long boat pole plus two original drowned corpse enemies. The encounter-only mechanic is a visible timed wave surge across the broken pier lane with wind-up and modest movement push/slow (not poison, revive or puppet strings). Two authored placements, original scene art and independent 1280×720 combat arena are required. The user selected **the third of three actually rendered artwork options**: diagonal pier, master at top right, two drowned low left. Assistant incorrectly returned the first image filename on the next turn; D182 canonically binds to the **third generated variant** `лунная_переправа_мертвецов.png`. Candidate `.tres`, exact approved 448×274 option-3 WebP/base64, strict image loader and isolated F6 preview are now in GitHub; native art QA is pending and card #37 remains unregistered. Keep D143/D167/D168 visual gates and 36-card live pool. See `docs/DECK_EXPANSION_D182_BLACK_CROSSING.md`.

## D181 — D153 release smoke passed in native Godot

Date: 2026-10-15. **Confirmed by user's Godot screenshot; no further code changes needed for this gate.**

The D180 `threadbare_theatre_release_smoke.tscn` shows **`D153 / ACT 1 RELEASE — PASS`** with 36 distinct registered cards, D153 in a controlled Tier1 offer, its choice routing to the correct encounter, Fate Spread completion record and sealed boss XIII alone after 12 resolutions. D153 is released as #36/45. This deterministic fixture is not a measurement of random offer frequency nor a fresh battle simulation; D178 separately provided a 54/54 functional combat PASS. The next card (#37) has **not** been designed/approved yet. Continue to honor D143/D167/D168, showing the user gameplay concepts first and three genuinely distinct rendered image options before approving card art.

## D180 — Release Threadbare Theatre as Act 1 card 36/45
Date: 2026-10-15. **Source released; native release smoke subsequently passed (D181).**

After the user accepted the D176/D177 revised D153 encounter in principle (`пока все ок`) and asked to continue development, D153 becomes the 36th live nonboss Act1 card. Add only `threadbare_theatre` to `ACT1_CARD_IDS`; its `CARD_PATHS`, original scene art, genuinely new skeletal enemies, arena and local 32%/285px tether mechanic were already complete. Preserve existing D176 stats, the 12 + XIII run structure, approved DS2 visuals and all other encounters. Remove obsolete 35-card QA guards; introduce an F6 release smoke through the actual `RunState.get_offer_cards` / `choose_card` / `complete_active_card` path.

The native 54/54 combat matrix PASS remains valid for unchanged mechanics; it is **not** proof that the newly live card has completed post-release normal-deal QA. Never invent a Godot PASS until user checks the new `threadbare_theatre_release_smoke.tscn`.

## Foundation

- **D001–D006:** Name Misdeal; Godot 4.7.x with GDScript; card-driven cursed tabletop + compact tactical autobattler; evil wizard as host; playable vertical slice first; GitHub is technical source of truth.
- **Fate Spread:** exactly 12 resolved cards (I–XII) and a sealed XIII boss. A run can reach the boss with solo/duo/trio; current compensation parameters reside in `scripts/core/run_state.gd` (superseding old numeric balancing discussions).
- **Data/architecture:** scene/resource-driven `.gd/.tscn/.tres`; avoid speculative over-engineering and changes to unrelated encounter behavior.

## Content and visual rules

- **D143:** any added card involving combat requires genuinely new original opponents, their art and identity/mechanic; reuse of old skeletons renamed or merely recolored is not enough.
- **D167:** card illustration depicts a believable scene inside Misdeal's world, not detached unit cutouts against a blurred background.
- **D168:** show 2–3 meaningful actually rendered **art variants** (prefer 3) *before* choosing a new/replacement card illustration. Integrate only the user-approved exact image. No fake/noisy repeating AI architectural detail; Godot UI/text stays outside the bitmap.
- **D169/D172/D173:** D153 specifically uses **skeletal** marionettes, a crowned skeletal puppeteer and the user-approved crimson/moonlit ruined puppet theatre. Accepted combat sprites and arena are not to be redesigned casually. `ThreadTether` is encounter-local: 32% minion mitigation within 285px, breaks on distance or master death; no changes to global enemy damage handling.

## Current D153 gating decisions

- **D174/D175:** scripted matrix alone is functional QA, not a balance/fun or complete navigation certificate. The real D153 Reward→Table route was user-confirmed prior to D176 tuning.
- **D176:** only D153 `UnitData` received targeted stronger stats. Puppeteer 142 HP / 7.5 damage / 1.65s attack, Marionette 88 HP / 10.5 damage / 1.22s attack.
- **D177:** resource-format regression diagnosed and loadable `.tres` restored; matrix now reports exact missing resources.
- **D178:** **post-tune** native matrix 54/54 functional PASS; surviving HP mean 74/67/74%, worst 39/15/37%. No blind global buffs and no automatic D153 card #36 release from a matrix result.
- **D179 (documentation hygiene, 2026-10-15):** keep working docs concise with a single canonical handoff, archive snapshots of full prior files, avoid repeatedly prepending entire session reports. Do not delete historical decisions, approved art or potentially referenced runtime files as part of documentation cleanup.

**Release state:** 36/45 in main; D180 native release-routing smoke PASS, normal randomized-run frequency untested. See `docs/HANDOFF.md`.
