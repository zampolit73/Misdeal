# Misdeal — D268 new chat handoff (current, 2026-10-19)

**Canonical code:** `zampolit73/Misdeal` `main`, Godot 4.7.x + GDScript. Verify current GitHub head first. Read `AGENTS.md`, `docs/CONCEPT.md`, `docs/PROJECT_STATE.md`, `docs/ROADMAP.md`, `docs/DECISIONS.md`, then [D268 QA record](D268_COURT_BATTLE_QA_STAGING.md) and [prior D267 approved-original import](D267_NEW_CHAT_HANDOFF.md).

## What has actually been committed

- Prior **D267**: all three exact approved rich Court original RGBA source PNGs and **75 full25 animation cells**, in strict animation library. Official 4.7.2 source-import CI previously PASS; **27 source-edge flags still have no true ×1 artistic sign-off** (Judge 5/Scribe 0/Bailiff 22).
- **D268**: registered D265 actor-free Court QA backdrop inside **actual Battle**, stopped the crypt fallback visual; D264 bottom combat floor unchanged. This background remains *schematic QA art*, **not final**.
- Added native F6 **real Court Battle** party-size/formation launcher: `res://scenes/dev/court_of_the_mute_d268_real_battle_preview.tscn`.
- Added `ПАУЗА`, frame stepping and 27-source-QC marker cycling to the already existing **three original character motion gallery**: `res://scenes/dev/court_of_the_mute_d267_rich_animation_preview.tscn`.
- Added `res://scenes/dev/court_of_the_mute_d268_balance_matrix.tscn` for **54 BattleUnit functional scenarios** + localized verdict metrics; `res://scenes/dev/court_of_the_mute_d268_qa_route_runner.tscn` for test-only direct setup of unreleased Court real Battle→Reward→Table; `.github/workflows/d268-court-battle-qa.yml` to run native CI.
- **IMPORTANT:** D268 GitHub Actions **status has not been observed/confirmed in the session that authored this file**. Source pushed ≠ parser PASS, 54/54 PASS, route PASS or artistic review. Inspect the workflow result, identify/fix any reported errors; never quote completed test metrics before execution.

## Exact next implementation work

1. **Verify actual D268 Godot 4.7.2 CI outcome**, fix GDScript/runtime/test contract issues via GitHub. The workflow covers source parse, D268 real Battle F6 launch, D267 rich gallery, D262 six Battle boots, 54 Court BattleUnit scenarios and a QA-only Battle→Reward→Table. No ordinary deal test possible before #39 activation.
2. One combined true **×1 & ×2 original rich animation** review (27 flags, especially Bailiff merged death3–5, shield/halberd grip and foot plants); correct only genuine art defects in a single batch, not 27 micro-approvals. Do not redraw the approved identities or replace them with D266 simplified prototypes.
3. Upgrade the **actor-free** Court battle plate to genuinely rich painterly dark fantasy aligned to accepted second D261 card art, preserve only walkable floor **screen x40–1268/y532–710**. User already approved this lower floor and exact card illustration; do not ask again.
4. Analyze 54-case combat stats for realistic solo/duo/trio challenge, validate genuine route through native Godot. Only after artwork, matrix and reward-route gates, **separate intentional release** card `court_of_the_mute` (#39 → 39/45). Until then `target_path = ""` and normal deck **38/45**.
5. After code/art work update active state/roadmap/handoff/decisions if needed, CHANGELOG and commit. Preserve D260 live #38, DS2, Fate Spread I–XII+XIII, and frozen KARAMBA73. GitHub is connected; do not ask for access or request manual file copying.

**Minimal local art check when needed:** `git pull` → Godot F6 `scenes/dev/court_of_the_mute_d267_rich_animation_preview.tscn` (pause/steps/27 markers) and `scenes/dev/court_of_the_mute_d268_real_battle_preview.tscn` (solo/duo/trio + 2 formations, Court floor / warning seal). Headless CI is not a rendered artistic verdict.
