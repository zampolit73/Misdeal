# Misdeal — third-party notices (working inventory)

This initial notice consolidates existing documented credits; it is **not**
a completed commercial-release clearance or an export-ready exhaustive list.
See [License Policy](docs/LICENSE_POLICY.md) and [registry](THIRD_PARTY_ASSETS.json).
Preserve the actual upstream license/copyright text when distributing.

## Godot — legacy-godot

Godot Engine contributors, MIT. The exact engine version's license and
third-party copyright notices must accompany the release; retain the actual
bundle from the export engine.
[Official guidance](https://docs.godotengine.org/en/stable/about/complying_with_licenses.html).

## GUT 9.7.1 — legacy-gut / legacy-gut-fonts

Tom "Butch" Wesley, MIT; version and pinned upstream commit documented
[in the project GUT guide](docs/GUT_TESTING.md).
[Original bundled MIT license](addons/gut/LICENSE.md).
The vendored Anonymous Pro font notice (Mark Simonson, OFL-1.1) is at
[addons/gut/fonts/OFL.txt](addons/gut/fonts/OFL.txt).
Check notices separately for the remaining GUT fonts, images and dependencies.
GUT is development tooling; exclude it from the commercial player export
where possible. Do not assume upstream MIT applies to all bundled assets.

## Third-party CC0 audio — legacy-act1-audio / legacy-combat-audio-v2 / legacy-combat-hotfix

Per-file authors, source links, edits and license evidence in the existing
[Third-party audio source ledger](docs/audio/THIRD_PARTY_AUDIO_LICENSES.md).
CC0-1.0 is declared there for contributions from Kenney, AntumDeluge,
bonebrah, Department64, JaggedStone, SketchMan3, artisticdude (submitted by
Ogrebane), Zane Little Music, Brian MacIntosh (BMacZero), Julie Damsgaard /
Spring Spring, Luke.RUSTLTD, saturdaysoundguy and JoeDinesSound.
[CC0 1.0](https://creativecommons.org/publicdomain/zero/1.0/).
Retain detailed per-file mapping and independently verify before release.

## Recorded ambience — legacy-d373-ambience

- **Creaky light wooden door** by **fractilegames** —
  [source](https://opengameart.org/content/creaky-light-wooden-door),
  [CC BY 3.0](https://creativecommons.org/licenses/by/3.0/).
  Cropped to two segments, normalized, downmixed, resampled and edited
  into the Castle composite `d369_castle_roomtone.wav`.
- **Bones 2** by **AntumDeluge** —
  [source](https://opengameart.org/content/bones-2),
  [CC0 1.0](https://creativecommons.org/publicdomain/zero/1.0/).
  Two edited rattles in the Ossuary composite.
- **Ambient Water Drips**, **Blender Foundation**, from *Yo Frankie!* —
  [source](https://opengameart.org/content/ambient-water-drips),
  [CC BY 3.0](https://creativecommons.org/licenses/by/3.0/).
  Cropped, mixed, resampled and edited into
  `d369_ossuary_roomtone.wav`.

See [D373 original source and output hashes](docs/D373_RECORDED_FOLEY_CREDITS.md).
D374 disabled default ambience playback, but the files are still tracked;
if distributed, these credits must accompany them.

## Project-origin road cinematic plate

`travel-v5-road-lost-purse-wide-generated`: Misdeal project / ChatGPT image generation, 2026-11-27. Only existing project reference art, no external ingredients. [Source and hashes](docs/qa/travel_road_v5/README.md); pending historical rights review is not commercial clearance.

## Project-origin rescue cinematic pose atlas

`travel-v5-rescue-living-poses-generated`: Misdeal project / ChatGPT image generation and sprite preparation, 2026-11-27. Four distinct poses per original character, generated from existing project-only references, packed to lossless WebP. [Provenance](docs/qa/travel_rescue_v5/README.md); historical source and tool rights review still pending for release.

## Project-origin Travel actor source-detail repack

`travel-actor-hd-source-repack`: Misdeal project / existing generated source artwork, source-detail packing on 2026-11-27. Seven 3× native-detail atlases derived from approved project characters, rear walks and rescue poses; no new external ingredient. [Source hashes and QA](docs/qa/travel_actor_hd/README.md). Legacy reference and tool rights review remains open for commercial release.

## Project-origin Borrowed Boots cobbler work cels

`travel-v5-squire-work-cels-generated`: Misdeal project / ChatGPT image generation and deterministic source preparation, 2026-11-28. Four original source-registered local work frames using only existing Misdeal artwork. [Source and hashes](docs/qa/travel_camp_v5/README.md); legacy source and tool rights review remains open.

## Project-origin Borrowed Boots wide cinematic

`travel-v5-boots-human-scale-wide-generated`: Misdeal project / ChatGPT image generation and deterministic source preparation, 2026-11-28. New empty wide environment and seven source-derived worksite/animation patches, project references only. [Provenance](docs/qa/travel_camp_v5/README.md); legacy reference and tool rights review pending.

## Project-origin Relic transaction wide cinematics

`travel-v5-relic-human-scale-wide-generated`: Misdeal project / ChatGPT image generation and deterministic source preparation, 2026-11-28. Three empty generated wide plates and thirteen original source-registered worksite cutouts. [Provenance](docs/qa/travel_relic_v5/README.md); legacy source and tool rights review pending.

## Future entries

Add the registry ID, actual work title, author, original source, license,
changes and relevant copyright/NOTICE text before distribution. Use the
upstream license verbatim in the original license file rather than
reconstructing it from this summary.
