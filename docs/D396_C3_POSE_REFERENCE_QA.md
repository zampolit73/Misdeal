# D396 — Actual authored-pose source versus D395 animation blocking

Date: 2026-11-05.

## Why

D395 generated 25 distinct RASTER outputs per role from one still. That was motion blocking, not original character animation. D396 investigates an immediately available, more credible source: the PRE-EXISTING `combat_units_anim_v2` atlases from older production. These contain genuine full-body individually illustrated stances/movement/attack/hit/fall poses, but do NOT meet newly approved C3 costume design by default.

## What was staged (QA ONLY)

- `scripts/dev/c3_authored_pose_study.gd` reads already-tracked 576x480, 6x5 legacy animated atlases for Knight, Ranger and male Mage, without writing a file or changing their original content. Knight receives a non-destructive desaturated burgundy **palette probe** converting blue cloth/shield pixels. This is not approved damaged-cloak art and does not alter the silhouette.
- `scenes/dev/d396_c3_pose_compare.tscn` and its script play D395 blocking (left) next to genuinely earlier-drawn pose animations (right), three role pairs on the real Firing Square art. Five state buttons allow review at once.
- Knight 4/6/6/3/6 = 25 old authored poses; Ranger 25 old authored poses. Mage has 24 valid actor poses, because one of the six old attack cells is a detached projectile; never pretend this is a sixth valid Mage body pose. The Mage preview uses attack columns [0, 1, 2, 3, 5].
- GUT checks original source decode, clip counts, Mage attack filtering, Knight color study and playback. Neither tests nor transformed colors constitute artistic approval.

## Current limitations and future art task

The archival Knight has a BLUE-original shield/cape before the color test, not the user's fully accepted battered C3 Knight. Changing hue does not produce a torn cape. The existing Ranger/Mage old designs may have different scale/silhouette/garment edges from the approved *intact* clothes. More importantly, this PR contains **NO NEW individually drawn art frames**. It is a quality-baseline comparison proving that previously authored motion is already in-repo and should beat D395 geometric deformations. On-screen art/hit timings, contact frames and bleeding/cropping require human F6 motion inspection and cleanup before considering asset production.

## Native F6

1. Pull `main` when PR is merged.
2. Open `res://scenes/dev/d396_c3_pose_compare.tscn` and press F6 at 1280x720.
3. Click IDLE, WALK, ATTACK, HIT, DEATH and observe whole animations. LEFT = D395 procedural warps; RIGHT = legacy original pose animation reference (Knight burgundy color trial only).
4. Check hands holding sword/bow/staff, feet contacting stone, natural leg extension, cape/robe continuity, fallback or projectile-only character flashes and true grounded death; note that both columns are experiments, not final C3 sprites.
5. Do not switch live characters until 25 actually C3-authored frames per role and native review; Mage sixth body attack still needs new original authored art.

No `BattleUnit`, runtime loader, card, enemy, waves, DS3, Fate Spread or XIII changes.
