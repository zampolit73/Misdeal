> **RELEASE STATUS 2026-10-29:** [D372 PR #37](https://github.com/zampolit73/Misdeal/pull/37) merged `68223fa00dfcbde7e9f6196298ed12062017affe`, [native Godot 4.7.2 CI SUCCESS 79/79](https://github.com/zampolit73/Misdeal/actions/runs/40769450969), WAV import/source-duration/dynamic-contrast regressions, native smokes/screenshots. Initial candidate language below is historical. **Player ear acceptance OPEN; no claim of recorded Foley or confirmed naturalness.**

# D372 — sparse atmospheric sound scenes, not continuous hiss

## User feedback that drove this change
The D371 three location WAVs were **audible on the player's computer** but sounded like **white noise**. Therefore neither the Godot audio chain nor gain was the remaining root cause; the original broad-spectrum continuous ambient sound design was wrong. **Do not turn this noise up again.**

## Replacement arrangement (candidate until ear-reviewed)

Keep the existing stable `SoundDirector` route, `Ambience` bus, scene selectors and 1.6-second crossfade. Replace *only* the three already used WAV file paths with **16-second original digitally synthesized soundscapes**, mono signed PCM16 at 16 kHz (512044-byte RIFF each). No third-party recordings or license dependencies; these are **not** real field recordings and must not be described as such.

The distinguishing feature is *dynamic contrast and sparse spatial cues*. The first second of each clip is almost quiet; a low structural rumble sits far below intelligible transient cues. No continuous loud white/pink-noise bed; noise excitations are only short, shaped components within individual creaks/impacts/gusts.

- `castle`: wooden beam under strain about 2–4s and 10–12s; weighty door/stone strike at ~5s, softer scrape at ~7.5s, dull iron latch near 14s. Silence between events.
- `courtyard`: **two shaped** wind gusts around 1–4s and 8–12s; gate scrape and a loose metal latch, later smaller scrape and clang. Not endless unshaped hissing.
- `ossuary`: two clusters of muted dry bone-like ticks around 2–3s and 10–11s; very short resonant drops and echoes around 4.3 and 12.6s; an occasional deep creak/stone knock. More quiet than the courtyard.

Techniques: independent harmonic and inharmonic resonators, irregular glissando/stick-slip wood and metal bodies, exponentially decaying tap modes with low delay taps, gust-shaped sub-band noise *only during wind events*, tapered loop endpoints. No melodies, soundtrack, UI/visual modifications, new combat events, synthesized "music" or 3D audio positioning. Story is **suggested by materials**, not a pre-recorded realism claim.

## Test surface

The existing `scenes/dev/d369_ambience_audition.tscn` F6 room now displays **D372 — ЗВУКОВЫЕ СЦЕНЫ** and a sentence for each location that tells the player when to expect identifiable events. It retains the D371 Master vs Ambience diagnostic tones, live bus/voice/peak readouts and sets preview gain to 100% *only while the audition is open*, then restores channel gain. Debug status now includes playback position in seconds. This scene is for QA only, not a game screen.

GUT additions: WAV full length and valid PCM size; initial quiet second; at least 4× local dynamic energy contrast and a minimum audible local transient window; preview scene script identifies D372 cue descriptions. Engineering tests **cannot** verify whether physical-model synthetic creaks/drips are natural or pleasing to a human ear.

### Local listener test / acceptance
After native Godot CI and merging to `main`, `git pull`, F6 `scenes/dev/d369_ambience_audition.tscn`, verify header **D372**, select Castle, Courtyard, Ossuary and give *each* the full 16s. Confirm explicitly that there are recognisable isolated creaks/metal/knocks/bone/drips and no endless hiss. Then F5 real table, courtyard and ossuary boss. If they still sound like an oscillator/synth, replace with actually recorded or licensed CC0 foley in a **subsequent approved art-quality pass**, rather than raising noise or claiming that CI proves realism.

## Existing boundaries
Preserve B — Oak user-selected table cues, D368 sparse combat audio, D365 visual quietness, DS3 card art, all game mechanics and Fate Spread. Other open gates: A1P3 human 12+XIII and independent RELEASE combat/animation matrix.
