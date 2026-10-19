# D257 — Three Black Lantern character atlases: seam-recovery QA stage

**Date:** 2026-10-19. **Branch:** main. **Scope:** three established D255 user-style-approved enemies for unreleased card #38. **Not a production art sign-off.**

## Delivered in this session

- Added deterministic \`tools/art/author_black_lantern_d257_seam_recovery.py\` and build workflow \`.github/workflows/d257-seam-recovery.yml\`. GitHub Actions ran successfully on the real tracked 1374×1145 transparent originals.
- Instead of blindly cutting 229×229 panels, the author gathers alpha-connected details from the **entire source row**, determines their owner using central-body alpha mass, and transfers unambiguous spillover detail back to that frame. Components spanning two strong neighboring bodies would be surfaced as unresolved rather than guessed. Only outer horizontal source portions are warped to fit; center body scale stays unchanged.
- Recovered components by role: **Guide 9, Oil Acolyte 10, Archer 8**. These are **component counts, not 27 certified repaired frames**. D255's original 12/13/9 edge warnings are source-diagnostic and not automatically disproved by a new machine check.
- A second localized pass adds a short source-colored lower contour to exposed bottom-edge silhouette fragments; all 75 frames receive the same source-space -6px vertical shift to keep cycle alignment. This remains an **ART REVIEW candidate**, not proof that truncated real boots were perfectly repainted.
- Three generated assets in \`assets/pixel/units/black_lantern_road_qa/\`:
  - \`extinguished_guide_d257_seam_recovery_qa.webp.b64\`
  - \`oil_acolyte_d257_seam_recovery_qa.webp.b64\`
  - \`lantern_archer_d257_seam_recovery_qa.webp.b64\`
- Actual GitHub Actions source processing and atlas QC **PASS** for **3×25 distinct states**, 5 true alpha-clear spare cells per role, 2px output alpha margins, 576×480 lossless WebP/Base64 decoding. See \`docs/qa/D257_SEAM_RECOVERY_QC.json\`.
- The report still explicitly records **11 original vertical source-edge warning sites**: Guide **4 idle** (bottom), Acolyte **4 idle** (bottom), Archer **3 attack** (bottom). They require native visual judgement; do not treat reduced warnings as automatically finished artwork.
- New single combined F6 scene: \`res://scenes/dev/black_lantern_d257_three_character_art_preview.tscn\` (all three sprites, ×2.1 and true ×1, five animation states, both facings). D255 QA version retained for rollback/comparison.

## ART HOLD and next gates

1. **User-native Godot 4.7 F6 NOT RUN here.** Check Guide's rigid yoke plus exactly three linked lamps, Acolyte's tank and held burner, Archer's actual bow draw/release and attached side lamp; all five states in both directions, especially ATTACK and DEATH; inspect toes/sole contact and 1× readability. D257's programmatic component transfer and bottom-contour extension may still leave missing or deformed parts. Visual failure must trigger an internally corrected complete three-character pack, not 75 individual approvals.
2. If F6 acceptable, stage the **exact D257 candidate** in temporary five-enemy **3v5 QA**, then register all three in shared animation library only after artistic and real-Battle QA. Keep D244 Sentinel and D224 Bearer byte-exact.
3. Use D254 real Battle→Reward→Table launcher for solo/duo/trio and both formations, run normalized **54-case balance matrix**, check previously observed easy three-hero wins and overlapping HUD; only then consider releasing **\`black_lantern_road\`** as card 38/45.
4. **No change** to RunState.ACT1_CARD_IDS (37/45 live), encounter balance, original illustrated sheets, D253 light, DS2, approved D209 arena, 12 Fate resolutions + boss XIII, or frozen KARAMBA73 checkpoint.

## Reproducibility and QA levels

Generation is a **GitHub Actions source transform** from tracked original images; the automated workflow writes the three *.webp.b64 assets plus a detailed report and commits them with its bot account. CI success demonstrates generator execution and static structure, **not** visual animation quality, foot contact, game import or a user-played scene. The full result may be resumed from main with \`docs/HANDOFF.md\` and this file, without reading previous chats.
