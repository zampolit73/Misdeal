# Wizard Archive Visual V2.1

Run F5 → **АРХИВ ВОЛШЕБНИКА** → **Реликварий** on the review branch. Down enters the cabinet. Use the arrow keys and Enter, or click a niche. Esc returns to the menu.

| Evidence | Capture |
| --- | --- |
| Godot 4.7.2, empty profile | [0/13](reliquary_00.webp) |
| Godot 4.7.2, partial profile with Shield of the Dead selected | [6/13](reliquary_06.webp) |
| Godot 4.7.2, complete profile | [13/13](reliquary_13.webp) |
| Visual target | [Approved concept](../../../assets/source_archive/wizard_archive_v21/approved_reference.png) |
| Runtime artwork | [Clean plate](../../../assets/pixel/ui/wizard_archive_v21/reliquary_plate.webp) |

The supplied [layout JSON](../../../assets/pixel/ui/wizard_archive_v21/layout_1280x720.json) positions Godot buttons, labels, art and the prepared navigation and arch states in 1280×720 design pixels. The 5+4+4 niches are from the supplied clean plate. The approved concept has illustrative item data and a different row count. The game places the 13 existing catalog images on the matching cushions, using the bounds of the visible pixels. The right panel shows the actual resource text, with a bounded scroll area for long effects. The other three tabs retain their existing list content below the shared navigation.

Compared the native frames with the concept and clean plate. Removed the old square niches, stacked frames and second title. The native frames show the supplied arches, the selected arc, live labels and the count inside the parchment plaque. Final artistic approval remains with the player.

Verified headless import and a native 1280×720 launch on Godot 4.7.2. Using isolated profiles, checked 13 niche positions and artwork baselines, selection by mouse and keyboard, all four tabs, Esc and that browsing did not change the profile file. Godot reported the environment's Windows root-certificate-store warning.

The [cabinet master](../../../assets/source_archive/wizard_archive_v21/cabinet_master.png), reference and runtime assets were copied from the supplied package. Both source PNGs match [the supplied provenance hashes](provenance.json). The clean plate SHA-256 is `7e796888cfc43572e0cc1772379d3dd05ec734c9efd84728ce28e93f96b2472a`.
