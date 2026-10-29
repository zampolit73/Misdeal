## 2026-10-29 — D373 recorded Foley pilot for Castle and Ossuary (candidate)

Player reviewed D372 and preferred only Courtyard ("более или менее"). New 16s recorded-material Castle (real wooden cabinet door, CC BY 3.0) and Ossuary (bone-like CC0 sound plus Blender Foundation water drips CC BY 3.0) were mastered as PCM WAVs with sparse quiet gaps. Courtyard remains SHA-identical; no music/UI/gameplay edits. Licenses, authors, original SHA and modification descriptions in [D373_RECORDED_FOLEY_CREDITS.md](docs/D373_RECORDED_FOLEY_CREDITS.md). Await Godot native QA and human acoustic quality confirmation.

## 2026-10-29 — D372 sparse environmental Foley-style scenes shipped

[D372 PR #37](https://github.com/zampolit73/Misdeal/pull/37) squash `68223fa00dfcbde7e9f6196298ed12062017affe`; [Godot 4.7.2 CI SUCCESS 79/79](https://github.com/zampolit73/Misdeal/actions/runs/40769450969), import/GDScript parse, native smoke and scene capture PASS. User complained the previous playable D371 backgrounds were simply continuous white noise. Replaced three 8-second source WAVs with three original 16-second mono PCM16 **synthetic** audio scene compositions, using widely separated resonant creaks, door/stone, intermittent gust and gate, dry bones/drips and near-silence instead of a continuous loud noise bed. F6 D372 room gives location cue times and playback-position status, retains Master/Ambience diagnostic buttons; updated GUT verifies source durations and dynamic contrast. Not field recordings; subjective listener quality remains OPEN. No music, game UI/visuals, encounter mechanics, D368 Combat or Oak B changes.

## 2026-10-29 — D372 replacing white-noise atmosphere (candidate)

After player confirmed audio playback works but feels like white noise, built three new sparse 16-second 16kHz mono synthetic environment scenes (castle timber/stone/iron, courtyard shaped wind/gate, ossuary bones/drips), replacing existing D369 WAV paths without changing audio bus routing. F6 D372 screen describes each scene's cue times and shows playback position; QA adds loud-event vs quiet-gap assertions and tests longer WAV imports. **Awaiting native CI and subjective user review.** Oak B, D368 combat and gameplay/visual art unchanged.

## 2026-10-29 — D371 audio presence and version diagnostics

[PR #36](https://github.com/zampolit73/Misdeal/pull/36) squash `ba1ff4fa6b770f3ff24cf52a747a642695751060`; [native Godot 4.7.2 CI SUCCESS 78/78 GUT](https://github.com/zampolit73/Misdeal/actions/runs/40767000965), import/parse, smoke and screenshots. Re-authored three existing castle, courtyard and ossuary original synthesized PCM WAVs at measurable audible-level RMS; F6 diagnostic scene now shows D371 build ID and Master/Ambience output-probe buttons, current location, bus dB/mute/stream/voice playing state and peak meters. F6 audition bus level is restored after exit. SoundDirector same-location restarts if the voice was stopped. **Live speaker verification pending**, approved Oak and D368 and normal game visuals/logic untouched.

## 2026-10-28 — D370: fix inaudible environment audio

[PR #35](https://github.com/zampolit73/Misdeal/pull/35) squash `0a1b003` merged after [Godot 4.7.2 CI 75/75 PASS](https://github.com/zampolit73/Misdeal/actions/runs/40732846429), import/parse, native smokes and visual capture. Fixed D369 mixer gain floor: already quiet WAVs were reduced by -16dB voice AND -10dB bus; now -2dB voice and -3dB bus (+21dB). F6 listening scene starts castle automatically, offers a short generated audible same-bus diagnostic tone, displays Ambience bus dB and lifts nearly muted slider on diagnostic. Three new regression tests cover levels, WAV non-silence and audible-test-stream PCM amplitude. Audio quality and real device playback still need human confirmation. B Oak, D368 and gameplay/visuals unchanged.

## 2026-10-28 — D369 subdued roomtone released

[PR #34](https://github.com/zampolit73/Misdeal/pull/34) squash `44f2e0b75df9861d820e36589c8cdc66d5a79596`; [Godot 4.7.2 CI SUCCESS](https://github.com/zampolit73/Misdeal/actions/runs/40711701797) **72/72 GUT**, imports, native smokes and screenshots. Added three original correctly encoded (256044-byte each) 8-second synthetic `castle/courtyard/ossuary` WAVs, dedicated persistent Ambience crossfade at 1.6s, arena/table/reward/event/menu routing, adjustable separate bus and F6 audition scene. A failed first candidate's malformed Base64 WAV files were replaced and checked by Git tree before successful CI. No music, gameplay/visual changes, Oak B or D368 modifications. **F6/F5 actual acoustic review open; standalone RELEASE matrix skipped.**

## 2026-10-28 — D369 subdued Act I ambience candidate

Staged 3 separate 8-second original digitally synthesized `castle/courtyard/ossuary` roomtones (16kHz mono WAV), persistent 1.6s low-volume crossfade, battle arena-based selector, table/event/reward/intro/end routing, live Ambience mixer slider in F6 audition and 7 GUT regressions. No new music, no visual/gameplay changes, D368 combat and approved B Oak untouched. **CI/merge and human acoustic quality pending**, subject to listening. [Pilot notes](docs/D369_AMBIENCE_PILOT.md).

## 2026-10-28 — D368 battle sound release verified

[PR #33](https://github.com/zampolit73/Misdeal/pull/33) merged to `main` as `20368dd822a06e234c9a5c23235c36744f01bba2`, [native Godot 4.7.2 CI SUCCESS](https://github.com/zampolit73/Misdeal/actions/runs/40705404555): **65/65 GUT**, import, smoke and screenshots passed. Eight short original synthetic Foley-style WAVs are live, with procedural fallbacks, 6 priority-capped Combat voices, separate bow variants and shared 155ms volley throttle; dedicated F6 scene available. D365 visuals, damage, balance, DS3/Fate and Oak B unchanged. **Real local acoustic review still open; not recorded field Foley.** Standalone RELEASE battle/animation matrix skipped.

## 2026-10-28 — D368 restrained combat sound pilot (candidate)

Staged 8 short 24 kHz mono PCM **synthetic** steel/bow(×2)/magic/bone impact/death/heal bell/boss samples, direct live CombatAudio integration with procedural fallback, a maximum of six priority-aware voices and family-level anti-machinegun throttles. Added F6 `scenes/dev/d368_combat_audio_audition.tscn`, 5 GUT checks and [auditory QA handoff](docs/D368_COMBAT_FOLEY.md). **Native CI and F5 ear acceptance pending**; B Oak and all mechanics/visuals unchanged.

## LATEST 2026-10-28 — Definitive Audio 1 handoff

[Current concise handoff](D368_NEW_CHAT_HANDOFF.md). **B — Oak already selected and live in main** via [PR #32](https://github.com/zampolit73/Misdeal/pull/32) `6d39c4e`, [CI success 60/60](https://github.com/zampolit73/Misdeal/actions/runs/40532236638). F5 live audio mix check pending. Next **D368** dry combat sound pilot then **D369** restrained ambient audio. Fate Spread untouched; D365 quiet-combat visual rule locked. Older notes below are historical.

## 2026-10-27 — D367B Oak table audio shipped

[PR #32](https://github.com/zampolit73/Misdeal/pull/32), squash `6d39c4e`, was merged after [Godot 4.7.2 Actions SUCCESS](https://github.com/zampolit73/Misdeal/actions/runs/40532236638), **60/60 GUT** and native scene/import checks. User-approved B WAV now plays on actual table deals; select/discard/meddle/milestone have four quieter synthesized oak/paper cues with procedural fallback and per-event anti-spam. F6 pilot marks B approved. No changes to combat sounds, ambience/music, UI or rules. **Local F5 listening still required**.

## 2026-10-27 — D367B approved Oak table audio pack (release candidate)

User chose **B — Oak** from the actual F6 audition. D367B feature branch now plays the original approved B WAV on real card deals, authors four short dry-oak/paper cues for select/discard/meddle/milestone, retains the original procedural soundbank as import fallback, and adds event-specific anti-spam and native GUT regressions. Audition scene now identifies the locked B sample. **CI/PR merge and F5 ear check still pending**; no actual recorded foley, combat sound changes, ambience/music or gameplay changes in this candidate. See [D367B release notes](docs/D367B_OAK_TABLE_RELEASE.md).

## 2026-10-27 — D367 consolidated new-chat handoff

Added [D367_NEW_CHAT_HANDOFF.md](docs/D367_NEW_CHAT_HANDOFF.md) and current pointers in the documentation index/state/roadmap/handoff. No additional gameplay or audio features. Recorded shipped PR #31/CI 56/56, unresolved audio A/B/C audition, approved DS3/Fate Spread/D365 boundaries and independent A1P3 release gates for the next chat.

## 2026-10-27 — D366–D367 Audio 1 pilot released

[PR #31](https://github.com/zampolit73/Misdeal/pull/31) merged `cd487890` with [Godot 4.7.2 CI](https://github.com/zampolit73/Misdeal/actions/runs/40527079810) **SUCCESS**, 56/56 GUT and native smokes PASS. Introduces UI/Combat/Ambience sound buses, SoundDirector, three 24kHz mono WAV card-deal prototypes and F6 sound audition with channel sliders. Existing live procedural cues stay in place; prototypes need human listening approval before replacing sound events. Game mechanics, DS3 and Fate Spread unchanged.

## 2026-10-27 — D366–D367 audio audition pilot

- Introduced native UI/Combat/Ambience bus layout and a small persistent SoundDirector API for independent volume and future crossfades; existing table/combat synthesizer events unchanged in timing and type.
- Created three 24 kHz WAV prototypes for the card-deal sound, plus F6 sound audition with three buttons and three gain sliders. **These samples are demo-only** until heard and approved; no new live sound bank, ambient loops or music claimed.
- Added GUT tests of bus routing, WAV import, volume/mute and audition scene. Main release gated by Godot CI; subjective timbre by player ear.

## 2026-10-27 — D365 combat feedback cleanup released

User local review led to [PR #30](https://github.com/zampolit73/Misdeal/pull/30) squash `67d5c852`. [Godot 4.7.2 CI](https://github.com/zampolit73/Misdeal/actions/runs/40523091071) SUCCESS: 51/51 GUT, native Battle scene smoke PASS. Remove automatic mouse-hover target rays and long Ranger/Bone Archer shot tracers/arrowheads; preserve chosen `ЦЕЛИ` pre-combat preview, short contact effects, damage/healing numbers and genuine heal links. Balance/AI/DS3 untouched. Human F5 recheck still pending.

## 2026-10-27 — D365 quiet-combat visual rollback

- After user’s local test, removed **unwanted** cursor-hover target line/rings and long archer/Ranger straight-arrow overlays. Restored explicit-only precombat `ЦЕЛИ` toggle and the earlier lightweight magic trace.
- Retained successful ally/enemy damage color distinction, combat numbers, true support-heal links, original hit reaction, targeting AI, timing and DS3. Replaced obsolete GUT hover-target tests with two opt-in-only checks.
- CI and user acceptance must be checked before declaring final release.

## 2026-10-27 — D362–D364 released to main

[PR #29](https://github.com/zampolit73/Misdeal/pull/29), `00294879`; [native Godot CI](https://github.com/zampolit73/Misdeal/actions/runs/40516027761) SUCCESS: **51/51 GUT**, D291 Battle native smoke and other core checks. Hero vs enemy damage colors, short straight arrowheads, hover actual target during real fights, and successful bellkeeper healing connection. Existing combat timing/gameplay and DS3 unchanged. Human three-fight F5 quality review pending.

## 2026-10-27 — D362–D364 battle legibility

- Added hover-only real combat target focus alongside existing precombat full intent preview. Does not alter AI.
- Clarified which side lost HP, with red hero damage numbers vs bronze enemy damage and straight-headed ranged traces.
- Linked source and healed ally on successful bellkeeper support heals using brief nonintrusive visual lines and rings.
- Added GUT regressions for hover focus / live target. No balance, encounters, approved artwork or DS3 changes; native Godot user acceptance pending.

## 2026-10-27 — D361 Act I readiness test released

- [PR #28](https://github.com/zampolit73/Misdeal/pull/28) merged `6c61fa2` after [Godot 4.7.2 CI PASS](https://github.com/zampolit73/Misdeal/actions/runs/40508157201): 49/49 GUT, new 40/40 current Act I card/boss visual-resource/target integrity checks PASS and native core smokes PASS.
- No changes to authored art, DS3, enemy compositions, rewards or game rules. Full human 12+XIII F5 playtest and separate RELEASE animation/Battle matrix remain outstanding; `docs/D361_ACT1_FINAL_QA.md` records procedure.

## 2026-10-27 — D361 complete-deck readiness regression

- Added GUT verification for **39 dealt Act I cards + Bone Warden XIII**, using shipped `RunCardData`, real EncounterData/event targets, the runtime `CardArtCatalog` first and the original `.tres` fallback when applicable. CI initial PR check **49/49 GUT**, all 40 card records; no gameplay/UI/asset alterations.
- Added scoped A1P3 final local QA checklist and evidence guidelines. This is **not** a human-playtested 12+XIII win or the standalone RELEASE animation matrix.


## 2026-10-27 — D360 final artwork released

D360 FINAL release verified: [PR #27](https://github.com/zampolit73/Misdeal/pull/27), squash main `6ee01f606d283e2f36823360ebc0178f134b4b34`, native [Godot 4.7.2 CI SUCCESS](https://github.com/zampolit73/Misdeal/actions/runs/40501281488) (import, GUT, D289/D315/D316, screenshots and evidence PASS; standalone RELEASE animation/battle matrix skipped). Exact approved final `firing_square_d360_approved_straight_arrows.webp` WebP 448×274 SHA256 `2d156da95541f8c31131581bb0a986384744c5b8fb1b49482aca745bd4cb6c72` / blob `0865337d3b76e8db5e744e4b4582b083d5eeeea3` present in main. User-approved third scene, revised to show bone archers shooting fallen skeletal bodies and straight shafts. D315 now guards 29 exact user-approved illustrations. No combat, DS3 or earlier art changed. Local gallery F6 + full A1P3 human F5 12 resolutions + XIII still pending. Planned art passes D356–D360 now complete.

## D360 — final corrected-arrow Firing Square art (2026-10-27, CI pending)

D360 «Расстрельная площадь»: user-approved FINAL third option, then corrected to show four skeletal archers firing at fallen skeletons and straight arrow shafts. Exact source `скелетный_рыцарь_в_огненном_дворе.png` (1536x1024, SHA256 `b32de7df8d9f9827221301ac977f5b900365e4551ba43490849f18c29d5908fc`). Runtime `assets/pixel/card_unification_v1/run/firing_square_d360_approved_straight_arrows.webp` (448x274, SHA256 `2d156da95541f8c31131581bb0a986384744c5b8fb1b49482aca745bd4cb6c72`, blob `0865337d3b76e8db5e744e4b4582b083d5eeeea3`). Only art override changed; the 4 archers plus sentinel stay mechanically identical. D315 now protects 29 selected illustrations. Native CI pending, not yet a release; next complete A1P3 F5 12+XIII human run and visual audit. See `docs/D360_NEW_CHAT_HANDOFF.md`.

## D359 — VERIFIED: «Последний звон» released to main (2026-10-27)

User-approved FINAL third D359 Last Bell illustration (two skeletal bellkeepers, central bronze bell, two skeletal sword raiders) was released in [PR #26](https://github.com/zampolit73/Misdeal/pull/26), squash merged `ee0982a98d022779f233f8572ba7f2f875feeb1b` after [real Godot 4.7.2 Actions run 40455007006](https://github.com/zampolit73/Misdeal/actions/runs/40455007006) **SUCCESS** (project import/GDScript, GUT, D289/D315/D316, real scene screenshots and artifact upload). Runtime 448×274 WebP `assets/pixel/card_unification_v1/run/last_bell_d359_approved_option3.webp` verified present on `main`, Git blob `801c513160358a23e9ecce101eee41c8a387f281`, SHA256 `d8ceeaf98209dc097ee8f291b44c81702091f5fb0b2bd54d16291766ed254bc1`. Exact original SHA256 `584ada89fe9f9c280ed6dd1ba0bb921ecda4d04f1f2f002271bc8bef3ef0c9ea`. D315 protects 28 individually selected paintings. No gameplay / DS3 / preceding art changed. Full RELEASE battle-animation matrix NOT run; A1P3 F5 human 12+XIII playtest remains outstanding. User: `git pull`, F6 `scenes/dev/d315_card_ds3_gallery.tscn`, check «ПОСЛЕДНИЙ ЗВОН». Next D360 `firing_square` options-first.

## 2026-10-27 — D359 approved «Последний звон» art integration

- User-approved third standalone art: two bellkeepers, large bell, two raiders in ruined tower; SHA256 `d8ceeaf98209dc097ee8f291b44c81702091f5fb0b2bd54d16291766ed254bc1` (448×274 WebP), original SHA256 `584ada89fe9f9c280ed6dd1ba0bb921ecda4d04f1f2f002271bc8bef3ef0c9ea`.
- Only `last_bell` run-card art override; D315 adds 28th guarded artwork. Combat and DS3 unchanged; CI pending.

## 2026-10-27 — D358 released with native Godot CI PASS

PR [#25](https://github.com/zampolit73/Misdeal/pull/25) squash-merged to main at `ac0a52180ed98a068334b5f4940d126f6eaff1b2` after [real Godot 4.7.2 Actions PASS](https://github.com/zampolit73/Misdeal/actions/runs/40451151255) (project import/GDScript, GUT, native smoke D289/D315/D316, GPU screenshot capture and evidence upload successful). Full authored RELEASE battle/animation matrix skipped; human A1P3 F5 12+XIII run still pending. Exact selected third `iron_wall` scene `assets/pixel/card_unification_v1/run/iron_wall_d358_approved_option3.webp` verified present in main: binary Git blob `b621374d1523ab8cef9040b94ca0cebfb90c023e`, 448×274 WebP, SHA256 `2d5ece6be4f3c4e4e695ea91899ce92aa6fd83f9d5b5ecd2a749ead91f2e3d99`. TWO armored skeleton guards with iron shields, ONE rear archer. D315 safeguards **27 approved images** (26 native WebP files and D350 encoded). No game mechanics, prior arts, or DS3 changed. Player: `git pull`, F6 `scenes/dev/d315_card_ds3_gallery.tscn`, inspect «ЖЕЛЕЗНАЯ СТЕНА». Next D359 `last_bell` and D360 `firing_square` (two remaining card art passes).

## 2026-10-27 — D358 Iron Wall selected art implementation (CI pending)

User approved the standalone final third "ЖЕЛЕЗНАЯ СТЕНА" artwork `скелетные_рыцари_в_крипте.png` (1536×1024, SHA256 `c29623adbe26853c81bd59191cbda467e33e6ca809bb52e3b9eda39a3bf39a71`): TWO imposing armored skeletal shield guards and ONE hooded skeletal archer behind in a vaulted ossuary. Exact game WebP `assets/pixel/card_unification_v1/run/iron_wall_d358_approved_option3.webp` 448×274 Q86 center-cropped from (0,42)–(1536,981), SHA256 `2d5ece6be4f3c4e4e695ea91899ce92aa6fd83f9d5b5ecd2a749ead91f2e3d99`, Git blob `b621374d1523ab8cef9040b94ca0cebfb90c023e`. Only CardUnificationV1.RUN_CARDS["iron_wall"] changed; original card Resource art fallback stays. D315 exact-image checks: 26 native WebPs + separate D350 encoded WebP = 27 approved illustrations (hash, size, WebP decode, live pixel equality). Combat composition, rewards, Godot DS3 and other art untouched. Native Godot 4.7.x CI pending; PR merge only after green GUT/D289/D315/D316 and screenshots. Next D359 `last_bell`, D360 `firing_square`; full A1P3 F5 12+XIII manual run still pending.

## 2026-10-27 — D357 native Godot release verified

- D357 «Врата оссуария» exact user-approved THIRD image is live on main from [PR #24](https://github.com/zampolit73/Misdeal/pull/24), merge commit `578502b2a6a7d713de01837ca25c8ccae67b57a8`, native [Godot 4.7.2 CI SUCCESS](https://github.com/zampolit73/Misdeal/actions/runs/40398849776) (GUT, D289/D315/D316 and actual screenshots PASS). Live WebP `assets/pixel/card_unification_v1/run/ossuary_gate_d357_approved_option3.webp`, 448×274 SHA256 `24e7fec8df8ac4f4b4610eb4032b6066d1d50b1dcff89a17d10cb4959d339645` (Git blob `eda1cda2b6a3309f2afe38071054ee736360c3ce`), from selected original `неживой_дозор_у_лунных_врат.png` SHA256 `f4442f0261219f832521fc1657305c4ac91884eed6d0febec8ecd36aae3c48e1`. Four undead defenders: guard, bell keeper, archer, thrall. Total D315 protected paintings 26. No gameplay, DS3, prior art changes. User local: `git pull`, F6 `scenes/dev/d315_card_ds3_gallery.tscn` and inspect «ВРАТА ОССУАРИЯ». Next D358 «Железная стена», then «Последний звон», «Расстрельная площадь» (3 artistic passes remain); full manual A1P3 F5 12 cards + XIII still outstanding.

## 2026-10-27 — D357 «Врата оссуария» art integration candidate

- Added exact user-approved third final Ossuary Gate painting as binary 448×274 WebP SHA256 `24e7fec8df8ac4f4b4610eb4032b6066d1d50b1dcff89a17d10cb4959d339645`, 4 authentic enemy roles and defended gate. Switched only `CardUnificationV1.RUN_CARDS["ossuary_gate"]` art override, kept legacy resource fallback. Expanded D315 strict hash/image/pixel coverage to 26 selected illustration locks. Updated project context and rollback identity; no combat, balance, DS3, other art changes. Native Godot PR CI pending.

## 2026-10-26 — D356 release verified

- D356 artwork user-selected FIFTH round-table composition shipped with [PR #23](https://github.com/zampolit73/Misdeal/pull/23), squash d9727dcc6ecf5b360f25cd926f2e6ee921842c16 and [Godot 4.7.2 CI PASS](https://github.com/zampolit73/Misdeal/actions/runs/40338354135). The file assets/pixel/card_unification_v1/run/faceless_card_d356_approved_option5.webp is present in main, binary Git blob 9bf6b31e3cd315ad1d27e1001adbb4770ab9bf36, 448x274, SHA256 7f811babefa69692614db472be8233ec70112551324e7774600b74bdc47f925c. Godot import, GUT, D289/D315/D316 and real screenshot capture/evidence passed. D315 protects 25 selected card illustrations. Choices, prices, DS3, balance and previous art unchanged. User git pull, F6 scenes/dev/d315_card_ds3_gallery.tscn, inspect 'КАРТА БЕЗ ЛИЦА'. D357 next: guard + bell ringer + archer + thrall at actual Ossuary Gate (reject old empty-gate triptych). Full Act1 12+XIII F5 human playtest is not yet done.

## 2026-10-26 — D356 Faceless Card approved fifth image

Exact fifth round Misdeal table composition installed as faceless_card_d356_approved_option5.webp (448x274, SHA256 7f811babefa69692614db472be8233ec70112551324e7774600b74bdc47f925c). CardUnificationV1 mapping + D315 strict 25-approved-image checks. Old .tres fallback, event, balance, DS3 and prior artwork unchanged. Native Godot 4.7.2 CI pending; full F5 Act1 manual playtest still needed.

## 2026-10-26 — D355 verified Godot release

- [PR #22](https://github.com/zampolit73/Misdeal/pull/22) merged `0304f634` after [Godot CI PASS](https://github.com/zampolit73/Misdeal/actions/runs/40325370134): GUT, D289, D315 (24 approved images), D316 and authentic screenshot artifact upload. Installed exact approved third Death Wager scene (448×274 WebP `4ee5865a55d8dc0ebc35eb49b6572901dbeec24cf1878efbcf199a4add85ba7b`) without gameplay, reward, layout or earlier art changes. Local F6 and full A1P3 F5 playtest still pending.

## D355 — Death Wager new approved art (2026-10-26)

Final user-selected D355 standalone option #3 `стражи_проклятой_крипты.png`: five undead before sealed ossuary doors — an armored skeletal captain with heavy axe, two hooded skeletal archers on raised flanks, and two weaker skeletal fighters at front. Original 1604×981 PNG SHA256 `0e0283c8c94c6f9e708110b3968c7c8d341de3463d14b8122977488bc69a8472`. Exact resized 448×274 WebP quality 86 at `assets/pixel/card_unification_v1/run/death_wager_d355_approved_option3.webp`, SHA256 `4ee5865a55d8dc0ebc35eb49b6572901dbeec24cf1878efbcf199a4add85ba7b`. No crowns, bells, wizards or UI inside painting.

`CardUnificationV1.RUN_CARDS["death_wager"]` selects this approved art; prior Bone Patrol path in `.tres` stays as fallback. D315 native-file approved gallery list is extended to **24** entries and checks strict SHA256, WebP decoding, dimensions 448×274 and catalog pixel equality. No changes to the five-enemy encounter, elite rewards (gold/relic/extra upgrade), balance, DS3, or already approved art.

Native Godot 4.7.2 PR CI **PENDING**: require 48/48 GUT, D289 Table, D315 Gallery, D316 Card Surfaces and screenshot capture before merge. Local review after merge: `git pull`, F6 `scenes/dev/d315_card_ds3_gallery.tscn`, inspect «СТАВКА НА СМЕРТЬ». Full A1P3 F5 12+XIII manual run still pending. Next D356: new art options-first.

## 2026-10-26 — D354 native Godot verified and merged

- [PR #21](https://github.com/zampolit73/Misdeal/pull/21) squash-merged `631e16a142b863e19e4be82a37aa284119c8470d` after [native Godot 4.7.2 CI PASS](https://github.com/zampolit73/Misdeal/actions/runs/40315124428) on head `0ba96e9da94995d6efa27a48aab5827a0c713314`: **48/48 GUT**, D289 Table, **D315 Gallery including exact user-approved 23rd `grave_bell` image**, D316 Card Surfaces and authentic 1280×720 Table/Gallery screenshot captures, evidence uploaded. Live WebP `assets/pixel/card_unification_v1/run/grave_bell_d354_approved_tower.webp` SHA256 `9eb40f8db8cb734a1283a90fc746d1b4d358f28ab27824394d803cb3a1c9cbef`. User-chosen standalone #2 (skeletal ringer pulling rope of giant cracked hanging bell); no change to Grave Bell fight/healing, DS3 or other locked paintings. User after `git pull`: F6 `scenes/dev/d315_card_ds3_gallery.tscn`, inspect «МОГИЛЬНЫЙ ЗВОН». Full A1P3 F5 I–XII+XIII manual player run still outstanding. Next D355 art options-first.

## D354 — Grave Bell artwork (2026-10-26)

Added approved standalone second Grave Bell depiction (graveyard's cracked bronze bell, robed skeletal ringer, two risen skeletons) as `grave_bell_d354_approved_tower.webp` 448×274 WebP. Connected `RUN_CARDS["grave_bell"]` with existing Resource fallback, extended D315 strict artwork check to 23 approved card arts. No gameplay, unit, boss, healing, DS3 or other art modifications. Native CI and player F6 check remain separate.

## 2026-10-26 — D353 verified Godot release

- [PR #20](https://github.com/zampolit73/Misdeal/pull/20) merged `3144899a`; [native Godot 4.7.2 CI](https://github.com/zampolit73/Misdeal/actions/runs/40239294144) PASS: 48/48 GUT, D289/D315 (22nd exact visual guard)/D316, screenshot/evidence steps successful. Approved crypt elite plus two thralls live; player F6 and A1P3 human F5 still pending.

## 2026-10-26 — D353: approved Crypt Guard second painting

- Connected user-approved standalone armored crypt sentinel plus two bone thralls as 448×274 WebP `crypt_guard_d353_approved_option2.webp`. Card catalog overrides old Bone Patrol placeholder while keeping legacy fallback. D315 now protects 22 distinct approved paintings by exact D353 SHA256/WebP decode/dimensions/live pixels. No encounter/balance/DS3/previous artwork edits. Native CI and user F6 acceptance are separate steps.

## 2026-10-26 — D352 released and Godot 4.7.2 verified

- [PR #19](https://github.com/zampolit73/Misdeal/pull/19) merged `a5290fa`; [CI](https://github.com/zampolit73/Misdeal/actions/runs/40237209321) passed 48/48 GUT, D289/D315/D316 and native Table/Gallery screenshot captures. Final Wizard Tithe **without crown** live, 21st strict gallery art lock. Player F6 and A1P3 full first-act F5 playthrough still open.

## 2026-10-26 — D352: Wizard Tithe final crownless ritual image

- Installed the explicitly approved #2 altar scene revised to remove the wizard crown (`wizard_tithe_d352_approved_hooded_ritual.webp`, 448×274), reusing full original art colors and composition. Retained legacy fallback; extended D315 to 21 exact-art checks (SHA/WebP decode/size/live gallery pixels). No event mechanic, DS3 or older asset changes. Native Godot PR CI and user F6 check remain separate gates.

## 2026-10-26 — D351 verified native Godot release

- [PR #18](https://github.com/zampolit73/Misdeal/pull/18) merged to main at `968fd0f`; [CI](https://github.com/zampolit73/Misdeal/actions/runs/40234667983) native Godot 4.7.2 PASS: 48/48 GUT, D289/D315/D316 and screenshot steps. D351 Bone Tax standalone art shipped with 20th image exact hash/decode/pixel validation. Player F6 and A1P3 full F5 still outstanding.

## 2026-10-26 — D351: Bone Tax skeletal gatekeeper illustration

- Added exact user-chosen first `bone_tax` portcullis/toll-guard scene at 448×274 as native binary WebP, connected to `CardUnificationV1` with fallback retained. D315 now checks 20 approved unique scene paintings (binary hash/decode/size/catalog pixel equality). Updated current decision, visual registry and handoff without gameplay or DS3 modification. Native CI and local F6 review still need separate verification.

## 2026-10-26 — D350 Godot release verified

- [PR #17](https://github.com/zampolit73/Misdeal/pull/17) squash-merged `fa03cbf` to `main`; [Godot 4.7.2 CI](https://github.com/zampolit73/Misdeal/actions/runs/40232179481) passed 48/48 GUT plus D289/D315/D316 native smokes and captured 2 actual 1280×720 screenshots. D350 image and native card pixel/decoded SHA guard shipped; local F6 player review remains separate. Gameplay and DS3 unaffected.

## 2026-10-26 — D350 approved Debtor Bones illustration

- User-approved standalone skeletal hand rolling three bone dice is integrated as the 19th user-locked card illustration. Exact WebP bytes are tracked in a Base64 source file (448×274 SHA256 `8b08781cb21c56bbef50b01b3fda0d0de02248f0ecd22256d5761a31c3be8113`) and decoded by existing card-art class. D315 validates original decoded checksum and live pixels. No gameplay, event effects, DS3 or previous approved art changes. Native CI and local Godot F6 visual check pending.

## 2026-10-25 — D349 verified release

- [PR #16](https://github.com/zampolit73/Misdeal/pull/16) merged `c227621`; [native Godot CI](https://github.com/zampolit73/Misdeal/actions/runs/40227525071) passed 48/48 GUT, D289/D315/D316 smokes and produced 2 genuine Godot screenshots. Local F6 art approval and full A1P3 F5 player run remain pending.

## 2026-10-25 — D349: Broken Crown chosen third artwork

- Integrate user-approved shattered crown/helmet/sword image as live `broken_crown` card at 448×274; exact D315 SHA/decode/size/catalog regression now covers 18 scenes. Retain original fallback, DS3, gameplay and prior art. Native PR CI + user F6 approval are separate follow-ups.

## 2026-10-25 — D348 CI verified and merged

- [PR #15](https://github.com/zampolit73/Misdeal/pull/15) merged at `69e8f3e`; [Godot 4.7.2 run 40223519538](https://github.com/zampolit73/Misdeal/actions/runs/40223519538) passed 48 GUT tests, three relevant native smokes, two real rendered screenshots. D348 user F6 review remains pending.

## 2026-10-25 — D348: Curse Forge user-approved image

- Add exact user-reposted 50% human / 50% skeletal blacksmith to live Curse Forge card as 448×274 WebP with 17-image D315 SHA/decode/texture guard. Existing card mechanics and all earlier visual decisions unchanged; native CI/hand-playtest verdict pending.

## 2026-10-25 — D347: Official Godot CI green and merged

- [PR #14](https://github.com/zampolit73/Misdeal/pull/14) merged to main as `85ffbda`, carrying exact D347 approved WebP and native 16-art integrity guard.
- [Godot 4.7.2 Actions https://github.com/zampolit73/Misdeal/actions/runs/40194579988](https://github.com/zampolit73/Misdeal/actions/runs/40194579988) verified **48/48 GUT PASS**, D289 Table, D315 Card DS3 and D316 card surfaces PASS; rendered authentic Table and gallery screenshot evidence.
- F6 human visual inspection and A1P3 normal F5 12+XIII full run are still open acceptance gates.

## 2026-10-25 — D347: Approved Last Camp art integrated

- Shipped original user-approved third «Последний свидетель» standalone veteran beside the castle outpost campfire as 448×274 WebP (`assets/pixel/card_unification_v1/run/last_camp_d347_approved_last_witness.webp`).
- `last_camp` now resolves via live card catalog override; original card resource, event gameplay and old fallback remain unchanged.
- Extended D315 authenticity/decode/448×274/pixel-check coverage to 16 locked artworks with exact D347 SHA256; native CI and F6 user signoff must be observed separately.
- Updated design decision, state, roadmap, registry and next-chat context, preserving A1P3 outstanding F5 human playthrough.

## 2026-10-25 — D346: Rattling Bridge final continuous-castle art

- Implemented exact user-approved **third** «Гремучий мост» scene after marked sky replacement and extending one uninterrupted castle wall instead of another distant bridge.
- Added native 448×274 WebP, live `RUN_CARDS["rattling_bridge"]` mapping and D315 exact-art SHA-256, decode, dimension and real catalog pixel regression; existing event / gameplay / DS3 and approved earlier art intact.
- Updated visual decisions, state, roadmap, registry and handoff without altering prior verified A1P3 CI integration work. Native test for this later commit pending.

## 2026-10-23 — A1P3 native Act I stage-handoff QA and DS3 warning repair\n\n- Added five native GUT integration cases instantiating original ActChoice, Table, Battle, Reward and RunEnd scenes for event progression, victory rewards, XIII victory, defeat/Last Deal and prisoner recruitment. Tests inject battle outcomes / fast-forward route state and **do not claim real 13-fight balance QA**.\n- Native [initial PR #13 red run](https://github.com/zampolit73/Misdeal/actions/runs/39964235068) identified 11 existing full-rect anchor/size warnings emitted during the real Battle DS3 UI setup. Removed the redundant explicit size writes on panel/tactic reliefs in `battle_ds3_pass.gd`; no design, gameplay or source art changes.\n- Prepared [12+XIII player F5 playtest](docs/A1P3_LOCAL_PLAYTEST.md) covering event choices, rewards, boss, defeat/Last Deal, party fates and pacing. Final [Godot CI 39964999071](https://github.com/zampolit73/Misdeal/actions/runs/39964999071) **48/48 GUT, 5,860 assertions, 8 smokes PASS**; [PR #13 merged](https://github.com/zampolit73/Misdeal/pull/13) `f30e008`. Human experiential feedback remains a separate acceptance gate.\n\n## 2026-10-23 — A1P2 first-act route audit and Fate Hold combat invariant

- Audited 36 deterministic solo/duo/trio 12+XIII Fate Spread **state routes** on original Godot resources (432 choices); documented encounter rhythm and limitations in `docs/A1P2_ACT1_ROUTE_AUDIT.md`.
- Fixed a confirmed bug where a held noncombat event returning at the mandatory combat slot could let a player skip the fight. It now returns immediately after the forced combat; ordinary two-deal Hold remains unchanged, and the tooltip explains the exception.
- Added two original GUT suites for end-to-end state progression and held-card gate; [43/43 GUT tests, 5,752 assertions and original native/visual smoke PASS](https://github.com/zampolit73/Misdeal/actions/runs/39960631781). [PR #12 merged](https://github.com/zampolit73/Misdeal/pull/12) `c4501ee`.
- No new mechanics, combat/enemy tuning, card weighting, rewards or approved imagery modified.

## 2026-10-23 — A1P1 Wizard discard-memory beats

- The Wizard now reacts with three distinct short context lines to the last actually rejected Fate Spread card after resolutions 3, 7 and 11, enhancing continuity in Act I without a new mechanic.
- Eight GUT tests verify source of discarded name, timeline, priority, missing rejection and authentic three-choice flow; [Godot CI 40/40 PASS](https://github.com/zampolit73/Misdeal/actions/runs/39957116934), 141 assertions.
- [PR #11 merged](https://github.com/zampolit73/Misdeal/pull/11) `63e6d7d`; no card probabilities, graphics, balance or progress changes.

## 2026-10-23 — GUT3 additional combat rules regression coverage

- Added 16 real-unit Godot GUT tests for target-selection tactics, Bone Warden 50% enrage, and Pallbearer Last Rite resurrection/cancellation in 3 new GDScript test files.
- Official Godot 4.7.2 native [PR CI](https://github.com/zampolit73/Misdeal/actions/runs/39955690331): **32/32 tests PASS, 110 asserts**, previous native smokes PASS; [PR #10](https://github.com/zampolit73/Misdeal/pull/10) merged `394b0d9`.
- No changes to gameplay rules, resources, sprite atlases, approved card art or runtime scenes.

## 2026-10-23 — GUT editor Run All first-install fix

- Seed new GUT editor panel's test folders from tracked `.gutconfig.json`; keep custom user GUT settings intact, no manual settings edits required on fresh install.
- Add three regression tests for empty/configured/disabled editor directories; [real Godot 4.7.2 GUT 16/16 PASS](https://github.com/zampolit73/Misdeal/actions/runs/39954278962), ordinary smoke and visual QA green.
- [PR #9 merged](https://github.com/zampolit73/Misdeal/pull/9) as `6320585`. Gameplay/graphics unaffected.

## 2026-10-23 — GUT1 released with real native unit coverage

- [PR #8 merged](https://github.com/zampolit73/Misdeal/pull/8), main commit `7290f35`: pinned GUT 9.7.1 (MIT) under `addons/gut`, enabled plugin in Godot 4.7.2.
- 13 executable BattleUnit/RunState tests, 51 assertions; CI requires nonzero GUT discovery. Cleaned test-only VFX. [Final native CI SUCCESS](https://github.com/zampolit73/Misdeal/actions/runs/39952061209) including existing gameplay/visual smoke.
- Kept source game behavior, approved art, QA Hub and main F5 launch unchanged.

## 2026-10-23 — OPT1 + OPT4 smart Godot QA and F6 launcher

- Upgraded existing required GitHub PR smoke to safely select docs-only, FAST or VISUAL scopes by changed paths, with manual full RELEASE. Added eight selector unit tests and original Godot screenshot evidence collection; no new paid plugins.
- Added DS3-styled categorized F6-only `qa_hub.tscn` linking existing scene QA and actual game screens, plus native QA Hub smoke. Ordinary F5 main game unaffected.
- Kept specialist CI3/4/5 available via manual dispatch to avoid redundant PR execution; [PR #7](https://github.com/zampolit73/Misdeal/pull/7) merged after [8/8 native checks and five authentic screenshots PASS](https://github.com/zampolit73/Misdeal/actions/runs/39944961444).
- Preserved all approved card illustrations, sprites, game mechanics and current D345 art approval gate.

## 2026-10-23 — D345: Ship approved Chained Prisoner «Old Acquaintance» image #2

- Real GitHub publication of the final user-approved prisoner illustration (shackled living former soldier with recognizing gaze behind prison bars). Resized original 1608×978 directly to 448×274 WebP.
- Added `chained_prisoner` live catalog override and native D315 strict SHA-256/image decode/size/live texture regression; original event card file, mechanics and DS3 unaffected.
- Updated current state/roadmap/visual decisions/registry/handoff after previously incorrect no-GitHub-access replies; preserved CI5 and all earlier approved painting assets. Native post-D345 test outcome separate.

## 2026-10-23 — CI5 real Battle matrix and original animation-frame audit

- Added opt-in Godot 4.7.2 Xvfb QA for genuine Court of the Mute trio and Grave Bell duo production fights: 8 full native 1280×720 images, correct rosters/encounter rules, observed movement 123.37/124.61px, motion CSVs.
- Validated and exported original authored Court Magistrate/Scrivener/Bailiff runtime SpriteFrames: 3 atlases of 25 distinct 96px poses, correct 5 unused alpha-clear cells, no missing/cropped poses; 75-row pixel-foot/edge CSV. No game artwork changes.
- [PR #6 merged](https://github.com/zampolit73/Misdeal/pull/6) `b3a5699`; native [CI5 PASS](https://github.com/zampolit73/Misdeal/actions/runs/39939170351) and [7/7 smoke PASS](https://github.com/zampolit73/Misdeal/actions/runs/39939170283).

## 2026-10-23 — CI4 real Battle movement capture

- Added opt-in GitHub Actions capture of production Graveyard Ambush: genuine Knight and 3 authored skeleton enemies, native prep/intro plus five timed live frames (Godot 4.7.2 Xvfb/Mesa).
- Enforced 1280×720 PNG integrity and frame uniqueness, runtime Fight start and unit movement; saved PNGs, motion CSV and logs for ChatGPT QA. Included 3fps MP4 review flipbook (not continuous native 60fps gameplay).
- [CI4 seven-frame actual PASS](https://github.com/zampolit73/Misdeal/actions/runs/39937515858), [7/7 native smoke PASS](https://github.com/zampolit73/Misdeal/actions/runs/39937515794); no approved image, combat, animation sheet or gameplay changes.

## 2026-10-23 — CI3 actual Godot screenshot automation

- Added GitHub Actions optional actual rendered frame capture (Godot 4.7.2 Xvfb/Mesa) for real ClassSelect, Table, D308 Wizard panel and D315 gallery scenes.
- Saved nonblank original native 1280×720 PNGs + import/capture logs as GitHub artifact; first verified [run 39934851995](https://github.com/zampolit73/Misdeal/actions/runs/39934851995) SUCCESS, parallel full 7/7 native smoke PASS.
- No gameplay, approved painting, design-system, balance or animation edits; screenshots are Linux software-rendered references, not final visual approvals.

## 2026-10-23 — CI2 Wizard objective native smoke and D313 live bounds

- Extended general read-only PR gate to seven native Godot 4.7.2 functional scripts by adding D306 Wizard side objective and D308 F6 preview.
- Fixed actual Godot Label min-height overlap between D311 Wizard objective rule and reward: y38/y73 keeps readable font/approved plaque and stays above carved border. No game balance, art assets, reward mechanics or controls changed.
- [PR #3](https://github.com/zampolit73/Misdeal/pull/3) merged, [7/7 native PASS](https://github.com/zampolit73/Misdeal/actions/runs/39933674652), separate [D291 push-to-main PASS](https://github.com/zampolit73/Misdeal/actions/runs/39933807515).

## 2026-10-23 — CI1 GitHub Actions pull request smoke

- Added read-only cross-project Godot **4.7.2** PR smoke: verified official runtime, native import/parse and D279/D289/D291/D315/D316 regression suites with PASS sentinel validation.
- Added GitHub Job Summary and attached logs for failure diagnosis, and `docs/CI_AUTOMATION.md` describing web ChatGPT + GitHub workflow.
- No game code, art, animation, balance or locked visual approvals modified. Visual preview automation is a separate planned follow-up.

## 2026-10-23 — D344R2: Candle Seller replacement per newest user-approved image

- Replaced earlier D344 thin-taper candle scene with user-selected revised `оккультный_ритуал_при_свечах.png` (hooded merchant, ivory/red/indigo candles, Gothic cabinet). Converted to 448×274 WebP and wired to live catalog.
- Kept old D344 painting for rollback; corrected D315 exact SHA-256/regression asset selection and updated documentation/handoff. No event mechanics or Card DS3 changes. Native Godot CI requires independent check.

## 2026-10-23 — D344: Candle Seller approved thin tapers and arched candle cabinet

- Committed user-approved final `candle_seller` painting: dark hooded trader, THREE slender muted candles and the final replacement candle-filled Gothic cabinet on right, no distant outdoor sunset.
- Published 448×274 WebP, wired live Card DS3 catalog override; old event Resource, mechanics, layout and earlier approved art unchanged.
- Extended D315 native art integrity smoke with exact SHA/decode/dimensions/live catalog check; wrote D344 project/decision/roadmap/registry/handoff history. Native CI still requires real runner verification.

## 2026-10-22 — D343: Lost Purse approved cropped-head corpse artwork shipped

- Replaced path-only response with real GitHub publication of user-reposted `закатная_добыча_на_кладбище.png` (gold purse, dead hand, reclining body with skull out of frame), converted to native 448×274 WebP.
- Bound `RUN_CARDS["lost_purse"]`; unchanged event gameplay/Resource, D328 Card DS3 frame/text and other approved assets.
- Extended D315 exact SHA/decode/native dimensions/live catalog verification; updated decisions, registry, state, roadmap and current new-chat handoff. Native CI separately pending.

## 2026-10-22 — D342: Publish edited Ash Rest sunset camp, no distant ruins

- Corrected previous path-only response by committing user-approved revised campfire scene: right-side distant ruined arches removed, left ruined shelter wall and empty bedrolls retained.
- Exported selected full-resolution PNG into native 448×274 WebP; mapped `ash_rest` in live `RUN_CARDS` catalog. Event Resource, mechanics, DS3 frame and earlier art unchanged.
- Added exact binary SHA-256 + WebP decode/dimensions/live catalog regression to D315; refreshed project state, decision, roadmap, visual asset registry and new-chat handoff. Native CI result to be confirmed.

## 2026-10-22 — D341: Gravedigger Shop approved old-man illustration shipped

- Honored approval of final color-preserving, slightly decluttered living elderly gravedigger artwork; previous assistant only sent a local source path.
- Exported selected 1619×971 PNG to 448×274 WebP with minimal side crop; mapped `gravedigger_shop` in live Card DS3 catalog, retained previous art.
- D315 regression now checks exact D341 SHA/decode/size/catalog pixels. Shop encounter/resources, game mechanics and D328 UI unchanged; refreshed project state, design decision, roadmap, registry, handoff and changelog.
- Native Godot CI outcome is separate, not presumed green.

## 2026-10-22 — D340: Whispering Well first ghost reflection shipped

- Corrected previous local-file-only response by pushing user's approved FIRST full-size reflection well painting into GitHub (real 448×274 WebP, original composition retained).
- Updated `RUN_CARDS["whispering_well"]` only; old WebP remains as rollback, event content and D328 Card DS3 unaffected.
- Added D315 image-integrity/hash/decode/dimension/catalog protection, handoff, registry, state, roadmap and decision record. Native Godot verification is separate.

## 2026-10-22 — D339: Grave Crossfire option 3 published

- Locked user's THIRD image of final Grave Crossfire triptych: crossfire flanks each have a skeletal bowman and the middle is blocked by a sword/shield skeleton.
- Exported original 1604×981 illustration without crop at 448×274 WebP; mapped `grave_crossfire` in live catalog while preserving legacy image.
- Extended D315 smoke to check exact SHA-256, decoding, native dimensions and catalog pixel match; documented locked art. D328 DS3, fight enemies, balance and gameplay untouched; post-commit native CI not yet verified.

## 2026-10-22 — D338: Bone Swarm second swamp artwork approved and shipped

- User picked exact second final swamp-swarm artwork (`скелетный_рейд_в_туманном_болоте.png`), four melee raiders in blue-gray marsh with hanging lamps.
- Published native 448×274 WebP from original 1536×1024 source with top-anchored composition crop; linked to `bone_swarm`, original legacy WebP retained.
- D315 regression enforces file SHA, WebP decode/size and catalog texture consistency; documented final visual approval. Card DS3 D328, combat and encounter definitions unchanged; native CI review is separate.

## 2026-10-22 — D337: Gallows Volley approved option 1 shipped

- Confirmed connected GitHub write access and published user-approved first (upper wide scene) Gallows Volley image as a unique 448×274 WebP; used a focal crop to preserve gallows, BOTH bowmen and shield fighter.
- Switched `gallows_volley` asset override only, without changing DS3 frame, UI text, combat mechanics or encounters; previous WebP retained.
- D315 integrity guard now verifies approved SHA, decode/dimensions and catalog pixel match. Saved current state, design decision, asset registry and new-chat handoff; native Godot run outcome requires separate verification.

## 2026-10-22 — D336: Ship exact already-approved Graveyard Ambush option 1

- Corrected unnecessary extra art exploration after user's prior approval and used the **exact PNG reattached by the user**.
- Added full-original 448×274 game WebP, bound `graveyard_ambush` to its own selected image, preserved old fallback for rollback.
- Extended native D315 QA with SHA-256, decoding, expected dimensions and catalog pixel comparison; no encounter, UI or gameplay changes.
- Updated current handoff, project state, roadmap, decisions and visual asset registry. Native Godot CI verification separate.

## 2026-10-22 — D335: User-selected pixelated Bone Ritual #3 shipped

- Selected exact third of the latest three more-pixelated ritual images; exported a real 448×274 WebP directly from 1604×981 approved original, not Canva thumbnail upscaling.
- Mapped `bone_ritual` by exact RunCardData ID to unique image; added D315 SHA/decode/dimensions/catalog regression and preserved old source.
- Updated project state, decision, registry, roadmap, handoff. Frozen Card DS3, Table mechanics and battle encounter unchanged; native CI result is a separate check.

## 2026-10-21 — D334: Consolidated new-chat handoff after successful D333 rollout

- Confirmed latest GitHub `main` state, active 4 approved scene-art mappings, and native D315/D316 [SUCCESS](https://github.com/zampolit73/Misdeal/actions/runs/39662338488).
- Authored `docs/D334_NEW_CHAT_HANDOFF.md`, indexed and synchronized Project State, Roadmap, Decisions, Visual Asset Registry and HANDOFF. Documentation only; **no art or gameplay code change**.
- Clarified that a purportedly shown `bone_ritual` option sheet was not verified; in new chat render and visibly show 3 fresh options before seeking approval. User's last request is to switch chats with zero context loss.

## 2026-10-21 — D333: User-approved Bone Patrol watchtower art live and native verified

- Published `bone_patrol_d333_approved_tower.webp` 448×274 from accepted last version of lookout-tower composition #3 and mapped `bone_patrol` card ID; previous fallback kept. GitHub Actions D333 import [success](https://github.com/zampolit73/Misdeal/actions/runs/39662185041).
- Extended D315 card-art integrity checks to third selected illustration; [D315/D316 native CI successful](https://github.com/zampolit73/Misdeal/actions/runs/39662338488).
- Runtime image uses lower-resolution signed Canva preview upscaled; preserve original high-quality approved PNG for future replacement; no gameplay changes.
- Showed 3 Bone Ritual art concepts (Invocation/Sacrifice/Circle); selection pending, no runtime `bone_ritual` art changed.

## 2026-10-21 — D332 native regression green

- [D315/D316 Godot smoke success](https://github.com/zampolit73/Misdeal/actions/runs/39658979922) after the D332 fix for runtime Reward `Portrait.stretch_mode` reversion. Previous BloodCoin failure no longer reproduces.
- No live DS3 frame/layout/text/art mechanics changes. Card art D331 stays published for Bone Crush/Blood Ledger.

## 2026-10-21 — D332: Correct runtime Reward portrait cropping

- Real Godot CI `BloodCoin` false-color/crop regression traced to unconditional `TextureRect.STRETCH_KEEP_ASPECT_COVERED` in reward card texture refresh paths.
- Both normal loot and hero upgrade update functions now preserve DS3 CENTERED mode after new textures; fallback DS2 flow unchanged. Source commit `08085a8`.
- D315 smoke asserts this contract; [run 39658979922](https://github.com/zampolit73/Misdeal/actions/runs/39658979922) initially pending. No DS3 design or gameplay modification.
## 2026-10-21 — D331 verification/cleanup

- Real two card assets uploaded and bound; temporary signed-CDN import workflow removed after successful export.
- D315 engine QA reached old Reward crop failure on BloodCoin (D322), matching failure from before D331: new image files and catalog mapping were not the blocker. Full native QA remains red.
- 448×274 engine images are derived from authorized Canva ~200px previews; full-resolution original authored crops remain available in current conversation and should supersede when possible.

## 2026-10-21 — D331: Publish two approved scene-specific card WebPs in main

- Actually committed chosen `bone_crush` ("Прорыв ворот" variant 2) and `blood_ledger` (final skeletal scribe) images as 448×274 WebPs to `assets/pixel/card_unification_v1/run/`; `CardUnificationV1.RUN_CARDS` picks these for real game and QA gallery instead of old atlas. Successful binary [import workflow](https://github.com/zampolit73/Misdeal/actions/runs/39657041960) created `cb03e65`.
- Image-source caveat: from Canva resized thumbnail previews, NOT original full-res approved master pixels. The authored 448×274 WebPs remain available in conversation for later lossless asset replacement. No unrelated DS3/encounter modification. D315 smoke now verifies exact mapping and expected dimensions; native Godot F6 review pending.

## 2026-10-21 — D330: Log two confirmed individual card-art choices for direct integration

- User approved the middle “Прорыв ворот” rendered Bone Crush composition; exact triptych file ID and game-sized crop recorded in project handoff/registry.
- Preserved the earlier selected final skeleton-scribe Blood Ledger image in the same art handoff, with exact file ID and game-ratio crop.
- No runtime art/code modification in this doc-only commit: approved WebPs were prepared locally but not transferred to GitHub due to binary transport gap. Remaining to ship via `CardUnificationV1.RUN_CARDS`; don't claim playable completion prematurely.

## 2026-10-21 — D328: Card DS3 visual baseline approved by user

- User explicitly accepted D327 layout («утверждаю»). Freeze current full-frame, true-color, no-inner-outline, optically centered Card DS3 visual design as approved baseline.
- This is a design approval, not a native CI result or 55-card individual-art completion. Keep progressing through separately approved image batches, preserving current UI mechanics and source assets.
- Synced project state, roadmap, visual design system, decision log and next-chat handoff; no gameplay/code change in this documentation commit.

## 2026-10-21 — D327: Real painted-frame optical centering and actual top tab

- User's enlarged real Godot F6 screenshot revealed a prior false assumption: `Button` math x136 center differs from physical asymmetrical `front_frame.webp` art center, so descriptions/title/CTA remained visibly left of printed art after D326.
- Shared + gallery copies now use x147; actual black category tab x150 instead of category drawn outside at x174. True Fate Roman numeral kept next to tab, no overlap; Reward x158 and inspected/Fate title art axes adjusted without changing functionality.
- Updated smoke assertions on 55 actual gallery text positions, upper tab, numeral and 3 Reward cards. Code commits `90aee64`, `094c15b`; actual new Godot screenshot/native CI status pending. Originals/card IDs/art palette preserved.

## 2026-10-21 — D326: Keep gallery descriptions fully centered after parenting

- Fixed DS3 full-gallery `Description` labels that retained an obsolete/global rect during reparenting: now reparent without old global transform, anchor each body to its full clipped centered CardTextClip and reapply horizontal/vertical centering.
- Normalize live Table description anchors before authored x43 centered placement. Preserve two-line previews and unchanged complete lore in reader.
- Native D315 smoke now asserts ALL 55 actual description text-box centers relative to the card, parent, anchors and dimensions, rather than only settings. Committed `895fc731`; native F6 acceptance pending.

## 2026-10-21 — D325: Align DS3 card copy on a consistent centerline

- Fixed mismatch between shared Table label boxes and F6 gallery overrides: title, short copy and action hint now share exact card x136 centerline with explicit horizontal/vertical centered typesetting.
- Kept category within upper-right tab; Reward live role/heading/effect/description forced centered x146; Fate title centered.
- Extended native D315 smoke on 55 gallery entries and all three real Reward cards; follow-up `e906827` fixed the actual node names so no checks silently skip.
- Art, shaders, single original frame, card data and mechanics preserved. User Godot F6 screenshot/CI not yet confirmed.

## 2026-10-21 — D324: Fix visibly crooked inner frames around DS3 card artwork

- Reviewed actual user F6 screenshot of reward/upgrade cards after D323; decorative external frame now complete but separate gold 1px art-well outlines float crookedly around aspect-fitted scene.
- Shared card skin `_new_art_well` now draws borderless flat `FACE_STONE` matte, retaining original one physical Gothic frame and unmodified full-source illustration. Affects gallery, Table, Reward, reader and Fate surfaces; no gameplay edits.
- D315/D316 native smokes now assert zero inner panel border on actual gallery, Reward, RMB inspector and Fate slot. Source code commit `8f07dad`. Runtime Godot F6 and CI post-fix not independently confirmed.

## 2026-10-21 — D323: Correct clipped right/bottom DS3 card borders

- Real user Godot F6 screenshot confirms missing right/bottom portions of the frame after D322: NOT approved. Fixed `CardDS3Skin._new_art` order so Godot ignores original frame 375×509 minimum before sizing to physical 272×338, preventing parent clipping.
- Applied same minimum-size correction to `_fit_art_in_well` for existing already textured Art, preserving D321 colors and D322 inset without cropping.
- Added explicit native size assertions to D315 55-card gallery/Reward and D316 Fate/held/discard smoke tests. Source commit `fcf5a099`; native post-fix screenshot remains pending. Existing gameplay untouched.

## 2026-10-21 — D322: Physically mount full scene illustrations inside DS3 card wells

- User requested implementation in GitHub, not another generated UI preview. Real `CardDS3Skin` now inserts a restrained dark/bronze art well behind the existing direct-child illustration; retains one D320 front frame.
- `STRETCH_KEEP_ASPECT_CENTERED` preserves each authored scene's full composition instead of cropped/overdrawn COVERED, applied to Table, Reward, real RMB inspector, Fate Spread and the 55-image QA gallery.
- Native D315/D316 regression smoke expanded for well/Art layering, full-aspect fit and separation from live title. Card IDs, mechanics, real description text, D319 selected Black Altar and D321 true colors preserved. Actual post-fix Godot screenshot/CI not yet confirmed.

## 2026-10-21 — D321: Restore approved original card colors in actual Godot shader

- Diagnosed severe darkness visible in real post-D320 F6 gallery as **double multiplication of the illustration texture** in shared CanvasItem fragment shader.
- Captured original vertex tint before Godot applies texture internally, then emitted a single source-grade multiplication, retaining alpha and live hover/selection tint.
- Reduced shared sepia/bronze grade from 30% to 10%, warmed without crushing cold moonlight or red altar light; preserved all 55 original texture mappings and D319 approved third Black Altar artwork.
- Added native D315 regression checks; original D320 single-front-frame structure, real two-offer Table, rewards, Fate I–XIII and combat code unchanged. Native F6/CI confirmation still pending.

## 2026-10-21 — D320: Fix double ornamental frame on actual DS3 cards

- Inspected original GitHub front and ink WebPs; found duplicate full gilded card-back border beneath the front face. Replaced face stone with non-ornamental deep background ColorRect throughout Table/gallery, Reward, full-card inspection, Fate Spread and held/discard, retaining exactly one painted front `DS3CardFrame`.
- Preserved the source framed back WebPs, original artwork, text, 12+XIII, all live buttons and game logic. No regenerated concept images or art replacements.
- Expanded D315/D316 native smoke coverage to guard against framed back under front across all major surfaces. Actual Godot 4.7.x F6/CI confirmation pending.

## 2026-10-21 — D319: Accept and integrate Black Altar third scene; fix actual gallery screenshot defects

- Reviewed user's two actual F6 D318 screenshots. Confirmed major text containment/reader improvement; diagnosed tooltip hovering across cards and barely-visible black-on-black titles.
- Commit `4831b93`: clear F6 gallery mouseover tooltip, brighten DS3 physical card title to ivory with fine outline and prevent tooltip regression in native smoke.
- User selected third/bottom Black Altar painting. Commit `a5cb905`: exact selected vignette crop 448×274 registered as a unique `black_altar` card image via `card_unification_v1.gd` (asset checksum validated in native smoke). Source event backdrop/legacy art preserved; no gameplay code changed.
- Record active art/regression progress in `docs/D319_BLACK_ALTAR_OPTION3.md` and handoff. Native D319 screenshots/CI still pending; only 1/55 individually repainted card images so far.

## 2026-10-21 — D318: Real DS3 card gallery readability and shared artwork contrast repair

- Reproduced D317 issues from the actual saved native Godot screenshot; source fixed in main `d6b2eda`: compact strictly bounded gallery preview, title/type dedicated niches, no fake I–XII enumeration, original unmodified full lore in a large scrollable click-to-read modal, ESC/close, independent illustration.
- Replaced black-crushing D315 shared color grade with warmer readable midtone lifting, maintaining approved crimson/aged bronze on actual Table/Reward/Spread/inspector/gallery art (new F6 visual validation required).
- Extended D315 F6 gallery native smoke with geometry, all 55 card slots, lore exactness, reader close, native Reward regression.
- Follow-up `61ca941` corrects actual live Table DS3 category into top-right tab and limits its two-line preview without changing original RunCardData, RMB lore, real I–XIII or any run interaction. DS2 text fallback retains old max length.
- Updated project handoff, roadmap, DS3 design rules and decision record. Native CI/screenshots not yet verified; **55 bespoke illustration repaints are still pending**, to follow D168 options-first after real screenshot.

## 2026-10-21 — D317: Save first real Card DS3 gallery screenshot and defect handoff

- Archived the user's real 1630×886 Godot full-gallery screenshot in `docs/qa/D317_card_ds3_gallery_user_screenshot.webp`, with 40 loaded cards, 15 additional images and 0 lookup gaps.
- Inspected real D315 gallery source and observed blockers: full multiline card text overflows adjacent cards, title/type panel conflicts, misleading modulo-12 Roman numerals, over-dark artwork and a tiny full-copy viewer.
- Added comprehensive new-chat handoff `docs/D317_CARD_DS3_GALLERY_SCREENSHOT_HANDOFF.md` and updated PROJECT_STATE, ROADMAP, DECISIONS and HANDOFF. Approved richer DS3 palette remains unchanged; actual gallery not accepted. No art, GDScript, mechanics or UI fixes made yet; next chat starts with the screenshot-grounded UI repair.

## 2026-10-21 — D316: Resume real GitHub Card DS3 implementation in small verified stages

- Compared current GitHub HEAD with promised work: existing D315 was **already substantial**, including 3 DS3 assets, red/black shader, original Table + Spread (12/XIII/held/discard) + Reward integrations, full 40-card + upgrade/reward F6 gallery and native regression definition. Did not duplicate this code.
- Locked user's first bright crimson/aged-bronze/parchment reference as Card DS3 in DESIGN_SYSTEM / DECISIONS; recorded exact implementation-vs-artwork audit in `docs/D315_CARD_DS3_AUDIT.md`, created `checkpoint/card-ds3-d315-audited-2026-10-21`.
- Added true DS3 physical card inside original right-click full-description/inspection reader; real card art/title/long scrolling copy and close remain interactive.
- Added real Spread and inspector native smoke `scripts/dev/d316_card_surfaces_smoke.gd` with D315 CI coverage. **No confirmed native Godot PASS or post-change user screenshot** yet.
- Shared style/shader is not the same as hand-authoring 55 new scene illustrations. Further illustration-specific redrawing will be guided by actual F6 visual QA; gameplay unaffected.

## 2026-10-21 — D314: Battle DS3 artistically accepted and release checkpoint preserved

- User explicitly approved ending the Battle DS3 visual iterations after D313. Accepted combined D303 carved command/Fight, D311 third Wizard portrait and D312–D313 corrected native labeling. Do not require a further Battle screenshot for aesthetic signoff.
- Created permanent checkpoint branch `checkpoint/battle-ds3-approved-2026-10-21` at D313 code commit `25878ca7023874e9ca96f412470241cc5496b775` alongside existing DS2 restore point.
- Reviewed current working Reward DS2 code; recommended new Reward DS3 art-first exploration (2–3 selectable concepts). No Reward code, event rules, combat balance or Fate Spread artwork changed. Native automated D313 certification remains separately unconfirmed.
- Recorded complete next-screen scope/guardrails in `docs/D314_NEXT_VISUAL_PASS.md`.

## 2026-10-21 — D313: Fix real Godot Wizard gold label crossing ornate lower border

- Reviewed user-provided actual D312 prep and live-combat screenshots; discovered `+15 золота` visually crosses the bottom bronze ornament, while failure text is correctly visible.
- Adjusted the genuine Battle Wizard rule to (56,44) 173×34, its gold reward to (65,80) 165×16 with slightly clearer muted ochre. Inset rectangles do not overlap and stay above lower finial. No changes to gameplay, reward payout, Battle art, actors or 3–5 tactics.
- Updated both native Battle and F6 smoke tests to assert new coordinates, non-overlap and reward bottom bound. Native engine/CI and post-fix user visual approval still pending.

## 2026-10-21 — D312 Wizard panel readability and reward hierarchy

- User approved the direction of a final restrained polish on selected third Wizard plaque in two concept images. Applied the adjustments to **real Godot UI code**, not just the illustrations.
- Recentered live title/condition text inside their corresponding D311 artistic wells, gave glyphs a minimal dark edge, and moved the preparation panel upward 4px.
- Added a quiet dynamic `D312WizardReward` label that extracts `+15 золота` from canonical objective text; hides on success/failure and does not alter reward calculation or side-objective rules.
- Expanded D306 genuine Battle and D308 direct F6 smoke checks. Native runtime D312 and final Battle visual approval remain pending. Source images, animations, AI, tactics, DS2 checkpoint unaffected.

## 2026-10-21 — D311: integrate user's selected third Wizard art module

- User selected third illustrated Battle Wizard plaque concept with hooded character medallion and restrained bronze/wood, replacing previous D307 ornate silhouette art direction.
- Extracted original selected painted panel from concept, removed all baked rule/heading lettering, published isolated RGBA source and game WebP binaries in `assets/pixel/ui/battle_ds3_d311/`.
- Reused fixed-size D309 drawing contract, draw at 258×138 instead of imported WebP 286×153; relocated live header/body labels in independent material wells for original dynamic rule/bonus/failure data.
- Updated real Battle and D308 F6 regression checks and CI asset triggers; original arena, animated units, stats, 3–5 tactics, actual Wizard payouts and DS2 restore point untouched.
- Awaiting native Godot smoke result and visual screenshots for final runtime approval.

## 2026-10-21 — D310 real Godot screenshots confirm D309 layout repair

- Inspected fresh user preparation and live-combat screenshots of `Могильный звон`: approved Battle modules unchanged, Wizard decorative panel now remains compact in both locations, no longer covers combatants or overflows screen.
- Live condition failure displays the correct text and state color within the artwork's header/body wells.
- Visual bug verified fixed from screenshots; no additional gameplay or asset change. Wizard/full Battle final artistic acceptance still pending, automated CI result not independently confirmed.

## 2026-10-21 — D309 Wizard art display-size regression fixed

- Diagnosed two real user Godot screenshots: oversized D307 Wizard decoration hid action HUD in prep and much of the battlefield during combat, with text left outside artwork.
- Switched the illustration from auto-sized TextureRect to explicit fixed 252×158 `draw_texture_rect` on a mouse-ignoring Control. Source WebP, original rule text, two live labels, reward and combat unchanged.
- Extended both native Battle and isolated F6 preview smoke scripts to assert source art, fixed coordinates, viewport bounds and combat safety. Godot CI/local visual recheck still pending.

## 2026-10-20 — D308 standalone Godot Wizard UI inspection scene

- Added `scenes/dev/d308_wizard_panel_preview.tscn` for F6 direct visual QA of D307 painted Wizard challenge against the real Graveyard arena artwork.
- Reuses production Gothic panel renderer, canonical source text, 3 encounter rule samples and prep/combat positions; preview controls simulate active/success/fail with no game-state changes.
- Added `Открыть настоящий бой` button to run genuine Grave Bell Battle in isolated test process, plus native headless preview smoke in the D291 Battle workflow.
- No change to default launch scene, HP/AI/rewards or approved D303 Battle art. CI/native screenshot and explicit art approval remain pending; see `docs/D308_WIZARD_PANEL_TEST_SCENE.md`.

## 2026-10-20 — D307 Gothic Wizard condition candidate implemented

- Published a new text-free illustrated `wizard_condition_game.webp` and full-resolution `wizard_condition_source.webp` directly as binary Git objects.
- Integrated the painted frame with separate dynamic title/body labels on the actual optional Battle Wizard challenge; retired overlapping legacy chrome only when art imports. Original ObjectiveLabel remains the sole canonical gameplay text source.
- Synced text after legitimate initial, failure, countdown and bellkeeper-first updates; no change to side wager reward, battle AI, tactical controls or arena.
- Extended real Grave Bell native regression and GitHub Actions asset triggers. User-local Godot rendering and explicit artistic approval remain pending.

## 2026-10-20 — D306: Real Grave Bell Wizard condition visibility and combat location

- Reviewed user screenshots of actual D303 illustrated Battle UI, with four tactics, Grave Bellkeeper, optional wizard challenge and combat.
- Fixed nested Wizard objective label obscured by the later-appended engraved overlay: moved live label above ornaments, increased contrast and added readable aged-bronze panel styling.
- Made the same optional objective panel move from left lower prep margin to unobstructed upper-left during real Fight, without changing rule text, +15-gold reward, enemy death order or HUD input.
- Added actual `grave_bell` native Godot smoke plus GitHub Actions gate for the objective's visibility/contrast, state and real Fight transition. CI/native D306 PASS and user in-game visual signoff remain pending.

## 2026-10-20 — D305: Verify direct GitHub publication of approved Battle DS3 modules

- Confirmed `main` commit `a933bc36` already published all five approved game-ready WebP skins and five full-size source WebPs plus manifest.
- Independently uploaded raw Git blobs from the approved local binary archive; their SHA1 identities matched existing GitHub artwork byte-for-byte. Duplicate commit unnecessary; user does not need to install or publish anything manually.
- Updated documentation to remove stale 'binary pending' action item. Actual Godot 4.7 native/visual approval remains pending; no combat or UI logic modified in this verification pass.

## 2026-10-20 — D304 approved modular Battle skin integration scaffold

- Added optional true full-panel user-approved D303 source-derived art skins under real Battle Controls, with no fake labels/buttons and safe D301 fallback when the binary source pack has not yet been installed.
- Kept the actual three-to-five tactical orders, click/selected and hover description logic, red Fight and targeting callbacks, original arenas/units/HP and RunState unchanged.
- Added a one-time Windows PowerShell installer/publisher with strict SHA256 checks and isolated path staging; user downloads genuine art ZIP and the script commits the source-derived images to GitHub, not general modified Godot files.
- Extended real Battle native smoke and Godot CI triggers to accommodate approved art/fallback. **Binary publication, native Godot evidence and in-game visual signoff remain pending**.

## 2026-10-20 — D303: user art approval of five modular Gothic Battle UI source images

- User signed off five independent artistically rich, transparent, empty Battle UI skins: command cabinet, Fight cabinet, tactic idle, tactic selected, crimson Fight action.
- Archived source PNGs in conversation-generated ZIP with native dimensions and SHA256 manifest; recorded scope, implementation rules and status in `docs/D303_BATTLE_MODULES_APPROVED.md`, PROJECT_STATE, ROADMAP, DECISIONS and HANDOFF.
- No runtime code or PNG binaries committed in this documentation pass, and no Godot visual/technical approval asserted. Next integration must preserve actual controls, dynamic 3–5 tactical states, existing arenas, user screenshot gate and DS2 rollback.

## 2026-10-20 — D301 Live Battle: in-panel order descriptions instead of overlapping native tooltips

- User's actual D300 `КОСТЯНОЙ ДОЗОР` screenshot confirms painted DS3 Battle ornaments render, but the default Godot tooltip covers the lower tactical description and repeats the same data.
- Removed five redundant native tactic `tooltip_text` values; added mouse-hover preview of unselected tactics in the existing actual `OrderDescription` Label and restoration of active tactic upon mouse exit. No fake UI, new panels or combat behavior.
- Expanded production Battle native smoke to test hover preview and selection isolation. Official Godot run / local screenshot still pending; checkpoint DS2 and prior art packs unchanged.

## 2026-10-20 — D300 Actual-Godot-screen material quality recovery

- Two actual 1280×720 screenshots prove D299 painted ornaments load, but embroidered banner/candles are fuzzy due to source thumbnail downsampling and aggressive WebP loss.
- Rebuilt the four original-reference material fragments with higher-quality encoding, less edge blur and native source dimensions: banner 111×189, medallion 88×113, candles 57×172, wax ribbon 84×178. Added isolated 23,510-byte packed WebP at `assets/pixel/ui/battle_ds3_d300/reference_fragments_hq.webp.pack.b64`; original D299 source preserved.
- Updated only source decoder constants, validated GitHub pack FNV and extended real-Battle native smoke for larger source sizes and transparency. Real live tactical UI, arena, units and all combat mechanics unaffected.
- Godot 4.7.2 CI/native render and art approval still pending. Pre-DS3 rollback unchanged.

## 2026-10-20 — D299 Reference-source Battle DS3 art integration

- User approved proceeding with the more artistic second Gothic `Могильный перекрёсток` concept instead of D298's simplified vector treatment.
- Extracted four transparent, scaled WebP decorations **from the approved image pixels**, not hand-rebuilt icon silhouettes: aged crimson banner, compass medallion, tall candles and worn wax ribbon.
- Added packed base64 material resource and GDScript caching decoder; live Battle swaps overlapping D298 SVG art for these genuine painted fragments, retaining empty command/Fight plates, dynamic labels, actual 3–5 tactics and all existing gameplay/arena.
- Extended real-Battle native smoke for texture decode, eight layers and no doubled emblem/click interception. Source pack length and checksum independently verified; **native CI and user screenshot remain pending**. [Details](docs/D299_REFERENCE_ART_IMPLEMENTATION.md).

## 2026-10-20 — D298 Reference-level materials for selected light Gothic Battle DS3

- User requested actual game Battle to approach the richer **second illustrated reference** (D297 was visually functional but still flat).
- Authored six editable **text-free SVG artwork components**, each independent of real controls and gameplay, in `assets/pixel/ui/battle_ds3_d298/`: hanging torn-red banner, bronze progress compass seal, small metal floral finial, tattered crimson Fight fabric, engraved wood/metal empty tactical tray and lacquer/gold empty Fight tray.
- Integrated seven mouse-ignoring transparent decorative TextureRects in `battle_ds3_pass.gd`; repositioned dynamic header/party copy to clear banner, retired doubled progress emblem, preserved selected tactics as living Godot Buttons, aligned Fight decor with original callback.
- Fixed deployment-hint collision with actor feet by moving/wrapping into unused lower-left margin, conditionally raising it to open sky when the real wizard secondary objective occupies that margin.
- Expanded actual Battle native smoke for SVG decode/scene geometry/text clearance and noninteractive art. CI and true native screenshot aesthetic comparison **not yet confirmed**. Arena art, hero/enemy sprite files, balance, AI, RunState and DS2 backup are unchanged.

## 2026-10-20 — D297 Battle DS3: readable run modifiers and genuine order heraldry

- Reviewed user's actual D296 `ЗАСАДА НА КЛАДБИЩЕ` screenshot: material/typography now visible and battlefield unobstructed; right solo status copy still too dense.
- Expanded only the right progress plaque to 299×78, set status to 12px with two compact rows, left all original modifier text in a real hover tooltip and counted extra condition rows instead of overflowing onto the arena. `RunState`, solo/duo/trio tuning, Wizard modifiers and combat untouched.
- Added small individually authored vector insignia to existing Battle tactical Buttons when enough width exists (no fake baked UI/click overlays).
- Extended native real-scene smoke contract for actual solo modifiers, full tooltip, plaque geometry and input-safe engravings. Official native Godot result and user artistic QA are still open; DS2 rollback unchanged.

## 2026-10-20 — D296 Battle DS3: engraved material and serif UI after native screenshot

- User shared actual D295 `Костяной рой` preparation. Geometry/units/tactics readable, but top ledger and lower command bar still flat and typography plain, so screenshot is **not** artistic approval.
- Added native vector relief/patina/cut-corner chrome `battle_engraved_frame.gd`, attached as mouse-ignoring child Controls to real Battle plates and taktics; made upper inset plates translucent instead of drawing doubled black rectangles.
- Applied OS serif font with Cyrillic fallbacks only to key battle headings/order buttons and Fight, kept gameplay text/controls data-backed; retained D287 decorative image fragments and increased the single selected token mark.
- Extended real Battle native regression for etched pieces/fonts/mouse behavior. Official CI and native user screenshot still pending. Original combat, arena, motion, tactics, rewards and DS2 restore unaffected.

## 2026-10-20 — D295 Approved second DS3 Battle design direction, native Godot cosmetic layout

- After screenshot critique of D293, presented two Battle DS3 art concepts. User chose the second minimal Gothic overlay, *not* the ornate first one.
- Rebuilt runtime placement of real encounter/progress labels, centered the command tray, kept live 3–5 tactical Buttons aligned, separated the actual Fight/target-preview island, and moved optional side-objective left to avoid overlapping right action.
- Refined bronze/wood/steel overlays and aligned inset/description without baking mockup text or characters; reused accepted D287 small filigree and heraldic fragments.
- Added native scene smoke geometry assertions; official Godot 4.7.2 result and user-local visual approval are pending. No combat, arena, actor/HP, AI or RunState changes.

## 2026-10-20 — D293 Full material direction for DS3 Battle HUD

- User rejected the flat-box D292 Battle HUD despite technical PASS. Rebuilt the actual Godot cosmetic layer with blackened wood/bronze tactical command holder, inlaid scroll/hardware, a lacquered crimson Fight action decorated with the approved ruby crest, and physically engraved upper encounter/card ledgers.
- Reused previously approved D287 art fragments as **real PNG-free transparent WebP layers**; no AI-generated screen with fake health bars/buttons/text. Kept old scene geometry, actors/HP, 3–5 genuine tactics, handlers/RunState and all approved arenas intact.
- Expanded native Battle smoke for painted art decode and real Hunt→Formation selection. D293 official Godot 4.7.2 CI **PASS** ([run 39399922113](https://github.com/zampolit73/Misdeal/actions/runs/39399922113)); **new user visual signoff pending**, and no D292 art approval assumed.


## 2026-10-20 — D292 screenshot-led DS3 Battle readability

- Real Battle prep screenshot confirmed painted stone floor and correct actor/HP placement, but bottom UI too slab-like and selected tactic nearly indistinguishable.
- Changed scoped `battle_ds3_pass.gd` to give **only** selected tactic a warmer fill plus live state-synced bottom inlay; make tactical/fight lower panels lighter with single upper hairlines, increase placement hint contrast. No gameplay, arena or layout changes.
- Native Godot 4.7.2 D292 real Battle and Hunt→Formation visual-state QA **PASS** ([run 39398661063](https://github.com/zampolit73/Misdeal/actions/runs/39398661063)). Fresh user screenshot pending.


## 2026-10-20 — D291 DS3 Battle HUD pilot

- D290 real Table screenshot confirmed the single live deck numeral and slimmer header chrome; no changes to cards or Table needed.
- Added opt-in subdued DS3 battle chrome on existing six HUD panels and 5 actual tactical buttons, with dynamic selected states; styled Fight/Continue/Restart/Target Preview without changing active mechanics, UI geometry or arena art.
- Added actual Godot Battle-native smoke. After correcting headless test registration order and GDScript typing, official **Godot 4.7.2 PASS** ([run 39397929958](https://github.com/zampolit73/Misdeal/actions/runs/39397929958)). Battle visual screenshot and route QA not yet signed off.
- Preserved original DS2 restore point and unchanged other game screens.


## 2026-10-20 — D290 first native DS3 Table screenshot polish

- Corrected doubled baked/live left deck count ("КОЛОДА 22" plus true 37) using localized number matte while preserving all data-backed counts and art.
- Removed extra DS2 corner brackets from DS3-styled Table top bars only; now thinner single-bronze edges.
- Expanded D289 Table Godot QA to assert these fixes and unchanged two-card callbacks; official Godot 4.7.2 PASS: https://github.com/zampolit73/Misdeal/actions/runs/39396611590 .
- Await actual user D290 screenshot to approve visuals. Full DS2 backup branch still untouched.


## 2026-10-20 — D289 First DS3 real Table pilot

- Added per-screen `table_ds3_pass.gd` for thinner aged-bronze DS3 plates, warm live text and subtle control chrome on the actual HUD, Wizard, Squad, Fate Spread and Wager; original two painted encounter card Buttons untouched.
- Applied the DS3 pass after the old DS2 rollout to avoid altering any other screen. No RunState, selection, card art, balance, battle or rewards changes.
- Added official native D289 full two-card Table smoke for real game-state, card art, actions and Wager. PASS ([run 39393893259](https://github.com/zampolit73/Misdeal/actions/runs/39393893259)); D274 card-art smoke still PASS. User visual screenshot review pending.
- Pre-DS3 full-project rollback branch remains fixed at `4cbd206`.


## 2026-10-20 — D288 DS2 checkpoint and opt-in DS3 foundation

- Created and verified `checkpoint/ds2-pre-ds3-2026-10-20` at exact pre-migration Git HEAD `4cbd206` (full tracked project rollback; branch is isolated from future `main`).
- Added opt-in DS3 color/material/component kit, preserving accepted DS2 runtime screens and D287 dossier visuals.
- Migrated only the live D287 dossier panel factory to an identical DS3 shared style helper, and extended its official Godot native test — **PASS** ([run 39392900520](https://github.com/zampolit73/Misdeal/actions/runs/39392900520)). No changes to gameplay/card counts/arena/combat/RunState.
- Documented safe rollback instructions and staggered one-screen-at-a-time DS3 acceptance with native screenshots.


- User approved the richer last painting of the third dossier layout. Extracted only its transparent ruby crest, gold filigree corners and near-black Gothic bas-relief into three compact source-derived WebP decorative assets; no baked-screen data.
- Layered decor into actual Godot `squad_dossier_v3.gd` panels and portrait, gave upgrade badges bronze diamonds with real completion colors, made relic slots bronze medallions with real occupancy status and kept original V7 hero paintings and D286 full-height cropping.
- Upgraded native smoke to verify the art fragments decode and real 0/3 state remains unchanged. Native base integration and extended D287 visual-component smoke PASS ([run 39390304778](https://github.com/zampolit73/Misdeal/actions/runs/39390304778)); actual user screenshot still pending. No gameplay or RunState changes.

## 2026-10-20 — D283 Approved Bone Ritual + Firing Square production art

## 2026-10-20 — D286 Squad dossier real-screenshot polish

- Fixed tall portrait black bands by switching only the live `Portrait` TextureRect to aspect COVERED and panel clipping; original V7 Knight/Ranger/Mage paintings retained, with no baked UI.
- Improved readable stat size and vertical spacing, upgraded right-side progression/relic visual landmarks and split the long footer modifier onto its own line. True RunState counts and effects unchanged.
- Strengthened native smoke to assert fill mode/stat legibility and right-side marker layout. Godot 4.7.2 CI PASS; real user screenshot recheck pending.


## D285 — Squad Dossier third visual option integrated (2026-10-20)

User selected **third** of three rendered dossier design concepts (hybrid: left portrait roster, tall central hero card, clear middle stats and role text, right progression/relic panels, segmented party footer). Implementation is in `scripts/ui/squad_dossier_v3.gd`, wired to actual `scenes/table/squad_status.tscn` and `scripts/table/squad_status.gd`; real RunState data/role switching, upgrade counts, relics, solo modifiers and close preserved. Native Godot 4.7.2 regression initially failed due inferred `selected` boolean type; fixed in commit `2b9e2c5`. Native D285 Actions **PASS**: https://github.com/zampolit73/Misdeal/actions/runs/39386342756. **User screenshot visual validation still OPEN**: ask for one 1280×720 screenshot of real dossier and address only observed differences. This is not a pixel-perfect reproduction claim. No combat/balance changes.


- Integrated two explicitly selected **1280×720** painted arena illustrations from original 1672×941 PNGs, without new image generation or gameplay code changes.
- `bone_ritual` now uses sparse-bone moonlit ruined chapel; `firing_square` uses approved first execution-yard variant. Preserved old v1 files for rollback; other 14 arenas unaffected.
- Official D283 native Godot 4.7.2 texture smoke PASS ([run 39374993074](https://github.com/zampolit73/Misdeal/actions/runs/39374993074)); user subsequently confirmed **«Все ок)»**. D283 art pass accepted with no blockers; no separate screenshot or full-route QA claimed.

## 2026-10-20 — D282 Final ClassSelect UI chrome polish

- Kept approved full-HD clean cursed-table background and original three D278-framed hero portraits.
- Replaced heavy dark title plate with translucent aged-bronze trim; lifted Wizard commentary into a subtle standalone caption above the hands.
- Added proper persistent gold overlay for selected protagonist (independent softer hover), strengthened crimson/brass confirmation and improved bottom companion tip readability.
- Extended native Godot 4.7.2 tests for title/caption/footer/over-frame hover & selected rims. CI PASS; user visual re-check still pending. Gameplay selection and solo-confirmation remain unchanged.

## 2026-10-20 — D280 pure ritual table class selection

## 2026-10-20 — D281 Full-HD ClassSelect correction

- User screenshot REJECTED 640×360 (11KB) background stretched to 1280×720; returned to an actual 1280×720 high-quality clean wizard/table painting derived directly from the original 1672×941 art.
- Removed obsolete D280 base64 transport and loader; native WebP lives in `assets/pixel/class_select/d281_clean_table_hd.webp`.
- Keyed dark rectangular source backing out of the existing logo for ClassSelect only.
- All card portraits, D278 frames, HP/damage hover and solo confirm unchanged. Godot 4.7.2 CI PASS; native artistic screenshot acceptance pending.


- Integrated independent clean wizard/candles/rune-circle artwork under the three ClassSelect protagonist cards, without painted HUD, cards, Hold or counters.
- Removed temporary D279R screenshot concealment shader/plaques, fake FateTitle and duplicate emblem; inserted real logo and lighter header, moved Wizard reaction above cards.
- Retained all D278 character art and frames, real source data HP/damage hover, two-step selection and solo-hero routing.
- Official Godot 4.7.2 integrity plus actual scene and solo-confirm native tests PASS. User visual approval at 1280×720 still open.

## 2026-10-19 — D279R screenshot-proven baked background defect

- Reviewed user native Godot ClassSelect screenshots: the original D279 background is a **fully baked table screenshot** and visibly duplicates gameplay cards, HUD, Hold and Fate Spread controls under the three new hero cards. D279 visual quality rejected despite native functional success.
- Added scoped bronze header/counter/spread concealment and textured brocade behind the playable class cards, moving the title/Wizard line off the face; preserved active ClassSelect layout/stats/confirmation and original production Table.
- Added automatic Godot node tests for occlusion masks, but final native 1280×720 artistic screenshot acceptance remains open. A genuine clean tabletop source is still preferable long term.

## 2026-10-19 — D279 class-select tabletop UI

- Replaced the large black hero-selection modal with the approved full Variant C cursed table and three live D278 parchment/bronze character cards. Existing authored v7 class portraits are loaded independently, not baked into screenshot UI.
- Added source-backed HP/damage reveal on hover/selection, subtle card lift/choice dim, class-specific Wizard commentary and separate crimson confirmation button; arrow keys cycle and Enter confirms.
- Kept `RunState.choose_protagonist` exclusive to final confirmation, all combat numbers, starting solo-party contract, and original Table route. Added official native Godot import and interaction smoke; user art approval pending.

## 2026-10-19 — D278 native screenshot review

## 2026-10-19 — Act I «Обещанный рассвет» story bible (documentation only)

- Approved new story facts: Chancellor forged the protagonist's truthful no-relief dispatch; castle Commandant learned of the forgery yet maintained the lie; Commandant is the future Bone Warden XIII.
- Added [docs/ACT1_PROMISED_DAWN_STORY_BIBLE.md](docs/ACT1_PROMISED_DAWN_STORY_BIBLE.md): draft 20-day siege timeline, 12 discoverable letters/records, verified unique hooks for **all 39** existing Act I cards, non-linear clue discovery, a tactile dispatch/seal comparison and conditional XIII dialog + three morally costly possible outcomes.
- No existing game code, card content, visuals, balances, Acts or finale were modified.

## 2026-10-19 — Act I siege mystery direction (design only)

- Recorded user-selected narrative reveal: the historic hero sacrificed a besieged castle to protect the country but sent an honest no-relief order; **someone else forged reassuring letters**. Culprit and motive deliberately left open for investigation.
- Created [docs/ACT1_SIEGE_MYSTERY_DIRECTION.md](docs/ACT1_SIEGE_MYSTERY_DIRECTION.md) covering hooks for all 39 current cards, randomized clue delivery and unresolved story decisions. No runtime, art, card pool or balance changes.

- Reviewed user Godot screenshots for normal two-card deal, hover-raised offer and lore inspection: painted frame is live on both cards; Cyrillic, buttons and art remain legible, no visual blocking failure detected. Formal user approval still open; no gameplay code changed.

## 2026-10-19 — D278 separate painted transparent frame on live cards

- Replaced D277 procedural offer-card ornament display with a cropped artist-rendered, alpha-isolated real worn-bronze transparent image, reused by both actual 272×338 offer cards.
- Stored one 5088-byte 272×338 WebP in four GitHub-safe text fragments, with source SHA256 and Godot cached image loader; preserved all live card text, art, CTA, Hold, RMB lore and original RunState behavior.
- Extended official Godot smoke to verify byte-perfect WebP rebuild, dimensions, transparent center, overlays, mouse-pass-through and original actions. Artistic screenshot check still required.

## 2026-10-19 — D277 dark-fantasy parchment art pass

- Enriched the opt-in two-card parchment shader with uneven pigmented paper, foxing, fibers and singed edges while retaining ink contrast.
- Added restrained engraved bronze corners, borders and small rivets; hover brightens the existing crimson Choose face without changing its hit target.
- Added subtle bronze hardware and frame details to the compact separate RMB lore window. Updated native Godot component regression to cover the new engraving/hover states.
- No changes to core game, Fate Spread, event art, Act1 39/45 or any other UI skin; native screenshot/artistic approval remains open.

## 2026-10-19 — D276 compact lore and engraved offer-card trim

- Reviewed user-supplied native D275 screenshots: hover text no longer obstructs the table and the deliberate RMB lore window works, but the modal had too much unused space.
- Tightened full-text inspection from 760×440 to 720×364 with rebalanced content; removed redundant instruction copy beneath artwork and added restrained dark-fantasy linework.
- Added subtle card inner-frame/illustration-rim/choose-divider accents and improved the bottom RMB hint contrast. All game data, card arts and click/hold routes remain unchanged; new screenshot acceptance pending.

## 2026-10-19 — D275 deliberate card lore inspection

- Removed automatic offer hover tooltips after actual Godot screenshot showed even wrapped hints blocking both cards and embedded Choose controls.
- Added card RMB inspect overlay with original large card art, full lore with scrolling, ESC/close/outside dismiss and a discoverable table hint; LMB Choose and Hold behavior unchanged.
- Expanded D274 native smoke to exercise the new inspection panel. CI and user visual sign-off tracked separately.

## 2026-10-19 — D274R card-tooltip overflow repair

- Corrected screenshot-proven giant unwrapped stock tooltip across two parchment cards, preserving full Russian lore in a 318px wrapped tooltip.
- Darker readable text ink and hold tabs above hovered cards. Official Godot 4.7.2 custom tooltip native component check PASS; real visual acceptance pending.

## 2026-10-19 — D274 Table parchment offer UI

- User-selected hybrid two-card treatment in production Table: 272×338 parchment cards, preserved painted encounter art, ink text, bronze borders/hold tabs, crimson choose area, motion/hover states and complete card text in tooltips.
- Added a Godot 4.7.2 D274 UI import and component smoke workflow. Actual 1280×720 user visual QA remains open; no Fate Spread, RunState, battle, or Act1 39/45 changes.

# Changelog

## 2026-10-19 — D273 Court #39 RELEASED (39/45), native real-deal PASS

- User accepted real D271 painted character-free Court battle artwork. D272 independent 75-frame alpha audit found all approved D267 rich sprites unique and safely padded (minimum **3px** transparent margin; 15 spare cells alpha-clear), with 27 original-source warnings retained as possible visual review points rather than proven sprite corruption. Original D267 PNG→WebP rebuild sha contract PASS.
- **Act1 38→39/45**: connected `resources/cards/court_of_the_mute.tres` encounter path and appended `court_of_the_mute` to normal `RunState.ACT1_CARD_IDS`. Four original enemy actors (Magistrate, Scribe, Bailiffs×2), existing D262 verdict/2 formations/D268 local balance, actual approved D271 1280×720 painted arena and D264 exact floor unchanged.
- Added `scenes/dev/court_of_the_mute_d273_release_route_runner.tscn` testing ordinary Tier1 `RunState.get_offer_cards()` + `choose_card()`, real Battle/Fight, Reward claim, Table resolution. [Godot 4.7.2 native all-green CI](https://github.com/zampolit73/Misdeal/actions/runs/39264156351) also includes 6 real battle setups, 54/54 BattleUnit matches, D271 art identity, B/L/G QA controls; [independent original-rich CI PASS](https://github.com/zampolit73/Misdeal/actions/runs/39264427458).
- Migrated existing historical sprite preview, F6 Battle launcher and native QA contracts to **39/45 released** without changing source artwork/other live encounters. Source-edge art flags preserved for future motion review when evidence warrants. D261 exact second card illustration, D260 #38, D264 floor, DS2/Fate Spread and KARAMBA73 frozen. [D273 release](docs/D273_COURT_CARD39_RELEASE.md) / [handoff](docs/D273_NEW_CHAT_HANDOFF.md).


## D271 — ACTUAL PAINTED COURT IN MAIN; Godot native PASS, artistic user verdict next

The previously rejected D270 SVG has been replaced in real **Court-only** QA Battle by the genuine full-resolution painted D271 WebP b64 (1280×720; SHA256 `1eb45164d9c7418fb9c459d18c0640935452266aeecbb04d1e9d7bd527af8784`). [Godot 4.7.2 full D271 CI PASS](https://github.com/zampolit73/Misdeal/actions/runs/39261648732): source bytes, 1280×720 texture, F6 **B** D265/D271 comparison, **L/G**, six real Battle setups, 54/54 Court BattleUnit simulations and QA-only Fight→Reward→Table. The old "not transferred" D271 notes below are HISTORICAL/SUPERSEDED. Need native visual acceptance from user, then rich D267 ×1 animation review/27 flags, then separate #39 ordinary-deal release. Card #39 still UNRELEASED, 38/45, D261/D264/#38/KARAMBA73 unchanged. [D271 verified report](D271_PAINTED_COURT_NATIVE_PASS.md).


## 2026-10-19 — D271 Court visual art correction (binary art transfer still pending)

- User screenshot demonstrated D270 editable SVG was visibly schematic/placeholder, despite valid Godot native functional tests. Mark D270 **ART REJECTED**, do not release #39 with that picture.
- Prepared a high-detail actor-free new Gothic tribunal background from generated painted art and reframed it into exact 1280×720 with a genuinely uninterrupted lower combat terrace. QA preview and WebP generated as chat artifacts. **Not yet committed or switched in GitHub**, so no runtime artwork replacement or CI claim.
- Next: copy exact painted asset binary-safe to GitHub and wire Court-only, run full native Battle/Balancing/Reward tests, solicit one real Godot visual review. #39 stays unreleased, Act1 **38/45**; D261 card, D264 floor, D267 original sprites and frozen KARAMBA73 unchanged.


## 2026-10-19 — D270 new actor-free tribunal QA stage in actual Battle

- Authored `assets/pixel/battle/arenas/court_of_the_mute_d270_empty_qa.svg`, editable independent empty Court with carved throne, justice scales, banners, elevated braziers, ruined arches and contiguous **D264 legal lower floor**, no embedded people, sprites, text or UI. Court-only Battle now previews its 1280×720 nearest-neighbor native SVG; original D265 `.webp.b64` kept as full rollback.
- Real F6 Court preview added **B** comparison old D265/new D270 in-place; existing **L** ambience and **G** floor toggles retained. Godot actual F6 checks SVG opaque floor and both B states.
- [Godot 4.7.2 D270 official CI SUCCESS](https://github.com/zampolit73/Misdeal/actions/runs/39255650012): SVG resource, all QA toggles, 6 Court Battle setups, 54/54 original BattleUnit diagnostic fights, direct QA-only Fight→Reward→Table. **No art-quality claim from CI.**
- D267 rich animated originals (75 poses/27 source QC review marks), D261 selected original card bitmap, D264 movement floor, D260 released #38 and frozen KARAMBA73 unchanged. **Card #39 remains unreleased (38/45 live)**; full painterly art verdict and native x1 motion review required. [D270 QA details](docs/D270_COURT_EMPTY_ARENA_NATIVE_QA.md) · [handoff](docs/D270_NEW_CHAT_HANDOFF.md).


## 2026-10-19 — D269 Court upper-tribunal atmospheric QA pass, verified

- User replied «Да, Все ок» to D268 native real battle check. Incrementally added Court-only upper-architecture cold shafts, warm four-brazier breathing, sparse dust motes; every effect remains safely above the D264 screen lower-floor start y532, **no changes to movement or unit cards**.
- F6 `res://scenes/dev/court_of_the_mute_d268_real_battle_preview.tscn` now has **L** light on/off compare and **G** precise lower battle zone overlay, both only in QA preview; added independent real F6 D269 floor/light contract and CI step.
- [Official Godot 4.7.2 Actions PASS](https://github.com/zampolit73/Misdeal/actions/runs/39252464563): D269 new L/G test, D262 six genuine Court Battle startup cases, D268 54 original BattleUnit balance simulations and QA-only Fight→Reward→Table. **Card #39 stays UNRELEASED, 38/45 LIVE.**
- **Art remains OPEN:** existing D265 actor-free provisional raster unchanged, newly brainstormed baked-actor/UI scene comps intentionally NOT used; need genuine rich empty Court painting and x1 review of all 75 D267 original rich poses/27 flagged sources. [D269 report](docs/D269_COURT_UPPER_TRIBUNAL_ATMOSPHERE_QA.md) · [handoff](docs/D269_NEW_CHAT_HANDOFF.md). D261 selected portrait/D264 floor/#38/KARAMBA73 unchanged.


## 2026-10-19 — D268 verified native Court QA, balanced local encounter, reward route PASS

- [Official Godot 4.7.2 workflow #9 SUCCESS](https://github.com/zampolit73/Misdeal/actions/runs/39249979969): parser, two combined F6 scene headless smoke tests, six real Court Battle startups, **54/54 original Court BattleUnit functional scenarios**, and direct QA only Fight→Reward→Table.
- Replaced erroneous Crypt arena fallback and ambience with Court's own empty D265 *provisional QA* art in real Battle. Added F6 selectable Court solo/duo/trio + 2 formations and 27 flagged-source-frame navigation in rich D267 three-character preview.
- Local Court-only difficulty adjustment: Magistrate damage **8→9** / movement **49→55**; Scribe damage **5→5.5**; Bailiffs damage **6.8→7.8** / movement **63→68**. New means solo/duo/trio **83.84% / 75.54% / 80.16%** HP, 2 individual trio fallen, **54 wins / 0 timeouts**; older baseline was 86.29/78.42/82.77%. No global AI/party changes.
- Corrected QA checker that sampled SpriteFrames before `add_child`; instrumented all live active marked-target ticks: **7,694/7,694 actual Bailiff target-hold**. Zero forced retarget counters expected when they already prefer the marked hero naturally. D262 forced-retarget contract separately passes.
- **Still art HOLD**: 27 D267 source-edge warnings need true Godot ×1 visual review and scene-appropriate rich character-free Court tribunal not yet authored. Normal #39 still unreleased: ACT1 **38/45**, card target_path empty, chosen D261 second illustration/D264 floor/D260 #38/KARAMBA73 preserved. [Detailed native run and balance metrics](docs/D268_NATIVE_COURT_BALANCE_AND_ROUTE_PASS.md) · [current handoff](docs/D268_NEW_CHAT_HANDOFF.md).

## 2026-10-19 — D267 continuity: verified source/art integration after interrupted connection

- Checked live GitHub main: all three approved original Court source PNGs, their rich full25 atlases and Godot ×1/×2 F6 preview are committed; [native Godot 4.7.2 CI PASS](https://github.com/zampolit73/Misdeal/actions/runs/39242455779). No retransmission or accidental overwrite required.
- Archived **exact current next-chat handoff** in [D267_NEW_CHAT_HANDOFF.md](docs/D267_NEW_CHAT_HANDOFF.md): 27 seam warnings by role, art review, actor-free arena and full Court Battle/Reward/54-case QA open; card #39 still QA only, Act1 **38/45** and frozen KARAMBA73 preserved.

## 2026-10-19 — D267 rich user-approved Court originals/75-frame atlas integration verified

- All three exact approved RGBA PNG sources and all three rich 25-pose QA atlases committed to GitHub. Recovered actual original artwork instead of D266 simplified procedural placeholders.
- Godot 4.7.2 CI source regeneration, 75-cel QA, three-role library registration and native combined rich ×1/×2 preview **PASS** ([CI](https://github.com/zampolit73/Misdeal/actions/runs/39242455779)).
- Source clipping warnings **27** remain visual-review items; background and full Court route unfinished. **38/45 LIVE**, #39 not released. [D267 handoff](docs/D267_ACTUAL_RICH_ATLAS_IMPORT_QA.md).

## 2026-10-19 — D267: all three rich Court character art directions user-approved

- User explicitly approved the detailed transparent Judge, Scribe and Bailiff source pose illustrations (three 1374×1145 RGBA images). Archived exact source filenames/design description and no-more-reconcepting rule in [D267](docs/D267_APPROVED_COURT_CHARACTER_ART.md).
- Original image import, seam-aware 75-frame atlas QC and native F6 not yet complete. D266 simplified QA prototype art not promoted to production. #39 still QA-only, 38/45 live, KARAMBA73 preserved.

## 2026-10-19 — D266 three Court 25-pose prototype animation atlases + QA

- Authored three entirely new 576x480 25-pose transparent skeletal animation atlases (Magistrate/Scrivener/Bailiff) under `assets/pixel/units/court_of_the_mute_qa/`, from source keyed joint and prop movement, not borrowed sprites or annotated montage.
- Independent **75/75** source QC and native Godot 4.7.2 **all-three ×1/×2 F6** preview PASS. Scene: `res://scenes/dev/court_of_the_mute_d266_three_animation_preview.tscn`.
- Current visual styling is simplified QA art, **not accepted final rich animated artwork or production library content**. #39 remains QA-only; 38/45 live and KARAMBA73 untouched. [Full D266 record](docs/D266_COURT_ALL_THREE_ANIMATION_QA.md).

## 2026-10-19 — D265 Court richer empty arena / strict three-original-atlas readiness audit

- Reproducible `1280×720` actor-free richer tribunal QA source `tools/art/author_court_d265_rich_arena.py`, independent WebP rollback-preserving `court_of_the_mute_d265_rich_qa.webp.b64`; official Godot 4.7.2 F6 import and same D264 lower-floor overlay PASS.
- Added `tools/art/audit_court_d265_three_roles.py` + GitHub Actions to check 3×25 original Court alpha pose sheets together; [reported **0/75 real frames accepted**](docs/qa/D265_THREE_ROLE_FULL25_AUDIT.json), all three original sprites missing. Successful audit script ≠ sprite art PASS. Generated labelled art montage intentionally NOT installed.
- D265 backdrop still QA schematic, not a completed production replacement. D261 chosen second court card, #38 release, 38/45 live, D262 verdict, DS2/KARAMBA73 unchanged. [D265 art hold](docs/D265_COURT_RICH_ARENA_AND_ART_AUDIT.md).

## 2026-10-19 — D264: move Court walkable floor to user's red-marked lowest stone platform

- Applied explicit screenshot feedback to **actual** `court_of_the_mute` combat and F6 preview: shared screen bounds `(40,532)-(1268,710)` instead of former raised overlay `(110,380)-(1190,538)`. Stairs/throne no longer valid Court pathing.
- Scoped `Battle` combat bounds, preparation hero drag pocket and pre-Fight actor starting depth to lower terrace (visible above lower tactics HUD); rest of card pools and arenas unchanged. Green QA preview overlay shares the exact new bounds, title/hints moved away from feet.
- Godot 4.7.2 native F6 scene import/launch and six real Court solo/duo/trio×two-formation simulations PASS, including original verdict controller and existing 54-case released #38 regression. [D264 QA report](docs/D264_COURT_LOWER_FLOOR_FIX.md).
- D263 original arena is STILL QA visual candidate and three 25-frame authentic character packs still not accepted. D261 chosen card bitmap byte-identical, #39 unreleased 38/45, KARAMBA73 preserved.

## 2026-10-19 — D263: QA-only empty Court battle arena authoring and native preview (art hold)

- Added reproducible original Court `1280×720` character-free pixel battle plate from `tools/art/author_court_d263_arena.py`; stairs, pillars, cracked tribunal, scales and wide walkable stone. Kept separate from production `BattleBackdrop` pending artistic quality.
- GitHub Actions Pillow source/QC PASS; native Godot 4.7.2 full image decode + D261 approved card reference in `res://scenes/dev/court_of_the_mute_d263_empty_arena_preview.tscn` PASS; G toggles floor footprint.
- Explored character montage poses but **NO THREE COMPLETE original 25-frame alpha-animation packs obtained or committed**. Incomplete/opaque source intentionally rejected; full artistic D263 release gate OPEN.
- No normal `ACT1_CARD_IDS`, UnitData balance, common sprite registration or original card art changes. **38/45 LIVE**, #39 QA-only, KARAMBA73 frozen. [D263 honest QA note](docs/D263_COURT_EMPTY_ARENA_QA.md).

## 2026-10-19 — D262: Court new combat UnitData + encounter-scoped verdict mechanic (QA only)

- Added `mute_magistrate`, `ash_scrivener` and `bone_bailiff` wholly distinct skeletal `UnitData` and Court encounter with four enemy instances/two original formations.
- Added `CourtVerdictController` with red warned marked hero and temporary Bailiff-only target preference; Scribe death cancels, no shared `BattleUnit` AI modifications. Wired exact encounter setup/start/stop to actual Battle.
- Native Godot 4.7.2 CI **PASS**: warning/focus/expiry/Scribe-death contract, 1/2/3-party×two-formation (6) genuine Battle launches, D260 released #38 54-case regression.
- Original three complete 25-frame sprite atlases and playable Court arena **remain ART HOLD**, not replaced by generic sprites or baked-art scene; #39 card resource target_path blank and live pool **38/45** unchanged. Selected second D261 card art and KARAMBA73 untouched. [D262 QA handoff](docs/D262_COURT_VERDICT_QA.md).

## 2026-10-19 — D261: second Court of the Mute art selected and wired into native QA

- User selected battle option A `Суд безмолвных` and **image #2** of the three rendered portrait concepts. Exported selected exact composition as 448×274 source-derived WebP, original selected portrait not restyled. Export SHA256 `704eef553a1ef528d2793b692462315048b06cf23ddaf17dff0c1fba0ed69d5c`.
- Committed `assets/pixel/card_unification_v1/run/court_of_the_mute_selected_v1.webp.b64`, strict `CardUnificationV1` art branch, QA-only `resources/cards/court_of_the_mute.tres` + `RunState.CARD_PATHS` entry (NOT `ACT1_CARD_IDS`), and `scenes/dev/court_of_the_mute_d261_card_preview.tscn`.
- Official [Godot 4.7.2 WebP exact-transfer and native preview CI PASS](https://github.com/zampolit73/Misdeal/actions/runs/39212443418). Three new 25-pose original unit sets, underground arena and scoped `verdict_target` mechanic to follow in D262. Full [selected art QA](docs/D261_COURT_SELECTED_ART_QA.md).
- Act1 live **38/45**, released #38, DS2/Fate Spread and KARAMBA73 unchanged.

## 2026-10-19 — D261: card #39 three-way concept proposal (no runtime changes)

- Following user acceptance of released card #38, drafted three intentionally different card #39 options: mute tribunal battle with new marked-target enemies, haunted memorial-garden ward combat, and stranger's epitaph event.
- Archived mechanics, new-enemy requirements, scope comparisons and D168 scene-first three-rendered-art selection gate in [D261 concept options](docs/D261_CARD39_CONCEPT_OPTIONS.md).
- **No artwork generated or approved yet; no implementation, card pool modification or release.** Act1 remains 38/45, D260 untouched, KARAMБA73 frozen.

## 2026-10-19 — D260: RELEASED Black Lantern Road, Act1 38/45

- Released `black_lantern_road` into normal `RunState.ACT1_CARD_IDS` (new pool **38/45**), preserving five original 25-frame skeleton animations and previously selected D200 card illustration/D209 forest arena.
- Local Godot 4.7.2 balance assessment 54/54 scenarios, 0 defeats/timeouts, average HP solo/duo/trio ~79.7/69.2/74.6%, worst ~53/29.8/44.1%, 0/2/4 individual fallen heroes; accepted original five UnitData and travelling lanternlight ×1.16 for initial release with no inflated damage.
- Released normal Tier1 `RunState` deal/choose→actual five-role Battle win→Reward claim→Table **native headless PASS**. Repeated post-release 54-case balance matrix PASS; dedicated `res://scenes/dev/black_lantern_d260_released_battle_preview.tscn` for direct F6 preview with party and authored formation selectors.
- Updated original matrix 38-card contract, built repeatable Godot 4.7.2 release CI, preserved old D259 QA/history; KARAMBA73, Fate Spread and DS2 unchanged. [D260 full release note](docs/D260_BLACK_LANTERN_CARD38_RELEASE.md).

## 2026-10-19 — D259: canonical five-role original animation library staging, card #38 release prep

- Added reproducible original D257 → canonical RIGHT-facing WebP exporter and CI source QA for Guide/Acolyte/Archer; all 25 distinct cels and five blanks per atlas retained.
- Shared strict `MisdealUnitAnimationLibrary` now supplies all **five original Black Lantern enemies**; existing D244 Sentinel and D224 Bearer unchanged. New D259 real Battle F6 and headless preflight use **no temporary sprite injection**.
- Wired unreleased `black_lantern_road` card's `target_path` to its actual five-role encounter; `RunState.ACT1_CARD_IDS` remains **37/45**, no production balance/light modifications.
- Official Godot 4.7.2 standard-loader smoke and **54/54** normalized functional combat PASS. Corrected invalid HUD Z indices (5090–5100) to legal 3090–3100; corrected QA-only headless observer creation. Final Godot 4.7.2 [CI](https://github.com/zampolit73/Misdeal/actions/runs/39206093134) **PASS** for the entire genuine Battle win→Reward→Table navigation and 54/54 normalized battle regression; test-only synthetic frame signal compensates for headless RenderingServer, not a visual proof.
- Previous art, DS2 and KARAMBA73 preserved. [D259 detailed handoff](docs/D259_CANONICAL_FIVE_ROLE_RELEASE_PREP.md).

## 2026-10-19 — D258: original five-enemy Black Lantern real combat QA

- Staged all five original rich 25-pose characters in a separate D258 3v5 BattleUnit scene and real Battle→Reward→Table F6 launcher; Guide/Archer left-authored art normalized in QA only. D244 Sentinel and D224 Bearer unchanged.
- Official Godot 4.7.2 GitHub Actions **PASS**: GDScript parser, actual five-role 3v5, real Battle injection preflight and **54/54 normalized matrix cases** (54 wins/0 party defeats/0 timeouts; 0/2/4 individual hero losses). Full route and art judgement **not yet tested**.
- Preserved all original art and previous D249/D254 scenes; no production sprite library/RunState/card pool/balance changes. 37/45 live, KARAMBA73 frozen. [D258 QA evidence](docs/D258_FIVE_ROLE_GODOT_QA.md).

## 2026-10-19 — D257: seam-aware repair candidates for all three approved D255 characters

- Added tracked source-aware Python art recovery, GitHub Actions build, **three newly generated QA-only WebP/Base64 25-pose atlases** and detailed per-pose machine QC.
- Cross-cell alpha ownership reclaimed **9/10/8** components respectively for Guide, Oil Acolyte and Archer; local lower-contour treatment staged. Static generator/format PASS: 75 unique frames, 15 transparent unused cells, 2px margins. **11 raw lower-source-boundary warnings remain**, and true art/motion PASS is pending F6.
- Added single combined D257 Godot x1/x2.1 gallery. Preserved all original D255 assets, both existing accepted-stage roles, 37/45 live card pool, normal game scripts, Battle→Reward→Table and frozen KARAMBA73.
- Complete next-chat context and limitations: [D257 atlas QA](docs/D257_THREE_ATLAS_SEAM_RECOVERY_QA.md).

Current implementation summaries only; the exhaustive pre-cleanup change history lives at [CHANGELOG archive](docs/archive/2026-10-15-pre-cleanup/CHANGELOG.md).

## 2026-10-19 — D256: complete self-contained new-chat handoff for D255 art checkpoint

- Consolidated user-approved *visual directions* vs pending animation approval; all 6 large D255 source/atlas blobs, deterministic generator, 75-cel static QA, unified F6 scene, and 34 source-border warnings in `docs/D256_NEW_CHAT_HANDOFF.md`.
- Updated legacy NEXT_CHAT_HANDOFF and INDEX to point at current D256, rather than old D238/D241 as latest; prepended concise current status to PROJECT_STATE, HANDOFF and ROADMAP.
- Docs-only. No character registrations, gameplay mechanics, balance, live 37/45 deck or frozen KARAMBA73 changed.

## 2026-10-19 — D255: complete original visual packs for three remaining #38 roles (QA source and sprites)

- User-approved visual directions for Guide/Oil Acolyte/Archer preserved in lossless Git source. Authored 75 original illustrated pose cutouts as three complete 25-frame WebP alpha candidates + Python generator + per-cell QC and combined x1/x2.1 five-state/two-facing Godot F6 gallery.
- Offline structural QC passed 25 unique per role, 5 fully clear unused cells per role, 2px safe margins and fixed transform without pose-by-pose whole-body shrink.
- **Internal art hold**: edge-overlap in original six-column images clips moving lamps/chains/cloth (12/13/9 source frame flags respectively), not visually release-ready. No global animation registration, #38 deal activation or game balance changes. One final full-pack native F6 should follow repaired atlas only.
- 37/45 active cards, D244 Sentinel/D224 Bearer, real D253 light, D254 QA launcher and frozen KARAMBA73 untouched.

## 2026-10-19 — D254: real #38 Battle→Reward→Table F6 launcher, live deck unchanged

- Added a dedicated F6-only front end to select party size and either formation, then instantiate full real Battle (preparation/tactics/intro/true D206 encounter light), navigate actual Reward and Table inside the throwaway debug process.
- QA card #38 is now look-up-able by ID in RunState.CARD_PATHS only, **not** included in 37-card ACT1_CARD_IDS. Inject original Guide/Oil/Archer technical animation into QA units only; accepted D244/D224 roles untouched.
- Generated Guide reference with opaque labels not promoted to animation; final genuine transparent 25-frame Style B remains required, along with 54-case matrix, visual QA and native full-route check. No live encounter rollout.

## 2026-10-19 — D253: scope already-tested lantern light into the real Battle scene

- Reused original D206 attack-interval boost controller exclusively for unreleased `black_lantern_road` in real Battle. Exact five original enemy-role guard, normal party/run modifiers, Fight-intro start and win/lose interval-restoring stop; other cards unchanged.
- Static source contract checked; Godot main Battle route with #38 NOT yet run; normal pool still 37/45, no unit art or stats changed.
- Local D251 Guide alpha fringe experiment rejected as insufficient; complete painterly 25-pose Guide, Acolyte, Archer and full integration/matrix QA remain before release.

## 2026-10-19 — D252: user-native D251 scene verifies BOTH five-enemy formations

- Reviewed ~27.76 sec actual Godot user recording. Native **ПЕРЕКРЁСТОК** and **МАРШ** each completed real isolated 3v5 fights at roughly 9.7 in-game seconds with all three heroes surviving; both encounter position variants and selector were actually exercised. Previous D250 second-formation PENDING is now CLOSED for **isolated QA**.
- Confirmed enemy labels hidden by default (optional ON untested), existing hero HP/names still have crowd overlap, D206 attack-buff phases and counters visible; no red QA FAIL on record.
- The D218 Guide remains oversized simplified technical art. D251 new rich character pack was NOT installed, and remains internally rejected, as stated in `docs/D251_GUIDE_RICH_ART_INTERNAL_FAIL.md`. Normal card #38 still unreleased, full balance and Battle→Reward→Table untested. Evidence in `docs/D252_D251_NATIVE_BOTH_FORMATIONS_QA.md`.
- No gameplay or asset changes; 37/45 live and frozen KARAMBA73 preserved.

## 2026-10-19 — D251: rich triple-lantern Guide structural pack, internally rejected as final; isolated QA HUD

- New original 1536×1024 rich B-style Guide reference has rigid overhead iron yoke and three chain-hung lamps; extracted 25 frame-wise illustrative poses into lossless alpha 576×480 with 25 distinct/5 clear/margins PASS, original source/reproducible offline author and QC staged in QA.
- **Internal art FAIL:** matte fringe, compressed chain motion in wide attacks, inconsistent animation proportions. No shared Guide registry switch and no player F6 requested for rejected candidate.
- D249 3v5 isolated test now shows explicit alternate-formation destination and optional enemy name overlays, OFF by default to reduce overlap without touching HP bars, units or production Battle. New Godot native test pending.
- Current released 37/45, unchanged unit stats, D209, DS2, Fate Spread and frozen KARAMBA73.

## 2026-10-19 — D250: actual user D249 3v5 native video review

- Independently inspected user's ~21.4s running Godot footage. D249 MARШ first encounter proceeds through 3v5 combat and light boost/off control, winning around 9.6s with 3 heroes alive, 0 enemies, attack count 17/6; a second MARШ run starts successfully.
- Remaining second ПЕРЕКРЁСТОК formation is **not** demonstrated in this video; no real Battle→Reward→Table/balance evidence. Document exact video evidence and boundaries in `docs/D250_NATIVE_D249_3V5_VIDEO_QA.md`.
- Noted major nonrelease visual defect: huge gray D218 Guide technical actor obscures accepted detailed sprites and labels in melee; B-style guide 25 original yoke/three-lamp frames remain required. No game code, active cards, original art, or KARAMBA73 modified.

## 2026-10-19 — D249: native original five-enemy 3v5 diagnostic scene staged

- User reports D248 real 1v1 technical Guide QA OK; D218 still NOT painterly Style B art. Internally rejected three new artwork sheets with wrong yoke/lantern identity and invalid game atlas structure, imported none.
- Added isolated Godot F6 D249 real 3v5 with original enemy data, two authored positions and working previously scoped lantern light controller. The 2 previously accepted-to-proceed characters come from the shared staged animation library; remaining three original, TECHNICAL art packs are injected into only the QA instances.
- Static source paths/contracts checked; native Godot D249 F6 pending, not a balance benchmark or actual release route. No ordinary 37/45 deck, production battles, hero progression, reward, KARAMBA73 or DS2 changes.

## 2026-10-19 — D248: Bearer staged, Guide real 1v1 technical QA added

- Recorded user's `«все ок»` after D247 actual Bearer Knight duel. Linked the original user-selected D224 25-frame asset blob into canonical Bearer `.webp.b64`; added Bearer to strict staged library alongside D244 Sentinel (two of five #38 roles).
- Added D248 isolated real BattleUnit Guide 1v1 on D209 to probe AI movement with the old D218 triple-lantern tech atlas; keeps all 25 frames local to one instance. New Godot F6 NOT RUN. D218 simplified geometry NOT accepted for production.
- Rejected off-identity exploratory shield-bearer illustration; did not import any new art for Guide. Future B-style 25-frame original Guide work remains required.
- Zero RunState, normal battle/unit stats, #38 pool, DS2, D200/D209 or frozen checkpoint changes. Live remains 37/45.

## 2026-10-19 — D247: rich Sentinel staged, Bearer real Knight duel ready

- User feedback D246 `«вроде все ок. продолжай»` authorizes moving forward with Sentinel B-style D244 on the QA-only #38 lane, not a complete game-release confirmation.
- Staged D244's **existing exact Git blob** in canonical Sentinel animation file, leaving D229 archived and updating its historical smoke into a D229-vs-D244 library comparison.
- Added Lantern Bearer D224 actual AI combat preview using one isolated instance of the already-approved illustrated original repack; 25-cel strict validation, side swap, actual shield range/attack, forced death and HP-only extension.
- Changed no live Act1 cards, five-role encounter, original UnitData, main battle, light mechanic or frozen backup. D247 native Godot test PENDING.

## 2026-10-19 — D246: real 1×1 Sentinel D244 combat preview (QA-only)

- Added Godot F6 scene `black_lantern_sentinel_d246_combat_preview.tscn` using real `BattleUnit` AI for exactly one D244 Sentinel and one Knight; authentic movement, auto-facing, melee hit effects and death on approved D209.
- Kept D244 art override on preview instance only; no shared animation-library/caching, live battle scene, `UnitData` or random-deal modifications. HP ×3 is clearly QA-only to prolong observation; buttons restart, reverse sides and trigger actual death.
- Added native QA instructions and source-of-truth D246 handoff. **Static source checks completed, native Godot F6 not yet verified**. Live 37/45; card #38 and frozen KARAMBA73 untouched.

## 2026-10-19 — D245: recorded real native Godot D244 gallery QA

- Evaluated user's 21.38s Godot screen recording frame-by-frame: ×1/×3 D209 stage, both directions, all five states, visible horizontal spear thrust, multi-stage falling body and attached amber lantern. Gallery rendering/motion reviewed as **native scene PASS**, not inferred from static 25-frame QA.
- Artistic motion substantially improved over D241; final user aesthetic acceptance not explicitly received. No actual #38 combat/matrix/navigation test and no real animation registry or run-pool change. Recorded constraints and next single overall art verdict at `docs/D245_SENTINEL_USER_VIDEO_NATIVE_QA.md`.
- 37/45 live cards and frozen KARAMBA73 preserved.

## 2026-10-19 — D244: original illustrated Sentinel 25-pose QA, native review pending

- Authored new detailed D235-inspired skeletal spear/held-lantern 25-frame illustrated source with true distinct whole-body poses instead of D243 flat vector geometry or D241 static cutout rotations.
- Packed one 576×480 25-state lossless WebP atlas via connected-alpha island extraction to avoid source overlaps, plus separate spear-tip perspective correction on two attack frames, 5 transparent unused cells and 2px pad.
- Static QA PASS on source segmentation, 25 unique frames, alpha, dimensions and lossless export. Godot F6, game motion and player artistic acceptance PENDING; new isolated preview does not change production sprites, card pool 37/45, selected card/arena or frozen KARAMBA73.
- Source/provenance, author script, machine report, isolated F6 and decision gates in `docs/D244_SENTINEL_RICH_ILLUSTRATED25_QA.md`.

## 2026-10-18 — D243: internal 25-pose motion study, not final painted art

- Drew 25 explicit articulated 96px motion frames with separately positioned armored joints, grounded spear thrust, visible lantern grip and staged kneel/fall/corpse. QA-only WebP atlas, Python source, machine checks and native Godot preview are staged.
- Offline structural QA PASS (25 unique, five clear, 2px margins, lossless). **Internal visual art FAIL**: too simplified against D235 accepted rich B-style. Native Godot NOT RUN; no user retest requested.
- `docs/D243_SENTINEL_MOTION_STUDY_ART_FAIL.md` records the blocker and next full character-redraw gate. No real Battle/Act1 pool/approved visuals or KARAMBA73 changes.

## 2026-10-18 — D242: Native D241 video proves visual animation FAIL

- Opened user's 16.6s Loom via connected Atlassian and inspected the actual attached ~17s MP4 frame by frame. Godot's D241 x3/x1 QA scene runs; walking ~5–10s is stiff, attack ~11–13s leaves spear raised rather than making thrust, death ~13–16s collapses into flattened poster-like smear. Full hit and both facings were not shown; not falsely marked tested.
- **D241 ART REJECTED**, despite technical 25 unique / 5 blank QC. D239 also rejected. Existing assets left safely in QA history; no character registry, card pool, game or KARAMBA73 changes.
- Wrote `docs/D242_SENTINEL_NATIVE_VIDEO_ART_FAIL.md` and aligned full new-char redraw acceptance/handoff. Next real milestone: independently drawn all-state whole-body spear Sentinel matching shipped D153/D183 motion fidelity. No repeated individual frame approval.

## 2026-10-18 — D240/D241: Rework Sentinel after user-native D239 art rejection

- User's native D239 F6 shows scene loads but **explicit art FAIL**: detached foreign-looking polygon legs and wooden weightless steps. Inspected previous released D153 Puppeteer/Marionette and D183 Ferryman original whole-body 25-frame atlases. Logged root cause: D236R hand-coded boot/greave overlay and D239 rigid body-splicing, rotating still for death.
- Added D240 reproducible internal foreground-extraction QA of selected rich D235 six full-body illustrated poses including **their original armored legs**; GitHub generated six transparent source frames and matte inspection. No new card art or live characters changed.
- Built D241 **entire QA 25-frame illustrated-body atlas** (idle4, walk6, attack6, hit3, death6 +5 clear) with original illustrated boots, reused D234 actual painted spear at hand pivot, reconstructed attack stances and visible horizontal grounded corpse poses. GitHub Actions source/strict alpha/unique/2px validation PASS. D241 full atlas sha256 `47078522c29d2f5d55418800054edff21ef70541ad3fe51db0db4eb26b422be1`.
- One isolated Godot F6 scene `res://scenes/dev/black_lantern_sentinel_d241_wholebody25_preview.tscn` compares ×1/×3 and both facings across five states on existing D209 forest. **No native engine execution or artistic PASS claimed**; full individual painting (especially spear thrust and death) may still be needed.
- No D229 production registry switch, no #38 release, active **37/45**, KARAMBA73 frozen. Canonical notes `docs/D240_SENTINEL_ANIMATION_ART_REJECTION.md` and `docs/D241_SENTINEL_WHOLEBODY_FULL25_QA.md`.

## 2026-10-18 — D239: Full 25-frame Sentinel illustrated-source QA package

- Generated and committed **actual 576×480 WebP/Base64 atlas** with 25 distinct roles across idle4/walk6/attack6/hit3/death6, five empty alpha cells and valid 2px margins, via a scoped GitHub Actions Pillow builder. Machine report `docs/qa/D239_SENTINEL_FULL25_QC.json`, SHA256 `79817fba4ee8469de6923fc9cdb30436db6852aa415533a25c93529f4fc49487`.
- Source-preserving art construction uses accepted D234 visible free-hand lantern and D236R gait, with pose-staged illustrated-source attack/hit/collapse. Not 25 independently full-body-painted cels; *visual completion still subject to one full-package native review*.
- Added `res://scenes/dev/black_lantern_sentinel_d239_full25_preview.tscn` on existing D209 forest, five state buttons, both facings, ×1/×3 and strict decoded-atlas QC. **Godot 4.7 F6 not performed here.**
- No production sprite or #38 pool switch; Act1 37/45, frozen КАРАМБА73, D200/D209/D196 and older staged art untouched. Full handoff `docs/D239_SENTINEL_FULL25_QA.md`.

## 2026-10-18 — D238H: Clean new-chat continuation and documentation consistency

- User requested all current GitHub context saved for resuming in a new chat. Added standalone compact `docs/D238_BATCH_ANIMATION_NEXT_CHAT.md` describing the **full 25-frame in one batch / one finished F6** workflow, each current source art reference, exact #38 work boundaries, and next code/art implementation action.
- Reconciled `docs/INDEX.md` and linked D238 from `PROJECT_STATE`, `ROADMAP`, `DECISIONS`, and `HANDOFF` so earlier D237 micro-approvals and D230 premature "final art" claims cannot be mistaken as active instructions.
- Documentation/handoff only; **no new 25-frame atlas implemented**, no current runtime code, card ID pool, art sources, or frozen KARAMBA73 modified. Act1 LIVE remains **37/45**, #38 QA-only.

## 2026-10-18 — D238: Restore batch-first original 25-cel character art delivery

- User explicitly requested the old workflow: finish all **25 real idle/walk/attack/hit/death poses** for the game in one batch instead of seeking approval for every minor animation increment.
- Added permanent character-animation policy to `AGENTS.md` and locked D238 in `docs/DECISIONS.md`: self-QA five states, 6×5 packing, image fidelity, hand/weapon grip, leg contact, x1 appearance, clean alpha and frame uniqueness **internally**, show ONE complete F6 preview per character. True fundamental art direction changes still require user input; D168 2–3 card art choices unaffected.
- Updated `PROJECT_STATE`, `ROADMAP` and `HANDOFF`: next is one full rich Road Sentinel atlas using approved D234 wrist-held lantern, D235 rich long-spear style and D236R walk, **not six-attack-only approval D237**. Complete pack not yet implemented in this policy-only commit.
- No Godot/runtime/regular deck changes, #38 QA-only and 37/45 live; untouched KARAMBA73.

## 2026-10-18 — D237 handoff: user accepts repaired six-phase gait

- User responded «пойдет» to the D236R A/B native visual comparison, so repaired D236R six-frame WALK accepted **for continued development**. Previous D236 gait still rejected.
- No new art or live code changed in this acceptance update. No full 25-frame premium Sentinel atlas, actual Battle/UnitData/RunState, final-art or #38 release PASS implied.
- Next art work: original 6-frame planted spear-thrust ATTACK pilot with windup, contact and recovery preserving D234 hand-held lantern and D235 richness; after that hit/death and full art integration.
- Synced HANDOFF, PROJECT_STATE, ROADMAP and DECISIONS for fresh chats; 37/45 live.

## 2026-10-18 — D236R: repair unnatural Sentinel walk reported by user

- User `не естествено` rejected D236 Godot walk QA, superseding offline six-unique test. Root cause: wide hard-coded straddle, abrupt A/B foot swap between phases and frozen torso.
- Created independent `tools/art/author_road_sentinel_d236r_walk.py`: physically phased A-foot support contact/weight/toe push then B-foot support, swing arcs, y91 aligned support soles, max ankle transition10px across all adjacent frames including loop seam, small torso bob to transfer weight. Kept complete rich D234 cloak, spear, attached lantern source and D235 accepted look reference.
- Committed `road_sentinel_d236r_walk6_support_cycle.webp.b64` with 6 genuinely distinct row1 WALK images and 24 empty slots, 2px borders safe, WebP SHA `bef95a03eb3da3996846e0826a5bf6fe53a1250b284ffa12f44d4d3fd50b73d5`; report `docs/qa/D236R_SENTINEL_GAIT_QC.json`.
- New isolated `res://scenes/dev/black_lantern_sentinel_d236r_gait_compare.tscn` old D236 left/new gait right, ×3 and ×1, both directions, 0.5× playback, ground guidelines. **Native F6 pending; still a rigging pilot, not six fully hand-painted rich D235 art cels.**
- No production sprite, Battle, RunState, #38 release or backup changes; live 37/45. `docs/D236R_SENTINEL_GAIT_REPAIR_QA.md`.

## 2026-10-18 — D236: real six-step gait PILOT with accepted D234 rich torso/held lamp

- Attempted extracting original D235 3×2 illustrated poster into real alpha animation; automatic background matting left visible brown gradients and truncated spear. **REJECTED**, not shipped as engine art.
- Added reproducible `tools/art/author_road_sentinel_d236_walk6_pilot.py` using approved D234 illustrator body/free-hand attached lantern and six author-controlled alternating boot and armored shin articulation states. Genuine moving legs, while upper body repeats D234 partial cels; therefore **not a complete individually illustrated D235-quality six-frame atlas**.
- Staged `assets/pixel/units/black_lantern_road_qa/road_sentinel_d236_walk6_pilot.webp.b64`: valid lossless 576×480 / 96×96, exactly **6 distinct row1 WALK** poses and **24 clear others**, zero boundary faults, WebP SHA `c37d8155925de2e6cad90140cbe5328b91fa489b7ed4da2c301cd30b8b1ac6fb`; `docs/qa/D236_SENTINEL_WALK6_PILOT_QC.json`.
- Added QA-only `res://scenes/dev/black_lantern_sentinel_d236_walk6_pilot.tscn` with original D209 forest, left D234 4-IDLE and right D236 6-WALK, x3/x1 and pause/flip. **Godot native F6 and style acceptance pending**, not integrated with real battle; only six walk cells, still no attack6/hit3/death6 rich originals.
- Full current handoff `docs/D236_SENTINEL_WALK6_MOTION_PILOT.md`; ordinary live 37/45, #38 QA-only, no changes to active actors, D200/D209 or frozen KARAMBA73.

## 2026-10-18 — D235: user accepts rich six-pose Sentinel WALK visual; source archived

- User explicitly **«принято»** on the new 1536×1024 3×2 richly illustrated skeletal Road Sentinel walk concept with real pointed long SPEAR, layered plate, burgundy cloak and separate amber **wrist-held lantern**. The selected visual direction is locked; retain D234 right-hand handle.
- Saved full-resolution near-original WebP-quality-95 visual reference as `assets/pixel/units/black_lantern_road_qa/road_sentinel_d235_approved_walk_concept_q95.webp.b64` and checksum/report `docs/qa/D235_SENTINEL_WALK_CONCEPT_REF_QC.json` so later project chats can inspect the approved reference without previous-chat media. Original PNG SHA `9fa8e48baed60364411e13e2a58d1549e052bbdc250c26b37933d2081442b181`.
- **NO game animation/production asset was changed:** poster 3×2/background is NOT six individually authored 96px RGBA walk frames, full 25-frame set, or Godot-native PASS. Next six actual walking poses/grounded movement and x1 F6, then attack/hit/death. Existing D229 technical registered atlas and 37-card pool intact.
- Full accepted-art note `docs/D235_SENTINEL_WALK_ART_APPROVAL.md`.

## 2026-10-18 — D234: free-hand lantern attachment and illustrated robe repair

- User observed **D233 FAIL**: skeleton did not appear to hold hanging lantern. Diagnosed source coordinates: original lantern under opposite knee, free hand far right; independent cutout movement made lamp visually float.
- Created reproducible `tools/art/author_road_sentinel_d234_hand_lantern.py`, relocated exact original illustrated lantern under right gauntlet, redrew continuous handle/iron ring to its wrist anchor and composited hand over the ring. Repaired cutout region with mirrored original cloth texture rather than flat paint. Four independent idle image variants, 26 unused empty cells; zero alpha-edge faults. `assets/pixel/units/black_lantern_road_qa/road_sentinel_d234_handheld_idle4.webp.b64`, `docs/qa/D234_SENTINEL_HAND_LANTERN_QC.json`.
- Added `res://scenes/dev/black_lantern_sentinel_d234_hand_lantern_compare.tscn` with old D233 LEFT/new D234 RIGHT, ×1 and ×3 and direction/pause on approved D209. Native F6 and visual approval pending; not a full 25-pose atlas.
- All code/assets for ordinary 37-card run and real D229 technical Sentinel role remain untouched; card #38 still QA-only. `docs/D234_SENTINEL_HAND_LANTERN_ATTACHMENT_QA.md`.

## 2026-10-18 — D233: rich Sentinel 4-frame idle cutout-motion proof, no fake 25-pose completion

- Continued D232 illustrated spear Sentinel visual recovery work without treating user «прододалжай» as artistic F6 approval.
- Added deterministic `tools/art/author_road_sentinel_d233_idle_proof.py`: reads **tracked D232 original source**, masks/sways hanging lantern and outer cloak independently, flickers amber glass, strengthens thin spear-wood continuity, generates **four** distinctive idle-only true RGBA 96px tiles + **26 transparent** slots, lossless 576×480 WebP/B64. Reproduced byte-for-byte from repo source and checked alpha margins/uniqueness in `docs/qa/D233_SENTINEL_CUTOUT_IDLE_QC.json`.
- Added `res://scenes/dev/black_lantern_sentinel_d233_idle_cutout_proof.tscn` with D232 still LEFT vs D233 moving 4-IDLE RIGHT, x3/x1, both directions, pause/resume on exact D209 arena. Native Godot F6 pending. **This is an illustration-cutout motion study, NOT 25 hand-authored full-body poses; walk/attack/hit/death have not been done.**
- No changes to `BattleUnit`, `MisdealUnitAnimationLibrary`, active #38, original D200/D209 art or frozen KARAMBA73. Live Act1 37/45. `docs/D233_SENTINEL_IDLE_CUTOUT_PROOF.md`.

## 2026-10-18 — D232: one high-fidelity Sentinel 96px still and real Godot-scale comparison

- Avoided repeating the D215–D229 error of calling procedural/test-pose sprites visually final. Generated new Style-B long pointed spear/hood/rust-plate/amber-lantern references; rejected decorative multi-panel `25 frames` compositions as NON-Godot animation atlases.
- Isolated **ONE** individual figure from the illustrated reference, cleaned background alpha and nearest-scaled to 96×96. Original 115×129 cutout plus versioned single transparent WebP/Base64 committed as `assets/pixel/units/black_lantern_road_qa/road_sentinel_d232_{reference_cutout,single_96px}.webp.b64`; alpha bounds and lossless verification recorded in `docs/qa/D232_ROAD_SENTINEL_SINGLE_POSE_QC.json`.
- Added `res://scenes/dev/black_lantern_sentinel_d232_art_direction_preview.tscn` (D229 LEFT vs D232 ONE-POSE RIGHT, each x3 and true x1, exact approved D209 forest). **User-native F6/art decision still pending**, no fake 25 pose scenes or full combat claims.
- `MisdealUnitAnimationLibrary` and 37-card ordinary deck remain unchanged; sprite art finality still OPEN for Sentinel and four other role designs. Full handoff `docs/D232_SENTINEL_SINGLE_FRAME_ART_REVIEW.md`.

## 2026-10-18 — D231: Correct D230 premature Sentinel sprite-art 'FINAL' claim

- User explicitly objected that original atlas was much more beautiful than the newly registered sprite and asked what happened. Inspected actual local originals: `пиксельный_атлас_скелета_стража.png` **1254×1254** has far richer armor/cloak/lantern but incorrectly carries an **AXE**, and D221 accepted `лунный_страж_проклятой_дороги.png` **1672×941** has valid long spear but embedded presentation/background. Neither was transformed into transparent 25-frame game atlas; D229 was procedurally painted from geometric code and looks much simpler.
- Corrected acceptance boundary: the user chose D229 over D228 within two TECHNICAL 96px drafts, **not** as permission to abandon the rich final art quality. D230 art-final statement **superseded** by explicit user concern. D230 selected candidate/loader is retained as unused #38-only staging, not a visually finalized approved sprite; 37 cards live unaffected.
- New full handoff `docs/D231_SENTINEL_ART_FIDELITY_CORRECTION.md`. NEXT: verify appealing spear-bearing armor and lantern in single true game-scale frame, not yet another simplistic 25-pose version; then genuinely new high-quality 25-cel asset with native QA and later #38 integration. No actual art or release code changed by this correction.

## 2026-10-18 — D230: User final choice for second D229 Sentinel; exact production animation registration

- User explicitly selected **D229 SECOND (RIGHT) side-by-side Road Sentinel** as final art («давай примем 2 вариант и уже закончим с этим»). **Stop further Sentinel cosmetic passes**; D221 detailed concept remains historical inspiration only, not permission to override current final user selection.
- Promoted the **identical** approved original 25-frame WebP/Base64 atlas into `assets/pixel/units/deck_expansion_v1/road_sentinel_frames.webp.b64`. Source/canonical GitHub re-fetch comparison exact, no resizing or painting changes.
- Registered only `road_sentinel` in `scripts/battle/unit_animation_library.gd`, adding strong original-frame count/uniqueness/padding/unused-tile validation without touching other character art or Act1 card IDs.
- Corrected `scripts/battle/unit.gd` role-specific LEFT-authored atlas flipping for enemy-to-hero target facing; old combat roles behave unchanged.
- Added `res://scenes/dev/black_lantern_sentinel_d230_approved_smoke.tscn` with actual animation library source + final atlas identity check and five synchronized states at 3×/1× in both directions. **Native F6 still not received**, this is engine integration verification pending, NOT another artwork approval vote.
- Full milestone documentation: `docs/D230_ROAD_SENTINEL_FINAL_APPROVAL.md`. #38 still QA-only, Act1 37/45; other 4 enemies require final artwork and real battle route QA; KARAMBA73 untouched.

## 2026-10-18 — D229: side-by-side old/new Road Sentinel native-scale animation gallery

- User instructed continue after D228 art staging without confirming its native F6; retained D228 status as **pending**, NOT implicit PASS.
- Repainted native 96px forge-steel chest planes, segmented pauldron, hood edge and pointed spear highlight on all 25 pose-authored cels. D229 transparent WebP/Base64 original 576×480 6×5, 25 unique+5 empty, zero 2px cell-edge warnings, bit-exact PNG/WebP; 12,880 different RGBA pixels vs D228. Source `tools/art/author_road_sentinel_d229.py`, art `assets/pixel/units/black_lantern_road_qa/road_sentinel_d229_art_candidate.webp.b64`, QC `docs/qa/D229_ROAD_SENTINEL_ART_QC.json`.
- New `res://scenes/dev/black_lantern_sentinel_d229_compare.tscn` side-by-side real x1 plus x3 art comparison (D228 left vs D229 right, all 5 animations and both facing buttons synchronized) on exact approved D209 forest. No new production sprite switching.
- Actual x1 aesthetic improvement remains subtle; final user approved D221 Style B detail bar NOT met/declared passed. Native F6 pending. Keep original armor SPEAR, 5 skeleton roles and 37-card live pool untouched; frozen KARAMBA73 preserved. See `docs/D229_SENTINEL_NATIVE_SCALE_AB_REVIEW.md`.

## 2026-10-17 — D228: Road Sentinel original armor/cloth/spear/lantern pixel art pass

- Continued user's selected original D228 polish pipeline rather than distributing effort across other skeletons; no artwork choices re-opened.
- Reauthored native pixel geometry in **all 25** Sentinel state cels through new self-contained `tools/art/author_road_sentinel_d228.py`: irregular layered forged cuirass and pauldron, ripped oxblood mantle, real narrow steel spear with strapped shaft and short trailing ribbon, metal-caged Gothic amber lantern, while keeping original physically different walk/thrust/hit/death poses.
- Committed QA-only `assets/pixel/units/black_lantern_road_qa/road_sentinel_d228_art_candidate.webp.b64`, `docs/qa/D228_ROAD_SENTINEL_ART_QC.json`; **25 individual frames, 5 fully alpha-clear cells, 0 border warnings**, changed 29,154 RGBA pixels vs D227. Transparent WebP SHA `7ef8f0833a17d06812f7f472b8946f2bdcadc49dd3c0caf28f91adc750663322`.
- Added `res://scenes/dev/black_lantern_sentinel_d228_art_preview.tscn` and its GDScript with 3x/x1 gallery, both facing buttons, five animations on exact D209 forest. **Native F6 and final Style B art acceptance pending**, D227 preserved for comparison; no production sprite registration or real #38 release.
- Added `docs/D228_SENTINEL_ORNAMENTAL_PIXEL_ART_QA.md`, updated source-of-truth handoff. Act1 live 37/45; D196/D200/D209, boss XIII and KARAMBA73 untouched.

## 2026-10-17 — D227: Native 25-frame original Sentinel detail repaint and F6 staging

- User «хорошо» approved proceeding from D226 screenshot feedback; NOT final D226 art acceptance.
- Enhanced 25 individually posed Sentinel sprite cels with actual 96px-authored asymmetric plate armor, skull depth, mottled oxblood layered cloth, reinforced spear tip, moved iron-caged separate amber hanging lantern, guard boots; same authentic walk/thrust/hit/death pose logic. No image generator's wrong-role panel imported, no source sheet resampling.
- Added new versioned `tools/art/author_road_sentinel_d227.py`, QA asset `assets/pixel/units/black_lantern_road_qa/road_sentinel_d227_art_candidate.webp.b64`, `docs/qa/D227_ROAD_SENTINEL_ART_QC.json`. Offline validated **576×480 RGBA, 25 distinct authentic frames, 5 alpha-empty cels, zero 2px edge warnings**; WebP SHA `f1b50b919c76f5af9173ea33c77e484188077dbd72aee98110329210d84f7fbc`.
- Added `res://scenes/dev/black_lantern_sentinel_d227_art_preview.tscn` for two facing directions and all five animation states on approved D209 forest. **Native Godot F6 and polished D221 art fidelity acceptance PENDING.**
- D226 candidate preserved, runtime Battle/UnitData/RunState/forest/other 37 live cards/KARAMBA73 unchanged. Full checkpoint: `docs/D227_SENTINEL_PIXEL_FIDELITY_QA.md`.

## 2026-10-17 — D226 native screenshot result and D227 fidelity gap

- User sent actual Godot screenshot of `black_lantern_sentinel_d226_art_preview.tscn`: accepted D209 arena and both 3×/1× Sentinel views visible; shown `ХОДЬБА · ← ВЛЕВО` with no red QA error. Confirmed **gallery loads and left-facing walk pose displays**; cannot infer complete 5-state animation/right-facing PASS from a still.
- Art inspection: D226 is still visually technical/simplified compared to selected D221 highly detailed style-B armored spear Sentinel — thin/plain skull/chest shapes, flat iron, simple square lamp and insufficient native x1 detailing. **NO final-art acceptance**. Next is genuine artwork improvement to all 25 native 96px poses, not interpolation, forced rescale or toggling pixel filter. Original D226 retained for comparison.
- Only documentation changed in this pass. No production asset/animation library, arena, Battle, card pool, or immutable KARAMBA73 changed.

## 2026-10-17 — D226: Sentinel B-style native pixel art and new two-facing F6 scene

- User responded «все ок. давай дальше» to the D225 left/right Bearer gallery test; noted user-reported direction QA PASS, not full final-art/gameplay integration.
- Art generation initially produced a wrong Oil Acolyte presentation board; REJECTED with no import or misleading sprite claim.
- Authored new original per-frame Road Sentinel **96×96** pixel details using existing D215 pose/movement joints with rich rust-red cloth, deep hood and layered copper iron; kept real pointed spear + small amber lantern. Full **25 separate poses**, 5 empty/transparent unused slots, **0 edge warnings**, no rescaling-induced blur. `tools/art/author_road_sentinel_d226.py`, `assets/pixel/units/black_lantern_road_qa/road_sentinel_d226_art_candidate.webp.b64`, and machine-readable `docs/qa/D226_ROAD_SENTINEL_ART_QC.json`.
- Dedicated `res://scenes/dev/black_lantern_sentinel_d226_art_preview.tscn` + GDScript with both left/right directions, enlarged/native views, all five states on exact D209 arena. **User-native F6/final art fidelity acceptance pending.**
- Added `docs/D226_SENTINEL_STYLE_B_ART_QA.md` and updated context. No live sprites, Battle, deck #38, D196 surf, D200 card art, D209 arena, DS2 or frozen KARAMBA73 changed.

## 2026-10-17 — D225: Both-direction Lantern Bearer art gallery for native QA

- User D224 Godot screenshot confirms original accepted shield-and-handheld-lantern B art loaded at x3 and x1, with shield-attack shown and no red QA error; it does not prove every state or both directions.
- User asked whether animation was bidirectional and agreed to add preview controls. Read `scripts/battle/unit.gd` target-facing code; actual battle already uses `art_sprite.flip_h` but the isolated D224 gallery did not.
- Added `← ВЛЕВО` and `ВПРАВО →` buttons to **same** D224 Godot QA scene script; both sprites mirror together, label indicates active direction, start facing left toward heroes. No separate 25 frames needed. **Native Godot after change pending.**
- Reconfirmed both previews already use `TEXTURE_FILTER_NEAREST` and x3 integer scale; visible softness is inherited from downsampling original 1374×1145 illustration into 96px frames, so did not claim a fake filtering fix or modify locked art.
- Added `docs/D225_BEARER_FACING_PIXEL_CLARITY_QA.md` and aligned handoff/state/roadmap/decisions. No production Battle, source image, live 37-card pool or KARAMBA73 change.

## 2026-10-17 — D224: approved original 25-pose Bearer art preserved, standalone native grid QA

- User approved D223 corrected Bearer design («да все ок») and new dark-fantasy style-B 25-pose shield/hand-lantern original image («подходит»). Saved selected **1374×1145 PNG-visible pixels losslessly as WebP/B64** in GitHub QA asset `lantern_bearer_d224_approved_original_lossless.webp.b64`; PNG and WebP origin hashes in `docs/D224_LANTERN_BEARER_APPROVED_ART_QA.md`.
- Adaptive-repacked the image to Godot 576×480 6×5×96px and committed `lantern_bearer_d224_approved_repacked_candidate.webp.b64`: 25 unique pose cels, 5 empty clear slots, 0 new 2px border failures, byte-verified against GH upload. The source layout includes **overlapping neighboring cel artwork**; cropping may lose individual source pixels, so these metrics are technical QC only, not native art QA approval.
- Added reproducible `tools/art/inspect_and_repack_lantern_bearer_d224.py`, QA source/region data `docs/qa/D224_LANTERN_BEARER_ART_QC.json`, and isolated original-style Godot gallery `res://scenes/dev/black_lantern_bearer_d224_art_preview.tscn`, with 3×/1× state buttons; **Godot F6 PENDING**.
- No changes to older D216 candidate, active animation library, real Battle, approved D209 arena, RunState 37-card pool, D196 waves, DS2, sealed boss or frozen KARAMBA73. D224 documentation added and handoff updated.

## 2026-10-17 — D223: corrected Lantern Bearer shield + separate lantern visual candidate

- After D222 rejected staff-bearing generated layouts, produced a new style-B Bearer composition and a cleanly **cropped, text-free character reference** `Misdeal_D223_Lantern_Bearer_Concept_B_Portrait.png` (388×386). Heavy iron-banded plank shield in one hand and an amber lantern in the separate free hand; no staff or spear. The background is still baked into the concept image.
- Presented design to user for **visual approval pending**. Not a native transparent atlas/25 frames, not committed as game art, no QA sprite replacement or card #38 release. Authored `docs/D223_LANTERN_BEARER_CORRECTED_CONCEPT.md` with source/crop SHA and next production gate.
- Retain D221 accepted Sentinel B look, D209 exact forest, normal pool 37/45 and frozen KARAMBA73.

## 2026-10-17 — D222: Lantern Bearer final-appearance concepts blocked by art QA

- After user requested to continue, attempted three B-style Lantern Bearer illustrations. All mistakenly added a long staff/diagonal pole and mounted lamp on wooden shield rather than separate heavy hand-carried lantern; assistant rejected concepts without requesting user accept compromised design. Those image panels contain simulated frame sheets and are **not actual 25-cel original sprites**.
- Logged precise rejection and next standalone full-body character look in `docs/D222_LANTERN_BEARER_FINAL_ART_REVIEW.md`; no art binary, Godot code, UnitData or release pool changes. Sentinel B look approval preserved; #38 QA-only, 37/45 cards live.

## 2026-10-17 — D221: group style B and detailed Sentinel character art accepted

- User selected illustration **B** as the cohesive dark-fantasy pixel direction for all 5 skeletons and replied «отлично» to the separately rendered plated/hooded long-spear Road Sentinel with suspended lamp.
- Approved the **visual character direction only**. The multi-scale concept image includes scene background and labels, **NOT a production 25-frame 6×5 transparent atlas**; no game art bytes or runtime animation registration changed.
- Added `docs/D221_SENTINEL_FINAL_STYLE_APPROVAL.md`; next character visual concept is Lantern Bearer in the same style, followed by real source-cel repaint/user approval. Live Act1 37/45, all other scenes and KARAMBA73 preserved.

## 2026-10-17 — D220: Isolated D219 user OK and hard final-art replacement gate

- User replied «все ок» after D219 standalone Lantern Archer preview F6 request. Treat as user-reported QA success only, not a full five-role motion video/production art acceptance.
- User explicitly asked whether five simple character sprites would later be replaced; confirmed YES. Locked that D215–D219 procedural 25-cel atlases are **temporary QA versions** and that ALL FIVE must be newly drawn to production dark-fantasy pixel-art quality, with real-size composition approval on D209 exact chosen forest BEFORE connecting finished characters into active battle/card #38. Preserve role-specific weapons/features, authentic 25 poses, alpha/foot QC; no upscaling or recycled skeleton sprites.
- Added `docs/D220_BLACK_LANTERN_FINAL_SPRITE_REPLACEMENT_GATE.md`; all changes to docs only. Act1 live 37/45, `RunState` and frozen KARAMBA73 unchanged.

## 2026-10-17 — D219: fifth original Lantern Archer 25-frame candidate and F6 gallery

- User gave positive feedback «отлично» after D218 Guide F6 request. This permits proceeding; native D218 full five-state motion still has no supplied detailed log.
- Created genuine QA-only 25-frame `lantern_archer` pixel-art atlas with curved bow, quiver, amber lantern, specifically differentiated six-frame draw/loose animation, two-grounded-step walk, recoil and collapse. Correct 576×480 alpha 6×5/96px in `assets/pixel/units/black_lantern_road_qa/lantern_archer_d219_candidate.webp.b64`, original reproducible `tools/art/author_lantern_archer_d219.py`.
- Addressed original bottom-bleeding death poses and unnatural upright quiver before export. Offline: 25 distinct nonempty, 5 unused transparent, zero 2px-border flags; GitHub Base64 exact text equality verified against local QA output.
- Added **QA-only** `res://scenes/dev/black_lantern_archer_animation_preview.tscn` / GDScript showing 3×/1× on accepted D209 arena with strict live image validation and five animation controls. Native F6 pending. No live sprite library, Battle, UnitData, projectile, card pool or KARAMBA73 changes. Detailed `docs/D219_LANTERN_ARCHER_ANIMATION_QA.md`.

## 2026-10-17 — D218 original towering Guide art/source and QA-only F6 gallery; D217 native post-fix PASS

- User replied «все ок» after the D217 original SVG death border fix and exact Godot F6 retest request. Treat D217 isolated user-native QA as PASS, not real combat.
- Added `tools/art/author_extinguished_guide_d218.py` (original 25 hand-directed pixel-frame configurations) and `assets/pixel/units/black_lantern_road_qa/extinguished_guide_d218_candidate.webp.b64`: 576×480 lossless alpha/WebP B64, 25 distinct populated cels, 5 entirely unused, zero offline alpha-boundary warnings after correcting original death drawing on extended canvas. Model has ragged large mantle, irregular armored shoulders, three chained lanterns on metal yoke, heavy attack/collapse.
- Added `scripts/dev/black_lantern_guide_animation_preview.gd` + `scenes/dev/black_lantern_guide_animation_preview.tscn`: exact D209 forest, original 1.8× Guide next to 1× Bearer at matched floor level, 2.8× detail and five QA state buttons with strict on-load checks. User-native D218 F6 pending; not a final battle-art approval. `docs/D218_EXTINGUISHED_GUIDE_ANIMATION_QA.md`.
- No production animation registry, collider, five-enemy stats, light bonuses or card pool changes; baseline 37/45 and KARAMBA73 remain safe.

## 2026-10-17 — D217 Godot border FAIL repaired in SVG art source

- User-native D217 F6 screenshot showed red QA FAIL on 0-based death row4 col4 and col5; backdrop D209 loaded fine. Investigated committed SVG and found exactly two late-death rib strokes extending into y94–96 outside the approved 96px-cell margin.
- Fixed only these SVG strokes in `assets/pixel/units/black_lantern_road_qa/oil_acolyte_d217_vector_candidate.svg` (commit `a8a80f1`). No tolerance changes to Godot's 25-frame/5-empty/border validator; post-fix GitHub geometry scan shows 25 groups and no predicted alpha-safe border violations. **Native Godot F6 recheck still pending.**
- Separate user D216 screenshot shows Lantern Bearer gallery renders at 3× + 1× and shield attack frame without red failure; five-state full artistic acceptance still not documented. All runtime scenes, card pool and KARAMBA73 unchanged.

## 2026-10-17 — D217: Oil Acolyte third original animation role, standalone QA only

- Drew a new 25-pose (idle4/walk6/attack6/hit3/death6) 576×480 RGBA Oil Acolyte **raster** candidate: light skeletal ritualist with separate green oil bottle, tiny amber belt lamp and curved open **sickle** instead of an early cleaver-like blade. Offline Pillow QA after edge fixes: 25 distinct visible, five transparent unused, zero edge contacts. This local raster PNG/WebP/B64 plus reproducible authoring code is available in a conversation ZIP, not committed as engine bytes.
- Added a **separate** original editable, transparent 25-state 576×480 SVG vector-cel QA candidate in GitHub: `assets/pixel/units/black_lantern_road_qa/oil_acolyte_d217_vector_candidate.svg`. Its graphics are **not byte-identical** to the raster candidate; do not substitute one QA result for another.
- Added `scenes/dev/black_lantern_oil_acolyte_animation_preview.tscn` and script; renders GitHub SVG using Godot SVG image decoder, does native post-decoding alpha/25-unique/5-blank/border inspections and displays all five states on the D209 accepted forest at 3× and 1×. **Godot F6 pending**.
- No new oil-burning mechanics, no modifications to `UnitData` stats, production animation library or live battle. D216 Bearer native F6 **still pending**, D215 Sentinel user accepted QA; deck remains 37/45, KARAMBA73 untouched. Detailed `docs/D217_OIL_ACOLYTE_ANIMATION_QA.md`.

## 2026-10-17 — D216: native D215 OK and QA-only 25-cel Lantern Bearer animation art

- User replied **«все ок продолжай дальше»** after D215 Road Sentinel animation gallery review; record user-native standalone gallery QA OK, not #38 battle release.
- Drew completely new flat pixel-art **Lantern Bearer** 576×480 RGBA row-per-state (idle4, walk6, attack6, hit3, death6), 25 individually articulated poses with wooden barricade shield and separately swinging amber lantern; 5 transparent unused cells and **zero border contact warnings** after shifting last falling poses.
- Committed lossless WebP/B64 under **QA-only** `assets/pixel/units/black_lantern_road_qa/lantern_bearer_d216_candidate.webp.b64`, confirmed GitHub encoded bytes match local source, source `tools/art/author_lantern_bearer_d216.py`, plus `res://scenes/dev/black_lantern_bearer_animation_preview.tscn` and controller. F6 native visual PASS **NOT YET REPORTED**.
- No shield mechanics, UnitData stat changes, production SpriteFrames registration, battle logic or regular deck changes. Detailed `docs/D216_LANTERN_BEARER_ANIMATION_QA.md`; Act1 37/45 and frozen `КАРАМБА73` preserved.

## 2026-10-17 — D215: First genuine spear Sentinel 25-frame QA candidate and native animation gallery

- Produced original 576×480 RGBA 6×5 atlas for D211 user-selected armored `road_sentinel`, through authored native-pixel limb/armor/spear/lantern cels rather than rescanning the rejected 5×5 axe sheet. **25 unique nonempty poses**, 5 alpha-empty, **zero cell-margin warnings** after death sprite adjustment; correct animation rows (4/6/6/3/6). First draft artistic fidelity is intentionally not described as user-approved.
- Committed lossless WebP/Base64 `assets/pixel/units/black_lantern_road_qa/road_sentinel_d215_candidate.webp.b64` and the reproducible offline `tools/art/author_road_sentinel_d215.py`. GitHub B64 matches generated source exact bytes.
- Added isolated F6 `scenes/dev/black_lantern_sentinel_animation_preview.tscn` and GDScript gallery, loads accepted D209 backdrop, performs cell checks and presents 3×/1× animations with state buttons. **Godot native test and final art sign-off pending**; no live animation library, battle scripts, UnitData or card pool changed.
- Current art QA gate: `docs/D215_SENTINEL_NATIVE_ANIMATION_QA.md`. Preserve accepted D200/D209 artwork and KARAMBA73. Live Act1 **37/45**.

## 2026-10-17 — D213/D214: Canonical original-animation master, full Lantern Bearer production spec

- User chose **D211 Armored Spear Sentinel option A** («а»), concept silhouette LOCKED only; five final sprite atlases remain uncreated/unapproved.
- Read actual `scripts/battle/unit_animation_library.gd` and found old chat's D212/D213 **sequential row-major** atlas layout contradicts the real per-state-row loader. Documented correct 576×480 RGBA, 6×5 cells, `idle4+2empty` / `walk6` / `attack6` / `hit3+3empty` / `death6`, 25 authored cels in `docs/D213_BLACK_LANTERN_MASTER_ANIMATION_BRIEF.md`. Do not use contradictory old chat diagram.
- Added `docs/D214_LANTERN_BEARER_PRODUCTION_SPEC.md`: thick-boned shield/plank escort with heavy lantern, detailed 25 individual animation-pose instructions, row-level correct Godot layout, alpha margins/leg placement/source-art/orientation QA and acceptance conditions. **Art brief only; no new shield gameplay.**
- Synchronized docs/DECISIONS, ROADMAP, PROJECT_STATE, HANDOFF and INDEX to preserve user approvals across chats. **No `.gd`/`.tres`/runtime sprite assets modified; Act1 37/45; D209 accepted forest and KARAMBA73 untouched.**

## 2026-10-17 — D211: Spear Sentinel A/B illustrated alternatives (art direction only)

- Created two isolated pixel-art **character silhouette concept crops**, both correctly show a LONG SPEAR unlike rejected D205 axe: A armored pauldron/lantern on shaft and B ragged hood/lantern on shaft. Comparison board `Misdeal_D211_Road_Sentinel_Concept_Options.png` contains native 96px cell scale sanity checks; source and board exist as conversation art only.
- **No real 25-frame atlas**, no isolated-alpha sprite and no native character motion approval; both diagonal spears reduce readable body size when forcing 96×96. User design choice A/B pending; next actual production needs new cel-accurate spearman, not cropping the concept sheet.
- Added `docs/D211_ROAD_SENTINEL_SPEAR_CONCEPT_OPTIONS.md` with strict exact-art/animation gate. No combat, card pool, accepted D209 arena or frozen KARAMBA73 changes.

## 2026-10-17 — D210: User-native D209 forest layout PASS; five-animation-sheet art audit

- User supplied screenshot of `black_lantern_road_arena_visual_preview.tscn` with correct third forest artwork, 3 hero + 5 enemy proxies, 2 legible light pools and replied «все ок». **D209 Godot visual-composition PASS** (not actual sprites/combat).
- Inspected all five D205 skeleton 5×5 concept atlases and their technical 6×5 remaps. Created conversation-only `Misdeal_D210_Animation_Review.png` and a QA ZIP/JSON summarizing states and frame-boundary warning counts 13/20/24/21/13; warns of Sentinel axe vs approved spear, missing distinctive bearer rig and oil-acolyte silhouette work. Art remains blocked; original animations not yet approved.
- Added `docs/D210_BLACK_LANTERN_ANIMATION_ART_QA.md` with acceptance contract; no new production sprite bytes, card pool changes, live combat wiring or changes to approved forest artwork. Baseline **37/45**, KARAMBA73 frozen.

## 2026-10-17 — D209: user-selected exact forest arena added to GitHub, native QA scene

- Imported **exact previously user-selected third** moonlit forest source as 1280×720 WebP/Base64 `assets/pixel/battle/arenas/black_lantern_road_arena_selected_v1.webp.b64`; 170,424 decoded bytes. Verified fetched GitHub blob SHA matches independently computed export Git blob SHA `6fad8192e4e2a9baa308db82e0ce84beeeb167ad`. No new art generation or substitute.
- Registered `black_lantern_road` in existing `scripts/battle/authored_backdrop.gd` loader without redirecting existing arenas, normal Battle scene or ordinary card offers.
- Added QA-only native `res://scenes/dev/black_lantern_road_arena_visual_preview.tscn` with the exact forest background, actual D206 lanternlight geometry/cue under 3 hero/5 enemy foot-contact envelopes (2× Guide), floor and pause controls. **Godot F6 not yet run**; not a playable card, rendered skeleton animation or art signoff.
- Details, hashes and next user test `docs/D209_BLACK_LANTERN_ARENA_NATIVE_QA.md`. D208 +22% speed trial remained reverted to +16%; live Act1 37/45 and frozen KARAMBA73 untouched.

## 2026-10-17 — D208 native QA PASS and local balance rollback

- User-provided Godot screenshot: D208 +22% scoped light trial **54/54 functional PASS**; 54 wins, zero defeats/timeouts, unchanged average HP 80/70/74%, worst HP 52/30/44%, and 13.2/14.6/13.3-second mean battles compared with D207 +16% (rounded displayed metrics).
- Measured actual attack exposure: **635 real enemy attacks, 59 under light (9.3%)**; 90 warnings, 11,433 active frames, 15,510 enemy-buffed frames, maximum 3 simultaneously lit. Increased raw attack-speed multiplier did not yield measurable aggregate difficulty difference at display precision.
- **Reverted +22% to prior validated +16%** in `scripts/battle/black_lantern_light.gd` (commit `cc624e3`), retaining D208 instrumentation for future route/zone timing analysis. No new post-revert instrumented native F6 is claimed.
- Next focus exact approved moonlit-forest backdrop/5 original skeletal atlas corrections and native readability, not stat inflation. Existing releases and KARAMBA73 untouched.

## 2026-10-17 — D208: Native D207 54/54 baseline and local light-risk pass

- User's real Godot screenshot confirms D207 54/54 completed, 54 wins, no party defeats or timeouts; 18 wins each by class and party size. HP avg 80/70/74%, worst 52/30/44%; individual deaths 0/2/4, durations 13.2/14.6/13.3s. Light 90 telegraphs, 11,434 active frames, 15,502 buffed-enemy exposure frames, max three buffed. Distinguish functional PASS from accepted difficulty/art.
- Made one controlled local change: `BlackLanternLightController.ATTACK_SPEED_MULTIPLIER` **1.16 → 1.22** for *lit enemies only*, no five-enemy global stat inflation or changes to existing live battles.
- Extended existing D207 54-case F6 matrix to label D208 and count *actual light-buffed enemy attacks* from existing `BattleUnit.diagnostic_attack`; new D208 Godot run pending. Full before/after source/QA notes: `docs/D208_BLACK_LANTERN_BALANCE_PASS.md`.
- Act1 stays 37/45, `КАРАМБА73` preserved, new arena/skeleton art still not imported/accepted.

## 2026-10-17 — D207: Native D206 contract PASS, isolated 54-case battle matrix staged

- User supplied **green native Godot F6 screenshot** confirming D206 five new UnitData, two five-enemy formations and enemy-only temporary light-buff/reset after typed-array fix.
- Added `scripts/dev/black_lantern_road_battle_matrix.gd` + `scenes/dev/black_lantern_road_battle_matrix.tscn`: deterministic **54 cases** with actual BattleUnit AI, 2 formations, Knight/Ranger/Mage, solo/duo/trio and 3 tactical orders, plus D206 scoped lanternlight. Captures wins/losses/timeouts, surviving HP, durations, casualties, illuminated enemy exposure, movement/clamp and buff cleanup.
- This is **diagnostic QA only**; battle simulation runs invisibly so no unfinished original enemy art is displayed or replaced by recycled sprites. No regular pool/real Battle route/source mechanics touched. D207 native F6 pending; code/source checks are not gameplay balance approval. Full contract: `docs/D207_BLACK_LANTERN_BATTLE_MATRIX.md`.
- Preserve existing live Act1 37/45, D196 waves and frozen KARAMBA73 checkpoint.

## 2026-10-16 — D206 hotfix: typed lanternlight arrays in Godot 4.7.2

- User-native F6 screenshot: runtime error in `scripts/battle/black_lantern_light.gd:109`, `Trying to assign an array of type "Array" to a variable of type "Array[Vector2]"`. Root cause was the conditional `get_pool_centers() if active else []` promoting the empty branch to an untyped array.
- Updated the staged encounter-only controller: initialize a strictly typed `Array[Vector2]` first, conditionally populate it, and avoid conditional expressions for typed zone arrays/returns. **Only the isolated QA light controller was changed**; regular battle remains untouched.
- Fixed in GitHub commit `9f751e7`; source review completed, **Godot-native F6 re-test pending**. Do not mark D206 smoke passed until user re-runs `res://scenes/dev/black_lantern_road_contract_smoke.tscn`.

## 2026-10-16 — D206: New five-enemy encounter data and scoped lanternlight source (QA-only)

- Created five **original** unbalanced `UnitData` candidates for `extinguished_guide`, `lantern_bearer`, `road_sentinel`, `oil_acolyte`, `lantern_archer`, plus a standalone `EncounterData` with two five-unit formations within existing battle bounds.
- Implemented independent, deterministic `BlackLanternLightController` (two moving light pools, telegraph, enemy-only temporary attack-interval multiplier, cleanup/reset). **Not wired into live battle or cards**; provisional parameters pending art and native balance.
- Added Godot F6 `black_lantern_road_contract_smoke.tscn` to verify resource identity, formations, buff scope and cleanup. Source committed, native run **NOT CONFIRMED**.
- Converted the user-selected exact option-3 forest scene to local 1280×720 WebP; exact original bytes and conversion hashes documented. **Neither local bitmap nor unresolved 5-role art candidates imported into GitHub.** Existing #34–#37, D196, DS2, Fate Spread and fixed `КАРАМБА73` backup preserved.
- Full contract and next handoff in `docs/D206_BLACK_LANTERN_ENCOUNTER_STAGING.md`. Live Act1 stays **37/45**, #38 QA-only.

## 2026-10-16 — D205 hotfix: Godot 4.7 parser type inference in lantern preview

- User screenshot showed Godot 4.7.2 parse error at `black_lantern_road_light_preview.gd:121`: implicit `opacity` inference from `abs(sin(...))` failed. Fixed with explicitly typed `float`, `absf()` and typed `v`/`eased` to prevent nearby inference issues. **Native re-test still pending**; change limited to isolated dev scene, no combat behavior or card pool changes.

## 2026-10-16 — D205: Selected forest artwork and isolated moving-lanternlight QA preview

- User selected **A: dead-forest bend** geography and then **the third** of 3 finished forest arena images (`лунная_дорога_через_туманный_лес.png`, 1672×941). Preserve as the selected scene source; no bitmap upload/engine stage claimed.
- Inspected five recent character concept sheets, each 1254×1254 RGBA in 5×5 format; remapped them offline to 576×480 6×5 candidate atlases, 25 distinct nonblank cells each with five blank cells. Detected 13/20/24/21/13 source-cell boundary risks and Sentinel's axe instead of approved spear. The generated animation QA pack is a chat artifact, not activated production media.
- Added offline developer helper `scripts/dev/stage_black_lantern_art.py` for deterministic candidate staging. **No new art bytes committed or live `unit_animation_library.gd` roles changed.**
- Added stand-alone QA-only `res://scenes/dev/black_lantern_road_light_preview.tscn` and controller. Two travelling pools, warning and pause button are demo-only; no combat buffs/damage/spawn/routing. Native F6 **NOT RUN**.
- Captured exact gates in `docs/D205_BLACK_LANTERN_ASSET_AND_LIGHT_STAGING.md`. Act1 **37/45**, #38 remains QA-only, `КАРАМБА73` frozen checkpoint untouched.

## 2026-10-16 — D204: Present three composition-only Black Lantern arena geographies

- Audited active repository and applied the four supplied DARK FORGE skill briefs. Rejected two accidental roadmap/infographic generations as unsuitable arena artwork; no incorrect bitmap enters the game.
- Created three distinct **conversation-only** 1280×720 pixel-style blockout PNGs: dead-forest bend, peat ford with dry central combat strip, and broken toll gate. Verified pixel dimensions and inspected the composition. These are technical **layout drafts**, not production background art and not user-approved assets.
- Documented A/B/C concepts and exact next art-approval gate in `docs/D204_BLACK_LANTERN_ARENA_BLOCKOUT_OPTIONS.md` and canonical handoff. **No runtime source/assets/Act1 pool changed**; frozen KARAMBA73 untouched, #38 still QA-only, Act1 37/45.

## 2026-10-16 — D203: Specialist-skill review of Black Lantern arena composition and combat clearance

- Read three user-supplied dark-fantasy designer, game-artist and developer SKILL.md archives and the art-style/QA references; project rules still override defaults.
- Rejected repeated fortress-on-hill/viaduct castle-scene generations as **not genuinely distinct** dark-forest arena options. No unapproved art imported.
- Verified existing D201 option #2 PNG at native 1280×720 and created a **conversation-only transparent staging-overlay test** with 3 hero proxies, 5 enemy proxies (2× Guide) and illustrative twin amber lantern zones. Floor region is derived from actual `battle.gd` coordinates; this is NOT Godot native F6 or implementation of the light mechanic.
- Documented 3 meaningful environment alternatives and artist/developer release criteria in `docs/D203_BLACK_LANTERN_ARENA_ART_QA.md`. Live Act1 remains **37/45**, card #38 QA-only, original D200 art and KARAMBA73 frozen restore branches unchanged.

## 2026-10-16 — D202: Freeze KARAMBA73 full GitHub-tracked project checkpoint

- User requested an explicit whole-project/context restore point tied to the recovery word **КАРАМБА73**.
- Frozen snapshot branch: `backups/KARAMBA73-2026-10-16`, including **all tracked** game code, scenes, Resources, `.webp.b64` art, `project.godot`, current docs and full Git commit ancestry. Source game mechanics and artwork unchanged by D202; only manifest/handoff/status/decision/index documentation added.
- Created `docs/checkpoints/KARAMBA73_2026-10-16.md` with the exact saved milestone (live 37/45, #38 QA-only, D200 art accepted, D201 arena approval pending) and **non-destructive** future restore steps: safety branch from then-current `main`, new commit using saved Git tree, no force push.
- Pending D201 concept art images produced in chat are **not part of the tracked game state**; they are not silently substituted as approved arena assets. User's untracked local files/caches likewise are not included in a GitHub snapshot.

## 2026-10-16 — D201: Record native card-art approval and start arena art selection

- User replied «вск ок» after requested native F6 preview of the exact D200 chosen third Black Lantern Road 448×274 card image. Mark **user-reported native card-art approval**; no independent Godot screenshot/log received.
- Next production stage is **2–3 original 1280×720 actor-free arena visual options**, clear road battleground with hanging lamps positioned outside fighter lanes. User must select one before it becomes the battlefield background.
- No gameplay, scripts, live deal registration, selected card art or opponent assets changed in this checkpoint; Act1 stays **37/45**, #38 remains QA-only.

## 2026-10-16 — D200: Install user-selected THIRD lantern-road card art for QA-only review

- User chose **third** of three newer standalone illustrated Lantern Road scenes after approving the five original skeletal enemy designs. Preserved exact chosen image (`лунный_марш_скелетного_легиона.png`) and exported it to text-free **448×274 WebP/Base64**. No rerender, replacement art or text in bitmap.
- Committed `assets/pixel/card_unification_v1/run/black_lantern_road_selected_v1.webp.b64` and strict cached `scripts/ui/card_unification_v1.gd` card-ID override; unchanged existing art catalog/UI.
- Added **QA-only** `resources/cards/black_lantern_road.tres` (Tier1 combat, encounter target still blank) and F6 `res://scenes/dev/black_lantern_road_card_preview.tscn`. It verifies exact 448×274 asset and confirms #38 is NOT in the 37-card live pool.
- **Native art preview QA pending**; arena, five original animation atlases and moving light zones are next. No gameplay/balance/#37 or Fate Spread edits.

## 2026-10-16 — D199: Approve Black Lantern Road five-skeleton concept for card #38

- User selected **gameplay proposal 3**, «Дорога чёрных фонарей» (Tier1 combat), then first among 3 moonlit forest-road image options. Rejected artificial detail noise and required Act1's skeleton-first enemy theme and **more than 3** actual enemy combatants.
- User then approved a cleaner road-scene revision and requested a **roughly 2×-height, truly distinct giant Lantern skeleton**. Last generated encounter/character sheet features **5 new skeletal roles** (large Погасший проводник; Носильщик фонаря; Страж дороги; Масляный служка; Стрелок фонарей). User approved with «последняя концепция подходит».
- Locked these choices in `docs/DECK_EXPANSION_D199_BLACK_LANTERN_ROAD.md`, `docs/DECISIONS.md` and the active roadmap/handoff. Moving, telegraphed lanternlight zones are the unique planned local mechanic; timings/damage stats still not implemented or balanced.
- **Reference sheet contains labels, therefore is NOT an approved runtime card bitmap or animation atlas.** Next production: clean standalone text-free 448×274 scene, walkable arena and five 25-pose original enemy sprites, with explicit art and Godot QA gates.
- **No runtime code or images modified by this documentation phase.** Live Act1 stays **37/45**, D198 released; card #38 remains concept-approved but not live.

## 2026-10-16 — D198 closeout: user-native card #37 release PASS; next D199

- After the requested Godot F6 full-pool `black_crossing_release_smoke.tscn`, the user replied **«все ок»**. Record **user-reported native release PASS** (not an independent engine log/screenshot). D197 Battle→Reward→Table route was already user-confirmed.
- `black_crossing` #37 is fully released in the **37/45** Act 1 pool. D191 54/54 combat still applies; D196 wave VFX remains the user's accepted-for-now presentation. No runtime code/art modifications in this closeout.
- Reconciled active project state, roadmap, encounter QA spec, decisions, visual registry, index and canonical handoff; next task **D199 gameplay concept choices for card #38** (8 cards remaining to reach 45).

## 2026-10-16 — D198: Black Crossing released into the 37-card Act 1 pool

- User confirmed the D197 native route (preflight → real battle → reward → table) with «Все ок». D196 surf is the approved current baseline for continued development; D191 native battle matrix 54/54 remains valid.
- Registered `black_crossing` as live Act1 **#37/45** in `RunState.ACT1_CARD_IDS`; card/encounter resource, scene art, original Ferryman/Drowned animation atlases and scoped wave mechanics unchanged.
- Updated D151, D152, D153, Bone Shepherd, D188 diagnostic/battle/release smoke guards, and legacy card/playtest previews for a **37-card** pool.
- Added `scenes/dev/black_crossing_release_smoke.tscn`: checks 37 unique real cards, originals, real full-pool random Tier1 offers across 80 seeded samples (NOT a forced two-card fixture), choice/completion/Fate Spread and sealed boss XIII.
- **Native D198 release smoke pending** — code in `main`, not yet a Godot PASS. Next: F6 the new scene; upon native PASS move to card #38.

## 2026-10-16 — D197: Black Crossing #37 release-route preflight

- User elected to leave D196 wave VFX as the current baseline and continue progression rather than tune surf further. D196 rendering and D191 battle logic untouched.
- Audited real Battle victory → Reward screen → RunState.complete_active_card() → Table code path. This is a source review, **not** native route confirmation.
- Added `scenes/dev/black_crossing_release_preflight.tscn` with production RunState/asset/encounter/deck/XIII audits and one button to launch real Black Crossing Battle→Reward→Table. Updated the existing Black Crossing playtest to support both QA-only 36/45 and future released 37/45 without changing its encounter routing.
- Kept `black_crossing` outside the ordinary random pool until native real reward route sign-off; D197 Godot preflight/result still pending. No gameplay or approved art changes.

## 2026-10-16 — D196: Advance Black Crossing breakers farther onto intact pier

- User native D195 screenshot: smoother foam, but the waves look static; requested a much more substantial forward-moving storm surge.
- Rendering-only: warning waterline advances from -91 to -62px relative to the foot contact; 1.6s impact begins continuously at -62px, covers 94px on screen rather than 37px, and then spreads semi-transparent, physically bounded runoff with moving broken foam across planks.
- No hitbox, warning/rest/slow timing, 43px left push, -30% movement, encounter stats, sprites, approved art or deck changes; D191 native 54/54 gameplay PASS remains valid. D196 visual F6 + real reward→table still required. Act1 36/45.

## 2026-10-16 — D195: Organic storm foam and breaker decay

- User native D194 Godot screenshot: wave size is an improvement, but evenly spaced light-blue triangular peaks look artificial; requested a professional animation pass.
- Rebuilt **render-only** foam from continuous asymmetric wave contours and three soft rounded irregular clusters per breaker. Denser 72-sample geometry, multiple flowing frequencies, quieter cold-blue tones, foam flecks, and visible wash/recede phase replace repeated polygon teeth.
- No changes to storm art, character animations, encounter balance, floor, wave hit lanes, 43px push, 30%/1.6s slow, or battle results. D191 **native 54/54** remains valid; D195 visual F6 and real reward→table route still require user confirmation, so live Act1 stays 36/45.

## 2026-10-16 — D194: Replace rejected spray scratches with true rolling breaker silhouette

- User D193 Godot screenshot and feedback: prior fragmented foam looked like tiny pale scratches on the deck despite the massive storm; not approved. D192 long turquoise banner was also rejected.
- Rebuilt encounter-only wave rendering as three offset overlapping storm swells with tapered 3D-like faces, raised and curling pale foam tops, animated chop, impact spray and a 38px shoreward sliding wash. Warning is darker and smaller than the impact.
- Left gameplay hit lane, knockback 43px left, 30% slow/1.6s, floor, animations, approved scene backdrop and original enemies **unchanged**. D191 native **54/54 FUNCTIONAL PASS** continues to apply, but D194 still needs Godot visual approval and real reward→table check. Act1 remains 36/45.

## 2026-10-16 — D193: Ground Black Crossing surf on planks

- Native D192 screenshot rejected: prior full-width bright turquoise water band appeared suspended at the far side of the board, above the foot line and distant surf.
- Replaced **only wave drawing** with shallow segmented tapering stormwater washes placed at the animated sole-contact level (+36px from UnitsLayer origin); staggered breaking foamy tongues, restrained bubbles and desaturated low-alpha blues; visible deck gaps throughout.
- No `BlackCrossingFloor`, battle unit, hit lane, push, slow or other combat logic change. D191 native **54/54 gameplay PASS** remains valid; D193 Godot **visual** approval and real reward→table are still outstanding. Live Act1 36/45.

## 2026-10-16 — D192: Fuller breaking surf, native 54-case confirmation

- User native D191 F6 screenshot **54/54 wins, 0 full defeats**; 18 wins for every party size and protagonist, mean HP 86/74/77%, worst 58/42/50%; 78 warnings, 62 wave impacts, 66 pushes and 66 slow resets.
- User real-battle screenshot still showed D189 wave as thin artificial line. Replaced *only* Black Crossing's procedural drawing with layered sea-body polygons, an advancing lifting crest, irregular curled whitecaps, swells, broken wake and restrained spray.
- Left `BlackCrossingSurgeController` gameplay timings, damage, hit lane, push/slow, floor bounds, enemy stats and original approved artwork unchanged. D192 native **visual** F6 is pending; reward→table and #37 release not yet approved. Act1 remains 36/45.

## 2026-10-16 — D191: Black Crossing native-QA parity hardening
- Inspected current GitHub `main` and D190 handoff; D189 surf/floor source exists, native Godot still unavailable in assistant environment.
- Updated Black Crossing 54-case smoke to mirror real battle solo/duo/trio hero spawn positions, floor-depth mapping, and initial placement clamp; replaced artificial hero positions.
- Set explicit release gate of 54/54 wins (not merely 54 completed cases), preserving per-frame plank legality and post-combat slow reset checks.
- No arena/card/unit bitmap, enemy stats, wave behavior, party scaling, or live deck change. Await native F6 playtest + matrix + reward→table confirmation; 36/45 live.

## 2026-10-16 — D190: New-chat checkpoint after D189
- Rechecked live GitHub source; **D189 surf-animation and safe-pier movement correction already committed**, so no duplicate gameplay patch.
- Rewrote canonical `docs/HANDOFF.md` with pre-fix Godot screenshot metrics, the exact two visual issues, D189 code paths and the **post-fix F6 retest still required**.
- Corrected stale status in `PROJECT_STATE` (Black Crossing QA-only `CARD_PATHS` lookup) and stale D187 preview-pending wording. No gameplay, stats or approved art changed; Act1 remains 36/45.

## 2026-10-16 — D189: Black Crossing rolling surf and intact planks fix
- User's native D188 smoke screenshot: historical 54/54 functional PASS (85/78/84% average HP; 81 wave warnings, 58 strikes, 71 pushes and 71 cleanup resets). Separate battle screenshot shows amber rectangle wave and actor soles standing on broken forward beams.
- Replaced overlay rectangles with animated irregular sea foam, crest, water body and spray. Shared `BlackCrossingFloor` gives consistent intact-deck movement bounds for battle spawn/AI, hero drag zone, wave knockback, and 54-case matrix; wave lanes moved to the middle of the deck.
- Strictly local D188 art/geometry change; does not modify enemy HP, run pool or accepted original art. **Native Godot retest after D189 is pending**; prior 54/54 is not a substitute.

## 2026-10-16 — D188: Original Black Crossing battle & scoped wave QA
- User confirmed D187 arena Godot F6 OK; unchanged user-approved selected storm plate and original 25-frame Ferryman/Drowned art.
- Added two unique UnitData and two-placement 1+2 Ferryman/Drowned encounter, QA-only card lookup (not live in Act1), and neutral warned wave strip with bounds-safe push and temporary 30% movement slowdown.
- Added 54-seeded real BattleUnit matrix and isolated real Battle→Reward→Table playtest. Subsequent pre-D189 native matrix confirmed 54/54 functional PASS, but visual/off-floor defects required D189. Act1 remains 36/45.

## 2026-10-16 — D187: Black Crossing storm arena selected and source-integrated
- User approved final clean stormy "Последний причал" after removing the repeated left ruin and right background pier-frame; exported exactly this final image to 1280×720 WebP/Base64.
- Added unique `black_crossing` arena lookup/presentation in existing authored backdrop and visual scripts and clean 1280×720 F6 preview. No crypt atmosphere, no sprites or UI baked into the art.
- Native Godot arena check pending. No encounter waves, enemies/resource data, battle QA or Act1 pool change (36/45).

## 2026-10-15 — D186: Black Crossing original animation visual QA accepted
- User reported «все ок» after F6 for `scenes/dev/black_crossing_animation_preview.tscn`, accepting original Ferryman B and Drowned C five-state animations; no gameplay, art bytes or balance edits needed.
- Began D187 original arena art direction; three distinct 1280×720 battle backdrops to be reviewed before importing anything. Live pool remains 36/45.

## 2026-10-15 — D185: Original Black Crossing combat atlases installed
- Uploaded full Ferryman and Drowned 576×480 atlas WebPs into Godot-compatible tracked `.webp.b64` under `assets/pixel/units/deck_expansion_v1/`; each has 25 distinct/padded cells and 5 unused blank cells verified after local decode.
- Removed visibly disconnected Drowned pixel fragments; retained approved source design and documented one Ferryman derived attack-transition pose.
- Confirmed GitHub blob SHAs match the local encoded raster bytes. Native Godot F6 original-enemy animation acceptance still pending; no #37 encounter, waves, battle or live-pool change.

## 2026-10-15 — D184: Approved Black Crossing combat art and staged original role loader
- User confirmed Ferryman B / Drowned C and approved both generated original animation sprite-sheet previews.
- Locally created two 576×480 atlas candidates, checked 25 distinct alpha-padded poses, five unused transparent cells, documented the Ferryman's originally missing sixth attack pose. Remote raster upload was subsequently completed in D185; native F6 remains unverified.
- Added strict no-fallback D183 role support to MisdealUnitAnimationLibrary and an isolated F6 gallery; **the two `.webp.b64` files have not been committed**. All existing characters, encounters and live pool (36/45) remain untouched.

## 2026-10-15 — D183: Black Crossing card-art native acceptance
- User F6 screenshot + «утверждено»: original third D182 card illustration PASS in the intended 448×274 framing.
- Next combat models need separate silhouette approval, full original 25-frame sprite animation sheets and native QA; no changes to live cards or encounters.
- Current live Act1 **36/45**; release #37 remains gated by original enemies, independent arena, wave mechanic and battle/reward route.

## 2026-10-15 — D182: Black Crossing #37 direction approved, QA-only candidate staged
- User selected new drowned ferryman + two drowned corpse encounter with timed, telegraphed waves, and card-art option #3 (diagonal pier composition).
- Added standalone `resources/cards/black_crossing.tres` and detailed handoff spec; **no live registry/pool change**.
- Approved exact option-3 448×274 image now committed as `black_crossing_approved_v1.webp.b64`; strict loader and F6 art preview added. Remote text matched source export exactly. Native preview and enemies/arena/waves are pending; Act1 remains 36/45.

## 2026-10-15 — D181: D153 release-routing smoke confirmed in Godot
- User screenshot confirms F6 `D153 / ACT 1 RELEASE — PASS`: 36 unique cards, Tier1 controlled offer/choice, encounter routing, Fate Spread resolution, boss XIII gate.
- No gameplay or source edits required. Release #36 verified with this deterministic route fixture; randomized multi-run offer frequency remains untested.
- Next original #37 gameplay and art concept selection pending; D143/D167/D168 remain mandatory.

## 2026-10-15 — D180: D153 releases as Act1 card #36 (native smoke subsequently passed D181)
- Added `threadbare_theatre` to the normal Tier1 `ACT1_CARD_IDS` pool; now 36 unique nonboss cards.
- Fixed former 35-card assumptions in D151/D152/D153 smoke scenes and playtests, avoiding false failure after release.
- Added `threadbare_theatre_release_smoke.tscn`: tests real RunState offer, card selection, encounter routing, Fate Spread choice and boss XIII gating in a deterministic two-card Tier1 fixture.
- Previously confirmed native D176/D177 54/54 combat matrix remains valid for unchanged D153 values. Post-release deterministic normal-deal Godot F6 was subsequently confirmed PASS (D181).

## 2026-10-15 — Documentation hygiene (D179)
- Archived exact pre-cleanup copies of AGENTS, PROJECT_STATE, ROADMAP, DECISIONS, CHANGELOG, old handoffs, visual registry and D153 working docs.
- Consolidated current-state, release gates and next steps into a short canonical set with `docs/INDEX.md` and `docs/HANDOFF.md`; preserved full historical decision references.
- Updated README to the current playable game instead of the original early prototype; clarified Godot/dev test boundaries.
- No changes to gameplay, card pool, unit stats, mechanics, accepted art, or scenes.

## 2026-10-15 — D153 post-balance QA (D176–D178)
- D176: encounter-only Puppet Master/Marionette HP/damage/cadence/movement pass; no global balance changes.
- D177: restored resource serialization, added exact-path `UnitData` diagnostic.
- D178: user native Godot F6 54/54 FUNCTIONAL PASS; average survivor HP 74/67/74% solo/duo/trio, worst 39/15/37%; 123 link / 91 break / 54 master-death breaks.
- Historical D178 state: D153 was QA-only outside the 35-card pool. D180 has activated it; normal-deal regression check pending.

## 2026-10-15 — D153 original art and real battle
- User-approved skeletal marionettes, original crowned puppeteer, 25-pose original animations, selected gothic theatre card scene and moonlit ruined-stage battle arena committed.
- Encounter-local ThreadTether integrated into the real Battle flow (32% mitigation/285px); user previously confirmed battle→reward→table.
- Pre-balance matrix: 54/54 functional PASS with ~85/82–83/86% remaining HP, prompting localized D176 tuning.

## Previous released milestones
- D151 Funeral Procession: original skeletal units/Last Rite, live card **34/45**.
- D152 Defiled Laboratory: original toxic-hazard encounter, environment-led art, live card **35/45**.
- DS2 and Fate Spread Variant C established; earlier events, arenas, tactical cards, UI passes preserved in the archive.
