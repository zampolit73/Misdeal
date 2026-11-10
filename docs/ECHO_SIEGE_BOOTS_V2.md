# Echo of the Siege — «Чужие сапоги» updated final art (2026-11-10)

> **DEPLOYED UPDATE (2026-11-10).** The user pushed the exact approved boots v2 binary patch to `main`: [commit 3ce01ac1](https://github.com/zampolit73/Misdeal/commit/3ce01ac1). Connected GitHub inspection confirms only PNG source, boots card/backdrop WebPs and `manifest.json` changed. Source SHA256 in the live manifest = `2ec39769890b2229255b62d46e7585186cf23b31b1c63a1da0c064c39f66d519`; card = `50905e5c52a61a3d2c6328715dbf5fb9fcce3927a67f5c84cf6df92a7e3c2944`, backdrop = `beaff13743e4a2f58cf45a56121c1823ff171fd8ddca57fd5ea390a9e3bc1e4e`. All four other event paintings retained. The "not yet committed" instructions and status below are historical preparation notes. Godot native QA for this exact commit **has not yet been run/confirmed**.


## Locked approval — latest user-supplied source

The user replaced the previous approved `borrowed_boots` (skeletal quartermaster examining footwear at a workbench) with **the exact image attached in the latest conversation**: a curly-haired *young half-undead squire* sitting on a broken bench in a ruined castle military encampment, pulling on an oversized pair of muddy armored leather boots. Left arm is partly skeletal, right hand is human; a lantern hangs at upper left, discarded helmet/shield in the near left foreground, kettle over a fire and ruined fortress in the right distance. Burgundy flags bear the canonical aged-gold ring-and-cross sigil. **Do not redraw, change the character, crop, add UI, or replace the heraldry.** This approval supersedes ONLY the earlier `borrowed_boots` image; all other four Echo of the Siege paintings and five event mechanics are unchanged.

- Source image: user-provided `image.png`, 1280×853, opaque RGBA PNG.
- SHA256: `2ec39769890b2229255b62d46e7585186cf23b31b1c63a1da0c064c39f66d519`.
- Persistent approved source: user's ChatGPT Library `/Misdeal/approved_art/borrowed_boots_echo_siege_squire_v2_2026-11-10.png` (library `libfile_30f77db2fa34819188d2799034c14701`).
- Exact standalone patch ZIP: `misdeal_borrowed_boots_replacement.zip`, also in Library at `/Misdeal/approved_art/borrowed_boots_replacement_v2_final_2026-11-10.zip`. It contains the source, two generated images, a checksum manifest and a self-contained safe `install.ps1`.
- Game card: 448×274 WebP (lossless), SHA256 `50905e5c52a61a3d2c6328715dbf5fb9fcce3927a67f5c84cf6df92a7e3c2944`.
- Event backdrop: 1280×720 WebP (lossless), SHA256 `beaff13743e4a2f58cf45a56121c1823ff171fd8ddca57fd5ea390a9e3bc1e4e`.
- Image geometry: source fully contained without crop, Lanczos resize centered on `#100e0e` dark fill, same aspect/fit contract as `scripts/dev/pack_final_five_assets.gd`.
- Remote target paths only: `assets/pixel/events/final_five/sources/echo_siege_approved/borrowed_boots/approved_source.png`, `assets/pixel/events/final_five/borrowed_boots/card.webp`, `assets/pixel/events/final_five/borrowed_boots/backdrop.webp`, plus the existing `assets/pixel/events/final_five/manifest.json` (new source hash and two output hashes). No changes to `banner_seamstress`, `unsent_letters`, `false_weights`, or `last_signal`.

## Deployment status

**New boots v2 binary assets are NOT YET committed to GitHub** as of this documentation change. GitHub `main` already has the **previous full set of five** Echo of the Siege approved assets from the prior user push; its `manifest.json` presently still records the superseded boots source SHA256 `7cf1d2d0fa0cd813bdc0017b49d920f0fbd5692b0013f6d90cc716cb0120e88b`. Don't report the new picture as deployed until the source and two WebPs are pushed. The connected GitHub text mutation tools cannot directly upload this binary attachment.

A safe updater is included **inside the ZIP**. It verifies the exact image hashes, fetches `origin/main`, makes a fresh temporary detached worktree, refuses any unrecognized boots state, updates only the 3 boots assets + manifest, commits and pushes `HEAD:main`, and removes the temporary worktree after success. It deliberately leaves the user's dirty `codex/living-arenas-pilot` checkout and Godot `.import` files untouched. In Windows PowerShell after downloading ZIP to Downloads:

```powershell
Expand-Archive "$env:USERPROFILE\Downloads\misdeal_borrowed_boots_replacement.zip" "$env:TEMP\misdeal-boots-v2" -Force
powershell -ExecutionPolicy Bypass -File "$env:TEMP\misdeal-boots-v2\install.ps1" -Repo "C:\Users\irlix\GodotProjects\Misdeal"
```

The script's expected success message names `Borrowed Boots` and reports no other images touched. When GitHub main has the new source hash, inspect `scenes/dev/final_five_playtest.tscn` via F6 in an updated, clean main worktree. **Native Godot verification and full CI are still pending.**

## Context for future chats

The prior approved art decision for `borrowed_boots` in `docs/DECISIONS.md` and the previous SHA256 in the original five-card rollout table are **historical and superseded**, not an alternative current approval. Do not re-introduce the quartermaster painting or repack from the old 2/3/2/3/3 option manifest. Keep the new user-supplied 1280×853 PNG immutable.
