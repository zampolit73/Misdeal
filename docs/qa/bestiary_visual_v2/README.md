# Bestiary Visual V2

On `feature/bestiary-visual-v2`, open **F5 → Архив Волшебника → Бестиарий**. Down moves from the tab to a niche. Use arrows and Enter, or click a portrait. Use the page chevrons or Page Up / Page Down to turn pages. Esc returns to the menu.

| Godot 4.7.2, native 1280×720 | Capture |
| --- | --- |
| Empty profile, 0/26 | [Page 1](bestiary_00.webp) |
| Partial profile, 8/26, Grave Bellkeeper | [Page 2](bestiary_08.webp) |
| Complete profile, 26/26, Bone Warden XIII | [Page 1](bestiary_26.webp) |
| Complete profile, final two entries and ten inert niches | [Page 3](bestiary_page_3.webp) |

Compared the native screenshots with the [approved concept](../../../assets/source_archive/wizard_bestiary_v2/approved_reference.png) and the [supplied clean plate](../../../assets/pixel/ui/wizard_bestiary_v2/bestiary_plate.webp). The UI follows the [package coordinates](../../../assets/pixel/ui/wizard_bestiary_v2/layout_1280x720.json), using full-body in-game pixel sprites instead of the concept portraits. Selection brightens only the supplied arch mask. [Art pack and SHA-256 manifest](../../../assets/source_archive/wizard_bestiary_v2/)

The 26 real entries retain their existing order, discovery flags, names and combat descriptions. All 26 use full idle frames from 24 approved D420 roles. Bone Raider shares the Bone Thrall role, and Crypt Sentinel shares the Crypt Guard role, as defined in their production UnitData resources. Portraits trim empty alpha margins and use nearest-neighbor filtering.

Native QA used isolated saved profiles. It checked 26 entries and their sprite pixels, concealed details of undiscovered enemies, all three pages, mouse and keyboard selection, the unchanged Reliquary plate, the two list tabs, Esc, and profile hashes before and after browsing. Headless import completed. The existing Gameplay Meta capture passed with the updated selection after a real XIII fight. The engine reported a Windows certificate-store warning and a resource cleanup diagnostic at the end of the Gameplay Meta run.
