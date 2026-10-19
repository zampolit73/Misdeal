# D261 — Card #39 concept selection (THREE OPTIONS; no release)

**2026-10-19.** GitHub `main`: D260 user reported **«все ок»** after successful 38/45 Act1 release. This is a checkpoint confirmation, not a selection of a new #39 gameplay or illustration.

## Purpose and constraints

Act1 current released pool **38/45**; #39 shall provide a clearly distinct card scene and meaningful player choice, consistent with the cursed tabletop / dark fantasy / skeletal Act1 world. Godot 4.7.x, GDScript, data-driven `.tres` and `.gd`, DS2, Fate Spread 12+boss XIII, and KARAMBA73 unchanged. Do not begin implementing a live `#39` until a direction is chosen. If the direction has combat, obey **D143: all genuinely new enemy identities and original complete animated 25-frame atlases**; no old skeletons in new costumes, no generic placeholder art. D167 scene-first environmental art; D168 show **three genuinely rendered visual options for the CHOSEN direction** before integrating a selected card illustration. Full animations produced/repaired per enemy in whole packs without per-frame approval.

## Option A — СУД БЕЗМОЛВНЫХ (Court of the Mute) / COMBAT

**Scene:** Ruined underground tribunal behind an iron grating. Three tall judicial lecterns, a central cracked weighing scale, wet limestone steps, executioner's hook hanging in darkness, dust-cold olive torchlight. Clearly different from marsh ferry, theatre puppets, alchemical lab, lantern road and existing generic crypt skirmishes.

**Enemy identities (all new):**
- `mute_magistrate` — a tall sealed-face skeletal judge, wears black ceramic face visor and corroded bronze mantle, holding an oversized cracked staff/seal, identifiable leader
- `ash_scrivener` — frail parchment-wrapped skeleton scribe gripping iron quill and record slab, telegraphs target selection; no summoned enemies
- `bone_bailiff` — broad armored execution guard wielding a short hooked halberd and square convict's shield; 2 instances allowed of one truly original role

**Single localized mechanic:** `verdict_target` — scribe visibly marks one hero with a red seal after a warning. For a brief window bailiffs choose that hero as preferred attack target, with *no* global stun, instant damage or unavoidable attack. Existing positioning and tactic choices influence whether the party can intercept/remove the scribe. Judge has normal attacks; defeat the scribe removes current future marks. Target priority is encounter-local, not changed universally for other cards. Tune solo/duo/trio with existing RunState normalization, no permanent hero injury. Draft four enemies total, two formations and an authored new court arena.

**Scope/risk:** Medium-high due to encounter-local target-selection logic and three full new sprite sets. High tactical identity and satisfies user's preference for genuinely new foes and distinct battles. **Design recommendation** for #39 if the next slot is combat.

## Option B — САД СЛОМАННЫХ НАДГРОБИЙ (Garden of Broken Stones) / COMBAT

**Scene:** Steep neglected memorial garden full of leaning obelisks, a tree strangling limestone markers, low cold mist and pale fungi growing between engraved stone; moonlight is static and blue, not another travelling light-zone scene.

**All-new original enemy identities:**
- `ossuary_gardener` — hunched bone groundskeeper holding two-handed bone-shears with actual metal edges
- `tomb_vigil` — small grave sentinel skeleton with a cracked stone pavise and rusted spade
- `rootbound_widow` — skeletal mourner dressed in roots, carries a stone censer; leg contact grounded, not flying

**Single mechanic:** `grave_cover` — one finite, visible cover ward attaches to one enemy, absorbing a small quantity of damage. The Ward is renewed only while the groundskeeper remains alive; targeting the gardener first prevents the refresh, prioritizing sentinels first removes immediate front-line cover. NOT invincibility, enemy resurrection, a position hazard, a light zone, or puppeteer strings. Can be implemented as limited encounter-scoped shielding with visible cracks.

**Scope/risk:** Medium-high, three new roles and original art plus an encounter-only shield mechanism. More defensive and slower than #38, needs deliberate fight-duration QA to avoid grinding.

## Option C — ЧУЖАЯ ЭПИТАФИЯ (The Stranger's Epitaph) / EVENT

**Scene:** Rain-dark roadside grave with a fresh unmarked slab. Under it burns a single underground candle in a glass reliquary; an unfinished engraved name seems to match the protagonist's. No enemies or staged sprites required.

**Meaningful bounded choice:** Read the unfinished name to obtain a transparent one-encounter benefit **at a cost** (e.g. small gold payment or temporary, explicit Wizard mark); or scrape the name away for a modest guaranteed resource; or leave it untouched, with no hidden lethal punishment. Use existing `RunState` currencies/status modifiers and event decision UI where possible; no permanent rewrite of Fate/companion rules or retcon of hero backstory. Wizard comments on choice and records only existing memory counters where suitable.

**Scope/risk:** Low-medium. Strongest pace variation after four combat-heavy expansions; can release without inventing unique combat sprites, still requires one original selected scene-first card illustration and gameplay resolution QA. Must avoid copying `last_camp`, `death_wager`, `chained_prisoner`, `bone_tax` outcomes.

## Comparative choice

| Criterion | A Court | B Garden | C Epitaph |
|---|---|---|---|
| Type | New tactical combat | New tactical combat | Meaningful event |
| New full character animation sets | 3 | 3 | 0 |
| Distinguishing action | Telegraphed marked target + guard target focus | Finite defensive grave ward | Risk/reward name-engraving choice |
| Environment look | Iron tribunal / cracked scale | Moonlit overgrown tomb garden | Roadside black-grave close scene |
| Threat of mechanic overlap | Targeting must stay local | No D206 lantern zones or D153 tethers | Avoid existing wagers/rest |
| Release effort | Medium-high | Medium-high | Low-medium |

**Current recommendation:** **A**, for memorable new foes and a battle decided through preparation and target choice. However, no selection or artwork has been approved. The user picks **A / B / C** or suggests a hybrid. After the choice, show **three actually rendered, compositionally different card illustration options** for the chosen direction. Do not substitute descriptive text for those art previews, and do not integrate production images before user selects one.

## No code release from this note

This stage is planning **only**: no #39 `RunCardData`, `EncounterData`, gameplay modifiers, character sprites, image assets, or `ACT1_CARD_IDS` changes. No early promise of a new completed enemy animation pack. **#38 is LIVE 38/45 and remains unchanged**. This note is the next-chat handoff for D261 selection, not a locked design decision.
