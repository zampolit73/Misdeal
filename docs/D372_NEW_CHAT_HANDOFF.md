# Misdeal — CURRENT NEW CHAT HANDOFF (D371 audio diagnostics release, 2026-10-29)

**GitHub technical source of truth:** `zampolit73/Misdeal`, `main`. Start with `AGENTS.md`, `docs/CONCEPT.md`, `docs/PROJECT_STATE.md`, `docs/ROADMAP.md`, `docs/DECISIONS.md`, `docs/HANDOFF.md`, this file and `docs/D371_SOUND_DIAGNOSTICS.md`. Do not infer that locally installed changes match GitHub without the user's observed version.

## Why D371

User reported twice that newly added sound seemed absent or unchanged. D369 ambient PCM was very weak with -26dB total staging; D370 increased bus/voice gain by 21dB and added a single Ambience test tone, [PR #35](https://github.com/zampolit73/Misdeal/pull/35) 75/75 PASS. User then said **"как будто бы ни чего не добавилось и не изменилось"**. Whether local `git pull` completed, the F6 scene was selected, or Windows/Godot audio output worked is **unknown** — do not assume user mistake.

## Actual D371 production change

[D371 PR #36](https://github.com/zampolit73/Misdeal/pull/36) squash `ba1ff4fa6b770f3ff24cf52a747a642695751060` merged to main after [Godot 4.7.2 Actions SUCCESS **78/78**](https://github.com/zampolit73/Misdeal/actions/runs/40767000965), import/parse, native smoke and screenshots. Regenerated all 3 original synthetic 8-second castle/courtyard/ossuary ambient WAVs (RMS 0.086/0.099/0.078), preserved existing bus/voice -3/-2 dB, no music, changed none of Oak B or D368 combat. F6 same scene path `scenes/dev/d369_ambience_audition.tscn` now has a **huge D371 version header**; autoplays castle and temporarily sets preview bus to 100%; side-by-side **ТЕСТ 1 — MASTER** and **ТЕСТ 2 — AMBIENCE** beep through independently routed AudioStreamPlayers; displays player state and actual Godot AudioServer bus peaks. Restore volume on exit. SoundDirector now restarts a stopped cached location. New GUT asserts source RMS, diagnostics data, Master/Ambience preview. **Still waiting for local ear feedback; automated tests cannot confirm speaker playback.**

## Next user test / diagnosis

Only `git pull` locally, open F6 `scenes/dev/d369_ambience_audition.tscn`, confirm the **D371** title and try both tone buttons. If D371 missing: ask for output of `git pull` / `git log -1 --oneline`; earlier Windows local `project.godot` modifications blocked pulls, avoid forcing reset or overwriting user changes. If D371 present: compare audible MASTER and AMBIENCE tones and visible output peaks; then castle/courtyard/ossuary and F5. If only Master audible: bus routing. If neither: OS/Godot audio output. If both audible but no ambience: re-evaluate actual samples and volume based on user evidence. No need for a new visual/gameplay system. Never claim sounds were accepted without their report.

## Locked project constraints

Godot 4.7.x / GDScript. User-approved Oak B table audio via PR #32; D368 restrained combat foley via PR #33, six priority voices/archer family cooldown, human ear review still open. D365 forbids automatic cursor targeting beams and full-screen archer traces. DS3 painting/card design approved, exactly 12 Fate resolutions plus sealed XIII, Knight/Ranger/Mage, solo/duo/trio. A1P3 full human 12+XIII run and independently dispatched RELEASE battle/animation matrix still open. Update docs and main after substantive code, GitHub connected access should be used.
