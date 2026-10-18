# D250 — User-native video review of D249 five-enemy real combat QA

Date: 2026-10-19. Recorded user-uploaded 21.4s, 1920×1080 Godot/Windows video. Filename references a browser/Skills page but after the opening second the actual footage is **Misdeal(DEBUG)** running D249. Video remains conversation-only; do not commit private screen recording.

## What the actual recording proves

- ~3.5s: original D209 dark forest loads at 1280×720 viewport. HUD says `D249 · МАРШ · 0.8 сек · герои 3/3, враги 5/5`. Three distinguishable Knight/Ranger/Mage characters, five distinct skeleton enemy silhouettes, real red and green HP bars.
- ~6–11s: actors converge and move through auto-combat; visible damage and changes in living enemies. ~10.6s reads `герои 3/3, враги 1/5`, `свет: active`, `усилено скелетов 1`, `атак героев 14 / врагов 5`. This is strong **native visual evidence of phase/buff counter and combat movement**, not an automated damage-interval assertion.
- ~12–14s: the light button changes to `СВЕТ ВЫКЛ` after interaction and rings disappear. ~14.0s reads `МАРШ · 9.6 сек · герои 3/3, враги 0/5`, `ПОБЕДА ГЕРОЕВ — ТОЛЬКО QA`, `атак героев 17 / врагов 6`. Thus the first (diagnostic, nonnormalized) 3v5 reaches resolution; **no hero dies**.
- ~15–16.5s: restarted session reads **`МАРШ` again**, 3/3 and 5/5 at ~1.1 seconds, with light switched OFF. At ~20.7s second battle still underway with 3/3 heroes and ~3/5 remaining enemies. One successful restart seen. The pointer approaches `СМЕНИТЬ РАССТАНОВКУ`, but the HUD remains **МАРШ**, so the **second authored formation was NOT verified in this recording**.
- No visible red QA FAIL, parse exception, vanished actor, or crash. This is a positive **native one-formation smoke** rather than proof every 25-cel animation or error-log-free status.

## Art/composition issue — NOT a QA signoff

The guide's **D218 gray rectangular overscaled technical pixel geometry** (`extinguished_guide`, `visual_scale=1.8`) is dramatically less detailed than approved D244/D224 and occupies a large fraction of the cluster. At close combat, its body/iron yoke obscures other enemies, HP/name labels overlap around the fight center and narrow character silhouettes are difficult to distinguish. This is a real **presentation gate**, not proof the core battle AI is broken. Light circles are visible but not sufficient evidence of final atmosphere/clarity. **Never ship D218 as the completed rich B-style Guide** and don't pretend redrawing a shield-bearing skeleton is an acceptable Guide substitute. Must retain **rigid overhead iron yoke with three chain-suspended lanterns**, 25 separately illustrated poses, after art approval.

## Scope and next checks

- **PASS user-visible:** one real `МАРШ` formation start, three heroes vs five original enemies, live fight, visible light phases/active buff counter, light-off action, first battle victory, restart.
- **PENDING:** second `ПЕРЕКРЁСТОК` formation, native both-direction sprite acting, effect readability under all five enemies alive, independent combat matrix and balance, actual Battle→Reward→Table and live #38 unlock.
- Do not infer the 9.6s victory establishes balance: D249 explicitly bypasses actual RunState solo/duo/trio coefficients and real encounter battle routing. The 17:6 attack counts are observations in this isolated QA only.
- Keep approved 37/45 live, D209/D200, two accepted-to-proceed rich actor atlases, DS2/XIII, and frozen KARAMBA73 unchanged. The next useful development is rich full 25-cel Guide followed by Acolyte/Archer. A future visualization pass should reduce label clutter without changing authored enemy attack/movement roles before actual release QA.
