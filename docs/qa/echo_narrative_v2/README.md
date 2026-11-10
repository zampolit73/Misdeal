# Echo of the Siege — Narrative V2 QA

Delivery: [PR #100](https://github.com/zampolit73/Misdeal/pull/100), [required checks](https://github.com/zampolit73/Misdeal/pull/100/checks).

Five short card hooks, separate compact scene dialogue, the five approved Wizard lines and all fifteen choice labels/results are implemented. Read-mail title shortened to «Прочитать письма» after native inspection caught truncation. Event prose remains in the original footer; approved art and UI layout are retained. No code below `available()` in the event contract changed; numbers, availability, facts, order/debt and old save outcome keys are identical.

Local Godot 4.7.2: full pre-final-regression GUT 265/265 (71,284 assertions), final focused 10/10 (885). Existing tests cover all fifteen buttons across solo/duo/trio, blocked choices, effects, clues, actual movement, repeat-input safety and disk save/load. New regression guards all ten runtime art hashes and actual scene-vs-card text separation. Existing 19 full-suite warnings are retained.

Native GL Compatibility 1280×720: complete 45-state table/event/choice/return/unavailable sequence. QA waits for the real SceneTransition busy flag and another 30 frames before reading the framebuffer, avoiding mid-fade screenshots. Representative event frames in this directory; complete native capture is also uploaded by RELEASE CI. No manual complete randomized F5 playthrough is claimed.

F6: open `scenes/dev/final_five_playtest.tscn` in Godot 4.7.x. Set wallet 50 and debt ON; open each of Знамя на бинты, Запертая почта, Чужие сапоги, Неверные гири, Погасший сигнал. Inspect description/Wizard, all choices and outcomes. Set wallet 0 to inspect costs; set debt OFF for blocked promise choice. Existing QA save isolation applies. Original dirty Living Arenas checkout was not modified; implementation is in the managed `echo-narrative-v2/Misdeal` worktree.

Full RELEASE CI must pass before merge; the linked final-head checks are authoritative.
