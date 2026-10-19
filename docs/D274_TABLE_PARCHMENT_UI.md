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
