# D370 — D369 ambience inaudible on the player's system

**Released:** [PR #35](https://github.com/zampolit73/Misdeal/pull/35) squash `0a1b0034801a596b001e00570aeed75fb8ba6916`, [native Godot 4.7.2 CI SUCCESS](https://github.com/zampolit73/Misdeal/actions/runs/40732846429) 75/75 GUT and native smoke/screenshots. **Subjective device listening not yet complete.**

## Root cause and exact fix

D369 ambient WAVs are original 8-second mono roomtone synths with very weak naturalistic source levels. `scripts/audio/sound_director.gd` used `AMBIENCE_VOICE_DB = -16.0`, and `default_bus_layout.tres` used `bus/3/volume_db = -10.0`. This is **-26dB of attenuation before the low-energy PCM**, functionally inaudible in many speaker setups. The D369 F6 scene also did not auto-play any sound until a location button was pressed.

D370 changes the voice gain to `-2.0dB` and the bus default to `-3.0dB`, together **+21 dB** louder than D369 with the same WAV files. The F6 scene immediately calls `SoundDirector.set_location("castle")`. It adds **ПРОВЕРИТЬ ЗВУК** as an explicit short 660Hz signal played by a new AudioStreamPlayer on the *same* `Ambience` bus, with visible live bus dB. If the slider is almost muted, the test button restores a usable volume. All existing scene-based routing and crossfades remain intact; Combat and UI/Oak are unchanged.

Three new GUT regressions test bus/voice stage gain, source PCM non-silence and the calibration tone PCM/preview startup. **CI tests cannot detect host output device issues or judge acoustic taste**; use the probe to distinguish them.

## Player test

1. `git pull`, Godot 4.7.x, F6 `scenes/dev/d369_ambience_audition.tscn`. Castle ambience starts immediately.
2. Press **ПРОВЕРИТЬ ЗВУК**. A brief clear calibration beep should play. If **no beep**, inspect Godot Master/Ambience bus mute, OS mixer, selected output device and sound driver; an ambient-file retune will not cure an inaudible test beep.
3. If the beep works, listen to Castle, Courtyard and Ossuary with the slider at 70–100%, then F5 live table and battlefield. If beep audible but rooms not, refine the authored roomtones based on that finding.
4. Compare to B Oak card sounds and D368 combat and note any annoyance/repetitive noise. This fix is about **audibility**, not a subjective sound-style approval.

**Untouched:** game mechanics, art, DS3/Fate Spread, D365 quiet combat VFX, original approved B Oak sounds, D368 combat foley, no soundtrack. The full Act I 12+XIII player run and independently dispatched RELEASE combat/animation matrix are still outstanding.
