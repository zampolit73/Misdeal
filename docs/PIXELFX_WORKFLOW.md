# PixelFX for Misdeal — reusable VFX workflow

**Status:** available as a project skill and implementation guide; **not installed into the Godot runtime**. No PixelFX effects are shipped by this document alone.

- Project: `zampolit73/Misdeal` (Godot 4.7.x, GDScript)
- Skill: `.agents/skills/misdeal-vfx/SKILL.md`
- Upstream: https://github.com/patch-gg/pixelfx
- Live catalog: https://github.com/patch-gg/pixelfx/blob/main/docs/CATALOG.md
- Upstream license/notices: https://github.com/patch-gg/pixelfx/blob/main/LICENSE and https://github.com/patch-gg/pixelfx/blob/main/NOTICE.md

## When to use

Choose the workflow when asked to create or improve battle hit sparks, magic, curses, auras, environmental atmosphere, loot feedback or a sprite-sheet effect. Start by checking whether Misdeal already has a suitable effect. Do **not** use it to rewrite the tactical autobattler, regenerate approved card art, replace unit animation packs, or introduce a new visual style.

The game's current hooks include:

| Existing location | Responsibility | Rule |
|---|---|---|
| `scripts/battle/unit.gd` | attack/hit/death animation, damage feedback and hit-stop | Existing timing and gameplay remain authoritative |
| `scripts/battle/unit_attack_visuals.gd` | compact per-role contact visuals | Prefer adapting this hook if a future implementation is authorized |
| `scripts/battle/battle_motion_fx.gd` | tactical-order feedback | Preserve readable order information |
| `scripts/battle/battle_visual.gd` | arena/atmosphere overlays | Do not duplicate already-baked environmental effects |
| `scripts/battle/unit_animation_library.gd` | existing character SpriteFrames resources | Preserve 25-pose, 96×96 approved atlas format |

## Offline asset authoring (not a game dependency)

1. Use a separate working folder, outside the Misdeal checkout; do not vendor all 244 effects into the game.
2. Pin/record the PixelFX Git commit used for each exported effect. Requires Node.js 18+ for tools; ffmpeg is optional for video/GIF previews.
3. Inspect the [catalog](https://github.com/patch-gg/pixelfx/blob/main/docs/CATALOG.md) or query the upstream list script. Preview 2–3 candidates at actual scale, favoring reuse and recoloring.

```bash
git clone https://github.com/patch-gg/pixelfx.git
cd pixelfx
git rev-parse HEAD
node tools/list.mjs "shield"
node tools/render.mjs impacts/shield-block --sheet
node tools/render.mjs arcane/spell-charge --sheet
node tools/render.mjs spawn/soul-rise --sheet
```

Expected per-effect outputs are `records/<category>/<name>/contact.png`, `<name>.png` (transparent grid) and `<name>.json` (Aseprite-style frames plus `meta.pixelfx` fields). Verify the actual output and animation; do not treat a static contact sheet as motion QA.

For a **new authored** effect, follow upstream `docs/AUTHORING.md`: define the silhouette/motion, adapt existing code, render and look, revise, then run `node tools/check.mjs <category>/<name>`. Keep deterministic seeds; reject noise, loop seams, clips, bloated glow and slow/unclear timing.

## Import contract for a *future approved pilot*

- Stage only selected exports (for example under `assets/pixel/vfx/pixelfx/<effect_id>/`), with a tiny provenance manifest: upstream repo + commit, effect ID, render options, generated files, license/NOTICE obligations, pivot, fps and usage notes. Follow existing asset packaging constraints; do not silently convert unrelated `.webp.b64` files.
- Import transparent PNG into Godot as a sprite sheet. Use native `SpriteFrames` / `AnimatedSprite2D` or existing `Sprite2D` + `AtlasTexture` as appropriate. Parse JSON frame rects/durations or set the matching grid and fps explicitly. An Aseprite-style JSON is **not** an automatic drop-in game script.
- Set nearest-neighbor sampling and verify alpha, pivot, frame size, per-frame duration, looping and end-of-effect removal. Use Godot's local coordinate spaces and current z-order: floor/magic circles behind feet, impact accents in front, with HP bars/UI unobscured.
- Never bake PixelFX's generic dummy character into a production hero/enemy. Some actor-bound effects need a bespoke mask/port rather than a direct export.
- Preserve existing `unit.gd` damage timing, target selection, hit-stop (currently small style-dependent freezes) and approved animation cels. The upstream `act` metadata may inspire later work but must not override game behavior.
- The original 25-pose character packs are separate from VFX. Do not force effect-sheet frames into the 6×5 character atlas.

## Misdeal visual acceptance

Follow `docs/ART_DIRECTION.md`: quiet negative space, readable focal silhouette, limited palette and motivated light. Check native 1280×720 at 1× scale, against approved Knight/Ranger/Mage and relevant enemy/arena art. Intense rainbow explosions, generic rune clusters, visible pixel noise, harsh full-screen flashes and glowing overlays with no in-world source are likely wrong for Misdeal.

A suggested **first pilot**, only after separate implementation authorization:

1. Shield block (`impacts/shield-block`): short, legible impact at the actual contact.
2. Mage charge (`arcane/spell-charge`): restrained purple/teal ramp, with no change to attack cadence.
3. Undead soul (`spawn/soul-rise`): small fade following existing death art, not replacing it.

Use a **separate developer F6 preview** before live integration. Capture at least baseline/FX comparison and one native-scale frame plus motion evidence per effect.

## Verification and release gates

For a docs/skill-only change: check frontmatter (`name` and `description`), paths/links, unchanged existing `AGENTS.md` sections, and GitHub diff restricted to the requested three files. Runtime/GUT/F6 tests are **not applicable** to documentation-only changes; do not claim they ran.

For any later asset/code pilot:
- Validate source export and, for custom code, upstream `tools/check.mjs`.
- Inspect Godot 4.7.x F6 motion, sprite size, feet/target anchors, loop exit, scene reload and performance; run relevant GUT/native smoke + PR checks.
- Confirm no changes in damage, cooldowns, AI, saves, card routing, balance, character atlases or approved art.
- Keep the old visual and describe the rollback path. Obtain artistic approval for actual native visuals before shipping.

## Legal and reuse

PixelFX effects and code are MIT licensed (upstream includes Patch and Hugo Duprez copyright). If incorporating/substantially copying code or effect assets, preserve the copyright/license text and applicable third-party NOTICE statements alongside the shipped material. The `gallery/fonts` Patch Pixel font is **not** MIT and must not be copied. This skill intentionally copies no upstream code/assets.

Use this workflow in future VFX tasks; it does not authorize unattended asset changes or require repeated manual setup of PixelFX inside Misdeal.
