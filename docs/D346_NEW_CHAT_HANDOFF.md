# D346 — Misdeal handoff (2026-10-25)

## Source of truth and priorities

Connected GitHub repo `zampolit73/Misdeal` `main` (READ/WRITE available; do not ask user again). Before architectural tasks read `AGENTS.md`, `docs/CONCEPT.md`, `docs/PROJECT_STATE.md`, `docs/ROADMAP.md`, `docs/DECISIONS.md`. Project Godot 4.7.x GDScript and D328 Card DS3 locked layout. The earlier A1P3 48/48 native GUT PASS and 8 smoke tests (https://github.com/zampolit73/Misdeal/actions/runs/39964999071) have already been merged; real complete F5 12+XIII playthrough is still pending. Preserve these files and never revert current QA work when editing art.

## Final approved D346 exact visual

Card `rattling_bridge`, title «ГРЕМУЧИЙ МОСТ», text «Костяной мост трещит под ногами. На другой стороне может ждать не только добыча.» User chose rendered option **3** «Последний шаг», showing broken wooden-bone bridge over deep abyss to castle gate. User drew red region and asked (1) DELETE second far-off bridge/ruins in upper middle-left, (2) EXTEND existing fortress from the right, (3) specifically make left background a seamless continuation of the SAME main castle instead of another second bridge or exit. Last finished painting `/mnt/data/a_dark_atmospheric_high_detail_gothic_fantasy_sc.png`, 1608×978 RGB, original SHA256 `5caa7ed39672acffed934106b16a11c4cf6f7095196672f65fe1569cf4b1d719`, is the **ONLY APPROVED VERSION**. User said «отлично. утверждаем и заливаем в гит» and then «отлично, продолжай»; previous assistant returned only a path. THIS D346 commit fixes that by uploading native art and source-of-truth documentation.

Visual: broken wood planks and bone ornaments/large skull to front left/right, chains and dark-red banners, orange fire from braziers against misty slate-blue chasm; main Gothic portcullis at upper right and uninterrupted long castellated fortress wall stretching to mid-left. NO second distant viaduct/bridge, NO separate secondary castle entry. Do not use earlier `проклятый_мост_к_крепости.png`, `wide_cinematic_dark_fantasy_scene_a_gloomy_atmos.png`, or the annotated red screenshots as final images.

Game file `assets/pixel/card_unification_v1/run/rattling_bridge_d346_approved_continuous_castle.webp` DS3-native 448×274 WebP, Lanczos from (4,0)-(1603,978) crop, quality 86, SHA256 `bbc2fe880a837f022ec01e1473380c2dae98e11de3a6062dfd205030d18e491c` Git blob `ef1a3c1656df6a3f2bde531a5ad46ea4b25c297c`. `scripts/ui/card_unification_v1.gd` maps `RUN_CARDS["rattling_bridge"]` to it. `scripts/dev/d315_card_ds3_smoke.gd` verifies exact SHA and decodable 448×274 catalog texture identical to approved bytes, now 15 artworks. Legacy `EVENTS` fallback, `resources/cards/rattling_bridge.tres`, event behavior and game mechanics untouched. D345 `chained_prisoner`, D344R2 `candle_seller`, D343 `lost_purse`, D342 `ash_rest` and all earlier art remain locked.

## Next

Check post-D346 native Godot smoke via actual CI if possible; static GitHub readback alone ≠ native PASS. User: `git pull`, F6 `scenes/dev/d315_card_ds3_gallery.tscn`, inspect «ГРЕМУЧИЙ МОСТ» at intended card size. A1P3 local human 12+XIII playtest remains priority (see `docs/A1P3_LOCAL_PLAYTEST.md`). If user continues visual process, D347 select a fresh unapproved event (possible `last_camp` / `curse_forge`), check actual resource and registry, show 2–3 *actually generated distinct* dark-fantasy paintings in chat, user selects, then commit. Preserve user's palette, reduce AI-detail noise and avoid redundant castles/long horizons.

## Consolidated project continuation — locked visuals, scope, QA

This is the short, one-file continuity index; use the named primary project files for implementation details. Project is a cursed-table dark-fantasy roguelike hosted by an evil wizard, with TWO card offers at a time and a compact tactical autobattler. Pick Knight/Ranger/Mage and recruit other former-life companions conditionally. Fate Spread resolves I–XII and XIII is Bone Warden. Do not change core rules, story truth or party mechanics without discussing them with the user. The Act I castle mystery slowly reveals what the hero did when its defenders waited for reinforcements; old memories, surviving witnesses and a morally hard decision are the creative through-line. The user favors clear authored illustration, charcoal/blue shadows and warm rust-red highlights, slightly pixelized imagery and restrained objects, NOT crowded AI-style scatter/detail. Keep approved D328 Card DS3 one ornate frame, optical centering and no UI baked into artwork.

### Approved cards already in `main` (do not re-approve or repaint)

| Release | Card ID | Exact visual decision |
| --- | --- | --- |
| D319 | `black_altar` | Third approved gloomy altar image |
| D331 | `blood_ledger` | Scribe at his book, signature crimson/black palette |
| D331 | `bone_crush` | Fortress breach, user-selected composition |
| D333 | `bone_patrol` | Approved night watchtower, skeletons |
| D335 | `bone_ritual` | Third restrained necromancer ritual |
| D336 | `graveyard_ambush` | First graveyard ambush |
| D337 | `gallows_volley` | First gallows archers |
| D338 | `bone_swarm` | Second selected genuine rushing melee swarm, not a sparse patrol |
| D339 | `grave_crossfire` | Third flanking archers/guard |
| D340 | `whispering_well` | First ghostly face reflected in dark water |
| D341 | `gravedigger_shop` | LIVE elderly bearded man/merchant at crimson sunset, cleaned scene |
| D342 | `ash_rest` | Small campfire/bedrolls by old wall, distant right-hand ruins REMOVED |
| D343 | `lost_purse` | Open golden purse and skeletal hand with reclining corpse HEAD OUT OF FRAME |
| D344R2 | `candle_seller` | LATEST user-approved occult candle stall, hooded trader and 3 ivory/red/slate candles, gothic cabinet; supersedes earlier slim candle D344 art |
| D345 | `chained_prisoner` | Second «Старый знакомый», living chained former soldier staring directly at hero from behind bars |
| D346 | `rattling_bridge` | Last selected broken bone/wood bridge to fortress with ONE continuous background wall; remove second viaduct/exit, not the castle |

All these files and their SHA-256 details are in `docs/VISUAL_ASSET_REGISTRY.md`. Do not confuse similarly themed `ash_rest` («Пепельный привал») with `last_camp` («Последний привал»). Keep legacy fallbacks and user-approved originals intact when adding new artwork.

### Technical QA and active workstreams

- A1P1 wizard remarks about rejected cards at existing milestone turns 3/7/11 (voice only), without rewriting deck, Fate Hold or routes.
- A1P2 validated 36 deterministic `RunState` 12+XIII **structural** routes (solo, duo, trio) and fixed held noncombat cards being returned on compulsory fight turns; this is not a fully played battle-by-battle run. Source `docs/A1P2_ACT1_ROUTE_AUDIT.md`.
- A1P3 merged real `Table → ActChoice → Battle → Reward → RunEnd` scene-handoff tests, including injected victory/defeat and companion scar, and removed redundant full-rect decoration sizes causing native Godot warnings. Prior native CI run `39964999071`: 48/48 GUT, 5860 assertions, 8 smoke tests PASS on Godot 4.7.2. **Human normal-game F5 playtest across 12+XIII has NOT been signed off**; follow `docs/A1P3_LOCAL_PLAYTEST.md`.
- CI5 before A1P3 also captured real Court/Grave Bell Battle scenes, movement and 75 original Court pose frames (3 × 25), but screenshots are not proof of perfect artistic quality or smooth gameplay. Preserve workflows and tests.
- D315 smoke now checks 15 user-approved art files including D346 via exact approved SHA, WebP decode, 448×274 size and `CardArtCatalog.get_run_card_texture` pixel equality. The pre-D346 green CI is **not** evidence that this just-committed art passed in Godot; run a fresh native test or ask user to inspect gallery.

### Procedure for the next session

1. Read repo rules and active docs listed above, then `docs/D346_NEW_CHAT_HANDOFF.md` plus visual registry, `docs/A1P3_NEW_CHAT_HANDOFF.md` and playtest guide. **Use connected GitHub yourself**: do not claim access is unavailable without checking it; commit finished changes and update docs. Never force the user to copy code.
2. D346 owner action: `git pull`, Godot F6 `scenes/dev/d315_card_ds3_gallery.tscn`, inspect «ГРЕМУЧИЙ МОСТ». Separately F5 real 12+XIII first-act playtest when feasible. Do not say these local human checks have passed until actual evidence arrives.
3. Next **visual** item D347: check `resources/cards/last_camp.tres` (or another not-yet-illustrated card if overlapping prior art). Present **2–3 actual, visibly different images in the chat**; user selects, optionally requests edits; only then integrate that exact final image to GitHub and refresh D315 and documentation. Keep proposals as real images, not text-only descriptions or storyboard posters.
4. After substantial implementation refresh `PROJECT_STATE`, `ROADMAP`, `DECISIONS` for genuine locked decisions, `CHANGELOG`, `HANDOFF`, visual registry and latest numbered consolidated handoff. Another chat must be able to resume from `main` plus these docs without prior dialogue.

