# Misdeal: Цена клятвы — автономный альтернативный вертикальный срез (v0.1)

**Status:** isolated playable candidate, pending Godot 4.7.x native/visual validation. Not a release or a replacement of original Misdeal.

## Origin and relationship to Misdeal

This is a deliberately separate experimental reinterpretation of the existing cursed-table roguelike. It preserves the Wizard as adversarial host, the Knight / Ranger / Mage protagonist choices, recruitable and permanently losable companions, small automatic battles, the Fate Spread (12 resolutions I–XII), and the sealed Bone Warden XIII.

Original gameplay, DS2/DS3 art, original sound, saved progress, main scene and RunState **are unchanged**. This is a self-contained alternative Godot scene within the same repository, built without new third-party dependencies. It does not yet copy or redistribute any approved live art.

## What's new

- **Pledge:** Before choosing a card, voluntarily spend 5 permanent max HP on the front-line protagonist for **+1 Seal and +1 Debt**. Payment only happens on actually choosing an offer; toggling the pledge button is safe.
- **Debt is a boss contract:** Each unredeemed debt makes the final Bone Warden XIII gain +14 HP and +2 attack. Some table cards can buy down the debt.
- **Seals are tactical currency:** Choose the Ritual combat order to spend one seal for +9 damage each combat round.
- **Three battle orders:** Shield (safer, slower), Blade (faster, riskier), Ritual (consumes a seal). Combats autoplay after a single explicit order.
- **True party consequences:** You choose one protagonist, may discover and recruit the other two via rescue cards (guaranteed *offer* windows in slots III and VII, not guaranteed recruits), and fallen companions disappear for the rest of that run.
- **Two-card deals:** One card chosen; the other rejected. Fixed seed reproducibility for testing. A journal and 12-position circular progress are visible.

## Run the alternative without touching main

Open `project.godot` in Godot **4.7.x** and F6 scene `scenes/alternative/veil_table.tscn`.

The original F5 game remains exactly as before. The 12-card route and final boss are separate state and cannot mutate the main game's autoload RunState.

## Automated verification

GUT tests: `tests/unit/test_alternative_oath_table.gd`.
Validations to run in GitHub CI or Godot: project import/parse, GUT tests, alternate F6 scene launch, full 12+XIII playthrough at 1280x720 and visual review. CI success is not human playtesting. Native test result must be recorded before calling the candidate *verified*.

## Next bounded steps

1. Execute CI, repair import/parse or gameplay defects.
2. Replace clean engineering UI with hand-authored original visual assets for this **alternative** style, while respecting approved original Misdeal artwork.
3. Extend encounter diversity, hero tactics, balancing, accessibility, controller support, and save/continue.
4. Package as a separately launchable build only after test and licensing review.

## Ownership / safety

Everything for the experiment is under `scripts/alternative/`, `scenes/alternative/`, this document and a new targeted GUT test. Do not merge an unreviewed experimental variant into the original release pipeline, alter approved DS3, or turn sound ambience back on.
