# D152 — Defiled Laboratory (staged, NOT live)

Date: 2026-10-15. User approved continuing with D151 integration QA followed by original D152 combat expansion.

## State / hard gate

Original enemy identities and two authored formations have been staged as `.tres` Resources:
- `resources/units/plague_alchemist.tres`: ranged plague alchemist.
- `resources/units/unstable_homunculus.tres`: fast close-combat unstable homunculus (two instances).
- `resources/encounters/defiled_laboratory.tres`: new 1+2 roster and two layouts.

These are DATA ONLY. **No original art / animation, hazard mechanics, combat QA, or card registration has shipped.** Do not claim the encounter is playable or that 35/45 cards exist. These units have new visual_role values, not legacy skins. Their tuning is provisional and not balance-approved.

## Proposed gameplay

The alchemist periodically telegraphs an authored hazardous patch of floor near a target lane. When a telegraph completes, enemies standing in the danger area take no damage; player units standing there take a small time-bounded pulse of damage. If a homunculus is defeated, a brief localized hazardous spill may form at its death position. To remain a compact autobattler, telegraphs must be readable during preselected tactics and avoid fully unavoidable repeat damage; environmental damage needs explicit solo/duo/trio QA. Do not introduce a global hazard system or change old encounters automatically.

## Production steps / release gate

1. Close D151 manual integration: `scenes/dev/funeral_procession_playtest.tscn` -> win -> `reward.tscn` -> choose reward -> `table.tscn`, inspect Fate Spread count, reward persistence, absence of runtime errors. This is NOT the completed 54-case isolated smoke.
2. Author original 448x274 card illustration and original transparent 576x480 6x5 96px atlases: 25 nonrepeated real frames each (idle 4, walk 6, attack 6, hit 3, death 6). Inspect full feet and 2px empty cell borders, source facing and animation transitions in native Godot. No borrowed enemy sprites and no duplicate fake poses.
3. Implement encounter-local hazard controller, native isolated regression QA, and real combat wiring only for `defiled_laboratory`.
4. Test two layouts x 3 starting heroes x 1/2/3 party sizes x 3 tactics, and normal combat->reward->table. Measure challenge, not just completion.
5. Only after passing native tests: add the card to `CARD_PATHS` and `ACT1_CARD_IDS` (35/45), update smoke cardinality guards and docs.

Preserve D143 (novel enemies and original art per fighting card), DS2 / Fate Spread Variant C, 12+XIII, old Grave Bellkeeper, Funeral Procession Last Rite and D142 tactical balance backlog.
