# Wizard Archive Visual V2

F5 → **Архив Волшебника** → **Реликварий** on the review branch. Click a niche or move focus with the arrow keys and press Enter. Down from the Reliquary tab enters the cabinet. Esc returns to the menu. The three other archive tabs use the existing collections and readers.

| Collection | Native Godot 4.7.2 at 1280×720 |
| --- | --- |
| 0/13 | [Closed niches](reliquary_00.webp) |
| 6/13 | [Mixed collection](reliquary_06.webp) |
| 13/13 | [Full cabinet](reliquary_13.webp) |

Native QA opened separate temporary archive profiles, persisted and re-opened them, and launched the production scene. It checked 13 slots in each state, selection and current resource text, concealed identities and effects, all four tabs, keyboard focus, mouse selection and Esc. Headless import completed. The targeted Wizard Archive GUT suite passed 6/6 tests and 54 assertions. The sandbox prevented Godot from reading the Windows root certificate store.

`ArtifactData.description` provides each unlocked item's current player-facing effect. `WizardArchive` supplies collection membership and keeps its existing save format.

## Art sources

- The original nine relics, library, niche and parchment masters were generated for this pilot. Their PNGs live in [the source archive](../../../assets/source_archive/wizard_archive_v2/). The transparent relic sheet is packed into nine 192×192 WebP cells in [the runtime folder](../../../assets/pixel/ui/wizard_archive/).
- Shield, quiver and focus are cutouts of [the existing Curse Forge art](../../../assets/pixel/travel/batch_02/curse_forge/layers/canonical_artifacts.png). The crown is a cutout of [the existing Broken Crown art](../../../assets/pixel/travel/batch_02/broken_crown/small_props/layers/base_1280.png). The Archive uses those cutouts locally. Other screens still use the original `ArtifactArtCatalog` illustrations.
- The outer mount reuses the D413 dossier bronze frame. Locked slots share one cloth-covered silhouette so a niche's state never exposes its item.

The approved concept PNG was absent from the task attachment. The visual pass follows the written layout and material requirements. Side-by-side approval remains pending.
