# D382 — Two-wave Iron Wall pilot (user-requested experiment)

**Approval:** User explicitly requested trying rare wave battles with a between-wave fighter reposition. Pilot changes **only the existing Act I `iron_wall` encounter**; do not introduce new cards/characters, global battle waves, additional reward screens or changes to XII+XIII.

## Mechanics
- Wave I: the existing two Crypt Sentinels in either of their original two authored formations. The original Bone Archer is removed from this first group.
- On the **last enemy death of wave I**, only if at least one hero survives: **no victory/no reward**. Set combat inactive, stop survivors and clear their targets, reposition them into the original legal player deployment region, enable their normal drag handles; show restrained lower tactics/placement HUD, an explicit enemy-direction hint, and one button `ВОЛНА II`.
- Between waves: hero HP/HP caps/upgrades, lost companions, injuries, gold, counter state and wizard challenges remain unchanged. No free heal, new heroes or mid-battle shop. Allow only **Assault/Hunt/Formation** as selectable orders. One-use Sacrifice/Defiance cannot be re-purchased/re-unlocked; if already chosen before wave I, its effects persist into wave II until the player changes away.
- Wave II: new group **Bone Archer on the upper flank + existing Skeleton infantry from lower flank**, authored in `EncounterData`; short native `ВОЛНА II` intro, continue same `BattleUnit` survivors with unchanged HP and new targets. One final victory only after wave II is cleared; one reward, and the existing Last Deal rule on total defeat.
- Scripting: `EncounterData.has_second_wave` validates optional `second_wave_*.` If data is absent/malformed, other encounters retain original single-wave behavior. `battle_wave_index` is Battle-local only; never saved to RunState or counted as another resolved Fate slot. No boss XIII, black-crossing water surge, Court, funeral resurrection, wizard side objectives or global unit AI changes.
- Card and encounter descriptions telegraph rare second attack. The approved art remains untouched.

## F6 in Godot

Open **`res://scenes/dev/d382_iron_wall_wave_playtest.tscn`**, use **F6**, choose solo/duo/trio and first wave direct/diagonal formation, press **ЗАПУСТИТЬ БОЙ**.

1. Review **ВОЛНА I / II** and the two sentinels; set formation and start.
2. Kill both sentinels. There should be **no victory overlay yet**. A subdued text cue and `ВОЛНА II` button appear. Drag survivors into new positions, switch to e.g. **ОХОТА**, check they stay injured (HP unchanged), dead heroes remain absent.
3. Click `ВОЛНА II`: upper archer + lower infantry spawn on the original arena; surviving heroes fight automatically. The **second** win triggers one standard `ПОБЕДА` → one Reward → Table. Losing either wave uses original Last Deal/Defeat behavior.
4. Repeat with different party sizes; assess **tempo**, whether repositioning materially matters, whether double waves are too punishing for solo or too easy for trio, and whether the extra button feels intrusive.

## Regression gates
- Native GUT: resource is opt-in and valid, real unit death transitions to intermission without victory, healthy/injured hero state retained, 3-hero basic order switch/reposition, authentic second wave and only then final victory, cannot skip wave.
- `scripts/dev/tactical_gameplay_v21_smoke.gd` validates **two original sentinels in wave I** and the separate upper Bone Archer/lower Skeleton wave II, maintains other cards' original authored formation tests.
- GitHub PR native Godot import + parse + GUT + battle smokes; **human F6 still required** before calling wave combat accepted.
- If the playtest hurts pace, remove/disable the `second_wave_*` resource fields for Iron Wall and restore original 3-enemy first wave; avoid altering any other fights.

