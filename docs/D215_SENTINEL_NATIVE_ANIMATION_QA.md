# D215 — Road Sentinel A: original 25-cel animation QA candidate

Date: 2026-10-17. Status: **ART CANDIDATE SOURCE-INTEGRATED, STATIC QC PASS, USER-REPORTED NATIVE F6 / ART REVIEW OK (2026-10-17)**. Ordinary Act1 **37/45**, #38 QA-only.

## What genuinely changed

After D211 option **A** was user-selected and D213 corrected the atlas contract, D215 created a **new, native-size, transparent pixel-art** Road Sentinel animation candidate by directly drawing separate skeletal poses through per-state controlled bone joints, boots, armor plates, pole weapon, moving hanging lantern and falling poses. This is not the invalid previous cropped 5x5 atlas, nor a presentation sheet sliced into fake cels. Its artistic design is original **hand-authored parametrically**, following armored spear Sentinel A: asymmetric pauldron, bone skull, worn iron chest armor, LONG METAL-TIPPED SPEAR **not an axe**, hanging amber lantern, visibly planted foot poses. It is a first deterministic / low-detail pixel draft, and **not declared final production art**. The user should approve/reject its art fidelity separately from layout QA.

Files **actually committed to GitHub**:
- QA-only raster: `res://assets/pixel/units/black_lantern_road_qa/road_sentinel_d215_candidate.webp.b64`. It is 576x480 lossless WebP/Base64, created by direct drawing in each 96px tile, in corrected rows (idle4+2clear, walk6, attack6, hit3+3clear, death6).
- Reproducible authoring source: `tools/art/author_road_sentinel_d215.py`, using Python/Pillow **offline for asset production only** (not a Godot runtime dependency). Exports PNG, lossless WebP, Base64, JSON QC and montage. The Python art code is original to Misdeal project; no font/assets embedded or redistributed.
- New Godot **isolated animation preview scene**: `res://scenes/dev/black_lantern_sentinel_animation_preview.tscn` plus `scripts/dev/black_lantern_sentinel_animation_preview.gd`. Loads the exact approved D209 forest via existing `authored_backdrop.gd`, decodes the candidate atlas, performs per-cell alpha/duplication/transparent-slot and border QA, builds five `SpriteFrames` animations, offers 5 UI buttons and shows **3× preview plus 1× game-size**. It does **NOT** add `road_sentinel` to `MisdealUnitAnimationLibrary.ROLES`, modify `unit.gd`, affect battles, enable card #38 or change party balance.

Static output (offline Pillow QC): **576×480 RGBA**, 6×5, **25 nonempty unique cells**, **5 alpha-empty surplus cells**, **0 border-contact warning poses** after small adjustment of prone death frames. Source and GitHub WebP/B64 roundtrip compared and found identical. This does **not** prove authored frames achieve desired artistic fidelity, clean motion or stable foot contact in Godot. 4 idle poses are deliberately subtle, 6 walk poses create two grounded strides, 6 attack poses perform horizontal spear thrust, 3 hit recoil poses, 6 death stages ending prone. Review in motion before artistic acceptance; there may be silhouette improvements needed compared with D211 painterly reference. A previous image generation attempt yielded a labelled dark presentation sheet (Lantern Bearer) rather than a properly transparent playable asset; that output was **not committed as any runtime or QA sprite**.

Conversation-only QA materials (not GitHub):
- `Misdeal_D215_Road_Sentinel_Animation_QA.zip`: 6 files, including independent transparent PNG atlas, native WebP, b64, exact source author, a real 5-row overview and QC JSON.
- `D215_sentinel_animation_contact_sheet.png`: visual test board with 25 authentic candidate frames and checkerboard alpha reference. No labels exist inside committed atlas.

## F6 first-run gate (user)

1. `git pull`
2. Open **`res://scenes/dev/black_lantern_sentinel_animation_preview.tscn`**; press **F6**.
3. Click `ОЖИДАНИЕ`, `ХОДЬБА`, `АТАКА`, `УРОН`, `СМЕРТЬ`. Examine the first 3× sprite on dark stage for readable actual bone joints and spear-tip continuity; second 1× sprite on exact accepted D209 art for role silhouette, foot placement, attack impact/direction and leg movement. One-shot death should finish with a grounded corpse, not vanish.
4. If screen says `D215 / QA FAIL` or Godot parser errors, fix them directly in GitHub and rerun.
5. Even if all states animate and static QA passes, **ask user whether art fidelity is adequate** before connecting to the real battle. The D215 procedurally illustrated draft is visibly simpler than the approved scenic art; if rejected, keep it QA-only and improve/art-direct rather than falsely label finished.

## User native gallery confirmation — 2026-10-17

After F6 five-state Road Sentinel gallery instructions, user replied **«все ок продолжай дальше»**. This supports accepting the D215 standalone animation for proceeding to next character art, not full game battle/production sprite activation. Next character is D216 original Lantern Bearer: `docs/D216_LANTERN_BEARER_ANIMATION_QA.md`.

## Next actual production

If user accepts the quality or gives concrete improvements, correct this Sentinel sprite candidate and obtain native final-motion approval. Then create **original 25-cel** `lantern_bearer` following `docs/D214_LANTERN_BEARER_PRODUCTION_SPEC.md`: broad defensive wooden barricade/shield and separate heavy amber lantern, not another spear guard or a borrowed old skeleton. Continue oil acolyte, giant Guide and bow archer. Build an isolated native gallery for each; only after five art gates connect original #38 combat and scoped lanternlight, verify the real Battle→Reward→Table, 54-case matrix and release smoke; then Act1 can become 38/45.

Preserve D200 accepted third card illustration, D209 accepted original third forest arena, D196 approved storm, DS2, Fate Spread 12+XIII, +16% original local lantern-speed baseline, and frozen `backups/KARAMBA73-2026-10-16`. This was exclusively QA asset + dev preview source integration, not a gameplay milestone.
