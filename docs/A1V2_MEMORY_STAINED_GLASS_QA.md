# A1V2 — Memory Stained Glass implementation and QA

User-authorized final source SHA256 `b9bc84cde40956182ad22e049c56f1db034c95d8c6ab02b8ba9c12888a0e1f27`,1122×1402. Source and full task archived at `assets/story/a1v2/`. No image generation/repainting. Reproduce masks with `python scripts/dev/pack_memory_glass.py` (offline Pillow13). Authored narrative seed coordinates, deterministic luminance-barrier watershed,24 exhaustive disjoint alpha masks. Original pixels retained;24/24 draws the original single texture. `provenance.json` records source and coordinates. Binary watershed boundaries are approximate to the painted lead, not hand-traced vector contours; human visual acceptance remains separate from technical QA.

## Unlock contract

Only `RunState.complete_active_card` observes valid completed actions. Combat additionally requires `last_battle_won`; callbacks deduplicate by resolution index/card. One fragment per ordinary resolution, two at victorious XIII. Maximum6 ordinary +2 final =8/run. Personal memories have priority over chronicle. Already-owned candidates are skipped deterministically; no rewards/stats, clue injection or economic changes. Role means protagonist, never recruited companion. Successful stage alternatives make all24 reachable without a rare event; six simulated valid winning runs across all three protagonists cover the complete catalog. Early reruns cannot award new advanced fragments.

|ID|Group|Title|Minimum completed stage / alternative|Gate|
|---|---|---|---|---|
|SG01|chronicle|Последний мирный день|1 / —|none|
|SG02|chronicle|Огни за холмами|2 / —|none|
|SG03|chronicle|Каждый держит стену|3 / —|none|
|SG04|chronicle|Обещанный рассвет|4 / promise_heard|none|
|SG05|chronicle|Последняя мера зерна|5 / rations_hidden|none|
|SG06|chronicle|Те, кто смотрел на дорогу|6 / —|none|
|SG07|chronicle|Южная дорога|7 / southern_march|none|
|SG08|chronicle|Печать на чужом воске|8 / orders_conflict|none|
|SG09|chronicle|Суд без голосов|9 / silenced_witness|none|
|SG10|chronicle|Закрытая переправа|10 / —|none|
|SG11|chronicle|Ещё одна ночь|11 / —|none|
|SG12|chronicle|Пепельный рассвет|12 / —|boss_victory|
|SG13|knight|Клятва перед короной|1 / —|none|
|SG14|knight|Приказ без надежды|4 / —|none|
|SG15|knight|Цена манёвра|8 / —|none|
|SG16|knight|Знамя победителя|13 / —|boss_victory|
|SG17|ranger|Три дороги|1 / —|none|
|SG18|ranger|Следы уходящих|4 / —|none|
|SG19|ranger|Дети у ворот|8 / —|none|
|SG20|ranger|Последний сигнальный огонь|13 / —|boss_victory|
|SG21|mage|Первый оттиск|1 / —|none|
|SG22|mage|Два приказа|4 / —|none|
|SG23|mage|Невидимая подпись|8 / —|none|
|SG24|mage|Клятва, которую не забыли|13 / —|boss_victory|

## Persistence

Small independent profile service, retained across `reset_run`, version1 JSON at `user://memory_glass.json`. `.tmp` write/flush then replacement, previous valid generation kept as `.bak`. Missing profile starts empty; unknown/duplicate IDs filtered; legacy dictionary without schema accepted. Corrupt or newer schema is not overwritten, UI indicates save error. No existing A1M1/A1M2 clue is restored from this profile. Script-driven QA and GUT use an in-memory service or explicitly injected disposable path; F6 preview explicitly substitutes its own profile.

## Production UI

Table button «ПАМЯТЬ [M]»; modal ESC/close restores focus and the existing offers. Four tabs,24 selectable segments/list entries, scrollable reader, locked titles concealed;4/4 personal monologues,12/12 chronicle and24/24 realization available repeatedly. Two14×105 subdued architectural apertures beside the Wizard (x310/950,y140) use the original source with clipping; glow depends on collection. This conservative fallback preserves Wizard, hands, table and all existing imagery. No audio or forced overlay. New memory feedback is deferred until Table exists.

## Verified locally

Godot4.7.2: full GUT234/234,47633 assertions;19 existing warnings. Native production Table/viewer0/7/24 plus selected text and ESC: `docs/qa/a1v2/`. Pixel comparison against the same Table with memory node hidden finds zero differences outside the two apertures and button rectangle. Offers identical after close. Separate Godot processes write/read an isolated profile, both pass. Source unchanged by packing. Windows certificate-store/user-log sandbox diagnostics remain unrelated to GDScript/test results.

CI selector forces RELEASE for this feature; full existing release matrices plus A1V2 native captures must pass before merge. Delivery: [PR93](https://github.com/zampolit73/Misdeal/pull/93); [current-head checks](https://github.com/zampolit73/Misdeal/pull/93/checks). CI outcome is authoritative; no release claim until green. Final targeted suite additionally checks real event success, repeat callback, failed purchase, legacy data/duplicate/unknown ID filtering.

## Local check

F5: start a protagonist, resolve a card, return to Table, press M; read the new memory, ESC, continue the same deal. New run retains collection but clears investigation clues. F6 `scenes/dev/a1v2_memory_preview.tscn`: F1=0,F2=7,F3=24; M opens viewer; F4 simulates a confirmed completion in this isolated fixture only. Developer preview never writes the player profile.
