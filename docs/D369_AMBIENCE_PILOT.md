> **RELEASE VERIFIED 2026-10-28:** [D369 PR #34](https://github.com/zampolit73/Misdeal/pull/34) merged `44f2e0b` into `main`; [Godot 4.7.2 CI 72/72 PASS](https://github.com/zampolit73/Misdeal/actions/runs/40711701797) after checking **256044-byte** valid source RIFF/WAV for each of the three 8s loops. Import/parse, GUT, native smoke and screenshots PASS. Historical candidate/CI-pending text below is superseded. **Local sound-quality approval remains OPEN.** No music and no separate full RELEASE combat matrix.

# D369 — quiet environmental audio for Act I (2026-10-28)

## Creative direction and scope

Original **digitally synthesized 8-second 16 kHz mono WAV loops**, not location recordings, cinematic music, melodies or a guaranteed acoustic-quality approval. Three different low-density environments: `castle` (muffled stone/wood air), `courtyard` (soft wind over paving), `ossuary` (very low subterranean draft / occasional bone settling). Designed to sit *behind* combat and the user-approved B — Oak card gestures; do not amplify to compete with active events.

Three files: `assets/audio/ambience/d369_{castle,courtyard,ossuary}_roomtone.wav`. They loop continuously only after entering an actual location, not in the main menu, and are silent while no scene has claimed a location. The constant sound is roomtone, **not a constant soundtrack**.

## Runtime routing

- Existing autoload `SoundDirector` now loads/caches each ambience WAV on demand, sets `AudioStreamWAV.LOOP_FORWARD`, preserves the independent `Ambience` bus, crossfades between two persistent audio players over 1.6 seconds and guards redundant re-entry. Voices themselves are -16 dB relative to the Ambience bus (layout default -10 dB, ~-26 dB combined).
- `scripts/table/table.gd` selects `castle` on normal table entry. `scripts/battle/battle.gd` uses the already-real `EncounterData.arena_id`, **not random guesses**. Outdoor ids such as `firing_square` and `graveyard` select `courtyard`; ossuary/crypt/warden/bone ritual ids select `ossuary`; other interiors such as `iron_wall` and `last_bell` select `castle`.
- `SceneTransition` selects castle for event/reward screens, gracefully silences for intro/class select/main/run-end. It does not override table/battle's precise context. Old and new scenes overlap behind a transition veil, while the autoload carries the continuous fade.
- Complete audio isolation: UI/Oak and D368 Combat bus/cues/voice priority unchanged. No visual/UI rearrangement, card or encounter mechanics, Fate Spread or DS3 changes.
- `SoundDirector.set_channel_volume("Ambience", 0.0)` mutes all ambience; QA scene slider 0–100% is a real session control.

## Local acoustic review

After CI and release: `git pull` and F6 `scenes/dev/d369_ambience_audition.tscn`. Press Castle/Courtyard/Ossuary/Silence and listen **at least one full 8-second loop**, plus a crossfade. Adjust only Ambience slider; note that at default volume it will be subtle. In F5, hear low interior air on the cursed table, slight open wind on Firing Square, and subdued subterranean draft in an ossuary/boss encounter; return to table after battle. Important: none should cover card Oak, four-archer volley, real healing bells, voice or loot/outcome.

**Sound quality has not been approved by a human ear.** The waveforms are synthesized prototypes; native Godot test/audio import success never proves the desired acoustic experience. If the roomtone sounds electronic, repetitive, shrill or tiring, refine the WAVs or replace with properly sourced/licensed acoustic recordings on feedback. Do not import stock music or change the user's approved sound palette without discussion.

## CI / QA

`tests/unit/test_d369_ambience.gd` includes stream import/length, idle silence/bus, authored arena routing, cached looping/idempotence, crossfade/silence, real production hook checks and F6 audition scene. The repo's actual GitHub Actions Godot 4.7.2 import/parse, GUT, scene smokes and screenshots must pass before merge; no release PASS is presumed in this candidate spec. Subjective F6/F5 ear QA is a separate open gate. User ear review for D368 combat foley and B Oak live-table mix **also still remains open**.

## Later

One cohesive acoustic retune after player feedback, not repeated micro-approval of every loop. Then return to core A1P3 human 12+XIII run and full independently dispatched RELEASE battle/animation matrix. No UI/visual or gameplay expansion under D369.
