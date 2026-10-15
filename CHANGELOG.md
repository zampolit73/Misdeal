# Changelog

Current implementation summaries only; the exhaustive pre-cleanup change history lives at [CHANGELOG archive](docs/archive/2026-10-15-pre-cleanup/CHANGELOG.md).

## 2026-10-15 — D183: Black Crossing card-art native acceptance
- User F6 screenshot + «утверждено»: original third D182 card illustration PASS in the intended 448×274 framing.
- Next combat models need separate silhouette approval, full original 25-frame sprite animation sheets and native QA; no changes to live cards or encounters.
- Current live Act1 **36/45**; release #37 remains gated by original enemies, independent arena, wave mechanic and battle/reward route.

## 2026-10-15 — D182: Black Crossing #37 direction approved, QA-only candidate staged
- User selected new drowned ferryman + two drowned corpse encounter with timed, telegraphed waves, and card-art option #3 (diagonal pier composition).
- Added standalone `resources/cards/black_crossing.tres` and detailed handoff spec; **no live registry/pool change**.
- Approved exact option-3 448×274 image now committed as `black_crossing_approved_v1.webp.b64`; strict loader and F6 art preview added. Remote text matched source export exactly. Native preview and enemies/arena/waves are pending; Act1 remains 36/45.

## 2026-10-15 — D181: D153 release-routing smoke confirmed in Godot
- User screenshot confirms F6 `D153 / ACT 1 RELEASE — PASS`: 36 unique cards, Tier1 controlled offer/choice, encounter routing, Fate Spread resolution, boss XIII gate.
- No gameplay or source edits required. Release #36 verified with this deterministic route fixture; randomized multi-run offer frequency remains untested.
- Next original #37 gameplay and art concept selection pending; D143/D167/D168 remain mandatory.

## 2026-10-15 — D180: D153 releases as Act1 card #36 (native smoke subsequently passed D181)
- Added `threadbare_theatre` to the normal Tier1 `ACT1_CARD_IDS` pool; now 36 unique nonboss cards.
- Fixed former 35-card assumptions in D151/D152/D153 smoke scenes and playtests, avoiding false failure after release.
- Added `threadbare_theatre_release_smoke.tscn`: tests real RunState offer, card selection, encounter routing, Fate Spread choice and boss XIII gating in a deterministic two-card Tier1 fixture.
- Previously confirmed native D176/D177 54/54 combat matrix remains valid for unchanged D153 values. Post-release deterministic normal-deal Godot F6 was subsequently confirmed PASS (D181).

## 2026-10-15 — Documentation hygiene (D179)
- Archived exact pre-cleanup copies of AGENTS, PROJECT_STATE, ROADMAP, DECISIONS, CHANGELOG, old handoffs, visual registry and D153 working docs.
- Consolidated current-state, release gates and next steps into a short canonical set with `docs/INDEX.md` and `docs/HANDOFF.md`; preserved full historical decision references.
- Updated README to the current playable game instead of the original early prototype; clarified Godot/dev test boundaries.
- No changes to gameplay, card pool, unit stats, mechanics, accepted art, or scenes.

## 2026-10-15 — D153 post-balance QA (D176–D178)
- D176: encounter-only Puppet Master/Marionette HP/damage/cadence/movement pass; no global balance changes.
- D177: restored resource serialization, added exact-path `UnitData` diagnostic.
- D178: user native Godot F6 54/54 FUNCTIONAL PASS; average survivor HP 74/67/74% solo/duo/trio, worst 39/15/37%; 123 link / 91 break / 54 master-death breaks.
- Historical D178 state: D153 was QA-only outside the 35-card pool. D180 has activated it; normal-deal regression check pending.

## 2026-10-15 — D153 original art and real battle
- User-approved skeletal marionettes, original crowned puppeteer, 25-pose original animations, selected gothic theatre card scene and moonlit ruined-stage battle arena committed.
- Encounter-local ThreadTether integrated into the real Battle flow (32% mitigation/285px); user previously confirmed battle→reward→table.
- Pre-balance matrix: 54/54 functional PASS with ~85/82–83/86% remaining HP, prompting localized D176 tuning.

## Previous released milestones
- D151 Funeral Procession: original skeletal units/Last Rite, live card **34/45**.
- D152 Defiled Laboratory: original toxic-hazard encounter, environment-led art, live card **35/45**.
- DS2 and Fate Spread Variant C established; earlier events, arenas, tactical cards, UI passes preserved in the archive.
