## NEW ACTUAL GODOT EVIDENCE — 2026-10-15

User sent two screenshots from Godot 4.7.2:
1. `defiled_laboratory_art_preview.tscn` failed to parse `var role := ROLES[i]` (could not infer static type). **Source hotfix committed** to `scripts/dev/defiled_laboratory_art_preview.gd`: explicit type for role, SpriteFrames, Label and state/frame counter. The new art gallery **has not yet been re-run after this fix**.
2. `defiled_laboratory_playtest.tscn` visibly runs a real **Knight vs Plague Alchemist + two Homunculi** fight with native original sprites and a chemical-zone visual ring. This is an in-engine entry/render confirmation, **not** proof of victory, reward→table, correct balance, or completed F6 gallery.

Next minimal user action: `git pull`, re-open Godot and F6 art gallery, check motions/feet/facing, then finish existing real fight and check transition. Both WebP atlases already in GitHub; no ZIP/PowerShell. Card remains **NOT LIVE 34/45**, original 448×274 card illustration still pending.

---

# D152 — Defiled Laboratory: GitHub art shipped, native playtest pending

**2026-10-15 latest:** Both original 25-frame animation atlases are now tracked in GitHub `main` as `.webp.b64`. Their exact base64 bytes were independently refetched from GitHub and verified against offline-generated WebP binaries. **No ZIP extraction or manual PowerShell is required.** The old ZIP / ignored local PNG pathway is historic optional fallback; **`git pull` alone now provides both actual D152 role atlases.** The production code prioritizes tracked `.webp.b64`.

## Current shipped development assets (NOT live Act1 card)

- `resources/units/plague_alchemist.tres`: original ranged Plague Alchemist.
- `resources/units/unstable_homunculus.tres`: original fast melee Homunculus, used twice.
- `resources/encounters/defiled_laboratory.tres`: original 1+2 enemy roster, two authored formations.
- `assets/pixel/units/deck_expansion_v1/plague_alchemist_frames.webp.b64`
- `assets/pixel/units/deck_expansion_v1/unstable_homunculus_frames.webp.b64`
- Both encoded WebPs decode to transparent **576×480 (6×5, 96px)** with 25/25 active authored cells (idle 4, walk 6, attack 6, hit 3, death 6), 25 unique decoded frames per role, no alpha on the outside 2px border of any active cell (offline QA). Compression is WebP quality 80; native visual fidelity still requires screenshot/inspection.
- `scripts/battle/unit_animation_library.gd` supports both new roles, prefers GitHub production `.webp.b64`, refuses absent/missing/duplicate/clipped animation frames without copying older enemy sprites.
- `scripts/battle/laboratory_hazards.gd`: only D152 uses acid warning, timed toxic zones/damage and on-death homunculus spills. The isolated `scenes/dev/defiled_laboratory_smoke.tscn` passed in the **user's native Godot screenshot**.
- `scripts/battle/battle.gd` wires this controller ONLY for `defiled_laboratory`, starts on fight launch and stops on conclusion.
- `resources/cards/defiled_laboratory.tres` is lookup-only through `RunState.CARD_PATHS` for development. **DO NOT put D152 into `ACT1_CARD_IDS` yet.** The card illustration is **NOT done**: `art_path` intentionally empty.
- `scenes/dev/defiled_laboratory_art_preview.tscn`: shows the two original animated enemies cycling through five named actions.
- `scenes/dev/defiled_laboratory_playtest.tscn`: enters a real Knight battle once both atlases pass resource validation.

## QA status and next user action

**Validated:**
1. D152 isolated hazard F6 native **PASS** from user screenshot.
2. Offline transparent frame occupancy, uniqueness and padding **PASS** for both newly committed `.webp.b64` atlases; remote content refetch matches the local original encoded data exactly.

**Pending (do not claim PASS):**
1. Native Godot 4.7 animation playback, full body silhouettes, no frame bleed/flicker and correct right-facing at source.
2. Real Knight `defiled_laboratory_playtest.tscn` action, acid hazard readability, hero damage, death spills, victory/result and reward/table transition.
3. Original 448×274 cinematic card illustration, with explicit native visual approval.
4. Actual 54-case matrix (2 formations × 3 protagonists × solo/duo/trio × assault/hunt/formation) and meaningful challenge evaluation.

**Minimal user workflow:** Run `git pull`, restart/open Godot, F6 `res://scenes/dev/defiled_laboratory_art_preview.tscn`; report screenshot or failure. If the gallery looks right, F6 `res://scenes/dev/defiled_laboratory_playtest.tscn` and send the battle result. **No downloading ZIP, extracting files or manually copying code.** Assistant owns future GitHub fixes and docs.

Release gate: keep Act1 **34/45**, Fate Spread **12 cards plus sealed XIII** until card art + full integrated QA pass. Preserve D143 original enemy-only requirements, DS2, Funeral Procession Last Rite, Bone Shepherd Whistle, and the D142 HUNT/duo balance backlog. D151 original 54/54 isolated F6 PASS stands, but its normal victory→reward→table remains an independent unverified QA task.

## Historic staging note

An early D152 art-review approach used a conversation ZIP containing locally generated PNG atlases under the ignored `assets/local_previews/d152/` directory. That method is now **obsolete for the normal workflow**: the assistant has since transferred production `.webp.b64` assets directly into GitHub using the connected integration, verified GitHub contents, and eliminated the ZIP dependency.
