> **Release verified 2026-10-27:** [PR #32](https://github.com/zampolit73/Misdeal/pull/32) merged squash `6d39c4e49c1fbe7cae93c5e2d62d53c9cf68432c`; [Godot 4.7.2 Actions 40532236638](https://github.com/zampolit73/Misdeal/actions/runs/40532236638) **SUCCESS, GUT 60/60**, project import, native smokes and screenshots passed. The following implementation notes were written while feature-branch CI was pending; the live code is now on `main`. Final **human F5 listening** is still pending, and the tests do not validate acoustic quality.

# D367B — approved Oak table sound, live cue pack candidate

Date: 2026-10-27. The user listened to the D367 audio audition and explicitly selected **B — Oak / дубовый стол**. This is the accepted sound direction for the cursed table. Do not reopen A/B/C approval without new user feedback.

## Implemented in feature/d367-oak-live-table-pack (CI and local listening pending)

- Live `TableAudio.play_event("deal")` now loads and plays the **exact approved B sample** from `res://assets/audio/pilot/d367_deal_b_oak.wav`, at normal pitch, on the existing `UI` bus. The A and C prototypes are not live.
- The existing other four live table events (`select`, `discard`, `meddle`, `milestone`) receive distinct short deterministic **synthetically authored oak/paper cues** at 24 kHz mono 16-bit. Not new field-recorded foley. Their character follows B: muted tabletop taps, short card scrapes and no arcade UI chimes.
- A complete original procedural cue dictionary is retained as fallback. If B fails to import, all five existing sounds are still usable. Existing 4 voice round-robin, `output_volume_db` and UI bus routing are preserved.
- Per-event short anti-spam cooldowns (deal 80ms, select 65ms, discard 90ms, meddle 160ms, milestone 260ms) reduce accidental audible piles without delaying card selections or changing game state. No hover sounds.
- The original F6 `scenes/dev/d367_audio_audition.tscn` now labels B as approved and keeps the A/C buttons for reference.

## Engineering checks

- `tests/unit/test_d367_oak_table_pack.gd` covers the exact B resource in the live deal bank, all five cue streams, short PCM character, complete fallback coverage, UI voice bus, cooldown and different-event concurrency.
- **Do not claim Godot runtime/CI PASS before actual GitHub Actions results.** Current branch code is a release candidate.
- No D368 combat foley, D369 ambient loops/music, revised battle FX, DS3/Fate Spread, balance or gameplay changes in this patch.

## Local listening after CI and release

`git pull`, F5 normal game, deal cards several times, select, discard, observe wizard meddle and Fate milestones as encountered. Listen for tactile, quiet wooden texture rather than a sharp synthesized click. Verify no constant hiss, no hover buzz, no changed game reactions; check UI mixer at normal volume. If a cue feels electronic/too strong, adjust just that cue from user feedback.

## Next

D368: sparse, priority/cooldown-limited battle foley on Iron Wall / Firing Square / Last Bell, while keeping D365 battle visuals quiet. D369: three subdued atmospheric beds without mandatory music. The separate A1P3 human 12+XIII playthrough and authored RELEASE battle matrix remain open.
