# D377 — Live F5 audio origin and checkout verification

## Player report
After D374 disabled **all** environment loops by default, user says **"Не увидел разницы"**. This has two possible immediate explanations: (1) the local Godot project is still an older Git checkout (there have been `project.godot` pull conflicts before), or (2) the distracting sound comes from `TableAudio` on `UI` or `CombatAudio` on `Combat`, or the user expected an atmospheric improvement rather than silence. **Do not declare any of these proven** based on GitHub CI.

## Verified repo architecture
- `scripts/audio/sound_director.gd`: location ambience `_location_ambience_enabled := false`, `set_location("castle"|"courtyard"|"ossuary")` no-ops during normal F5. All three rejected 16s WAVs remain archived for **manual F6** only.
- `scripts/table/table_audio.gd`: four event voices with user-selected B Oak deal and other short Oak-family UI cues, routed to `UI`.
- `scripts/battle/combat_audio.gd`: six priority combat voices with sampled/backup short SFX, routed to `Combat`.
- Scene files `scenes/table/table.tscn`, `scenes/battle/battle.tscn` bind the corresponding components. The default bus layout has Master, UI, Combat and Ambience.

## D377 temporary source inspector
[D377 PR #40](https://github.com/zampolit73/Misdeal/pull/40) merged `c9d60fc825d39b37d8302aeed14bb3c9a945dbc4` following [Godot 4.7.2 native CI SUCCESS 86/86](https://github.com/zampolit73/Misdeal/actions/runs/41191238662). `scripts/dev/d377_live_audio_probe.gd` is instantiated by `SoundDirector` only for its real `/root/SoundDirector` autoload **and only if `OS.is_debug_build()`** (Godot editor F5). It is invisible until **Ctrl+Shift+M** is pressed. A floating panel displays **D377 — ПРОВЕРКА ЗВУКА В ИГРЕ**, build marker, normal/muted buses, live playing `AudioStreamPlayer`/`AudioStreamPlayer2D` counts and `SoundDirector` ambient enable flag. Buttons switch between:
1. **ИСХОДНЫЙ МИКС** — restores original mute states from opening the diagnostic.
2. **ТОЛЬКО КАРТЫ / UI** — isolate UI; use while dealing/choosing cards.
3. **ТОЛЬКО БОЙ / COMBAT** — isolate Combat while a battle is running.
4. **ТОЛЬКО ОКРУЖЕНИЕ / AMBIENCE** — with D374 default off this should be silent; if not, investigate independently created ambience voice.
5. **ПОЛНАЯ ТИШИНА** — mute UI, Combat and Ambience; if sounds remain, a source may be routed directly to Master.

Press **Ctrl+Shift+M** again to close and restore original bus mute states. No new gameplay audio, no runtime mixer changes before the user chooses a mode, no production/release overlay and no change to DS3 aesthetics.

## Local user checklist
Run `git pull` from `C:\Users\irlix\GodotProjects\Misdeal`; F5 the **project** (do not F6 an archived sound booth), reach table, press **Ctrl+Shift+M**. If **D377 not present**, ask for `git pull` output and `git log -1 --oneline`; avoid destructive `git reset --hard`. If present, stay in the same action and A/B switch the relevant sound channels. Record precise audible channel and whether "Silence" actually gives silence, and optionally a screenshot of the panel. Then propose **only one focused fix** tied to the identified sound. Native 86/86 CI certifies code mechanics, not local playback.

## Other constraints
User rejected all D373 location loops during F5, including the relatively preferred Courtyard clip. Preserve B Oak as selected and D368 combat until concrete channel feedback; do not add or modify atmosphere, music or endless recordings by guesswork. A1P3 full human 12 Fate Spread resolutions I–XII and sealed boss XIII and independently dispatched full RELEASE authored battle/animation matrix are still open.
