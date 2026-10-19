# D268 — Court real-battle QA staging, unreleased card #39

**2026-10-19.** GitHub `main`, Godot 4.7.x/GDScript. **Historical staging note superseded:** [D268 complete native Godot 4.7.2 QA + 54-case balance + route PASS](D268_NATIVE_COURT_BALANCE_AND_ROUTE_PASS.md), [successful Actions run #9](https://github.com/zampolit73/Misdeal/actions/runs/39249979969). This original file records the prior QA staging, not final artwork approval.

## What changed

- `scripts/battle/authored_backdrop.gd`: encounter-only `court_of_the_mute` backdrop now selects the already tracked **D265 actor-free QA-only 1280×720 tribunal** rather than silently falling back to Crypt. The existing selected D261 card portrait remains unchanged.
- `scripts/battle/battle_visual.gd`: accepts the Court ID and suppresses legacy Crypt glow above the new backdrop. This does not affect the 38 released encounters.
- Real **Battle** F6 QA scene `res://scenes/dev/court_of_the_mute_d268_real_battle_preview.tscn` has solo, duo, trio party picker and two original Court deployments. Units and their D267 rich original SpriteFrames come from the canonical library, not per-scene replacement. D262 warning/focus mechanic and D264 lower-floor movement are the production code.
- Existing combined three-character `res://scenes/dev/court_of_the_mute_d267_rich_animation_preview.tscn` now has **pause, frame ←/→ and '27 МЕТОК'** navigation. Flags are the exact original QC set: Magistrate walk2–3/attack0–1,3; Scribe none; Bailiff all idle/walk/attack/hit frames plus death3–5 merged alpha. These are *review candidates*, not confirmed visible art defects; visual ×1 review is still open.
- `res://scenes/dev/court_of_the_mute_d268_balance_matrix.tscn`: authored **54 deterministic functional BattleUnit** scenarios (two formations × three protagonists × three party sizes × three tactics). Uses the real original unit resources, original animation loader, actual Court floor, ordinary party/enemy scaling and encounter-scoped `CourtVerdictController`, with warning/redirect/interruption counters, HP, deaths and durations. Note this is a functional BattleUnit simulation, **not 54 instances of the Battle UI**. D262 independently covers six real Battle configurations.
- `res://scenes/dev/court_of_the_mute_d268_qa_route_runner.tscn`: independent **headless QA** that directly configures the *unreleased* Court card, opens the actual Battle, triggers Fight and Continue, and exercises Reward→Table. Because `target_path` intentionally remains empty and Court is NOT in ACT1 draws, this is **not** a real ordinary dealt-card test. No normal navigation code is modified; the test-only observer emits a frame-post-draw signal in headless mode, as established in D260.
- `.github/workflows/d268-court-battle-qa.yml`: Godot 4.7.2 parser + F6 smoke, D267 gallery, D262 six real boot cases, new 54 matrix, and dedicated Court reward route. **Result now VERIFIED: SUCCESS**, including complete 54-case original BattleUnit matrix and direct QA-only Battle→Reward→Table. See [verified report](D268_NATIVE_COURT_BALANCE_AND_ROUTE_PASS.md).

## Outstanding release gates

1. True visual inspection at ×1/×2 of all D267 rich original animations; inspect the 27 source edge flags, especially Bailiff death3–5 and held halberd/shield. Fix demonstrated defects as one batch without per-frame approvals.
2. Replace the still schematic **actor-free** D265 QA tribunal with artwork at the accepted rich D261 aesthetic, keeping the exact user-chosen **D264 lower floor** screen x40–1268, y532–710. No painted actors on background.
3. **COMPLETED for current provisional art:** official Godot 4.7.2 CI SUCCESS, 54 functional BattleUnit fights and direct QA-only real Fight→Reward→Table PASS, local Court enemy stats tuned. Re-run same checks against finished art before release. A headless green result is still not x1 visual approval.
4. Explicitly release card #39 **only after all gates pass**: add encounter target and live Act1 ID in a distinct release commit, update 39/45 contracts. Until then: `resources/cards/court_of_the_mute.tres` still has `target_path = ""`, live Act1 **38/45**, D260 card #38 and frozen KARAMBA73 unchanged.

### User-local optional check

`git pull` → F6 `res://scenes/dev/court_of_the_mute_d268_real_battle_preview.tscn` → choose three heroes and either formation → Fight. Verify only **bottom stone floor**, the right three distinct undead roles (four actors), and red warning seal before Bailiffs focus. For motion frame QA instead F6 `res://scenes/dev/court_of_the_mute_d267_rich_animation_preview.tscn`, use **ПАУЗА**, **КАДР ◀/▶**, **27 МЕТОК ▶**. A green automation check does not replace this ×1 user visual evaluation.
