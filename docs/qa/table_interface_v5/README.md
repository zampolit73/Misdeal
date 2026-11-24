# Table Interface V5

Start or continue a run in F5 on `feature/table-interface-v5`. After the deal, click the journal, window or grimoire, or press Tab, M or A. Close the Archive with **К столу [Esc]**. A full-screen archive opened from the main menu retains **В меню [Esc]**.

| Native Godot 4.7.2 at 1280×720 | Capture |
| --- | --- |
| Live table with unopened Memory (0/24) | [Table](table_00.webp) |
| Light accent from the first unlocked memory | [Memory pulse](table_memory_pulse.webp) |
| The held card before opening the Archive | [Before](table_held.webp) |
| Existing Archive over the live table | [Archive](table_archive.webp) |
| The same deal and hold after Esc | [After](table_return.webp) |
| Nine seconds of interaction recorded by Godot Movie Maker | [Silent 1280×720 recording, MJPEG AVI, 28 MB](table_v5_demo.avi) |

Compared the live table with the [approved concept and production screenshot](../../../assets/source_archive/table_navigation_v5/) and the [supplied layout](../../../assets/pixel/ui/table_navigation_v5/layout_1280x720.json). The cutouts use the package coordinates over the original backdrop. Both silhouettes and their focus rims clear the card piles. The window light tracks the existing MemoryProfile count. The pulse eases back to the progress brightness and uses only the ornamental glass art.

Native QA used isolated run, archive and memory files. It checked mouse and hotkey access to all three destinations, input blocking during the opening deal, mutual exclusion of overlays, all four archive tabs, the Back button and Esc, and the normal close route from the main menu. A new memory was awarded through the existing profile code. An actual Hold and the full serialized run state matched before and after modal browsing. After closing the Archive, a real event still proceeded through Travel to a fresh deal. Godot reported the Windows certificate-store diagnostic and one cleanup warning in the focused run.

The existing D289 Table smoke passed with an additional Archive state check. The A1V2 Memory route passed at 0, 7 and 24 fragments with the updated local window bounds.
