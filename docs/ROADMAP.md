## Wave 1 source art candidate delivery — 2026-10-13

- [x] Prepare first 13 WebP candidates from approved D130 concept and validate sizes/ZIP structure.
- [x] Add optional WebP override resolver + real legacy-fallback to CardArtCatalog and ActChoice.
- [x] Preserve untouched DS2 UI, previous atlases, shop/well/table/battle gameplay.
- [ ] Binary transfer to GitHub unresolved. ZIP is a conversation artifact, not committed assets: user local extraction is needed to activate the optional overrides.
- [ ] Inspect 13 resulting images in actual Godot 1280x720; specifically check reconstructed picture-in-picture corners and softness of large event artwork. If unacceptable, create new clean native-resolution originals faithful to D130.
- [ ] Complete remaining five previously planned art targets separately with new approval.

## Art direction sign-off — 2026-10-13 — approved final concept (D130)

- [x] User approved the last consolidated concept board, including reduced medieval archers in `gallows_volley`, gray-bearded male mage and skeletal hand holding ruby for `relic_wager`.
- [x] Map all **13 pictured compositions** to actual runtime art IDs in `docs/CARD_ART_UNIFICATION_WAVE1.md`; distinguish the remaining 5 unseen candidate assets.
- [ ] Preserve accessible high-resolution copy of approved concept art in GitHub or Project sources; current concept PNG is only attached to the conversation, not in repository.
- [ ] Produce 13 individually usable illustration textures matching approved board (no card frame, labels or inset previews baked into art).
- [ ] Review/approve remaining 5 Wave 1 target compositions separately, if still in scope.
- [ ] Integrate clean assets with keyed fallbacks and test at 1280x720 in Godot before declaring the **game art** shipped.

## Card Art Unification Wave 1 — inventory stage (2026-10-13)

- [x] Audited live `CardArtCatalog` selection priority, active atlas regions and non-shop event backdrop paths.
- [x] Documented 18 specific first-wave card-illustration targets and safe art replacement approach in `docs/CARD_ART_UNIFICATION_WAVE1.md`.
- [ ] Compare actual current art as a contact sheet at run-card size; choose which assets need redraw versus preservation.
- [ ] Draw/review a three-art reference sample before committing the batch; keep approved DS2 UI/screens untouched.
- [ ] Implement only approved asset replacements with fallback and verify in Godot 1280x720.
- [ ] Update visual registry and acceptance decisions after user approves changed art.

## Next milestone — 2026-10-13 — DS2 accepted, return to Act 1 gameplay

- [x] Consolidated Design System 2.0 rollout across non-shop events, hero selection, squad dossier, run-end, battle HUD and table/Wizard Wager.
- [x] User confirmed the full bulk visual pass looks good in local Godot («все хорошо»); **visual approval complete** (D129).
- [x] Preserve frozen Fate Spread Variant C, accepted Reward major-upgrade, Whispering Well and Gravedigger Shop visuals.
- [ ] Select next *gameplay/content* improvement to Act 1 after checking current deck/encounters, to make repeated runs more varied without expanding architecture prematurely.
- [ ] Functional regression coverage when practical: actual shop paid/leave and Lost Purse price, conditional event choices, selected reward grants/return, battle tactics/results. User's broad approval does not prove every branch was executed.
- [ ] Fix only reproducible defects, if any, without restarting a wholesale UI overhaul.

**Historical note:** earlier sections below saying bulk DS2 visual acceptance is "pending" are superseded by this milestone; branch-specific functional test checklists are not automatically complete.

## Bulk Design System 2.0 rollout — 2026-10-12

- [x] User explicitly authorized shipping the remaining UI as one large DS2 batch rather than requesting visual approval of each scene.
- [x] Apply DS2 event shells to all remaining non-shop shared `ActChoice` events while keeping real descriptions/disabled states/art and their existing button signals.
- [x] Apply scoped DS2 material pass to Class Select, TAB Squad Dossier, Run End, Battle HUD and Table HUD/Wizard Wager.
- [x] Preserve accepted Fate Spread, Reward, Well and Shop and existing main/intro art.
- [x] Static source audit of handlers and UI scene paths; no Godot test claimed.
- [ ] **Consolidated Godot 4.7.x 1280×720 smoke** of new multi-screen visual pass: text, alignment, missing art, different event choice count, hover, disabled, result, navigation.
- [ ] Check real Gravedigger Shop purchase/leave with sufficient/insufficient gold (previous stage's live QA is still open).
- [ ] Check battle tactical orders/target preview/fight overlays and main table wager; no gameplay regressions.
- [ ] Verify ActChoice recruitment, upgrades, one-choice and three-choice events, full-tooltips and state update correctly.
- [ ] Only after running the full flow, accept or repair observed issues (avoid speculative restyling and preserve approved art).

## DS2 production Gravedigger Shop — 2026-10-12

- [x] User approved the corrected independent F6 preview («все ок. внедряй»).
- [x] Add shop-only DS2 presenter `scripts/event/gravedigger_shop_ds2.gd` and call it from shared `act_choice.gd` only when `card_id == "gravedigger_shop"`.
- [x] Keep real `RunState.get_gravedigger_shop_price()`, actual party/extra-upgrade availability, Lost Purse consequences, existing purchase/leave/result/table handlers, and preserve complete offer tooltips.
- [x] Source diff confirms seven critical original gameplay functions unchanged.
- [ ] Godot 4.7.x 1280×720 LIVE shop smoke: all 3 texts/illustrations; price changes with Lost Purse; insufficient gold; absent party roles; limit/exhaustion.
- [ ] Confirm exactly one upgrade awarded and exact gold deduction; leaving awards nothing; resolved footer and Continue reach table.
- [ ] Fix only defects observed in live Godot, without altering unrelated `act_choice` events or approved screens.

## Gravedigger Shop F6 screenshot defect — 2026-10-12

- [x] Inspect user screenshot: static headings and detail labels absent while runtime-updated price/status text is visible.
- [x] Apply preview-only post-construction static text assignment (`f6bb46e`) and distinguish disabled/available cards.
- [ ] Validate corrected F6 scene in Godot 4.7.x at 1280×720; verify every Cyrillic heading/name/detail and both toggle states.
- [ ] Obtain visual acceptance before modifying production shop branch.

## Gravedigger Shop isolated DS2 preview — 2026-10-12

- [x] Create independent `design_system_v2_shop_preview` F6 scene + GDScript with existing role upgrade art and tabletop materials.
- [x] Simulate affordable/unaffordable gold and Mage present/absent; selection and leave are display-only.
- [ ] Review preview in Godot 4.7.x at 1280×720 and obtain user visual approval.
- [ ] After approval, migrate only `gravedigger_shop` branch in shared `act_choice` presentation, preserving actual dynamic price, Lost Purse, role restrictions, purchase grants and routing.

## DS2 event milestone — Whispering Well approved, Gravedigger Shop next (2026-10-12)

- [x] Live Whispering Well row centering, full rescue copy and disabled-gold warnings corrected in `1adc634`; user confirmed local result is good, **without a new screenshot** (D126).
- [x] Close **visual alignment QA** for the live Whispering Well; preserve accepted styling against unnecessary further passes.
- [ ] Separately verify all Whispering Well gameplay branches (blood/25g/leave, revisit upgrade/relic/refund and table return) when practical; not implicit in layout approval.
- [ ] Create **isolated F6 DS2 Gravedigger Shop preview**: three physical upgrade cards with dynamic price concepts and a leave option, using existing art and material tokens.
- [ ] Show preview at 1280×720, receive user sign-off before migrating production.
- [ ] In shared `act_choice.gd`, scope any production UI changes to `active_card.card_id == "gravedigger_shop"` so other event cards stay untouched.
- [ ] Preserve existing `RunState.get_gravedigger_shop_price()`, Lost Purse discounts/penalties, gold checks, upgrade grants and scene navigation.

## Whispering Well group-centering fix after detailed screenshot review (2026-10-12)

- [x] Recognize prior pass corrected card internals but **not** row-center alignment: `HBoxContainer` retained width constrained by previous 330px child minimums.
- [x] Set 292px button minimums before container resizing; set beginning alignment, explicit 928px row centered at x640 and deferred final bounds (`1adc634`).
- [x] Increase two-line enabled-card description space to restore hidden «МАГ ПРИСОЕДИНИТСЯ»; place disabled warning with bottom margin; top-align event narrative.
- [x] Confirm existing seven core choice/art/resolve methods unchanged.
- [ ] Local Godot 1280×720 screenshot: compare actual first/last card edges to header/footer edges, check description two lines and 0-gold warning margins.
- [ ] Test enabled coin choice and later revisit layout and actual branching; avoid further speculative pixel offsets without a screenshot.
- [ ] Keep DS2 art/backdrop, approved Reward layout and favorite Fate Spread unmodified.

## Whispering Well final alignment after live QA screenshot (2026-10-12)

- [x] Keep existing approved DS2 background, event choice illustrations, colors and three-card positions.
- [x] Align header type and three parchment title/effect/detail regions; reserve dedicated warning baseline for unavailable middle card (`c513b63`).
- [x] Render disabled copy without repeated warning; size displayed text after choice-state adjustment (`dd4b486`).
- [x] Confirm by source comparison original seven event branch/art/resolve/return handlers unchanged.
- [ ] **Local Godot screenshot QA:** test 20-gold disabled center choice and 25+-gold enabled option, check that all Russian text is visible within three cards and header, warnings do not overlap.
- [ ] Verify actual blood/coin/leave choice effects and return to table before declaring live event fully accepted; revisit branches remain outstanding.

## Whispering Well real-game header QA correction (2026-10-12)

- [x] Inspect first actual 1280×720 production screenshot: choice cards display but long story text collides with bronze header border; header obscures gold/party label.
- [x] Reposition header title/quote/story text and restore top counter draw order with GoldLabel z-index (`2a0baab`).
- [ ] Recheck live scene in Godot after `git pull`: complete story above border, visible gold/party counters, no text/card overlap in both recruit and revisit branches.
- [ ] Test blood / 25-gold / leave outcome effects, disabled insufficient-funds state and return to table; do not infer game logic from screenshot.
- [ ] Keep accepted Fate Spread and Reward art unaffected.

## DS2 production Whispering Well (2026-10-12)

- [x] User approved isolated Whispering Well three-choice event preview and authorized live migration (D125).
- [x] Update live scene's materials/background to canonical Variant C and DS2 parchment cards; retain approved original event choice artwork.
- [x] Show dynamic offers for both recruiting Mage and later revisit/extra-upgrade/relic states; preserve original action/cost/refund/route handlers exactly, confirmed by source comparison.
- [x] Show cost and disabled-reason text legibly, retain full offer tooltips and highlight choice on click.
- [ ] **Godot 4.7.x smoke:** live Whispering Well with/without 25g, recruitable Mage blood/coin/leave routes, later revisit with available/unavailable upgrades/artifacts, results and table return.
- [ ] Validate actual full-screen 1280×720 screenshot; tune only observed legibility/layout bugs, then request live event visual acceptance.
- [ ] Continue DS2 event/shop adoption only after this runtime gate; untouched Fate Spread and accepted Reward major-upgrade appearance stay frozen.

## DS2 next stage — isolated Whispering Well event (2026-10-12)

- [x] Inspect existing `whispering_well.gd` options, recruit and upgrade branches and approved event choice artwork.
- [x] Stage separate F6-only DS2 material event preview with canonical bronze/parchment aesthetic and original approved well background/choice images.
- [x] Allow harmless selection and simulate insufficient gold to demonstrate disabled choice; never touch RunState or production Well event.
- [ ] User review at 1280×720 Godot F6: visible all three choices, no clipping, hover, click, gold-disabled styling and legible Wizard line.
- [ ] Once approved, migrate the **real** Whispering Well event's visuals, keeping recruit/pay/leave and other upgrade/relic branches exactly intact.
- [ ] Then tackle other events and merchant/shop one screen at a time; full Reward flow checks remain required.

## DS2 Event screens — isolated Whispering Well preview (2026-10-12)

- [x] Inspect existing `whispering_well` scene and choice art loaders before proposing production edits.
- [x] Commit isolated F6 preview with three tactile Fate Spread-style outcome cards and harmless selection interaction.
- [ ] User `git pull`, run `res://scenes/dev/design_system_v2_event_preview.tscn` F6 at 1280×720, check Cyrillic, real art, selected focus, parchment and card alignment.
- [ ] Secure user sign-off on Event treatment before making any `scenes/event` production changes.
- [ ] Test production Reward gameplay modes (normal, upgrade chain, stake, elite) separately; do not infer from major-upgrade screenshot approval.

## DS2 live Reward visual approval — 2026-10-12

- [x] User approved **production Godot** screenshot at 1280×720 for `major_upgrade` / `РАЗВИТИЕ ОТРЯДА` with two heroes and three upgrade cards (D124).
- [x] Freeze approved visual hierarchy, parchment/bronze material treatment, illustration layout, wrapping, header and footer for this state.
- [ ] Smoke-test clicking an upgrade, then subsequent ordinary loot and correct return to table.
- [ ] Verify one-card normal loot, three-choice Death Wager, bonus upgrade and elite artifact rewards at 1280×720 for both art/text and actual reward grants.
- [ ] Once remaining reward flows pass, advance DS2 screen-by-screen to events and merchant UI, keeping the favorite Fate Spread unchanged.

## Design System 2.0: production Reward migrated (2026-10-12)

- [x] User approved reward-preview look and corrected parchment text-fit; authorized real game migration.
- [x] Apply DS2 material/bronze/parchment card chrome and Variant C visual backdrop to production `Reward` without modifying the canonical Fate Spread.
- [x] Preserve existing reward buttons, art catalogs, five reward modes and all `RunState` grant/claim/navigation paths.
- [x] Add text wrapping, dynamic effect rows and full-text tooltips for longer upgrade or artifact copy.
- [ ] **Godot 4.7.x runtime validation:** normal loot (one centered card), major upgrade followed by loot, Death Wager (three cards), bonus upgrade and elite artifacts; inspect long Cyrillic, art, button hover/click, exact reward effects and return to table.
- [ ] Fix only observed issues before considering Reward DS2 visually accepted and moving on to events/shop/battle HUD.
- [ ] Preserve original Fate Spread art and gameplay throughout.

## DS2 isolated Reward preview — text/layout acceptance follow-up (2026-10-12)

- [x] User approved DS2 reward preview art direction, materials, palette and three-card composition at 1280×720.
- [x] Fix overflowing card description labels with early wrapping, explicit sample line breaks, smaller card typography and parchment clipping (`dac4953`).
- [ ] Godot F6 screenshot recheck: all Russian text fully legible and stays within each parchment, selected/hover state works; avoid treating clipping as a replacement for text fit.
- [ ] Only after final approval, migrate the actual `scenes/reward/reward.tscn` screen without changing reward logic.

## Design System 2.0 Reward preview — local visual approval pending (2026-10-12)

- [x] Create isolated F6 reward preview scene/controller using approved Variant C tabletop image, actual reward art catalog and three representative Death Wager choices.
- [x] Add opt-in blackened-material, aged-bronze framed-card and parchment-panel \`MisdealUIKit\` helpers; no production style changes.
- [x] Make preview interaction real but harmless: hover/select/inspect feedback only, no reward grants or run-state writes.
- [ ] Godot 4.7.x at 1280×720: validate actual textures, card text, Cyrillic, hover/focus/selection, button and layout; screenshot to user.
- [ ] **User sign-off** before changing production Reward. Then migrate only Reward in a small reversible patch, with gameplay smoke.
- [ ] Continue additional screens only if approved. Favorite Fate Spread art stays untouched.

## Approved Fate Spread → Design System 2.0 (2026-10-12)

- [x] User selected the canonical Fate Spread Variant C as favorite whole-game visual reference; freeze its art/composition.
- [x] Document material grammar, provisional palette, safe migration and acceptance rules in `docs/DESIGN_SYSTEM.md` and binding decision D123.
- [x] Add opt-in color tokens in `MisdealUIKit` without touching existing screen styling.
- [ ] Create an **isolated** 1280×720 reward/event material treatment preview in Godot; use existing data/art and proper font/Cyrillic support.
- [ ] User approve screenshot before modifying any production screen.
- [ ] Migrate one approved UI screen at a time; verify interaction, contrast and no art/layout regressions.
- [ ] Keep original Fate Spread Variant C completely unchanged.

## Health bars compact gothic styling (2026-10-12)

- [x] Restyle live unit `ProgressBar` as smaller dark inset track with thin edge and subdued team-colored fill (`d744e61`).
- [x] Retain slightly wider Crypt Guard and boss-specific larger bar; unchanged combat HP logic.
- [ ] Local Godot screenshot check in Gallows Volley, Bone Swarm and boss fight: low health readability, overlapping crowd and labels, no clipped bars.

## Mage size recheck after new clean atlas (2026-10-12)

- [x] Correct Mage visual multiplier from 1.65 to 1.25 (`38831c0`); keep clean Mage art intact.
- [ ] Local battle screenshot QA alongside Ranger/Knight to confirm size and foot baseline.

## Elder Mage sprite quality repair deployed (2026-10-12)

- [x] User approved cleaner, solid elderly white-bearded Mage redraw.
- [x] Archive prior atlas (`089b9fd`) and replace production Mage WebP/Base64 (`9d72854`), verified remote equals source.
- [x] Play 6 real attack poses, retire old skipped fifth attack frame (`6ce91f9`).
- [x] Preserve user-approved Mage hero scale 1.65; Knight/Ranger unchanged.
- [ ] Review new Mage at actual 1280×720 Godot battle and F6 in all five states: no faint silhouette or cross-cell fragments, staff, boots and death.
- [ ] Continue local in-engine visual acceptance of earlier Pack 1/2 animation changes.

## Hero size adjustment after Firing Square screenshot — 2026-10-12

- [x] Increase Mage art-only factor 1.15 → 1.65 (`ab22b50`) to compensate small within-cell Mage pose.
- [ ] Confirm with new Godot 1280×720 screenshot that three heroes are comparably tall and grounded in placement and attack.

## Player trio battle sprite size pass (2026-10-12)

- [x] Hero-only art scale multipliers relative to Ranger: Knight 0.90, Ranger 1.00, Mage 1.15 (`24b3df1`).
- [x] Keep enemy/boss visual scale, battle hitboxes, stats, AI and placement unchanged; reuse animated sole grounding after final scale.
- [ ] Local Godot check: Iron Wall encounter with all three heroes at 1280×720; compare visible head/boot heights, animation states and floor contact.
- [ ] Refine only if screenshots demonstrate residual disparities; avoid shared camera/arena changes.

## Bearded Mage redraw delivered — local acceptance pending (2026-10-12)

- [x] User chose first of three concepts: older white-bearded male Mage with purple staff and robes.
- [x] Preserve old `mage.webp.b64` as `mage_archived_pre_oldbeard.webp.b64` (`4c0e94a`).
- [x] Commit new 576×480 transparent 25-pose Mage atlas to `combat_units_anim_v2/mage.webp.b64` (`3e23cc8`); remote content matched.
- [x] Use existing SpriteFrames loader without gameplay code changes.
- [ ] **Godot F6 + fight:** inspect all 5 states, staff/robe/boots, boundary scraps and attack spell alignment, death, 1280×720 scale; report visual defects before closure.
- [ ] Follow up on blue Knight and four Pack 2 roles' engine acceptance.

## Redesigned blue Knight animation integrated — local review pending (2026-10-12)

- [x] User approved visibly separated two-legged Knight in blue armor, cape and shield; authored transparent 576×480 atlas with all 25 real poses.
- [x] Archive previous flawed v2 Knight atlas at `combat_units_anim_v2/knight_archived_pre_blue.webp.b64`.
- [x] Replace production Knight sheet with approved blue version and re-enable Knight frame animation via existing SpriteFrames loader, retaining static-v4 fallback.
- [x] Offline transparency/cell/ground baseline checks passed; GitHub asset content matches approved source.
- [ ] **LOCAL Godot F6 + fight:** check Knight two boots and leg readability at actual 1280×720 size, walking grounded on blue team ring, attack/hit/death, no frame bleed, sprite orientation/scale.
- [ ] Validate all Pack 2 roles in engine; correct any animation defects found before closing animation polish.

## Pack 2 all four enemies hooked up — local acceptance gate (2026-10-12)

- [x] Approved genuine transparent 576×480 framesheets staged for Bone Thrall, Grave Bellkeeper, Crypt Guard and Bone Warden (25 used poses each).
- [x] Bone Warden atlas committed and remote content verified (`77a759d`); enabled `bone_warden` in production library with static-v4 fallback (`1238b3c`).
- [x] All four enemies now have production SpriteFrames lookup; no other roles switched.
- [ ] **Local Godot F6 acceptance:** check all 4 enemies, all 5 states, foot baseline, cropping, effects and visuals at 1280×720.
- [ ] **Live combat acceptance:** attack contact/VFX/HP/death, Bone Warden boss scale/movement/phase, enemy facing, no art clipping.
- [ ] **Knight remains static v4:** only replace after new independently readable 25-frame art and user approval.
- [ ] Fix any observed in-game issues before declaring Pack 2 final visual polish complete.

## Crypt Guard — Pack 2 integrated (2026-10-12)

- [x] User approved Crypt Guard look and 25-frame 576×480 sheet; offline asset validation: zero errors or warnings.
- [x] Upload and verify exact `crypt_guard.webp.b64` in `combat_units_anim_pack2_candidates/` (`5412b1d`).
- [x] Enable role in `unit_animation_library.gd` using existing static-v4 fallback (`fa78548`).
- [ ] Local Godot F6 and fight review: armor/shield/sword, feet, attack effects, facing, death.
- [ ] Create and approve Bone Warden genuine 25-frame atlas before activating last Pack 2 role.
- [ ] Knight remains static v4 until a readable new animation is approved.

## Grave Bellkeeper Pack 2 integration — 2026-10-12

- [x] Approved Grave Bellkeeper visual; prepared 576×480 transparent 6×5 atlas with 25 used poses, offline checks completed.
- [x] Upload `grave_bellkeeper.webp.b64` to `assets/pixel/units/combat_units_anim_pack2_candidates/` and verify exact GitHub content (commit `c28011d`).
- [x] Enable Grave Bellkeeper via production SpriteFrames library, keeping static v4 fallback (commit `9f32e4b`).
- [ ] **LOCAL GODOT F6 / BATTLE:** inspect Idle/Walk/Attack/Hit/Death, bell and chain, ground line, flip and death/targeting, against the existing v4 silhouette.
- [ ] Author, validate, approve and enable Crypt Guard and Bone Warden sheets separately. Knight stays static v4 pending redraw.

## Bone Thrall Pack 2 sheet in GitHub — local QA gate (2026-10-12)

- [x] User approved Bone Thrall 25-pose asset, transparent 576×480 grid.
- [x] Commit exact WebP Base64 candidate `assets/pixel/units/combat_units_anim_pack2_candidates/bone_thrall.webp.b64`; remote contents verified, commit `29d0725`.
- [x] Production SpriteFrames lookup for `bone_thrall` (commit `d25e471`) with static v4 fallback, only this Pack 2 role enabled.
- [ ] Run Godot F6 comparison preview and actual fight, check feet at the floor, attack/readability, death row, weapon/effects and enemy facing.
- [ ] Create / approve / import three remaining sheets: `grave_bellkeeper`, `crypt_guard`, `bone_warden`. No activation before QA.
- [ ] Keep Knight static v4 pending a leg-readable replacement.

## Bone Thrall approval and integration bridge (2026-10-12)

- [x] User approved RGBA 576x480 / 25-pose visual draft; offline alpha/pose-grid checks passed.
- [x] Generated lossless WebP/Base64 file in conversation artifact runtime; not yet present in GitHub.
- [x] Optional production lookup for Bone Thrall with static v4 fallback if candidate is missing.
- [ ] **BLOCKER:** commit `bone_thrall.webp.b64` bytes under `assets/pixel/units/combat_units_anim_pack2_candidates/`; no sheet currently exists in the GitHub path.
- [ ] Run F6 review and live BattleUnit validation in Godot 4.7.x before declaring Bone Thrall animation implemented.
- [ ] Author Bellkeeper/Guard/Warden original sheets later.

## NEXT ANIMATION ART STEP — frame production brief (2026-10-12)

- [x] Technical preparation: offline importer, Godot candidate-only validation, side-by-side F6 review; **no live models switched**.
- [x] Write per-role frame briefs and QA plan: `docs/UNIT_ANIMATION_PACK2_FRAME_BRIEFS.md`.
- [ ] Draw and approve Bone Thrall four-key-pose proof; then Bellkeeper, Guard and Warden key-pose proofs.
- [ ] Draw **four authentic 576×480 transparent spritesheets**, each with Idle4 / Walk6 / Attack6 / Hit3 / Death6 (25 authentic poses).
- [ ] Import/stage, validate and F6-review all five states for each role; reject merged legs, detached weapons, float/clipping and fake duplicate poses.
- [ ] Only after explicit approval, switch roles **one at a time** using existing animation library and static v4 fallback.
- [ ] Local Godot 4.7.x runtime/F6 acceptance still required; Knight stays static v4.

## NEXT-CHAT PRIORITY — Undead Pack 2 Stage B: prepared / awaiting real art (2026-10-12)

**Verified handoff gate:** toolchain and F6 preview committed; all four expected candidate atlas paths absent in GitHub. Next contributor should create and approve genuine role-specific sprite sheets rather than changing the production loader. No battle models were switched. See `docs/HANDOFF.md` and `docs/UNIT_ANIMATION_PACK2.md`.


- [x] **Technical preparation complete:** Python importer, candidate-only Godot validator, 1280x720 F6 side-by-side preview, staging folder README and full QA contract in GitHub.
- [x] **No live-model switch:** Knight remains static v4; Ranger/Mage/Skeleton/Bone Archer keep existing frame animation; four remaining undead keep static v4 and Stage A impact VFX.
- [x] **Context saved** in PROJECT_STATE, ROADMAP, HANDOFF, VISUAL_ASSET_REGISTRY, UNIT_ANIMATION_PACK2 and CHANGELOG. Important QA decision already captured as D121 in DECISIONS.
- [ ] **ART IS THE BLOCKER:** create four authentic transparent 576x480 pixel-art sheets, one per `bone_thrall`, `grave_bellkeeper`, `crypt_guard`, `bone_warden`, 25 distinct poses each (Idle 4 / Walk 6 / Attack 6 / Hit 3 / Death 6).
- [ ] Run `scripts/dev/import_animation_pack2_candidate.py` for each role, then F6 `res://scenes/dev/unit_animation_pack2_preview.tscn`; compare v4 with new animation frames and inspect legs, weapon and contact line. Until assets exist, F6 should show `ОЖИДАЕТ АРТ`.
- [ ] After explicit approval only, update the production animation loader with static-v4 fallback and test real battles/grounding/death. Keep Knight static until a genuinely readable replacement exists.
- [ ] Verify Godot 4.7.x F6 runtime locally (source checks alone are not enough).
## Undead Animation Pack 2 — Stage B QA gate implemented (2026-10-12)

- [x] Check GitHub and available assets: four remaining enemies have only static v4 art, not any role-specific 6×5 animated sheet.
- [x] Add offline `scripts/dev/import_animation_pack2_candidate.py` and test: real 6×5 transparent frames accepted; RGB opaque-background fake rejected; warning for unstable feet/edge bleed.
- [x] Add `scripts/dev/unit_animation_candidate_validator.gd` to inspect frames inside Godot without modifying live loader.
- [x] Add `scenes/dev/unit_animation_pack2_preview.tscn` side-by-side v4 vs prospective candidate, with Idle/Walk/Attack/Hit/Death review buttons and explicit `ОЖИДАЕТ АРТ` status.
- [x] Staging contract documented; only approved candidate art may be moved into production `SpriteFrames`.
- [ ] **GODOT F6:** inspect `unit_animation_pack2_preview.tscn` at 1280×720; without candidate files, all four panels should say `ОЖИДАЕТ АРТ`; no broken nodes or hover effects.
- [ ] **ASSET STEP:** author 25 genuinely different poses per enemy (Bone Thrall, Grave Bellkeeper, Crypt Guard, Bone Warden) with legs/weapon/ground contact obvious in 96px cells; source art isn't available yet.
- [ ] Validate candidates and stage WebP/Base64 files, review all five states in F6 at full arena scale. Reject malformed/floating frames; do not claim acceptance based solely on automatic checks.
- [ ] Upon visual approval, connect those four roles to the real combat library with static-v4 fallback and check actual targeting, movement, attack contact, corpse behavior.

## Undead Animation Pack 2 — Stage A attack accents (2026-10-12)

- [x] Confirm four enemy roles `bone_thrall`, `grave_bellkeeper`, `crypt_guard`, `bone_warden` currently have static v4 assets only; don't call wobbling/static tweens frame animation.
- [x] Implement per-role short action-contact FX with native Godot `Line2D`/Tween; no attack timing/damage change.
- [x] Connect FX at real `BattleUnit` attack trigger, not pre-hit/fake telegraph; automatically clean up ephemeral nodes.
- [x] Provide standalone F6 Godot gallery for four existing enemies and per-role effects.
- [x] Document actual shipped scope and Stage B quality gates in `docs/UNIT_ANIMATION_PACK2.md`.
- [ ] **LOCAL GATE:** `git pull`, F6 `scenes/dev/unit_undead_fx_preview.tscn`; inspect four cues at 1280×720, check UI text and node cleanup.
- [ ] Play relevant encounters with Bellkeeper, Thrall, Crypt Guard and Warden; check accents aren't too bright or too frequent, no hit timing/regression.
- [ ] **Stage B:** author *actual* distinct enemy `idle/walk/attack/hit/death` transparent frames, with clean feet/weapon/ground contact; review every row before activating roles in battle. The prior screenshot-style image cannot serve as a sprite sheet.
- [ ] Revisit Knight animation only after an acceptable leg-readable sprite sheet exists; continue using v4 static Knight until approved.

## Knight leg silhouette hotfix — static v4 fallback (2026-10-12)

- [x] Confirm on repeated user screenshots that Pack 1 animated Knight legs are not readable; vertical adjustment alone cannot fix authored silhouette.
- [x] Temporarily force **only Knight** to use the existing approved static v4 tile; all other four active Pack 1 character animations remain.
- [x] Recalibrate Knight-only static floor offset to -8px so v4 feet align with the existing combat floor ring; keep name/HP/world origin and hitboxes unchanged.
- [x] Preserve both Knight animation v1/v2 asset archives and the dev animation preview for a future redraw/rollback.
- [ ] **LOCAL GATE**: user `git pull`, check Knight leg visibility/contact/attack in Bone Swarm and Grave Crossroads; other active roles' animations unaffected.
- [ ] Before re-enabling Knight animation, **redraw and validate** all Knight sprite states with independent armored boots/clear negative space, shield moved away from legs, consistent ground contact; require real Godot screenshot approval.

## Unit floor contact visual pass — per-role offsets (2026-10-12)

- [x] Respond to user feedback: Pack 1 frame cleanup solved fragment/jitter defects but some feet still looked submerged.
- [x] Introduce per-role signed visual offsets in `BattleUnit`, including static-v4 enemy variants; animated + static sprites use one rest-position helper.
- [x] Ensure combat attack tweens, idle visuals, initialization and old static death path all respect calibrated rest positions.
- [x] Preserve world coordinates, shadow/arena layouts, collision and game balance; leave approved source art intact.
- [ ] **LOCAL VISUAL CHECK:** `git pull`, run Bone Swarm and Cemetery Ambush at placement and during actual movement/attack/death; verify boots no longer look buried, and shadow contact, HP bars and enemy flip still read correctly.
- [ ] If one archetype remains visually too low or appears to hover, tune only that role's `ROLE_FLOOR_OFFSETS` value based on new screenshot; do not move the entire arena or alter physics.

## Pack 1 animation hotfix — row-bleed, floor contact, startup jitter (2026-10-12)

- [x] Inspect source atlases; confirm detached legs from previous row in Knight Walk and smaller enemy cross-row fragments.
- [x] Generate versioned cleaned `combat_units_anim_v2` for Knight, Ranger, Mage, Skeleton and Bone Archer; align all 125 processed cells (124 active character frames) to consistent y=92 sole.
- [x] Switch SpriteFrames loader to v2, slow Idle 5→2.7 fps and Walk 9→7 fps.
- [x] Synchronize art (including attack tween return) to y=36 contact-shadow floor using actual role sprite scale.
- [x] Add randomized initial idle phase and short walk/idle hysteresis.
- [x] Verify exact GitHub payload match and frame contact-line metrics; preserve v1 rollback files.
- [ ] **LOCAL GATE**: `git pull` Godot 4.7.x, check Bone Swarm / Graveyard Ambush at start and when hitting/retreating. Confirm no extra floating Knight feet, no buried skeleton torsos and no idle strobe.
- [ ] F6 `scenes/dev/unit_animation_pack1_preview.tscn` and spot-check all 5 states for all 5 roles. Fix screenshots if any source frame remains visually malformed before proceeding to Pack 2.

## Unit Animation Pack 1 — five live frame-animated roles (2026-10-12)

- [x] Extract five generated 6×5 / 229px spritesheets to 96px transparent gameplay frames and package as GitHub-safe Base64 WebP text.
- [x] Commit `knight`, `ranger`, male `mage`, `skeleton`, `bone_archer` animation atlases.
- [x] Introduce cached `SpriteFrames` library and bind actual idle, walk, attack, hit, death animation frames to existing live `BattleUnit` Sprite2D without changing combat timing or team facing.
- [x] Skip Mage projectile-only raw attack cell, keep existing combat spell trace separate.
- [x] Add dedicated F6 animation review scene using real `AnimatedSprite2D` previews; keep static v4 fallback for missing/other roles.
- [ ] **LOCAL GATE:** F6 `res://scenes/dev/unit_animation_pack1_preview.tscn` at 1280×720. Test 5 states/5 characters, foot contact, weapon clipping, alpha, male Mage, enemy direction and Cyrillic labels.
- [ ] **GAMEPLAY GATE:** three protagonist classes; skeleton and bone archer battles; pre-fight idle/drag, movement, attack, hit, death; confirm HP bars, target changes and victory/reward flow.
- [ ] **Pack 2:** remaining role-specific assets/animation for Bone Thrall, Grave Bellkeeper, Crypt Guard and Bone Warden, after visual approval.
- [ ] After smoke tests: consider syncing damage contact to specific attack frames without altering balance, and clean frame silhouettes only where screenshots show defects.

## Design System 1.0 — Package 3 core screen pass implemented (2026-10-12)

- [x] Keep Main and Intro art intact while bringing hotspot text/focus state into shared `MisdealUIKit`.
- [x] Improve legibility of class-select instructions/rules/status and RunEnd recap copy without shifting approved layouts.
- [x] Move live Table card border states (ordinary, Boss, Wizard mark, held) into the shared component and improve quiet HUD text contrast.
- [x] Make Battle tactical selection visibly distinct for all unlocked 3–5 orders without changing logic or panel sizes.
- [x] Record the six-screen scope and exact component contracts in `docs/DESIGN_SYSTEM.md` Section 8.
- [ ] **LOCAL GATE STILL OPEN:** run Godot 4.7.x at 1280×720: Main → Intro → ClassSelect → Table → Battle → RunEnd; inspect transparency, art preservation, label clipping, card special states, 3/4/5 order highlighting, victory/defeat.
- [ ] Confirm Foundation and Components F6 previews if not previously reviewed; correct any errors or overly bright accents before any further screen polish.
- [ ] Next visual changes must be screenshot-driven and must not affect the playable vertical slice or approved art.

## Design System 1.0 — Package 2 Components implemented (2026-10-12)

- [x] Centralize exact active battle HUD panel/button styles in `MisdealUIKit`; remove local `StyleBoxFlat` duplication without redesigning the HUD.
- [x] Add reusable card surface, selected choice state, readable info/tooltip panel and opt-in native hover tooltip button.
- [x] Add separate interactive Godot Components gallery with state examples, including card selected/normal and tactical choice switching.
- [x] Document API/ownership/constraints in `docs/DESIGN_SYSTEM.md` Section 7.
- [ ] **LOCAL GATE:** `git pull`, F6 `res://scenes/dev/design_system_components_preview.tscn`: hover/pressed/disabled/selected states, Cyrillic text, styled native tooltip and no clipping at 1280×720.
- [ ] Play Main → Table → Battle to check unchanged layout/readability, all 3–5 tactical controls, cards, stakes, fight/rewards.
- [ ] **Package 3 / Screen Pass** only after preview approval, with approved art/geometry unchanged unless discussed.

## Design System 1.0 — scoped rollout (2026-10-12)

- [x] **Package 1 / Foundation:** document palette, type scale, spacing, borders, layering, readability and no-baked-HUD art rules in `docs/DESIGN_SYSTEM.md`.
- [x] Centralize new foundation constants and opt-in typography/minimum-button helpers in existing `MisdealUIKit`; preserve backwards compatibility.
- [x] Commit a standalone runnable Godot foundation specimen scene, not routed from gameplay.
- [ ] **LOCAL GATE:** run F6 on `res://scenes/dev/design_system_foundation_preview.tscn` and check 1280×720 styling, Cyrillic, no layout clipping, and no Main/Table/Battle regressions.
- [ ] **Package 2 / Components:** review unified visual states and shared Godot panel/button/card/tooltip implementation; migrate battle-local StyleBox duplication selectively.
- [ ] **Package 3 / Screen pass:** apply approved components selectively to table, battle, cards and menus while preserving the accepted visual compositions.
- [ ] Continue prior arena package-2 and local gameplay gates independently of this style-system effort.

## Current priority — Male Mage and enemy facing (2026-10-12)

- [x] Add male Mage 96×96 portrait-to-miniature cutout from approved roster, with alpha mask and lossless source archive.
- [x] Point Mage role alone at the new v4 WebP tile, retaining original atlas and safe fallback for other roles.
- [x] Face hostile miniatures toward heroes at spawn and toward their current target in combat; keep matching rim sprite oriented the same way.
- [ ] **Local Godot gate:** check Crypt Patrol, Iron Wall, Bone Warden: enemy facing before Fight and after crossing/switching targets, Mage male silhouette and transparency, HP/name overlays and completed combat.
- [ ] Continue to the remaining two arenas after validation.

## Current priority — Approved Unit Art v4 integration (2026-10-11)

- [x] Transform approved nine-character concept art into a transparent 288×288 atlas with exact 3×3 / 96px tile layout.
- [x] Integrate v4 Base64-WebP runtime art into `BattleUnit`, verify all nine visual-role indexes, cache decoded texture, preserve v3 fallback for rollback.
- [x] Archive lossless PNG sprite sheet master and checkpoint art sources in GitHub.
- [ ] **LOCAL GATE:** Godot 4.7.x screenshot in Grave Crossfire, Iron Wall, Bone Swarm and Warden to check in-game outline quality, missing pixels, transparent edges, silhouettes/weapon cropping, HP labels and attack/drag behavior.
- [ ] Optionally refine individual cutouts after screenshots. Bone Raider / Crypt Sentinel currently share archetype silhouettes.
- [ ] Resume remaining two arena arts once combat-unit readability is accepted.

## Current priority — Unit readability after arena redraw (2026-10-11)

- [x] Improve battle silhouette clarity on detailed Gothic backdrops with restrained rim contour and subtle value separation, not neon halos.
- [x] Increase only sprite presentation (heroes ~10%, enemies ~8%, boss ~5%) and relocate art/HP/name offsets without touching hitboxes or combat stats.
- [x] Widen solo/duo/trio initial party stagger across all encounter-specific placement profiles, while retaining actual legal floor regions.
- [x] Make the larger on-screen hero sprites easier to grab and drag without changing combat collision radii.
- [ ] **LOCAL GATE:** verify Grave Crossfire, Gallows Volley, Bone Swarm and Warden readability and 1/2/3-player drag plus complete fights in Godot 4.7.x; adjust if sprite/UI overlap remains.
- [ ] Return to arena package 2 only after readable miniature composition is accepted.

## Current priority — Drag-only floor UI polish (2026-10-11)

- [x] Remove persistent deployment rectangles and 3×2 decorative circles that obscured approved arena art.
- [x] Render a low-opacity glow of *real legal regions* only during hero drag; no fixed tile slots.
- [x] Suppress the additional hero placement ring while idle, preserving contact shadow/team allegiance ring.
- [ ] Validate default/drag/drop/Fight transitions on Crypt and Grave Crossfire; confirm two-pocket and split-lane variants still indicate legal areas.
- [ ] Only after visual approval, continue with the two unfinished arena background assets.

## Current priority — Battle floor grounding and tactical placement, 2026-10-11

- [x] Align all encounter spawns and combat movement with the new arena-floor plane, including boss reinforcements.
- [x] Show live engraved deployment guides linked to the actual draggable regions; hide them when combat begins.
- [x] Anchor contact shadows/rings under miniature feet and clamp preparation heroes into legal positions.
- [ ] **LOCAL GATE:** in Godot 4.7.x check solo/duo/trio, Bone Swarm, Last Bell, Iron Wall, Gallows, and Warden reinforcements for floor contact, legal drag, completed fight and tactics UI.
- [ ] Tune any specific new perspective/floor mismatch from gameplay screenshots; do not keep generating decorative baked grids.
- [ ] Complete arena art package 2 only after ground/layout acceptance.

## Current priority — Arena Redraw v2 package 1 integrated, 2026-10-11

- [x] Replace the ten approved pack-1 arena backdrops with native 1280×720 WebPs via `AuthoredBackdrop`.
- [x] Preserve the original twelve-arena v1 set for rollback and keep combat/HUD/deployment gameplay unchanged.
- [ ] Locally verify all ten backgrounds against unit contrast, deployment zones, and a completed combat.
- [ ] Generate/review and integrate remaining `firing_square` and `bone_ritual` with the same art constraints (package 2).
- [ ] Resume Act 1 solo/duo/trio balance validation after visual checks.

## Current continuation priority — 2026-10-11

- [x] Replace all 12 active battle backdrops with the unified `arena_redraw_v1` production set.
- [x] Preserve live Godot HUD, units and existing combat rules while changing arena art.
- [ ] **Next:** run several fights locally, especially Bone Swarm / Grave Crossfire / Firing Square / Bone Ritual, and check unit contrast plus usable floor.
- [ ] Fix only concrete arena/deployment mismatches found in screenshots.
- [ ] After arena validation, resume full Act 1 solo/duo/trio testing through Bone Warden.

## Current continuation priority — 2026-10-09

- [x] Freeze the accepted Fate Spread composition.
- [x] Make the final cleaned-up Variant C art the canonical full-screen normal Wizard table.
- [x] Preserve its source master and runtime WebP in GitHub.
- [x] Align live offers, Hold actions, deck/discard counts and deal/discard motion to the physical artwork.
- [ ] **Next:** local 1280×720 screenshot of the exact-art normal table; fix only concrete alignment/mask/readability defects.
- [ ] Verify the Wizard wager overlay over the exact-art normal table.
- [ ] Once accepted, resume full Act 1 vertical-slice validation (solo/duo/trio) through Bone Warden and tune only from concrete playtest failures.


# Misdeal — Roadmap

This roadmap is intentionally focused on reaching a playable vertical slice quickly.

## Phase 0 — Combat proof of concept

Status: complete

- [x] Godot project boots.
- [x] Main screen transitions into battle.
- [x] Spawn 3 heroes and 3 enemies.
- [x] Automatic target acquisition.
- [x] Automatic movement.
- [x] Automatic attacks.
- [x] HP and death.
- [x] Victory / defeat detection.
- [x] Restart encounter.
- [x] Pre-battle player unit placement.
- [x] Three pre-battle tactical orders that change hero target selection/engagement behavior without adding mid-fight micromanagement.

## Phase 1 — Tactical autobattler slice

Status: complete

Goal: make preparation meaningfully affect battle outcome.

- [x] Player can reposition party before combat.
- [x] Clear preparation phase and combat phase.
- [x] Prevent illegal placement outside the deployment zone and overlapping hero drops.
- [x] Improve combat-time unit spacing/readability with separation steering.
- [x] Move unit definitions toward data-driven Resources.
- [x] Add at least one distinct enemy behavior: Bone Archer keeps distance.
- [x] Add at least one simple unit ability or combat modifier: Mage splash damage.
- [x] Improve combat feedback enough to read hits and deaths.

## Phase 2 — First complete game loop

Status: complete

Goal: prove the Misdeal concept outside the battle sandbox.

- [x] Create cursed table scene.
- [x] Present three playable combat cards.
- [x] Choose among multiple encounter cards.
- [x] Launch combat from a card encounter.
- [x] Resolve victory/defeat back into persistent prototype run state.
- [x] Present a three-option reward choice.
- [x] Return to the table with reward effects persisted.
- [x] Add multiple playable cards and complete a three-victory sequence ending in a run result.

Target loop:

`table -> card -> combat -> reward -> table`

## Phase 3 — Build identity

- [x] Add first visible wizard host/antagonist presence at the table.
- [x] Wizard reactions and short commentary.
- [x] First active Wizard interference: two rare visible card substitutions per Act 1 run, one mid and one late.
- [x] First voluntary Wizard wager: accept +25% enemy damage on the next combat in exchange for x2 next ordinary loot, or refuse without mechanical punishment.
- [x] Wizard Memory v1: narrative-only memory of wagers, companion fates, debt-clearing, defeats/retries and greed-heavy choices with contextual table reactions.
- [x] Multiple encounter types: combat cards plus a non-combat event.
- [ ] More party archetypes.
- [x] Per-run protagonist class choice with solo start.
- [x] Hard-roguelike companion recruitment/loss through existing Act 1 cards.
- [x] Variable solo/duo/trio combat composition with visible incomplete-party compensation.
- [x] Restrict upgrade/relic offers to heroes actually recruited in the current run.
- [x] First artifacts that alter hero autobattle behavior.
- [x] First hero build-progression layer: nine role-specific upgrades with one guaranteed major choice per Act 1 tier.
- [x] Replace ordinary post-combat HP/damage reward choices with tier upgrades plus simple gold loot.
- [x] Rework Death Wager reward into gold / artifact / extra hero-upgrade choices.
- [x] Rework positive event-card stat rewards around hero upgrades, relics and build identity; retain raw stats mainly as costs/penalties.
- [x] First progression-economy balance pass: cap optional hero upgrades at 3 per run and retune Bone Warden for 4–6-upgrade builds.
- [x] Squad-status/build-inspection modal with effective stats, upgrades, relics and dynamic specialization names.
- [x] First risk/reward event card: Whispering Well.
- [x] First boss encounter: Bone Warden with an enrage phase.
- [x] Bone Warden two-phase gameplay rework with cleave and phase-two reinforcements.
- [x] Dedicated Bone Warden combat sprite, boss-card art and boss-arena treatment.
- [x] Expand the prototype run into a 12-card Act 1 plus boss.
- [x] Two-card offers with rejected cards removed from the current run.
- [x] Data-driven 24-card structural pool split into early/mid/late tiers.
- [x] Replace prototype card resolvers with real mechanics for the full 24-card Act 1 pre-boss pool.
- [x] First real recovery card: Ash Rest.
- [x] First functional shop: Gravedigger Shop.
- [x] First artifact-choice card: Curse Forge with three hero-specific artifacts.
- [x] First support enemy behavior: Grave Bellkeeper healing pulse.
- [x] First swarm encounter: Bone Crush with five Bone Thralls.
- [x] First elite encounter: Crypt Guard with guaranteed artifact reward.
- [x] Real Black Altar risk/reward event.
- [x] Real Chained Prisoner choice event.
- [x] Real Debtor Bones gamble event.
- [x] Wizard Tithe temporary-debt event with harder combat and doubled normal reward.
- [x] Late Faceless Card hidden-outcome event.
- [x] Late Blood Ledger resource-conversion event.
- [x] Source-locked Broken Crown party-wide artifact card.
- [x] Last Camp pre-boss preparation event.
- [x] Ossuary Gate mixed-archetype late combat encounter.
- [x] Rattling Bridge early traversal event.
- [x] Lost Purse greed event.
- [x] Candle Seller early micro-shop event.
- [x] Bone Tax forced payment event.
- [x] Death Wager late elite combat with enhanced reward.

## Phase 4 — Vertical slice polish

Only after the loop is fun:

- [x] First procedural visual blockout for table, cards, wizard and unit silhouettes.
- [x] Integrate first authored table, wizard, card-back and unit miniature assets.
- [x] First pixel-art combat readability redesign with larger silhouettes, ground rings and compact HP UI.
- [x] Pixel battle presentation pass with atmospheric arena decor, HUD chrome and attack motion.
- [x] Multi-arena Act 1 pass with data-driven crypt, graveyard, ossuary and Bone Warden lair families.
- [x] Replace weak procedural arena overlays with four authored pixel-art battle backdrops selected by `arena_id`.
- [x] Remove nearest-neighbor 2× arena presentation.
- [x] Package true native 1280×720 authored assets for crypt/graveyard/ossuary/warden through a repository-safe binary staging path.
- [x] Recompose live battle UI/arena toward the approved gothic pixel mockup.
- [x] Replace the procedural battle arena with the authored second-reference backdrop while keeping combat/UI layers live.
- [x] Replace the core Knight/Ranger/Mage/Skeleton/Bone Archer set with pixel sprites and scale the live unit presentation accordingly.
- [x] Complete high-detail sprite pass for all nine current combat roles: heroes, base undead, support, swarm, elite and boss.
- [x] Convert main menu, table/cards/wizard, event, reward and run-end UI to the same pixel-art language.
- [x] Rebuild the wizard table around an approved authored pixel concept while keeping live Godot HUD/cards.
- [x] Physical card-table staging pass: deck/discard zones, fate spread, dealt-card motion, fan/hover lift and choose/discard animation.
- [x] Rich procedural table-art dressing experiment rejected in local visual review and superseded.
- [x] Clean wizard-table art pass: remove procedural hands/heavy frames, retain physical deal motion with restrained deck/discard/progress dressing.
- [x] Table hierarchy polish: dim baked background cards, compact the top HUD/commentary and move the fate counter to the table edge.
- [x] Add a shared runtime gothic UI kit for main menu, Class Select, Wizard table/wager, Squad Dossier, Act 1 events, Whispering Well, Reward, Battle HUD/Last Deal and Run End while preserving live text/state.
- [ ] Locally verify the shared UI-kit pass at 1280×720 for card text margins, corner chrome, hover/disabled states and modal readability.
- [ ] Coherent visual language for table/cards/miniatures;
- [x] First lightweight combat animation/impact pass: idle motion, role-aware attack motion/tracers, hit kick and death fall/fade.
- [x] Combat presentation v2 pass: arena-integrated unit lighting/rims/shadows, hit-stop/sparks, distinct death treatment, gothic tactical HUD, Wizard battle commentary, dynamic arena atmosphere and cinematic fight start.
- [x] Unify protagonist select, all Act 1 event choices, reward/upgrade screens, fallback event cards and Wizard wager modal under the approved dark-gothic ritual UI language.
- [x] Replace temporary combat-sprite UI fallbacks with the accepted authored choice/development art for approved Development, Curse Forge and Chained Prisoner cards.
- [x] Integrate the approved full pixel-art set for all 25 active Act 1 table cards, all nine hero-development paths and six reward-state cards.
- [x] Fill the remaining generic Act 1 event choice-card art slots from the active card illustration while preserving dedicated Forge/Prisoner choice art.
- [x] Replace the rejected thumbnail-resolution card-art atlases with near-display-resolution approved-art atlases.
- [x] Polish Wizard wager and Curse Forge presentation, and replace generic relic imagery with object-centric artifact art across forge/reward surfaces.
- [x] Tighten Wizard Wager after local review: larger term art, stronger risk/reward separation, contract sigil and dedicated accept-button glow.
- [x] Fix shared event/footer overflow and Squad Dossier layering after local screenshot review; rebalance dossier portrait/stats/build columns.
- [x] Polish the shared Act 1 event-window hierarchy: framed context art, compact state chips, semantic risk/role accents and upgrade-specific choice illustrations; bring Whispering Well into the same card hierarchy.
- [x] Integrate the approved Whispering Well / Chained Prisoner card mockups: exact choice-art crops, taller art bands, semantic accents, medallion dividers and explicit disabled-state ribbons.
- [x] Add the first cross-card consequence set: Lost Purse → Gravedigger Shop, Debtor Bones → Wizard Tithe, Blood Ledger → Broken Crown.
- [x] Replace anonymous blood-rescue HP taxes with named protagonist rescue scars and surface them in effective stats / Squad Dossier.
- [x] Expand Wizard Memory for rescue scars, long solo runs and deliberate abandonment of both companions.
- [x] Add the one-battle cursed tactical order **ЖЕРТВА** as an optional follow-up to an accepted Wizard wager.
- [x] Add restrained Wizard table tells: wager-history deal cadence, pre-meddling card twitch and memory-linked card/commentary pulses.
- [x] Replace free combat retry with the one-use **ПОСЛЕДНЯЯ СДЕЛКА**: sacrifice an owned relic or take a -15 max-HP brand to retry the same fight; refusal or a later defeat ends the run.
- [ ] Locally verify the Last Deal branches: relic payment, no-relic brand payment, refusal, second defeat, boss defeat and run-end summary.
- [x] Run a static post-Last-Deal balance audit of baseline solo / duo / trio output and preserve the current fixed benchmark numbers rather than making speculative global retunes.
- [x] Split battle preparation HUD into concise encounter-threat text plus a separate run-condition block so party compensation/debt no longer collide with the card counter at 1280×720.
- [x] Turn the three rescue scars into situational Act 1 keys: Chains → Bone Tax, Road → Faceless Card, Whisper → Blood Ledger.
- [x] Add one-use **УДЕРЖАТЬ** fate control to the two-card table offer, returning the reserved card after two resolved cards.
- [x] Add two visible **ПЕЧАТЬ ВОЛШЕБНИКА** offers per run: +20 gold for accepting the marked card, with +15% enemy damage until the next combat victory.
- [ ] Locally verify fate hold return timing across tier boundaries, marked-card combat/event branches, mark + debt stacking and all three scar-key event variants.
- [x] Add encounter-specific deployment geometry for Gallows Volley, Bone Crush, Ossuary Gate and Bone Warden, including disconnected legal deployment regions.
- [x] Add compact combat-threat tags directly to Wizard-table card type lines (`РОЙ`, `ЛЕЧЕНИЕ`, `AOE`, ranged threat, phases).
- [x] Add a late **КАРТА БЕЗ ЛИЦА** reckoning that reads whole-run behavior instead of only a single earlier card.
- [ ] Locally verify the new deployment regions with solo/duo/trio parties and confirm the threat tags / Faceless reckoning fit cleanly at 1280×720.
- [x] Add three visible optional combat conditions with small gold rewards: Bellkeeper-first, stay-above-25%-HP and timed Bone Crush clear.
- [x] Add one-battle **НЕПОВИНОВЕНИЕ** after two explicit refusals of Wizard wagers/marks: -20% incoming damage, -15% own damage.
- [x] Personalize Bone Warden Phase II reinforcements from the Act 1 reckoning profile while keeping the boss's base benchmark stats fixed.
- [x] Locally verify the combat-condition / Defiance / personalized Bone Warden package at normal play level; user reported the package working. Keep edge-case retry/profile checks in the later full-run balance pass.
- [x] Implement first full-run party-size pressure pass: stronger solo baseline, transparent enemy HP/damage scaling for solo/duo, proportional support healing, and no forced combat on Act 1 card 1.
- [ ] Locally verify first forced combat, one mid fight, one late elite and Bone Warden with solo Ranger/Mage, duo and trio; retune only observed outliers.
- [x] Add live first-target intent arrows during battle preparation so hero placement and tactical orders expose their immediate targeting consequences.
- [x] Put target-intent arrows behind an explicit `ЦЕЛИ: ВКЛ/ВЫКЛ` preparation toggle; default off and remember the preference for the current app session.

- [ ] Locally verify target-intent readability on 1/2/3-hero parties and the five-enemy Death Wager without excessive visual clutter.
- [ ] Run fresh solo / duo / trio balance passes with rescue scars, event echoes and **ЖЕРТВА**, then retune only the concrete outliers.
- [x] First procedural combat SFX pass: attack/hit/death/heal/order/start/result cues.
- [ ] Authored sound replacement and battle/table music.
- [x] Skippable five-frame pixel-art comic prologue establishing the old pact and replayed-life premise;
- [ ] onboarding;
- [ ] local UI verification/polish for the new squad-status modal;
- [x] initial Act 1 combat-pacing / boss / Death Wager balance pass;
- [ ] follow-up balance pass after local solo/duo/trio recruitment runs against the fixed 700-HP Bone Warden;
- [ ] basic settings;
- [ ] save/run persistence if needed for the slice.

## Explicitly deferred

Do not prioritize these before the vertical slice works:

- large content library;
- elaborate meta progression;
- online features;
- procedural architecture for every possible future system;
- complex faction/synergy systems comparable to large auto-chess games;
- final production art.

## Art-direction follow-up

- [x] Define production visual rules in `docs/ART_DIRECTION.md`.
- [x] Add shared environment/card art-grade materials.
- [x] Apply the first pass to Wizard table, battle backdrops and Whispering Well.
- [ ] Review fresh screenshots for the first production art-direction pass and identify illustrations that still need true redraw.

## True art replacements

- [x] Replace the reused Ossuary art in **КОСТЯНАЯ ДАВКА** with the approved dedicated arena.
- [x] Replace blue deployment rectangles with subdued floor/chalk presentation and add authored two-band markings to Bone Crush.
- [ ] Locally verify the approved Bone Crush arena replacement at 1280×720 before using it as the template for the remaining arena redraws.

### Second production-art pass

- [x] Review local screenshots after the first art-grade pass and identify the strongest remaining generated-art tells.
- [x] Establish **КОСТЯНАЯ ДАВКА** as the first true redraw benchmark and approve a simpler low-detail crypt direction in chat.
- [x] Add a dedicated `bone_crush` arena id and production backdrop so the redraw does not alter other Ossuary encounters.
- [ ] Replace blue deployment-zone panels with subtle in-world floor markings based on the same legal placement rectangles.
- [x] Retune environment/card grade shadows and remove post-grade from authored table/wager art so dark-mid detail stays readable.
- [ ] Review the Bone Crush redraw locally at 1280×720 before propagating the style.
- [x] Integrate the first object-first card redraw batch: **ГРЕМУЧИЙ МОСТ**, **КОШЕЛЬ МЕРТВЕЦА** and **ШЕПЧУЩИЙ КОЛОДЕЦ**.
- [x] Correct the broad redraw integration after local quality review: 19 semantically matched card redraws now run at 224×137 source resolution with the existing approved 25-card atlas as fallback.
- [x] Finish the six remaining fallback cards: five matching 224×137 v5 redraws plus the exact object-centric Broken Crown artifact art for **СЛОМАННАЯ КОРОНА**.


### Full visual redraw rollout

- [x] First object-first card redraw batch is live: **ГРЕМУЧИЙ МОСТ**, **КОШЕЛЬ МЕРТВЕЦА**, **ШЕПЧУЩИЙ КОЛОДЕЦ**.
- [x] Replace 19 active Act 1 card illustrations with correctly mapped near-display-resolution v4 redraws; preserve unique approved fallback art for the other six.
- [x] Finish the six remaining card redraws without unrelated substitutions; all 25 active Act 1 table cards now resolve to current redraw/object-specific art.
- [x] Replace Crypt and Gallows Volley with native 1280×720 v4 arena redraws while retaining validated HD Graveyard/Ossuary/Warden and the dedicated Bone Crush benchmark.
- [x] Wire the latest native-HD Graveyard/Ossuary/Warden/Bone Crush redraws, remove post-grade darkening and floor-align Bone Crush deployment/combat.
- [x] Align Gallows Volley movement/spawn bounds to the authored stone floor and clamp unit positions immediately when combat bounds are assigned.
- [ ] Locally verify Gallows Volley retreat/separation with solo, duo and trio so ranged units never appear to move over background architecture.
- [ ] Continue any further arena replacement from native/high-resolution sources only. Thumbnail-scale full-screen arena upscaling is rejected.
- [x] Integrate the prepared v6 Wizard/table backdrop without baked live UI and reduce Wizard-wager/table dimming.
- [x] Rebuild the high-visibility remaining surfaces: Class Select portraits, Reward, Whispering Well, Curse Forge, Chained Prisoner, Black Altar and Run End now use dedicated authored v7 art while mutable values stay live.
- [ ] Continue lower-priority event/shop surfaces only where fresh local screenshots still show a meaningful visual mismatch.
- [x] Locally verify the corrected v4 cards and restored high-resolution arenas at 1280×720 before another broad visual rollout.


### V7 screen-art follow-up

- [x] Replace enlarged combat-sprite portraits on Class Select with dedicated Knight / Ranger / Mage portraits.
- [x] Replace the generic reward background with a dedicated treasure-altar scene.
- [x] Replace procedural Whispering Well and Run End backgrounds with authored full-screen scenes.
- [x] Give Curse Forge, Chained Prisoner and Black Altar dedicated full-screen event environments in the shared live-UI event scene.
- [ ] Review fresh 1280×720 screenshots before replacing any lower-priority art.


- [x] Replace the rejected low-quality main splash with the approved restrained Wizard/table redraw at native 1280×720 runtime resolution.
- [x] Add a persistent scene-transition veil and route active scene changes/reloads through it so runtime texture setup cannot expose a gray viewport frame.
- [x] Preload incoming scenes while the outgoing scene remains alive and manually swap them under an already-rendered veil, eliminating the empty SceneTree frame behind the intermittent gray flash.
- [x] Remove parse-time dependence on the `SceneTransition` autoload identifier so local `project.godot` conflicts cannot break compilation after pull.
- [ ] Locally stress-test repeated table ↔ event ↔ battle ↔ reward transitions for any remaining OS/editor-level flash.
- [ ] Locally verify table → battle, event → table, battle → reward and Last Deal reload transitions after a fresh Godot restart.

### Runtime art loading hardening

- [x] Harden v7 WebP loading against Godot import/parser timing by replacing direct new-asset preloads/ext_resources with runtime FileAccess + Image decoding.
- [ ] Confirm Class Select, Reward, Whispering Well, Curse Forge, Chained Prisoner, Black Altar and Run End all open cleanly after a fresh `git pull` and Godot restart.


### V8 secondary event-art pass

- [x] Reuse the accepted Class Select portraits in Squad Dossier instead of combat-sprite crops.
- [x] Wire dedicated V8 environments for Candle Seller, Gravedigger Shop, Blood Ledger and Faceless Card.
- [ ] Continue the remaining lower-priority generic Act 1 event screens after fresh screenshot review.


### V9 final generic-event environment pass

- [x] Integrate the final V9 generic-event environment batch for Rattling Bridge, Lost Purse, Debtor Bones, Bone Tax, Wizard Tithe, Ash Rest, Last Camp and Broken Crown.
- [x] Keep all V9 event text/state/choices live in the shared Act Choice UI and load the new WebPs through the runtime decoder.
- [x] Replace the main remaining duplicate event-thumbnail choice cards with semantic action art: Lost Purse, Debtor Bones, Wizard Tithe, Blood Ledger, Bone Tax, Ash Rest recruitment and Last Camp recruitment.
- [x] Prefer native 384×160 approved choice cells and reuse them as truthful action verbs instead of creating another broad generated-art batch.
- [ ] Review fresh local 1280×720 screenshots for targeted choice-art polish only; do not start another blanket visual redraw.


### Project continuity / source preservation

- [x] Save a durable GitHub handoff covering the current gameplay/visual state and exact next step.
- [x] Add a visual asset registry with runtime paths, version history, rejected approaches and source provenance.
- [x] Archive the final V9 generated masters at 1672×941 so future chats can recrop/re-export without recovering old chat attachments.

- [x] Replace abstract Act 1 progress with the live `РАСКЛАД СУДЬБЫ`: twelve historical card slots, sealed XIII boss, held-card area and Wizard rejected-card discard.
- [ ] Locally verify Fate Spread readability at 1280×720 after 0, 4, 8 and 12 resolved cards, including a held card and a populated rejected discard.

- [x] Bring Fate Spread closer to the approved reference with a live occult seal, fate-thread path, chapter gates, progressive XIII chains and stronger center hierarchy.
- [ ] Verify the reference-driven Fate Spread at 0/4/8/12 progress and confirm XIII chain break/reveal timing reads clearly at 1280×720.

- [x] Add physical table texture under the Fate Spread, hoverable chosen/rejected decision memory, and one-shot ritual reveals at IV/VIII/XII.
- [ ] Locally verify milestone auto-open timing after card 4/8/12 and hover-memory readability without blocking `R`/Esc close input.

- [x] Integrate the approved ornate Fate Spread reference as a dark atmospheric runtime underlay while keeping all run-state cards/counters live and data-driven.

- [x] Replace the dark full-screen Fate Spread underlay with bright top/left/right edge-art plates while keeping the center fully live.
- [ ] Locally verify that candles/metal/red cloth read clearly at 1280×720 without reducing card/title readability.

- [x] Rebuild `РАСКЛАД СУДЬБЫ` around the user-approved full reference plate, with live cards/masks aligned to its physical holders and ring.
- [ ] Local 1280×720 check: verify all I–XII live cards fully cover the baked concept cards, Hold/Discard masks hide stale concept state, and title/count masks do not expose duplicate text.

- [x] Rebuild the normal Wizard/card-selection screen around the approved Variant C oval ritual table instead of a rectangular lower UI panel.
- [x] Integrate the final approved Variant C full-table artwork as the canonical 1280×720 normal-table foundation while keeping live cards/counts/actions authoritative.
- [ ] Locally verify the exact-reference table at 1280×720: check live card coverage over the baked examples, Hold visibility, deck/discard numeric masks, hover/deal animation alignment and wager overlay readability.

## Current visual checkpoint — 2026-10-09

- [x] Freeze the approved Fate Spread composition after local screenshot verification; future changes are bug-fixes only.
- [x] Make the final cleaned-up Variant C art the canonical full-screen normal-table foundation.
- [x] Preserve the Variant C source master separately from the 1280×720 runtime WebP.
- [x] Align live two-card offers, Hold controls, Fate Spread access, deck/discard animation anchors and live counts to the approved full-screen table.
- [x] Hide the old procedural normal-table renderer / compact progress ring on the canonical table.
- [ ] **Immediate next check:** local 1280×720 screenshot of the exact-art normal table with two live offers; tune only concrete mask/position/readability defects.
- [ ] After the table screenshot is accepted, return to vertical-slice validation/balance rather than another broad art pass.


### Motion polish

- [x] Pass 1: physical table interactions — Hold stamp, chosen-card focus, rejected-card travel and discard impact feedback.
- [x] Pass 1 follow-up A: safe entry-only choice-card stagger restored for generic Act Choice and Whispering Well without commitment hooks.
- [ ] Pass 1 follow-up B: any choice-commit/result timing motion remains blocked until the entry-only patch is locally verified.
- [x] Pass 1: staged reward reveal and selected-reward confirmation beat.
- [ ] Pass 2 follow-up: attack anticipation/death settling was rolled back after a missing-unit regression; reintroduce only after local spawn/render verification.
- [x] Pass 2: Fate Spread ritual reveal/stagger and milestone emphasis without changing the frozen composition.
- [x] Pass 2: restrained Wizard wager/meddling reactions without skeletal/puppet-style animation of the painted character.
- [ ] Pass 2 local verification: confirm combat still reads fast, Fate Spread stagger does not feel slow, and backdrop reaction tints stay subtle.
- [ ] Pass 3 rework: battle controller motion was rolled back after the empty-arena regression; reintroduce only as isolated verified patches.
- [ ] Pass 3 local verification: confirm result overlays stay fast, Last Deal remains immediately readable, and battle controls never feel delayed.
- [x] Pass 4: subtle Variant C candle ambience, ritual reaction pulses, deal/deck response and destination-tinted safe scene veils.
- [x] Pass 4: staged Main Menu and Run End entry/commit motion.
- [ ] Motion cleanup: local verification and duration/intensity tuning only; avoid adding another broad animation layer before vertical-slice balance testing.
- [x] Pass 5: Class Select card reveal/commit, Intro frame settle, Squad dossier open/switch/close motion.
- [x] Battle recovery verified locally: heroes/enemies render again on the stable controller.
- [x] Safe combat-feedback pass: isolated tactical-order markers, Sacrifice/Defiance state FX, Death Wager framing and stronger source-aware hit feedback without touching battle controller/spawn.
- [ ] Combat polish follow-up: tune only intensity/readability from local screenshots; do not reintroduce async attack-windup/controller edits.


### Combat Expansion v1

- [x] Add six new combat cards, two per Act 1 tier, to increase run-to-run fight variety without extending act length.
- [x] Add fast Raider and lighter AOE Sentinel UnitData variants using existing validated combat families.
- [x] Give the new encounters distinct compositions, threat tags, preparation cues and proven deployment profiles.
- [x] Keep new combat rewards on the existing normal-loot path; Death Wager / Crypt Guard / Bone Warden special reward identities remain unchanged.
- [ ] Run several fresh Act 1 seeds and identify which new encounters feel redundant, overtuned or worth dedicated enemy/card art.
- [x] Create dedicated battle backdrops and table-card art for all six Combat Expansion v1 encounters.
- [ ] If Raider/Sentinel survive gameplay validation, create dedicated production unit silhouettes rather than keeping family-art reuse permanently.
