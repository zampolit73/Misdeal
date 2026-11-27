# Travel actor source-detail rollout (2026-11-27)

Player requested higher-quality main units in all Travel locations after the rescue correction. Source baseline `6e5205cfe171d9ff1cc9dad3006e3b60a63913d0`. This is a visual-only cross-cutting upgrade of the 24 existing event Travel renderers, seven already-live V5 films, and three staged rescue V5 previews. No new V5 opt-in, card outcome, hero appearance, authored animation pose/order, route, hero scale, combat sprite or save changes.

## Implementation and source identity

The approved 96×96 combat cels are **not** enlarged and filtered to fake HD. Repack the original painted source artwork (before its previous 96 px reduction), including both original rear-walk directions and the 16 just-authored living poses. Each native-detail texture contains 288×288 pixels (3× resolution per axis, 9× samples) but is rendered with a 96×96 logical size through `ImageTexture.set_size_override`. The exact original logical texture remains attached for sole/height/gait calculations; linear sampling draws the high-resolution texture. The presentation-only library copies SpriteFrames, preserving original clip frame count, frame time and loops, leaving the approved BattleUnit cache untouched. Missing/corrupt atlas falls back to the low-resolution art and nearest filtering, not an unavailable Travel scene.

| Atlas | Covered cels |
| --- | --- |
| side_knight, side_ranger, side_jack | Idle4 + walk6 each |
| side_mage | Idle4 + walk6 + staff cast6 |
| rear_ne, rear_nw | 3 heroes × 6 walk cels each |
| living | 4 characters × 4 living recovery/gesture cels |

98 source-detail cels total. All currently used main-unit Travel clips covered, including V5 kneel/rise, Ranger reach, Mage ritual and Jack rest/sit/stand/run. Unused combat-only clips intentionally retain existing battle-quality sprites. Real scene paintings and painted NPCs untouched. Original source cels were extracted using the existing registered 96 px low-detail bounding geometry with native source colour detail, local neutral storyboard-floor matte removed, transparent alpha cleaned. The old dog walk had faint matte pixels above the body inflating the bounding box: new image preserves the original visible silhouette width and source aspect, aligned to the existing sole. Jack uses common 0.95 m nominal stature relative to adult Ranger and fixed 56 px standing reference, not maximum stride envelope, in every Travel renderer; existing follower routes/spacing stay independent from size.

## Source provenance

No new generation or external ingredient in this task. Existing source artworks at baseline are copied/repacked, not regenerated. `scripts/dev/pack_travel_actor_hd.py` is an offline Pillow/numpy/scipy authoring script only, not a game dependency. WebP quality 95 colour, lossless alpha; originals untouched. Existing living pose source PNG was retained from the previous built-in generation receipt (hash below); that original is not separately duplicated in Git. The packed HD cels are tracked and usable without the generation receipt.

- `assets/pixel/units/hero_c3_d412/knight_source.png`: `97016297b9b40fe786500b6ded850617f419d12727f586d44e49e52038dec32b`
- `assets/pixel/units/hero_c3_d412/ranger_source.png`: `6cc421af6f6da1f0494a9316a7391784e1f6a8b0de8266c29d5f431e20ff5dca`
- `assets/pixel/units/hero_c3_d412/mage_source.png`: `145f3bdfefb055770c81b74158f106cbc1912243e4408e2d31f3ca02a57d6f69`
- `assets/pixel/units/jack/source.png`: `7588a5a3fa24448c992ae16aa4157d23da7b64debd1cfbaf44674ca66b135791`
- `assets/pixel/travel/campfire_without_master/rear_walk/source.png`: `9b533ea2f499e18a3c21c10844e332cb54e92d6bd2abc339d89c5a6da8c19d27`
- `assets/pixel/travel/last_dressing_station/rear_walk/source.png`: `0558c019770c0841752081f37f305727fd14027a2da51616cb1b8c90ba299714`
- Previous rescue generated source: SHA-256 `95be1260d763c35bf74a15f777e5328082f62bb73d6b53d768203f18ee00de8b`, prompt and original source references recorded in [rescue evidence](../travel_rescue_v5/README.md).

Exact runtime hashes are registered under `travel-actor-hd-source-repack` in THIRD_PARTY_ASSETS.json. Project-origin declaration only; legacy source and actual release rights review remains open.

## QA

Godot 4.7.2 isolated fixture with actual project Travel resources, scripts, art and imported textures (stub RunState; no production save writes). All 24 legacy location renderers each sampled in a legal party/outcome context with actual Jack flag. 98 HD cels checked through source resources, exact 96px geometry, unchanged combat lookup, all 24 visible actors/follower, linear filter and dedicated F6 recovery.
- [All locations](hd_all.log): 24 locations, 1,887 checks, 0 failures.
- [Missing HD files](hd_fallback.log): 17 checks, 0 failures.
- [Forge](hd_forge.log): 19 contexts, 4,471 checks, 0 failures.
- [Merchant](hd_merchant.log): 66 contexts, 11,870 checks, 0 failures.
- [Road](hd_road.log): 109 contexts, 9,525 checks, 0 failures.
- [Rescue](hd_rescue.log): 128 contexts, 20,861 checks, 0 failures.
- Production-router regression: [Forge](hd_forge_live.log) 19 contexts / 229 checks, [Merchant](hd_merchant_live.log) 69 / 1,596, [Road](hd_road_live.log) 112 / 2,077, zero failures.
- Offline source-cel before/after inspection and actual Godot sampled Sprite2D compositing (Jack, Prisoner and Altar) reviewed at logical native stage scale. Native GPU framebuffer/Windows visual acceptance still pending.

F6 `scenes/dev/travel_rescue_v5_preview.tscn` and existing Forge/Merchant/Road previews; use existing QA Hub Travel locations to verify V4. F5 actual 24-location routing stays unchanged (7 V5, 17 V4). User should evaluate sharper faces/armour/clothing and consistent Jack while moving. Native gameplay and save behavior unchanged.
