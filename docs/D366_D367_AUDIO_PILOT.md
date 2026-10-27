> **Approval update (2026-10-27):** User chose **B — Oak**. D367 A/B/C audition is no longer awaiting selection. The exact B WAV is connected to live card-deal events in the D367B feature branch, with four additional short oak/paper cues and procedural fallback. CI and human F5 acceptance pending. See [D367B_OAK_TABLE_RELEASE.md](D367B_OAK_TABLE_RELEASE.md). The original pilot text below remains as historical implementation record.

> **Release verified:** [PR #31](https://github.com/zampolit73/Misdeal/pull/31) merged to main as `cd487890d75fbf62336112a2cb254f8cffd3dc92`. [Native Godot 4.7.2 CI](https://github.com/zampolit73/Misdeal/actions/runs/40527079810) **SUCCESS**: 56/56 GUT, native smoke and current-scene screenshots. Existing procedural table/battle audio is preserved; A/B/C WAVs are **audition-only** awaiting user choice. No real field recordings, no ambient loops/music yet.

# D366–D367 — Dark Forge Audio 1, mixer foundation and card dealing audition

Date: 2026-10-27. User authorized the first two phases of the audio upgrade.

## Verified pre-work state

- `scripts/table/table_audio.gd` synthesizes 5 table cues at 22,050 Hz mono and `scripts/battle/combat_audio.gd` synthesizes 11 battle cues. They are functional, but do not yet use recorded foley.
- No dedicated audio module in `scripts/event/act_choice.gd`, `scripts/reward/reward.gd`, or ambient music/loop implementation in the existing scenes. Not adding music to this phase.
- DS3, `Расклад судьбы`, battle FX and target readability D365 remain locked; no cursor-hover sounds and no new visuals.

## D366 foundation — implemented in feature branch

- Native `default_bus_layout.tres`: `UI`, `Combat`, `Ambience` (each routed to Master), preserving the existing Master output; ambient bus defaults to -10 dB.
- Existing TableAudio procedural SFX route through `UI`; CombatAudio procedural SFX route through `Combat`. No difference to attack timing/damage/card selection.
- Lightweight autoload `SoundDirector` exposes independent `set_channel_volume(bus_name, linear)` / `get_channel_volume(bus_name)`. Defaults preserved for UI/combat; supports mute. Two persistent, initially silent ambience voices with crossfade helper for future approved loops, **no ambience playing by default**.
- Does not introduce new third-party dependencies or game menu settings (that can follow user sign-off). No hidden background audio.

## D367 — three playable card-dealing prototypes (approval pending)

Original digitally synthesized sample files, **not recordings** and **not automatically replacing existing live TableAudio**:

| Option | File | Feel |
| --- | --- | --- |
| A | `assets/audio/pilot/d367_deal_a_parchment.wav` | Dry parchment flip, subtle soft knock |
| B | `assets/audio/pilot/d367_deal_b_oak.wav` | Worn wooden table impact, sliding tactile tail |
| C | `assets/audio/pilot/d367_deal_c_cursed.wav` | Quiet ritual shimmer under the card landing |

Audition in **Godot F6 `scenes/dev/d367_audio_audition.tscn`** at 1280×720: click each of the three buttons. Includes 3 manual gain sliders (UI/Combat/Ambience, scene-only live mix), plus a label to identify what is playing. Files are 24 kHz, 16-bit mono, under 1s each. No excessive loudness; existing table SFX continue on old fallback until sample direction is approved.

These are low-cost prototyping timbres, not claims of finished field-recorded AAA foley. If they sound electronic, request more acoustic recorded-material direction before replacing gameplay samples.

## Tests and acceptance

- `tests/unit/test_d366_audio_foundation.gd` validates runtime audio buses, all three importable WAVs, volume/mute/restore behavior, the existing TableAudio/CombatAudio player bus routing, and F6 audition node availability.
- PR Godot 4.7.2 CI must pass import, GUT and native smokes before merge.
- After `git pull`, F6 the audition scene and select **A / B / C** (or request changes). The user needs to hear it, because CI validates functionality only, not sound quality.
- Once approved: D367 full table cue set with actual chosen sounds, then D368 battle foley, D369 three atmosphere loops; do not claim these latter stages completed yet. For D368 prioritize `last_bell` and `firing_square`, suppress machinegun attacks via priority/cooldown without altering gameplay. For D369 keep a very quiet environment, no music.
- Human A1P3 12+XIII and separate release battle/animation matrix remain open.
