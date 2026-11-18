# Combat Planning UX V2 | Native review

The V1 captures showed tactic names in the squad summary and kept the target, trigger and duration in the selected slot. The selector also returned to slot I when changing heroes. In battle, the notice said only that an order had changed. The result opened on a technical log, and repeating a battle lost every explicit target. [V1 editor and battle captures](../combat-planning-pilot/README.md).

V2 puts each hero's sequence on a single row. The upper editor leaves those rows and the arena available, and choosing an enemy temporarily collapses both panels. The first native pass exposed clipped second lines and overlapping full-name enemy markers. Fixed-height tiles now give each line its own place, numbered badges distinguish candidates, and the actual wizard objective remains visible. The result opens on observed HP, kills, transitions and deaths, with the timeline one click away.

| Scenario | V1 | V2 |
|---|---|---|
| Read all details for nine populated orders | 10 navigation clicks from Knight I: two hero selections at two clicks each and six slot clicks | 0 clicks |
| Change the target and increment the limit for Ranger I | 5 actions: open hero list, pick Ranger, arm target, click enemy, increment limit | 4 actions: click Ranger I, arm target, click enemy, increment limit |
| Change one order after defeat | Reopen editor, select hero and stage if needed, restore any explicit target lost on replay | «Изменить план», then click the exact order. Matching targets are restored |
| Plan for solo | One hero in the selector | One visible row, with only the next addable order exposed |
| First launch | «Свой план» with initial one-order defaults | Editable staged example with the meaning of each preset explained in setup |

Counts measure pointer actions from preparation, with an existing nonfinal Ranger I and a one-second adjustment. They measure navigation cost rather than player reading speed or preference.

- [Trio overview](ux_overview.jpg), [single order](ux_order.jpg), [enemy selection](ux_target.jpg)
- [Live HUD](real_engine_live.jpg), [loss summary](report_grave_bell_staged.jpg), [win summary](report_grave_bell_assault.jpg), [expanded chronology](ux_chronology.jpg)
- [Solo](ux_solo.jpg), [960×540 window](ux_small_window.jpg)

All screenshots come from the Godot 4.7.2 native renderer. The primary window is 1280×720. The smaller PNG was captured after resizing the actual window to 960×540. GUT passed 313/313 tests. The native runner covers solo/duo/trio, controls, actual arena selection and cancellation, F9 and edit retry, cross-encounter and cross-wave reset, reports, 15 reference battles and the actual Iron Wall wave break. Windows still reports its existing root-certificate-store diagnostic during startup.
