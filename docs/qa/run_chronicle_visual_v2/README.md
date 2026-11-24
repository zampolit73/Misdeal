# Run Chronicle Visual V2

On `feature/run-chronicle-visual-v2`, open **F5 → Архив Волшебника → Летопись забегов**. Click a record or use Down to focus the list and Enter to select. The chevrons and Page Up / Page Down turn pages. Esc returns to the main menu.

| Godot 4.7.2 at 1280×720 | Capture |
| --- | --- |
| Empty history | [Empty](chronicle_empty.webp) |
| XIII victory with three heroes and all 13 relics | [Victory](chronicle_victory.webp) |
| Defeat at XI with Last Deal used | [Defeat](chronicle_defeat.webp) |
| Two oldest runs on a partial second page | [Page 2](chronicle_page_2.webp) |

The runtime uses the supplied [plate and layout](../../../assets/pixel/ui/wizard_chronicle_v2/). The supplied [concept, clean master and SHA-256 manifest](../../../assets/source_archive/wizard_chronicle_v2/) are archived separately. The castle and wax seal are decorative. The hero thumbnails come from the D413 dossier and the item icons come from ArtifactArtCatalog.

Native QA compared all four captures with the clean plate and approved concept. Two isolated profiles, one empty and one containing seven fixture records, exercised persistence and newest-first ordering, the recorded XIII result and a loss at XI, page controls, three portraits, 13 real relic textures, all four tabs and Esc. Profile hashes matched before and after browsing. The fixture wrote archive records through the existing save path and did not simulate combat. Godot reported the environment’s Windows certificate-store diagnostic during both import and launch.

The progress numerals emphasize only the reached card. The remaining details use the existing saved date, party, relics, style, oath, and Last Deal flag. Final artistic acceptance remains with the player.
