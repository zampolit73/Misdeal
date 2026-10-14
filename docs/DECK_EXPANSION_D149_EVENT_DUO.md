# D149 — Moon Seal / Echo Crypt (source shipped; local Godot QA pending)

Date: 2026-10-14. Engine: Godot 4.7.x / GDScript. Repository: `zampolit73/Misdeal`, main.

## Why this slice

The user approved the updated cinematic `bone_shepherd` card illustration and both enemy miniatures in actual 1280×720 F6 screenshots, and the native D148 combat smoke finished 54/54 with 14 Whistles. This is scoped visual approval **of the displayed previews/pre-battle**, not a claim that full win→reward→table or every combat pose was tested. The next content increment is **two noncombat event cards** to diversify runs without any old-enemy reuse or premature new-enemy art. Decision D143 remains binding: all future fight-bearing additions demand genuinely original enemies, AI and card/animation art.

## Authored content

| Card | Tier | Type | Role |
|---|---:|---|---|
| `moon_seal` / «ЛУННАЯ ПЕЧАТЬ» | 0 | event, no battle | First decision; optionally carry a silver seal forward |
| `echo_crypt` / «СКЛЕП ОТЗВУКОВ» | 1 | event, no battle | Later echo of the first decision; still playable without seeing the first card |

New resources: `resources/cards/moon_seal.tres`, `resources/cards/echo_crypt.tres`. Both use existing `scenes/event/act_choice.tscn` with dedicated handlers in `scripts/event/act_choice.gd`. Registration is in `RunState.CARD_PATHS` / `ACT1_CARD_IDS`. Result: **33 nonboss Act1 pool cards** (was 31); tier 0 = 12, tier 1 = 11, tier 2 = 10. One run still resolves **12 cards + sealed Bone Warden XIII**, offers two choices, and retains forced combat rules.

### Moon Seal

- **Keep**: +10 gold, sets `event_outcomes["moon_seal"] = "kept"`. This is a small immediate reward and unlocks better Echo Crypt terms *only if that card is also drawn*.
- **Sell**: +30 gold, `"sold"`, standard Wizard greed memory.
- **Burn**: permanent party damage +1, party HP bonus -10, `"burned"`.
- **Leave**: no reward, `"left"`. No forced combat or invisible penalty.

### Echo Crypt

Works without Moon Seal. Checks `RunState.get_event_outcome("moon_seal") == "kept"` at the moment the event UI opens; no hidden card re-deal or guaranteed chained encounter.

- **Open reliquary**: adds a random still-unowned artifact; if held seal, no cost; otherwise party HP bonus -15. If no unowned artifacts, gives +35 gold instead and does not charge HP.
- **Take offerings**: +25 gold normally, +40 with seal.
- **Listen**: party damage +1.5; party HP bonus -15 normally or -5 with seal.
- **Leave**: safe, no reward.

All four choices call the normal `RunState.complete_active_card()` and continue toward the tabletop. No enemies/encounter assets, combat code, companion-fate overrides, global balancing retune or new battle mechanics.

## Artwork caveat: gameplay first, new illustrations next

The source currently maps `moon_seal` to the **unchanged accepted** `run/whispering_well.webp` and `echo_crypt` to **unchanged accepted** `run/gravedigger_shop.webp`, strictly as **temporary themed DS2-quality visual fallbacks**. These are **not bespoke D149 illustrations and not final art approval**. The new cards have no new event background or brand-new sprites; they do not make combat claims. Before declaring this pair production-art-complete, create two own 448×274 full-bleed painterly card illustrations (moonlit engraved silver seal in a grave chalice; open ancient ossuary door/reliquary echoing its silver sigil). Preserve the user's rich D147 photo-painterly standard, no baked card border/title/text, freeze existing approved WebPs. Replace only the two paths in `CardArtCatalog`'s `CardUnificationV1.RUN_CARDS`; approved source images never change.

## Source/static QA completed

- All 33 ids unique; two cards have valid `RunCardData` Resources, unique titles, explicit event target and correct tier.
- Both configure/resolve handlers, leave outcomes, thematic choice icons, DS2 presentation hook exist.
- The old `bone_shepherd_smoke.gd` fixed-pool assertion was updated from 31 to 33; its **previous** D148 54/54 PASS remains historical, not automatically a D149 rerun.
- No Godot executable is available in the assistant runtime; **new event source is not yet F6-certified**. Actual tier-dealing/choice-result/UI wrap need local review.

## User F6 in one scene

Run `res://scenes/dev/deck_expansion_d149_event_preview.tscn` with F6 after `git pull`. Three buttons open **the real** Act Choice UI:
1. Moon Seal (start state) — inspect all three choices and leave, confirm reward + event return.
2. Echo Crypt **with kept seal** — 35 seeded gold, free relic / 40g / HP -5 paths.
3. Echo Crypt **without seal** — same 35 seeded gold, 15HP relic cost / 25g / HP -15.
Each launch is isolated and automatically resets run state; after the selected resolution, pressing Continue returns to the normal table. Check text fits in parchment DS2 panels at 1280×720. If an F6 parser/UX error appears, fix in GitHub, not by asking the user to edit scripts.

## What's next

1. F6 D149 preview and option/return QA; inspect real Bone Shepherd victory→reward→table separately (D148 smoke did not certify it).
2. Produce distinct D149 original painterly art and replace temporary art aliases, subject to screenshot approval.
3. Then advance remaining 12 proposed expansion cards; every new combat-containing card needs fully original enemy species/roles/abilities/art per D143.
4. D142 tactical HUNT and party-size causal balance experiments remain a separate approved-gate proposal, not part of D149.
