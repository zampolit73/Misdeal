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
