# Misdeal — handoff: Cinematic Travel and Posthouse (2026-11-11)

> **Priority:** read this alongside `AGENTS.md`, `docs/CONCEPT.md`, `docs/PROJECT_STATE.md`, `docs/ROADMAP.md`, `docs/DECISIONS.md` and `docs/HANDOFF.md`. GitHub `main` is the technical source of truth. The user's approvals in project chat are the artistic source of truth.

## Current verified release point

- Repo: [zampolit73/Misdeal](https://github.com/zampolit73/Misdeal), Godot 4.7.x, GDScript.
- [PR #103](https://github.com/zampolit73/Misdeal/pull/103): four-second skippable travel after resolved Echo of Siege events and completed battle rewards. Existing SceneRouter/SceneTransition, no saved travel stage.
- [PR #104](https://github.com/zampolit73/Misdeal/pull/104): mountainous ruined-castle road art replaces repetitive bridge forms.
- [PR #105](https://github.com/zampolit73/Misdeal/pull/105): Cinematic Travel V2 six-layer parallax, real D412 party, contact shadows/step dust, fog/banner, compact narration, scene-entry/exit polish. Full CI green; reviewed via earlier user F6 video, accepted as *basis* for travel direction, not blanket approval of all future scenes.
- **[PR #106](https://github.com/zampolit73/Misdeal/pull/106) merged to main** at `406b63c02f9455f25b5ed5f9b588b70dba47a1fc`: second authored travel location, **«Почта последнего рассвета»**, for card `unsent_letters` / «Запертая почта».
- [PR #106 RELEASE CI](https://github.com/zampolit73/Misdeal/actions/runs/43002837989) completed successfully: GUT **285/285**, **72,176 assertions**, 43 native posthouse frames, 20 clean isolated replay/free cycles and real three-choice routes. This confirms technical checks, **not final artistic approval**. If main has advanced further, inspect new commits first.

## Exact approved artwork and nonnegotiable rules

The user corrected a mistaken option-number interpretation by uploading the **exact** desired image again. Its source is **`assets/pixel/travel/last_dawn_posthouse/approved_reference.png`**, **1672×941 RGBA**, SHA256 **`e4a3f62457071e431e7d01b739925db44a3ae9c8da4a13d51928e2f790d10bf5`**. Also named `misdeal_posthouse_approved_reference.png` in project chat. PR #106 preserved this PNG byte-for-byte in GitHub: no need to ask for the attachment again.

Composition to preserve: posthouse **left**, sealed-envelope sign and warm lantern, heavy door and shuttered mail window, parcels/letters/sacks, a **bird perched on the wooden crossbar**, abandoned mail cart in middle distance, wide muddy road to right for the party, ruined village houses, mountain fortress, cold gray-blue fog and muted burgundy/gold standards. **Original reference shows an ordinary bird; final game rendition must show ONE distinctly skeletal pigeon**. The source PNG stays immutable; remove the living bird only from *derived* composited background and animate a separate skeletal bird.

Use exact established Misdeal heraldry, not invented emblems: worn burgundy cloth; aged-gold ring, crossbar, long thorn/spiked vertical shaft. PR #106 reports correcting only two incorrect distant emblems, leaving already-correct close flags intact. Avoid AI-noise/detail creep or changes to approved architecture, light, road, palette and camera angle.

**Explicitly rejected:** earlier generic ruined village concept (including the previous flag-corrected version); do not recycle it for another travel card. Also reject alternative posthouse compositions or the version with already-flying ordinary pigeon. Use only the exact chosen source.

## Story attachment and outcome-dependent action

Card: `resources/cards/unsent_letters.tres`, `resolved_card_id == "unsent_letters"`; scene title **«ПОЧТА ПОСЛЕДНЕГО РАССВЕТА»**. The story is about undelivered letters and a dead postmaster still waiting for authorization to send them. Established Act 1 canon: hero knowingly sacrificed besieged castle while honestly stating no reinforcements would come; Chancellor substituted a false promise; Commandant later learned the truth but perpetuated the deception. Do **not** spoil the final Bone Warden/Commandant connection before its proper reveal.

Each resolved choice produces its own **presentation** on the same authored location, without new rewards, clues or saves:

| Choice | Visible action | Scene narration |
|---|---|---|
| `release` («ОТПРАВИТЬ ПИСЬМО») | One skeletal pigeon takes one sealed envelope, launches from its perch, flies toward roofs/mist and disappears. No extra birds. | «Письмо наконец покинуло крепость. Но те, кому оно предназначалось, давно перестали ждать». |
| `read` («ПРОЧИТАТЬ ПИСЬМА») | Skeletal pigeon remains perched; one opened paper moves weakly in the breeze. Implies the southward army march, no explicit invented road signs. | «В письмах обещали спасение. Но армия уже уходила на юг, прочь от этих стен». |
| `passed` («ЗАПЕРЕТЬ СУНДУК») | Bird remains perched; slight shutter and lantern movement; stillness. | «Письма остались заперты. И вместе с ними — слова, которых так никто и не услышал». |

The card's **gameplay** effects remain in `scripts/event/final_five_events.gd`: release costs 10 gold/prepares Defiance; read records the southern-march fact; passed changes nothing. **Travel is presentation only** and cannot replay these effects.

## Implemented paths in PR #106

- Approved art and separate derived layers / bird atlas: `assets/pixel/travel/last_dawn_posthouse/`
- `resources/travel/last_dawn_posthouse.tres`
- `scripts/travel/posthouse_panorama.gd` and `scripts/travel/posthouse_reactions.gd`
- Card-to-location mapping: `scripts/travel/travel_catalog.gd`
- Native test scene: **`scenes/dev/posthouse_playtest.tscn`**
- Pack/rebuild: `scripts/dev/pack_posthouse_assets.gd`
- Full implementation, art provenance and QA notes: **`docs/TRAVEL_LAST_DAWN_POSTHOUSE.md`**, `docs/qa/posthouse/README.md`

Existing travel road remains available for other eligible cards; no new autoload, saved travel stage, secondary router, card art replacement or D412 edits. Maintain V2 skip/pause/transitions and 4s cadence.

## NEXT ACTION — user review is not yet recorded

1. Open a **clean/appropriate checkout of main** in Godot 4.7.x. Prior original user's main checkout was dirty on a Living Arenas branch; **do not blindly reset, stash, switch or pull that worktree**. Inspect `git status -sb` before updating. Prefer a clean separate checkout/worktree if needed.
2. Open `scenes/dev/posthouse_playtest.tscn` and press **F6**. `1` solo Knight, `2` Ranger+Mage, `3` trio; **Q** release, **W** read, **E** passed; **P** pause, **R** replay; Space/Enter/Escape/button skip.
3. Request a short actual-Godot video or screenshots for **all three variants**. Verify that the pigeon is skeletal and flies only on release, carrying the letter; real foot contact, source fidelity, heraldry, readable caption, correct parallax/occlusion/seams, and natural transition back to the cursed table. Record user feedback and fix directly in GitHub before declaring the art final.
4. F5 smoke: real «Запертая почта» choice → Posthouse → Table; other event → old road; Battle → Reward → old road; direct save/load to Table. PR #106 CI already exercised these, but user art acceptance is separate.

## Longer-term creative direction — not yet implemented

The user expressly wants **many unique travel scenes, ultimately one recognizable authored location per completed card**, rather than a single repetitive generic road. The world must remember the finished **card and its decision**, through subtle visual changes and specific Russian narration. One base location per card, with 2–3 decision-specific reactions when applicable; not three full paintings per branch. Cards may resolve in different orders; key by card ID + outcome, **not slot order**. Preserve Fate Spread 12+XIII, no new overworld map, and keep travel short/skippable. Extend the existing small data-driven mapping incrementally; do not prebuild a large speculative framework.

Next art after Posthouse *artistic review*: choose a different existing Act 1 card (possible candidates `banner_seamstress`, `borrowed_boots`, `false_weights`, `last_signal`) and design **three actual rendered options** consistent with its current card/story, then user explicitly chooses the final painting. Do not recycle the rejected ruined village. Keep approved event card illustrations and choices untouched. Use scene-first art and correct in-game heraldry.

## New-chat kickoff

«Продолжай Misdeal с `docs/SESSION_HANDOFF_2026_11_11_TRAVEL_POSTHOUSE.md` и актуального GitHub `main`. PR #106 уже merged и CI green. Начни с художественной проверки F6 сцены “Почта последнего рассвета” по реальному видео или скриншотам; затем согласуем следующую уникальную travel-сцену для другой карты. Не переделывай утверждённый исходный PNG, не переиспользуй отвергнутую деревню и не меняй игровой цикл».
