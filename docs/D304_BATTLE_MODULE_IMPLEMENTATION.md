# D304 — Native integration of approved D303 Battle art modules

**Decision:** The user approved five separately rendered high-resolution, transparent Gothic Battle UI modules in D303. Do not replace them with SVG sketches or flattened fake HUD images. D304 integrates them *conditionally* with the production Godot 4.7 Battle, pending binary upload and native acceptance.

## Implemented source changes

- `scripts/ui/battle_approved_modules.gd`: checks that **all five** real .webp assets are importable before enabling painted art. If any are absent the existing D301 HUD stays unchanged, so a code-only `git pull` still boots. If all are present, hides the old lower D298/D299 ornaments and procedural chrome, displays complete command and Fight bases under real controls, switches each of the five actual tactical Buttons between approved selected/idle skins and gives the real Fight Button its own painted skin.
- `scripts/battle/battle_ds3_pass.gd`: installs approved modules after other UI setup; tactical selection changes the actual live skin on every press, without touching stats, scene routing or signals.
- `scripts/ui/battle_engraved_frame.gd`: keeps only the tiny genuine tactic-specific glyph over a painted button, never an old double frame.
- `scripts/dev/d291_battle_ds3_smoke.gd`: preserves checks for authentic original units/UI/tactic callbacks/hover behaviour and branches to verify both the old fallback state and the fully imported D304 artwork. The official Godot workflow is now also triggered when the .webp files are published.

## Asset pack and local installation

**Approved source:** `Misdeal_Battle_DS3_D303_approved_modules.zip`, 5 RGBA PNG originals at their original render size; unchanged and archived in this conversation.

**Game-ready bundle:** `Misdeal_D303_Godot_final_art_bundle.zip`, generated from exactly those originals, preserving alpha and material texture. Includes original full-asset optimized WebPs, five in-game footprint derivatives, and `manifest.json`.

Only these five `*_game.webp` files are mandatory under
`assets/pixel/ui/battle_ds3_d303/`:

| Filename | SHA256 |
| --- | --- |
| `command_game.webp` | `dedee26e488bd75ecbda28014dd62cc16cb9212e8d023613f330d6c4a66dcc47` |
| `fight_panel_game.webp` | `343f85ec4af6088f51112cf152b6538162d625dee887b6b78413fe1764cf041c` |
| `idle_game.webp` | `d9a08beb75a645134c114b4a7362721ecbf824fd1c65d359a1c12da2263d46a9` |
| `selected_game.webp` | `991635cdbb1de565f48f4b9a9bcf9bf6ad5262064361e9c07d480f21a1e206db` |
| `fight_button_game.webp` | `bdccdd7d0730b9e8cce312de6eb5d754c548aa2c9d186d0b0363ea8ab0d3d4c6` |

The connected GitHub UTF-8 file writer cannot directly transfer local image bytes. Instead, `tools/install_d303_battle_art.ps1` verifies the cryptographic hashes, installs only the five asset files and the manifest in the user's local clone and, with explicit `-Publish`, commits **only these assets** and pushes them to `main`. No manual code editing, bulk `git add .` or screenshot upload is needed.

On Windows:
1. Download `Misdeal_D303_Godot_final_art_bundle.zip` from this conversation to `Downloads`.
2. `git -c gc.auto=0 pull --ff-only`.
3. `powershell -ExecutionPolicy Bypass -File .\tools\install_d303_battle_art.ps1 -Publish`.
4. Restart Godot, open a 1280×720 actual Battle, verify 3/4/5 tactics, in-panel hover, target toggle, red Fight action, bottom art visibility, all units/HP/floor, no frame doubling; send a real screenshot.

Once the user publishes the source pack, later clones need only `git pull`: real binaries will then be in GitHub. Do not mark the art committed to GitHub before that push succeeds. The Godot native regression, D304 visual signoff and 3–5 unlocked cases remain pending until their real result is inspected. Checkpoint `checkpoint/ds2-pre-ds3-2026-10-20` at `4cbd206` is unchanged.
