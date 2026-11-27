> Superseded on 2026-11-28 after player feedback on the discontinuous insert. Use the [continuous relic polish review](polish.md) for current F6 and evidence; the older candidate below is historical.

# Cinematic Travel V5 — Relic transactions (2026-11-28)

Review-only candidate on the approved scene-first, human-scale direction.
No campaign selector change: 10/24 V5 in production, 6 staged (including 3 previous rescue candidates), 8 not yet staged.

## F6 player review

Open `scenes/dev/travel_relic_v5_preview.tscn`, F6. Z/X scene, arrows action,
1/2/3 party size, Q/E party composition, J actual Ranger companion toggle,
P pause, R replay, H clean view, M mute. Default trio, success.

| Location | States | Source worksite projection | Source origin |
|---|---|---:|---|
| Стол невыплаченных долгов | gamble_success, gamble_failure, safe, break, leave | 0.29 | (660,363) |
| Чаша под открытым небом | gold, blood, refuse | 0.34 | (384,351) |
| Пустое место последнего властителя | wear, break, melt, leave | 0.23 | (730,381) |

6.6-second deterministic films, human-height approach, local lights, authentic existing HD hero/Jack cels and original registered outcome overlays, then road exit.
For actual transactions, 2.45–4.02s is a separate full-frame original-art insert;
old local animated cels and the exact final state at 3.22s, then the matching small
worksite. A sparse single-pose dice break keeps the intact painting until impact.
Pass never cuts, stops to interact or changes the painting.
No newly drawn hands, new dice roll, rewards, invented party members, live route, or save changes.

## Provenance

Pinned originals at `a9d276cb768b8801f1af67f4c9230fd24b80a537` in `assets/pixel/travel/batch_02/<id>/`.
Generate separate empty wide paintings from the three original masters only: wet
vaulted dungeon, windswept circular terrace, ruined Gothic cloister. No characters,
tables or relics baked into the generated wide plate. `pack_relic_v5.py` extracts
source-registered original worksite (including props and original painted character)
and composites exact prior outcome layers, feathers edges and downsamples to
640×360 alpha WebP. The generated plate is 1280×720 WebP Q89; worksite Q92,
alpha Q100. Original full-sized source art, all local cels and V4 continue unchanged.
New project-origin asset hashes are registered in THIRD_PARTY_ASSETS.json.
Historical source/tool rights review remains an open release audit item.

## Focused check

Godot 4.7.2 isolated routing fixture, 12 outcomes × all 7 real compositions,
plus Jack on/off for the four Ranger compositions: **132 contexts / 26,531 checks / 0 failures**.
Checks: actual composition, exact original action schedule, single world/insert,
state transfer, only living HD poses, intact adult dog proportion, grounded soles,
camera coverage, onward route, replay and F6 controls. Headless F6 scene also
launched. Earlier initial smoke exposed sparse source manifests; fixed the
single-impact case and checked native authored timing instead of assuming
every manifest begins with a pose. No full campaign or framebuffer test.
Offline composites sampled from actual Godot textures, positions, visibility,
modulation and camera transforms; shader effects not reproduced. Native player
review pending before production opt-in.

[Smoke output](smoke.log) · [sampled visual evidence](samples.jpg).

[Source hash receipt](provenance.json).
