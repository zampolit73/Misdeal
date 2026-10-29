# D374 — Silent-first sound baseline for Act I

## Why this supersedes D373

The player compared D372 in isolation and marginally preferred courtyard, then tested the new recorded D373 sounds in **actual Misdeal gameplay**: **"звуки не подходят. нужно менять. они отвлекают и ломают атмосферу."** That is a rejection of the *system as used in the game*, not an invitation to turn it down 3dB or generate another creak. All three are rejected as F5 default even though courtyard was relatively less bad in F6.

## Product change

- `SoundDirector` has `_location_ambience_enabled := false` by default. Calls to `set_location("castle"|"courtyard"|"ossuary")` by current Table, Battle, Event, Reward and scene transitions **do nothing**, and do not load/play/loop assets. `set_location("silence")` remains allowed. This avoids scene-specific silent failure and preserves future explicit opt-in.
- `set_location_ambience_enabled(true)` exists for opt-in, isolated developer **F6 audition only**; disabling fades out all players and sets current location to silence. Expose `is_location_ambience_enabled()` and `get_ambience_debug_info()["enabled"]` for native verification.
- The old developer audition `scenes/dev/d369_ambience_audition.tscn` stays available for comparison and license traceability, now marked **D374 — БЕЗ НАВЯЗЧИВОГО ФОНА**. It opens in silence and labels each previous recording as not approved, does not auto-play it, and restores previous preview mode + bus volume on exit. The Master/Ambience calibration buttons are unchanged.
- Source WAVs and D373 CC BY/CC0 credits are retained; no rights info is lost. **No visual/gameplay changes.** B Oak UI/audio, D368 Combat and all combat/UI active effects are untouched.

## Audio design: what NOT to do

Do not infer that dark fantasy demands continuous drones, loops, synth wind or artificial bone rattles. Empty, quiet spaces are a feature of the cursed tabletop. If a new cue is warranted later, it should be an intentional discrete event tied to existing action/stakes (a dealt card, new curse, Warden reveal), quiet and short, and auditioned against the actual gameplay sound mix **before** touching F5. Do not sneak in a soundtrack; it has never been approved.

## QA / acceptance

GUT guards: new SoundDirector instance starts disabled and stays silent even when all three locations are requested; enabling in an explicit preview permits playback, disabling restores silent behaviour; F6 archive opens silent and restores enable state. Actual playing audio and artistic appropriateness must be checked in **F5** after a successful `git pull`. Check real table card gestures/Oak, an arena fight/D368, return via reward and boss/ossuary. There must be no repetitive 16s environmental loop, while existing approved interaction sounds remain. Only after confirming F5 is usable should any new ambient sonic direction be proposed and user-approved. Full human A1P3 12+XIII and full RELEASE authored animation matrix are still open.
