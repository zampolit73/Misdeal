# D262 — Court of the Mute: three unique UnitData roles + encounter-scoped verdict, native QA PASS

**2026-10-19 · current main. Status: TECHNICAL MECHANIC AND SIX REAL BATTLE PREFLIGHT CASES PASS; original pixel animation and court arena ART HOLD.** #39 NOT RELEASED; ACT1 38/45 LIVE.

## Source-of-truth context

D261 user approved **concept A** and exactly the **second** court card illustration (source portrait `мрачный_трибунал_у_трона_смерти.png`). DO NOT replace/crop its accepted `448×274` export again. See [exact selection record](D261_COURT_SELECTED_ART_QA.md). Following D261 user's **«отлично»** authorizes proceeding D262; does not equate to approval of unfinished new character art or arena.

## Implemented D262 source files

- `resources/units/mute_magistrate.tres`: new original skeletal judge leader `UnitData`, 102 HP, 8 dmg, attack 1.85s, slow/sturdy
- `resources/units/ash_scrivener.tres`: new parchment-wrapped quill/ledger scribe, 58 HP, ranged 163, attack 2.10s and minimum range 70
- `resources/units/bone_bailiff.tres`: new shield/halberd guard, 74 HP, 6.8 dmg, attack 1.70s
- `resources/encounters/court_of_the_mute.tres`: **4 independent actor instances, 3 original identities** (Judge ×1, Scribe ×1, Bailiff ×2), two original deployment formations, unique card and wizard descriptions. These are preliminary **QA-only combat numbers** pending full art/balance.
- `scripts/battle/court_verdict.gd`: `CourtVerdictController` with first 1.0s delay → visible 1.4s wax-red warning seal on the nearest living hero to the scribe → 2.5s bailiff focus → 3.6s rest; 2 guards focus **only** the marked hero during active phase, then their normal nearest-enemy targeting resumes. A kill of Scribe interrupts, clears focus immediately and stops further marks. Invalid/dead heroes handled; **no stun, no forced direct hit, no global target-AI change**. Draws warning line from scribe's quill and red seal above hero in UnitsLayer.
- `scripts/battle/battle.gd`: exact encounter-ID guarded hook in preparation/setup, start-after-Fight-intro and stop-on-battle-result. Strictly validates exact four-enemy roster before configuring. Other 38 live cards never instantiate controller. Neither existing `BattleUnit` nor other mechanics were changed.
- `scripts/dev/court_of_the_mute_d262_verdict_contract.gd`, matching scene: real `BattleUnit` instances test warning, expiration, focus and death cleanup. Expected all three new sprites **NOT registered** yet.
- `scripts/dev/court_of_the_mute_d262_real_battle_boot.gd`, matching scene: instantiates the **actual Battle scene** 6 ways (1/2/3 heroes × 2 formations), validates proper original enemy roster, controller startup **only after Fight**, target and cancellation; ensures other encounter controller #38 never leaks.
- `.github/workflows/d262-court-verdict-contract.yml`: official Godot **4.7.2** parser/import, two native D262 contracts and release #38 original **54-case** headless balance regression.

## Proven checks

[GitHub Actions D262 success](https://github.com/zampolit73/Misdeal/actions/runs/39214875883):
- Godot GDScript project import/parsing PASS (aside from independently pre-existing `assets/concepts/approved_battle_direction.jpg` import failure)
- `D262_COURT_VERDICT_PASS`: 1.4-second warning precedes targeting; 2 bailiffs focus correct marked hero, release after 2.5 seconds; Scribe death cancels
- `D262_COURT_REAL_BATTLE_PASS`: SIX real Battle instance setups with three party sizes, two formations, exact roster, and encounter-only controller working
- D260 38-card original balance matrix regression PASS. No changes to #38 or overall card pool.

## Visual work still REQUIRED, do not misrepresent

The court needs **THREE independently authored complete 25-pose original sprite atlases** — `idle4/walk6/attack6/hit3/death6`, `6×5×96px` and 5 fully transparent unused cells per role — with held readable assets and real feet at true ×1: 
- Judge: sealed-face skeleton, corroded bronze mantle, staff/wax seal, grounded footsteps
- Scribe: distinct thin shrouded skeleton, quill + ledger remaining gripped through attacks
- Bailiff: substantial large square shield + hooked halberd in two real hands, grounded soles.

DO NOT synthesize 25 hashes out of one static sprite or borrow `road_sentinel`/any previous enemy. No original Court sprite atlases were committed in D262 yet. The speculative preliminary tribunal image generated in the chat is **not** the user's selected second card image nor a production arena; it contains characters already painted into the scenery and so was **not installed** as combat background.

The original tribunal arena still needs genuine architectural art: giant scales, cracked stone bench, low walkable floor distinct from the upper tribunal, no baked combat enemies. Do not substitute a generic crypt or blur/upscale existing card image as final. Current `arena_id = "court_of_the_mute"` is staged in encounter data only; artwork is NOT shipped. The card resource `resources/cards/court_of_the_mute.tres` intentionally keeps **`target_path = ""`** to prevent a fake complete route; `RunState.CARD_PATHS` makes QA art addressable, but `ACT1_CARD_IDS` remains **38** and no production #39 preview with placeholder enemy art is allowed.

**NEXT D263**: deliver 3 complete 25-pose rich original atlases in one authored batch plus original unpopulated court battle background, inspect full animation x1 and scene contact in one F6 QA, then hook those assets to strict game sprite library/arena only after coherent quality. After that, actual solo/duo/trio × formations 54-case balance and real Battle→Reward→Table, then separate release #39 to 39/45.

Maintain chosen card illustration, D260 Black Lantern Road, DS2, Fate Spread 12+boss XIII, 1.16× light, all other authored arenas and frozen KARAMBA73.
