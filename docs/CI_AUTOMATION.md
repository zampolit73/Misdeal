# Misdeal — Cloud Godot QA (CI1)

## Goal

Keep development in the ChatGPT project + the connected GitHub repository. Let GitHub Actions run **real Godot 4.7.2 headless checks on each pull request**, before code is merged to `main`. This complements (not replaces) a local visual F6/gameplay review.

## Existing checks

Stage-specific workflows under `.github/workflows/d*.yml` run on relevant `main` pushes and often support `workflow_dispatch`. Do not remove or silently replace them; in particular `d315-card-ds3.yml` verifies approved card assets and surfaces.

## Unified pull-request gate

`.github/workflows/godot-pr-smoke.yml` is an additional, read-only, no-secret workflow:

1. GitHub Actions checks out the PR and downloads official Godot **4.7.2 Linux**, verifying the existing pinned SHA-256.
2. Headless editor import checks the full project for resource and GDScript parse errors.
3. Native script smokes verify **class selection (D279), DS3 Table (D289), DS3 Battle (D291), Wizard side objective (D306), Wizard F6 preview (D308), card/catalogue (D315), and card surfaces (D316)**. Each test requires a specific PASS sentinel and fails on nonzero exit/parse/FAIL markers.
4. Every run writes a concise **GitHub Job Summary** and uploads `misdeal-pr-godot-logs` logs (14-day retention), including on failure. These are accessible to the connected GitHub integration for diagnosis.

How to use: open a pull request for code changes and wait for the **Misdeal Godot PR smoke** status. If it fails, share the PR or run link in chat; the connected GitHub tools can read the job logs. Fix errors on the PR branch before merging. Workflow may also be run manually from the GitHub Actions tab once merged to `main`.

Notes:
- Headless native PASS is **not visual approval**. Lighting, text positioning, animation, and art still require actual Godot 1280×720 captures or user F6 review.
- No third-party Godot add-on, Codex installation, new backend, local webhook or Windows self-hosted runner is required.
- Keep `main` merge approvals and branch restrictions as a separate administrative decision. The workflow is a gate for review, but does not itself enable repository branch protection.
- Godot Actions runners are disposable; they **cannot control the user's local Godot Editor**. Never claim otherwise.
- This PR workflow deliberately runs for every PR; narrow it only if the compute cost becomes an issue.

## Proven results (2026-10-23)

- Unified [PR #3 Godot native run](https://github.com/zampolit73/Misdeal/actions/runs/39933674652): **7/7 PASS**.
- Independent [D291 specialized main-branch native run](https://github.com/zampolit73/Misdeal/actions/runs/39933807515): **PASS**, including D306/D308.
- D306 logs exposed a real UI layout issue: Godot's Label intrinsic minimum heights were greater than authored sizes, so the painted Wizard plaque's reward crossed the D313 limit. See `scripts/battle/battle_ds3_pass.gd` y38/y73 and the D306/D308 `Rect2` checks. The user's Godot F6 visual judgment is still needed for subjective typography.

## Next safe enhancement

Add an **opt-in visual preview** workflow on Linux with a virtual display (or a Godot scripted Viewport render), producing labeled PNG artifacts from **specified stable dev scenes**. Do not use headless logs as evidence that sprites look correct. Validate any preview against a real Godot session before calling it an approved visual checkpoint.
