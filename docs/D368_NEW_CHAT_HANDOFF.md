> **D368 work started 2026-10-28:** This pre-implementation checkpoint remains relevant for locked game/visual/Oak decisions, but the more recent **combat foley candidate** is documented in [D368_COMBAT_FOLEY.md](D368_COMBAT_FOLEY.md). Check branch/CI and human ear gate before calling D368 released.

# Misdeal — CURRENT NEW CHAT HANDOFF (2026-10-28)

This is the **latest concise checkpoint**. Current technical truth: `zampolit73/Misdeal`, branch `main`; read `AGENTS.md`, `docs/CONCEPT.md`, `docs/PROJECT_STATE.md`, `docs/ROADMAP.md`, `docs/DECISIONS.md`, and this file first. Historical stale sections under later headers must not override the latest release.

## Project and locked decisions

- Godot **4.7.x / GDScript** dark-fantasy card-driven roguelike, cursed tabletop hosted by an antagonistic Wizard; small tactical autobattler. 12 normal resolutions I–XII, sealed Bone Warden XIII. Hero Knight/Ranger/Mage and contingent solo/duo/trio party.
- **Fate Spread («Расклад судьбы») is APPROVED and must stay in its current layout.** Avoid changing core rules, art, DS3 cards/arenas, or the hard-roguelike roster without user discussion.
- Visuals: approved dark-fantasy DS3 card system, 29 protected approved paintings, D356–D360 released. Avoid over-detailed AI-looking decorative clutter.
- Combat D362–D364 initially added mouse hover intent and long archer tracers; **user rejected those two visual effects**. D365 [PR #30](https://github.com/zampolit73/Misdeal/pull/30) rolled them back. **Never silently re-add automatic hover lines, boot rings or long laser-like ranged tracers.** Keep positive heal link, side-specific red/bronze damage numbers, original action animations/impact/sound.

## Dark Forge Audio 1 — source of truth and latest release

- D366–D367 foundational pilot [PR #31](https://github.com/zampolit73/Misdeal/pull/31), squash `cd487890`, [Godot CI 56/56](https://github.com/zampolit73/Misdeal/actions/runs/40527079810): independent **UI, Combat, Ambience** native buses, persistent `SoundDirector` with volume controls and silent ambience crossfade capability; F6 `scenes/dev/d367_audio_audition.tscn` with A parchment/B oak/C occult WAV demos. No ambience/music automatically playing.
- **User has already chosen B — OAK. Do NOT ask to select A/B/C again.**
- D367B live Oak SFX [PR #32](https://github.com/zampolit73/Misdeal/pull/32) merged to `main`, squash `6d39c4e49c1fbe7cae93c5e2d62d53c9cf68432c`; [Godot 4.7.2 CI 40532236638](https://github.com/zampolit73/Misdeal/actions/runs/40532236638) **SUCCESS, 60/60 GUT**, import, smoke and screenshot capture. The **exact approved B WAV** is used for live `deal`; `select`, `discard`, `meddle`, `milestone` have four distinct dry oak/paper synthetic cues, procedural fallbacks and anti-spam cooldowns.
- Existing battle audio from `scripts/battle/combat_audio.gd` is still mostly procedural mono synth; do not describe it as finished recorded foley. No D368 combat-fol­ey pack or D369 castle/environment ambience has shipped, and no soundtrack chosen.
- The human **F5 listening acceptance is still open**. A successful CI using dummy audio is NOT proof of actual perceived sound or mix. Latest detailed source: `docs/D367B_OAK_TABLE_RELEASE.md`; pilot historical reference `docs/D366_D367_AUDIO_PILOT.md`.

## Immediate next actions

1. Player's only local steps after the latest release: `git pull`, normal **F5** (not only F6) to listen to live dealing, selecting, discarding, wizard meddling and Fate milestone. Ask about volume, repetition, tactile quality, and whether B Oak is too synthetic. Adjust in GitHub if needed; honor approved base sound identity.
2. Once live table sound accepted, begin **D368**: sparse, dry metallic/bone/bow/healing-bell/boss foley; keep 4 archer volleys from sounding like a machinegun; use priority/cooldown and restrained blend, retain procedural fallback. Prepare real playable variants and a QA listen scene; CI and player-ear approval. No visual FX additions.
3. Then **D369**: quiet ambient castle interiors/courtyard/ossuary with gentle crossfade, no intrusive constant music. Do not assume actual ambience recordings exist.
4. A1P3 **full human 12+XIII gameplay run** and independently dispatched **RELEASE battle/animation matrix** remain pending; pre-existing GUT/route smokes do not replace them.

## Delivery workflow

Assistant has connected GitHub app. For user-requested implementation edit repo directly with meaningful commits, PR + real Godot CI, update `docs/PROJECT_STATE.md`, `docs/ROADMAP.md`, `docs/DECISIONS.md` if needed, `CHANGELOG.md` and `docs/HANDOFF.md`. User should only need `git pull` + exact local check. Never imply background/asynchronous completion. Communicate in Russian.

This checkpoint supersedes outdated historical D367 “A/B/C not yet chosen” notes.
