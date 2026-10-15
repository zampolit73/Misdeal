## 2026-10-15 — D153 NATIVE THREAD QA PASS; STRICT ORIGINAL ANIMATION GATE COMMITTED

Confirmed user Godot screenshot: `D153 / SKELETAL STRINGS — PASS`, 0 visible errors; original skeletal roster/two placements, 32% damage protection within 285px, tether break/relink and immediate protection removal on Puppeteer death plus cleanup all verified in **isolated** F6 logic test. D153 art preview was already seen rendering correctly in two separate screenshots.

**Next stage source committed, not yet animation assets:** `scripts/battle/unit_animation_library.gd` registers original D153 `threadbare_puppeteer` and `bone_marionette` with strictly separate `576×480` (6×5 cells of 96px) `.webp.b64` atlas paths under `assets/pixel/units/deck_expansion_v1/`. Requires all **25 independent visible frames** (idle4, walk6, attack6, hit3, death6), empty outer margins and unique non-repeated poses. **No fallback to old skeleton sprites**. Added `scenes/dev/threadbare_theatre_art_preview.tscn` five-state gallery with an explicit missing-original-art message. **Neither original 25-frame D153 atlas has been delivered or native-validated yet**; the art gallery is a preparation scaffold, NOT PASS, and no user F6 is needed until production sprite sheets exist. Generated concept boards / scene illustrations are references ONLY and must NOT be misrepresented as actual frame sheets. Future sprite art must retain full feet, right-facing source pose, no flicker.

**Release gates still pending:** approved source-accurate two full animation atlases in GitHub; native art gallery signoff; original theatre combat arena; D153-only `ThreadTetherController` lifecycle wiring in real `battle.gd`; native 54-case plus real battle→reward→table. D153 still NOT in `CARD_PATHS` or `ACT1_CARD_IDS`, live Act1 **35/45**, 12 Fate Spread + sealed XIII unchanged. Assistant handles source/assets in connected GitHub. Documentation in `docs/DECK_EXPANSION_D153_THREADBARE_THEATRE.md` and handoff; no manual ZIP/PowerShell/copying.

---

## 2026-10-15 — D153 ORIGINAL SKELETAL STRINGS NATIVE F6 PASS

User supplied Godot 4.7.2 screenshot of `res://scenes/dev/threadbare_theatre_smoke.tscn`: **D153 / SKELETAL STRINGS — PASS**. The scene explicitly reports passing original two-undead-types/two-formations data, **32% marionette protection within 285px**, range-severed bonds, immediate loss of protection on Puppeteer death, and cleanup restoring original damage multipliers. Godot debugger shows **0 errors** in this screenshot. This is **only the isolated encounter logic QA**, NOT animation approval, real battle wiring, theatre arena, real victory/reward/table or balance approval. D153 selected skeletal-theatre card artwork separately rendered in user Godot screenshots. The assistant now proceeds to original 25-frames-per-role unit animation production (puppeteer + bone marionette), then native gallery QA before battle integration. Active pool stays **35/45**, D153 NOT in CARD_PATHS nor ACT1_CARD_IDS; preserve D143/D167/D168, 12+sealed XIII, DS2 and all older encounters.

---

## 2026-10-15 — D153 NATIVE CARD PREVIEW RENDER CONFIRMED; THREAD SMOKE STILL UNVERIFIED

The user supplied **two Godot 4.7.2 screenshots of the same** `res://scenes/dev/threadbare_theatre_card_preview.tscn` scene. The selected third skeletal marionette / moonlit theatre illustration visibly loads in the **actual 448×274 slot**, with title, description and QA-only status; neither screenshot shows a blocking card-loader issue or any red error count (red counter 0). This verifies **native rendering of the staged D153 artwork** and confirms the chosen image is legible, but the user did not yet send an explicit statement of aesthetic acceptance after these screenshots.

**Crucial:** BOTH images are of `ThreadbareTheatreCardPreview`; there is **NO evidence yet for** `res://scenes/dev/threadbare_theatre_smoke.tscn`. DO NOT call the D153 32%-protection/range break/master death logic native PASS until its test screen is submitted. D153 still has no original 25-frame unit animation atlases, no theatre battle arena, and no production battle lifecycle wiring. Remains **NOT LIVE**, Act1 stays **35/45**, Fate Spread 12 + sealed XIII unchanged.

**Only next user action:** run F6 `res://scenes/dev/threadbare_theatre_smoke.tscn` after their existing `git pull` and share PASS/FAIL screenshot. Assistant must fix errors in GitHub; user should never manually paste code or manage assets. Proceed afterward to original skeletal character animation art, then real battle and full matrix before release. User's D168 multiple-concept selection is already fulfilled for D153; don't show another unrequested option round for this approved direction.

---

# D153 — Threadbare Theatre / Театр оборванных нитей

Date: 2026-10-15
Status: **original skeletal encounter DATA + local thread controller + 448x274 user-selected art staged, NOT LIVE**.

## Original undead direction / user approval

User specified that Misdeal's current enemies are undead, so the previous *wooden puppet* concept must be replaced by **skeleton marionettes**. The user liked the **third** visual option best, featuring an angular ruined theatre under shattered moonlight, an undead crowned puppet master, two bony marionettes in theatrical rags and physically visible threads. They then instructed the assistant to continue. Art direction must follow D167 dark-fantasy scene illustration, and D168 options-before-final workflow is considered satisfied by the already selected third concept.

The exact resulting 1604×981 selected/refined image was resized to **448×274** and saved as export-safe original WebP in GitHub:
`assets/pixel/card_unification_v1/run/threadbare_theatre_approved_v1.webp.b64`.
SHA256 of decoded WebP: `9a98c35b46f820acea3a0e3e3821fdb652f31a611428f384be6fd16900e260c3`.
Remote GitHub base64 content was refetched and independently compared byte-for-byte with the prepared source (MATCH). `scripts/ui/card_unification_v1.gd` now provides `get_run_texture("threadbare_theatre")` using a strict 448×274 WebP check; this is **only a QA art preview**, not a live card addition.

## Original staged resources (all independent of old enemies)

- `resources/units/threadbare_puppeteer.tres`: skeletal, ranged leader `threadbare_puppeteer`, provisional stats HP 108, damage 5.5.
- `resources/units/bone_marionette.tres`: original bone-and-rags marionette `bone_marionette` (two separate units), provisional HP 71/damage 8.5.
- `resources/encounters/threadbare_theatre.tres`: 1 master + 2 skeleton puppets, two independently-authored placements. The `crypt` arena is a **temporary data placeholder**, NOT approved theatre scenery.
- `resources/cards/threadbare_theatre.tres`: QA-only combat card data; intentionally **NOT** in `RunState.CARD_PATHS` or `ACT1_CARD_IDS`, which remains **35/45**.
- `scripts/battle/thread_tether.gd`: scoped ThreadTetherController without modifying global BattleUnit. While the skeletal master lives, puppets within **285px** receive **32% less damage** (multiplying each unit's original `damage_taken_multiplier` by 0.68). Movement can sever/reconnect a thread and death of the master immediately breaks all links and restores multipliers. Lines drawn between living units are distinct, not a generic area-of-effect poison/revive.
- `scripts/dev/threadbare_theatre_smoke.gd`, `scenes/dev/threadbare_theatre_smoke.tscn`: direct real BattleUnit F6 test of data/roster, near/far tether, damage reduction, break/relink, master death and cleanup.
- `scripts/dev/threadbare_theatre_card_preview.gd`, `scenes/dev/threadbare_theatre_card_preview.tscn`: staged original image shown at 448×274 using normal CardArtCatalog, and source guard that D153 is NOT yet live.

## IMPORTANT native QA boundary

**None of the new D153 scenes has yet been run in native Godot**. The source and GitHub files have been verified but cannot be labeled F6 PASS. Do not imply that a real D153 fight works: the controller is **not wired into** `battle.gd` and the two new enemy roles **do not yet have original animation atlases**. It is intentional to avoid rendering old skeleton sprites or blank units in a live battle.

Next minimal user steps:
1. `git pull`, F6 `res://scenes/dev/threadbare_theatre_card_preview.tscn` to verify card art is correct at runtime.
2. F6 `res://scenes/dev/threadbare_theatre_smoke.tscn` to test thread mechanics. Send one screenshot or PASS/FAIL text.
No manual file copying, ZIP extraction, or PowerShell required.

After that: generate original **25 authored frames per role** (idle4/walk6/attack6/hit3/death6) in separate transparent 576×480 atlases, preserve visible feet and actual unique poses; user reviews Godot gallery before production. Prepare original theatre combat arena, then wire controller **only** for `threadbare_theatre`, do native 54-case mechanical/balance test and real win→reward→table navigation, and only then register D153 as **36/45**. Maintain 12 Fate Spread resolutions + sealed XIII, DS2 Variant C, D143 genuine new enemies and D167/D168 card-art rules.
