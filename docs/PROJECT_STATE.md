# Misdeal — Current Project State

Updated: 2026-10-16 (D200 selected third card illustration F6 user-confirmed; arena concepts next). Source of truth: `zampolit73/Misdeal` / `main`.

## Safety snapshot: КАРАМБА73

User requested a 2026-10-16 fixed restore point for the **entire GitHub-tracked Misdeal project**, current game and development context. Frozen branch: `backups/KARAMBA73-2026-10-16`; exact recovery process and snapshot scope: `docs/checkpoints/KARAMBA73_2026-10-16.md`. The saved milestone is **37/45 released cards**, #38 QA-only, D200 third card artwork user-native-approved, D201 empty battle-arena concepts awaiting a choice. Saying **КАРАМБА73** later authorizes restoring this saved Git tree to `main` while first preserving the then-current `main` on a separate safety branch. Tracked GitHub files only; not unknown local Godot/untracked files.

## Live playable baseline

Godot **4.7.x / GDScript** dark-fantasy card-driven roguelike: evil Wizard hosts a cursed 12-resolution Fate Spread; the central Bone Warden is sealed as **XIII**. Knight / Ranger / Mage protagonists, conditional companion recruitment and loss (solo, duo, trio), decision cards, prepared tactical autobattles, rewards and return to the table all exist. DS2 / Fate Spread Variant C is the accepted UI. Preserve existing party-size compensation and Wizard Debt/Mark logic.

**Act 1 random-deal pool: 37/45 cards.** `RunState.ACT1_CARD_IDS` now includes:
- **#34** D151 Funeral Procession — original Funeral Priest and Pallbearers; localized Last Rite.
- **#35** D152 Defiled Laboratory — original Alchemist and Homunculus; localized chemical hazards.
- **#36** D153 Threadbare Theatre — original skeletal Puppeteer and Marionettes; localized tethers.
- **#37** D198 **Black Crossing / ЧЁРНАЯ ПЕРЕПРАВА** — original drowned Ferryman + two Drowned; localized storm waves.

There are **eight remaining planned cards** to reach 45. Boss XIII is NOT in the regular pool.

## Release QA and boundaries

**D153 (#36):** User-native D178 matrix **54/54 wins**, mean surviving HP 74/67/74% (solo/duo/trio), user-confirmed real reward→table, D181 native release smoke **PASS**; its smoke guards have now been updated for the 37-card pool. Keep the puppets skeletal and the approved original artwork.

**Black Crossing (#37):**
- **D182–D187 accepted visuals:** selected card illustration variant **3** (448×274), Ferryman **B** / Drowned **C** 25-pose original animations, and cleaned 1280×720 storm arena **«Последний причал»**. Assets are already in GitHub; do not redraw or replace them.
- **D188–D191 original combat:** two formations of one Ferryman + two Drowned. User-native **D191 functional PASS: 54/54 wins, 0 party defeats**; solo/duo/trio 18/18/18 and Knight/Ranger/Mage 18/18/18, mean surviving HP 86/74/77%, worst 58/42/50%, 78 warnings / 62 impacts / 66 pushes / 66 slow resets. Shared D189 bounds lock feet and impulses to the intact upper planks.
- **D196 visuals:** storm-wave renderer draws three rolling breakers with a 94px forward impact, foam and runoff, while damage remains zero, push 43px left and 30% slow for 1.6s. User said **«давай пока оставим этот. продолжай»**. Leave D196 as the current baseline; do not return to wave tuning without new feedback.
- **D197 native route QA:** after F6 preflight and pressing the actual battle→reward→table button, user replied **«Все ок»**. Treat pre-release real navigation as approved.
- **D198 live-source release:** `black_crossing` is in `RunState.ACT1_CARD_IDS` as card #37. Legacy D151–D153, shepherd and D188 regression guards were updated to 37. Added `res://scenes/dev/black_crossing_release_smoke.tscn`: it tests all 37 unique cards, original assets/formation, real **full-pool** random Tier1 offers (80 deterministic seed samples, without a two-card fixture), production selection/completion/Fate Spread and sealed boss XIII.
- **D198 user-reported native release smoke PASS:** after being asked to run `git pull` and F6 `res://scenes/dev/black_crossing_release_smoke.tscn`, the user replied **«все ок»** (2026-10-16). Treat the 37-card ordinary-pool release gate as satisfied by the user's confirmation, not as an independently captured engine log or screenshot. Card #37 is fully released. D191 54/54 remains valid because D198 changed only deck registration.

## D203 arena staging evaluation (not production)

Used the newly supplied artist/designer/developer skill archives for D201 art QA. Generated castle/causeway concepts remained too visually repetitive; **no arena was approved, committed as game art or assigned to #38**. The existing D201 option #2 (1280×720) was used **only** as a temporary staging test with 3 hero proxies, 5 skeletal enemy proxies (2× tall Guide), and 2 illustrative light zones. The production default ground bounds map to screen X110–1190 and Y380–538. Result: the region accommodates the intended figures, but excessive baked lamp highlights clash with the gameplay cue, so an alternate **dead-forest / ford / toll-gate** environment needs user selection. Details: `docs/D203_BLACK_LANTERN_ARENA_ART_QA.md`. Annotated preview `d201_arena_gameplay_clearance_test.png` is a **conversation attachment**, not a playable or committed arena. The frozen **КАРАМБА73** backup is unchanged. Act1 still **37/45**.

## Next action

**D199 card #38 concept and latest character design explicitly user-approved (NOT LIVE):** `black_lantern_road` / «Дорога чёрных фонарей», Tier1 combat. User chose **third gameplay option**, then **first** of 3 generated moonlit forest-road images, requested lower AI visual noise, Act1 skeleton consistency and **more than 3 enemies**. After a cleaner scene and 2×-height giant Lantern skeleton iteration, the user approved the **last five-role concept sheet** («последняя концепция подходит»). Exactly **5 proposed distinct skeletal enemies**: Погасший проводник (large ~2× height, heavy lantern yoke, cloak/chains), Носильщик фонаря, Страж дороги, Масляный служка, Стрелок фонарей. Encounter-local, telegraphed shifting lanternlight zones temporarily empower undead; numeric values/balance pending. **This final sheet is NOT a text-free card illustration, arena background or combat animation atlas.** See `docs/DECK_EXPANSION_D199_BLACK_LANTERN_ROAD.md` for reference ID and production contract. **D200:** after three further production illustrations, the user chose the **third** (`лунный_марш_скелетного_легиона.png`). Its exact 1604×981 composition was resized text-free to 448×274 and committed as `assets/pixel/card_unification_v1/run/black_lantern_road_selected_v1.webp.b64`, with a strict cached unified loader, standalone QA-only `resources/cards/black_lantern_road.tres` and native F6 `res://scenes/dev/black_lantern_road_card_preview.tscn`. No encounter target yet, no change to `RunState.CARD_PATHS` or live `ACT1_CARD_IDS`. **D200 F6 card-art acceptance USER-CONFIRMED** (user replied «вск ок» to the requested `black_lantern_road_card_preview.tscn` check on 2026-10-16; native screenshot/log not independently collected). **Next propose separate safe 1280×720 arena variants for user selection, then create five original animation atlases**, then local light mechanic and 54-case combat QA; keep new card outside normal pool until all gates pass. Live Act1 remains **37/45**. Preserve D196 waves, D151–D153, #37 art, 12+XIII and party scaling.

Binding rules: D143 genuinely new enemies and encounter mechanic for each new combat card; D167 credible scene-first dark-fantasy art; D168 show 2–3 actually rendered variants *before* replacing card art. Preserve D151–D153, accepted DS2 and original user-selected sources.

Canonical next-chat notes: `docs/HANDOFF.md`. Specific encounter spec: `docs/D188_BLACK_CROSSING_ENCOUNTER.md`. Deep history remains in Git commits and `docs/archive/2026-10-15-pre-cleanup/`.
