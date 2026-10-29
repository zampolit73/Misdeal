> **D374 RELEASED AFTER PREVIOUS CANDIDATE (2026-10-29):** [PR #39](https://github.com/zampolit73/Misdeal/pull/39) merged, [Godot 4.7.2 native CI SUCCESS 84/84 GUT](https://github.com/zampolit73/Misdeal/actions/runs/40854842019); automatic location ambience disabled in real gameplay; F6 archived audition only. Latest continuation is now [D376_NEW_CHAT_HANDOFF.md](D376_NEW_CHAT_HANDOFF.md). Human F5 quiet-baseline acceptance still pending.

# Misdeal — D375 CURRENT NEW CHAT HANDOFF (D374 silent-first audio correction)

Repo `zampolit73/Misdeal` `main`, connected GitHub available. Read `AGENTS.md`, `docs/CONCEPT.md`, `docs/PROJECT_STATE.md`, `docs/ROADMAP.md`, `docs/DECISIONS.md`, `docs/HANDOFF.md`, this handoff and `docs/D374_SILENT_FIRST_AUDIO.md`. Godot 4.7.x GDScript, GitHub is code truth and user listening is design truth.

## Why immediate action was necessary
D369–D373 spent multiple passes making three locations audible. D373 used licensed recorded audio with provenance [D373_RECORDED_FOLEY_CREDITS.md](D373_RECORDED_FOLEY_CREDITS.md); CI 81/81 PASS. User tested the actual game and explicitly said **"звуки не подходят. нужно менять. они отвлекают и ломают атмосферу"**. The previous F6 marginal preference for Courtyard DOES NOT mean production approval. **ALL three automatic environmental ambiences rejected for F5.** Do not generate more random noise, synth Foley or mix up a forced soundtrack.

## D374 change
D374 `fix/d374-silent-first-atmosphere` sets `SoundDirector._location_ambience_enabled := false` by default. Normal table, battle, event/reward and SceneTransition can request location but nothing is loaded/played when disabled; scene code preserved, B Oak UI/table and D368 combat voices/buses unchanged. F6 `scenes/dev/d369_ambience_audition.tscn` now shows **D374 — БЕЗ НАВЯЗЧИВОГО ФОНА**, starts in silence, allows archived manual playback for QA only, restores previous mode/bus on exit. Old WAVs and legal credits retained for archival comparison. New GUT guards no runtime autoplay and reversible F6 preview. Check release PR / Godot 4.7.2 CI and merge before claiming shipped.

## Next user test and path
After merge, user `git pull`, **F5 normal game**. Listen to cursed table card/Oak sounds, battle action/D368, return-to-table and boss arena; verify **no repetitive ambient recording** and the game regains tension. Don't ask user to approve the old sounds. For a new direction, after quiet baseline is confirmed, develop separately audible *short contextual event cues* to compare in game, e.g. Wizard gestures/curse card reveal or boss threshold, not automatic location loops. No new music or endless sound beds without clear approval.

## Other ongoing constraints
Act I: 12 resolutions I–XII and sealed XIII Bone Warden; evil Wizard host, conditional Knight/Ranger/Mage solo/duo/trio. User approved DS3 card paintings, D365 forbids auto-cursor trails/archery tracers; B Oak selected table sound; D368 combat audible-quality review still open. A1P3 full human 12+XIII run and separate full RELEASE combat/animation matrix still outstanding. Update docs/change log and meaningful commits after changes; user should only need git pull and specific Godot QA.
