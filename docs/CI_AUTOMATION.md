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


## CI3 — Real rendered scene previews (opt-in)

`.github/workflows/godot-render-previews.yml` renders **actual** Godot 4.7.2 frames with Ubuntu + Xvfb + Mesa software OpenGL and the real Misdeal game/QA scene scripts. A native `SceneTree` helper `scripts/dev/ci3_capture_rendered_scene.gd` waits for `RenderingServer.frame_post_draw` before reading the root `Viewport` and writing 1280×720 PNG files.

Scenes included:
- `01-class-select.png`: production class choice, Knight selected
- `02-table.png`: production cursed table with real game state and cards
- `03-wizard-prep.png`: original D308 Wizard optional objective preview in preparation phase, with D311 painted plaque
- `04-card-gallery.png`: production D315 Card DS3 gallery (first visible row)

The run checks each source PNG for dimensions, nonblank buffer and unique contents, archives individual diagnostic logs + PNGs in `misdeal-ci3-real-rendered-scenes` for **14 days**, and prints their file paths in GitHub Actions. Screenshot inspection is a visual review aid, not a license to overwrite user-approved artwork or proof of perceptual perfection.

**How to use:** GitHub → Actions → **CI3 real Godot scene screenshots** → **Run workflow** on `main` (after this workflow has been merged); open completed run → Artifacts → `misdeal-ci3-real-rendered-scenes` to view PNGs. The workflow also runs on PRs that modify its own capture script/workflow; it does not consume compute on every card-art commit. ChatGPT can inspect run status/logs **and download the screenshot artifact ZIP directly via the connected GitHub app**, then inspect its real PNG contents in-chat; this was demonstrated on CI3's first native run (artifact 12493421005). You need not take and send manual screenshots for these covered scenes. Arbitrary local Godot scenes still require a suitable capture scene/runner or a user-provided screenshot.

Keep these shots clearly labeled **Linux software OpenGL**; text rasterization, font differences and contrast may differ slightly from the user's Windows GPU/editor. When objective text positioning or sprite motion matters, corroborate with local Godot F6.

## CI4 — Genuine production Battle screenshots and motion evidence

`.github/workflows/godot-battle-frames.yml` runs only on changes to its own script/workflow in a PR, or manually from **Actions → CI4 native Battle motion frames → Run workflow** on `main`. It downloads verified official Godot 4.7.2 and uses Xvfb + Mesa to **actually render** the original shipped `graveyard_ambush` encounter using `scenes/battle/battle.tscn`: a Knight versus two skeletons and one bone archer. No reauthored UI/sprites, no gameplay mutation.

`scripts/dev/ci4_capture_real_battle.gd` checks original `BattleUnit.sprite_frames`, the authentic Fight-button signal, then captures seven complete 1280×720 framebuffers after `RenderingServer.frame_post_draw`:

- `00-preparation.png`: live preparation/tactics, before fight
- `01-intro.png`: production battle intro
- `02-live-0000ms.png`, `03-live-0300ms.png`, `04-live-0650ms.png`, `05-live-1050ms.png`, `06-live-1600ms.png`: timed live autobattle frames

Each run validates count, PNG signature/resolution/nonblank images and frame distinction, checks the actual unit displacement (must exceed 2px), logs the original `battle-frame-metadata.csv` and records images in `misdeal-ci4-real-battle-motion` for **14 days**. It also uses ffmpeg (installs if absent) to create `battle-review-flipbook.mp4` at **3 fps** from *these exact seven frames*. The flipbook is a review aid for spatial changes and is **not** continuous gameplay footage or evidence that all individual 25-frame animations are smooth.

The GitHub connector lets ChatGPT retrieve artifact ZIPs and inspect original PNG frames directly. The first [native 7-frame CI4 run](https://github.com/zampolit73/Misdeal/actions/runs/39937515858) passed and reported ~183.6px original BattleUnit movement; the images were retrieved and visually inspected. [Original seven native functional smoke tests](https://github.com/zampolit73/Misdeal/actions/runs/39937515794) also passed. Visual opinions are still separate from CI PASS, and Linux Mesa/OpenGL screenshots can differ from Windows hardware. 

## Next safe enhancement

Add opt-in coverage for representative arena/party combinations (including Court and Black Lantern) and sampled animation states/frames, validating authored actor bounds and soles. Do not switch approved gameplay sprites or reinterpret a slideshow as accepted 25-frame motion.


Add an **opt-in visual preview** workflow on Linux with a virtual display (or a Godot scripted Viewport render), producing labeled PNG artifacts from **specified stable dev scenes**. Do not use headless logs as evidence that sprites look correct. Validate any preview against a real Godot session before calling it an approved visual checkpoint.
