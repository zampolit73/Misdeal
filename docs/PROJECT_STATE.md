# Misdeal — current project state

Delivery: [PR88](https://github.com/zampolit73/Misdeal/pull/88) · [final-head RELEASE checks](https://github.com/zampolit73/Misdeal/pull/88/checks).

## D418 — Jack event

User chose gateway art option1. Added Ranger-only Tier1 event with exactly three outcomes:25 gold → real animal companion, pass unchanged, or token → Ranger damage+10% for this run.40/45 ordinary cards; hero count/compensation,12+XIII, approved heroes and old mechanics preserved. Complete25-pose dog, actual native event/combat/choice/wave evidence and regression tests. [Behavior, assets, QA and F6](D418_JACK_EVENT.md). Final PR RELEASE CI must pass before merge; native F6 launcher `scenes/dev/jack_event_playtest.tscn`. Earlier VP1–VP7 release below remains merged at d49d51a1.

Delivery: [PR87](https://github.com/zampolit73/Misdeal/pull/87) · [final-head CI checks](https://github.com/zampolit73/Misdeal/pull/87/checks). Merge requires successful full RELEASE; current check conclusion is authoritative.

## Visual polish delivery — 2026-11-09

D414–D417 are merged: [#83](https://github.com/zampolit73/Misdeal/pull/83),[#84](https://github.com/zampolit73/Misdeal/pull/84),[#85](https://github.com/zampolit73/Misdeal/pull/85),[#86](https://github.com/zampolit73/Misdeal/pull/86). Integration baseline `d9613298` includes all four; final-head CI for integrated D414: [42596022608](https://github.com/zampolit73/Misdeal/actions/runs/42596022608). Merge order84→85→86→83 preserved ancestry and combined dossier/motion hooks; documentation conflicts resolved, no force push/reset.

The autonomous VP1–VP7 program implements concrete native-audit repairs: both Reward modifiers fit the painted strip; full original descriptions open via RMB/F with keyboard scrolling and correct modal focus; Reward/Shop reuse D416's exact clean tabletop and truthful passive counters; merchant pictures follow actual offered upgrades, full tradeoffs and resolved states are readable; long story choices fit without hiding penalties; RunEnd summaries scroll within their panel; the existing Battle victory action now draws above its scrim, at unchanged coordinates. No approved source artwork, D412 poses, mechanics, economy, card counts or timings changed.

Validation: Godot4.7.2 **224/224 GUT**,51 scripts,47,268 assertions;13/13 QA-selector tests. Native baseline48 states and final52-state matrix, identical seeded fixtures and explicit source SHAs. Actual ordinary Court Battle→Reward→Table PASS (39/45 content); solo/duo/trio RELEASE motion and75 Court source poses PASS.20 critical approved image sources are guarded by decoded SHA256, with all original D412 pose/source regressions intact. Final PR CI includes complete RELEASE mode and full matrix; see [release QA](VISUAL_POLISH_RELEASE_QA.md) for verified run/PR links and limitations.

[Audit](VISUAL_POLISH_AUDIT.md) · [before/after](qa/visual_polish/compare.html) · [current handoff](HANDOFF.md) · [current roadmap](ROADMAP.md). No confirmed in-scope P0/P1 remains in inspected states. No human full F5 playthrough claimed; existing19 GUT type warnings, Windows certificate-store diagnostic and route-runner shutdown leak diagnostics remain explicitly documented. Legacy enemy style differences are P2/out-of-scope, not authority to redraw accepted art.

## Product baseline

Godot4.7.x/GDScript;40 implemented Act1 cards toward45, two normal offers, I–XII resolutions plus sealed Bone Warden XIII. Solo/duo/trio contracts and compensation, authored encounters/waves, nine hero upgrades and original relic catalog remain authoritative. D412 accepted full75-pose hero pack is live; prior art/fallback/checkpoints retained. D314 Battle, D328 card DS3 and Fate Spread art locks remain. Silent-first production audio unchanged.

Long prior session logs and older backlog context: [archived state](archive/2026-11-09-pre-visual-polish/PROJECT_STATE.md), [archived roadmap](archive/2026-11-09-pre-visual-polish/ROADMAP.md). Historical pending flags there are superseded by current GitHub/this release; do not repeat old D153/D410 redraw work.
