## 2026-10-15 — D152 CARD ART + REAL WIN → REWARD → TABLE ACCEPTED BY USER

**Latest direct user feedback:** after being asked to F6 `res://scenes/dev/defiled_laboratory_card_preview.tscn`, inspect the original 448×274 card art, click «ПРОВЕРИТЬ В БОЮ», win the real encounter, choose a reward and return to the cursed table, the user replied **«Все ок»**. Treat this as **user-reported acceptance of the card illustration and real battle→reward selection→table route**. The user did not provide a new screenshot or instrumentation trace of the reward flow; do not portray it as independently automated verification. Prior actual Godot screenshot confirms the **D152 54/54 FUNCTIONAL PASS**, with **54 wins/0 losses**, solo/duo/trio 18/0 each, 67 warnings, 435 poison hits, 108 spills, longest 14.9s. Earlier original 25-frame animation gallery was accepted separately.

**Status:** D152 original art and integration acceptance gates are satisfied by user report; **BALANCE gate remains open**. 100% diagnostic wins across every composition are a strong signal to evaluate encounter difficulty, not proof of a defect or an instruction to change worldwide combat tuning. Next recommended step is a **D152-only measured balance pass**: compare win/loss and battle times by party size, hero class, deployment and tactic; review local enemy stats or hazard timings based on results, preserve readable telegraphs and solo viability. Verify changes again in Godot before release. **Do not activate D152 in `RunState.ACT1_CARD_IDS` yet.** Live Act1 still **34/45**, run **12+sealed XIII**. All modifications should go through connected GitHub; user should need only `git pull` and F6. D151 isolated 54/54 PASS remains valid; its own separate complete reward→table check is not inferred from D152 acceptance.

---

## D152 QA UPDATE — 2026-10-15 — GODOT 54/54 PASS; ORIGINAL CARD ART STAGED

**User's Godot screenshot confirms:** `res://scenes/dev/defiled_laboratory_battle_smoke.tscn` **FUNCTIONAL PASS**, 54/54 completed, 54 wins / 0 losses (solo 18/0, duo 18/0, trio 18/0), 67 chemical telegraphs, 435 toxic hits, 108 death spills, maximum battle 14.9 seconds. This replaces any previous D152 "54-case pending" statement. Original D152 Plague Alchemist + Homunculus animation gallery was separately approved by user, and both real 25-frame atlases are already in GitHub. **54/54 is a technical smoke, NOT balance approval.** 100% wins in all compositions merits later challenge evaluation; do not change global solo/duo scalers or other encounters automatically.

**New candidate artwork (not yet native/user approved):** Original D152 card illustration assembled from D152 original enemy artwork and generated cursed-alchemy-laboratory imagery into a single **448×274** text-free WebP scene. GitHub `assets/pixel/card_unification_v1/run/defiled_laboratory.webp.b64` contains its packed bytes; independently refetched from GitHub and matched to source. `scripts/ui/card_unification_v1.gd` resolves this **only for `defiled_laboratory`** via a strict 448×274 loader, with no fallback to another card. New F6 `res://scenes/dev/defiled_laboratory_card_preview.tscn` displays the illustration and lets the user click **«ПРОВЕРИТЬ В БОЮ»** to enter `defiled_laboratory_playtest.tscn`. The generated concept UI text/button `Обойти` is **not gameplay** and was not implemented or baked into the card art; encounter stays combat-only.

**Still pending:** Godot 4.7.2 **native card art F6 inspection / user visual acceptance**; **normal win → reward selection → table** check with the dev-only card; measured fair challenge assessment. Keep D152 **QA-only `CARD_PATHS`**, **NOT `ACT1_CARD_IDS`**, Act1 **34/45**, run shape **12+sealed XIII**. Do NOT claim D152 live 35/45. No archive/PowerShell required: `git pull`, F6 `res://scenes/dev/defiled_laboratory_card_preview.tscn`, inspect card, click button, finish battle, choose reward, return to table, report result. The latest source still needs a native Godot run; any error should be fixed by assistant directly through GitHub. Detailed checkpoint: `docs/DECK_EXPANSION_D152_DEFILED_LABORATORY.md`.

---

## 2026-10-15 — D152 ART GALLERY ACCEPTED; 54-CASE NATIVE BATTLE SMOKE STAGED

User supplied an actual running Godot 4.7.2 screenshot of `res://scenes/dev/defiled_laboratory_art_preview.tscn` showing **both original animated characters** (Plague Alchemist and Unstable Homunculus) loading and rendering normally, and explicitly replied **«Все ок.»** The earlier GDScript `var role := ROLES[i]` parser error is no longer observed on the new screenshot. Record **native art gallery accepted by the user**, not proof of complete animation-frame technical validation by screenshot alone. Both original 25-frame atlases are tracked in GitHub (no ZIP).

**New test staging:** committed `scenes/dev/defiled_laboratory_battle_smoke.tscn` and `scripts/dev/defiled_laboratory_battle_smoke.gd`: 54 simulated real BattleUnit fights covering 2 authored formations × 3 protagonists × solo/duo/trio × ASSAULT/HUNT/FORMATION; scoped real `LaboratoryHazardController` steps in each fight. Checks QA-only card/34-pool guard, 25-frame original atlas roles, source-right D152 facing and 54 completed win/loss outcomes; reports party-size wins/losses, toxic warnings/hits/spills and max encounter duration, FAILs on timeout or zero telegraphs. **This new 54-case F6 scene has NOT been run in native Godot** and must not be called PASS yet. It is technical diagnostic, not balance or normal reward navigation verification.

**Single next user action:** `git pull` and F6 `res://scenes/dev/defiled_laboratory_battle_smoke.tscn`; send screenshot/PASS/FAIL. Assistant edits/fixes GitHub directly. D152 is **still NOT live**; `ACT1_CARD_IDS` remains 34/45, 12+sealed XIII. Original 448×274 card illustration and normal D152 victory→reward→table still pending, along with D151 real end-to-end UX. Do not change global scaling, old sprites or D143 original-enemy requirement.

---

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
