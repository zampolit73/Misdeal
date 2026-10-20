# Misdeal Design System 3 — Safe Rollout Foundation (D288)

**Status 2026-10-20:** DS3 is **opt-in**, not a global reskin. Initial D288 native Godot 4.7.2 regression **PASS** ([run 39392900520](https://github.com/zampolit73/Misdeal/actions/runs/39392900520)). Keep the original DS2/Variant C behavior and styling for unreviewed screens.

## Immutable rollback checkpoint

- Branch: [`checkpoint/ds2-pre-ds3-2026-10-20`](https://github.com/zampolit73/Misdeal/tree/checkpoint/ds2-pre-ds3-2026-10-20)
- Commit SHA: `4cbd206cc3739355a9d375a0752a6a840e35caa2`
- Git tree SHA: `955d34147260d725264a104a6f8b3a1fe60fd725`
- Source: `main` immediately **before** any D288 DS3 code/docs edits. The branch was created and the ref's SHA verified on GitHub.
- Snapshot includes all tracked Godot scenes, assets, working DS2 UI, D287 squad dossier, active arenas and their code/data. This is a **Git snapshot**, not a savegame or local uncommitted file backup.
- Do not modify, rebase, force-push or delete this checkpoint branch.

## Safe verification and rollback

To **inspect** old DS2 separately (protect or stash local uncommitted work first):

```powershell
git fetch origin
git switch -c review-ds2 origin/checkpoint/ds2-pre-ds3-2026-10-20
# Open the project in Godot 4.7.x to compare the older look
git switch main
git pull --ff-only
```

To **roll back main**, prefer reverting DS3 commits in reverse chronological order (new revert commits, no history rewrite/force push); first identify DS3-specific commits using `git log --oneline`. The connected GitHub tools can create the equivalent revert on explicit user request. **Do not** run `git reset --hard` on a shared `main`.

## Identity (keep what is already approved)

- **Physical tabletop:** blackened wood, actual painted encounter cards, Wizard's hands, wax seals, candles. Two normal deal choices remain **two**. The illustrative DS3 concept with three simultaneous cards is not authorization for a new gameplay mode.
- **Hero dossier / development / relics:** dark stone/bronze/copper hierarchy, small isolated ruby and aged-metal ornaments, tall readable portrait, clean live stats. The D287 approved layout and three actual D287 decorative assets remain intact.
- **Battle:** atmospheric arena and legible small autobattler actors take precedence. The illustrative DS3 battle with ability hotkeys and turn order is **not** the game's existing combat model and must not be implemented as gameplay.
- **Cards / shop / rewards:** painted scenes and parchment readability; do not introduce fictional relics, rewards, bonuses or rarity rules from concept art.
- **Mood restraint:** avoid duplicate flaming skulls, purposeless tiny filigree, mirror-perfect symmetry, engraved lines on every label, and generated image text/controls.

## Canonical palette — DS2 values retained as DS3 base

| Token | Hex | Role |
|---|---|---|
| Obsidian | `#100C0D` | deep surfaces, not unbroken pitch-black void |
| Crimson | `#62201E` | risky choices, emphasis, not all borders |
| Aged bronze | `#A66636` | physical dividers, frames, navigation |
| Warm parchment | `#DFB77E` | readable labels and painted card surfaces |
| Moonlit steel | `#334758` | restrained cool contrast / battle info |
| Stat positive | `#91D795` | positive actual deltas only |
| Stat negative | `#EC897C` | harmful actual deltas only |

Art styles may use subdued intermediate shades; avoid globally replacing per-screen authored DS2 color tokens. For new components, use `scripts/ui/misdeal_ds3.gd`.

## Component contract (Godot 4.7.x; GDScript)

- `MISDEAL_DS3.make_plate(fill, outline, thickness, shadow)` is a reusable **visually identical** D287 panel material factory for the initial migration.
- `MISDEAL_DS3.make_surface("table" | "battle" | "dossier")` exposes deliberate decor-density tiers; no global application.
- `MISDEAL_DS3.apply_surface(panel, surface)` and `apply_action(button, primary)` are explicit opt-in helpers for subsequent reviewed screens. No event handlers, state or geometry are touched.
- D288 pilot: `scripts/ui/squad_dossier_v3.gd::_plate()` delegates to DS3 helper with **the same four incoming parameters and output visuals**. D287 actual portrait, relics, label data and hover behavior are untouched. No DS3-wide battle/table changes yet.
- Avoid whole-screen pictures with drawn-in text/health bars/buttons: every UI element stays a separate Godot Control and receives actual RunState data.
- Use 1280×720 real game screenshot **before** accepting any visibly changed screen. Godot headless CI confirms parsing/behavior, *not* aesthetic quality.

## Rollout gates

1. **D288 foundation:** verified checkpoint, DS3 opt-in styles, identical-behavior D287 dossier style helper integration, official Godot native dossier smoke.
2. **Next:** choose a single real screen (suggest Table first), audit its current Node/Control hierarchy, scope a visual-only DS3 iteration and compare the Godot screenshot. Do not change normal dealing or card counts.
3. **Then:** battle chrome separately, prioritizing arena space/unit feet/HP/tactics, with Godot screenshot + combat smoke.
4. **Later:** reward/shop/info screens after their UI requirements are grounded in existing gameplay; no automatic full-game conversion.

See also `docs/DESIGN_SYSTEM.md` for approved historical DS2 decisions and `docs/DS2_CHECKPOINT.md` for a short restoration guide.

## D289 — Live Table visual-only pilot

- Implemented in [`scripts/table/table_ds3_pass.gd`](../scripts/table/table_ds3_pass.gd), attached from `scripts/table/table.gd::_apply_ui_kit()` **after** `MISDEAL_DS2_ROLLOUT.table(self)`.
- Scope: metal/material styling of live HUD and Wizard text, two existing navigation buttons, truthful Deck/Discard counts and the existing optional Wager window. Minimal thin engraved detail is drawn as native mouse-ignoring `ColorRect` children of those panels.
- Explicitly excluded: two live offers, choice/hold/inspection handlers, D278 full art, existing tabletop, actual Fate Spread, per-card rewards, all gameplay.
- Native test `scripts/dev/d289_table_ds3_smoke.gd` bootstraps `RunState` and the **real** Table and checks exactly two `get_offer_cards()`, original card art/size, connected callbacks, Wager and DS3 panels. [Godot 4.7.2 PASS](https://github.com/zampolit73/Misdeal/actions/runs/39393893259). Original D274 regression PASS.
- **Open:** actual 1280×720 user screenshot of two-card Table D289. Do not claim pixel-perfect equivalence or final artistic signoff. Next Battle HUD pass only after assessing this visual gate.


## D290 — Post-first-screenshot fixes

First actual D289 Table screenshot exposed fixed deck text and heavy doubled chrome. D290 scopes masking and thinner decoration to the actual Table without touching other screens/gameplay. Native two-card QA PASS: https://github.com/zampolit73/Misdeal/actions/runs/39396611590 . Await screenshot to approve.

