> **Release verified:** [PR #30](https://github.com/zampolit73/Misdeal/pull/30) merged as `67d5c8525634648bf658e1fae182c76d19074482`. [Native Godot 4.7.2 CI](https://github.com/zampolit73/Misdeal/actions/runs/40523091071) **SUCCESS**, 51/51 GUT and D291 Battle smoke. Player F5 confirmation still outstanding.

# D365 — combat feedback declutter after local player review

Date: 2026-10-27. User tested D362–D364 and approved everything except hover target display and shooting display, which cluttered the arena.

## Product decisions (locked by hands-on feedback)

- **No hover targeting overlays.** `BattleTargetPreview` matches the pre-D362 original: off by default; player may explicitly toggle `ЦЕЛИ: ВКЛ` during deployment to compare actual chosen targets, then preview hides on Fight. Moving the cursor over units never draws linking arrows, ground rings or an additional layer.
- **No long ranged attack streaks/graphic arrowheads.** `ranger` and `bone_archer` still play their authored attack animation, timing, hits, impact sparks, numbers and sounds, but they no longer spawn a full-span Line2D for every arrow. No fake projectile delay; real HP application stays instantaneous. Existing mage/bellkeeper magic traces unchanged.
- **Keep the liked improvements:** damage to heroes in muted crimson, damage to enemies in muted bronze, green +HP numbers and short actual source→recipient healing links, short impact feedback, unit movement and sounds.
- No DS3, arenas, tactical AI/order choices, encounters, resource data, Fate Spread, 12+XIII progression, sprites or balance changes.

## Focused Godot acceptance

After merging, `git pull` and F5 normal run:

1. On **Железная стена**, moving cursor over hero/enemy should have *no* visual effect; optional `ЦЕЛИ: ВКЛ` should display target preview **only before Fight** and switch off normally.
2. On **Расстрельная площадь** (4 archers), watch several volleys. No full-screen bright streaks or arrowheads; attack and hit frames, damage numbers, HP and sound still visible. Shots remain functionally identical.
3. On **Последний звон**, verify two healers still show green numbers and green source-to-recipient connections only for actual positive healing.
4. Check that selected tactics and Battle → Reward → Table remain correct; do not confuse 51/51 GUT with human visual acceptance.

## Automated release gates

Require Godot 4.7.2 import, GUT and native smoke CI PASS for PR before merge. New GUT regression `tests/unit/test_d365_quiet_combat_feedback.gd` proves off/explicit preview behavior and absence of D362 cursor-only hooks. Full standalone RELEASE animation/battle matrix and full 12+XIII human F5 loop stay pending.
