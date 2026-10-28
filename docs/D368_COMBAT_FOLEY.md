# D368 — restrained combat Foley pilot (2026-10-28)

## Scope

**Status: feature-branch candidate; native CI and human F6/F5 acoustic acceptance not yet established.** Replaces the live combat WAV palette only, keeps the existing procedural bank as fallback; the user-approved B — Oak tabletop sample/variants are unchanged. No new visuals, cursor targeting, long archer tracers, gameplay timing, AI, balance, DS3, Fate Spread or soundtrack.

Eight **original digitally synthesized** 24 kHz, mono, signed 16-bit PCM WAVs in `assets/audio/combat/`:
- `attack_melee`: short dark steel-on-steel contact;
- `attack_ranged_a/b`: two dry bow/string/wood plucks, not sweeping pew/laser tones;
- `attack_magic`: subdued short arcane breath;
- `hit`: light bone contact, deliberately quieter than the attack;
- `death`: several falling bone ticks;
- `heal`: low bronze bell/chime tail (real healing events only);
- `boss`: muted, low enrage accent (actual boss event only).

They are **synthetic Foley prototypes**, NOT actual field-recorded impacts. Subjective quality requires the player's ears and remains an approval gate.

## Routing and density

`scripts/battle/combat_audio.gd` retains the existing battle `play_event(event_name, role)` contract and `Combat` bus. Six voice pool slots instead of ten. Cooldowns per event family: shared archer/Ranger ranged 155ms, melee 72ms, magic 130ms, hit 110ms, death 160ms, heal 360ms, boss 750ms, order 105ms. Distinct bow variants alternate on **audible accepted shots**; four almost simultaneous arrows cannot build a machine-gun sound. Different event families may layer; no queue delays damage. Per-event quieter volume offsets and minor pitch variation (fixed bell pitch) reduce repetition.

Voice stealing is priority-aware: victory/defeat (6), boss/heal (5), hero boss death (5), regular death/start (4), attack (2), hit/order (1). Under saturation, only an equal/lower-priority voice can be replaced; high-priority accents survive attacks. The system does not guess/simulate combat events, it only sounds real calls.

`_fallback_streams` preserves every original procedural event (attack variants, hit, death, heal, boss, order, start, victory, defeat). An individual WAV failing to load falls back to its procedural equivalent. The D367 approved oak table bank and SoundDirector buses remain untouched.

## Human review

1. `git pull` **only after the changes are released to main** (or use the branch if intentionally testing a PR candidate). Godot 4.7.x: F6 `scenes/dev/d368_combat_audio_audition.tscn`. Listen with default Combat volume, eight labeled buttons, four-archer volley, and mixed hits/heal/boss. Slider independently changes Combat bus (in that session only).
2. In normal F5, check **Firing Square**: four archers should sound like sparse bow release, not rapid synthetic machinegun or long whooshes; damage still takes effect on every shot.
3. Check **Iron Wall**: armor and bone contact readable but not noisy; check **Last Bell**: real healing bell distinguishable from attack hits, with no invented heal and no change to green support VFX.
4. Boss XIII if available in the run: enrage accent audible without an overblown cinematic stinger. Table remains tactile Oak B, no hover or constant music.
5. Provide feedback on bow naturalness, relative impact/bell volume and fatigue in repeated encounters. Dry synthesized timbre is **not** approved just because WAV imports or tests pass.

## Engineering and open gates

- GUT regression: `tests/unit/test_d368_combat_foley.gd`: 8 real imported WAV resources, 12 fallback keys, bus, fixed voice cap, shared ranged throttle and alternating variants, priority and audition scene.
- Native Godot 4.7.x import, GDScript parse, tests, existing battle smokes and CI must PASS before merging branch. Any CI result belongs in top/current notes, not inferred.
- Human F6 and F5 listening remain open even after CI. The standalone A1P3 player 12+XIII clear and independently dispatched RELEASE animation/battle matrix remain open.
- **Next D369** after listening: gentle castle/courtyard/ossuary ambience with crossfade, no perpetual score, D365 visual quietness stays locked.

## New-chat context

Read `AGENTS.md`, `docs/CONCEPT.md`, `docs/PROJECT_STATE.md`, `docs/ROADMAP.md`, `docs/DECISIONS.md`, `docs/D368_NEW_CHAT_HANDOFF.md` and this document; older dated sections below top headings are historical. B Oak approved and already shipped as main PR #32 / 60 of 60 GUT before D368. Respect D365 ban on cursor-target overlays and archery tracers. GitHub is source of technical truth.
