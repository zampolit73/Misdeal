# Misdeal — D153 current handoff (2026-10-15)

Repository: `zampolit73/Misdeal`, branch `main`. Read `AGENTS.md`, `docs/CONCEPT.md`, `docs/PROJECT_STATE.md`, `docs/ROADMAP.md`, `docs/DECISIONS.md` first; GitHub is the live technical truth. The assistant uses the connected GitHub tools to make all changes; user uses local Godot 4.7.x and `git pull`.

## Confirmed by user
- D153 card scene: chosen third, original moonlit destroyed theatre with **skeletal undead** puppeteer and two skeletal marionettes; source card art 448×274 has rendered in Godot.
- Redrawn crimson-bone animation atlases `threadbare_puppeteer_frames.webp.b64` and `bone_marionette_frames.webp.b64` were user-accepted after five-state gallery F6 («все ок»); never revert to the old generic mini-skeletons.
- Approved D153 arena image: latest rendered `лунная_арена_среди_руин_театра.png`, a relatively understated dark backstage scene with ONE distant silhouette, moon through broken roof, asymmetrical ladders, old rigging and open floor. User explicitly said «утвердили — продолжай» and requested implementation.
- Earlier isolated `scenes/dev/threadbare_theatre_smoke.tscn` native screenshot **PASS**, 0 displayed errors: 32% marionette damage reduction within 285px, severed distance, master death, and cleanup. This does **not** certify production battle.

## Now committed to main (source-integrated, not native-tested yet)
- `assets/pixel/battle/arenas/threadbare_theatre_approved_v1.webp.b64`: approved picture downsampled to 1280×720 WebP; 94,090 bytes decoded; SHA-256 `6cb6db8138afca085add843833fbf579c00c99f81535a8a2f6266850e102ebe0`. Refetched GitHub encoded contents byte-for-byte matched source.
- `resources/encounters/threadbare_theatre.tres` now points to `arena_id = "threadbare_theatre"`. `scripts/battle/authored_backdrop.gd` + `battle_visual.gd` route this specific arena to its new art and unobtrusive atmosphere.
- `scripts/battle/battle.gd` wires `ThreadTetherController` **only for D153**. Instantiates after enemy spawn, starts after intro, stops/restores on combat conclusion; enemy leader must be `threadbare_puppeteer`, 2 allies `bone_marionette`. Existing mechanisms for other encounters are untouched.
- `scripts/core/run_state.gd` includes D153 in `CARD_PATHS` **only for dev QA to reach real reward flow**. `ACT1_CARD_IDS` still excludes it: live Act1 remains **35/45**.
- `scenes/dev/threadbare_theatre_battle_smoke.tscn` — NEW 54-case F6 deterministic matrix, actual combat units and tether controller.
- `scenes/dev/threadbare_theatre_playtest.tscn` — NEW real battle → reward → table isolated QA entry. It sets up a Knight and injects an explicit D153 dev offer; no live deck insertion.

## Immediate next native checks (user only)
1. `git pull`, F6 `res://scenes/dev/threadbare_theatre_battle_smoke.tscn`; send screenshot showing PASS/FAIL, 54/54, victory/defeat and linked/broken counters.
2. F6 `res://scenes/dev/threadbare_theatre_playtest.tscn`. Observe original theatre **arena and skeletons**, actual battle, links, fight end → Claim Reward → Table. Send screenshot or exact error; assistant must fix in GitHub.

**Do not call native QA PASS yet**; no Godot binary available in authoring runtime. Matrix PASS will prove technical completion only; balancing with solo/duo/trio damage/HP telemetry is a separate user acceptance gate. D153 is NOT randomly playable until verified/released as #36. Keep DS2/Fate Spread I–XII+sealed XIII, D143 original-enemy rule, D167/D168 scene-first art/approval rule and all previously accepted D151/D152 visuals locked.
