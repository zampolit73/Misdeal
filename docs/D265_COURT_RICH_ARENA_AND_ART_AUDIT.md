# D265 — Court rich empty arena QA + strict 3×25 sprite-art audit

2026-10-19. Stage: **QA ONLY**. Act1 live **38/45**, card #39 **NOT RELEASED**; approved **second D261 card illustration**, D264 user-selected lower combat floor and frozen KARAMBA73 unchanged.

## Committed
- `tools/art/author_court_d265_rich_arena.py` reproducibly adds stone, cracks, patina, stepped stone lighting and edge brazier detail to the **actor-free** Gothic tribunal. New 1280×720 lossless WebP `assets/pixel/battle/arenas/court_of_the_mute_d265_rich_qa.webp.b64`; old D263 original unchanged. Asset SHA256 `867abf998d65d947369f6935808dd716bd8951c415c3d2e2573e7e122fb4d160`. [Source/encoder CI PASS](https://github.com/zampolit73/Misdeal/actions/runs/39223840993).
- `res://scenes/dev/court_of_the_mute_d265_richer_arena_preview.tscn` opens only this new character-free candidate. Press **G** to show *actual same* Court lower-floor rectangle screen x40–1268 / y532–710; D261 selected second card image is displayed unchanged. [Godot 4.7.2 native scene/import PASS](https://github.com/zampolit73/Misdeal/actions/runs/39223974836).
- `tools/art/audit_court_d265_three_roles.py` and its GitHub workflow check **ALL THREE** original-character sprite sources together, requiring for each role: 576×480 6×5×96 atlas, idle4/walk6/attack6/hit3/death6, **25 nonempty nonduplicate distinct original cels**, 5 fully transparent unused cells and >=2px clear borders. It NEVER fills gaps by mirroring/duplicating. [Audit procedure CI PASS](https://github.com/zampolit73/Misdeal/actions/runs/39224576431); [machine status](qa/D265_THREE_ROLE_FULL25_AUDIT.json) **BLOCKED: 0/75 source animation cels accepted, 3/3 original sprite atlases absent**. Green workflow means checker completed, NOT animation art approved.

## Honest visual gate
The new arena is **more textured than D263**, but still a **QA-only schematic** rather than an approved painterly finished background matching D261 art. It is **not** registered in production `authored_backdrop.gd`. Exploration generated labelled composite art references that are not usable as clean-alpha original 25-frame packs; they are NOT committed as final poses.

D262 `CourtVerdictController` and new Magistrate/Scrivener/Bailiff `UnitData`, both formations and native six-case combat setup remain. No actual approved Court character art, no `SpriteFrames` registration, no Court Battle→Reward→Table release claim. `resources/cards/court_of_the_mute.tres` target path remains blank. Other encounters, D260 #38, DS2/Fate Spread and immutable KARAMBA73 are unaffected.

## Next D266
**Create all 3 complete original 25-pose alpha sheets together** (real hands holding magistrate's seal/staff, scribe's ledger/quill, bailiff's shield/halberd; grounded feet; coherent facing; no fake animation). Run the 75-frame batch structural validator then inspect one combined native F6 1× / 2× motion scene. Refine the character-free arena until visually appropriate; keep user's lower floor. Only then integrate into real `Battle`, 54-case balance and genuine Battle→Reward→Table, and separately release #39 to 39/45 after PASS. Do not ask for per-frame approvals.
