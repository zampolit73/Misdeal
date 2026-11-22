# Gameplay 2.0 Core — provisional run rules

**Scope:** phase 1 of the requested Gameplay 2.0 plan. Changes use existing Fate I–XII, fixed XIII boss, current heroes, current 4 original relics, 9 upgrades and the accepted Godot Table. Does not introduce new classes, new art or change auto-battle/AI.

## Health

- Each role carries `hero_health_by_role[role] = {current: float, max: float}` (saved on victory). A new/unsaved companion starts with full effective HP. Jack is not a party role and carries no HP.
- BattleUnit still constructs normally; the actual scaled max HP is computed with all ordinary upgrades, relics, scars and party-size modifiers, and persistent current HP is applied after scene insertion/ready.
- A winner alive at the end of combat records exact remaining HP. A party member who died while another hero won receives **20% max HP** in the *next* fight. This is not in-combat resurrection. The total-party loss does not alter persistent HP; a Last Deal retry starts with the original injuries.
- If max HP increases (through an upgrade or changed party multiplier), add only the increase to existing current HP, not a full refill. If max decreases, clamp HP to the new maximum. RunState clamps the persistence record to [1, max].
- Story effects that alter **max** HP remain distinct from actual HP, and existing scene events/Travel remain unchanged.

## Stops and economy

- After **Fate IV**: camp; **after Fate VIII**: second camp, then limited merchant. Neither adds to Fate I–XII or skips the required combats. The same checkpoint is only available once per run.
- Camp (free, one option only): **Rest** heals 40% of each present hero's effective maximum, capped at max; **Training** grants the next allowed *existing* extra hero upgrade to the least-developed available party role. If no extra-upgrade slots/items are available, Training is disabled.
- Merchant (no automatic gifts): one **40 gold relic** from the current available pool, one **35 gold existing extra upgrade** and one **20 gold 30% party heal**. Each slot can be purchased at most once; different slots may be purchased together. Artifact/upgrade availability obeys current real party and resource catalog; heal is unavailable at full HP. The offer chooses the first sorted available relic, and updates after a purchase; shop completion is recorded when leaving.
- The Table appears under a dark Gothic stop overlay, not a fake Fate card. No extra SceneRouter/Travel route; after closing, the existing offer selection resumes.

## Save compatibility

New variables: `hero_health_by_role: Dictionary`, `camp_last_completed: int`, `shop_last_completed: int`, `shop_purchases: Dictionary`. The current save snapshot and FIELD audit contain 71 properties. Historical schema-1 67-field saves (missing **exactly** these four fields) are accepted and migrated at apply time to empty health/purchase dictionaries and zero checkpoints. All other missing/unknown fields remain invalid. The original envelope checksum, .bak and New Game archive remain unchanged. Store purchases and finished stops using the established Table checkpoint; no events resolve twice on Continue.

## Check before promoting to production

1. Native Godot 4.7.x script/import smoke: no parser/type errors in the new UI or modified RunState/save code.
2. Full GUT incl. `test_gameplay20_core.gd` and historic `test_run_save.gd` save-property inventory.
3. F5 Knight/Ranger/Mage: injury across two battles, hero death during victory, camp IV, camp VIII, shop VIII, old Save Continue, Last Deal and XIII access.
4. QA economy: no accidental gold refund or duplicate purchase after save reload; two different purchases allowed.
5. Compare at least three real no-cheat attempts; distinguish actual run outcomes from fixed fixture/smoke results. The provisional 20%/30%/40% and prices need tuning after evidence; no claim of fixed difficulty or completed full run without F5.

## Release gate

Do not merge solely on static code inspection. CI Godot import and GUT are required for this gameplay change; keep the PR open on any failure or missing check.

## Player-facing health readout

The Squad Dossier's HP row now displays actual current/effective maximum (for example 85/220) without losing the original/base HP comparison. The existing Table Squad button gives a hover tooltip for each active hero. Both read directly from RunState and never alter HP.

## Release QA — standalone travel audio dependency

A full release run exposed a pre-existing standalone SceneTree travel capture dependency: the travel animation script referenced the `SoundDirector` autoload as an identifier and failed to compile when the singleton is not registered by a standalone QA script. The Travel presentation now uses a guarded runtime lookup; normal F5 with SoundDirector retains all cues, and standalone QA without it skips only audio cues. No Travel art, timing or route changes.
