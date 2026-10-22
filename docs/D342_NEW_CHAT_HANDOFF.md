# D342 — Misdeal new-chat handoff (2026-10-22)

**Source of truth** GitHub `zampolit73/Misdeal` branch `main`. At the beginning of a new chat read `AGENTS.md`, `docs/CONCEPT.md`, `docs/PROJECT_STATE.md`, `docs/ROADMAP.md`, `docs/DECISIONS.md`. GitHub connector read/write is enabled, do not ask repeatedly. This supersedes D341 as latest context.

## User-approved exact D342 image

Card `ash_rest`, display «ПЕПЕЛЬНЫЙ ПРИВАЛ», quiet Act 1 event: warm ash remembers former companions. User first requested more versions of **variant 2** of the previous illustrated camp series. Of new three, user took the FIRST scene, ruined wall + sword + backpack + campfire + two bedrolls, and sent a red-outline image selecting specific remote ruined towers/arches on the RIGHT hillside, requesting they be removed. Image generator then produced revised landscape `/mnt/data/wide_cinematic_fantasy_dark_medieval_landscape_sce.png`, user file `file_0000000017d08246b3f51d01a0b20241` (1536×1024 RGB). User said «отлично. утверждаю. заливай в гит и дальше по процессу». Previous assistant only sent path; D342 commit corrects that.

**Preserve edited version**: damp ruined stone wall and arch on LEFT foreground, sword propped, pack and kettle, small fire, two empty bedrolls and subtle smoke, on RIGHT an open misty forest valley with lakes and red-gold low sun. No remote castle, towers or ruined bridge in the outlined far RIGHT region. Do not use red-marked *source* or unedited options. Whole image converted with minimal vertical crop (x0..1536, y35..974) to WebP Q86 448×274 at `assets/pixel/card_unification_v1/run/ash_rest_d342_approved_clean_horizon.webp`, SHA-256 `d09b1dcaf027b9eb06f9d9affb8d5ec163340cb5c5fc89e3627d1ff4bd735f7b`. Live mapping in `scripts/ui/card_unification_v1.gd` `RUN_CARDS["ash_rest"]` and SHA + native 448×274 + catalog pixel tests in `scripts/dev/d315_card_ds3_smoke.gd`. Event Resource `resources/cards/ash_rest.tres`, mechanics, Fate and Card DS3 **D328** unchanged.

## Already approved frozen art

D341 `gravedigger_shop` last cleaned living elderly bearded gravedigger with preserved sunset palette; D340 `whispering_well` first ghost face reflection; D339 `grave_crossfire` third archers crossfire; D338 `bone_swarm` second swamp melee rush; D337 `gallows_volley` first gallows; D336 `graveyard_ambush` first scene; D335 `bone_ritual` third; D333 `bone_patrol` watchtower; D331 `blood_ledger` scribe and `bone_crush` breach; D319 `black_altar` third. All approved; do not change without user request. GDScript Godot 4.7.x, single-party up to 3 and compact autobattler, 2 card offers, 12 Fate resolutions and XIII boss.

## Next step

Check actual post-commit native Godot D315/D316 CI where exposed; do not claim PASS without evidence. User only `git pull`, F6 `scenes/dev/d315_card_ds3_gallery.tscn`, check «ПЕПЕЛЬНЫЙ ПРИВАЛ» at actual card scale. Then D343 new **not yet approved** event such as `lost_purse` («КОШЕЛЬ МЕРТВЕЦА») or `candle_seller`, inspect resource contents. **Show 2–3 actual distinct rendered illustrations** in chat and wait for user choice before any new artwork replacement. Avoid repetitive castles, giant suns/moons, red banners, stacks of tiny decorations; image must be visually distinct and tell card's story.
