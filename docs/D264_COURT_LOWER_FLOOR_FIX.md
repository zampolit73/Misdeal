# D264 — Court lower-stone-floor combat geometry (USER-APPROVED)

**Date:** 2026-10-19. **Status: IMPLEMENTED, official Godot 4.7.2 native QA PASS.** Art remains a QA candidate; #39 is unreleased.

## Visual decision

User supplied a screenshot of `res://scenes/dev/court_of_the_mute_d263_empty_arena_preview.tscn` with the old high **green** combat area overlapping the throne's stairway and the desired **red** rectangle surrounding the flat *lowest* stone platform. User explicitly requested **move it directly in GitHub without an approval gate**, and permission to continue and adjust later.

**LOCK D264:** Court heroes, enemies and their pathable combat bounds must occupy the **lower flat stone floor**, not the decorative throne, benches or ascending staircase. No changes to placement for any other Act1 encounter. The red user annotation is a **location request**, not a change to the green on/off QA overlay's actual color.

## Exact coordinate contract (1280×720 game screen)

Source of truth: `scripts/battle/court_of_the_mute_floor.gd`.

| Object | Coordinate space | Bounds |
|---|---|---|
| Lower combat floor | Screen / F6 overlay | `Rect2(Vector2(40, 532), Vector2(1228, 178))` → x40–1268, y532–710 |
| Same combat floor | `UnitsLayer` local (screen - 20,96) | `Rect2(Vector2(20, 436), Vector2(1228, 178))` |
| Hero draggable lane before Fight | `UnitsLayer` local | `Rect2(Vector2(140, 442), Vector2(395, 51))` |
| Hero/enemy spawning before Fight | `UnitsLayer` local | Proportional original authored y-depth → local floor y461–471, screen y557–567 |
| Pre-fight HUD | Screen | Existing tactics HUD y574–710, unchanged for all cards |

**Reason for shallow initial deployment:** The current shared Battle UI covers much of the lowest stone floor while choosing tactics. All parties start **above HUD y574** on the lower floor, preserving both authored horizontal deployment patterns. When Fight begins the HUD hides, and **actual BattleUnit AI is free to move over the entire x40–1268 / y532–710 lower-floor rectangle**. This deliberately avoids walking on the stone dais as well as silently hiding characters behind the preparation controls. If user-native F6 feedback requests more room, adjust Court layout/UI together, never relocate units back onto staircase.

Implementation:
- `scripts/battle/court_of_the_mute_floor.gd`: one scoped shared coordinate contract.
- `scripts/battle/battle.gd`: `_get_combat_bounds` and `_get_placement_regions` use Court-specific constants; `_project_spawn_on_floor` places Court roles in the visible lower-floor strip only. All other encounter defaults and their special floor handlers are unchanged.
- `scripts/dev/court_of_the_mute_d263_empty_arena_preview.gd`: preview overlay reads exactly the same `SCREEN_COMBAT_BOUNDS`, moves its instruction label from the floor to the top, retains the previously selected **D261 card art unchanged**.
- `scripts/dev/court_of_the_mute_d262_real_battle_boot.gd`: all 6 real Godot Battle setups verify the shared lower bounds, actor floor contact, permitted hero drag region and no spawn under tactics panel. D262 mark/focus tests retained.
- `.github/workflows/d263-court-native-preview.yml`: looks for updated D264 preview marker after moving overlay. Initial failed run was a stale expected marker; corrected and rerun. A second initial failed contract was malformed GDScript indentation in a newly added `match` arm; corrected and rerun. Both **PASS** afterward.

## Native test evidence

- [Court preview native Godot 4.7.2 PASS](https://github.com/zampolit73/Misdeal/actions/runs/39221367512): new actual F6 preview screen bounds and original chosen card texture decode correctly.
- [Six-party/formation real Battle native PASS](https://github.com/zampolit73/Misdeal/actions/runs/39221531626): Godot parser/import, D262 verdict warning/active/kill contract, **six** original court Battle setups with explicit bottom-floor/HUD-safe assertions and 54-case regression of released card #38. Separate unrelated `res://assets/concepts/approved_battle_direction.jpg` import warning remains, not a new source parse failure.

## Local review / next

`git pull` → F6 `res://scenes/dev/court_of_the_mute_d263_empty_arena_preview.tscn` → press **G**. The green overlay should now match the user's **red bottom rectangle**, and stairs/throne must be entirely above it. The native game view was not visually observed post-change; official headless CI only verifies geometry and scene integration.

**NEXT D264 art proper:** Finish three genuinely original 25-frame transparent character atlases (Magistrate, Scrivener, Bailiff) and a richer, actor-free Court arena. Current D263 pixel background remains just a geometry QA candidate; no art release or character registration. Preserve the chosen D261 second card art, D260 #38 release, DS2/Fate Spread, LIVE **38/45**, and **KARAMBA73**. Only after art, true-scale Godot F6 and encounter balance will card #39 be released.
