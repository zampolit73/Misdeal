# D377 — Audio source A/B diagnostic inside real F5 gameplay

## User report and verified findings

After D374 silent-first ambient-loop removal, the player said **"Не увидел разницы"**. **Do not assume that a Windows `git pull` happened** or that this is about visual appearance. Github `main` at intake is `1b97321`: D374 `SoundDirector._location_ambience_enabled := false` is correct and the 3 location WAVs **cannot** autoplay in normal game; it's intentional that visuals and the pre-existing Oak/table and D368 combat cues did not change.

Reviewed the actual scene wiring:
- `scripts/table/table.gd` calls `TableAudio.play_event` and the `scenes/table/table.tscn` contains `TableAudio`, which routes all one-shots on bus `UI` with approved B — Oak deal WAV and synthetic fallback/select/discard details.
- `scripts/battle/battle.gd` and `scripts/battle/unit.gd` call `CombatAudio.play_event` / group `combat_audio`; `scenes/battle/battle.tscn` owns `CombatAudio`, routed to `Combat` bus. These are short event SFX, **not** environmental loops; their timbre was never accepted during a full live run.
- `SoundDirector` has 2 `Ambience` players, disabled in F5. No second permanent ambience player found in normal Table/Battle scene files.

## Implemented F5 diagnostic (not a new sound direction)

In Godot **debug F5** running game, press **Ctrl+Shift+F10**. This displays a temporary, dark translucent top-right panel **D377 — ЗВУК В РЕАЛЬНОЙ ИГРЕ** with explicit build marker, current scene, disabled/enabled ambience state, bus peaks and active AudioStreamPlayer voice counts. Panel is invisible unless deliberately summoned and cannot appear in exported non-debug builds.

Four A/B modes affect **bus mute only** and do not create new audio:
- **ОБЫЧНЫЙ ЗВУК**: original UI, Combat, Ambience, Master mute settings as they were before opening;
- **ТОЛЬКО КАРТЫ / UI**: Combat and Ambience muted; only UI-related voices can be heard;
- **ТОЛЬКО БОЙ / COMBAT**: UI and Ambience muted; combat audible;
- **ПОЛНАЯ ТИШИНА**: Master mute; game-generated sound silent.

Press **Ctrl+Shift+F10** again to close; all original bus mute states are restored. The overlay is not part of any .tscn normal scene and does not change gameplay/AI/art, ambient routing, volume gains, Oak source WAV, D368 source WAV, or add music. Auto scene changes do not remove this autoload-owned QA panel.

## QA and interpretation

Native Godot 4.7.2 PR CI must confirm parsing, full GUT and relevant smokes. New GUT tests verify build marker, explicit hotkey, read-only default, reversible UI/Combat/Master modes, and original scene presence. **A passing CI does not certify the user's mix.**

Ask the player to `git pull`, start **F5**, press **Ctrl+Shift+F10**, verify heading D377, compare **ОБЫЧНЫЙ ЗВУК** vs **ПОЛНАЯ ТИШИНА** at card table; then compare UI-only there, and Combat-only in fight. Report which mode restores atmosphere or which mode is distracting. If D377 panel is absent, collect `git pull` and `git log -1 --oneline` output first rather than changing audio. If all modes sound the same even after Master mute, check OS/game instance and debugging input. Do not treat this diagnostic as a long-term UI feature.

## Next design work

User rejected D373 location Foley and D374 did not produce a noticeable improvement. **Do not invent a new score** or remix automatically. The next sound design decision must be driven by real live A/B listening, potentially reducing *Combat* or *UI* material in specific gameplay situations, while preserving B — Oak deal until specific feedback changes it. A1P3 real human 12+XIII, independent RELEASE authored matrix are still open.
