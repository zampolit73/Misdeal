## D412 — approved full pack integrated in production Battle (2026-11-09)

Verified [Godot4.7.2 CI SUCCESS](https://github.com/zampolit73/Misdeal/actions/runs/42526508093) for integration commit `41aedac7`: 208/208 real GUT, actual Battle→Reward→Table route, relevant scene smokes and GPU screenshot capture passed. Full authored RELEASE matrix skipped. PR81 is ready for review; main unmerged.

Player approved quality, scale and all three animations («отлично», then «продолжай»). Production now loads the exact `hero_c3_d412_polish` 75 poses, with a single rollback flag and validated archived C3 fallback. Old D407–D409 single-frame patches do not overwrite new artwork. D404 travelled-distance gait and D405 attack timing remain. Correct source sole Y90, exact accepted preview scaling (Ranger1.40, Knight/Mage1.47), immediate first-target facing. Local Godot4.7.2 **208/208 GUT**, 45 scripts, 47,059 assertions. Actual Court trio win→Reward→Table route PASS; native GPU real Battle captured. No human F5 navigation PASS claimed. See [D412 QA](D412_THREE_HERO_PACK_QA.md). PR81 pending CI/review; no merge to main.

## Integration verification

All 75 live BattleUnit frame images are tested pixel-identical to the approved polished atlas; independent archive lookups cannot corrupt the live frame cache. Source-specific D398/D402/D406–D409 tests explicitly verify the old fallback resources rather than demanding them in new live art. Actual live motion/grounding/attack/HIT/DEATH regressions remain on the new pack. Every approved character has six attack/death and six walk frames, original frame rates and D405 weighted holds. The first left-target attack faces its opponent in the same frame.

Native existing D273 Court ordinary-deal runner: actual trio combat victory→Continue→Reward choice→Table PASS, run at4x simulation speed; not a manual F5 playthrough. Existing runner reports shutdown ObjectDB/resource-use diagnostics after PASS; Windows also reports certificate-store error. Route is added to battle-relevant PR CI.

[Native first acquisition](qa/d412/live_first_acquisition.png) · [Native actual combat](qa/d412/live_combat.png). Automated captures use production battle.tscn, exact live sprites, real AI and GPU1280x720. Frame acquisition is frozen for diagnosis; continuous combat resumes for capture sequence.

Rollback flag: `MisdealUnitAnimationLibrary.D412_APPROVED_ENABLED`; archived loader also remains available as `get_frames(role,false)`. Invalid/missing approved files fall back through existing C3/v2. No combat resources, cards, waves, AI or damage altered.

## D412 follow-up — motion accepted, detail and size polish (2026-11-09)

Player explicitly accepts all three animations. Preserve poses, order and timing; no new animation approval gate. Increase displayed size ~9–10% (live common hero scale1.40; role ratios unchanged; new-pack preview Ranger1.40/Knight1.47/Mage1.47). Recover source material detail with premultiplied Lanczos colour sampling while retaining exact accepted nearest-sampled alpha for every pose. New version in `assets/pixel/units/hero_c3_d412_polish/`; baseline source/packed files retained. This is resampling/detail polish, not newly painted models. Full new pack remains QA-only, production uses prior atlases.

The refined alpha plane is verified pixel-identical against the accepted baseline atlas in a new GUT regression. No source artwork changes or pose regeneration. Native GPU screenshots rerun for all five states.

# D412 — three complete hero animation candidates

Player request: Ranger quality reference; Mage same body height as Ranger, Knight slightly taller; complete animations for all three without repeated per-state approvals.

## Delivered and limits

Three **new image-generated** sheets, 25 distinct source poses each (idle4/walk6/attack6/hit3/death6), plus 5 empty cells each. Sources, native packed PNG and lossless WebP/Base64 stored in `assets/pixel/units/hero_c3_d412/`. These are generated pose artwork, **not 75 independently hand-pixel-painted cels**. First Mage generation contained a sword and was rejected. Final Mage uses only staff. The old runtime art is preserved; new pack is staged QA-only until full motion/prop/fidelity review. Do not call this production registration or final artistic acceptance.

Built-in imagegen used with gameplay screenshot as reference. Prompt set: six equal columns/five rows, transparent RGBA, upright right-facing front-three-quarter human, exact 4/6/6/3/6 distinct motion sequence, retained weapons, safe margins, no UI/background; Knight worn steel/sword/burgundy shield/torn cape; Ranger intact olive hood/bow/quiver; male Mage intact violet robe/silver beard/staff, no sword/shield, dormant final crystal. Generated source files preserved unchanged. Repacking does nearest filtering, low-alpha haze removal and largest connected character component; this can lose detached projectile/spark pixels and requires visual QA of thin props. It does not invent or repeat poses. Lossless format preserves packed pixel data.

`scripts/dev/d412_pack_hero_sources.gd` reproduces the packed outputs. Every source pose is packed to 96px, standing baseline90, 2px minimum padding. A single source-to-runtime scale per character is calculated across ALL 25 poses, so wide/deep poses do not shrink independently during playback. Source anatomy and motion quality still require visual judgment.

## Runtime size and tests

Live role factors: Ranger1.00, Mage1.00, Knight1.05. Stats, collision, AI, accepted D404 distance sampling and D405 attack holds unchanged. Original D410/D411 stature test updated to the player's new size contract, preserving mechanics/grounding assertions.

Local Godot4.7.2: **205/205 GUT**, 45 collected scripts, 46,939 assertions. New test decodes all three final atlases: 75 unique nonempty poses, 15 empty cells, padded bounds. Native GPU1280x720 F6 captures performed for all five states; no GDScript errors. Windows certificate-store diagnostic persists. Artistic judgment is separate from these structural tests.

## Review

F6 `res://scenes/dev/d412_three_hero_animation_preview.tscn`: right=new pack, left=archive v2; AUTO cycles five states; arrow button mirrors both directions. Inspect exact native scale, stance, genuine stride, grips, intact Mage/Ranger clothes, final corpses and scale changes. [Native walk capture](qa/d412/native_walk.png).

Remaining: refine any pose/fidelity problems found in complete-pack motion review, then register complete accepted pack in production with real BattleUnit motion and Battle→Reward→Table checks. Existing live sprites were deliberately not silently replaced with technically passing but unapproved generated pose sheets.

Follow-up verification: local Godot 4.7.2 GUT 206/206, 45 scripts, 46,945 assertions; all three refined alpha planes identical to accepted baselines. Native five-state GPU render succeeded. Existing certificate-store diagnostic persists.
