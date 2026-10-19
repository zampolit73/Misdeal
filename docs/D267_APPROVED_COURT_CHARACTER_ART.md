# D267 — User APPROVED all three rich Court role illustrations

**Date:** 2026-10-19. **Explicit user feedback:** «отлично. подходит» to the three newly generated rich transparent pixel-art pose-sheet illustrations shown directly above this decision in the project conversation. This is **approval of the three visual designs/art direction**, not yet proof that production-ready 25-frame atlases were imported into Godot.

## Approved source images (conversation image files)
- Magistrate / `mute_magistrate`: `пиксельный_скелет_судья_лист_анимации.png` (1374×1145 RGBA); crowned skeletal judge with rich black/burgundy mantle and ornate bronze legal **scales-staff**; animated standing, walking, attack/seal, stagger and collapse.
- Scrivener / `ash_scrivener`: `пиксельный_спрайт_лист_мрачного_писца.png` (1374×1145 RGBA); robed hooded skeletal scribe with visibly held **ledger and quill**, crimson spectral handwriting, hit and death.
- Bailiff / `bone_bailiff`: `скелетный_страж_лист_анимаций.png` (1374×1145 RGBA); heavily armoured guard with large decorated **shield and hooked halberd**, swinging attacks, walking, hit and death.

These are genuine new rich character designs that the user has approved. **Do not replace these with the simplified programmatic D266 silhouettes.** Source PNGs were delivered in the conversation, not yet in GitHub's repo files. Their exact RGB/alpha image bytes must be preserved on import.

## Next implementation (no additional art approval needed)

1. Import the actual three conversation-source images to a reproducible `assets/pixel/units/court_of_the_mute_qa/` source archive in GitHub (preserve originals).
2. Split/assign genuine source poses to `6×5×96px` atlas cells following `idle4/walk6/attack6/hit3/death6`. Source canvas 1374×1145 is approximately six 229px columns × five 229px rows, but **do not assume naive rectangular cropping:** weapon, shield and robes can overspill neighboring cells. Recover seam-clipped shapes by connected-component attribution; explicitly inspect all three. Ensure all 75 cells artistically meaningful, 15 spare cells transparent, minimum 2px padding, feet at common contact plane and props physically held.
3. Build **one combined real Godot F6** ×1/×2.1 five-state both-facing animation preview replacing the D266 prototype preview only after source QA. The user approved art designs; this does **not automatically approve the technical atlas extraction and motion quality**.
4. Refine the empty Court arena to richer character-free painterly quality matching the original selected second D261 card artwork, **keeping D264 lower-flat-floor combat-only rectangle**.
5. Only after actual native art/motion checks: normal `MisdealUnitAnimationLibrary` registration, real Court Battle 54-case solo/duo/trio matrix, full Battle→Reward→Table, and a deliberate separate card #39 release to 39/45.

**Current technical state:** D266 generated 75/75 structurally valid simpler QA procedural candidates only; those remain useful for mechanics but are artistically **superseded** by D267 user-approved source illustrations. **Live Act1 = 38/45**, #39 remains QA-only, `court_of_the_mute.tres` target_path still blank; no claim of shipping art. Preserve exact selected second D261 Court card, D262 verdict, D264 lower stone floor, D260 #38, Fate Spread and KARAMBA73.
