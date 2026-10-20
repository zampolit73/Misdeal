# D283 — Two user-approved full-resolution battle arena replacements

2026-10-20. **Runtime art integrated; user-native screenshot QA still open.**

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
- Automated green **is not** proof of user visual acceptance, party animation/foot placement, or completed Battle→Reward→Table. These remain user-native QA gates.
- Next action for user: `git pull`, launch Godot at 1280×720, play `bone_ritual` and `firing_square` encounters, verify readable dynamic units are planted on the visual combat floor, appropriate active environment, and normal reward return. Send screenshot only if a concrete visual issue appears. Do not start further re-generation of these locked images without new direction.
