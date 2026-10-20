# D311 — Wizard condition plaque: approved third reference variant

User explicitly selected **«3 вариант»** from three separate illustrated Battle screen concepts after asking to further refine the optional Wizard panel. Previous D307 larger finial/studded panel had been corrected in D309 but user preferred the **third illustrated layout**: compact horizontally carved dark-wood/aged-bronze frame, **hooded Wizard silhouette in a round medallion at left**, restrained red cloth and simpler separate header + body wells.

## Source artwork

- `assets/pixel/ui/battle_ds3_d311/wizard_variant3_isolated.png`: the **selected third concept itself**, isolated at original crop resolution as transparent RGBA artwork. Removed the baked Russian headline/reward lines from the two dark material wells; no gameplay text, health, enemies, fake UI actions or arena/background should be baked as functional interface.
- `assets/pixel/ui/battle_ds3_d311/wizard_variant3_game.webp`: 286×153 game-size WebP for direct Godot rendering. The art is deliberately rasterized at target resolution to avoid the old giant imported-texture problem.

The original third concept was a flattened **Battle screen mockup**, not layered native UI art. The extracted material keeps its painted character, but requires native visual check at actual game scale; do not claim perfect transparency at every finial before seeing it in Godot.

## Live UI integration

Production `scripts/battle/battle_ds3_pass.gd` now loads `wizard_variant3_game.webp`, while maintaining the existing D309 `battle_wizard_plaque_canvas.gd` explicit draw path and real `SideObjectivePanel/ObjectiveLabel` canonical data.

- Art Canvas local position (-15,-12), fixed destination (286,153).
- Source parent panel **unchanged**: preparation (22,575), combat (98,165). Actual art bounding boxes prep (7,563)–(293,716), combat (83,153)–(369,306) in 1280×720 viewport. No overlap with party health/team or scene edge.
- Real heading `D307WizardHeading` moved to local x62,y13,w204,h34.
- Real body `D307WizardBody` moved to local x65,y57,w190,h65. These Labels remain live and reflect real reward, failure reason, timed condition, etc. Both headings and bodies are never baked into the raster.
- All previous D306/D308 production + F6 smoke tests retain scene and node names and now check D311 art dimensions, alignment and optional condition behavior. Workflow watches D311 assets.

**No changes** to Knight/Ranger sprites, graveyard arena, enemy AI, RunState, +15 gold condition payout, the original 3–5 tactical Buttons, Fight or the D303-approved main Battle UI artwork.

## User verification

After pulling `main`, Godot `scenes/dev/d308_wizard_panel_preview.tscn` → F6. Test `Подготовка`/`Бой`, all 3 rule strings, `Успех`/`Провал`, and `Открыть настоящий бой`. Compare actual new third-style medallion/wells with user's selected third reference. Godot native test and user screenshot **pending**. Selected variant 3 art direction is approved; the final Godot composition is not yet explicitly approved.

Restore point: DS2 checkpoint `4cbd206`. Previous D307 skin retained in repo for art fallback/reference but no longer the active texture in Battle.
