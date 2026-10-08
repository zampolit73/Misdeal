# Visual Pass Checkpoint — 2026-10-08

This checkpoint exists so a fresh project chat can continue the current art pass without reconstructing the previous conversation.

## Current repo/runtime status

- Core Act 1 mechanics, fate/hold/mark systems, scars-as-keys, authored deployment geometry, combat side conditions, **ЖЕРТВА**, **НЕПОВИНОВЕНИЕ**, Last Deal and personalized Bone Warden Phase II are in `main`.
- The user reported the latest gameplay package working locally.
- The first production-art grade is already integrated:
  - Wizard table backdrop + table card art;
  - authored battle backdrops;
  - Whispering Well choice art;
  - nearest filtering/resampling on battle backdrops.
- `docs/ART_DIRECTION.md` is the visual contract.

## What the latest screenshots showed

The grade made the game more coherent, but several source illustrations still visibly look generated.

Strongest issues:
1. **Bone Crush / ossuary arena**: too many candles, bones and repeated gothic details; no calm visual hierarchy.
2. Some table cards still look like reduced generic fantasy landscapes.
3. Wager/card art can become too black under the current grade.
4. Blue deployment rectangles look like debug overlays.
5. The live UI is clean while the backgrounds are excessively ornate, so the two layers do not feel authored by one production artist.

Better reference:
- **Gallows Volley** currently reads better because the moon/sky, architecture and floor form large separate value masses.

## Approved next direction

The user asked to see the redraw before integration, then approved proceeding with the shown direction.

### Bone Crush benchmark

Create/integrate a cleaner crypt arena with:
- large simple architecture;
- clear rear statue/throne focal point;
- restrained rust-red banners;
- only a few motivated torches/braziers;
- large quiet combat floor;
- simple central ritual circle;
- bones/rubble pushed to the edges;
- two deployment lanes expressed as scratched/inlaid floor geometry.

Do **not** bake units, health bars, labels, encounter title, card counter, tactical buttons or other gameplay UI into the arena image.

Technical integration should use a dedicated `bone_crush` arena id/path. Do not replace `ossuary.webp` globally.

### Deployment visualization

Replace `DeploymentZoneA/B`'s translucent blue debug-style panels with world-looking markings while keeping the existing multi-rectangle placement logic in `BattleUnit` / `battle.gd`.

### Grade tuning

Keep the shared grade, but restore more dark-mid readability for table wager/card art. Do not solve source-art problems by increasing posterization or crushing blacks.

### Card redraw queue

First candidates after the arena benchmark:
- **ГРЕМУЧИЙ МОСТ** — object-first bridge silhouette, abyss, moon/cold sky.
- **КОШЕЛЬ МЕРТВЕЦА** — large purse + skeletal hand/bones + a few coins.

## Do not do

- Do not regenerate the entire asset library at once.
- Do not replace good combat sprites with procedural symbols/circles.
- Do not bake live numbers/text into art.
- Do not add more random runes/filigree.
- Do not change gameplay while evaluating the art pass.
- Do not claim the Bone Crush redraw is already in runtime until it is actually committed and locally tested.

## Fresh-chat first action

Read `AGENTS.md`, `docs/CONCEPT.md`, `docs/PROJECT_STATE.md`, `docs/ROADMAP.md`, `docs/DECISIONS.md`, `docs/ART_DIRECTION.md` and this file. Then fetch current `main` before making changes.


## First live object-first card batch

Runtime now overrides the old atlas art for:
- **ГРЕМУЧИЙ МОСТ**;
- **КОШЕЛЬ МЕРТВЕЦА**;
- **ШЕПЧУЩИЙ КОЛОДЕЦ**.

The dedicated card sources are 224×137 WebP images reconstructed from repository text assets. Continue replacing the remaining card/event art in reviewed batches rather than regenerating everything blindly.


## Quality correction after broad redraw attempt

The first broad v3 rollout was locally rejected. Do not restore its 112×69 card atlas or 320×180 arena atlas.

Current corrected direction:

- table-card redraw sources are 224×137 per cell, matching the established near-display card-art pipeline;
- 19 generated redraws are mapped by actual subject, not by generation order;
- **КОСТИ ДОЛЖНИКА** now has a matching debtor/contract/coins redraw rather than the old Bone Patrol imagery;
- Ash Rest, Bone Crush, Broken Crown, Candle Seller, Bone Tax and Death Wager remain on their unique approved 224×137 fallback cells until matching redraws exist;
- Crypt and Gallows Volley use dedicated native 1280×720 v4 redraws; Graveyard/Ossuary/Warden keep validated HD sources and Bone Crush keeps its dedicated benchmark arena;
- never upscale a 320×180 arena to the 1280×720 gameplay viewport as the production background.


## Battle arena v6 review correction

After local screenshots exposed crushed shadows and a mismatched Bone Crush floor plane, the runtime arena pass was corrected:

- Graveyard uses the latest moonlit bell-mausoleum redraw.
- Ossuary uses the latest bone-gate crypt redraw.
- Warden uses the latest red throne / ritual-circle redraw.
- Bone Crush uses the latest broad-floor dark crypt redraw.
- The latest Bone Warden character redraw overrides the older boss-card atlas cell.
- Authored arena art is no longer post-darkened by the legacy environment-grade material.
- Bone Crush deployment/combat coordinates are constrained to the visible floor.

These are native 1280×720 runtime WebPs (boss card: 448×274), not thumbnail-scale atlas enlargements.


## Table/wager brightness correction

The remaining dark screenshots were traced to the table layer:

- WizardBackdrop was still receiving the old strong environment grade;
- all live table-card art and both Wizard-wager term images were also being graded;
- the wager scrim still used 0.82 black alpha.

The authored table/wager art now bypasses those materials, the scrim is 0.52, and passive table shading is halved. A previously prepared v6 Wizard/table illustration is now in runtime as a clean 1280×398 WebP crop with no baked mutable UI.

Shared grade strengths are reduced for any older surfaces that still reference them: environment 0.30, card 0.14.
