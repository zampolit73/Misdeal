# D373 — recorded ambient Foley source credits, licenses and reproducibility

**2026-10-29.** The player listened to D372 and gave clear feedback: *only Courtyard — Wind and Stone is more or less acceptable*. Consequently **the Courtyard file is byte-for-byte unchanged**; Castle and Ossuary D372 synthesized attempts are replaced with *recording-derived* candidates, not a new algorithmically generated noise bed.

## Source recordings and source fingerprints

These files are redistributed as **edited composites** in the two 16-second scene WAVs at existing paths. We do not imply any external uploader endorses Misdeal. The original sources were retrieved directly from OpenGameArt.org on 2026-10-29. Full links and provenance are preserved here (not simply omitted because CC0 does not require credit).

| Output | Recorded source | Author | License | Original file SHA-256 | Changes |
|---|---|---|---|---|---|
| `d369_castle_roomtone.wav` | [Creaky light wooden door](https://opengameart.org/content/creaky-light-wooden-door) (`creakylightwoodendoor.wav`) | fractilegames | [CC BY 3.0](https://creativecommons.org/licenses/by/3.0/) | `9b0a91420015c2ae080ef6fd9a3bf8141dc897b4d05aa6488d4e23c13bae8335` | Extracted two segments of an actual creaking wooden cabinet door, normalized, downmixed to mono, resampled to 16kHz, timed 2–7 and 10–14 s; short decays |
| `d369_ossuary_roomtone.wav` | [Bones 2](https://opengameart.org/content/bones-2) (`bones-2.wav`) | AntumDeluge | [CC0 1.0](https://creativecommons.org/publicdomain/zero/1.0/) | `5022acbf2c075a20e293fed359324492224c79e65d38ca3427176ca8b3774c68` | Two separated, quieter clicks/rattles; original artist describes a bicycle wheel spoke sound that resembles bones, **not an actual recording of bones** |
| `d369_ossuary_roomtone.wav` | [Ambient Water Drips](https://opengameart.org/content/ambient-water-drips) (`amb_waterdrip_1.flac`) | Blender Foundation, from *Yo Frankie!* | [CC BY 3.0](https://creativecommons.org/licenses/by/3.0/) | `c19f99a1a9a6a2aecf294e3cdea87b223a4b165e3e23df9cea2985ab20a907d0` | Original recorded water-drop sample, cropped and mixed twice with the bone sound; resampled to mono 16kHz with short decays |
| `d369_courtyard_roomtone.wav` | D372 **original synthetically authored** scene | Misdeal project | Original | Previously shipped | **No change** |

The two edited works are waveform compositions not copies of complete originals. The CC BY 3.0 credit and links above must travel with the shipped game sources, docs and packaged game license information if redistributed.

## Exact outputs

- Castle: `assets/audio/ambience/d369_castle_roomtone.wav`, 16 seconds, mono 16kHz signed PCM16, 512044 bytes, SHA-256 `e246e807528d32db9b7b32ec178fe1b135eb0f65978e88e00beb8467b818bd94`.
- Ossuary: `assets/audio/ambience/d369_ossuary_roomtone.wav`, identical format, SHA-256 `09f7f774e8988d2dde984d0b048cfb665e07b851fe0224dae5846c042fff7113`.
- Courtyard original SHA-256 `b88ee52f8673b43a20a15cfa88cfd77ac60ad4c49c7bcb87a0dc4c9e5a50c4e6`.

Rebuild with `python tools/audio/build_d373_recorded_ambience.py` in an environment with `ffmpeg` or `imageio-ffmpeg==0.6.0` and `FFMPEG_EXE` pointing to that binary. The builder pins all three original source SHA256 fingerprints, verifies exact output WAV byte sizes and quiet/active RMS contrast, and checks the Courtyard fingerprint. The temporary GitHub Actions importer built these assets from recorded originals on the branch, and is excluded from the final source tree; rebuilding does not run automatically in the shipped game. Network access is needed **only for an explicit rebuild**, not to run the game.

## Audition & gate

F6: `scenes/dev/d369_ambience_audition.tscn`; large D373 title, Castle then Ossuary for a full 16 seconds and Courtyard for comparison. On the actual game sound system, listen for real close/distant wood movement and water drops, but **do not treat this as approved yet**. Check that the user-preferred courtyard sounds precisely the same as before. If the new recorded door sounds too light/domestic or the bone-like sound mechanical, swap recordings based on player ear review rather than another synthetic attempt. No new music. B Oak and D368 combat cues and all gameplay/DS3 graphics unchanged.
