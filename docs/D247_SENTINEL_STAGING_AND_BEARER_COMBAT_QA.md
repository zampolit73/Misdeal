# D247 — Sentinel D244 staged; Lantern Bearer D224 one-character combat QA

Date: 2026-10-19. User responded **«так вродвсе ок. продолжай»** after D246 real BattleUnit 1v1. Interpret as **provisional no-blocker feedback for in-battle Sentinel movement**, NOT exhaustive video validation, final character art signoff or full #38 encounter approval.

## Sentinel next stage
- The previous canonical `assets/pixel/units/deck_expansion_v1/road_sentinel_frames.webp.b64` held visually rejected D229. Now the file points to **exact same git blob** as D244's illustrated lossless 25-pose QA asset. Legacy D229 original remains separately stored as `assets/pixel/units/black_lantern_road_qa/road_sentinel_d229_art_candidate.webp.b64`.
- Only the `road_sentinel` role in `MisdealUnitAnimationLibrary` is staged. It does not add #38 to `RunState.ACT1_CARD_IDS`; default 37-card run remains unchanged. Animation counts 4/6/6/3/6 and validation (25 distinct, padded, five transparent) remain mandatory. All actual `UnitData` speed/damage/attack/HP are untouched.
- The original D230 comparison smoke is updated (same scene path) to display D229 **archive** on left and current **D244 runtime** on right, requiring the canonical file to byte-match D244 QA before passing. It is a QA staging comparison, not release confirmation.

## Next enemy — user-approved D224 Lantern Bearer (shield + freehand lamp)

The user had approved its **rich original source** on 2026-10-17; see `docs/D224_LANTERN_BEARER_APPROVED_ART_QA.md`. The existing 96px D224 repack passed 25 unique/margins checks, but source image overlapped some nominal cell cuts; actual 1× foot/weapon attachment is unverified. **Never label it production-ready solely for technical repack**.

New scene `res://scenes/dev/black_lantern_bearer_d247_combat_preview.tscn` uses **real `BattleUnit` Bearer vs real Knight**, on exact approved D209 dark forest. It injects D224's repacked `lantern_bearer_d224_approved_repacked_candidate.webp.b64` only into the one instance, with real auto-target, walking/turning, melee shield bash, hit and death. Replay, swap left-right and force death available. Only `max_hp ×3` prolongs visual QA; all movement, attack timing/range/size parameters come from the original `lantern_bearer.tres`. The Bearer source art faces RIGHT; `BattleUnit._set_facing_left` already flips such roles normally, so no library-facing change.

**Native Godot F6 is NOT yet observed for new D247 scene.** User should `git pull`, F6 the one above; report if shield/lantern detaches, feet slide, incomplete falls, wrong facing or clipping. If it looks okay, stage D224 art for future #38 and proceed to next original role. If not, repair 25-pose repack itself rather than relaxing alpha thresholds or substituting a generic skeleton.

No changes to #38 encounter, cards, global Bearer roles, real battle effects, D200/D209 approved art, frozen `backups/KARAMBA73-2026-10-16`, DS2 or Fate Spread XIII. **Live 37/45**.
