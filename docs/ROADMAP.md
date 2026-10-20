# Misdeal — Active Roadmap

## D293 — Correct rejected Battle DS3 visual direction (2026-10-20)

- [x] User explicitly rejected D292 Battle visual after native screenshot, as being dark flat boxes rather than DS3.
- [x] Replace superficial reskin with a material-based actual Godot Battle command tray: inset tactic tokens/scroll, bronze hardware and existing approved D287 genuine gilt fragments, red primary action with heraldic ruby crest, engraved upper run/encounter ledger inlays.
- [x] Keep approved arenas, unit feet and HP, all 3–5 real tactic Buttons, dynamic selected highlights, Fight/Continue/Preview, tooltip/action and RunState unchanged.
- [x] Official Godot 4.7.2 native D293 regression PASS ([run 39399922113](https://github.com/zampolit73/Misdeal/actions/runs/39399922113)) for painted ornament files, panel structure and live tactical switching.
- [ ] **Visual gate:** after `git pull`, user screenshot in real Godot of the new Battle preparation screen at 1280×720. User has NOT yet approved D293. Review for overwhelming ornament, click coverage, small font and arena visibility. If rejected, revert D293 scope rather than insisting on it.
- [ ] Only after actual user approval continue DS3 rollout beyond Battle.


## D292 — Screenshot-driven battle DS3 tuning (2026-10-20)

- [x] First live D291 Battle prep screenshot received: arena/sprites/feet/HP readable, tactical bar visually plain and chosen button weakly differentiated.
- [x] Refine just Battle DS3 skin: selected tactic with warm contrast and synced 2px inlay; subtle less-opaque bottom plates and single metal hairline; improve placement hint contrast.
- [x] Actual native Godot 4.7.2 Battle smoke PASS ([run 39398661063](https://github.com/zampolit73/Misdeal/actions/runs/39398661063)), preserving five tactic controls, Hunt→Formation highlighting, real units and existing arena coordinates.
- [ ] User refreshed screenshot after `git pull`: check selection readability on actual art and confirm bottom HUD does not obscure actors. This remains an aesthetic gate, not an automated one.
- [ ] After visual signoff only, continue DS3 on rewards/shop or other screens, without altering combat or approved arenas.


## D291 — Next DS3 pilot: combat HUD (2026-10-20)

- [x] User posted new D290 Table screenshot: baked deck count collision eliminated; top header/Wizard bar less cluttered; two painted offer cards preserved.
- [x] Add scope-limited DS3 panels and original 5 dynamic tactic-button skins to production Battle, without changing battle geometry/actors/AI/RunState, at `scripts/battle/battle_ds3_pass.gd`.
- [x] Native official Godot 4.7.2 real Battle boot and tactic toggle/arena geometry smoke **PASS** ([run 39397929958](https://github.com/zampolit73/Misdeal/actions/runs/39397929958)).
- [ ] User native 1280×720 screenshot of actual pre-fight Battle and, if useful, during combat. Review overlap/contrast/hero feet/tactic selection. Fix only screenshot-evidenced issues before wider DS3 rollout.
- [ ] Continue reward/shop DS3 only after visual acceptance of Battle; no wholesale scene replacement.


## D290 — DS3 screenshot-backed corrections (2026-10-20)

- [x] Real D289 Table screenshot found baked-static 22 beside live deck count 37, and two layers of metal corner decoration DS2 + DS3.
- [x] Patch only D290 Table DS3: extend number mask and hide old two-panel corner overlay while keeping single thin DS3 outlines, all original artwork and real 2-card actions.
- [x] Native Godot 4.7.2 extended real two-offer Table smoke PASS: https://github.com/zampolit73/Misdeal/actions/runs/39396611590
- [ ] Compare D290 in fresh native Godot Table screenshot after pull; ensure single deck counter, preserved caption and calmer top chrome before moving to Battle HUD.


## D289 — DS3 Table-only live visual pilot (2026-10-20)

- [x] Apply DS3 copper/obsidian low-density chrome to peripheral live table HUD, Wizard line, Squad/Fate Spread buttons, actual Deck/Discard labels and Wizard Wager action panel, **after** existing DS2 styles.
- [x] Preserve BOTH physical 272×338 live encounter cards, D278 painterly frames/parchment/art, separate Hold controls, Lore RMB, 12-card Fate Spread and all two-offer RunState data.
- [x] Native Godot 4.7.2 two-card Table startup + live controls regression PASS ([D289 Actions](https://github.com/zampolit73/Misdeal/actions/runs/39393893259)); D274 original card-art contract regression PASS.
- [ ] User Godot screenshot at 1280×720 of normal Table with two offers. Assess frame weight, contrast, Wizard copy, card spacing, only actual issues to fix. Not yet visually signed off.
- [ ] Next, after accepting Table visuals, trial compact DS3 Battle HUD separately; original arena/units/tactics and combat mechanics must be preserved.
- [x] DS2 rollback branch remains immutable; D289 changes reversible by reverting DS3-specific commits.


## D288 — DS2 safe checkpoint, staged DS3 rollout (2026-10-20)

- [x] Record entire pre-DS3 `main` as verified immutable `checkpoint/ds2-pre-ds3-2026-10-20`, commit `4cbd206`, plus safe restoration instructions.
- [x] Introduce `scripts/ui/misdeal_ds3.gd` opt-in tokens/surfaces/action styles. Retain DS2 UIKit and all locked artwork as they were.
- [x] Exercise DS3's visually neutral, exact D287 panel style implementation on the live Squad Dossier; extend Godot headless regression checks.
- [x] D288 official native Godot 4.7.2 regression **PASS** ([run 39392900520](https://github.com/zampolit73/Misdeal/actions/runs/39392900520)); request screenshots only for later **visible** DS3 screen changes.
- [ ] DS3 pilot on one selected real screen (prefer Table, not generated three-offer concept), preserve actual two-offer UX, card data, fate spread and callbacks; real screenshot before rollout.
- [ ] Battle DS3 chrome pilot later, preserving autobattler behavior, enemy art and arena space; separate screenshot + fight→reward→table QA.
- [ ] Rewards, shop and secondary UI migrate only when previous screens and UX are accepted.


## D287 — Approved Squad Dossier final art direction (2026-10-20)

- [x] User approved the final richer third-layout dossier artwork.
- [x] Integrate UI-free genuine painted ornament from that source as small independent transparent WebPs, leaving real hero portraits, labels, stats, party effects, upgrade and relic data live.
- [x] Add ornamental crests and corners, dark medieval relief, progress diamonds, medallion relic holders; improve panel hierarchy with unchanged Battle/RunState.
- [x] Official native Godot 4.7.2 D287 base art CI PASS ([run 39390179653](https://github.com/zampolit73/Misdeal/actions/runs/39390179653)).
- [x] Extended D287 native decorative UI/data smoke PASS ([run 39390304778](https://github.com/zampolit73/Misdeal/actions/runs/39390304778)).
- [ ] User-native D287 1280×720 screenshot, including empty relics and live role switch; correct only actual observed issues.


## D286 — Dossier screenshot correction (2026-10-20)

- [x] Real D285 screenshot diagnosed: tall hero card had severe vertical black bands; stats too tiny and footer crowded.
- [x] D286 screenshot-directed UI-only correction committed `f6e5039`: cover-mode portrait, stronger stat hierarchy, larger progress/relic markers, multi-row footer; real RunState unchanged.
- [x] Official native Godot 4.7.2 smoke PASS ([Actions 39387267091](https://github.com/zampolit73/Misdeal/actions/runs/39387267091)).
- [x] D286 screenshot received: top/bottom voids removed; Knight face, sword and shield readable; stats and footer improved. This is a visual checkpoint, **not explicit user final approval**.
- [ ] Optional restrained art/UX pass on the sparse right progression/relic panels and empty states to better match approved third concept; avoid fictional perks or arbitrary decorations. Keep role/RunState logic unchanged.


## D285 — Squad Dossier third visual option integrated (2026-10-20)

User selected **third** of three rendered dossier design concepts (hybrid: left portrait roster, tall central hero card, clear middle stats and role text, right progression/relic panels, segmented party footer). Implementation is in `scripts/ui/squad_dossier_v3.gd`, wired to actual `scenes/table/squad_status.tscn` and `scripts/table/squad_status.gd`; real RunState data/role switching, upgrade counts, relics, solo modifiers and close preserved. Native Godot 4.7.2 regression initially failed due inferred `selected` boolean type; fixed in commit `2b9e2c5`. Native D285 Actions **PASS**: https://github.com/zampolit73/Misdeal/actions/runs/39386342756. **User screenshot visual validation still OPEN**: ask for one 1280×720 screenshot of real dossier and address only observed differences. This is not a pixel-perfect reproduction claim. No combat/balance changes.


## D283 — User-approved arena replacement (2026-10-20)

- [x] Integrate exactly chosen Bone Ritual and Firing Square 1280×720 scene art into the existing two `AuthoredBattleBackdrop` production mappings, with unchanged gameplay and rollback.
- [x] Provide native Godot 4.7.2 image decode/texture sanity smoke and update art gallery, source-hash notes and handoff.
- [x] Native Godot 4.7.2 D283 workflow **PASS** ([Actions 39374993074](https://github.com/zampolit73/Misdeal/actions/runs/39374993074)); user subsequently answered **«Все ок)»** to the requested local test. Treat this as no-blocker acceptance of both replaced arena artworks; no screenshot independently attached or full-route metrics claimed.
- [x] `grave_crossfire` art review closed by user decision: **retain existing** `arena_redraw_v2/grave_crossfire.webp`; proposed new crossroads images are rejected for integration. No code or asset change. Revisit only if explicitly requested.


## D282 — Final ClassSelect chrome polish (2026-10-20)

User reviewed real native D281 screenshot and found the **full-HD clean-table background / character illustrations good**, requested a small final UI-only polish. Runtime commit `8c66148f075da4fed0043c38228d25c5abe51deb` leaves the **1280×720 D281 source image, 272×338 D278 bronze hero cards, original three portraits, source UnitData HP/damage, solo hero and RunState, Battle/Table/Fate Spread untouched**. Visual changes: reduced the black top title slab to translucent narrow aged-bronze edging; moved Wizard dialogue from Y243–283 to a restrained, readable line in a separate thin band at Y98–136 (actual text Y103–131); added a mild bottom caption strip and larger readable 13pt explanatory text at Y688–711; improved crimson/bronze confirmation bevel; the selected hero now gets a **visible persistent 3px gilt rim OVER the illustrated card frame** (2px soft outline on hover; other hero cards modestly dim). Source-backed native Godot 4.7.2 import/scene/hover/selection/reselection/confirm/solo smoke PASS: https://github.com/zampolit73/Misdeal/actions/runs/39322918562. **User native 1280×720 D282 screenshot and final artistic acceptance remain OPEN**. Next: `git pull`, new ClassSelect screenshot idle and chosen, check header/line/readability and selected rim. No more speculative repaint without screenshot evidence.


## D281 — Fix D280 screenshot blur and logo rectangle (2026-10-20)

User's real 1280×720 Godot screenshot **REJECTED D280's art**: the 640×360 / 11,320-byte backdrop had been stretched 2×, destroying detail, with a hard dark rectangle in the PNG logo. D281 implementation commit `5b40b285` replaces it with **native 1280×720** WebP (`assets/pixel/class_select/d281_clean_table_hd.webp`, 168,948 bytes, SHA256 `7464edde5990b53a6d1ec8d1646e96080c9944be0a4a79e04bdba6689d5f28e1`) derived directly from the EXISTING 1672×941 clean wizard/table original at high quality, not upscaled from the bad D280 copy. Scene uses reusable `scripts/ui/runtime_webp_texture.gd` (no runtime resize), removes the 4 D280 Base64 chunks and obsolete loader, and keys out the original logo's dark matte with `shaders/class_select_logo_key.gdshader` on ClassSelect ONLY. Existing painted portraits/272×338 cards, source stats on hover, selection and confirmation, Table, Fate Spread and RunState unchanged. Official Godot 4.7.2 asset hash/scene/interactions PASS: https://github.com/zampolit73/Misdeal/actions/runs/39320810866. **Native user aesthetic re-check of D281 still OPEN.** Next: git pull, screenshot ClassSelect at 1280×720; check wizard and candles are sharp and logo's dark square is gone. More detail: docs/D280_CLASS_SELECT_CLEAN_TABLE.md.


## D280 — Clean three-fates class selection (2026-10-20)

User approved a final pure ritual-table ClassSelect: no baked HUD, no old offers or masked background UI, restrained heading, three existing hero cards, authentic hover HP/damage and separate crimson confirmation. Code commits a9b3cbeb, 52571357, 33f53350 now replace D279R screenshot with a NEW clean wizard/table painting (no old cards, buttons or counters). A single 640×360 UI-free WebP (11,320 bytes, SHA256 8005eca284768611b923cdf8b87f9a8f4db0554dd4a7e4d6277925c27a6d93fe) is reconstructed from four exact Base64 fragments by scripts/class_select/class_select_clean_backdrop.gd. D279R OldOfferObscurer and all fake cover plaques/FateTitle are removed. Real Misdeal logo returns; softer title at Y42-85, dynamic Wizard commentary at Y243-283, existing three 272×338 D278 framed cards at Y292-630 and confirm at Y640-682. Original Knight/Ranger/Mage portraits and .tres stats and solo RunState routing unchanged. Production Table and Fate Spread untouched. Official native Godot 4.7.2 asset-integrity, import and interaction smoke PASS: https://github.com/zampolit73/Misdeal/actions/runs/39318175090. THIS IS NOT THE USER'S 1280×720 ARTISTIC APPROVAL. Background source integrated at 640×360 for reasonable runtime footprint; review whether higher-res is necessary based on actual Godot screenshot. See docs/D280_CLASS_SELECT_CLEAN_TABLE.md.


## D279R — Screenshot FAIL: baked Table UI beneath ClassSelect; first-pass scoped concealment (2026-10-19)

Actual user Godot screenshots of D279 (idle and selected Knight) showed SEVERE art layering defect: background `assets/pixel/table/approved_variant_c/table_exact.webp` is a **FULL painted mock with baked HUD, WizardLine, FateSpread action, two old encounter cards, Hold controls, Deck/Discard counters**, NOT a UI-free photographic background. D279 wrongly used that image under three new live hero Buttons, so ghost card names, hold buttons and table UI remained visible. D279 native CI PASS was ONLY functional and did not imply visual approval. Mark D279 original layout **visual FAIL**.

Repair commits `419e0af`, `87e058c` and diagnostic cleanup `f7faba0`: **ClassSelect-only** occlusion layers `TopHeaderPlate`, `TopRightCover`, `FateSpreadCover` and shader-backed `OldOfferObscurer` conceal the known baked old UI; relocate ClassSelect Title + Wizard reaction into a small top bronze banner, not across the wizard face. Original hero portraits, D278 card trim, true UnitData HP/damage on hover, selection/confirm logic and three classes untouched; **production Table background is not edited**. Native Godot 4.7.2 load/role/confirm test PASS at https://github.com/zampolit73/Misdeal/actions/runs/39315102093 and https://github.com/zampolit73/Misdeal/actions/runs/39315252479. These are structural checks, **USER VISUAL RE-REVIEW STILL OPEN**. Note: old deck/discard art outside the occluded central play area is still baked into the source; an actual independently approved clean tabletop background remains the long-term proper replacement for this stopgap. Never mistake legacy baked `table_exact.webp` or `table_wizard_layer.png` for clean background. See `docs/D279_CLASS_SELECT_TABLE_UI.md`.


## D279 — Class choice screen on actual approved cursed table (2026-10-19)

User chose the understated three-card concept matching existing D278 tabletop colors and requested implementation, with clean idle state, real HP/damage shown on hover, Wizard commentary, persistent click selection and separate `ПРИНЯТЬ ЭТУ СУДЬБУ` confirmation. Implementation code commit `3d6476b`: `scenes/class_select/class_select.tscn` replaces giant opaque 1140×622 menu with the **existing approved Variant C `table_exact.webp` backdrop** and three 272×338 independently painted v7 portraits on warm parchment with the existing D278 transparent bronze frame. On hover, show HP/damage sourced from actual `resources/units/{knight,ranger,mage}.tres`, while normal card state retains class title/role/description; Wizard line reacts without changing narrative canon. Clicking a card only sets the highlight, dims others and activates separate confirm; **only confirmation calls `RunState.choose_protagonist(role)` then original Table routing**. Keyboard arrows cycle roles; Enter confirms only a selected role. No stat rebalance, starter party additions, new game narrative choices or Fate Spread changes. Official Godot 4.7.2 import + **full real-scene regression PASS** (https://github.com/zampolit73/Misdeal/actions/runs/39312723690): all three art/card resources loaded, source `.tres` stats verified, idle/hover and reselect work, **RunState stays untouched until confirmation**, then confirmation yields exactly the selected solo Mage. Standalone test harness adjusted in `86c59f4`; final extra confirm smoke `dd72b1c`. User native 1280×720 artistic acceptance **OPEN**. See `docs/D279_CLASS_SELECT_TABLE_UI.md`.


## Act I «Обещанный рассвет» — narrative production track (2026-10-19)

- [x] Approve hero sacrificed castle to save country but sent truthful no-relief order.
- [x] Approve **Chancellor forged letter; Commandant later learned truth and continued lying; Commandant = Bone Warden XIII**.
- [x] Author 20-day siege chronology, 12 draft letters, 39/39 current-card clue hooks and conditional XIII scene draft in [story bible](ACT1_PROMISED_DAWN_STORY_BIBLE.md).
- [ ] Settle specifics left open: actual origin/price of undead oath, Wizard relationship to events, name/localization details and finale consequence balance.
- [ ] Implement minimal tactile DS2 table slice: inspect two dispatches, compare two seals, log evidence and show one consequential Wizard response; test native Godot before broad rollout.
- [ ] Extend short optional clues across multiple cards/tiers, preserving random 12+XIII and existing event decisions; add QA seeded runs with sufficient/insufficient clue cases.
- [ ] Implement Warden identity reveal and final strategic choice in a separately reviewed/game-tested pass; current run_end is still a stats-only screen.

**Story-only now:** Act1 39/45, code, art, balance and final UX unchanged. The older «Narrative workstream: Siege mystery» list below is historical/superseded where it asks the team to select culprit.

## Narrative workstream: Siege mystery (approved direction; implementation not started)

- [x] Approve core twist: commander sacrificed castle to save country but sent **truthful** no-relief order; third party forged promised-rescue letters. Protagonist's tragic command responsibility remains.
- [ ] Propose and choose culprit, motive, what garrison knew, and supernatural mechanism of undead; validate against the current intro and three selectable protagonist classes.
- [ ] Write compact branching clue map using all 39 current Act I cards, with overlapping discovery paths suitable for randomized I–XII.
- [ ] Design first tactile tabletop investigation vertical slice (inspect letter, compare two seals, reveal consequential option) without bloating UI or requiring extra clicking on every deal.
- [ ] Plan XIII Warden revelation and final castle-vs-country choice after user approves detailed narrative; only then modify actual story/card events and test normal Godot gameplay.

Detailed non-code brief: [ACT1_SIEGE_MYSTERY_DIRECTION.md](ACT1_SIEGE_MYSTERY_DIRECTION.md). Act I currently 39/45; code and gameplay unchanged.

## D278 — Native screenshot review (2026-10-19)

User supplied three actual Godot tabletop screenshots after pulling D278: regular two-offer composition (Moon Seal + Whispering Well), raised/hovered card, and explicit RMB full-lore modal. Review: newly painted gold-bronze border is visibly present on BOTH original live illustrated cards, no evident opaque art/text overlay, Russian titles/descriptions and crimson Choose actions remain legible; raised-state and held tabs are visible; inspection modal is clean, readable and separate. Subtle gold edging is visually heavy near the corners, but no screenshot-proven blocking issue. **Native screenshot visual QA: no evident blockers; formal artistic approval not explicitly stated by user**. No new functionality or mechanical changes requested in this screenshot-only turn. Recommend pausing frame micro-polish and prioritizing a separately discussed tactile/lore interaction on the cursed table; preserve current D278 graphics for rollback. Act1 remains 39/45.


## D278 — Actual transparent painted metal frame on tabletop offers (2026-10-19)

User authorized replacing the previously procedural D277 decorative fittings with a true stand-alone graphic frame. Runtime committed in `6fcdf100`: an artistically sourced, cropped and alpha-isolated 272×338 WebP frame (`SHA256 94c1991dd4ea421b566bf5e6782fba9c04387cb6b4da97b31f0091754128f6b9`, 5088 bytes). Binary-safe GitHub storage uses four precisely verified 1696-character UTF-8 Base64 fragments `assets/pixel/table/offer_frame_d278_{1..4}.webp.b64` rather than baking a full reference screenshot. `scripts/table/table_offer_frame_asset.gd` concatenates, verifies dimensions/transparent center and provides ONE cached `Texture2D` to both `scripts/table/table_offer_skin.gd` live cards. Only graphic ornamentation changes: original dynamic illustration, original parchment, titles, event text, crimson Choose, Hold and RMB examination all remain Godot controls. Old D277 corner engravings hidden for visual cleanliness; kept intact for rollback. Official Godot 4.7.2 D278 exact-source hash / transparent-image decode / two-live-card smoke **PASS** (https://github.com/zampolit73/Misdeal/actions/runs/39296402449); user's native 1280×720 artistic review remains OPEN. No changes to Fate Spread Variant C, Wizard, party/battle, card pool 39/45, Court/D264, KARAMBA73. See `docs/D278_PAINTED_FRAME_INTEGRATION.md`.


## D277 — Production antique parchment and engraved cards (2026-10-19)

User requested immediate implementation after visually verifying D276 two-card + RMB lore UI. D277 code commit 0d3a1b9 modifies ONLY presentation: more nuanced deterministic aged-paper shader, engraved corner fittings and wax/bronze rivets, warm bronze offer borders, hover-dependent crimson/gleam on the existing Choose plate, and restrained ornamental trim around the compact RMB lore dialog. Existing painted encounter art remains independent; RunState, LMB Choose, RMB lore, hold, mark, dealing, Fate Spread I–XIII, wizard and 39/45 Act1 remain unchanged. Official Godot 4.7.2 D277 import/component test PASS: https://github.com/zampolit73/Misdeal/actions/runs/39293886000; **DO NOT assert user visual sign-off before new native 1280×720 screenshots**. Details: docs/D277_TABLE_ART_PASS.md.


## D276 — Screenshot-accepted D275 usability, compact art-polish in main; native visual QA pending

2026-10-19: User provided TWO native 1280x720 Godot screenshots: (1) intentional RMB lore examination modal for `ПЕПЕЛЬНЫЙ ПРИВАЛ`; (2) ordinary two-card table with `ПЕПЕЛЬНЫЙ ПРИВАЛ`, `КОСТЯНОЙ ДОЗОР` and Wizard Mark. **D275 hover obstruction is resolved in these actual screenshots**: offers remain visible and readable, and full lore appears in a separate modal. New visual issue: oversized empty space in 760x440 lore window and flat card trim. D276 scoped polish reduced inspect frame to 720x364 centered at (280,178), removed redundant under-art instructions, balanced artwork/title/scroll area, added two restrained engraved detail lines and a quiet emblem; cards gained an inner bronze line, art rims and an action divider. Read-more hint contrast improved. Original approved art and Background, single/duo/trio gameplay, card choice/hold, Fate Spread I–XIII, Wizard Mark and 39/45 Act1 pool unchanged. Commits 141e2b0 / a783f66; source-integrated, native Godot visual review of the **D276 pass** is still required. See docs/D274_TABLE_PARCHMENT_UI.md.


## D275 — Native screenshot: hover popup still obscured choice; inspect on RMB instead

2026-10-19: User's follow-up 1280x720 Godot screenshot proves D274R wrapped 318px tooltip is technically legible but **still covers card names, descriptions and red choose buttons**. Reject hover tooltip behavior as UI/UX failure, despite technical D274 green smoke. D275 now has **no automatic offer-card tooltip**: pointer hover only lifts card and previews Wizard line; **RMB on card** opens a dedicated framed inspect window with original art, FULL original Russian description and scrollbar; close by ESC, close button or outside click. A visible bottom-table hint advertises RMB; LMB retains original card selection, hold controls and all RunState logic stay unchanged. Implemented in commit 23adc330, Godot 4.7.2 native import and D275 inspect-panel smoke PASS (https://github.com/zampolit73/Misdeal/actions/runs/39290459465). This is presentation-only, no card art/Fate Spread/combat rewrite. Accept artistic quality only after native screenshot review, not solely CI. Read docs/D274_TABLE_PARCHMENT_UI.md. Act1 39/45, Court/D264, KARAMBA73 unchanged.


## D274R — Native screenshot visual FAIL repaired; re-review pending

2026-10-19: Real user 1280x720 Table screenshot revealed an unwrapped native Godot stock tooltip displaying long Russian card lore across BOTH parchment cards; earlier D274 technical CI did not guarantee visual acceptance. The problem was tooltip popup width, NOT duplicated card node labels. Commit 16107bb switches both live offers to a bounded 318px wrapped bronze/dark tooltip, darkens parchment title/type ink, and keeps hold tabs above hover-raised cards. The Godot 4.7.2 D274 component/long-Cyrillic-tooltip regression workflow PASSED: https://github.com/zampolit73/Misdeal/actions/runs/39289351602. Artistic verdict after user git pull remains OPEN. Do not change approved Wizard/table/Fate Spread, artwork, Act1 39/45, D264/D271, or KARAMBA73. Full handoff: docs/D274_TABLE_PARCHMENT_UI.md.


## D274 — User-approved parchment Table offer-card UI in main; native review open

2026-10-19: Implemented the selected TWO-card hybrid at 1280×720: 272×338 parchment cards, original large CardArtCatalog illustrations, ink Cyrillic copy, crimson inline ВЫБРАТЬ face, bronze УДЕРЖАТЬ tabs, full description via tooltip. Only normal-deal Table card presentation changes; all original RunState choice/hold/mark/meddling/wager transitions, Wizard, approved Variant C Fate Spread, and art assets remain unchanged. Act1 stays 39/45 (#39 released), D271/D264/KARAMBA73 intact. Main code e1b32fd; official Godot 4.7.2 D274 import and actual Table component smoke CI PASS (https://github.com/zampolit73/Misdeal/actions/runs/39288370462). **User native visual acceptance is still pending**: test hover, held, marked, boss/single, long Cyrillic and real choice transitions. See docs/D274_TABLE_PARCHMENT_UI.md.


## D273 — COMPLETE: Court #39 released into Act1 39/45; prepare D274

- [x] D271 genuine painted 1280×720 character-free Court arena visually accepted by user; D270 flat SVG explicitly rejected and no longer active.
- [x] D272 all 75 approved D267 rich exported poses structurally independently validated: 3px+ safe alpha gutters, all unique, 15 unused cells clear. **27 source flags remain visual pointers, not proven output-cut frames**.
- [x] **#39 released**: target_path connected; `RunState.ACT1_CARD_IDS` now **39/45**, no Fate Spread / party / balance rewrite.
- [x] [Godot 4.7.2 actual ordinary dealt #39 → Court 4 originals + red verdict + D271 → Reward → Table PASS](https://github.com/zampolit73/Misdeal/actions/runs/39264156351); 6 real Party/Formation boot cases and 54/54 functional cases green. [Original SHA/native rich gallery CI PASS](https://github.com/zampolit73/Misdeal/actions/runs/39264427458).
- [ ] Future QA if gameplay video demonstrates Bailiff death/grip or foot defects: one bundled targeted fix, preserve original D267 identity. Not a reason to call technical release unverified.
- [ ] **D274:** plan next #40 based on original enemy identities/mechanic and D168 2–3 genuinely rendered *card illustration* choices before final artwork selection. No unapproved underlying redesign. [Current handoff](D273_NEW_CHAT_HANDOFF.md).


## D271 — ACTUAL PAINTED COURT IN MAIN; Godot native PASS, artistic user verdict next

The previously rejected D270 SVG has been replaced in real **Court-only** QA Battle by the genuine full-resolution painted D271 WebP b64 (1280×720; SHA256 `1eb45164d9c7418fb9c459d18c0640935452266aeecbb04d1e9d7bd527af8784`). [Godot 4.7.2 full D271 CI PASS](https://github.com/zampolit73/Misdeal/actions/runs/39261648732): source bytes, 1280×720 texture, F6 **B** D265/D271 comparison, **L/G**, six real Battle setups, 54/54 Court BattleUnit simulations and QA-only Fight→Reward→Table. The old "not transferred" D271 notes below are HISTORICAL/SUPERSEDED. Need native visual acceptance from user, then rich D267 ×1 animation review/27 flags, then separate #39 ordinary-deal release. Card #39 still UNRELEASED, 38/45, D261/D264/#38/KARAMBA73 unchanged. [D271 verified report](D271_PAINTED_COURT_NATIVE_PASS.md).


## D271 — Court D270 SVG was rejected as placeholder; painterly arena restoration

- [x] Recorded user's native screenshot feedback as **artistic FAIL of D270**, despite its technically successful Godot CI.
- [x] New detailed **actor-free** Court painted 1280×720 visual candidate prepared from generated architectural art, recropped to remove lower ledges/steps so **screen y532–710 is entirely floor**.
- [ ] **BLOCKER:** transfer candidate WebP from chat artifact to GitHub asset without loss, stage exact actual image (not another programmatically drawn flat SVG). It is *not live yet*. Keep D265/D270 rollback.
- [ ] Native 1280×720 Godot real Battle image QA, user visual inspection, full 54-case QA plus Battle→Reward→Table, and D267 original full animation 27 source-edge review.
- [ ] Only after real artistic acceptance release card #39 separately; currently **38/45**.


## D270 — Editable actor-free Court battlefield staged, technical PASS; art review remains

- [x] Independently authored complete original *empty* Gothic tribunal D270 SVG; actual Court-only Battle uses it in QA at 1280×720. Existing D265 art remains for instant rollback; **B** in F6 compares both.
- [x] Separate native 1280×720 Godot SVG raster/opaque floor contract; **B/L/G** QA toggles no gameplay/geometry changes.
- [x] [Godot 4.7.2 native D270 CI SUCCESS](https://github.com/zampolit73/Misdeal/actions/runs/39255650012): new art, six real boots, 54 Court `BattleUnit` cases and direct unreleased QA Fight→Reward→Table.
- [ ] User-native **art quality** verdict at ×1 (B toggles D265 vs D270): SVG currently candidate, **not accepted painterly final**, preserve DS2 / D261 original style and D264 lower floor.
- [ ] Full D267 original rich sprite motion ×1 review/27 source-edge flags, fix only real Bailiff death or grip issues as a batch.
- [ ] Export final user-accepted arena safely and rerun native smoke, then separate #39 **ordinary dealt** release to 39/45. **Currently 38/45**. [D270 handoff](D270_NEW_CHAT_HANDOFF.md).


## D269 — Court upper-scene local atmosphere verified; full illustrated arena next

- [x] Added Court-only upper-vault subtle moon shafts, four original-brazier warm flicker and sparse motes, strictly **above** D264 lower combat terrace. Existing D265 provisional bitmap unchanged.
- [x] F6 genuine Court Battle QA now supports **L** upper light on/off, **G** exact lower legal floor debug highlight, both non-invasive/QA-only; independent D269 real F6 contract.
- [x] [Official Godot 4.7.2 native CI PASS](https://github.com/zampolit73/Misdeal/actions/runs/39252464563) incl. new D269 L/G checks, six Court Battle startups, 54 functional balance fights and true *direct-QA* Reward→Table.
- [ ] **Next art production:** actor-free **genuinely rich Court arena** (replace D265 temporary schematic) tied to D261 second selected card atmosphere; lower D264 floor unchanged, no painted characters/UI.
- [ ] Native ×1 visual review D267 all 75 poses and 27 source-edge flags; grouped repairs only for visibly broken frames.
- [ ] Final bitmap/native 1280×720 screenshot and route QA, then distinct gated #39 release and ordinary dealt-card test. **38/45 live now.** [Current handoff](D269_NEW_CHAT_HANDOFF.md).


## D268 — Court functional QA verified; ONLY art and release gates left for #39

- [x] Character-free QA Court arena integrated into actual Battle, correct D264 lower combat floor, removed unrelated Crypt effects; final painted backdrop NOT finished.
- [x] Real Court F6 1/2/3 hero × two-formation launcher, plus D267 rich animation F6 pause/frame-step/27-warning navigator.
- [x] 54 original Court BattleUnit matrix, six real Court Battle startup checks, and direct unreleased Battle→Reward→Table test: [official Godot 4.7.2 CI SUCCESS](https://github.com/zampolit73/Misdeal/actions/runs/39249979969).
- [x] Court-only measured balance pass: **54/54 wins, 0 timeouts**, mean remaining HP **83.84% / 75.54% / 80.16%** solo/duo/trio, 2 individual trio casualties. Marked hero held by Bailiffs for all 7,694 live active samples, 0 artificial redirect needed. [Full data](D268_NATIVE_COURT_BALANCE_AND_ROUTE_PASS.md).
- [ ] One genuine x1/x2 visual QA for all 75 original D267 sprite poses, inspect 27 source-edge warnings and repair actual defects, especially Bailiff death/halberd/shield.
- [ ] Finished richly illustrated **actor-free** tribunal replacing still-schematic D265 QA background, preserve bottom floor screen x40–1268/y532–710.
- [ ] Then final art-enabled native QA and separate intentional release card #39 to 39/45, including ordinary dealt-card smoke. **Currently 38/45 live, card #39 target_path empty**. [Current handoff](D268_NEW_CHAT_HANDOFF.md).

## D267 — Approved PNG import and rich 75-frame recovery DONE; user F6/release gates open

- [x] All three exact approved PNG sources and three clean-alpha D267 rich 25-frame atlas files committed; 75/75 structural PASS.
- [x] Strict Court role library QA-stage integration and native Godot 4.7.2 combined x1/x2 preview CI PASS.
- [ ] Visual F6 review of **27 original source seam warnings** (Judge 5, Scribe 0, Bailiff 22), including Bailiff death poses.
- [ ] Rich empty tribunal (D265 still QA), real 54-case new battle balance, Fight→Reward→Table, separate card #39 release to 39/45. Remains 38/45 LIVE now.

## D267 — Rich Court trio artistic direction approved; source import and native atlas conversion NEXT

- [x] User approved THREE detailed 1374×1145 transparent pose-sheet illustrations (Magistrate/Scrivener/Bailiff) after D266 stylized QA prototype review.
- [ ] Transfer unchanged three source PNGs from conversation to GitHub source archive; seam-aware compose 25 full original clean poses per role into 6×5×96, with 5 clear spare cells and planted feet.
- [ ] One F6 native x1/x2 motion review all five states/directions and real weapon/book grip; only then register real sprite assets. No art reconceptualization or micro-approvals.
- [ ] Refine character-free Court arena and test actual Battle/Reward and 54-case matrix; release #39 only when gates pass. Live **38/45**, KARAMBA73 frozen.

## D266 — Court three transparent 25-pose sprites structurally QA-ready, not yet approved rich game art

- [x] Three different 576x480 / 6x5x96 authored pose sheets: Judge, Scribe, Bailiff with 25 used and 5 empty cells each.
- [x] Independent 75/75 alpha-padding-and-uniqueness validation and Godot 4.7.2 x1/x2 three-role animation scene PASS.
- [ ] **NEXT D267:** enrich silhouette, bone/cloth shading, correct gripping hands, gait/death poses in one batch; single native F6 visual review, no per-frame signoff.
- [ ] Improve separate EMPTY Court arena beyond schematic QA; then stage original sprites in Battle, 54-case local balance and actual Reward→Table, release #39 only after passing.
- [x] Preserve selected D261 art, D264 lower combat floor, D260 #38, Act1 38/45, KARAMBA73.

## D265 — Richer Court background QA PASS; 3×25 original character-art source gate OPEN

- [x] New reproducible richer *character-free* tribunal QA WebP, separate from D263/approved D261 card, preserving D264 floor; Godot 4.7.2 F6 native decode PASS.
- [x] New unified **75-frame** structural, alpha, 2px-margin, spare-cell and pose-uniqueness audit, machine-readable: **0/75 originals accepted, all three Court atlases missing**; green audit process does not imply artwork completion.
- [ ] **NEXT:** batch draw/render all 75 original 96px cell poses, single Godot F6 1× / 2× movement/grip/feet review; no fake duplicate/mirror padding of missing art.
- [ ] Upgrade empty Court background beyond current schematic D265 QA, then native full Court Battle→Reward→Table and 54-case balance, deliberate #39 release to 39/45. Stay 38/45 live, KARAMBA73 untouched.

## D264 — Court combat bounds moved to lower floor (done); art still pending

- [x] Apply user RED-rectangle floor selection in actual Court Battle + F6 preview, not just a misleading visual overlay: screen `Rect2((40,532),(1228,178))`, `UnitsLayer` local `Rect2((20,436),(1228,178))`.
- [x] Court actors spawn on lower floor **above tactics HUD** before Fight, while AI remains bounded to entire lower terrace during battle; three party sizes and both formations retained. Existing other arenas / #38 unchanged.
- [x] Official Godot 4.7.2 floor preview PASS and real Battle 6-case bounds/verdict plus 54-case released #38 regression PASS; original D261 second card artwork unchanged.
- [ ] NEXT: three original full 25-cel transparent role atlases `mute_magistrate`, `ash_scrivener`, `bone_bailiff`; one batch with true x1 foot/grip/facing checks.
- [ ] Refine D263 geometric arena into suitably rich **character-free** Court scenery; D263 current file remains QA layout only. Then native full Battle→Reward→Table and Court 54-case balance, and deliberate #39 (39/45) release only after all gates.
- [x] Maintain live 38/45, DS2/Fate Spread and frozen KARAMBA73.

## D263 — Original character-free Court architecture candidate and honest art gate

- [x] Reproducibly generate a standalone **1280×720 empty** underground tribunal with stairs, throne, scales, candles, contiguous tactical floor; NO burned-in Court units.
- [x] Validate image size, lossless round-trip and Godot 4.7.2 scene decoding with approved D261 selected-card-art reference intact; F6 `court_of_the_mute_d263_empty_arena_preview.tscn`, G toggles legal floor.
- [x] Inspect exploratory sprite montage and reject as final: Magistrate ~24 miniatures, Bailiff ~18–20; Scrivener ~30 but opaque/composite, no clean grounded 6×5 sheet. Do NOT invent missing original poses or register false art.
- [ ] **NEXT D264:** make THREE full original clean-alpha sprite sheets (each 25 distinct = idle4/walk6/attack6/hit3/death6, 5 empty in 6×5 96px), coherent grip/facing and boots; single combined native F6.
- [ ] Refine current flat-color geometric floor into artistically acceptable **rich authored, character-free** scene matching selected second D261 portrait; current D263 asset remains QA only.
- [ ] Stage game-ready arena + rich original sprites, test full native 54-case Court balance and Battle→Reward→Table, then **release card #39 separately**. Keep ACT1 38/45 and KARAMBA73 unchanged.

## D262 — Court original combat roster and encounter-only red verdict targeting (QA technical PASS)

- [x] Stage **new** `mute_magistrate`, `ash_scrivener`, `bone_bailiff` `UnitData` with four original enemy instances and two formations; no borrowed enemy roles.
- [x] Implement original `verdict_target`: 1.4s conspicuous red warning on one hero, 2.5s focus from both Bailiffs, 3.6s rest; scribe death removes focus. Local controller only; no global AI, stun or guaranteed damage.
- [x] Hook exact Court encounter lifecycle into genuine Battle without exposing #39 in regular card pool; Godot 4.7.2 **6 true Battle startup cases and verdict contract PASS**, D260 38-card 54-case matrix regression PASS.
- [ ] **NEXT: batch-author 3 rich original 25-pose animated pixel-art atlases** `6×5×96px`, 5 alpha blank cells each; unique prop grips and planted feet, proper 1x facing/contact, one combined native F6.
- [ ] Original separate tribunal arena in the exact chosen card world's language: giant scales, ruined bench, walkable stone under units, NO baked unit illustrations; pass actual native art review.
- [ ] Native full 54-case solo/duo/trio×formations balance + Battle→Reward→Table; then explicit #39 activation **39/45**. Until then 38/45 live, original D261 card art and KARAMBA73 frozen.

## D261 — User-approved SECOND Court card art integrated in GitHub, native QA PASS

- [x] User chose **A `Суд безмолвных`**, a new tactical undead tribunal encounter; three original combat enemy types required, no reused costume swaps.
- [x] User explicitly chose **second** of three rendered illustration alternatives; source SHA-256 recorded and exact portrait-derived `448×274` WebP uploaded to GitHub, no repaint or regenerate.
- [x] New QA-only `court_of_the_mute.tres`, `CARD_PATHS` addressable entry, strict chosen-art loader, F6 preview. Godot 4.7.2 WebP integrity/native preview **PASS**.
- [ ] **NEXT D262:** new pixel art/complete animation packs (25 genuinely distinct frames per role) for Magistrate, Scrivener, Bailiff; one combined visual/motion QA, no micro-approvals.
- [ ] Original tribunal combat arena with walkable stone floor and recognizable huge scales. Scoped visibly telegraphed red `verdict_target` mechanics; no stuns, no global target AI changes.
- [ ] Native Godot real 3-party-size/two-formation battle+54-case regression and actual Battle→Reward→Table; only then release #39 to **39/45**, separate commit.
- [x] Keep #38 and Act1 **38/45 LIVE**, DS2/Fate Spread and KARAMBA73 unchanged.

## D261 — HISTORICAL: 3-way concept and pre-art review stage

- [x] Review latest `main`: Act1 **38/45** after released #38; DS2, Fate Spread, original new-enemy D143 and scene-first art D167/D168 rules remain.
- [x] Draft **three distinct next-card directions** in [D261 options](D261_CARD39_CONCEPT_OPTIONS.md): A mute skeletal court with encounter-local marked target; B haunted memorial garden with finite defensive ward; C stranger's epitaph choice event.
- [ ] **NEXT user selects A/B/C** (recommend A); no assumption that `«все ок»` picked a design.
- [ ] Show 3 actually rendered, non-repetitive art options under D168 for selected direction; wait for explicit choice before committing selected source image.
- [ ] Combat A/B requires 3 completely new original enemy roles, full 25-cel animation packets, novel localized mechanic and original arena, native solo/duo/trio balance and real Battle→Reward→Table; event C requires approved actual event choices and normal route validation.
- [ ] Only after all relevant gates release #39 to **39/45**. Until then keep Act1 38/45, no change to KARAMBA73.

## D260 — Card #38 released: Act1 38/45

- [x] Actual Godot 4.7.2 54-case local balance assessment: average remaining HP solo/duo/trio 79.7/69.2/74.6%, 54 wins/zero timeouts, 0/2/4 individual hero deaths, ~13–15s fights.
- [x] Compared previous D153 74/67/74% remaining HP; **accept existing five-enemy UnitData and x1.16 travelling light for initial release**, no generic buff inflation.
- [x] Explicitly add `black_lantern_road` in `ACT1_CARD_IDS`, now **38/45 live**; card art D200/arena D209/original full-five animations intact.
- [x] Official Godot 4.7.2 released Tier1 offer/choose→Battle win→Reward claim→Table PASS; post-release 54-case matrix PASS.
- [x] Provide `res://scenes/dev/black_lantern_d260_released_battle_preview.tscn` for direct user F6 (party/formation).
- [ ] **NEXT D261:** develop card #39 direction with user; D143 new enemies for any combat, 2–3 distinct rendered options before card art change (D168).
- [ ] Fix unrelated `approved_battle_direction.jpg` concept import only after tracing actual references; respond to reproducible visual crop issues from real gameplay. KARAMBA73 immutable.

## D259 — Original five-role production-format staging before card #38 release

- [x] Export source-preserving canonical D257 Guide/Acolyte/Archer 25-cel WebP to runtime `deck_expansion_v1`; cell-wise normalize source facing, validate 25 unique/5 clear per role.
- [x] Register all FIVE in strict shared library, preserving exact Sentinel/Bearer, `BattleUnit` behavior, enemy UnitData and original 37-card pool.
- [x] Fix QA-release card's missing `target_path` to point to original Black Lantern encounter; **not** added to deal pool yet.
- [x] Official Godot 4.7.2 full five-library-real-Battle preflight and 54-case functional regression PASS.
- [x] Correct invalid >4096 `z_index` values in real Battle HUD without changing layout ordering.
- [x] **Real headless Fight→Reward→Table PASS** in Godot 4.7.2: 3v5 win, Continue→Reward→Table/card completion using QA-only frame signal for native transition. User D258 reported no issues; visual critique remains feedback-driven.
- [ ] Make evidence-based local difficulty decision; 54/54 wins alone do not approve balance. Then release card #38 in **separate commit** to 38/45 only when gates pass. KARAMBA73 frozen.

## D258 — All five skeletons in real Battle QA and Godot CI matrix

- [x] Stage all five original rich enemy identities with full 25-pose atlases in isolated D258 real-AI 3v5 and genuine Battle launcher; correct left-origin Guide/Archer QA facing in memory only.
- [x] Godot 4.7.2 native headless source/scene smoke and **actual Battle preflight PASS** (eight BattleUnits, D253 light, two authored formations available, three D257 packs injected).
- [x] Rerun existing **54/54 real BattleUnit matrix functional PASS**: zero party defeats/timeouts, 18 wins per party size and class. Balance acceptance **OPEN**.
- [ ] **NEXT** real local F6 Fight→Reward→Table (trio/Перекрёсток, then solo/duo/Марш) plus original ×1 movement, prop/floor/HUD and lanternlight visual QA.
- [ ] Correct artistic, HUD or encounter difficulty issues from real game, run release smoke, register remaining three roles globally **only when complete**, then consider #38 38/45.
- [x] Preserve 37/45 live, original D244/D224 sprites and frozen KARAMBA73.

## D257 — Three complete character atlas repair candidates and one native art gate

- [x] Restore cross-cell pixels with a source-aware author for all three approved D255 silhouettes; stage three lossless 25-frame **QA-only** atlases via successful GitHub Actions.
- [x] Verify 75 distinct frames, 15 truly blank slots, 2px alpha margins and report 9/10/8 reconstructed source components. Apply local lower-edge contour trial; **11 original lower-cut source flags remain reviewable**.
- [x] Provide ONE combined D257 Godot gallery for all three roles, all states, both facings, and native ×1 scale.
- [ ] **NEXT** F6 visual art/motion review and repair defects, particularly sole contact and prop continuity; technical QC is not artistic sign-off. Only stage all three in real 3v5 upon acceptance.
- [ ] Actual D254 Battle→Reward→Table with solo/duo/trio and both formations; normalized 54-case balance matrix, crowding fix as needed; release #38 only after all gates. **Live pool remains 37/45**.

Updated: 2026-10-19 (D260 #38 released 38/45, release route and balance CI PASS; next D261).

## D256 — Current new-chat restart checkpoint

- [x] Archive complete D255 source files, 75 unique candidate sprites, per-frame QA report and F6 triple-character preview in GitHub.
- [x] Consolidate exact continuation and risks in `docs/D256_NEW_CHAT_HANDOFF.md`; align NEXT_CHAT_HANDOFF/INDEX/HANDOFF/PROJECT_STATE.
- [ ] **NEXT** correct D255 source-edge **12 Guide / 13 Acolyte / 9 Archer** frame warnings at original pose/prop level, verify 75 natural motions and true original rich silhouette. Only then one combined Godot F6.
- [ ] Register all three after actual artistic acceptance; native #38 real Battle→Reward→Table, normalized 54-case balance and release smoke. Until then ACT1 **37/45**, checkpoint frozen.

## D255 — Three complete character-art candidates in one batch; source cropping art gate

- [x] User positively received new visual direction for original Guide/Oil Acolyte/Archer; archive their three transparent full 25-pose illustrated sheets, distinct original silhouettes.
- [x] Reproducibly pack **three complete 25-frame** sets at fixed source scale into 576×480 RGBA lossless WebP, 75 unique/15 genuinely empty, inset margins correct, verify visible-pixel round-trip. One combined x1/x2.1 five-state left/right Godot QA preview created.
- [ ] Repair known **12/13/9 source-cell edge-overflows** (Guide/Oil/Archer) that sever airborne lamps/chain fire/cloth; inspect true motion quality internally. No provisional style regression or code-only fake uniqueness.
- [ ] After a clean full-batch art pass, one user-native combined F6 and real 3v5. Stage remaining three roles globally only if art approved; D254 real Battle→Reward→Table, 54-case balance and 38/45 card release still gated.
- [ ] Keep 37/45 released cards and KARAMBA73 unchanged.

## D254 — Original #38 real Battle QA route and party variation

- [x] Add `black_lantern_road` **ONLY** to RunState CARD_PATHS so a test session may resolve it; leave 37 ACT1_CARD_IDS exactly unchanged.
- [x] Add standalone F6 launcher for real Battle with solo/duo/trio and both authored formations. Temporary Guide/Acolyte/Archer 25-frame original QA art is injected per instance, Sentinel and Bearer use staged rich art.
- [ ] Native user F6 `scenes/dev/black_lantern_d254_real_battle_route_qa.tscn`: verify real Battle intro/tactics/lantern boost, win→Reward→Table, no engine errors. This is a technical route check, not final art approval.
- [ ] Full original clean rich Guide 25 cels, Oil Acolyte and Archer, then normalized 54-case balance/native final visual pass and #38 public 38/45 smoke. KARAMBA73 frozen.

## D253 — Dormant real Battle lanternlight hook for #38

- [x] Reuse D206 scoped light in normal Battle ONLY for exact original five-enemy `black_lantern_road` roster. Configure after normal units, start after Fight/intro, stop + restore on either battle result.
- [x] Preserve all other encounters, original battle data, D244/D224 staged art, live pool 37/45, KARAMBA73.
- [x] Local D251 matte cleanup test internally rejected as insufficient to fix compressed chain-attack motion and scale. No invalid art shipped.
- [ ] Rich original 25 whole posed frames for rigid triple-chain-lantern yoke Guide, then Acolyte and Archer, all with internal art QA.
- [ ] Godot-native actual #38 Battle→Reward→Table and 54-case party/formation matrix under released balance AFTER art is complete; release #38 only then.

## D252 — Native two-formation 3v5 visual-smoke gate closed

- [x] D251 user video: **ПЕРЕКРЁСТОК** native 3v5 ends win at 9.7 sec, all 3 heroes, 0 enemies; **МАРШ** native 3v5 also wins at 9.7 sec, 3/3 heroes. Actual button switches, not just restart.
- [x] New enemy-name OFF default improves crowded combat; changing to ON itself not tested. Scoped lantern light active and rest states with live enemy buff counter are visibly working.
- [ ] Original rich 25-pose **rigid triple-lamp shoulder-yoke Guide**: D251 extraction is an internally rejected art/motion reference, D218 tech actor still large and flat. Do not register as finished until genuinely clean consistent frame-by-frame art.
- [ ] Oil Acolyte and Lantern Archer rich character packs, crowded hero label/HP readability adjustments, then NORMAL #38 Battle→Reward→Table + solo/duo/trio 54-case matrix. Both current isolated 3v5 wins at 9.7s/3 heroes surviving should prompt difficulty review only in normalized final QA.
- [ ] #38 release to 38/45 only after full five-role art and live encounter QA; KARAMBA73 unchanged.

## D251 — Guide paint and encounter readability (not yet production-ready)

- [x] New detailed original Guide silhouette shows correct rigid shoulder yoke with three amber chain lamps, preserves Style B materials rather than copying a shield soldier.
- [x] Reproducibly pack 25 distinct transparent 96×96 native cels from 1536×1024 concept illustration; alpha margin, unique hashes, WebP round-trip structural PASS; **reject** as final due hairline cutout and distorting extreme chain attacks/falls.
- [x] D249 isolated 3v5: name labels hidden by default for enemy crowd readability, optional toggle; formation switch now explicitly shows destination → ПЕРЕКРЁСТОК / ← МАРШ.
- [ ] Rich original clean transparent per-pose Guide repaint correcting attack body/lamps and corpse consistency; one full 25-frame native F6 ONLY when internally ready. Do not weaken checks or force D251 through.
- [ ] F6 D249 improved QA and actual second ПЕРЕКРЁСТОК formation; then remaining rich Acolyte/Archer, true Battle→Reward→Table, 54 cases and pool 38/45. Live 37/45 KARAMBA73 frozen.

## D250 — User's first authentic D249 3v5 recording: one formation passes

- [x] D249 first real Godot video shows MARШ 3 heroes vs 5 original enemies on D209, real AI movement, 5→0 enemies, 3 heroes survive first ~9.6s, visible damage/attack counters.
- [x] Scoped light warning/active phases and live `усилено скелетов 1` counter, manual light off; restart observed.
- [ ] Confirm `ПЕРЕКРЁСТОК` second deployment on a future test. Recorded second run **also says МАРШ**, so do not mark the two-formation gate closed.
- [ ] Replace the large flat/geometric obstructive Guide D218 with full rich B-style **25 unique poses** depicting a rigid yoke and exactly three separately chained amber lanterns. Tight battle HUD labels and overlaps also need composition QA.
- [ ] Original rich Oil Acolyte/Archer; final 3v5 native both formation passes, true balance/matrix and production Battle→Reward→Table release gates before 38/45.

## D249 — Complete five-role REAL combat composition without premature card release

- [x] User D248 Guide native 1v1 technical no-blocker. D218 NOT rich final art.
- [x] Reject three exploratory Guide image sheets that lost rigid iron shoulder yoke/three lanterns or proper 25-cel sprite source. No accidental import.
- [x] Isolated D249 real 3v5 BattleUnit encounter with three real heroes, five original enemies, two formation options, scoped D206 light speed buff and strict temporary original art (D218/D217/D219) only for incomplete three roles.
- [ ] One F6 scene res://scenes/dev/black_lantern_d249_five_enemy_combat_qa.tscn: inspect all 8 sprites, two formations, floor contact and light cycles; report concrete errors for fix.
- [ ] Rich original Style B 25 poses with rigid yoke and three chain-hung lanterns Guide; then Oil Acolyte and Archer. Only after true art acceptance integrate full #38 Battle/Reward/Table, rerun 54-case matrix and release 38/45. KARAMBA73 frozen.

## D248 — Bearer accepted-to-proceed; original rich Guide 25-frame art required

- [x] User replied `«все ок»` after real D247 Bearer-vs-Knight Godot duel.
- [x] Canonical D224 Bearer atlas staged byte-exact beside D244 Sentinel; shared strict library registers only these two original B-style #38 roles, no card release.
- [x] QA-only D248 `black_lantern_guide_d248_combat_preview.tscn` real BattleUnit Guide-vs-Knight motion probe with temporary **simplified** original 25-pose D218 source; both directions/death, HP×3 only, no library role activation.
- [ ] Author new truly rich B-style **25 wholly posed** tall Guide, distinctive *three separate chain-hung lamps from iron yoke*; internally QA all actions before ONE user-native full-pack F6; never replace with new Bearer/shield clone.
- [ ] Rich Oil Acolyte & Lantern Archer full-25 art; genuine #38 3v5 with moving pools/light, deterministic matrix, reward/table and 38-card smoke/release only after full approval. 37/45 LIVE, KARAMBA73 frozen.

## D247 — Sentinel staged, next Bearer real combat check

- [x] User reports D246 real one-Sentinel movement **«вроде все ок»**, provisionally acceptable; no asserted video/exhaustive art PASS.
- [x] Copy *exact D244 git blob* into staged `road_sentinel_frames.webp.b64` (D229 archive preserved), update regression gallery and animation-library notes; #38 still not in pool.
- [x] Create one Knight vs D224 Lantern Bearer real AI preview (25 different original frames, HP-only ×3, reverse side and death buttons) on approved D209; no generic fallback or global Bearer registration.
- [ ] ONE **native F6** for `scenes/dev/black_lantern_bearer_d247_combat_preview.tscn`; accept or repair known potential D224 shield/cape cut, floor contact, hand-held lantern, flip and collapse.
- [ ] After Bearer, new original 25-frame complete packs for Guide, Oil Acolyte and Lantern Archer; then 5-role 3v5, light, balance, real battle/reward/table and full #38 release QA. Live **37/45**, KARAMBA73 frozen.

## D246 — Single Sentinel D244 real BattleUnit movement QA

- [x] Add isolated real AI **one Sentinel vs one Knight** D209 forest fight, unaltered movement, aiming, real hit/death feedback. D244 frames apply to only a QA BattleUnit instance (no global role cache).
- [x] Include restart, swapped-side attack direction and explicit death controls. Only HP ×3 locally to lengthen observation; check #38 stays outside 37-card live pool.
- [ ] **User-native F6:** run `res://scenes/dev/black_lantern_sentinel_d246_combat_preview.tscn`, observe actual walk floor contact, left/right automatic facing and attacks; send one short recording or defect list. Do not claim PASS until native test.
- [ ] Final D244 art verdict, four other unique characters, full 3v5/light/balance/reward and release gates; existing 37/45 and KARAMBA73 untouched.

## D245 — One complete D244 native video review (real Godot)

- [x] Reviewed user's actual 21.38s Godot D244 recording; 5 animations and both facings shown, ×3 and ×1 on D209 forest; gallery loads and plays, native review gate **completed**.
- [x] Confirmed spear extends nearly horizontally at ATTACK contact in both facings; DEATH buckles/falls to visible armored floor corpse rather than rotated/smeared poster; held lantern stays with actor.
- [ ] **One overall subjective D244 art acceptance** (user supplied video without verdict); avoid inventing user approval. Short-lived contact pose and subtle foot weight shift are visual review considerations; do not merely change FPS.
- [ ] After art sign-off, complete remaining four original roles in 25-frame batches, then real #38 3v5, lighting, route/matrix, reward and card-pool release QA. **37/45 LIVE.**

## D244 — Illustrated Sentinel all-25 pack QA

- [x] Generated 25 whole illustrated B-style armored skeleton poses in one complete image (not D243 geometry), preserving held amber lantern and long spear.
- [x] Isolated all 25 source characters via alpha-connected segmentation (prevents source-grid clipping on long thrust), perspectively shortened spear only where necessary to fit fixed 96×96, packed 6×5 lossless WebP/Base64.
- [x] Offline QC: 25 distinct, 5 transparent unused, full character in 2px inset, source-reproducible Python authoring and QC report.
- [x] Created new separate ×1/×3, five-state, left/right Godot F6 gallery using exact D209 forest; **native F6 not yet run**.
- [ ] ONE real full-pack native F6 visual review: leg weight during walk, forward pointed-spear contact, wrist lantern grip, progressive fall/corpse, both facings. Fix any identified flaws before registering.
- [ ] Other four authored role packs, #38 3v5 + localized light mechanic + balance + actual Battle→Reward→Table + 38-card pool smoke. Live still 37/45, checkpoint KARAMBA73 frozen.

## D243 — Technical movement study, NOT yet finished art

- [x] Construct 25 separate per-pose joint silhouettes, including horizontal spear impact and staged physical fall, and verify 25 unique/5 clear/2px/576×480 lossless texture.
- [x] Internally reject D243's visually simplified geometric finish against approved D235 high-detail character. No need for user to test rejected draft.
- [ ] Replace entire study with actual rich B-style painted frames in a ONE-BATCH original 25-cel pack; internal motion/art QA first, only ONE real finished-pack F6 by user.
- [ ] Finish four other original roles and #38 3v5 light/route/reward/balance/release. LIVE 37/45, KARAMBA73 frozen.

## D242 — Native recorded D241 QA fails acting/motion

- [x] Reviewed user's actual 17s MP4 / 16.6s Loom of full D241 QA scene; walk stiff, spear attack not a convincing thrust, death becomes a rotated flattened illustration. Loading PASS is **NOT animation ART PASS**. `docs/D242_SENTINEL_NATIVE_VIDEO_ART_FAIL.md`.
- [ ] **Reauthor complete Sentinel 25 full-body illustrated poses** for walking weight transfer, stab/hand mechanics, hit and collapsing death, preserving approved D235 B style and D234 held lantern. Avoid programmatically assembled body rotations, failed D236 polygon boots and reuse of rejected D239/D241.
- [ ] Internally evaluate new full pack against real shipped D153/D183 motion at x1/x3, stage ONE full Godot F6 scene; no old D241 retest, no per-state user approvals.
- [ ] Only after full art QA tackle other four roles and #38 3v5 light/route/balance/full-pool release gate. Live pool remains 37/45.

## D240/D241 PREVIOUS (ART REJECTED) full-character acceptance gate

- [x] Compared previous released Puppeteer/Marionette/Ferryman full-body animations and traced D239 mismatch to independently drawn polygon boots/greaves and upper/lower compositing; user explicitly **rejected** D239 visuals.
- [x] Re-extracted genuine D235 full-body illustrations with matching armored legs and assembled **one new 25-state D241 QA candidate** with 5 empty cels, static QC and one native F6 scene.
- [ ] One native Godot full-package review of `res://scenes/dev/black_lantern_sentinel_d241_wholebody25_preview.tscn` for feet, weight shift, spear grip/thrust, grounded death. Whole-body source compositing has NOT been approved as final original hand-painted action poses.
- [ ] If still unnatural, **repaint full-body attack/death/movement poses**, not geometric boot grafts or FPS tweaks. Do not register in real Battle until genuine art acceptance. Then other four 25-frame enemies and #38 balance/release QA.

## D239 previous/rejected acceptance gate

- [x] Author/assemble **one complete** 25-cell richly illustrated-source Road Sentinel QA atlas (4/6/6/3/6, 5 clear), and generate source-traced pixel QC in GitHub.
- [x] Stage **one native full-pack F6 gallery** with both facing directions, x1 and x3, approved D209 forest. No per-state user approvals.
- [ ] **Native Godot 4.7 full-pack test and artistic acceptance:** spear thrust/contact, natural knees/corpse pose and real ×1 quality still need user feedback. D239 source-composited is not 25 independently repainted full drawings.
- [ ] Refine whole pack from that single review; complete other four original role packs, then 3v5/light/route/54-case/full-pool QA before #38 release. Preserve existing 37-card pool.

## Completed / locked

- [x] Playable cursed table, exactly 12 Fate Spread resolutions + sealed boss XIII, and tactical battle → reward → table core loop. Solo/duo/trio preserved; DS2 / Variant C visual system accepted.
- [x] #34 D151 Funeral Procession, #35 D152 Defiled Laboratory, #36 D153 Threadbare Theatre all released with distinct enemies, encounter mechanics and scene-led original art. D153 D178 54/54 native balance and D181 native release smoke PASS.
- [x] D182–D187 Black Crossing: accepted card variant 3, Ferryman B/Drowned C atlases and stormy «Последний причал» arena.
- [x] D188–D191 Black Crossing authored 1+2 fight, wave push/slow and D189 safe plank boundaries. **D191 native 54/54 wins**, 0 entire-party defeats.
- [x] D196 storm VFX held as the current visual baseline after user's request; no more wave tuning in this phase.
- [x] D197 user-native preflight and real battle → reward → table confirmed («Все ок»).
- [x] **D198 Black Crossing #37 fully released.** Live 37-card pool, migrated D151–D153/shepherd smoke guards and full-pool random-deal release scene committed. The user replied **«все ок»** to the requested Godot F6 release smoke (user-reported native PASS, no independent log).

## D225 next QA gate — D224 art turning left/right

- [x] **D224 native gallery screenshot received:** correct D209 backdrop, selected Bearer full art visible in x3 and x1, shield-attack pose on screen. This is **NOT** the full five-motion or two-way motion PASS.
- [x] **D225 gallery both-facing controls added** to `scripts/dev/black_lantern_bearer_d224_art_preview.gd`: two buttons `← ВЛЕВО` / `ВПРАВО →` flip both views together and update the current state label. Both views retain nearest filtering; no actual 25-cel image bytes changed.
- [x] **D225 native Godot direction controls user OK:** user replied «все ок. давай дальше» after F6 request; this confirms gallery directional QA at user-report level, not production combat/art.
- [x] **D225 native Godot F6 previously requested (now user-confirmed):** same `res://scenes/dev/black_lantern_bearer_d224_art_preview.tscn`. Check walk / shield attack / fall in BOTH directions. The image's slightly soft details originate from prior 1374→96 pixel repack, not a missing NEAREST setting. Original art refinement later, do NOT silently sharpen user-approved source.
- [ ] Original five-role final polished atlases + combined five-vs-three art review, Battle→Reward→Table and #38 release gates remain.

## D238 CURRENT — produce FULL 25-cel Sentinel animation before next user QA

- [x] **Workflow approved by user**: no more piecemeal idle/walk/attack/death proposals and screenshots; one full game-ready 25-frame delivery per character, one F6 QA when complete. New rule permanently added to `AGENTS.md` / `docs/DECISIONS.md`.
- [x] **New-chat handoff archived:** [`docs/D238_BATCH_ANIMATION_NEXT_CHAT.md`](D238_BATCH_ANIMATION_NEXT_CHAT.md) captures accepted D234/D235/D236R, exact QA asset paths, five-role #38 scope, production status, and immediate one-pack task.
- [ ] **ONE complete rich Road Sentinel atlas:** idle4 + **approved D236R walk6** + original spear-thrust attack6 + hit3 + death6, with 5 unused alpha-clear slots, correct wrist-held D234 lantern, rich D235 outfit, full-scale x1 readability and grounded movement. Rework source frame-by-frame internally until look/motion passes; don't swap in procedural D229 art or fake cropped imagegen animation sheets.
- [ ] **ONE integrated native F6 QA** displaying all five animation states and both directions at x1/x3 on D209; after that, directly fix reported issues and update production art. Do not demand five separate user checkpoints.
- [ ] Repeat complete-25 approach for remaining Lantern Bearer, Oil Acolyte, Extinguished Guide and Lantern Archer; only after the cast, actual #38 combat/lighting/reward/matrix/release. Regular card pool 37/45.

## D237 SUPERSEDED PER-STATE USER GATE — accepted WALK baseline, genuine spear attack six-cel QA

- [x] User replied **«пойдет»** to D236R comparison: corrected gait sufficiently good to move forward. This is a **limited walk visual OK**, not complete final art or integrated battle.
- [x] Supersede D236 unnatural walk; retain D236R original six support/swing WALK frames with accepted D234 lantern grip and approved D235 richer visual direction.
- [ ] **D237 build six genuinely different spear-thrust attack poses** (anticipation/contact/recovery; clear pointed spear, free-hand lantern grip, feet planted), in QA-only resource and ×1/×3 Godot preview, without touching production role until all 25 states finished.
- [ ] Later hit3/death6 and cohesive 25-cel art approval, other four foes, actual #38 battle/light/reward/full pool. Ordinary pool **37/45**.

## D236R prior gait repair — gait fix after user's D236 visual FAIL

- [x] **D236 native visual FAIL:** user «не естествено». Do NOT accept motion based on six unique art hashes. Extreme stride, sudden swapped boots and nearly static torso investigated.
- [x] **D236R gait loop correction staged in main:** alternate 3 contact/weight/push vs 3 opposite-foot stance phases, each frame one planted foot (y91), ≤10px x/y next-step incl wrap, smaller stride, slight body bob while keeping D234 lantern attached; 6 distinct WALK +24 alpha-clear, zero clipped margins. `docs/D236R_SENTINEL_GAIT_REPAIR_QA.md`.
- [x] **D236 vs D236R side-by-side F6:** `res://scenes/dev/black_lantern_sentinel_d236r_gait_compare.tscn` x3/x1 both moving on D209 forest, half-speed control, facing, floor guides.
- [ ] **User-native D236R F6:** verify right-hand gait at actual x1 incl seamless repeat, spear/lantern and soles. **Unconfirmed**. If still unnatural, switch to genuine per-pose illustrated limb animation instead of repeated synthetic limb coordinate polishing.
- [ ] Final richly painted 25 original cels and full #38 release QA. Technical live cards remain **37/45**.

## D236 PREVIOUS / FAILED — real leg-movement proof, need x1 art acceptance

- [x] **Discarded defective D235 poster auto-segmentation:** background brown gradients and spear cropping make naive extract unsuitable, never promote those.
- [x] **D236 true six-phase leg pose motion pilot:** reconstruct from clean D234 handled-lantern upper artwork; hand-defined 6 planted/passing/swing boot/knee poses, 6 distinct cells in walk row1, **24 EMPTY**, no alpha-edge errors. Reproducible GitHub `tools/art/author_road_sentinel_d236_walk6_pilot.py`, art `road_sentinel_d236_walk6_pilot.webp.b64`. `docs/D236_SENTINEL_WALK6_MOTION_PILOT.md`.
- [x] **D236 isolated F6 scene:** `res://scenes/dev/black_lantern_sentinel_d236_walk6_pilot.tscn`; static accepted D209, D234 4-IDLE left vs D236 6-WALK right, x3/x1/facing/pause, structural validators.
- [ ] **USER Godot F6:** confirm feet walk (not slide/floating), correct wrist-lantern, leg art at x1; **NOT native-PASS** until user response. Six poses use reused upper D234 illustrations and drawn legs, NOT fully artist-painted six rich whole bodies, so final D235 fidelity is not automatically accepted.
- [ ] Polish motion/character frame quality before attempting next actual attack6, hit3, death6 and final 25 + five other skeletons/release #38; live pool 37/45.

## D235 PREVIOUS — six-walk Sentinel Style-B visual approved, production cells next

- [x] **D234 grip art direction accepted** by user: wrist-mounted amber lantern visibly HELD, no floating prop. Previous D233 rejected.
- [x] **D235 visual approval** («принято»): rich six-character 3×2 walking illustration, real long SPEAR, layered armor, burgundy hood, hand-held lamp. Original image source SHA `9fa8e48baed60364411e13e2a58d1549e052bbdc250c26b37933d2081442b181`, high-quality full-resolution WebP reference now **committed** under `assets/pixel/units/black_lantern_road_qa/road_sentinel_d235_approved_walk_concept_q95.webp.b64`. `docs/D235_SENTINEL_WALK_ART_APPROVAL.md`.
- [ ] **D235 original six walk cels at true 96px alpha:** draw six physically distinct legs/sole/planted passing poses, consistent lantern wrist grip + spear, protect rich look at x1. Original generated 3×2 poster has gradient backdrop; not a packable animation sheet.
- [ ] Isolated F6 native walk motion/feet/hand x1 on **D209** then remaining attack6, hit3, death6 genuinely authored. Do NOT switch released battle sprite library or card #38 before full art, battle and release QA.
- [x] D229 remains only staged technical alpha atlas; normal pool **37/45**.

## D234 PREVIOUS — fix art continuity BEFORE adding more animations

- [x] **D233 visual issue confirmed by user**: lantern near knee appears detached from free hand; D233 is **REJECTED** as an animation method acceptance.
- [x] **D234 source fix committed**: relocate same rich illustrated lantern to gauntlet, visible short forged hanger + wrist overlap and strictly pivot-linked tiny sway across 4 idle; vacated image region patched with source burgundy-cloak texture. `docs/D234_SENTINEL_HAND_LANTERN_ATTACHMENT_QA.md`.
- [x] **D234 side-by-side Godot F6 scene** `res://scenes/dev/black_lantern_sentinel_d234_hand_lantern_compare.tscn`: left BAD D233/right fixed D234, both x3/x1 and facing controls on exact D209. Static QC 4 unique, 26 blank, no border hits; **not 25 real frames**.
- [ ] **User-native D234 visual check**: at ×1 confirm free hand/handle truly reads as joined and patch isn't an obvious flat panel in all four phases. Only then continue actual separate poses walk6/attack6/hit3/death6. Godot native PASS not yet received.
- [ ] Final illustrated 25-pose quality, four other unique enemies and real battle→reward/light/balance release are still pending. Actual 37-card pool unchanged.

## D233 PREVIOUS — validate real rich-art idle motion before 25-frame commitment

- [x] **D233 idle-only motion proof** from D232 rich transparent figure, reproducible repo-relative painter `tools/art/author_road_sentinel_d233_idle_proof.py`: original body preserved, independent lantern and cloak tip movement, warm flicker. 4 actual distinct alpha cels + 26 clear, zero border faults. **Cutout animation from ONE illustrated pose; not hand-drawn four distinct full character stances or 25 finished cells.** `docs/D233_SENTINEL_IDLE_CUTOUT_PROOF.md`.
- [x] **Dedicated D233 Godot F6 preview** `res://scenes/dev/black_lantern_sentinel_d233_idle_cutout_proof.tscn`, left D232 single still/right 4-frame idle moving, both x3/x1 on approved D209 forest, pause and both orientations, strict 4+26 cell QA.
- [ ] **Native F6 and user method/art feedback:** judge if frame motion preserves lantern and cloak quality at x1; D232 look quality not yet explicitly user-approved.
- [ ] **Then 21 additional different original character poses** (walk6, attack6, hit3, death6) as true art, not 21 copies/tweens of idle. Real full 25-cel QA and battle only after quality success.
- [x] Current staged technical D229 production loader and normal 37-card pool remain untouched.

## D232 PREVIOUS — ONE art-quality check before authentic 25-cel animation

- [x] **D232 one alpha-cleared high-detail original-looking spear guard sample**: correctly shaped long spear, ornate iron armor, separate hand lantern and oxblood cape. Extracted from **one** generated pixel illustration pose and scaled to exactly 96×96 with NEAREST; **NOT native pixel-painted and NOT a valid 25-cel animation sheet**. Original cutout saved as lossless WebP/B64; alpha safe (9,5)–(86,93).
- [x] **D232 actual x1/x3 comparison scene:** `res://scenes/dev/black_lantern_sentinel_d232_art_direction_preview.tscn`, D229 old LEFT vs new static candidate RIGHT, five-state playback INTENTIONALLY ABSENT, correct D209 forest.
- [ ] **D232 real user visual/art direction acceptance:** examine x1 on Godot; only after acceptance work on original 25 true poses. Native Godot not run here.
- [ ] **D232 25-frame production (future):** recreate high-fidelity style in true state cels/alpha/bounds, protect spear and lantern, then real 3v5/battle/reward/light/54-case checks. Do not re-register single still as BattleUnit animation.
- [x] D229 production-stage 25-cel atlas and #38 pool intentionally unchanged; **37/45** live.

## D231 PREVIOUS — restore promised rich Sentinel visual bar; D230 final-art flag REOPENED

- [x] **Diagnosed visual regression / expectation mismatch:** original 1254×1254 illustrated `пиксельный_атлас_скелета_стража.png` has elaborate armor, cloak and lantern but an incorrect **AXE**, 5×5 generated poses; accepted D221 spear concept is rich but includes baked background. Both differ substantially from plain procedural D229 6×5×96px code-generated atlas. D230's claim of final quality was misleading. `docs/D231_SENTINEL_ART_FIDELITY_CORRECTION.md`.
- [x] **D229 SECOND vs FIRST D228 choice retained AS TECHNICAL SHORTLIST** (not final aesthetic quality waiver); D230 role registration currently exists only for unreleased encounter #38.
- [ ] **Proper high-fidelity original game sprites:** produce a single REAL game-scale crisp spear Sentinel matching accepted D221 richness for renewed art approval before painting all 25 poses; no more slight noisy Python shape bumps. If current 96px fidelity is insufficient, obtain user input before changing asset budget/format.
- [ ] **Full 25-pose release-ready Sentinel atlas**, 5 other state roles each complete, combined battle QA. No releasing original AXE art or procedural D229 as visually final. Live Act1 37/45.

## D230 PREVIOUS / SUPERSEDED FINAL-ART CLAIM — Road Sentinel final art DONE; proceed to remaining four enemies

- [x] **User formally chose option TWO / RIGHT D229 as final Road Sentinel** («давай примем 2 вариант и уже закончим с этим»). Never restart pixel-polish passes or ask again between D228/D229. Final art bytes exactly equal approved D229 source. `docs/D230_ROAD_SENTINEL_FINAL_APPROVAL.md`.
- [x] **D230 role-specific production atlas and library registration:** `assets/pixel/units/deck_expansion_v1/road_sentinel_frames.webp.b64`, `MisdealUnitAnimationLibrary.get_frames("road_sentinel")` strict 25 genuine frames/5 empty, `BattleUnit` authored-left orientation correct. Card #38 still QA-only.
- [x] **D230 isolated production-loader F6 smoke staged:** `res://scenes/dev/black_lantern_sentinel_d230_approved_smoke.tscn` compares selected art with actual animation library output at x1/x3 and both directions; does not re-open art approval.
- [ ] **D230 engine-native smoke (may bundle with combined QA):** Godot F6 not yet user-confirmed. Errors should prompt code fixes only, not aesthetic reconsideration.
- [ ] **Next art role:** Lantern Bearer source-approved D224 shield + free-hand lantern; complete its accepted final frame quality as needed; after that original Oil Acolyte, 1.8× Extinguished Guide, Lantern Archer. Then collective 3-vs-5 forest, real #38 battle/light/reward/matrix and release, 37→38 cards only after PASS.

## D229 PREVIOUS / SUPERSEDED artistic comparison — compare actual x1 before another repaint

- [x] **D229 original native 96px art experiment**: real large chest/pauldron facets, richer hood, improved real-spear blade edge, preserves all 25 moving states + 5 fully empty with 0 border violations. Old D228 art unchanged. `docs/D229_SENTINEL_NATIVE_SCALE_AB_REVIEW.md`.
- [x] **D229 A/B Godot F6 comparison scene**: `res://scenes/dev/black_lantern_sentinel_d229_compare.tscn`, D228 left and D229 right, both x3/x1, common animation state + direction controls, exact chosen D209 forest.
- [ ] **USER native F6 and aesthetic result**: compare A/B especially ×1; D228 native F6 was NOT separately accepted just because user asked to continue. Check walk/attack/death and left/right. No assumed PASS.
- [ ] **Final Sprite art fidelity:** x1 differences remain subtle; consider higher-quality silhouette composition at same 96px, *not* endless micro-polish, before agreeing to production sprite. Then remaining original four enemy final passes, combined battle and #38 real release.

## D228 previous QA gate — style-B Sentinel art fidelity

- [x] **D228 native sprite repaint shipped to QA branch of main:** detailed 96px original armor shapes, frayed burgundy cloak, upgraded genuine spear head and bindings, lantern metal cage. 25 different physical animation cels/5 empty/zero alpha border violations, correct 6×5 row-per-state. D227 preserved for visual comparison. `docs/D228_SENTINEL_ORNAMENTAL_PIXEL_ART_QA.md`.
- [x] **Isolated D228 F6 Godot gallery added:** `res://scenes/dev/black_lantern_sentinel_d228_art_preview.tscn` x3/x1, left/right, all five state buttons, approved D209 backdrop.
- [ ] **D228 native user art/animation QA:** verify appearance at x1, full spear thrust, lantern/cape staying attached through walking and collapse, both directions. No actual F6 PASS as of this commit. Polished accepted D221 visual target remains a hard gate.
- [ ] **Before live release:** final-art quality for all five enemies, integrated real #38 Battle→Reward→Table/light and full-pool/matrix smoke; ordinary pool stays 37/45.

## D227 previous native art QA gate — original painted Sentinel 96px

- [x] **D227 25-frame pixel art pass committed**: true native-resolution geometry (armor, skull, cloth, spear, lamp and greaves), alpha-safe original frames `idle4/walk6/attack6/hit3/death6`, five transparent cells, 25 unique, zero border touches. Original D226 QA untouched; **full D221 visual fidelity still not claimed**. `docs/D227_SENTINEL_PIXEL_FIDELITY_QA.md`.
- [x] **D227 F6 scene committed** `res://scenes/dev/black_lantern_sentinel_d227_art_preview.tscn` with x3 / x1 and LEFT/RIGHT, on accepted D209 forest.
- [ ] **D227 user Godot QA and art decision:** check walking soles, exact spear thrust, arm/lantern placement, final grounded collapse in both orientations; compare D226 vs D227. **Native PASS not yet received**.
- [ ] Full polished five-role artwork, real integrated #38 battle, reward route/matrix and 38/45 release checks all pending. Old released pool stays 37/45.

## D226 previous gate — painted Road Sentinel

- [x] **D226 richer original 25-cel spear Sentinel candidate:** deterministic native 96px drawn art in approved armored A silhouette/B palette with torn russet hood and copper-iron wear; 25 unique + 5 transparent, zero edge warnings, original pointed spear/amber lamp. **Not the final D221 fine-detail quality yet.**
- [x] **D226 isolated Godot F6 gallery:** original D209 moonlit forest, 3× and 1× frames, left/right direction switches, five states, strict validators. Source/asset/QA documented in `docs/D226_SENTINEL_STYLE_B_ART_QA.md`.
- [x] **D226 screenshot: native loading and leftward walk visible** — user showed x3 + x1 gallery on D209 background with no red QA error. This is **partial evidence only**, not all five motion states and left/right toggles tested.
- [ ] **D226 art fidelity / D227 native 96px repaint:** skull, plate volume, rusty metal clusters, spear head, lantern shape and burgundy mantle still visibly simpler than user-approved D221 illustration. Preserve 25 authored poses; not permitted to call D226 a final art PASS based solely on rendered gallery.
- [ ] **D226 full five-state/direction user-native visual review:** `res://scenes/dev/black_lantern_sentinel_d226_art_preview.tscn`, confirm direction, leg contact, real spear thrust, visible lantern at 1×, death; assess against D221 accepted detailed illustration. No live sprite swap until approved.
- [ ] **Full five-hero original art completion + real #38 battle/reward/table/release smoke** remains outstanding; live 37/45.

## D209/D210 status

- [x] **D209 native arena art visual PASS** — user F6 screenshot and «все ок» on selected third black-forest art, 3 hero + 5 enemy proxies and moving pools; this confirms layout only, not final character art.
- [x] **D210 art preflight** — five source 5×5 sheets and remapped 6×5 candidates visually audited; 13/20/24/21/13 boundary-contact warnings, Sentinel axe vs approved spear. Five atlas approval gates still **BLOCKED**. See `docs/D210_BLACK_LANTERN_ANIMATION_ART_QA.md`.
- [x] **D211 Sentinel option A approved** by user («а»): armored long-spear silhouette with small lantern. No authentic production atlas yet. `docs/D211_ROAD_SENTINEL_SPEAR_CONCEPT_OPTIONS.md`.
- [x] **D213 canonical animation master brief committed:** fixes prior chat D212/D213 row-major mismatch. All five Godot atlases MUST be row-per-state: idle(4), walk(6), attack(6), hit(3), death(6); 5 transparent surplus cells. `docs/D213_BLACK_LANTERN_MASTER_ANIMATION_BRIEF.md`.
- [x] **D214 Bearer production specification committed:** 25 explicit pose directions, heavy lantern + wooden defensive plank, real pixel/foot/alpha gates; purely ART specifications, no real atlas. `docs/D214_LANTERN_BEARER_PRODUCTION_SPEC.md`.
- [x] **D215 first original Road Sentinel QA atlas produced and committed:** handmade pose-specific 25 frames, 6×5 correct rows, transparent WebP/B64, no border spills, isolated native gallery F6; 3× and 1× on D209. **User art approval and native F6 PENDING; QA-only, not enabled in gameplay.** `docs/D215_SENTINEL_NATIVE_ANIMATION_QA.md`.
- [ ] Produce/review FIVE **genuinely authored** idle/walk/attack/hit/death 96px transparent atlases. Begin with Sentinel's correct spear; retain prior selected arena and card illustration.
- [x] **D215 Road Sentinel native F6 OK** — user replied «все ок продолжай дальше» after five-state standalone gallery check. QA candidate is acceptable for next art step; still not registered as live sprite or in battle.
- [x] **D216 Lantern Bearer original 25-frame QA asset staged:** shield-first melee, separately held amber lamp, walk/hit/death (576x480 WebP/B64, 25 distinct poses, 5 blank, zero border flags). Authored Python source + QA-only Godot gallery committed. `docs/D216_LANTERN_BEARER_ANIMATION_QA.md`.
- [x] **D217 Oil Acolyte QA source/gallery staged:** genuine third role with original flask+curved sickle+small belt-lamp identities. Local independent 25-pose PNG/WebP raster passed offline alpha QC; GitHub hosts a **separate 25-state original SVG QA** plus native `load_svg_from_buffer` F6 scene. Neither is production library art. `docs/D217_OIL_ACOLYTE_ANIMATION_QA.md`.
- [x] **D217 error diagnosis + source fix:** user Godot F6 screenshot flagged death row4 cells4/5; deleted only two offending low rib strokes from editable SVG, commit `a8a80f1`. QA checks remain strict, no gameplay/source substitution; native retest required.
- [x] **D217 native Oil Acolyte F6 retest user-reported PASS:** user replied «все ок» after the exact post-hotfix F6 request; removed border errors from death row4 col4/5, without loosening QA. No video or full-flow battle acceptance.
- [x] **D218 Guide QA atlas and F6 gallery source committed:** 25 original 96px cels, 5 unused transparent, no offline border contact; large leader silhouette with 3 chained lamps, 1.8x beside 1x Bearer on accepted D209 art. Full: `docs/D218_EXTINGUISHED_GUIDE_ANIMATION_QA.md`. **Godot F6 still pending**.
- [ ] **D218 native Guide F6:** `res://scenes/dev/black_lantern_guide_animation_preview.tscn`, inspect size ratio, feet, light chains, five motions, final corpse.
- [x] **D219 isolated Lantern Archer F6 positive user report** — user replied «все ок» after the D219 gallery test; technical preview only, NOT polished production-art approval.
- [x] **D220 explicit user-facing final-art requirement documented** — all FIVE QA-simplified sprites must be fully repainted into approved Misdeal dark-fantasy pixel art and reviewed together on D209 at real scale before production registration and #38 release. See `docs/D220_BLACK_LANTERN_FINAL_SPRITE_REPLACEMENT_GATE.md`.
- [x] **D221 Sentinel final appearance chosen** — user accepted detailed heavy-armored long-spear Sentinel illustration in selected collective style B («отлично»). Design approval only; composite is not transparent 25-cel game art. `docs/D221_SENTINEL_FINAL_STYLE_APPROVAL.md`.
- [x] **D222 Bearer concept quality review:** three B-style illustration panels generated but all had **unapproved long staff + lantern on shield** rather than a separate hand lantern, so REJECTED in art QA; do not use as assets. `docs/D222_LANTERN_BEARER_FINAL_ART_REVIEW.md`.
- [x] **D223 corrected Bearer visual concept illustrated:** 388×386 character-only crop with broad wood barricade and **separate hand-held lantern**, no pole, style B; conversation asset (not in-game art). User artistic approval **PENDING**. `docs/D223_LANTERN_BEARER_CORRECTED_CONCEPT.md`.
- [x] **D223 Lantern Bearer appearance approved** («да все ок»), shield one hand and separate lantern other; no spear.
- [x] **D224 Bearer 25-pose art sheet approved** («подходит»): exact RGBA source converted to visibly-lossless WebP/B64 in GitHub, 25-cel 576×480 repack + reproducible author and machine-readable QC, strict isolated F6 scene; no live sprite switch. `docs/D224_LANTERN_BEARER_APPROVED_ART_QA.md`.
- [ ] **D224 user-native F6:** `res://scenes/dev/black_lantern_bearer_d224_art_preview.tscn`; check 5 animations at 3× and 1× for any missing pixels at seam, feet/lantern/shield movement, final corpse; only then production art readiness.
- [x] **D223 Lantern Bearer specific visual acceptance** — user confirms D223 or requests edits, then real full-quality 25-cel animated original sprite in correctly packed rows.
- [ ] **D222 Lantern Bearer corrected standalone character appearance** — shield plus separate HANDHELD lantern, absolutely no staff/spear or composite fake 25-frame sheet; show to user before true final atlas.
- [ ] **D221 Lantern Bearer appearance** — present in same B art direction with broad wooden defensive barrier and heavy hand lantern, obtain user look approval before 25-cel art.
- [ ] **D220 actual FIVE final atlases:** original repaint, not upscale/recolor. Art options → explicit approval → native gallery/combined scene → integrate battle→reward→table → release smoke.
- [x] **D219 final Lantern Archer QA-only atlas produced:** new original 25-frame archer bow, quiver and lantern, with proper bow draw and user-native gallery before battle.
- [ ] **D216 five-state art approval** — gallery **renders** (user screenshot shows 3×/1× and shield attack, no QA FAIL); idle/walk/hit/death motion not yet separately confirmed. Scene: `res://scenes/dev/black_lantern_bearer_animation_preview.tscn`, check stance/foot contact, shield attack and final collapse on approved D209 arena.
- [ ] After sprite approval: Godot animation F6, actual #38 five-enemy battle with encounter-only light, then real reward→table and release smoke before Act1 **38/45**.

## D219 — fifth original role, art integration/release still gated

- [x] D218 triple-lantern Guide standalone preview: user replied **«отлично»** after native F6 request. Positive user feedback; no independently supplied new screenshot/log, nor real battle validation.
- [x] D219 original Lantern Archer 25-pose alpha WebP/B64 and editable Pillow art source created and committed: curled bow, quiver, amber lamp, intentional draw→loose→recover; **25 distinct / 5 empty / 0 border flags** offline, GitHub content verified; native F6 pending.
- [ ] **D219 native F6:** `res://scenes/dev/black_lantern_archer_animation_preview.tscn`. Judge 3×/1× bowstring, arrow leftward, alternating feet, grounded death and health/HUD room on accepted forest.
- [ ] Joint animation-scale/orientation QA for all five roles on D209; D216 Bearer complete five-motion user check if needed.
- [ ] Only after art/native QA: register five distinct original enemy roles in animation library for **QA-only** real `black_lantern_road` encounter, wire moving light, verify real Battle→Reward→Table; 54-case regression and full-pool release smoke before live card #38/45.
- [ ] Preserve `backups/KARAMBA73-2026-10-16`, live 37-card deck and accepted older encounters.

## Next (strict order)

1. [x] **D199:** #38 `black_lantern_road` approved design — five original skeletal roles, 2×-height Guide, travelling light; no live enemy assets or gameplay.
2. [x] **D200:** exact third card illustration installed QA-only, user-native art review previously reported OK. Keep it unchanged.
3. [x] **D204 → D205 arena selection:** user chose geography **A dead forest bend** and then **third of three finished forest backdrops**, exact source `лунная_дорога_через_туманный_лес.png` (1672×941); image is conversation-only, not yet Godot scene or GitHub assets.
4. [x] **D205 tech staging:** convert five previously generated 5×5 source concept atlases into 6×5 96px **review-only** candidates (25 nonempty unique frames per role). Edge-cropped source poses and Sentinel spear/axe mismatch **BLOCK art sign-off**; never enable them as live animations. Stager and QC spec documented.
5. [x] **D206 QA-only encounter and scoped effect source:** five unique UnitData, 2 five-enemy formations and isolated +16% enemy-only travelling-lantern buff/reset logic; *not wired into a playable battle, no native QA yet*. See `docs/D206_BLACK_LANTERN_ENCOUNTER_STAGING.md`.
6. [x] **D206 Godot native contract PASS:** user screenshot confirms 5 original UnitData, two formations, enemy-only lantern buffs/reset after the typed-array fix. This is NOT actual combat QA.
7. [x] **D207 54-case real-combat matrix written QA-only:** `res://scenes/dev/black_lantern_road_battle_matrix.tscn`; uses original UnitData, BattleUnit AI, deterministic scoped light, 2 formations × 3 classes × 3 party sizes × 3 orders. No art switching/live card inclusion.
8. [x] **D207 native F6 matrix 54/54 functional PASS** (user screenshot): 0 defeats/timeouts, avg HP solo/duo/trio 80/70/74%, worst 52/30/44%, light buff observed; **balance not yet approved**. Baseline: `docs/D208_BLACK_LANTERN_BALANCE_PASS.md`.
9. [x] **D208 narrow candidate staged:** increase the #38 *lit-enemy-only* speed modifier 1.16 → 1.22; no generic enemy stat changes. Add actual light-buffed enemy attack counting to deterministic matrix.
10. [x] **D208 native F6 rerun PASS:** 54 wins, no defeat/timeout, HP and duration unchanged to display precision; 59 of 635 enemy attacks accelerated (9.3%). +22% bonus reverted to already-tested +16% in `cc624e3`. Keep actual-attack instrumentation; **do not call balance approved**. Full comparison: `docs/D208_BLACK_LANTERN_BALANCE_PASS.md`.
11. [ ] **D205 native light-cue F6:** run `res://scenes/dev/black_lantern_road_light_preview.tscn`, verify clear moving circles / warning / five enemy proxies and pause. It is explicitly not battle code.
12. [x] **D209 exact forest arena committed:** selected third source re-exported as 1280×720 WebP/Base64; GitHub stored SHA exactly matches local export. Existing authored-backdrop now supports `black_lantern_road`, other arenas unchanged.
13. [x] **D209 native visual F6 PASS** — user screenshot confirms approved original forest background, 3 hero and 5 enemy proxies, large Guide outline and moving lantern circles. Visual layout accepted; actual sprite foot contact not yet tested. See `docs/D209_BLACK_LANTERN_ARENA_NATIVE_QA.md`.
14. [ ] Finish/correct five genuinely distinct skeletal 25-frame atlases to the approved silhouettes; native animation gallery and sprite F6.
15. [ ] **Activate the staged encounter locally** only after art QA: wire #38 light into battle, then 54-case solo/duo/trio combat matrix, real battle→reward→table, and full-pool smoke. Only after approval release #38 to **38/45**.
16. [ ] Finish remaining seven cards without rewriting existing D151–D153 or D196 effects.

## Constraints

Godot 4.7.x + GDScript, data-driven focused additions, rapid playable vertical slice, no speculative global architecture. D143 new enemies for new combats; D167 credible world scene art; D168 user chooses from rendered variants before art integration.
