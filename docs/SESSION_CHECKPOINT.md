## NEWEST — 2026-10-13 — Next art candidate brief prepared, image generation misrouted; NO new binaries

After D134 13/13 approved pictured compositions were shipped, user asked to continue. The remaining **five original 18-art inventory candidates**, NOT YET approved as images, are three live table cards `gravedigger_shop`, `bone_swarm`, `grave_crossfire`, and two live event backgrounds `candle_seller`, `last_camp`. New **`docs/CARD_ART_WAVE1_REMAINING5_BRIEF.md`** records five distinct scene concepts, correct runtime IDs/paths, source fallbacks, 448×274 vs 1280×720 export, and protection of signed-off Shop UI. Image generation unexpectedly repeated the **previous** five upgrade/reward artworks (Knight, Ranger, Mage, gold, ruby); this repeated result was **rejected** and NOT added to GitHub. This was a documentation/preparation pass only: **still 13/18 source inventory represented in main, 13/13 D130 approved artworks**, pending user Godot QA of last five D134 items. New five proposed art scenes need **fresh explicit generation intent and user approval** before asset integration. Do not suggest these five were accepted or committed.

---

## NEWEST — 2026-10-13 — D134: 13/13 D130 illustrated assets binary-shipped; Godot QA pending

User approved the last FIVE separate full-size arts and explicitly instructed to commit directly to GitHub. **Completed in main commit `e3729a4a86a9cce006ec8803fa6e7e0aa1f00de5`:** five new real `608×388` WebP binary assets, paths `assets/pixel/card_unification_v1/upgrade/{knight_iron_oath,ranger_arrowstorm,mage_glass_heart}.webp` and `assets/pixel/card_unification_v1/reward/{gold_windfall,relic_wager}.webp`. They are exported from exact latest 1570×1002 approved PNGs, NOT lower-resolution D130 concept crops and NOT the older individually generated knight variant. All five remote GitHub blob SHA identities and WebP headers independently verified; five-file-only commit. No code/UI/logic modifications needed because the preexisting `scripts/ui/card_unification_v1.gd` + `CardArtCatalog` resolve these images before the old atlas. **D134** records exact generation IDs, mappings and art restrictions including gray-bearded MALE mage and skeletal hand HOLDING red gem. D131 four run cards + D132 four event backdrops + D134 five upgrades/rewards = **13/13 D130 pictured compositions in GitHub main**. Additional 5 old Wave 1 candidate art IDs outside this pictured set are NOT approved or shipped.

**Next**: user `git pull` (no ZIP), preview `res://scenes/dev/card_unification_v1_preview.tscn` via F6 and live hero-upgrade/reward screens at 1280×720, confirming legibility and actual award behavior. If previously extracted old 13-image ZIP, Git may flag FIVE untracked upgrade/reward WebPs on pull; move those specific outdated files outside project before retry. Godot runtime has NOT been tested by assistant. If all looks good, mark the card art first wave visually validated, return to Act 1 gameplay or separate five remaining candidate art proposals. Approved DS2 / D123–D133 design frozen.

---

## NEWEST — 2026-10-13 — D133 D132 arts accepted in Godot; NEXT FIVE art plan authored; NO new images

User replied **«все ок. погнали дальше»** following the scoped D132 illustration mapping/tint fix. Treat this as local acceptance of 4 shipped event scenes and their new live deal-card thumbnails (D133); protect D131/D132 artwork and D123–D129 approved UI. Next 5 D130-approved compositions are `knight_iron_oath`, `ranger_arrowstorm`, `mage_glass_heart` (MALE elder with LONG GRAY beard), `gold_windfall`, `relic_wager` (SKELETAL HAND GRASPING RUBY). Their exact paths, narrative prompts and 608×388 export requirements are now in **`docs/CARD_ART_WAVE1_FINAL5_BRIEF.md`**. Attempts to generate the 5 images in this session instead produced two wrong old-events 4-panel collages. They were **discarded, not committed, not approved**. The connected OpenArt plugin shows zero credits and cannot be used without adding credits. **No new five asset files exist**; runtime falls back to atlas. For the next generation, anchor the user's actual explicit request to **one specific new asset** (Knight Iron Oath first) and use the detailed brief; after individual art approval create native-size WebP and commit binaries directly through GitHub. Do not pass off the wrong collages as new art. D133 records live acceptance, not future art approval.

---

## NEWEST — 2026-10-13 — D132 event art not seen in local game: targeted mapping + tint fix

After user reported «арты не загрузились проверил в игре», traced the repo source. **Actual D132 binary files are in main** and `ActChoice._apply_event_layout` already resolves them as full-screen **event backgrounds**, but `CardArtCatalog.get_run_card_texture` still selected old v4 atlas images for **the corresponding four deal cards**. This is why looking at the actual deal table could show no visual change. Fix commit `dd4db61` plus integer crop offset `46fe4c2`: `scripts/ui/card_unification_v1.gd` uses the existing 1280×720 D132 event WebPs for `curse_forge`, `black_altar`, `chained_prisoner`, `rattling_bridge` **also as center-cropped 448×274 run-card textures**, cached with old atlas fallback. Existing D131 four independent run-card images unaffected. Separate DS2 styling commit `4d515fb` reduces just these four event screen's background tint alpha from .58 to .34 to let the approved art show, leaving card geometry, buttons, all other events and gameplay unchanged.

**Unconfirmed in Godot:** user `git pull`, launch normal run and inspect deal cards of those 4 IDs and actual inside-event backgrounds. If cards show new art but event still does not, request screenshot of the specific *event* screen and log errors; inspect live hierarchy/feature art with current Godot, do not assume root cause solved. Can inspect the 8 installed sources in `res://scenes/dev/card_unification_v1_preview.tscn` via F6; remaining 5 uncommitted Wave1 art slots will show missing. No extra ZIP needed. Protect D123-D132 approved screen and imagery. Project source integration changed, no new binary files.

---

## NEWEST — 2026-10-13 — D132 FOUR event backgrounds committed to GitHub main

User explicitly accepted 4 latest full-resolution event artworks and authorized upload. **Done:** `assets/pixel/card_unification_v1/event/{curse_forge,black_altar,chained_prisoner,rattling_bridge}.webp`, all 1280×720 WebP from corresponding approved 1672×941 PNG originals, quality 91, main commit **`1722d070cfe5a5690596953a1465b198177a57b3`**. Verified four individual GitHub binary blob SHAs and diff (only four new asset files). No GDScript or UI changes required: existing `card_unification_v1.gd` and guarded ActChoice event art loader prefer valid new event WebPs with legacy fallback. No changes to fate spread, Wizard Shop, Well, combat, or event logic. This supersedes earlier D130 small-crop art for the FOUR event backgrounds. **Godot visual/runtime QA still open**: user pull and inspect actual Curse Forge, Black Altar, Chained Prisoner, Rattling Bridge at 1280x720 with DS2 overlay. D132 contains exact generation IDs/visual requirements. Existing D131 four table cards retained. The last five illustrated D130 artworks yet to be deployed: 3 hero upgrades (Knight Iron Oath, Ranger Arrowstorm, male gray-bearded Mage Glass Heart) and 2 reward arts (Gold Windfall, skeletal ruby hand Relic Wager). The five additionally proposed but never illustrated candidates still await design. Historical notes below claiming all four event backdrops absent are superseded. Do NOT extract outdated `misdeal_card_art_wave1_import.zip` over any of the 8 current tracked art binaries.

---

## NEWEST — 2026-10-13 — D131 FOUR run-card WebPs uploaded and live by source; Godot review pending

**User:** «хорошо. заливай в гит». Directly exported exactly the last four approved images (not earlier similar variants) from 1604×981 PNG to 448×274 WebP, WebP quality 82, and committed actual four binary files to `main` in **`9d864113d66236111b8a3f048afaac35416cedf1`**. Paths `assets/pixel/card_unification_v1/run/{bone_patrol,graveyard_ambush,gallows_volley,whispering_well}.webp`. Verified blobs present on main. Existing `scripts/ui/card_unification_v1.gd` + `CardArtCatalog` selects them first automatically, with previous v4 art fallback. These supersede the old blurry D130 ZIP crops. No game scripts/UI changed. D131 now marked deployed, although user Godot F6/gameplay QA remains open. **Next:** `git pull` + inspect 4 cards in `res://scenes/dev/card_unification_v1_preview.tscn` (other 9 entries still need separately installed candidate ZIP or will report missing) and normal run table. If ZIP's old four untracked WebPs were previously extracted, remove just those four before pulling or Git may refuse overwrite. Preserve newly approved distinct roles, 3 bow archers, unique well spectres. Remaining 9 D130 candidate WebPs not pushed; five further proposed Wave 1 artworks not yet produced. Next task after QA: separately finish remaining approved images, don't reopen D131 compositions.

---

## NEWEST — 2026-10-13 — D131: four high-resolution deal-card artworks approved by user

User approved **the last four** standalone art images (two sets were generated; only the most recent batch is authoritative for the four cards): `bone_patrol` = unique skeletal roles, `graveyard_ambush` = one main hooded ambusher, `gallows_volley` = exactly three different bow archers and NO firearms, `whispering_well` = distinguishable ghosts at the well. File names and exact image generation IDs are recorded in D131 and `docs/CARD_ART_UNIFICATION_WAVE1.md`. These **supersede D130's four small table card crops**, which were blurry and had replicated/AI-looking silhouettes. The other nine D130 concepts remain approved, including male gray-bearded mage and skeletal ruby hand. The new full-size PNG artwork **has not been added to GitHub**; current Wave1 override code exists, but the previously provided 13-image ZIP contains old small crops for those four. Do NOT treat that ZIP as the final source for approved four. Next step: produce correct 448x274 runtime WebPs from latest four PNGs preserving subjects, commit binary assets safely (or report the transfer limitation), and test Godot. Existing DS2 screens and game logic unchanged. Approval is visual, not proof of engine implementation.

---

## QA helper added — 2026-10-13

Godot F6 image QA scene added directly to main: scenes/dev/card_unification_v1_preview.tscn + scripts/dev/card_unification_v1_preview.gd. It shows the 13 optional D130 candidate source art files in three rows and displays a missing-count if the ZIP has not been installed locally. User testing: git pull, unzip conversation artifact misdeal_card_art_wave1_import.zip into Misdeal root (one-time assets step), open that scene F6 at 1280x720; inspect every thumbnail and bottom-right repair, then test event backgrounds, reward and card gameplay. Image binaries remain outside GitHub. Editor not available for runtime QA; scene source statically audited only.

## NEWEST — 2026-10-13 — Candidate card art prepared, conditional GitHub hookups committed

D130's approved 13 card-art examples were cut into first-pass separate WebPs from the accepted concept board, and a conversation artifact ZIP (misdeal_card_art_wave1_import.zip) plus contact review sheet produced. Some bottom-right mini-preview regions required approximate reconstruction; large event images use source crops upscaled to 1280x720, so quality acceptance is OPEN. Conditional asset resolver scripts/ui/card_unification_v1.gd and calls in CardArtCatalog and ActChoice are committed in GitHub main; missing/invalid new asset files revert to existing approved art. GitHub currently has code ONLY, not generated binary images, because no supported direct file-byte transfer for local artifact ZIP. User needs git pull + unzip package into root for local smoke. Never claim the new art images are already in GitHub or visually accepted. D130 approved concept and D123-D129 established UI remain protected. Refer to docs/CARD_ART_UNIFICATION_WAVE1.md for exact source mapping and next steps.

## NEWEST — 2026-10-13 — D130: card-art concept board visually approved

User approved the **last** Misdeal card-art concept after iterative redraws. D130 and `docs/CARD_ART_UNIFICATION_WAVE1.md` record the 13 depicted asset IDs and exact compositions. Key constraints: **`gallows_volley` = few archers with bows/arrows only (no firearms or masses); `mage_glass_heart` = mature male mage with gray beard; `relic_wager` = bony hand holding a red faceted jewel**. All other cards in the last sheet are approved as shown. Board: last chat-generated image `мрачный_концепт_арт_misdeal_награда_с_рубином.png`, gen `6c7d5d41-24a1-47f9-8f54-e689bbe265a5`. The PNG remains **in conversation context, NOT committed as a repo image**; the approved sheet is a reference, not production crops. Five of the 18 initially proposed Wave 1 assets were not on the accepted sheet. **Next:** derive or author 13 separate images faithfully, preserve textures/layouts, integrate only after clean assets exist and verify in Godot. No game code, image binaries or current art replaced in this checkpoint.

## ART PLANNING ADDENDUM — 2026-10-13 — Wave 1 asset inventory, no game art switched

After D129 bulk DS2 visual acceptance, user requested a precise first wave for unifying card **illustrations** (not the existing approved UI). Source audit completed in `scripts/ui/card_art_catalog.gd` and real event scene paths. New proposed plan `docs/CARD_ART_UNIFICATION_WAVE1.md`: **18 exact runtime targets** = 7 table/run-card crops (including Well/Shop as deal cards only), 6 non-shop event backdrops, 3 upgrade images, 2 reward images. The file documents old assets/atlas cell indices, existing renderer priorities, format constraints and protected surfaces. This is **planning only**: no new images, code, texture overrides or production runtime changes. Crucially do NOT replace approved live Well/Shop/table screen backgrounds simply because old `whispering_well.webp` and `gravedigger_shop.webp` event paths exist: those art assets are not currently used as live backgrounds. Next: visual contact sheet of actual active crops, decide keep/touch-up/redraw, create a reference trio and obtain approval before writing replacements.

# MISDEAL — Current restart checkpoint (2026-10-13)

**Status: Design System 2.0 bulk rollout accepted by user after local review.** The user responded «все хорошо» following the consolidated deployment of remaining interfaces. Treat the visual presentation of the batch as approved; do not demand another screenshot or reopen restyling without a new reported defect. This supersedes the earlier "awaiting full visual acceptance" notice below, but is **not** proof that every rare event branch, reward payout and combat outcome was exhaustively tested.

**Implemented and preserved:** `scripts/event/act_choice_ds2.gd` skins the non-shop shared event choices; `scripts/event/gravedigger_shop_ds2.gd` handles the live merchant; `scripts/ui/misdeal_ds2_rollout.gd` skins Class Select, TAB Squad Dossier, Run End, Battle HUD, and table peripheral UI/Wizard Wager. Dedicated Reward and Whispering Well screens already use approved DS2. **Frozen references:** Fate Spread Variant C (D123), Reward major-upgrade (D124), Whispering Well (D126), shop (D127), accepted bulk pass (D129). Start and Intro authored artwork retained.

**What to do next:** prioritize a small new *gameplay/content* vertical-slice improvement for Act 1, not speculative UI redrawing. Review `docs/ROADMAP.md` and current run/card/combat resources for the highest-impact change, discuss game-design changes before implementation. Functional regression tests may be done incidentally (shop price/charge, event branches, rewards and battle) but do not block future work merely because the earlier QA checklist was comprehensive. For any new reported defect inspect GitHub first. The new chat can proceed without reconstructing this history.

---

## NEWEST — 2026-10-12 — LARGE Design System 2.0 rollout committed; live Godot smoke pending

User requested remaining DS2 screens **in one large package** instead of screen-by-screen review. Applied production visual-only changes in GitHub main:

- New `scripts/event/act_choice_ds2.gd` presenter, connected to shared `scripts/event/act_choice.gd` for **all non-shop ActChoice events** (14 event types; existing approved standalone Whispering Well is separate). Existing Gravedigger Shop uses its own approved dedicated DS2 presenter. Event skin retains original event backdrop art and three existing choice buttons with their signal handlers, original full choice text in tooltips, original disabled/visibility states, and physical bronze/parchment layout plus shop-compatible resolved footer. Dynamic description and event text is read from the configured card. Existing `_configure_*`, `_resolve_*`, `_finish`, `_disable_choices` and route methods are byte-identical to pre-rollout; only `_ready` presenter selection and `_apply_resolved_layout` changed in shared file.
- New opt-in `scripts/ui/misdeal_ds2_rollout.gd` styles **class selection**, **squad dossier**, **run end**, **battle HUD**, and **table's peripheral chrome + Wizard Wager**. It uses existing Godot nodes and `MisdealUIKit`, no changes to data, scene trees, portraits, arena bounds, targeting, tactical option logic, run flow or reward code. Caller scripts: `scripts/class_select/class_select.gd`, `scripts/table/squad_status.gd`, `scripts/run_end/run_end.gd`, `scripts/battle/battle.gd`, `scripts/table/table.gd`. Existing introduction/splash art, approved Fate Spread variant C geometry/assets, Reward and live Whispering Well and Gravedigger Shop remain unchanged.
- Source checks compared previous versions: in `ActChoice` only `_ready` and `_apply_resolved_layout` changed; all rule handlers unchanged. Class select, squad, run end changed only `_ready`. Battle and Table changed only `_apply_ui_kit`. Referenced static scene node paths checked. No Godot binary was available for runtime tests.

**Next:** one consolidated `git pull`, run Godot 4.7.x at 1280×720. Smoke start → intro → choose role; table and wager; `TAB` squad dossier; real Gravedigger Shop with price/gold/purchase/leave; one or more of `ActChoice` event paths (blood/coin/leave, absent party, disabled button); fight with tactical orders and outcome; rewards; run end. Check all Cyrillic/clickable choices, dynamic hidden card counts and result-to-table, no clipping. Any observed issue should be corrected in its scoped DS2 presenter, not via generalized gameplay changes. D128 authorizes this larger rollout; D123 Fate Spread, D124 Reward, D126 Well and D127 Shop visual baseline remain binding.

## NEWEST — 2026-10-12 — Live Gravedigger Shop DS2 deployed after user-approved F6 preview

**User approval:** after the corrected F6 shop preview static-copy fix, user said «все ок. внедряй». This confirms approval of **isolated shop preview**, not yet production gameplay validation. DS2 shop now shipped to main with new scoped presenter `scripts/event/gravedigger_shop_ds2.gd` and a narrow call in the shared `scripts/event/act_choice.gd` **only** for `active_card.card_id == "gravedigger_shop"`. The real `scenes/event/act_choice.tscn` was not modified.

The presenter borrows approved tabletop art and DS2 bronze/parchment UI, reuses the original three interactive Choice Buttons and their existing signals, shows real upgrade names and `RunState.get_gravedigger_shop_price()` with Lost Purse history, distinguishes missing party role / exhausted upgrades / insufficient gold, and preserves complete original offers as tooltips. The original `_configure_shop`, `_set_role_upgrade_button`, `_resolve_shop`, `_resolve_leave`, `_finish`, `_disable_choices`, `_return_to_table` are confirmed **byte-identical** to the pre-migration source. The shop-only result/footer branch preserves Continue-to-table and refreshes real gold after payment. Commits: `bef2d4c`, `7b26850`, `664db0e`.

**Godot runtime was not available to the assistant; production QA remains OPEN.** User: `git pull`, play until real Gravedigger Shop, check layout at 1280×720, actual dynamic price with normal and Lost Purse modifiers, missing/available party roles, enough/insufficient gold, buy one upgrade (correct grant and charge), leave, result/Continue return to table. If anything overlaps or breaks, inspect the new presenter and current GitHub source before modifying other events. Approved Fate Spread D123, Reward D124 and Whispering Well D126 remain untouched. Binding preview decision D127.

## NEWEST — 2026-10-12 — Shop F6 screenshot revealed missing authored labels

User provided real Godot shop-preview screenshot: artwork, borders, dynamic gold/price/availability/status rendered, but **static header/title/role/product/description/footnote labels were missing**. Preview fix committed `f6bb46e` to `scripts/dev/design_system_v2_shop_preview.gd`: defer static copy insertion until after entire Control hierarchy/geometry is built, matching the already-visible runtime-updated labels; distinguish affordable/disabled note colors and tint disabled cards. This is a code-side hypothesis about initialization order, **NOT YET Godot-verified**. Next: `git pull` and F6 scene at 1280×720; inspect main title, top eyebrow/wizard text, three role labels, three product names, item descriptions, status/footnote and gold/role-toggle disabled cases. If still invisible, diagnose the actual runtime drawing order/layout rather than assuming approval. No production shop migration before approval.

## NEW — 2026-10-12 — Gravedigger Shop DS2 isolated preview staged

F6 scene `res://scenes/dev/design_system_v2_shop_preview.tscn` and controller `scripts/dev/design_system_v2_shop_preview.gd` now exist in main. Three existing upgrade illustrations (Knight executioner, Ranger arrowstorm, Mage glass heart) are displayed on tactile DS2 cards with illustrative 25-gold prices, gold 40/10 toggle, Mage-in-party toggle and no-purchase action. This is a strictly non-gameplay review: no RunState or routing; price is **sample only**, NOT read from actual shop. User should `git pull`, open the preview scene and F6 at 1280×720 to approve or request polish. **DO NOT integrate into shared production `act_choice.gd` until visual acceptance**; actual `RunState.get_gravedigger_shop_price()` and Lost Purse pricing remain unchanged. D123/D124/D126 approved screens untouched.

# Misdeal — Current Session Checkpoint

**As of:** 2026-10-12 (user confirmed local visuals)  
**Branch:** `main` in `zampolit73/Misdeal`  
**Read first:** `AGENTS.md`, `docs/CONCEPT.md`, this file, `docs/PROJECT_STATE.md`, `docs/ROADMAP.md`, `docs/DECISIONS.md`, `docs/HANDOFF.md`, `docs/DESIGN_SYSTEM.md`. GitHub is source of truth for code and implemented features.

## Game and visual baseline

Misdeal is a Godot 4.7.x / GDScript dark-fantasy card-driven roguelike with a compact tactical autobattler. The evil Wizard hosts a cursed tabletop. Act 1 uses a twelve-position **Fate Spread** plus central Bone Warden XIII. The player begins with one protagonist (Knight, Ranger or Mage), with other companions recruitable or permanently lost.

**Do not redesign or recolor** the user's favorite, approved **Fate Spread Variant C**. The approved **Design System 2.0** borrows its material vocabulary: blackened wood/obsidian, worn bronze, blood-red ritual markings, parchment cards and candlelight. Design decision: **D123**. Keep gameplay, card outcomes and existing approved art unchanged unless requested.

## Latest user acceptance — live Whispering Well

The user approved the production `ШЕПЧУЩИЙ КОЛОДЕЦ` look in local Godot after the centered-card-row fix `1adc634`. Their direct feedback was **«без скрина все хорошо»**. This is a **visual acceptance**, recorded in **D126**; do not request another screenshot simply to reconfirm it or keep fine-tuning without a reported issue.

- Production files: `scripts/event/whispering_well.gd`, `scenes/event/whispering_well.tscn`
- Approved three DS2 choice cards: blood, 25-gold coin, refusal; approved original art, framed parchment, top counters and warnings
- Final row fix: make all Button minimum widths **292px** before sizing the `HBoxContainer`, `BoxContainer.ALIGNMENT_BEGIN`, then apply a centered **928px** row at x=176 for the 1280px reference viewport; second rescue-result line and disabled-gold warnings now fit
- Original seven event decision/art/route methods remained unchanged after alignment source check
- **Still unverified in aggregate:** every gameplay branch (blood scar, paid rescue, refusal, revisit for relic/upgrade/refund and return-to-table). Keep these as separate functional smoke tests, not a blocker for the next design preview.

Other protected milestones: **D124** accepted the **production Reward major-upgrade** presentation (three cards). **D125** approved the Whispering Well design-preview direction and scoped migration; **D126** supersedes older notes that say its visual alignment still needs checking. Other Reward modes (ordinary loot, bonus upgrade, Death Wager, elite reward) still merit gameplay QA.

## Exact next task — Design System 2.0 Gravedigger Shop preview

**Next work is not yet implemented.** Create one isolated, non-gameplay **F6 preview** of the **Магазин могильщика** using existing art and DS2 material helpers. Show three purchasable role-upgrade cards (Knight, Ranger, Mage) with clear price/disabled affordability presentation, and a safe leave option. Use 1280×720. Ask the user to visually approve it **before** touching production presentation.

**Important architecture:** the shop is the `gravedigger_shop` branch in shared `scripts/event/act_choice.gd` / `scenes/event/act_choice.tscn`, **not** a dedicated scene. These resources also serve many unrelated events. Current shop setup lives in `_configure_shop()`. Any future live migration must be guarded explicitly to the shop card (`active_card.card_id == "gravedigger_shop"` or equivalent existing check), never applied to the full shared ActChoice UI.

Preserve all existing rules:
- `RunState.get_gravedigger_shop_price()` and Lost Purse history-adjusted price
- Correct party-role upgrade offers, affordability/disabled logic and gold deductions
- Existing selection, purchase, return-to-table handlers and persistence
- Original Fate Spread and accepted Reward / Whispering Well visuals

After isolated preview approval: implement a narrowly scoped production shop style pass, run local Godot QA, update `PROJECT_STATE`, `ROADMAP`, `HANDOFF`, `DECISIONS` if an additional binding decision is warranted, and `CHANGELOG`.

## Local developer workflow

User runs Godot locally and pulls GitHub commits with `git pull`. Connected GitHub tooling can edit/commit directly: **do not ask for GitHub access repeatedly and do not make the user copy patches manually**. Use Godot 4.7.x and GDScript, prioritize playable vertical slice and data-driven resources. No additional gameplay/art changes were requested with this handoff.
