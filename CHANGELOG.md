# Changelog

Current implementation summaries only; the exhaustive pre-cleanup change history lives at [CHANGELOG archive](docs/archive/2026-10-15-pre-cleanup/CHANGELOG.md).

## 2026-10-15 — Documentation hygiene (D179)
- Archived exact pre-cleanup copies of AGENTS, PROJECT_STATE, ROADMAP, DECISIONS, CHANGELOG, old handoffs, visual registry and D153 working docs.
- Consolidated current-state, release gates and next steps into a short canonical set with `docs/INDEX.md` and `docs/HANDOFF.md`; preserved full historical decision references.
- Updated README to the current playable game instead of the original early prototype; clarified Godot/dev test boundaries.
- No changes to gameplay, card pool, unit stats, mechanics, accepted art, or scenes.

## 2026-10-15 — D153 post-balance QA (D176–D178)
- D176: encounter-only Puppet Master/Marionette HP/damage/cadence/movement pass; no global balance changes.
- D177: restored resource serialization, added exact-path `UnitData` diagnostic.
- D178: user native Godot F6 54/54 FUNCTIONAL PASS; average survivor HP 74/67/74% solo/duo/trio, worst 39/15/37%; 123 link / 91 break / 54 master-death breaks.
- D153 remains QA-only outside the **35-card live pool**, pending revised real-battle feel signoff and card #36 normal-deal release.

## 2026-10-15 — D153 original art and real battle
- User-approved skeletal marionettes, original crowned puppeteer, 25-pose original animations, selected gothic theatre card scene and moonlit ruined-stage battle arena committed.
- Encounter-local ThreadTether integrated into the real Battle flow (32% mitigation/285px); user previously confirmed battle→reward→table.
- Pre-balance matrix: 54/54 functional PASS with ~85/82–83/86% remaining HP, prompting localized D176 tuning.

## Previous released milestones
- D151 Funeral Procession: original skeletal units/Last Rite, live card **34/45**.
- D152 Defiled Laboratory: original toxic-hazard encounter, environment-led art, live card **35/45**.
- DS2 and Fate Spread Variant C established; earlier events, arenas, tactical cards, UI passes preserved in the archive.
