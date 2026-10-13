# Act 1 Deck Expansion — Bone Shepherd / «КОСТЯНОЙ ПАСТУХ»

**Status: FIRST VISUAL + GAMEPLAY CONCEPT AWAITING USER APPROVAL (2026-10-14). NOT IMPLEMENTED.**  
Applicable established constraint: `docs/DECISIONS.md` **D143**. New combat cards need truly novel enemies, not reskins or reordered legacy rosters. Deck Expansion proposal: 30 → 45 Act 1 cards, still 12 resolved cards + boss XIII. This document is the first of five preliminarily named new fight-bearing cards; the five are not an approved final count/roster.

## Player-facing identity

- Proposed new card ID: `bone_shepherd`
- Display title: **КОСТЯНОЙ ПАСТУХ**
- Tier: **0** (early Act 1), `resolution_type = "combat"`.
- Encounter ID `bone_shepherd`, **one fixed authored roster**; formation variants may move those same enemies but **never randomly exchange enemy species**.
- Proposed card text: **«Из тумана выходит пастух. Его стадо давно не дышит — но всё ещё слушается свиста.»**
- Wizard line: **«Овцы, говоришь? Эти хотя бы никогда не отбиваются от стада. Без приказа.»**
- Battle promise: a distinct dark-fantasy funeral herder **commands two cursed quadrupeds**; clear positional attack cue, no old skeleton warriors/bellkeepers/archers/thralls.
- Art style: original user's locked **DS2 / Fate Spread Variant C** palette: blackened timber/obsidian shadows, ritual blood-red thread, worn bronze, parchment and moonlit steel with small warm practical light. Sparse and hand-authored pixel-art shapes, no ornate AI-looking greebles, readable at 1280×720. Never alter approved card layout or live art to fit this card.

## Opponents — both must be new UnitData/visual roles

### 1. Bone Shepherd — `bone_shepherd`

- **Single visible leader**, not a conventional skeleton humanoid. A too-tall, hunched **funeral shepherd's empty mourning cloak**, held together by a *vertical arc of large ribs and grave roots* with a long **hooked bone crook**; asymmetrical hanging crimson strips mark his authority. Dark mask/socket with a tiny warm ember. Cloak silhouette is a tall inverted wedge; one sharply recognizable hooked pole. **NO bell, staff with a bell, generic armored skeleton or crown:** don't confuse with Grave Bellkeeper.
- Role: **slow rear-area commander** whose single enemy tactic is a **telegraphed Shepherd's Whistle**.
- Whistle concept (not coded): every ~7–9 combat seconds, a short distinct VFX/SFX cue visibly marks the pair of lambs for ~0.6 s, then prompts a **short, noticeable collective rush** toward an existing valid hero target. No instant leap across the field, no unavoidable unavoidable stun and no new enemies spawning. Use a small **data-driven** behavior tuning definition in `.tres` / `.gd`, avoid generic global special-ability framework.
- Initial design-only balance target: deliberately **early-game weak**, with the two lambs as primary pressure. Exact HP/damage/range to be fixed after local isolated F6 against Knight/Ranger/Mage, solo/duo/trio; **do not set production coefficients merely from this brief**.

### 2. Ossuary Lamb — `ossuary_lamb`

- **Two matching new enemy units** in the same authored encounter. Quadrupedal, **short and bulky** rib-plates in the suggestion of torn bone-wool, long narrow lower jaw and **twisted short ram horns**; battered hoof-like feet and moonlit-blue cracks. Make each miniature recognizable as an unnatural *lamb/ram*, not a standard bone dog or existing `bone_raider`. Avoid tiny decorative objects; body and horns distinguish the 96×96 silhouette.
- Role: **close-range harrier**, not a small human skeleton. Usually approaches the nearest threat. On Shepherd's Whistle they perform the short coordinated approach/surge toward one hero for a bounded duration; **avoid general pathfinder rewrite** and keep telegraph visually obvious.
- Should not have generic skeleton hit/idle sprite, merely recolored bone raider frames, or overpowered solo pressure.

## Fixed encounter / authored placement for prototype

- **Enemy identity and count:** `bone_shepherd` ×1 + `ossuary_lamb` ×2. All **three are newly drawn creatures**; neither prototype nor shipping resource mixes in old units.
- Shepherd **rear / center**; lambs **front / upper and lower lanes**. Alternative formation can place lambs slightly staggered or closer together while retaining exactly the same three enemy IDs.
- Existing cemetery/graveyard arena is an acceptable starting environment if appropriate to art; a custom backdrop may be separately approved. No live Fate Spread/table redesign.
- Tactical lesson: positioning around a telegraphed synchronized charge, early readability of commander-versus-minion relationship. Killing the shepherd stops future whistles without immediately killing his lambs, allowing a natural target-priority tradeoff; still allow three baseline orders.
- New `UnitData` roles, new original miniature sprite atlases (including consistent floor contact across all frames), separate card illustration, authored `EncounterData`, and short cue VFX required *before* adding this card to `RunState.ACT1_CARD_IDS`. **Never deploy empty art fallback as a finished "new enemy".**
- Target sprite planning, subject to user's image approval: each unit an authentic `96×96` cell per frame, legible idle/walk/attack/hit/death sheet if feasible; do not fake frame animation by wobbling an idle pose (see `docs/UNIT_ANIMATION_PACK2.md`). A high-level concept sheet **is not itself an animation atlas**.

## Gate sequence

1. **This turn:** write original enemy concept and show a **single art-direction reference** of new Shepherd + Lamb (no user-facing card registered, no new combat data, no player-facing mechanics in GitHub until design accepted). Ask user's approval or specific redraw notes.
2. After explicit concept signoff, produce **real** miniature frames/sheets with source imagery and full unique card artwork. Verify pixel readability at 1280×720, including feet/stance.
3. Then implement only this one real battle card + distinct enemies/resources + basic readable Whistle/collective rush AI + appropriate F6 encounter tests. Keep card faithfulness and existing authored encounters unchanged.
4. Run `git pull` + F6 in user's Godot 4.7.x; verify no parse errors, unique roles/spawns, high combat legibility, solo/duo/trio against Tier0. Only then expand with further new combat cards or more events.

## Status caveats

No new `resources/cards/bone_shepherd.tres`, `resources/encounters/bone_shepherd.tres`, `resources/units/bone_shepherd.tres` or `resources/units/ossuary_lamb.tres` exist as of this concept checkpoint. No associated new enemy miniatures/card image exist in the GitHub repo. This concept does not approve itself. Existing v25 combat diagnostics and outstanding D142 HUNT/party balance QA remain separate from the Deck Expansion. Do not break 30→45 pool accounting or 12+XIII rule.

## Concept illustration clarification (same session)

A provisional concept illustration was generated in the chat (generation ID `f4082d45-feb8-46e4-9401-a3f5ca97638d`), **not committed as a game asset**. As an exploratory moodboard it added extra optional-choice UI, an alternative quadruped name/appearance and a *third* ghost enemy which are **NOT in the approved scope or in the above proposed 1+2 enemy spec**. Do **not** implement its extra enemies, combat branches, summoning/healing/status abilities or extra interface as if user accepted them. If user prefers any of these illustrated extras, first explicitly revise this design and the artwork list with their approval. Neither the creature look nor the gameplay behavior is yet signed off. Current user decision required: approve the 1× Shepherd + 2× horned Ossuary Lamb idea, or request a visual/roster revision. The image is **not an authentic 96×96 sprite atlas**.
