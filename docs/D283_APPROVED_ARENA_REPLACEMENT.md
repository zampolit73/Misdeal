# D283 — Two user-approved full-resolution battle arena replacements

2026-10-20. **Runtime art integrated; official native CI PASS; user reports no blockers («Все ок)»).**

## Accepted originals (DO NOT substitute different generated versions)

| Battle arena ID | Original selected art filename in conversation | Runtime WebP | File bytes | SHA-256 |
|---|---|---|---:|---|
| `bone_ritual` | `лунная_арена_разрушенного_собора.png` | `assets/pixel/battle/arenas/approved_d283/bone_ritual.webp` | 226362 | `48e3606c4677456a39f4e8b67ee3c861e1eb0a0c571d1d47dad9af05e78aae9a` |
| `firing_square` | `готический_двор_под_кровавой_луной.png` | `assets/pixel/battle/arenas/approved_d283/firing_square.webp` | 192408 | `ed06c800484f41b249559622a373c7b543573967fd630cd1af913661b7ddbccd` |

- `bone_ritual`: approved cold moonlight / sparse ivory-bone crescents around the altar on the right / ruined open Gothic cathedral / wide stone combat floor. More ornate overloaded alternatives were rejected.
- `firing_square`: **option 1** of the subsequent three-art execution courtyard set, raised wooden gallows/cage structures against fortress wall, scattered flames and moonlight, free central ground. Different from ritual altar scene.
- Both originals were 1672×941 PNG. Export was an accurate image resize to **1280×720** (LANCZOS), high-quality opaque RGB WebP (quality 87 / method 6), **not regenerated** or replaced by proxy SVG/thumbnail.

## Runtime contract / rollback

Two and **only two** `scripts/battle/authored_backdrop.gd` entries were updated:
```gdscript
ARENA_BONE_RITUAL: "res://assets/pixel/battle/arenas/approved_d283/bone_ritual.webp",
ARENA_FIRING_SQUARE: "res://assets/pixel/battle/arenas/approved_d283/firing_square.webp",
```
The original `assets/pixel/battle/arenas/arena_redraw_v1/{bone_ritual,firing_square}.webp.b64` remain tracked for instant rollback. All other 14 environments, 39/45 Act1 cards, encounter data, RunState, BattleUnit, unit placement/floor, tactical HUD, class screen, loot and Fate Spread are unchanged.

## Gates

- Native regression job: `.github/workflows/d283-two-approved-arenas.yml` uses official Godot 4.7.2 to import/parse the project and instantiate the **real production `AuthoredBattleBackdrop`** for both IDs, verifying runtime image sizes, opaque combat floor and immutable SHA256 against source WebP.
- Official native run [D283 #39374993074](https://github.com/zampolit73/Misdeal/actions/runs/39374993074) completed **SUCCESS**, checking selected WebP file integrity and real backdrop loading. No fake native screenshot claim.
- After being asked to check both battles in local Godot, the user replied **«Все ок)»** on 2026-10-20. Close D283 as a **no-blocker user-accepted arena artwork pass**. This response does not independently prove frame-perfect unit placement or a formally logged full Fight→Reward→Table regression.
- Both exact production images remain fixed; no more review required unless future local screenshots reveal a specific issue. For further variety proceed to **`grave_crossfire` options-first**; this is a new task, not permission to replace anything yet.
