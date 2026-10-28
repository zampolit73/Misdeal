> **SUPERSEDED BY D370 AUDIBILITY FIX (2026-10-28):** User reported no audible D369 ambient sound despite CI. [PR #35](https://github.com/zampolit73/Misdeal/pull/35) merged, [75/75 native Godot CI](https://github.com/zampolit73/Misdeal/actions/runs/40732846429); first fix was gain stacking (-26dB to -5dB), plus auto-start and an explicit Ambience-bus diagnostic tone in F6. Real listening still pending. **Current checkpoint is [D371_NEW_CHAT_HANDOFF.md](D371_NEW_CHAT_HANDOFF.md).**

# Misdeal — CURRENT NEW CHAT HANDOFF (D369 release; 2026-10-28)

## First reads

Repository `zampolit73/Misdeal`, branch `main`. Read `AGENTS.md`, `docs/CONCEPT.md`, `docs/PROJECT_STATE.md`, `docs/ROADMAP.md`, `docs/DECISIONS.md`, this file, then `docs/D369_AMBIENCE_PILOT.md` and `docs/D368_COMBAT_FOLEY.md`. GitHub is the technical truth. Earlier candidate and pre-release dated sections are historical.

## Current live audio (engineering verification, not subjective ear approval)

- **D367B Oak**: B — Oak user selected and approved, live card `deal/select/discard/meddle/milestone` via PR #32, approved base deal exact WAV; still awaiting complete local F5 volume/repetition check.
- **D368**: [PR #33](https://github.com/zampolit73/Misdeal/pull/33) merged `20368dd`, [Godot 4.7.2 CI 65/65](https://github.com/zampolit73/Misdeal/actions/runs/40705404555). Eight sparse original dry **synthetic** combat cues, six priority-aware voices, shared 155ms archer cooldown, alternating bow releases and fallbacks; `scenes/dev/d368_combat_audio_audition.tscn`. User F6/F5 listening **not yet accepted**.
- **D369**: [PR #34](https://github.com/zampolit73/Misdeal/pull/34) merged `44f2e0b75df9861d820e36589c8cdc66d5a79596`; [native Godot 4.7.2 CI 72/72](https://github.com/zampolit73/Misdeal/actions/runs/40711701797) PASS, import/GDScript, native smoke and screenshots. Three distinct short **synthetically generated** correct 8s/16kHz mono `castle/courtyard/ossuary` WAVs, actual tracked Git blobs size **256044 bytes each**; initial malformed base64 files fixed before release. Existing persistent `SoundDirector` now loops/caches on `Ambience` bus, fades 1.6s between real location contexts: cursed table→castle, open `firing_square`/graveyard→courtyard, ossuary/crypt/warden→ossuary, UI event/reward→castle, intro/menu/run-end→silence. `scenes/dev/d369_ambience_audition.tscn` contains three location buttons, Silence and a real bus gain slider. **User still needs to listen**; do not call this acoustic quality approved based on dummy-audio CI. No soundtrack or music added.

## Hard boundaries

Dark-fantasy card-driven roguelike with Wizard at cursed table and compact tactical autobattler. Exactly 12 Fate resolutions I–XII, sealed Bone Warden XIII; Knight/Ranger/Mage, solo/duo/trio conditional recruitment. Godot 4.7.x + GDScript, no C#. Approved DS3 card art, Fate Spread, 29 protected paintings, Arena VFX, story and balance untouched. **D365** prohibits automatic cursor-hover targeting arrows and long archer tracers; never restore them just to make battle feedback louder visually. No change to approved B Oak sound identity.

## Immediate player acceptance / QA

Only after normal `git pull`, F6 `scenes/dev/d369_ambience_audition.tscn`: hear all three environments for at least one full loop, switch mid-play and to Silence, try Ambience slider. Then F5 normal table `castle`, Firing Square `courtyard`, ossuary/crypt/boss `ossuary`, reward→table return. Confirm wind doesn't overwhelm Oak deals, actual D368 archery and healing bell, and no obvious click/repeated whoosh. Test combat foley in `scenes/dev/d368_combat_audio_audition.tscn` separately if needed. If electronic or unnatural, retune from actual feedback directly in GitHub; avoid micro-approval steps.

**Still open:** A1P3 complete human F5 12+XIII run and separately dispatched full RELEASE authored battle/animation matrix (regular PR CI does not cover it). These should be prioritized after audio listening, rather than inventing new visual systems or soundtrack.

## Workflow

Assistant uses connected GitHub without asking user to upload the repo. After any substantial work update `PROJECT_STATE`/`ROADMAP`/`DECISIONS`/`CHANGELOG`/`HANDOFF`, preserve meaningful commits, check native Godot CI and distinguish automated from human PASS. User typically only `git pull` + specific Godot scene.
