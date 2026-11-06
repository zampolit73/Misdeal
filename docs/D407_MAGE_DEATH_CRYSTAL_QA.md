# D407 — Mage death crystal stops glowing after death (2026-11-06)

## Grounded observation

The user's genuine `17-13-13.mp4` (22.53 seconds, 1920×1080, F6 C3 actor comparison) shows all five animation modes of Knight, Ranger and Mage. The sword+shield and Ranger bow remain readable; approved D404 walk and D405 attack cadence show no new defect in this recording. But at the Mage's end-of-DEATH pose, the staff tip still has a **bright, live-looking violet-white emissive core** after the Mage lies motionless on the floor. This is visible in the actual source D401 Mage DEATH row4 col5; earlier DEATH col4 has the body lying on the floor without the brightly lit crystal.

## Visual implementation

Do **not** rebuild the entire lossy D401 576×480 WebP: even a lossless re-encode changes thousands of alpha-clear RGB/source pixels per cel. D407 instead stores `res://assets/pixel/units/hero_c3_d407/mage_death_final.webp.b64` as ONE separately authored lossless RGBA **96×96** copy of **only** the original D401 Mage final death cel. Inside a 14×13px crystal area near x76–89/y77–89, the purple emissive highlights were substantially darkened, with the original staff shaft, crystal body, cloth and fully supine pose preserved; alpha silhouette unchanged. The result is a visible *dormant amethyst crystal*, not an active spell blast.

`MisdealUnitAnimationLibrary._create_frames()` selects this isolated image ONLY when `role == "mage" and is_c3_pilot`, overriding `SpriteFrames` DEATH frame index5. It leaves all other 29 Mage C3 source frames as the original D401 `AtlasTexture` references; Knight D406 and Ranger D401 unchanged. If the isolated image file is absent, malformed or wrong-sized, it falls back to unaltered original death cel. No change to `BattleUnit`, hp/damage/skill effects, D405 attack hold timings, D404 walking or other roles.

## Quality gate

`tests/unit/test_d407_mage_death_crystal.gd` checks exact 96px source, changed-pixel confinement, alpha continuity, strong glow attenuation and real `BattleUnit` use of the new source, plus the 29 untouched original Mage AtlasTextures and unchanged Knight/Ranger. `test_d398_c3_hero_animation_pilot.gd` is amended only to account for this lone 96px ImageTexture frame instead of blindly requiring all frames to be AtlasTextures.

Native Godot 4.7.2 CI import/GUT and scene smokes must pass before squash merge. Human F6 check: `git -c gc.auto=0 pull --ff-only origin main`, run `res://scenes/dev/d398_c3_hero_animation_preview.tscn` with F6, select DEATH; final Mage's staff crystal must now look inert while death motion and weapon silhouette remain readable. This is **one art fix**, not a claim that all 75 C3 images are finished or that F5 full combat has been tested by the user.
