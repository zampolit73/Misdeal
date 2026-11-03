# D383 — «Расстрельная площадь»: проект второй волновой арены (НЕ ВНЕДРЕНО)

**Статус:** design proposal after user «давай» to discussing the next selective wave arena. This is not approved code or a new encounter release. Do not add `second_wave_*` to Firing Square until design has been reviewed.

## Why it must differ from D382 Iron Wall

The *live* Tier 2 Firing Square encounter already has **1 Crypt Sentinel and 4 Bone Archers** and two authored enemy formations. The current battle stage is a narrow stone-floor strip, not an open tactical grid:

- `battle.gd` uses `GALLOWS_VOLLEY_COMBAT_BOUNDS = Rect2((90,279),(1080,163))` inside the UnitsLayer. Authored enemy Y positions project onto actual safe floor Y approximately **311–410**.
- Hero placement is **`Rect2((145,305),(385,122))`**. The player cannot meaningfully move units behind the far-right archers or far above the walkable area; claims of freely moving across the entire courtyard would be false.
- Current `assault` focuses nearest threat, `hunt` prefers ranged/support, `formation` defends the most vulnerable ally. D382 Iron Wall tests changing frontline into one ranged flank plus skeleton. Firing Square should test **reversing the direction of danger**, not repeating upper/lower foes appearing only on the right.

## Recommended option A — «Перекрёстный залп / Удар из тыла» (designed, NOT implemented)

Keep all **five pre-existing enemies** across **two waves**; no new card, enemy archetype, effect, screen or art.

| Beat | Authored foes | Player decision |
| --- | --- | --- |
| Wave I — front firing line | **1 Crypt Sentinel + 2 Bone Archers** on the right, keeping the existing two possible first-wave formations adapted to three actors | Ordinary opening deployment: do you stay compact around the Sentinel or Hunt the archers? |
| Intermission — rear flank revealed | After wave I is defeated with at least one hero alive, show the threat cue **«СЛЕВА — стрелок у тыла; СПРАВА — дальний залп»** BEFORE allowing wave II start. Reuse D382 intermission, move survivors and switch Assault/Hunt/Formation. | A Knight can shift left to protect the Ranger/Mage, rather than remain in the original forward-frontline position. Solo should still have a meaningful choice of placement + order but may be less affected by team-bodyguard tactics. |
| Wave II — split crossfire | Remaining **2 Bone Archers** emerge from **opposite horizontal flanks**, one on the **left edge near x=115, source y≈385** (behind the player deployment strip) and one from the **far right near x=1075, source y≈165**. Both are projected onto walkable floor. | Prevent left-side archer from shooting vulnerable allies while right-side archer forces targeting/range tradeoffs. A different decision from D382's melee-to-ranged flank transition. |

**Pre-spawn telegraph is mandatory.** No unannounced surprise archer at point-blank range. Preserve the approved arena art, original hero deploy rectangle and proper unit facing/foot contact; verify the left-side ranged unit faces its target dynamically, is not pinned behind scenic elements, and does not become an easy free kill with no counterplay.

**Battle rhythm:** short Wave I (3 actors) → one pause → short but directionally asymmetric Wave II (2 ranged actors) → **one victory and one normal Reward**. Hero HP/injuries/losses persist, no mid-fight heal/re-recruit or second Last Deal, no replenishment of one-use tactical orders. The selected Fate slot counts as **one** card; all normal arenas and XIII remain unaffected.

**Implementation caveat from actual D382 code:** `battle.gd` currently hardcodes Iron Wall prose during wave I, intermission and wave II (e.g. “часовые перекрывают проход”, “стрелы с верхнего фланга, пехота снизу”, “Вторую стену…”). To add a second encounter, move these into optional **data-driven localized per-wave labels/host quips**, or match on `encounter_id` in a small single helper. Never show Iron Wall's text over Firing Square. The existing `EncounterData.has_second_wave()` opt-in contract is enough to share the core win/intermission logic.

## Alternative B — «Двойной огневой рубеж» (rejected for initial prototype)

Wave I Sentinel + 2 Archers; Wave II the remaining 2 Archers positioned top-right and bottom-right. This is technically easy, but duplicates Iron Wall's upper/lower counterattack and gives much less reason to change hero positions. Better as a fallback if the left-edge crossfire fails safe-floor/facing/balance checks.

## Fairness, balancing and QA gate

- Keep existing **5 enemy count** instead of making a longer, heavier grind. Compare loss/finish rates against the old 5-foe one-stage fight at solo/duo/trio scaling (0.82/0.92/1.0 enemy HP; 0.80/0.90/1.0 enemy damage). The 3→2 split may make the encounter *easier* even with HP persistence; do not compensate by blindly raising damage.
- **Wave II should be telegraphed** from the left/right via one short DS3 line and still preview direction/identity before the confirmation button. No projectile streaks, bright arrows, grids or intrusive sounds.
- F6 playtest should use the real `Battle` screen at 1280×720 and permit party sizes 1/2/3 and two authored first formations. Check the left archer's feet on stone, correct facing and AI retreat at arena edge; no overlay/hero/archer overlap; meaningful Knight protection and Hunt/Formation targeting. Real GUT tests for precisely **3 first wave + 2 second wave**, enemy Y floor, no premature reward, carried HP, no extra Last Deal, and optional wave contract disabled for unrelated encounters.
- **Acceptance test:** two people playing the same encounter with one left-facing Knight deployment and one right-facing Knight deployment should have a noticeably different result or target behavior. If not, reposition is cosmetic; revise/reject.
- If approved and F6 pass: release by PR, native Godot 4.7.2 GUT+scene capture, then explicit player feedback before enabling waves on a third arena.

## Scope

This remains a **design draft**, not a player-approved finalized rule. D382 Iron Wall stays accepted and unchanged in main; no Firing Square gameplay or art files modified as part of D383 design.
