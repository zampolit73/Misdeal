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

## Future entries

Add the registry ID, actual work title, author, original source, license,
changes and relevant copyright/NOTICE text before distribution. Use the
upstream license verbatim in the original license file rather than
reconstructing it from this summary.
