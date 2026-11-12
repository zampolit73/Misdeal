## 2026-11-12 — Borrowed Boots Scene04 art APPROVED; Codex implementation pending

User explicitly approved **the exact new authored painting** of the young half-undead squire in a deserted sentry camp beside a dying fire, oversized boots, aged burgundy-and-gold heraldry and broken gate with a road leading **right/up into depth**. This scene belongs ONLY to `borrowed_boots` («ЧУЖИЕ САПОГИ»), not to `last_signal` or any reused generic location. Its supplied binary is named `scene04_borrowed_boots_approved_reference.png`, **1672×941 RGB**, SHA256 **`ea21184b5a2792ce5ac3d4226f95656a5b812caab6bd345d19ef6d138d94a53a`**. The attachment is in the user's Codex package, **NOT YET IN GITHUB**; when implementing, the Codex agent must receive the PNG, commit immutable source and derive only separate production layers.

Next: implement **Scene04 «КОСТЁР БЕЗ ХОЗЯИНА»** using existing V2 catalog, resource, router and original event outcomes `repair` / `hobnails` / `passed`, with subtle specific residual footwear/strap states and unchanged narration in `scripts/travel/travel_catalog.gd`. No duplicated reward/state edits. Party leaves the camera along the **right** road toward the gate with correct perspective/rear pose; do not repeat horizontal overlay of early Posthouse or left-up Scene03 route. Protect approved original, squire identity, and all existing scenes. Connected station/gate props must share parallax plane where attached, to avoid tearing. After Codex implementation inspect native F6 video before marking **runtime art** approved; current approval is for **source painting only**.

## Scene03 — layer-integrity correction

Station/arches/linen/opening pixels now form one full-height plate at the same4px/s; five runtime planes remain. Separate opening/stone fragments caused the moving seam and are no longer rendered. Former cutouts kept for rollback. Original source, unit route and reactions unchanged; native F6 checked, focused Scene03 GUT pass. Continue user artistic review via the same F6 scene.

## Scene03 correction — rear perspective route (PR #108)

User correction supersedes both older horizontal calibrations below. The party now leaves the camera up-left along the marked road, with shrinking three-quarter rear poses/intervals, road-aligned contacts and subtle colour haze. Original D412 combat art and all backgrounds/reactions stay unchanged. Review F6 `scenes/dev/dressing_station_playtest.tscn` (trio/solo); native pass and existing travel GUT20/20,801 assertions. New strips/provenance: `assets/pixel/travel/last_dressing_station/rear_walk/`. Final CI is authoritative; don't claim user artistic approval.

## 2026-11-11 — Scene03 implemented; native artistic review next

The supplied `MISDEAL_TRAVEL_SCENE03_CODEX_PACKAGE.zip` supersedes the older art-not-approved note below: exact dressing-station reference SHA256 `3c7b2626...47a34d` is now preserved and integrated. `banner_seamstress` → Scene03, `unsent_letters` → Posthouse, other routes unchanged. See [Scene03 contract](TRAVEL_LAST_DRESSING_STATION.md), [five native frames](qa/dressing_station/README.md) and F6 `scenes/dev/dressing_station_playtest.tscn` (Q/W/E outcomes;1/2/3 party;P/R;normal skip). Full local GUT288/288 and native production Event → Travel → Table pass; final required PR CI remains authoritative. Existing production-fixture shutdown diagnostics remain documented. **Do not claim final artistic acceptance**; next review is actual scale, cloth reactions and road composition. Do not redraw source characters, reuse this location for unrelated cards or change the event effects.

# Misdeal — current handoff

## 2026-11-12 — Travel Scene03 ACCEPTED, PR #108 merged; next art: Borrowed Boots

User explicitly **approved** the in-game final Scene03 staging after viewing F6 video: perspective three-quarter REAR walking group travels away from camera toward battlefield, original seamstress/captain remain focus; unified station/arches/cloth no longer visibly tear during pan. [PR #108](https://github.com/zampolit73/Misdeal/pull/108) merged to `main` at `5731faa1b913ae29dc1cd3da164021f5850d4dca`; required `godot-pr-smoke` on final PR head passed. Approved source image is immutable, exact original recorded in `docs/TRAVEL_LAST_DRESSING_STATION.md`. The **optional** earlier critique of path endpoint was superseded by user's explicit approval: **do not iterate Scene03 further** without a new request.

**Next candidate card:** `borrowed_boots` / «ЧУЖИЕ САПОГИ». Check the existing, specifically **approved** young half-undead squire art (not the superseded keeper), `docs/ECHO_SIEGE_BOOTS_V2.md`, `resources/cards/borrowed_boots.tres`, and `scripts/event/final_five_events.gd`. Existing outcomes: `repair` (light pair, 18 gold, +8% move speed), `hobnails` (heavy pair, +8 HP, −4% movement), `passed` (leave boots for absent master). Stage a new visually distinctive journey tied to an extinguished campfire/abandoned sentry yard, NOT a reuse of posthouse, dressing station or rejected generic village. **No new Scene04 art is yet approved.** Show the image for user artistic review before writing a Codex implementation request. Future travel scenes remain card-linked and choice-specific; game effects and saves untouched.


## 2026-11-11 — Posthouse scale APPROVED; next card travel art selection

User explicitly approved the **enlarged Posthouse party scale** from the latest local F6 video. [PR #107](https://github.com/zampolit73/Misdeal/pull/107) is now **merged to main** (`fd1660b642a04d7ccbd6e95ef87f1ce11ee450b6`): scene-only `party_scale 1.55`, `party_spacing 185`, `party_origin.x 890`. Leave the original posthouse painting, skeletal pigeon, choices, and the first travel road untouched. The accepted figure-scale calibration is **specific to Posthouse**; check human proportions independently against near architecture in every new scene.

**Next candidate card:** `banner_seamstress` / «ЗНАМЯ НА БИНТЫ». The existing event is an undead seamstress who keeps bandaging a skeletal captain while awaiting false-promised reinforcements. Its choices are `bandages`, `standard`, and `passed`, whose effects are already implemented. New authored travel artwork must represent the aftermath of this event, e.g. a deserted field hospital / medical outpost alongside a traversable road. Keep approved in-game heraldry, no embedded protagonists or UI, and preserve scene-specific choice reactions (strips of cloth / saved standard / uninterrupted ritual). **No new artwork has been approved yet**; show 2–3 genuinely distinct rendered compositions and wait for user selection before integration. Do not repurpose the previously rejected generic village, do not replace the Posthouse art.

## 2026-11-11 — VERIFIED NEXT CHAT START: Posthouse Scene02 merged, art review pending

**Read [the current Travel/Posthouse handoff](SESSION_HANDOFF_2026_11_11_TRAVEL_POSTHOUSE.md) first.** PR [#106](https://github.com/zampolit73/Misdeal/pull/106) is already **merged**; [RELEASE CI](https://github.com/zampolit73/Misdeal/actions/runs/43002837989) **PASS (285/285 GUT, 72,176 assertions)**. Exact user-approved `last_dawn_posthouse/approved_reference.png` is already tracked by GitHub; **no new attachment or implementation is needed**. The source has an ordinary perched bird, but the scene uses one separate **skeletal** pigeon. `unsent_letters` has three existing outcome-specific travel reactions; the user's artistic evaluation of the implemented scene **is not yet recorded**.

**Next:** inspect F6 `scenes/dev/posthouse_playtest.tscn` (Q release/W read/E passed; 1/2/3 party; P/R pause/replay), get user feedback, fix any visible issues, then design the next **unique card-linked** travel art after explicit approval. **Never reuse the rejected generic village**. Don't modify the approved posthouse original, event effects, existing road, game saves, or Fate Spread. Protect the user's potentially dirty original Windows checkout before local Git operations.


## Cinematic Travel Scene02 - The Last Dawn Posthouse

Own authored location for unsent_letters, selected by a small card-to-resource catalog map. Exact approved PNG retained; only ordinary-bird removal and two distant heraldry corrections in derived layers. One skeletal pigeon with20 distinct poses; release carries one envelope and flies, read animates opened paper, passed keeps the bird with subtle shutter/lantern motion. Seven depth planes reuse V2 UI, party gait, pause, skip and router. No event effects, save fields, D412 or original road artwork changed. Native43-frame matrix,20 clean replay/free cycles and actual three-choice/save/old-route checks pass locally; final CI and user artistic review remain authoritative. [Contract and F6](TRAVEL_LAST_DAWN_POSTHOUSE.md).


## Cinematic Travel V2 - parallax and visual polish

Six independent depth planes retain PR #104 source pixels for the castle, close wall, valley and road over reconstructed occlusion plates. Local-clock gait/contact shadows/step dust, valley fog and cloth, compact serif narration, 360ms entrance and removal under the existing SceneTransition veil. No changes to story outcomes, rewards, saves, party balance or D412 atlases. Local full GUT279/279,71,900 assertions; native26-frame solo/duo/trio/pause/resize matrix and20 replay/free cycles. Final required CI and local artistic review remain authoritative. [V2 contract, evidence and F6](CINEMATIC_TRAVEL_V2.md).


## Travel panorama — mountain valley correction

User-requested art correction removes repetitive bridge-like ruins from the left/central middle distance and replaces them with distinct natural ridges and mist. Main castle, close right wall/banner, walking road and separate foreground retain the same composition. Cloth animation now masks only the remaining close banner; mountains stay rigid. Travel routing, duration, party sprites and game logic are unchanged. Original background remains recoverable in PR #103 / d4fead3f. Native verification uses the existing travel capture and F6 preview.


## Cinematic Travel V1 — Тропа вдоль мёртвых стен

Presentation-only, skippable4s travel overlay through the existing SceneRouter after the five Siege Echo outcomes and completed victory rewards. Explicit pre-completion context; no RunState mutation/save stage/deal management. Real D412 walk sprites retain actual party roles, two original parallax layers, soft mist and restrained cloth motion. Space/Enter/ESC/button skip, pause, disabled-feature fallback, single-navigation guard. [Contract, QA and F6](CINEMATIC_TRAVEL_V1.md). Full RELEASE required before merge; update user's main project after green checks.

## Echo of the Siege — fifteen decision-specific illustrations

Player correction: each of the three choices in each of the five events now has a distinct illustration depicting its action. The prior shared image across three slots is superseded. `choices/<choice_key>.webp` maps through the existing stable choice key; 15 PNG originals/prompts and source/runtime hashes are retained. Approved cards and the five event backdrops stay intact. [Action matrix, QA and local F6](ECHO_SIEGE_CHOICE_ACTION_ART.md). Delivery [PR #102](https://github.com/zampolit73/Misdeal/pull/102), [required checks](https://github.com/zampolit73/Misdeal/pull/102/checks). Update the main user project after green RELEASE without resetting local files.

## Echo of the Siege — event choice illustration pass

Five dedicated event paintings extend the exact approved card references: bandaging seamstress, chest-closing postmaster with one skeletal pigeon, young half-undead squire fastening oversized boots, cheating quartermaster before straw soldiers, skeleton raising a cold signal basket. Source PNGs/prompts under `assets/pixel/events/final_five/sources/event_choice_v1/`; `event.webp` (448×274) appears in choices and `backdrop.webp` (1280×720) behind the existing UI. Approved `card.webp` and card source PNGs remain unchanged. Packer/manifest track separate event sources and prevent reverting backgrounds to the card scene. [Production/QA contract](ECHO_SIEGE_EVENT_ART.md). Delivery: [PR #101](https://github.com/zampolit73/Misdeal/pull/101); [required RELEASE checks](https://github.com/zampolit73/Misdeal/pull/101/checks).

## Echo of the Siege — Narrative V2

User-approved narrative implemented for all five events: undead seamstress tending a skeleton, postal clerk and one skeletal pigeon, young squire in oversized boots, quartermaster cheating straw soldiers, skeletal signal watchman. Short card hooks, compact event scenes with resident dialogue, exact Wizard lines and fifteen literary resolutions now match the approved paintings. All choice keys, numbers, gating, clues, debt and save contracts retained. Art hashes guarded; actual QA uses `scenes/dev/final_five_playtest.tscn` (F6), plus full GUT and native 45-frame capture. Delivery: [PR #100](https://github.com/zampolit73/Misdeal/pull/100); [native QA and F6](qa/echo_narrative_v2/README.md). Final-head CI is authoritative.

## Echo of the Siege — five event text concepts drafted, NOT approved (2026-11-10)

The user requested fresh narrative/choice content for the five already-approved event cards: all scene participants are undead and unconsciously repeating daily duties from the fallen castle's siege. Consult [draft narrative and choice treatments](ECHO_SIEGE_EVENT_NARRATIVE_PROPOSAL.md) for exact vignettes, NPC/host lines, and 3 option scripts per event. The proposal aligns with actual `resources/cards/{banner_seamstress,unsent_letters,borrowed_boots,false_weights,last_signal}.tres`, `scripts/event/final_five_events.gd`, existing option keys and economy/stats, plus canon in `ACT1_PROMISED_DAWN_STORY_BIBLE.md`. **NO in-game text or gameplay was modified; the user has not yet approved the drafts.** If approval arrives, compress card_text to actual Godot 40–54px description layout and implement narrative strings only, preserving DS3, immutable art, run-state effects, evidence gates and independent event order. Verify F6 and focused tests after implementation.

## Living Arenas — three production pilots

Implemented in [PR #99](https://github.com/zampolit73/Misdeal/pull/99): `firing_square` (castle courtyard), `black_crossing`, `threadbare_theatre`. Local masks animate existing light, distant haze/water and heavy curtain folds behind the unchanged combat actors/HUD. Original art hashes, source geometry, tide hazards, balance and silent audio are preserved. Godot 4.7.2: 265/265 full GUT tests; final focused 5/5 (22,365 assertions), 327 native frames plus three resize captures; protected-floor pixel audit passes. [Implementation, measurements and F6](LIVING_ARENAS_PILOT.md). [Required RELEASE checks](https://github.com/zampolit73/Misdeal/pull/99/checks) must pass before merge. Arena changes are committed; remaining unrelated local settings/imports are preserved. **Do not expand to other arenas before the user's artistic review of these three pilots.**

## Echo of Siege — DEPLOYED to main, native QA pending (2026-11-10)

**Authoritative latest state:** user successfully pushed base five-approved-event art commit [56c7a70d](https://github.com/zampolit73/Misdeal/commit/56c7a70d), then pushed final **Borrowed Boots v2** image in [3ce01ac1](https://github.com/zampolit73/Misdeal/commit/3ce01ac1). Connector verified the latter commit modifies **only** `assets/pixel/events/final_five/borrowed_boots/{card,backdrop}.webp`, `assets/pixel/events/final_five/sources/echo_siege_approved/borrowed_boots/approved_source.png`, and `assets/pixel/events/final_five/manifest.json`. The other four approved scenes were not modified in the v2 commit. Manifest source SHA256 for boots v2 is `2ec39769890b2229255b62d46e7585186cf23b31b1c63a1da0c064c39f66d519`, card WebP `50905e5c52a61a3d2c6328715dbf5fb9fcce3927a67f5c84cf6df92a7e3c2944`, backdrop WebP `beaff13743e4a2f58cf45a56121c1823ff171fd8ddca57fd5ea390a9e3bc1e4e`. No event effects or DS3 scripts changed.

The previous "not yet deployed / missing binary" sections below describe **earlier history** and are superseded. No native F6 test or full RELEASE CI pass has been substantiated for this exact head (combined GitHub commit status currently has no reported statuses; this is not a pass).

**Next safe user action:** original `C:\Users\irlix\GodotProjects\Misdeal` is still on a very dirty `codex/living-arenas-pilot` branch — **do not reset, stash everything, switch branches, or pull on that checkout**. The separate `C:\Users\irlix\GodotProjects\Misdeal-Echo-Siege` worktree is at a detached commit `56c7a70d` and may not yet include boots v2. In that *separate* worktree, inspect `git status -sb`; if clean, run `git fetch origin main` and `git switch --detach origin/main`, then open its `project.godot` in Godot 4.7.x and launch `scenes/dev/final_five_playtest.tscn` with F6. If not clean, preserve changes and inspect before switching. Confirm all five portraits and event backdrops, especially new squire in `borrowed_boots`; verify ordinary card flows. Keep the original dirty arena work isolated. Update RELEASE/QA evidence only after test execution.


## Echo of the Siege — critical updated Borrowed Boots approval (2026-11-10)

User supplied and approved a **new final image** for `borrowed_boots`: *young partly skeletal squire fitting oversized boots*, campfire, ruined castle, canonical banner. SHA256 exact 1280×853 PNG `2ec39769890b2229255b62d46e7585186cf23b31b1c63a1da0c064c39f66d519`. It **supersedes** the older quartermaster/boot inspector picture described in historical handoff sections. Source and self-contained exact single-card installation ZIP persisted in Library `/Misdeal/approved_art/`; see [ECHO_SIEGE_BOOTS_V2.md](ECHO_SIEGE_BOOTS_V2.md). Four other approved images are already in GitHub and **must not be changed**. New `borrowed_boots` v2 PNG and 448×274/1280×720 WebPs are packaged and checksum-tested but **not yet pushed**. The ZIP contains `install.ps1` that uses a temporary detached worktree, pushes only three boots image files and `manifest.json` to `main`, protecting user's messy `codex/living-arenas-pilot` worktree. Once user runs it and reports success, verify latest GitHub `manifest.approved_sources.borrowed_boots` equals `2ec39769890b2229255b62d46e7585186cf23b31b1c63a1da0c064c39f66d519`; then request F6 in a clean updated main worktree. Never claim native QA has passed in advance.


## Local Git: dirty living arenas branch — use isolated worktree (2026-11-10)

User's PowerShell log confirms **active local branch `codex/living-arenas-pilot`** tracking `origin/codex/living-arenas-pilot`, with MANY staged additions/modifications for the living-arenas pilot and separate Godot import metadata changes. `git switch main` failed because local `docs/DECISIONS.md` and `docs/HANDOFF.md` changes would be overwritten; `git pull --ff-only origin main` also failed on modified `CHANGELOG.md`, `docs/PROJECT_STATE.md`, `docs/ROADMAP.md`, etc. **DO NOT reset, clean, blanket-restore or stash their current worktree.** New approved-siege art ZIP remains available in project conversation but binary asset push has not happened.

Safe isolation: while staying in the original `Misdeal` directory, run `git fetch origin main` and `git worktree add --detach ..\\Misdeal-Echo-Siege origin/main`. Open `..\\Misdeal-Echo-Siege` and run the already-committed installer `scripts/dev/install_echo_siege_art.ps1` with the user-downloaded `misdeal_echo_siege_approved_pack.zip` using `-Commit` ONLY. Installer's `-Push` intentionally rejects a detached/non-main checkout; after successful installation/commit use `git push origin HEAD:main` from this isolated worktree. This leaves original local arenas branch, staged work and Godot import files untouched. Verify F6 on isolated worktree afterwards; do not claim runtime integration until push succeeds.

## Echo of Siege ZIP import — branch mismatch diagnosed (2026-11-10)

Windows user ran `git pull` and `powershell -File .\scripts\dev\install_echo_siege_art.ps1 ...` from their local checkout; PowerShell responded that the script file did not exist. Live GitHub inspection confirms `scripts/dev/install_echo_siege_art.ps1` exists on `main` but not on remote `feature/echo-siege-approved-art-20261110` (nor the `design/a1v1-memory-stained-glass-20261110` branch). The pull fetched `origin/main` 78ead0ad..165af9f8 but reported `Already up to date`, suggesting the current local checkout tracks some other branch. **Next user action:** `git status -sb`, `git switch main` (if no blocking local changes), `git pull --ff-only origin main`, then `Test-Path .\scripts\dev\install_echo_siege_art.ps1` must output `True`; only after that run archive importer. Never reset/clean worktree to solve this. This turn also hardened importer commit isolation: it checks manifest edits, refuses `-Push` from a non-main branch, and uses `git commit --only` to avoid unrelated pre-staged changes. Verified conversation ZIP contains 5 exact SHA256 PNGs and 10 corresponding WebPs (448x274, 1280x720). **Asset binary integration and native QA remain pending.**


## Echo of the Siege — safe importer and asset pipeline prepared (2026-11-10)

`scripts/dev/install_echo_siege_art.ps1` now validates user-approved source PNG SHA256 and WebP SHA256 against the packaged manifest, copies exactly five approved sources and ten derived runtime assets, and records `manifest.approved_sources` during import. `scripts/dev/pack_final_five_assets.gd` recognizes those approved originals and never reverts them to previous option numbers once installed. **Files have not yet been imported to GitHub and Godot native QA remains pending.** The conversation ZIP is downloadable, and importing requires a local invocation because the connected GitHub text/object actions do not accept these binary files directly. See [ECHO_SIEGE_ART_ROLLOUT.md](ECHO_SIEGE_ART_ROLLOUT.md).


## Echo of the Siege — 5 of 5 arts selected, integration outstanding (2026-11-10)

Fifth user-approved `last_signal` = **OPTION 1**: solitary skeletal sentry on a ruined moonlit battlement holding an extinguished brazier on a pole, gold ring-cross on crimson banner; not spyglass or handheld lantern. SHA256 of 1536x1024 original `2a53828e4fec3105605502fe5a4aa05610c5af46f5f8d61e35fc79cde7854026`; persistent Library location `/Misdeal/approved_art/last_signal_echo_siege_approved_2026-11-10.png`. All five approved originals are in that Library directory; a ready-to-integrate ZIP containing all five PNGs, ten WebPs and checksums was generated and linked in the current project chat. **Only documentation has been committed to GitHub; new art is not deployed to runtime.** Important: old `manifest.json`/packer still reference old selected options; fix source-packing reproducibility during the actual asset PR. Do not claim CI/native pass until run. Exact five art identities and workflow: [ECHO_SIEGE_ART_ROLLOUT.md](ECHO_SIEGE_ART_ROLLOUT.md), [DECISIONS.md](DECISIONS.md). User only needs `git pull` AFTER image bytes have actually landed in a GitHub commit.


## Echo of the Siege — 4/5 approved scenes, 1 remaining (2026-11-10)

NEW: User approved **`false_weights` / «Неверные гири»** after fixing heraldry to the exact Misdeal worn-gold crosswheel with extended vertical shaft. This is the version with a skull-faced quartermaster **cheating helmeted scarecrow dummies (NOT living soldiers)** by adding stones to the left side of a brass balance against a small pile of grain on the right. Original 1536×1024 PNG SHA256 `6d1c166f5587a68f366f68b210e3f6cae748d8a35a77cadc2bab605d399e95d6` saved to user's Library `/Misdeal/approved_art/false_weights_echo_siege_approved_2026-11-10.png` (`libfile_65edaaee10448191860c137b40fa1234`). Full immutable visual requirements and prior 3 approvals: [DECISIONS.md](DECISIONS.md).

**Approval is not implementation.** As of this handoff, new Echo of the Siege arts have not been packed into final runtime `assets/pixel/events/final_five/<id>/{card,backdrop}.webp`; keep existing original DS3, event mechanics, other resources and rollback intact. Later, use the project's packaging code for 448×274 cards and 1280×720 backdrops and verify native F6. Four approved: `banner_seamstress`, `unsent_letters`, `borrowed_boots`, `false_weights`. The **only** remaining art selection is `last_signal` / «Погасший сигнал»; show options in chat before implementing any fifth card art.

## Echo of the Siege — 3/5 approved art (2026-11-10)

NEW: The user approved the **FIRST image** from the last four-result set for `borrowed_boots` («Чужие сапоги»). It shows an undead skeletal quartermaster/boot inspector, with an abandoned row of boots across a dark workbench, gothic window and warm lantern (not the other young-squire/scavenger options). Full-res 1535×1024 PNG exact source in user's Library `/Misdeal/approved_art/borrowed_boots_echo_siege_approved_2026-11-10.png` (`libfile_8eeb8fef6848819189a8f8a6f568ec47`), SHA256 `7cf1d2d0fa0cd813bdc0017b49d920f0fbd5692b0013f6d90cc716cb0120e88b`. The previous two approved art sources are under the same Library folder (`banner_seamstress`, `unsent_letters`). See [DECISIONS.md](DECISIONS.md) for exact art identity and locked composition. **All 3 new approvals are art-only; runtime WebP files in GitHub remain the old art.** Integrate later using the existing 448×274 and 1280×720 rules without modifying the event effects or DS3. Remaining cards for fresh art review: `false_weights` («Неверные гири»), then `last_signal` («Погасший сигнал»).

## Echo of the Siege — two art approvals; gameplay unchanged (2026-11-10)

Approved, not yet integrated: (1) `banner_seamstress` / «Знамя на бинты»; (2) `unsent_letters` / «Запертая почта». Second final image: an undead postmaster sealing a letter into an open chest, **one skeletal pigeon** on the chest lid, and the exact crimson/gold ring-and-cross castle banner; everything else as generated in user's chosen third variant. The 1535×1024 approved source PNG is stored in user's Library `/Misdeal/approved_art/unsent_letters_echo_siege_approved_2026-11-10.png`, SHA256 `3e84b66a1109af5867126e6a3d87dd480d28f6fe3641fef137ef8becfabb5e0f`. Source of truth for both visual approvals is [DECISIONS.md](DECISIONS.md), which includes exact provenance and constraints. **Runtime assets in GitHub are still the pre-existing original illustrations**; approval does not mean deployed. For integration use existing `assets/pixel/events/final_five/<card_id>/{card,backdrop}.webp` paths and `scripts/dev/pack_final_five_assets.gd` fit rules (448×274/1280×720), preserve originals, verify actual Godot F6 and tests. No changes to event mechanics, effects, DS3, choices or save contracts. Remaining review order: «Чужие сапоги», «Неверные гири», «Погасший сигнал».

## Echo of the Siege — user-approved «Знамя на бинты» scene (2026-11-10)

User approved the **exact** half-undead seamstress illustration with gold ring-cross banner sigil (not castle). 1536×1024 PNG SHA256 `be70f5375c703fc9ad4c5a1f5cfb57eea5f499ac849526348fa842ee483e39b2`; durable full-resolution source in the user's Library: `/Misdeal/approved_art/banner_seamstress_echo_siege_approved_2026-11-10.png`. Details and visual locks: [DECISIONS](DECISIONS.md#echo-of-the-siege--approved-art-direction-2026-11-10). Current GitHub card/backdrop remain **old artwork**, not yet replaced by this newly approved image. Integrate approved source (card 448×274; event backdrop 1280×720) while preserving existing 45-card mechanics, original DS3 skin and source rollback; verify actual native F6. Continue visually reviewing the other four «Эхо осады» event illustrations, with distinct options-first artworks.

## Final five Act I stories — 45 ordinary cards

Five new original noncombat events, fifteen art candidates with selected finals, existing DS3 and actual choices/ordinary tier dealing. Godot 4.7.2: 260/260 Linux GUT tests (48,919 assertions), 45 native frames on Windows and Linux. [PR #98](https://github.com/zampolit73/Misdeal/pull/98) carries the required full RELEASE checks. [Effects, sources, QA and F6](ACT1_FINAL_FIVE_CARDS.md). This task explicitly delegates art selection; PR89/90/92 remain independent.


## Memory Glass — enlarged inspection

Enlarge button opens fit/native zoom with wheel, LMB drag and bounded pan. Same original art/unlocked masks; ESC returns to the unchanged memory selection before closing Table overlay. [Controls and native QA](MEMORY_VIEWER_CHRONICLE.md). RELEASE required before merge.


## Memory viewer — approved Variant3

«Хроника осколков» integrated in production: original glass left, framed scrolling reader right, group tabs above, four fragment buttons/page below. Reuses dossier frame; all24 unlock/mask/save/reset rules retained. [Layout, native QA and F5/F6](MEMORY_VIEWER_CHRONICLE.md). RELEASE required before merge.


## New Game — clean memory (user correction)

Confirmed main «Новая игра» starts at0/24 with archived prior data. The separate dialog action «Новый забег — сохранить витраж» and RunEnd preserve collection. Cancel/load/startup never clear it. Local245 GUT tests and native confirmation→Intro→Table0/24 pass; RELEASE required before merge. [Reset contract and QA](RUN_SAVE_SYSTEM.md).

## Run save system

New Game/Continue/Exit and ESC Save/Load/Save & Exit/Main Menu; validated versioned slot plus backup,67-field audit, safe Table/Reward checkpoints and permanent-memory rewind protection. [Architecture, field inventory and QA](RUN_SAVE_SYSTEM.md). RELEASE checks required before merge; native screenshots under docs/qa/run_save. Local user settings preserved.


## A1V2 — «Витраж Памяти»

24 persistent narrative fragments, approved immutable art, real completion hooks, cap8/run, protagonist gates, modal viewer and restrained Table apertures implemented. No combat/economy/clue carryover. Local234 GUT tests and native0/7/24/ESC/pixel-preservation/restart checks pass. RELEASE CI required before merge. [Contract, trigger matrix, evidence and F6](A1V2_MEMORY_STAINED_GLASS_QA.md).


## A1V1 — «Витраж Памяти» — КОНЦЕПТ, не реализация (2026-11-10)

Пользователь одобрил направление: **24 постоянных между забегами сюжетных осколка** (12 хроника + по 4 Knight/Ranger/Mage), сбор не за один проход, разные взгляды на осаду. Полный 24-пунктный сценарный черновик и границы: [ACT1_MEMORY_STAINED_GLASS_CONCEPT.md](ACT1_MEMORY_STAINED_GLASS_CONCEPT.md). Не создавались Godot-код, сохранение, 24 арта и новая UI-сцена. Последний пользовательский запрос — сохранить весь контекст и продолжить творческий процесс, **следующий шаг: визуально оценить место витража на реальном утверждённом фоне, не переделывая его**. Идея размещения за спиной Волшебника — лишь кандидат; центр фона перекрыт его силуэтом. Сравнить с необязательным увеличенным осмотром и маленьким предметом на столе. Не считать окончательно утверждённым внешний вид, расположение, триггеры, сюжетные тексты или награды. Канон Герой/Канцлер/Комендант/XIII и отсутствие ранних спойлеров в сюжетной библии. D418/PR88 merged, 40/45 карт. Остальные активные ограничения ниже.

Delivery: [PR88](https://github.com/zampolit73/Misdeal/pull/88) · [final-head RELEASE checks](https://github.com/zampolit73/Misdeal/pull/88/checks).

## D418 — Jack event

User chose gateway art option1. Added Ranger-only Tier1 event with exactly three outcomes:25 gold → real animal companion, pass unchanged, or token → Ranger damage+10% for this run.40/45 ordinary cards; hero count/compensation,12+XIII, approved heroes and old mechanics preserved. Complete25-pose dog, actual native event/combat/choice/wave evidence and regression tests. [Behavior, assets, QA and F6](D418_JACK_EVENT.md). Final PR RELEASE CI must pass before merge; native F6 launcher `scenes/dev/jack_event_playtest.tscn`. Earlier VP1–VP7 release below remains merged at d49d51a1.

Delivery: [PR87](https://github.com/zampolit73/Misdeal/pull/87) · [final-head CI checks](https://github.com/zampolit73/Misdeal/pull/87/checks). Merge requires successful full RELEASE; current check conclusion is authoritative.

## Completed autonomous visual program

D414–D417 merged safely; native audit and conservative VP1–VP7 repairs delivered. Read [release QA](VISUAL_POLISH_RELEASE_QA.md), [audit](VISUAL_POLISH_AUDIT.md), [current state](PROJECT_STATE.md). User request is preserved at [original brief](requests/2026-11-09-visual-polish-plan.md). All approved artwork, Wizard/table/Fate backgrounds, D412 animations, combat/data/economy/silent-first audio preserved. Do not reopen old art approval gates for already accepted work.

Current checks:224/224 GUT,13 selector tests,52 production-state renders, ordinary Battle→Reward→Table, real solo/duo/trio motion and original75-pose Court audit. Eight new visual regressions cover artwork locks, all9 reward text strips, read-only focus/state, merchant picture/purchase states, resolved event labels, long event/shop tradeoffs, scroll containment and victory-button canvas ordering. Final CI runs full RELEASE, not only import.

## Next work

No confirmed in-scope P0/P1 remains in inspected fixtures. Address concrete player feedback or ranked P2 items from release QA. Older enemy art differs from accepted D412 figures, but automatic repaint/rebalance is outside scope. Existing GUT type warnings and shutdown resource diagnostics merit a separate technical cleanup; do not hide them or confuse them with a failed visual check. Original content expansion/approval backlog remains in [archived roadmap](archive/2026-11-09-pre-visual-polish/ROADMAP.md) and must be reconciled against GitHub before action.

## Local operation and safe Git

Workspace `C:/Users/irlix/GodotProjects/Misdeal`; native binary `C:/Godot/Godot_v4.7.2-stable_win64.exe/Godot_v4.7.2-stable_win64_console.exe`. Local project content already includes the delivery. Stop an old running preview, then F5. Check Reward positive/negative lines and RMB/F, merchant prices/effects/resolution, RunEnd scrolling, TAB/R/hover and bright enabled victory CTA.

Player-local project.godot/GUT import changes and untracked UIDs/imports were preserved, not staged. Do not recommend blind pull/reset/clean on this dirty checkout. A clean independent checkout can use `git pull --ff-only origin main`. Read-only hygiene tool remains available. Continue button's canonical Battle path is now `ResultOverlay/ContinueButton` (same action/coordinates); legacy route observers and DS2/DS3 styling were updated together.

## Reproduce QA

`godot --headless --path . -s addons/gut/gut_cmdln.gd -gexit`; `python scripts/ci/test_smart_qa_select.py`. Native matrix: `godot --path . --script res://scripts/dev/visual_polish_matrix.gd -- <absolute-output-dir> <tested-sha>`; optional third comma-separated fixture filter for focused captures. Matrix changes automatically select existing CI RELEASE mode. Native frame manifest records actual RunState and source SHA. CI artifacts contain full52-frame results; compact before/after evidence is tracked under docs/qa/visual_polish/.
