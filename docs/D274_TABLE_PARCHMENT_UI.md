# D274 — Approved parchment card layout

User approval (2026-10-19): the hybrid TWO-CARD table mock, not the alternate three-card spread. Two portrait parchment cards with independent large illustrations, dark ink titles and captions, a red ВЫБРАТЬ face inside each card, bronze УДЕРЖАТЬ tabs, and the existing wizard, approved Variant C background, deck, discard and Fate Spread.

## Shipped runtime files
- scenes/table/table.tscn: 272×338 live offer cards at (349,329) and (659,329), single-card at (504,329); holds above them.
- scripts/table/table_offer_skin.gd + shaders/table_offer_parchment.gdshader: stable parchment grain, dark ink inscriptions, illustrations from the original art catalog, thin bronze ornaments, the red choose area and hold styling.
- scripts/ui/misdeal_ui_kit.gd: opt-in frame styles for normal/hover/held/boss/marked/disabled.
- scripts/table/table.gd: original buttons, RunState callbacks, Fate Hold, Wizard Mark, wizard wager/meddling, card reveal and animations retained. The full original card text remains in tooltip while printed card copy is shortened at a word boundary. No static UI image replaces the real Godot controls.
- scripts/dev/d274_table_offer_smoke.gd: optional script-mode Godot test for the real Table scene; workflow .github/workflows/d274-table-ui.yml checks native import and node/visual component contracts.

## Native review
Code is in main. The workflow checks Godot 4.7.2 parser/material loading and card construction; this alone is not visual sign-off. User should git pull, play a new Act 1 run at 1280x720, check both cards/art/text/holds; hover for full Cyrillic descriptions, choose a fight/event, return via reward to the table, use Hold once (and check its delayed return), inspect Wizard Mark, fate overlay with R, squad with Tab, one-card and boss layouts and wager/meddling states. Compare directly to the screenshot the user chose. If the procedural material looks too flat, enrich ONLY this opt-in skin, not the original approved Fate Spread, card art or game logic. Act1 remains 39/45; KARAMBA73, D271 Court, D264 floor unchanged.

## D274R — Screenshot-driven corrective pass

User's real Godot screenshot showed a long single-line gray native tooltip overlaying both cards, and weak teal-on-paper text. This is a visual failure despite earlier successful component smoke. The screenshot did not show duplicate in-card labels: it showed the native Control tooltip.

Code commit 16107bb adds scripts/table/table_offer_button.gd, subclassing the two card Buttons to make a 318px dark/bronze wrapped full-lore tooltip. Card titles and type labels now use dark ink. Hover-raised cards must not cover the Hold buttons. No card data, backgrounds, Fate Spread or encounter mechanics were modified.

Official native Godot 4.7.2 smoke PASS: https://github.com/zampolit73/Misdeal/actions/runs/39289351602. It checks a long Cyrillic tooltip width/label content plus hold z-index and parser. Await actual user Godot 1280x720 after git pull, hovering the same Moon Seal card, and verify no overlapping lore panel and correct card interactions. Technical PASS is not the same as artistic sign-off.

## D275 — No hover tooltip: intentional card examination

The second native user screenshot showed that wrapping the Godot tooltip only made it smaller; it still covered both physical offer cards. This is a usability failure. Remove popup entirely from hover; preserving a large popup somewhere else near the pointer is not an acceptable fix.

New contract: LMB anywhere on the card = original choose handler; pointer hover = card lift + Wizard reaction, no floating tooltip; RMB on card = separate modal examination with unchanged independent card art and FULL Russian lore in scrollable RichTextLabel. Close with ESC, the close button or outside click. A quiet line below cards advertises `ПКМ ПО КАРТЕ — ЧИТАТЬ ПОДРОБНЕЕ`. The modal has no state change and cannot be confused with selecting or holding.

Code: scripts/table/table_offer_button.gd (inspect_requested signal), scenes/table/card_lore_inspect.tscn and scripts/table/card_lore_inspect.gd; scripts/table/table.gd connects the signal and supplies actual RunCardData/card art and Wizard Mark/Held annotations. Do not re-enable tooltip_text for the live two offers; use the explicit mode instead. scripts/dev/d274_table_offer_smoke.gd covers the new scene and real signal. LMB choice, hold, wizard wager/meddling, Fate Spread and all 39 live Act1 cards remain unchanged.

QA: `git pull`, run the table at 1280x720, hover and confirm no lore obscures the two card titles or Choose buttons; RMB left/right card and scroll, dismiss via ESC/close/outside click; LMB should still proceed into an encounter. Verify when one offer, a held card, Wizard Mark and after Reward→Table. Native component CI must pass, **visual acceptance remains open**.


D275 native Godot 4.7.2 import plus inspect-scene smoke PASS: https://github.com/zampolit73/Misdeal/actions/runs/39290459465 (CI expected-output label corrected in commit dc49d03). Technical verification includes the original Cyrillic full lore in the separate dialog; **final visual screenshot/interaction acceptance still requires user Godot F6**.

## D276 — Native D275 screenshot review and restrained polish

Native user screenshots from 2026-10-19 confirmed the previous D275 UX repair: normal card offers and `УДЕРЖАТЬ`/`ВЫБРАТЬ` are unobstructed, and the deliberate RMB lore inspection correctly shows full `ПЕПЕЛЬНЫЙ ПРИВАЛ` card lore in a separate framed surface. D275 mechanics/read flow are accepted as a usable basis, not a final reproduction of the chosen painted UI mock.

New D276 scope: compact the original 760x440 lore modal to 720x364; keep the image, card title/type, full scrollable copy and all dismiss behavior but remove unnecessary under-image navigation instructions. Use fine bronze image/text rules and a restrained Misdeal emblem to reduce the impression of empty generic UI. In the two live parchment cards add only a thin engraved internal frame, slim artwork rims and a hairline above the red CTA; slightly improve the bottom RMB hint contrast. No changes to positions of cards (272x338), their meanings, existing art assets, button hitboxes, or RunState.

QA: official Godot 4.7.2 D276 CI should verify the new modal bounds and inner card frame. User should `git pull` and take one native screenshot of the updated RMB window and table at 1280x720. Native artistic sign-off for D276 remains OPEN until shown. Keep the current source values and this record in case any further visual refinements are needed.

Official Godot 4.7.2 D276 parser + compact-modal and engraved-card node smoke PASS: https://github.com/zampolit73/Misdeal/actions/runs/39291565684. This is a functional/native source check, NOT the user's visual approval of D276.

## D277 — Antique parchment and physical-card polish

User reviewed native D276 screenshot and asked to continue polishing only the artwork of the existing two live offer cards. D277 production change 0d3a1b9:

- shaders/table_offer_parchment.gdshader: richer but deterministic warm paper with coarse pigment variation, sparse foxing, fine fibre and irregular edge browning; card art and text remain separate Godot layers.
- scripts/table/table_offer_engraving.gd: custom light-touch thin metalwork outside legible captions, small crimson/bronze rivets. No gameplay signals.
- scripts/table/table_offer_skin.gd: attaches the engraving after the existing parchment/art/CTA, supplies a slim warm gleam above the red action and changes only its tint on existing Button hover signals. All drawing controls MOUSE_FILTER_IGNORE.
- scripts/ui/misdeal_ui_kit.gd: adjusts ONLY the opt-in parchment offer normal/hover border metal tones. Combat, Reward and Fate Spread skins untouched.
- scripts/table/card_lore_inspect.gd: slightly richer inner bronze frame, small upper seal mark and two slim artwork gilding rules; established compact 720×364 layout, full Russian lore and modal interactions unchanged.
- scripts/dev/d274_table_offer_smoke.gd & .github/workflows/d274-table-ui.yml: cover new engraving nodes, hover color restore, lore frame ornament, existing controls and native parse.

Native manual acceptance: run 1280×720, hover either card and see a soft gold frame/red footer accent; confirm text, CTA and illustrations remain readable and no old popup; RMB one card, inspect compact gilt frame and read full text; close via Esc, then LMB choose. Test Wizard Mark and hold after progression. Compare with originally selected two-card concept for restrained material feel. Native automatic smoke alone is NOT visual artistic sign-off.

## D278 — Real painted source instead of procedural card decoration

User approved production implementation of a separate, reusable graphic frame. A newly rendered dark-fantasy card concept was used **only as a painting source**; the specific bronze rim was cropped and the card illustration, card caption/type/body and crimson action were masked completely transparent. Source bitmap is 272×338 compressed WebP 5088 bytes with SHA256 `94c1991dd4ea421b566bf5e6782fba9c04387cb6b4da97b31f0091754128f6b9`; center pixel is fully alpha-clear. The composite source screenshot was NOT installed.

For GitHub's UTF-8-only art transfer, this single image's Base64 is stored as four ordered and verified equal 1696-character chunks, all at `assets/pixel/table/offer_frame_d278_{1..4}.webp.b64`. `scripts/table/table_offer_frame_asset.gd` reconstructs and caches one `Texture2D`. `scripts/table/table_offer_skin.gd` adds mouse-ignoring transparent IllustratedFrame as the last decorative child on both live offer Buttons, hiding previous D277 code-drawn corner fittings only when asset loading succeeds. The rest of the Table scene, disabled/held/marked styles and custom RMB inspection are untouched.

Acceptance: CI checks base64 reconstruction exact SHA, 272×338 WebP dimensions and alpha-center as well as actual two-card nodes. User native F6 screenshot is necessary to judge whether gilded side edges overprint titles/illustrations and if the shadow and button balance match approved conceptual art. Do not claim aesthetic signoff from CI alone.
