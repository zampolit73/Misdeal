# D204 — Road of Black Lanterns: three geographic layout blockouts

Date: 2026-10-16. Status: **COMPOSITION-ONLY PREVIEWS — NO PRODUCTION ARENA SELECTED.**

## Purpose and grounding

After the D203 rejection of repeated fortress/viaduct/lantern backgrounds, the assistant revisited the current GitHub source and four conversation-uploaded DARK FORGE skills (designer, artist, developer, producer). The intended result is an original 1280×720 background for card #38 that leaves production fight space clear. Existing `battle.gd` default world-screen floor envelope: X=110..1190, Y=380..538 after UnitsLayer translation. All current 37/45 live content, D200 chosen card illustration, approved D196 surf, DS2, 12+XIII and frozen `backups/KARAMBA73-2026-10-16` must remain unchanged.

Two illustrative image-generation attempts yielded infographic/roadmap images rather than playable arena backgrounds. **Both rejected as wrong-medium output; no engine assets integrated.** Instead, three procedurally drawn, flat-color, pixel-style **layout blockouts** were exported locally as separate 1280×720 RGB PNGs and a comparison montage. File dimensions were checked; render appearance visually inspected. These show geography and negative space, not final artistic fidelity.

## Current three options (NOT approved)

- **A — Black Forest Bend / Изгиб мёртвого леса**: moonlit dead wood with oversized side tree silhouettes, winding road vanishing into fog, two sparse edge lanterns. No fortress or elevated viaduct. Most consistent with the already approved #38 scene theme.
- **B — Drowned Ford / Затопленный брод**: a completely dry raised stone crossing with dark stagnant peat water to the sides; distinguish strongly from #37's wave-covered sea pier. Mid-floor is unobstructed.
- **C — Abandoned Toll Gate / Заброшенная застава**: a tiny distant collapsed guard booth, broken iron toll barrier, carriage wheel, broad worn-stone center road. No combatants baked into art.

The three files and montage are **conversation artifacts only**, bundled as `Misdeal_D201_arena_blockouts.zip`. They are not GitHub runtime images and are not approved final art. No generated UI, enemies or tactical light effects should be baked into the future background. Their simplicity is intentional: this is a composition decision aid, not a pixel-perfect production export.

## Next user decision and quality gate

Ask whether A, B or C is the preferred **geography** (not yet approval of a production bitmap). If the user prefers another scene, revise the brief. Produce **2–3 rendered, distinctly composed, proper Misdeal-quality production backgrounds** for the selected geography, not more low-fidelity blockouts. After an exact visual selection, integrate only the approved source, create QA-only F6 stage with 3 heroes/5 new skeletons (large Guide around 2×) and temporary light-zone overlays, verify feet, contrast and UI clipping, then proceed to five genuine enemy animation atlases. A native Godot F6 pass has NOT occurred in D204. Card #38 is NOT in ordinary `ACT1_CARD_IDS`; the live pool is still 37/45.

No gameplay scripts, game scenes, resources or assets were changed by D204; document-only synchronization is allowed for next-chat continuity.
