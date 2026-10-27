> **RELEASED UPDATE — D367B, 2026-10-27:** User approved **B — Oak**; [PR #32](https://github.com/zampolit73/Misdeal/pull/32) squash `6d39c4e` merged to main; [Godot 4.7.2 CI](https://github.com/zampolit73/Misdeal/actions/runs/40532236638) **60/60 PASS**. Exact B WAV now plays on live card deal, four distinct short dry-oak/paper table cues shipped with fallback + cooldown. **Next: user `git pull`, F5, listen to table.** Then D368 battle foley. Older A/B/C selection wording lower in this document is historical, not actionable. Human Act 1 12+XIII and authored RELEASE matrix remain outstanding. Details: [D367B_OAK_TABLE_RELEASE.md](D367B_OAK_TABLE_RELEASE.md).

> **LATEST UPDATE — D367B, 2026-10-27:** The user has now selected **B — Oak**. Previous passages below saying “await A/B/C choice” are frozen historical D367 state and **no longer active**. Development branch `feature/d367-oak-live-table-pack` connects the exact approved B WAV to live deal, authors four distinct short oak/paper table cues, retains original fallback and adds test/anti-spam; awaiting Godot CI + local F5 listening. See [D367B_OAK_TABLE_RELEASE.md](D367B_OAK_TABLE_RELEASE.md). No D368 or D369 work yet. Do not reopen selection, redesign DS3/Fate Spread or claim the full Act1 player run is verified.

# D367 — Current Misdeal new-chat handoff (2026-10-27)

> **START HERE IN A NEW CHAT.** Canonical current working context for the end of the D366–D367 Audio 1 pilot. It supersedes outdated "pending" statements in earlier dated entries of `docs/HANDOFF.md` / `docs/ROADMAP.md`, but never supersedes the actual GitHub code on `main`. Last verified source before this handoff: **`main` at `c9f73cf52fe3a410545229f6f67ca2888446905c`**. The handoff-only commit follows that snapshot.

## 1. How to work with the user

- Speak **Russian**; code, resource names and paths English. Main repository: **[zampolit73/Misdeal](https://github.com/zampolit73/Misdeal)**. **Connected GitHub is available**; use it directly for approved implementations/fixes; no repeated access questions or manual user code paste.
- A new chat must read `AGENTS.md`, `docs/CONCEPT.md`, `docs/PROJECT_STATE.md`, `docs/ROADMAP.md`, `docs/DECISIONS.md` first. Then this handoff, `docs/D366_D367_AUDIO_PILOT.md`, and relevant code. GitHub is the technical source of truth; the user's native Godot visual/audio judgments override speculative design.
- Godot **4.7.x / GDScript**, data-driven minimal changes, vertical slice before architecture bloat. PR + native Godot/GUT CI before release; after substantive commits update `PROJECT_STATE`, `ROADMAP`, `HANDOFF`, `CHANGELOG` and significant decisions. Local user habit: `git pull` → F5/F6 → send screenshots/audio impressions.
- **Do not tell the user to wait for future asynchronous work.** Act on the next concrete request in the current turn.

## 2. What game we're making

Misdeal is a dark-fantasy card-driven roguelike on a cursed round table, hosted by an evil Wizard who acts as commentator/antagonist. Compact tactical autobattler: pick one Knight/Ranger/Mage protagonist, recruit or lose others *organically* through cards; fight solo/duo/trio with precombat party positioning and tactic. A run has exactly **12 resolved Fate cards I–XII plus a sealed Bone Warden boss XIII**, with randomized offerings, deck/discard/hold. **39** current first-act dealable cards, plus XIII, have resource/art audit coverage; 29 selected art assets are guarded against accidental substitutions.

**The player likes the existing «РАСКЛАД СУДЬБЫ» and explicitly said to leave its design/form as-is.** Do not redesign Fate Spread, add a node map, change the 12+XIII rules, alter DS3 approved card art or rebalance combat without a new discussion. Main palette: dim medieval black, crimson, old bronze, parchment; approved scene-first dark-fantasy paintings, minimal AI-like trinkets, no arbitrary neon or gratuitous HUD.

### Locked story direction, NOT all implemented

Act I «Обещанный рассвет»: the protagonist deliberately sacrificed a besieged castle to save the country and **sent an honest order saying relief would not come**. The **Chancellor** substituted a forged promise of rescue. The **Commandant** discovered the truth yet kept promising defenders reinforcements. Commandant/Bone Warden XIII confrontation is the direction for the first-act mystery; the protagonist still bears moral responsibility for abandoning the castle. The Wizard's historical culpability and exact ending details remain unresolved. **Story bible proposals are not equivalent to runtime implementation**; see `docs/ACT1_PROMISED_DAWN_STORY_BIBLE.md` and relevant `docs/DECISIONS.md` sections. Maintain flexible Knight/Ranger/Mage starting class and randomized run.

## 3. Verified recent GitHub releases / guardrails

| Stage | Status / evidence | What matters |
| --- | --- | --- |
| D356–D360 art | PRs #23–#27 merged. D360 PR [#27](https://github.com/zampolit73/Misdeal/pull/27), native [CI](https://github.com/zampolit73/Misdeal/actions/runs/40501281488) PASS | Approved card paintings shipped. D360 «Расстрельная площадь» final straight-arrow image is an **illustration only**; do not mistake it for effects to draw across the 3D/2D combat field. |
| D361 full card-art/target audit | [PR #28](https://github.com/zampolit73/Misdeal/pull/28) merged `6c61fa2`, [Godot CI](https://github.com/zampolit73/Misdeal/actions/runs/40508157201) SUCCESS, **49/49** GUT | All **39 Act I card resources + XIII** have decodable runtime art and valid targets. This does **not** prove a real human 12+XIII victory. |
| D362–D364 readability pilot | [PR #29](https://github.com/zampolit73/Misdeal/pull/29) merged `00294879` | Team-distinct damage numbers and *actual positive heal* source→recipient link are liked. Initial hover target rays and long Ranger/Bone Archer shot overlays were **rejected** by user. |
| D365 combat clutter correction | [PR #30](https://github.com/zampolit73/Misdeal/pull/30), `67d5c852`, [CI](https://github.com/zampolit73/Misdeal/actions/runs/40523091071) SUCCESS **51/51** GUT | **No automatic hover target rays/rings; no long archer/ranger shot streaks/heads.** Original optional precombat `ЦЕЛИ` toggle still exists. Red/bronze hit values, green heal links, original attack animations and sounds stay. **Local human retest after D365 remains unconfirmed.** See `docs/D365_COMBAT_FEEDBACK_ROLLBACK.md`. |
| **D366–D367 Audio 1 pilot (CURRENT)** | [PR #31](https://github.com/zampolit73/Misdeal/pull/31), merged **`cd487890d75fbf62336112a2cb254f8cffd3dc92`**; release docs **`c9f73cf52fe3a410545229f6f67ca2888446905c`**; [Godot 4.7.2 CI run 40527079810](https://github.com/zampolit73/Misdeal/actions/runs/40527079810) **SUCCESS 56/56 real GUT**, native table/battle smoke and scene screenshots | UI / Combat / Ambience native buses + `SoundDirector`; existing live procedural SFX routed by bus but unchanged; **three A/B/C trial WAVs and F6 audition**, not yet sound-approved or live-replaced. Initial audio GUT script parse issue was corrected **before** the final passing run. |

CI for D366–D367 runs headless on a dummy audio device (no physical loudspeakers), so **passing import/GUT is not subjective listening approval**. A separate `release` authored Battle/animation matrix was not run as part of that PR's FAST/VISUAL suite.

## 4. CURRENT: AUDIO 1, exact assets and implementation

User said «Начинаем улучшение звука и атмосферы», approved **DARK FORGE AUDIO 1** and then «давай» for D366–D367. Objectives: tactile card/wood/steel/bones/bells and restrained silence; avoid arcade cacophony; no intrusive visuals and **no new background music** until ambience is assessed.

- `default_bus_layout.tres`: **Master**, `UI`, `Combat`, `Ambience`. `project.godot`: `SoundDirector` autoload / native bus layout.
- `scripts/audio/sound_director.gd`: per-bus gain/mute getters/setters and persistent, **initially silent** two-player ambience crossfade intended for future D369. There are not yet actual ambient loops playing.
- `scripts/table/table_audio.gd`: original five procedural mono 22.05kHz table cues routed to `UI`. `scripts/battle/combat_audio.gd`: original eleven procedural combat cues routed to `Combat`. No changed attack timings, combat AI, card mechanics or DS3/Fate UI.
- Three **original digitally synthesized 24kHz, 16-bit, mono deal-card prototypes** (NOT recorded foley): `assets/audio/pilot/d367_deal_a_parchment.wav` (A — dry parchment), `assets/audio/pilot/d367_deal_b_oak.wav` (B — heavy oak tabletop), `assets/audio/pilot/d367_deal_c_cursed.wav` (C — subdued occult shimmer).
- F6 playable audition: **`scenes/dev/d367_audio_audition.tscn`**, logic `scripts/dev/d367_audio_audition.gd`; 3 sample buttons, 3 mix sliders. These gain sliders are a **test scene**, not a saved player options menu.
- `tests/unit/test_d366_audio_foundation.gd`: 5 additional GUT cases to check buses, importable WAVs, gain/mute, original scene audio routing and audition nodes; final total **56/56 PASS**.
- **No user A/B/C choice received yet. Do not switch the live game’s card sounds to any of the samples without first hearing which approach they want.** If all three sound too synthetic, prototype/obtain genuinely acoustic suitable recordings instead and seek auditory feedback.
- Detailed acceptance, design constraints and file paths: **`docs/D366_D367_AUDIO_PILOT.md`**.

## 5. Precisely what happens next

**If next user says "продолжай":** the immediate useful step is to have the user actually hear/select the already-shipped A/B/C prototypes; they can also use the WAV links in the old chat if available. Ask only for their sonic preference or feedback (do not reopen GitHub access or design basics):

1. Locally `git pull`.
2. In Godot use **F6** on `scenes/dev/d367_audio_audition.tscn` and listen to A/B/C. They are already merged to main; no further asset upload is needed.
3. Once chosen, implement the **complete D367 table pack** (deal, select, discard, wizard meddling, milestone; possible restrained coin/chain/reward accents) in connected GitHub; preserve procedural fallback, avoid mouse hover noise, respect short samples and concurrency limits, update tests/docs and run CI; then request F5 live-table listening acceptance.
4. Next stage **D368**: new layered but sparse battle foley for steel, bones, arrow twangs, healer bell and boss; suppress simultaneous four-archer 'machinegun' SFX using voice budgets/cooldowns **without delaying/computing damage**; pilot on `iron_wall`, `last_bell`, `firing_square`. Keep D365 visual declutter policy.
5. Next stage **D369**: three subtle ambient loops (cursed table, castle outdoors, ossuary), very quiet gain + crossfades; leave constant score/music out, check scene transitions and ability to mute each channel. Do not call unmade recordings/loops finished.

**Parallel unresolved gate:** A1P3 human F5 Knight playthrough all I–XII + XIII, actual fights → Reward → Table → RunEnd; independent manually dispatched `release` battle/animation matrix. The prior structural fast-forward route checks and native smoke do **not** substitute for this. See `docs/D361_ACT1_FINAL_QA.md` and `docs/A1P3_LOCAL_PLAYTEST.md`.

## 6. User preferences from the entire project, worth preserving

- **No remake of «Расклад судьбы».** The current form and approved card designs are liked.
- Avoid visual clutter and obviously AI-looking artefacts. Prioritise subtle, believable, medieval tangible effects. The user actively tested combat: disliked auto hover rays and noisy shooting overlays; D365 deliberately removed them.
- For new visual card art, show **2–3 real different renderings first**, implement **exactly** the approved one, do not quietly swap it later. In DS3 art: aged-paper + dark red + bronze, no second nested frame, text optically centred; see `docs/DESIGN_SYSTEM.md`, `docs/VISUAL_ASSET_REGISTRY.md`.
- Create full sprite animation packs in batches (25 actual unique frames for currently approved unit standard), not repeated per-frame microapproval; ensure leg contact on the true floor, facing and readable scale.
- Keep protagonist Knight/Ranger/Mage choices, conditional companions, fixed authored enemy formations; no unintended extra cards/encounters without distinct new enemies.
- The current focus is **sound audition → chosen table sound pack**, not new card art, Fate Spread remake, unsolicited battle UI overlays, architecture rewrite or lore replacement.
- User expects GitHub edits by the assistant, meaningful commits and CI; only local `git pull` and explicit F5/F6 checks for the user.

## 7. Useful source-of-truth links

- [GitHub repository](https://github.com/zampolit73/Misdeal), [D366–D367 merged PR #31](https://github.com/zampolit73/Misdeal/pull/31), [final CI 56/56](https://github.com/zampolit73/Misdeal/actions/runs/40527079810).
- `docs/D366_D367_AUDIO_PILOT.md` — exact new audio contracts and audition check.
- `docs/D365_COMBAT_FEEDBACK_ROLLBACK.md` — restrained fighting visuals.
- `docs/D361_ACT1_FINAL_QA.md` + `docs/A1P3_LOCAL_PLAYTEST.md` — unfinished full playable Act1 acceptance.
- `docs/ACT1_PROMISED_DAWN_STORY_BIBLE.md` — story *proposals* vs locked concept.
- `docs/INDEX.md`, `docs/CONCEPT.md`, `docs/DECISIONS.md` and `AGENTS.md` — project protocol.

**Current stop point: approved AUDIO 1 plan, implemented and CI-verified mixer plus three audition WAVs; waiting for the user to choose A/B/C based on hearing.**
