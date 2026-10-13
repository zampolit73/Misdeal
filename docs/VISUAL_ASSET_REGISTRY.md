### FIRST WAVE COMPLETE — 2026-10-13 — D135 last 5 standalone WebP assets in GitHub

New five separate user-approved images from `docs/CARD_ART_WAVE1_REMAINING5_BRIEF.md` uploaded as **raw GitHub binaries** in `ac860ad2cacf17e7ab4e64c54f2ddfb70debd146`. Paths relative to `assets/pixel/card_unification_v1/`, SHA256 of the actual shipped WebP bytes:

| Live ID | Relative path | Pixels | Bytes | SHA256 |
|---|---|---|---:|---|
| `gravedigger_shop` | `run/gravedigger_shop.webp` | 448×274 | 42900 | `27d946f5d00366d3c53ff148f5525a83a75129364055acb67bda84d98901a667` |
| `bone_swarm` | `run/bone_swarm.webp` | 448×274 | 60158 | `444558761d3715a264025dd2cbe0d3925f1765aafbe21facb31805680fcf3664` |
| `grave_crossfire` | `run/grave_crossfire.webp` | 448×274 | 39878 | `d501bef16504efb8b73a175e6f41b866522d73555370974e083200d4f8123f8a` |
| `candle_seller` | `event/candle_seller.webp` | 1280×720 | 215846 | `33130fc7634cca9a1382effdf1319f6abcf8a6fd91a53176621fe5cce3605641` |
| `last_camp` | `event/last_camp.webp` | 1280×720 | 217006 | `ef6116ce8f8af9431642667752579e51363e8e0ccb071a118b1904f8658f0bc5` |

Git blob IDs remotely verified (all five). Mappings added in `scripts/ui/card_unification_v1.gd`: 3 `RUN_CARDS`, 2 `EVENTS`; original atlas event-path fallback remains. `gravedigger_shop` only overwrites its dealt-card illustration, NOT the separately approved Gravedigger Shop live DS2 appearance/economy; `bone_swarm` / `grave_crossfire` replace only offer card art, with combat logic untouched; `candle_seller` / `last_camp` supply both event background and cropped deal-card image through existing resolver. Exact source PNG titles/gen IDs and user approval: decision D135. New `scenes/dev/card_unification_final5_preview.tscn` F6 gallery for these five. Total D131 4 + D132 4 + D134 5 + D135 5 = **18/18** first-wave source inventory illustrations now committed, **without a Godot 4.7.x runtime certification**. User needs local smoke.

---

### ACTIVE UPGRADE AND REWARD ART — 2026-10-13 — D134 five files in GitHub main

Approved as five separate latest images and shipped as real WebP binaries in `e3729a4a86a9cce006ec8803fa6e7e0aa1f00de5`. All source 1570×1002, exported **608×388**, quality 90, directly resampled, no collage upscaling. Paths relative to `assets/pixel/card_unification_v1/`:

| Live ID | File path | Bytes | SHA256 |
|---|---|---:|---|
| `knight_iron_oath` | `upgrade/knight_iron_oath.webp` | 84528 | `57dc237b0ec6ea7fe785e82d633cd04043a788ac2d9f35337ca54229d77f59e9` |
| `ranger_arrowstorm` | `upgrade/ranger_arrowstorm.webp` | 79182 | `2d2ce9078d81de6fbbf066fe52e6ad3ed6ef0f0d545632168a3f6526fa5e7a5d` |
| `mage_glass_heart` | `upgrade/mage_glass_heart.webp` | 89166 | `25cda1fb23898a5ab5cfd7f2e0b8f2b6156e95b66ffd6e24267a47ca422bcf4e` |
| `gold_windfall` | `reward/gold_windfall.webp` | 89446 | `ac955a469970f05f3c92cdfd5a36e754441b256c213c0e1b19396c5ef663d8d0` |
| `relic_wager` | `reward/relic_wager.webp` | 56646 | `6cc40c40c20abbbd8557ad08c0d38446c134e20c5ec2d15c9d5da68cb829b669` |

The `CardArtCatalog.get_upgrade_texture()` / `get_reward_texture()` override lookup is already present. Original fallback atlas is retained; no UI/code changes in this art commit. User accepted images as drawn; local Godot in-engine QA still pending. User requirements: male gray-bearded wizard for `mage_glass_heart`, skeletal hand gripping ruby for `relic_wager`. D134 records exact source image names and generation IDs. **13/13 pictured D130 slots now have binary assets**; earlier 18-art inventory has additional 5 candidate-only items still outside approval/deployment.

---

### LIVE EVENT BACKGROUNDS — 2026-10-13 — D132 four approved 1280×720 WebPs in main

Binary delivery completed in `1722d070cfe5a5690596953a1465b198177a57b3`; paths below have their own separate approved event compositions (user signed off, no further generation needed):

| Event ID | New WebP, relative to `assets/pixel/card_unification_v1/event/` | Bytes | SHA256 |
|---|---|---:|---|
| `curse_forge` | `curse_forge.webp` | 284100 | `04658f71ce0aff97ed77235165fb7a9ea05f3ad848fe89b49239a31bf47b03ea` |
| `black_altar` | `black_altar.webp` | 213172 | `33dcb8351ca90da60e91e0fcaf5b7c0a6e27d6ad830d6434d453de8f8472b933` |
| `chained_prisoner` | `chained_prisoner.webp` | 251358 | `97ddc751b5390407269ebf8fb0dbb53a4ea41b6bdb1ab2077455dcf632093fb7` |
| `rattling_bridge` | `rattling_bridge.webp` | 179336 | `e85c8385f9dae40c9f05310a04f6d01e9f56081bfad6b7e0f66fb14b3cdebe8b` |

All exactly 1280×720 WEBP quality 91 exported from latest approved 1672×941 originals, rather than upscaled D130 contact sheet crops. Remote GitHub blobs verified; existing `card_unification_v1.gd` and `act_choice.gd` choose these first, preserving older backdrops as fallback. **In-engine live visuals remain for user to check**. D132 binds four exact source concepts. No other event/DS2/UI screen modified. Keep these distinct from 448×274 RunCard art.

---

### ACTIVE CARD ART — 2026-10-13 — D131 four approved deal-card WebPs now in GitHub main

The user-approved latest four D131 images were exported from their native 1604×981 PNGs as dedicated **448×274 WebP** (quality 82, not resized from the previous small concept collage) and committed as actual binary blobs in **`9d864113d66236111b8a3f048afaac35416cedf1`**:
- `assets/pixel/card_unification_v1/run/bone_patrol.webp` — 28,422 bytes; SHA256 `98d49a68620a0c096b90e9840d7cb6918ab090c519b9a129a7de4c6bb5dc515a`
- `assets/pixel/card_unification_v1/run/graveyard_ambush.webp` — 28,626 bytes; SHA256 `120b2410843b51e13162cf6a6e59f5c82b2da9819dff491926ea3b4fd614775f`
- `assets/pixel/card_unification_v1/run/gallows_volley.webp` — 20,632 bytes; SHA256 `4b71652ba533aff009a41988bf1b1c4e5fb088a8ce9f2b61d1a77565b88455f0`
- `assets/pixel/card_unification_v1/run/whispering_well.webp` — 29,670 bytes; SHA256 `2b6cd5446498264b493626fd772015ed860c00affd316dba8dfd80d983960665`

All four GitHub blob SHAs were verified. `scripts/ui/card_unification_v1.gd` is already loaded by `scripts/ui/card_art_catalog.gd` and selects these textures before previous v4 atlas. Existing art atlas remains as safe fallback. This modifies table **card images only**: the Whispering Well full event screen and DS2 Fate Spread stay untouched. D131 contains the precise approved originals/generation IDs and character requirements. **Local Godot F6/actual table visual QA is still pending.** The earlier chat artifact `misdeal_card_art_wave1_import.zip` included obsolete blurry versions for these four IDs and must not overwrite the new files after pulling. If those ZIP files were previously extracted as untracked files, remove/move just those four WebPs before `git pull` to avoid Git refusing to overwrite untracked paths.

---

### CURRENT MAGE — 2026-10-12 — clean bearded Mage sheet

- New active Mage `assets/pixel/units/combat_units_anim_v2/mage.webp.b64` commit `9d72854`, transparent 576×480, 25 used frames; old low-quality Mage archived `mage_archived_pre_dark_clean.webp.b64` commit `089b9fd`.
- Mage hero-only scale 1.65 remains as visually accepted in screenshot; Mage attack plays six authored frames (`6ce91f9`).
- Pending Godot F6 and actual battle review for alpha, limb silhouette, attack effects and ground contact.

### CURRENT MAGE ART — 2026-10-12 — elder bearded Mage atlas committed

- Active Mage: `assets/pixel/units/combat_units_anim_v2/mage.webp.b64` (`3e23cc8`), approved variant 1 of latest three concepts; white-bearded elder in dark-violet robes with glowing staff. Prior Mage asset archived as `mage_archived_pre_oldbeard.webp.b64` (`4c0e94a`).
- Existing SpriteFrames animated role remains unchanged in code. Remote file matches approved source. Local Godot F6 and live fight QA are pending, especially 25-pose boundaries, attack projectile and alignment.
- Other Pack 1/Pack 2 role configuration unchanged.

### CURRENT UNIT ART — 2026-10-12 — Blue Knight frame animation active

- Approved blue Knight 576×480 atlas is now `assets/pixel/units/combat_units_anim_v2/knight.webp.b64` (`6afd288`), with the prior flawed sheet preserved as `knight_archived_pre_blue.webp.b64` (`0101679`). Live `BattleUnit` no longer excludes Knight from SpriteFrames (`dffa7ee`).
- All Pack 1 five roles and Pack 2 four enemies are now animation-enabled (asset-dependent static-v4 fallback). Local Godot F6 and real fights are required to accept boots, attack frames and overall coherence.
- Older registry statements below claiming Knight is static v4 are historical and superseded by this header.

### PACK 2 CURRENT STATUS — 2026-10-12 — Four enemy animated sheets committed

- **Active Pack 2 sheets:** `assets/pixel/units/combat_units_anim_pack2_candidates/{bone_thrall,grave_bellkeeper,crypt_guard,bone_warden}.webp.b64` — 576×480 transparent WebP Base64, 6×5 × 96px, 25 used frames per role.
- **Last asset:** Bone Warden (`77a759d`), **loader:** `1238b3c`. `MisdealUnitAnimationLibrary` selects all 4 Pack 2 roles with v4 fallback. Existing Stage A attack VFX unchanged.
- **Godot quality gate remains open:** F6 5-state inspection and in-battle grounding/phase verification needed, especially for boss attack arc and death. Knight static v4; Ranger/Mage/Skeleton/Bone Archer Pack 1 v2 animated.

### CURRENT PACK 2 STATUS — 2026-10-12 — Crypt Guard added

- Pack 2 active animation roles: `bone_thrall`, `grave_bellkeeper`, `crypt_guard`; each has transparent 576×480 Base64 WebP in `assets/pixel/units/combat_units_anim_pack2_candidates/` and is loaded by `MisdealUnitAnimationLibrary` with v4 fallback.
- Crypt Guard commit: asset `5412b1d`, loader `fa78548`; offline 25-frame grid QA passed but in-engine F6 and battle review still pending.
- `bone_warden` remains static v4 with Stage A contact FX and needs a genuinely authored sheet. Knight intentionally static v4; the four other Pack 1 roles remain animated.

### CURRENT STATUS — 2026-10-12 — Pack 2 Bone Thrall + Grave Bellkeeper

- **In GitHub and used by production loader:** `assets/pixel/units/combat_units_anim_pack2_candidates/bone_thrall.webp.b64` and `grave_bellkeeper.webp.b64` (transparent 576×480; 6×5; 25 used poses each), v4 fallback. Latest Bellkeeper asset commit `c28011d`, loader commit `9f32e4b`.
- **Still static v4:** `crypt_guard` and `bone_warden`, each with existing Stage A attack-contact VFX. Knight intentionally static v4; other four Pack 1 roles animate as before.
- **QA:** user approved Bellkeeper visual and offline technical frame checks passed, but no Godot F6 or actual combat runtime review has yet occurred. Old registry entries below predating this header are historical.

### CURRENT GAME-ART STATUS — 2026-10-12 — Pack 2 staging complete; new character animation art missing

- **LIVE NOW:** Knight uses readable static v4 (offset -8); Ranger, male Mage, Skeleton and Bone Archer use real Pack 1 v2 frames. Bone Thrall, Grave Bellkeeper, Crypt Guard and Bone Warden still use **static v4** plus already-live Stage A short contact VFX.
- **NOT YET CREATED / NOT IN BATTLE:** 4 authentic per-role transparent 576x480 sheets (6x5 grid, 96px cells; 25 used frames), for `bone_thrall`, `grave_bellkeeper`, `crypt_guard`, `bone_warden`. No candidate `.webp.b64` has been approved or enabled. Candidate folder contains README only.
- **PREPARATION FINISHED:** staged importer `scripts/dev/import_animation_pack2_candidate.py`, isolated Godot validator `scripts/dev/unit_animation_candidate_validator.gd`, F6 comparison `scenes/dev/unit_animation_pack2_preview.tscn`. Details in `docs/UNIT_ANIMATION_PACK2.md`; check manual visual integrity of feet, weapon, pixel art and grounded fall.
- **Important correction:** historical sections below refer to Knight as animated in Pack 1, but its animation was withdrawn from **current production** because legs were unreadable. Keep v4 until redesigned frames pass visual review. Stage B has not altered the production loader or miniature art.
### Animation Pack 1 grounded v2 — live asset set (2026-10-12)

- Canonical live animation assets are now `assets/pixel/units/combat_units_anim_v2/{knight,ranger,mage,skeleton,bone_archer}.webp.b64`. Original `combat_units_anim_v1` remains committed for rollback.
- Cleaned detached previous-row legs/border scraps from generated sheet cuts and vertically aligned all **125 processed frame cells** (124 active character frames; Mage projectile-only frame is excluded) to last solid foot/body contact pixel **y=92** inside their 96×96 cells. The loader applies 2.7 fps Idle, 7 fps Walk.
- Unit animation rest-position is computed in `BattleUnit` from pixel sole center y=92.5 to current floor shadow ring y=36 using effective art scale; all real-world spawn placements and health labels remain unchanged. No combat/game-balance or arena art edits.
- Source review, applied fix and local gate documented in `docs/UNIT_ANIMATION_PACK1.md`.

### Unit Animation Pack 1 — active for five roles (2026-10-12)

- Five 576×480 transparent WebP atlases stored as Base64 text in `assets/pixel/units/combat_units_anim_v1/{knight,ranger,mage,skeleton,bone_archer}.webp.b64` (30 fixed 96×96 slots, only valid cells populated).
- Generated input sheets: `пиксельный_спрайт_лист_синего_рыцаря.png`, `пиксельный_спрайт_лист_лесного_следопыта.png`, `пиксельный_атлас_тёмного_мага.png` (male Mage), `пиксельный_спрайт_лист_скелета_воина.png`, `пиксельный_спрайт_лист_скелета_лучника.png`, each 1374×1145 (6×5 × 229px).
- Layout: row 0 Idle (4 frames), row 1 Walk (6), row 2 Attack (6; male Mage skips isolated projectile slot and uses 5), row 3 Hit (3), row 4 Death (6). Framerates and state rules in `scripts/battle/unit_animation_library.gd`; `BattleUnit` swaps frame textures and syncs rim texture.
- Remaining aliases and units still use static v4. Approved v4 atlas/male-Mage override stay in repo for safe fallback. This animation pass does not modify arena background art or existing map/grid conditions.
- F6 gallery: `res://scenes/dev/unit_animation_pack1_preview.tscn`. Full mapping and visual QA in `docs/UNIT_ANIMATION_PACK1.md`. Godot runtime QA pending.

### Combat Miniatures — approved Unit Art v4 (active 2026-10-11)

- Canonical runtime 3×3 transparent WebP atlas, 288×288, 96×96 per sprite: `assets/pixel/units/combat_units_v4/atlas.webp.b64`.
- Lossless editable 288×288 cutout master: `assets/source_archive/unit_art_v4/combat_units_v4_master.png.b64`; base64 decode to PNG before editing.
- Runtime loading and fixed 3×3 role index mapping: `scripts/battle/unit.gd` (`_get_art_texture`, `_get_unit_sheet_texture`).
- Tile order in the fallback atlas: row 0 `knight`, `ranger`, `mage`; row 1 `skeleton`, `bone_archer`, `grave_bellkeeper`; row 2 `bone_thrall`, `crypt_guard`, `bone_warden`.
- **Active male Mage override (2026-10-12):** `assets/pixel/units/combat_units_v4/mage_male.webp.b64` (standalone transparent 96×96 WebP, decoded in `_get_male_mage_texture()`); fallback is the atlas Mage cell. Lossless tile source: `assets/source_archive/unit_art_v4/mage_male_tile.png.b64`. Enemy sprites use `flip_h=true` on spawn, then turn toward live targets during combat; `RimSprite` flip is synchronized.
- Approved concept choice: Variant A for Knight/Ranger/Mage; detailed undead variants from the approved bestiary sheet. Nine transparent sprites were manually extracted/trimmed from the previously approved concepts, then cleaned.
- `bone_raider` and `crypt_sentinel` UnitData retain `visual_role` aliases to `bone_thrall` and `crypt_guard` pending unique silhouettes.
- Archived v3 parts (`assets/pixel/units/combat_units_v3/part_*.txt`) remain in GitHub for fallback. Game tests still need to validate pixel transparency, readability and labels.

### Fate Spread

- Approved visual direction: ornate physical occult table with red ritual cloth, candle/brass highlights, gothic edge props and chained XIII as the central focal point.
- Approved runtime plate: `assets/pixel/table/fate_spread/fate_spread_exact.webp`
- Live scene: `scenes/table/fate_spread_overlay.tscn`
- Live logic: `scripts/table/fate_spread_overlay.gd`
- Approved source master: `assets/source_archive/fate_spread/fate_spread_exact_master.webp`
- Earlier edge-art masters remain archived under `assets/source_archive/fate_spread_edges/` but are no longer runtime assets.
- Rule: the plate is atmosphere only. I–XII history, XIII state, counters, hold/discard contents and decision memory remain live Godot UI.
- The full plate defines the physical composition. Baked run-specific examples are covered by live masks/cards; `RunState` remains authoritative for cards, counts, Hold/Discard and XIII.

# Misdeal — Visual Asset Registry

Last updated: 2026-10-11

Purpose: make visual-source provenance and runtime mapping recoverable from GitHub without reading old chats.

## Canonical loading rules

- Dynamic text/state/buttons remain native Godot UI.
- Full-screen authored WebPs added through recent passes use runtime decoding through `scripts/ui/runtime_webp_texture.gd` or an equivalent battle-specific runtime decoder.
- New screen art should be native 1280×720 when it fills the viewport.
- Table-card art should stay near live display size or better; do not recreate the rejected 112×69 atlas approach.
- Source/master archives are not runtime dependencies.

## Production visual passes

### Card art

- v4: `assets/pixel/ui/visual_pass_v4/` — accepted corrected near-display redraw atlas.
- v5: `assets/pixel/ui/visual_pass_v5/` — completion batch for remaining table cards.
- v6 Bone Warden card: `assets/pixel/ui/visual_pass_v6/bone_warden_card.webp`.
- Broken Crown table card deliberately shares the approved Broken Crown artifact illustration.

All 25 active Act 1 cards resolve to current matching/object-specific art before legacy safety fallback.

### Battle arenas

Canonical live art: **Arena Redraw v2 (approved pack 1)**, integrated 2026-10-11. Ten arena IDs use native 1280×720 WebP assets in `assets/pixel/battle/arenas/arena_redraw_v2/`. The remaining two retain the prior v1 Base64-WebP payloads until pack 2 is approved and implemented.

| arena_id | Runtime source | Format |
| --- | --- | --- |
| `crypt` | `arena_redraw_v2/crypt.webp` | WebP bytes |
| `graveyard` | `arena_redraw_v2/graveyard.webp` | WebP bytes |
| `gallows` | `arena_redraw_v2/gallows.webp` | WebP bytes |
| `ossuary` | `arena_redraw_v2/ossuary.webp` | WebP bytes |
| `warden` | `arena_redraw_v2/warden.webp` | WebP bytes |
| `bone_crush` | `arena_redraw_v2/bone_crush.webp` | WebP bytes |
| `bone_swarm` | `arena_redraw_v2/bone_swarm.webp` | WebP bytes |
| `grave_crossfire` | `arena_redraw_v2/grave_crossfire.webp` | WebP bytes |
| `iron_wall` | `arena_redraw_v2/iron_wall.webp` | WebP bytes |
| `last_bell` | `arena_redraw_v2/last_bell.webp` | WebP bytes |
| `firing_square` | `arena_redraw_v1/firing_square.webp.b64` | Base64 WebP text |
| `bone_ritual` | `arena_redraw_v1/bone_ritual.webp.b64` | Base64 WebP text |

`scripts/battle/authored_backdrop.gd` is the authoritative live selector. It loads raw `.webp` bytes for the approved new pack and decodes legacy `.webp.b64` for the remaining two arenas; both paths create an `ImageTexture` and use nearest-neighbor fallback resizing. Live unit sprites, HUD, tactics, deployment and encounter data remain unchanged.

The new visual direction limits each environment to one dominant meaningful landmark, believable geography and a broad readable central combat floor. It preserves the existing Misdeal blue-black moonlight, warm firelight and restrained crimson gothic identity while avoiding repetitive AI-looking castles. The earlier `arena_redraw_v1`, `visual_pass_v4/v6` and `combat_expansion_v1` assets remain in Git history/repo for rollback. The 1672×941 PNG generation masters remain in the conversation package `misdeal_arena_redraw_pack1_review.zip`; the committed native WebPs are the complete runtime sources.

See `docs/ARENA_REVIEW_2026_10_11.md` for the approved arena-to-landmark map and local-validation checklist.

### Main menu

- Canonical main splash: `assets/pixel/main/approved_splash_hd/main_splash.webp`
- Runtime scene: `scenes/main/main.tscn`
- Runtime loader: `scripts/main/approved_main_backdrop.gd`
- Production size: 1280×720 WebP
- Accepted direction: restrained dark-gothic Wizard at the cursed table, reduced prop noise, red-black-gold foreground against cool moonlit city, live hotspot/UI kept outside the art.
- Superseded: the older compressed three-part splash and the intermediate over-rendered/off-model Wizard redraws.

### Wizard table

- Canonical runtime plate: `assets/pixel/table/approved_variant_c/table_exact.webp` (1280×720)
- Approved source master: `assets/source_archive/table/approved_variant_c/table_exact_master.webp` (1672×941)
- Approved normal-table composition: **final Variant C** — restrained oval ritual tabletop, Wizard centered behind it, two offer cards near the player, physical deck/discard holders at the sides.
- Superseded normal-table backdrop: `assets/pixel/table/visual_pass_v6/table_wizard.webp` (kept in repository history/assets, no longer referenced by `table.tscn`)
- Procedural `scripts/table/table_visual.gd` and `scripts/table/table_spread_visual.gd` remain available but are hidden on the canonical normal table.
- Scene/runtime logic: `scenes/table/table.tscn`, `scripts/table/table.gd`
- The full approved plate is the runtime visual foundation; run-specific cards, counts, Hold state, Wizard text and buttons remain live Godot UI aligned over it.
- Detailed run progress is not duplicated here; `РАСКЛАД СУДЬБЫ` owns the full I–XIII progression view.
- Important: authored table art bypasses the old heavy environment/card grade.
- Shared neutral card back: `assets/pixel/table/card_back_runtime.svg`.
- Runtime foundation rule: the two baked sample offer faces in `table_exact.webp` are permanently covered by neutral physical card backs beneath the live offer layer. Do not restore dark cleanup masks.
- Fate Spread Hold uses the same back when empty; Wizard Discard hides when empty and uses the back as the physical frame under the live top card when populated.
- Local status: the physical card-back pass is committed; local 1280×720 verification is pending.
- Visual lock: Fate Spread is frozen; the exact Variant C plate is the canonical normal-table art. Do not return to the procedural oval-table approximation.

### V7 high-visibility screens

- Knight portrait: `assets/pixel/class_select/v7/knight.webp`
- Ranger portrait: `assets/pixel/class_select/v7/ranger.webp`
- Mage portrait: `assets/pixel/class_select/v7/mage.webp`
- Reward: `assets/pixel/reward/v7/reward_backdrop.webp`
- Whispering Well: `assets/pixel/event/v7/whispering_well.webp`
- Curse Forge: `assets/pixel/event/v7/curse_forge.webp`
- Chained Prisoner: `assets/pixel/event/v7/chained_prisoner.webp`
- Black Altar: `assets/pixel/event/v7/black_altar.webp`
- Run End: `assets/pixel/run_end/v7/run_end.webp`

The same portraits are reused by Squad Dossier.

### Event choice mini-art

- Runtime mapping: `scripts/ui/approved_event_choice_art.gd`, consumed by `scripts/event/act_choice.gd` and `scripts/event/whispering_well.gd`.
- Visual rule: context art describes the event; mini-art describes the action. One dominant object/gesture/action is preferred over three repeated crops of the event image.
- Native 384×160 choice cells are preferred whenever an approved source already exists; the compact 192×80 sheet is now a fallback source, not the desired presentation size.
- Native Rattling Bridge source: `assets/pixel/event/choice/rattling_bridge_hd/` — 1152×160, three 384×160 cells: rescue / bag / walk away. Used for both bridge branches and as generic rescue/bag/leave actions where semantically truthful.
- Native approved Well/Prisoner atlas: `assets/pixel/ui/approved_event_choice_polish/event_choice_atlas.bin` — 1152×320, six 384×160 cells. Provides whisper, coins, occult-card, broken-chains and body-search actions.
- Compact approved sheet: `assets/pixel/event/choice/approved_choice_sheet_v2/` — 576×320, 192×80 cells. It remains the source for the approved Black Altar blood-sacrifice and cursed-offering cells; runtime reconstructs it before use.
- Reusable action vocabulary exposed by `ApprovedEventChoiceArt.get_action_texture()`: `rescue`, `bag`, `leave`, `whisper`, `coins`, `occult_card`, `chains`, `loot_body`, `blood`, `cursed_relic`.
- Explicit semantic event mappings now include Rattling Bridge, Whispering Well, Chained Prisoner, Black Altar recruitment, Lost Purse, Debtor Bones, Wizard Tithe, Blood Ledger, Bone Tax, Ash Rest recruitment and Last Camp recruitment.
- Curse Forge continues to use actual artifact art because its three choices are concrete relics.
- Role-development choices continue to show the actual offered upgrade art.
- Broken Crown now shows crown / coins / actual offered upgrade (or cursed-relic fallback) instead of three copies of the crown.
- Superseded runtime path: `assets/pixel/event/choice/black_altar_recruitment.svg`.


### V8 secondary event screens

| card_id | Runtime art |
| --- | --- |
| `candle_seller` | `assets/pixel/event/v8/candle_seller.webp` |
| `gravedigger_shop` | `assets/pixel/event/v8/gravedigger_shop.webp` |
| `blood_ledger` | `assets/pixel/event/v8/blood_ledger.webp` |
| `faceless_card` | `assets/pixel/event/v8/faceless_card.webp` |

### V9 final generic-event screens

| card_id | Runtime 1280×720 art | Archived generated master |
| --- | --- | --- |
| `rattling_bridge` | `assets/pixel/event/v9/rattling_bridge.webp` | `assets/source_archive/visual_pass_v9/rattling_bridge_master.webp` |
| `lost_purse` | `assets/pixel/event/v9/lost_purse.webp` | `assets/source_archive/visual_pass_v9/lost_purse_master.webp` |
| `debtor_bones` | `assets/pixel/event/v9/debtor_bones.webp` | `assets/source_archive/visual_pass_v9/debtor_bones_master.webp` |
| `bone_tax` | `assets/pixel/event/v9/bone_tax.webp` | `assets/source_archive/visual_pass_v9/bone_tax_master.webp` |
| `wizard_tithe` | `assets/pixel/event/v9/wizard_tithe.webp` | `assets/source_archive/visual_pass_v9/wizard_tithe_master.webp` |
| `ash_rest` | `assets/pixel/event/v9/ash_rest.webp` | `assets/source_archive/visual_pass_v9/ash_rest_master.webp` |
| `last_camp` | `assets/pixel/event/v9/last_camp.webp` | `assets/source_archive/visual_pass_v9/last_camp_master.webp` |
| `broken_crown` | `assets/pixel/event/v9/broken_crown.webp` | `assets/source_archive/visual_pass_v9/broken_crown_master.webp` |

Original V9 generated filenames from the conversation:

- Rattling Bridge — `лунный_мост_над_проклятым_ущельем.png`
- Lost Purse — `лунная_дорога_среди_мёртвых.png`
- Debtor Bones — `лунный_алтарь_костяных_костей.png`
- Bone Tax — `лунный_костяной_алтарь_у_готических_врат.png`
- Wizard Tithe — `готический_алтарь_под_полной_луной.png`
- Ash Rest — `готический_лагерь_под_полной_луной.png`
- Last Camp — `одинокий_лагерь_под_готическим_собором.png`
- Broken Crown — `разбитая_корона_в_лунных_руинах.png`

The archived masters are 1672×941 Q95 WebP exports from those generated PNGs. The runtime copies are separate 1280×720 production assets.

## Rejected / superseded art paths

### Rejected low-resolution v3

The broad v3 integration used roughly:

- 112×69 card cells;
- 320×180 arena cells.

It was locally rejected because upscaling produced muddy/blocky presentation. Do not restore this pipeline.

### Strong double grading

Legacy environment/card grade on already-dark authored art caused black crush on battle/table/event screenshots. Current authored surfaces either bypass it or use substantially reduced fallback strength.

### Generated full-screen UI mockups

Approved mockups may guide composition, but baked gameplay values/buttons/text are not production runtime UI. Preserve live Godot controls.

## Source preservation

Earlier production passes (v4-v8 and battle/table v6) are already recoverable from their committed runtime assets and Git history.

V9 additionally keeps larger source masters under `assets/source_archive/visual_pass_v9/` because these were the last generated images immediately before the transition away from broad art replacement.

If a future pass needs a different crop or export, start from the archived master where available rather than regenerating a new scene.

## Combat Expansion v1 dedicated visual set — 2026-10-11

The six gameplay-test encounters now have approved dedicated arena and card exports.

| Encounter | Battle backdrop | Table card |
| --- | --- | --- |
| `bone_swarm` | `assets/pixel/battle/arenas/combat_expansion_v1/bone_swarm.webp` | `assets/pixel/ui/combat_expansion_v1/cards/bone_swarm_card.webp` |
| `grave_crossfire` | `assets/pixel/battle/arenas/combat_expansion_v1/grave_crossfire.webp` | `assets/pixel/ui/combat_expansion_v1/cards/grave_crossfire_card.webp` |
| `iron_wall` | `assets/pixel/battle/arenas/combat_expansion_v1/iron_wall.webp` | `assets/pixel/ui/combat_expansion_v1/cards/iron_wall_card.webp` |
| `last_bell` | `assets/pixel/battle/arenas/combat_expansion_v1/last_bell.webp` | `assets/pixel/ui/combat_expansion_v1/cards/last_bell_card.webp` |
| `firing_square` | `assets/pixel/battle/arenas/combat_expansion_v1/firing_square.webp` | `assets/pixel/ui/combat_expansion_v1/cards/firing_square_card.webp` |
| `bone_ritual` | `assets/pixel/battle/arenas/combat_expansion_v1/bone_ritual.webp` | `assets/pixel/ui/combat_expansion_v1/cards/bone_ritual_card.webp` |

Production sizing:
- battle: 1280×720 WebP;
- card: 448×274 WebP.

These exports were cropped from the six user-approved composite concepts generated for Combat Expansion v1. The former semantic card aliases are retired. Bone Raider and Crypt Sentinel still intentionally reuse existing production unit silhouettes pending mechanical validation.

### Combat Expansion v1 archived composite masters

The approved generated composites used to derive the live arena/card exports are preserved for recropping:

- `assets/source_archive/combat_expansion_v1/bone_swarm_composite_master.webp`
- `assets/source_archive/combat_expansion_v1/grave_crossfire_composite_master.webp`
- `assets/source_archive/combat_expansion_v1/iron_wall_composite_master.webp`
- `assets/source_archive/combat_expansion_v1/last_bell_composite_master.webp`
- `assets/source_archive/combat_expansion_v1/firing_square_composite_master.webp`
- `assets/source_archive/combat_expansion_v1/bone_ritual_composite_master.webp`

These 1055×1491 source composites contain the approved arena concept in the upper portion and the approved card illustration in the lower portion. Use these masters rather than regenerating the concepts if a crop or export needs adjustment.
