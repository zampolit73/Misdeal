# D384 — Волновые бои: тактический прогноз перед второй атакой

**Scope:** quality-of-decision improvement for the two **already approved** optional wave encounters only: D382 `iron_wall` and D383 `firing_square`. No new arenas, enemy groups, UIs, target lines or stat buffs. Godot 4.7.x / GDScript / existing DS3 physical battle HUD.

## Problem

The between-wave break already lets surviving heroes reposition and select a basic tactical order, and BattleUnit's enemy AI always picks the **nearest alive enemy**. However, the consequences are invisible until after `ВОЛНА II` is pressed. Players might consider the reposition a decorative chore rather than a meaningful gamble.

## Implemented D384 behavior

- Reuse the **existing two-line `OrderDescription`** control in the approved battle panel. During wave I or on a normal encounter, no future-wave forecast appears.
- At the D382 or D383 **intermission only**, the first line is the already-existing real selected order description: `НАТИСК`, `ОХОТА`, `СТРОЙ`, or a spent rare order (not reacquired). The second line is a compact, **non-guaranteed first-target estimate** for the incoming opponents:
  - Firing Square: `ПЕРВЫЕ ЦЕЛИ: слева — Рыцарь · справа — Следопыт` (example, driven by actual living positions).
  - Iron Wall: `ПЕРВЫЕ ЦЕЛИ: стрелок — Рыцарь · пехотинец — Маг` (example).
- Every `0.12` seconds during the pause only, the readout compares each authored incoming spawn **after the SAME floor projection used by real Battle** to living heroes' current positions. It uses squared distance, exactly as the generic enemy `BattleUnit._find_nearest_enemy()` does. Thus moving the Knight to the left or right dynamically changes which hero the left/right archer is expected to target at combat start. It is a prediction of **first** target pressure, **not** guaranteed later enemy focus, kill, damage, or future AI movement.
- Hovering a tactic previews its description on line 1 without altering the selected order or predicted enemy targets on line 2. Clicking a tactic commits the existing actual AI stats/target order. Stays in **existing HUD**, no overlay or arrows. When wave II launches the briefing disappears with the preparation HUD.
- When multiple survivors are clamped back from their combat positions into the narrow legal preparation strip, they can otherwise spawn *on top of each other*. D384 also separates **only overlapping living party miniatures** by finding the nearest non-overlapping point on the existing approved legal floor. Heroes who are already apart do not move, and no hero is healed, resurrected, moved off the floor or given new stats.
- The two optional wave encounters' already approved enemy spawn points, enemies, HP carryover, loot and 12+XIII are unchanged. The other arenas remain quick, single-wave autobattles.

## Native Godot F6 QA

After `git pull`, open each existing preview and press **F6**:

1. `res://scenes/dev/d383_firing_square_crossfire_playtest.tscn`: select a **trio**, clear wave I, observe the current order and **`ПЕРВЫЕ ЦЕЛИ`** line in the lower command panel. Move Knight to **left** edge; the left Archer's opening target should be Knight. Move Ranger/Mage to the right; the right Archer targets the nearest right-hand hero. **Exchange hero positions** and verify the names change *before* pressing Wave II.
2. If your surviving party converged on the same point at the end of Wave I, they should return to the legal preparation strip **without stacking miniatures**. You must be able to click each hero. No HP changes.
3. Hover `ОХОТА`, `СТРОЙ`: the first line temporarily previews that real order while the enemy initial target prediction remains. Click `СТРОЙ` or `ОХОТА`: actual order changes, prediction remains accurate for the chosen positions. The existing tiny DS3 panel must fit both lines without covering unit feet, hero buttons or the main Fight action.
4. Start Wave II: compare the opening enemy focus against the brief prediction. The enemies can re-evaluate targets later as units move/die; this is intentional.
5. Open `res://scenes/dev/d382_iron_wall_wave_playtest.tscn` (F6). Repeat: the forecast names **стрелок** and **пехотинец**, not fake left and right threats. A solo hero gets both predictions on himself; no other changes.
6. Standard battles still show only the regular order description. There are no bright target lines, sound cues, new combat phases or more opponents.

## Regression / rollback

- `tests/unit/test_d384_wave_briefing.gd` covers live Firing Square left/right target shift after moving heroes within legal placement, deterministic non-overlapping real party redeployment after clamping, D382 Iron Wall distinct enemy labels, order preview and stat switch, and no reveal during wave I or on ordinary battle.
- Existing D382 and D383 live Battle/RunState GUT tests must still pass, including one Reward, health retention, no skips. Native CI3 framebuffer capture `firing-square-break` explicitly positions two real heroes in their legal area and checks the two-line command description, then renders the authentic Godot 1280×720 frame.
- If human F6 finds the second line visually too dense, shorten the localization in `_get_wave_target_readout` and keep the same existing panel; **do not** add another floating overlay or tracer.
- All code is limited to one existing battle script, one actual Firing Square CI capture and a dedicated test suite; rolling back D384 does not remove the accepted D382/D383 wave gameplay. D384 has **no new animations, bitmap assets or automatic assistance buffs**.
