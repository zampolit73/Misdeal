# D356 — Faceless Card: approved 5th image, exact handoff

D356 «КАРТА БЕЗ ЛИЦА» approved option #5 ('готический_ритуал_с_чёрной_картой.png'): exactly one blank black card held over the ROUND Fate Spread Misdeal gaming table with red occult markings, brass rim, burgundy cloth, candles and gothic interior. Source 1536x1024 PNG SHA256 94e3f8d6d6471fd3e232b94be5c55b735043670aac3832138b34d532a23b64bb. Runtime res://assets/pixel/card_unification_v1/run/faceless_card_d356_approved_option5.webp = crop (0,42)-(1536,981), 448x274 WebP Q86, SHA256 7f811babefa69692614db472be8233ec70112551324e7774600b74bdc47f925c. Only CardUnificationV1.RUN_CARDS['faceless_card'] points to approved art; .tres fallback stays intact. Native D315 list has 24 native WebPs plus D350 separately, 25 exact approved illustration locks total. No event choices, costs, gameplay, balance, DS3 or previous illustrations changed. Native PR Godot CI and local F6 review pending. The old D357 three-door-only options were rejected as not depicting the actual encounter.

## Verified implementation files

- assets/pixel/card_unification_v1/run/faceless_card_d356_approved_option5.webp — actual binary WebP in GitHub; Git blob 9bf6b31e3cd315ad1d27e1001adbb4770ab9bf36.
- scripts/ui/card_unification_v1.gd — RUN_CARDS['faceless_card'] override.
- scripts/dev/d315_card_ds3_smoke.gd — D356 strict SHA / WebP decode / dimensions / card catalog pixel equivalence and 25 approved art assets in total (including special D350).
- Original resources/cards/faceless_card.tres keeps prior fallback reference.

## Tasks

1. Wait for and verify real native Godot 4.7.2 CI on PR, 48/48 GUT, D289, D315, D316 plus screenshot capture/evidence. Do not merge until successful.
2. If green, squash PR into main, append verified CI + merge status to PROJECT_STATE, ROADMAP, HANDOFF and CHANGELOG.
3. Player runs git pull then F6 scenes/dev/d315_card_ds3_gallery.tscn and visually checks «КАРТА БЕЗ ЛИЦА».
4. D357 «Врата оссуария» — present actual 2-3 landscape images with guard, bell ringer, archer and bone thrall; avoid earlier erroneous door-only triptych.
5. A1P3 full F5 12 cards + XIII local playtest remains outstanding. 3 subsequent planned visual passes (iron_wall, last_bell, firing_square).
