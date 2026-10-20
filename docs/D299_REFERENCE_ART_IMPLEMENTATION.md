## D300 image-quality correction (2026-10-20)

Following two real D299 user Godot screenshots, the D299 source crop compression was found too aggressive (74×127 banner; 44×135 candles, upscaled). D300 retains the original reference-art intent with a new higher-resolution packed WebP in `assets/pixel/ui/battle_ds3_d300/reference_fragments_hq.webp.pack.b64`; decoder in `scripts/ui/battle_reference_fragments.gd` now points there. D299's original byte spans recorded below remain accurate only for rollback to that pack. Current production pack: 23,510 binary bytes / 31,348 encoded chars; `banner` 0–7454 (111×189), `medallion` 7454–12862 (88×113), `candles` 12862–17566 (57×172), `wax_ribbon` 17566–23510 (84×178). Native smoke asserts exact dimensions and transparent corners. No new painted words or fake UI. Artistic acceptance requires post-D300 actual Godot screenshot.

# D299 — Approved Battle reference: source-painted runtime decoration

Date: 2026-10-20. User approved continuing after a new richly illustrated **second Gothic DS3 Battle composition**. The design's displayed words/buttons/hero/enemy characters are **reference-only**, never to be pasted into the game.

## Source and artwork

The selected concept is the recently rendered `Могильный перекрёсток` screen, 1672×941 pixels. A local asset-preparation pass isolated four reference-art ornaments through hand-directed alpha mats. Only these source-pixel fragments (and **not** the entire flattened screenshot) are stored:

| ID | Native decoded size | Packed byte span | Intended panel |
|---|---|---|---|
| `banner` | 74×127 | [0,2378) | `TopHudPanel/DS3PaintedBanner` |
| `medallion` | 74×96 | [2378,5348) | `RunHudPanel/DS3PaintedMedallion` |
| `candles` | 44×135 | [5348,7400) | `BottomHudPanel/DS3PaintedCandles` |
| `wax_ribbon` | 64×135 | [7400,10084) | `FightHudPanel/DS3PaintedWaxRibbon` |

- Immutable bytes in GitHub: `assets/pixel/ui/battle_ds3_d299/reference_fragments.webp.pack.b64`, 13,448 base64 characters (=10,084 concatenated WebP bytes). Verified stored text FNV1a32 `a440ed74` against the extracted source pack.
- Decoder: `scripts/ui/battle_reference_fragments.gd` uses `Marshalls.base64_to_raw`, exact slices, `Image.load_webp_from_buffer`, and cached `ImageTexture`. No external third-party runtime image library.
- Composition: `scripts/battle/battle_ds3_pass.gd` attaches four `TextureRect` with `MOUSE_FILTER_IGNORE`. Preceding D298 SVG art remains in source control **for selective rollback** but the overlapping banner/medallion/Fight ribbon nodes are not created in D299. Original text-free D298 background plates and small gold finials remain in use.

These hand-matted fragments preserve the exact material pixels from the displayed D299 concept as best the isolation allows; they are **not a claim of perfect source alpha** or a complete pixel-perfect UI implementation. Hard edges, tiny source-baked environment pixels and resampling may still require real-screen review at 1280×720.

## Must stay dynamic and unchanged

- Real `Title`, `Status`, `DealLabel`, `RunConditionLabel` and complete hover modifiers, `PlacementHint`, real target-preview and Fight/Continue handlers.
- All original 3–5 tactical `Button`s, selected/locked state, combat damage/AI, actor foot position/HP, arena art, RunState, route to Reward.
- DS2 snapshot: `checkpoint/ds2-pre-ds3-2026-10-20` at SHA `4cbd206`.

## QA and acceptance

`scripts/dev/d291_battle_ds3_smoke.gd` now confirms all eight named art surfaces in the **real** Battle, no overlapping D298 copies, successful cached WebP decode and non-capturing input. Workflow: `.github/workflows/d291-battle-ds3.yml` (Godot 4.7.2). **Do not claim native CI PASS without an actual workflow result**; the public Actions page could not be inspected in this session. The next visual gate is the user's fresh Godot **1280×720** preparation screenshot of Grave Crossfire with 3 tactics (also review 4/5 unlocked and the special-objective case). Confirm pointer actions and collision/occlusion before artistically approving D299.

**Local action:** `git pull`, open the existing `Могильный перекрёсток` preparation, test Hunt→Formation and Fight, send screenshot. Do not request the user to manually copy any source files.
