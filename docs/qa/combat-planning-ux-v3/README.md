# Combat Planning UX V3 — native review

V2 kept the 151 px overview and added a separate 125 px editor at y=145. V3 replaces the overview in the same bottom panel. At 1280×720 the panel begins at y=563 for the trio overview, y=584 for editing and y=670 for target picking. The title, wizard objective, units and HP remain in the existing arena layout. The overview keeps light backgrounds on order cells and reserves bronze outlines for hover and focus.

| State | V2 | V3 |
|---|---|---|
| Overview | [Trio board](../combat-planning-ux-v2/ux_overview.jpg) | [Trio board](ux_v3_overview.png) |
| Edit | [Separate upper editor and lower board](../combat-planning-ux-v2/ux_order.jpg) | [Lower editor only](ux_v3_edit_order.png) |
| Target | [Upper prompt](../combat-planning-ux-v2/ux_target.jpg) | [Single lower line](ux_v3_target_picker.png) |

[Solo](ux_v3_solo.png) · [Duo](ux_v3_duo.png) · [Combat HUD](ux_v3_combat.png) · [Iron Wall intermission](ux_v3_intermission.png) · [960×540 overview](ux_v3_small_window.png)

Godot 4.7.2 native checks click Ranger II, type a limit without pressing Enter and verify the new tactic and limit on return. They assign the Bellkeeper to Mage I through the arena, verify Escape and button cancellation, clear the target and check rebinding and scope changes. They also start a real fight from the board, click «Изменить план» after a controlled defeat and exercise the same two preparation modes between real waves. The runner checks that active pages share one parent, only one page is visible at each step, and the panel sits below the living units. The 15 controlled Grave Bell comparisons preserve legacy assault parity for solo, duo and trio. The existing combat rules have their original GUT coverage.
