# D371 — roomtone audibility and local-version diagnostics

**Merged**: [PR #36](https://github.com/zampolit73/Misdeal/pull/36) squash `ba1ff4fa6b770f3ff24cf52a747a642695751060`; [native Godot 4.7.2 Actions SUCCESS 78/78](https://github.com/zampolit73/Misdeal/actions/runs/40767000965), import/GDScript parse, relevant smokes and native scene capture. **Not a human acoustic PASS**.

## Why this pass happened

The player reported that after D370 it seemed nothing had changed, despite the mixer hotfix being merged. Cannot prove from GitHub whether their local `git pull` succeeded. The F5 screens were intentionally unchanged, and original roomtone PCM remained hard to hear. Instead of another blind bus-gain tweak, D371 makes local build version and playback chain verifiable, *and* increases actual source sound energy.

## What changed

- New original **synthetic** 8-second mono 16kHz WAV roomtones on existing three paths: `assets/audio/ambience/d369_castle_roomtone.wav`, `d369_courtyard_roomtone.wav`, `d369_ossuary_roomtone.wav`. Measured target source RMS approximately **0.086 / 0.099 / 0.078** (all not near-silent), room-specific sparse wind/stone creak/rattle and tapered loop endpoints. No music. Retains current -2dB voice and -3dB bus mix.
- Same F6 scene path `scenes/dev/d369_ambience_audition.tscn` now has an obvious `D371 — АУДИО-ДИАГНОСТИКА` large header and build marker. Starts castle roomtone and sets Ambience bus to 100% for QA, **restores original session volume on exit**.
- Separate short calibration tone buttons **ТЕСТ 1 — MASTER** (direct to Master) and **ТЕСТ 2 — AMBIENCE** (to existing Ambience bus), plus bus presence/current dB, stream/player-playing state and live left channel peak readout. This is a DEV/F6 screen only.
- `SoundDirector.set_location` will restart a previously stopped location if its audio player is not playing; avoids old cached state suppressing re-play.
- Three additional native GUT regressions: waveform RMS threshold, real director status and two distinct bus playback paths. **78/78 total**.

## User test and deterministic diagnosis

After `git pull` in the **correct local repository**, F6 the above scene. Confirm **D371** big title exists. If it still says D369 or the new buttons are absent, **stop diagnosing WAVs** and inspect `git pull` output, local branch/HEAD and potential locally changed files (historically `project.godot` could block pull). Do not have user manually rewrite code.

If D371 appears, use **ТЕСТ 1 — MASTER**, then **ТЕСТ 2 — AMBIENCE** and report audible/inaudible separately; the live `ПЛЕЕРЫ/ПИКИ` row distinguishes a loaded/playing stream from a bus with no signal. If both probes audible but background still silent, revisit perceived timbre and roomtone gain based on real device. If neither is audible, inspect selected Windows output device, Godot Master mute, OS sound mixer/headphones. If only MASTER is audible, inspect Ambience bus level/mute/send. Finally F5 actual table → outdoor Firing Square → ossuary/catacombs. Do not assert speaker playback passed without feedback.

All original approved Oak B UI SFX, D368 combat foley, D365 combat visual restraint and DS3/Fate card flow remain untouched. Full A1P3 human 12+XIII and separately dispatched RELEASE battle/animation matrix remain open.
