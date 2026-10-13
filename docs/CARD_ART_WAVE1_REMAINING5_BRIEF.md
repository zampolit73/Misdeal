## DELIVERY UPDATE — 2026-10-13 — Approved last five art files shipped (D135)

User approved all five individually rendered final illustrations and requested direct GitHub upload. **Done:** five real binary files in GitHub `main` (commit `ac860ad2cacf17e7ab4e64c54f2ddfb70debd146`) at `assets/pixel/card_unification_v1/run/{gravedigger_shop,bone_swarm,grave_crossfire}.webp` 448×274 and `assets/pixel/card_unification_v1/event/{candle_seller,last_camp}.webp` 1280×720. All five GitHub blob hashes and valid WebP headers verified. Runtime mapping `scripts/ui/card_unification_v1.gd` updated to load three RUN_CARDS and two EVENTS, and existing `CardArtCatalog`/`ActChoice` paths load them without rewriting gameplay/approved UI. New gallery `scenes/dev/card_unification_final5_preview.tscn` for F6. Binding art decision D135 lists generation IDs and exact names. `18/18` initial Wave 1 candidate art images are **shipped in repo** but **new five NOT YET user tested in Godot**; review still pending. Gravedigger Shop live screen preserved.

Historical "unapproved/not generated" text below predates D135 and is now superseded.

---

# Misdeal — Five unapproved remaining Wave 1 illustration targets

Date: 2026-10-13  
State: **brief prepared only, NOT user-approved and NOT generated/committed as new game images**.

## Context

D130/D131/D132/D134 signed-off artwork comprises **13/13 pictured compositions** and is already present as binary WebPs in GitHub main. Following a user request to keep progressing, the next possible art set consists of **five other entries** from the original 18-item source inventory, which were never shown or individually approved. Do not conflate the user's acceptance of the first 13 with acceptance of these five. A new image-generation attempt on 2026-10-13 erroneously replayed **the previous five upgrade/reward illustrations**; that repeat output was discarded, not a new asset, and not committed.

**Art direction:** approved DS2, D130–D134 painted dark fantasy, detailed restrained storytelling, one readable main silhouette, faded moonlit steel blues vs warm ember orange and ritual reds, natural medieval materials, no duplicated actors, unmotivated details, photoreal artifacts, embedded card frames, writing or firearms. Produce five **distinct standalone** horizontal images (not a collage). Preserve all signed-off D123–D134 card interfaces and images, gameplay and RunState.

## Three table/deal-card thumbnails

**A. `gravedigger_shop`:** An elderly sinister gravekeeper / gravedigger in a hooded weathered cloak stands alone behind a makeshift wooden merchant counter in a crypt, with a **few clearly different** symbolic class offerings (aged knight token, quiver, forbidden bound page). One lantern/candle and warm bronze light, sickly teal moonlight receding through an arch, burial tools. Empty nearby shelves; no second identical dealer, no text, avoid giant skull collage or multiple duplicative objects. **This is ONLY the run/deal-card illustration**, never the user's approved DS2 live Shop event scene/table backdrop. Runtime key `gravedigger_shop`, desired `assets/pixel/card_unification_v1/run/gravedigger_shop.webp`, 448×274.

**B. `bone_swarm`:** Combat encounter: a SINGLE dominant knot of animated skeletal limbs and two recognizably **different** minor bone creatures emerging from grave-soil under a crescent moon. Energetic, readable diagonal motion; bone-and-ash shadows, not dozens of repeated skeleton clones; no gunpowder weapons, no gibberish bones or anatomy. Runtime key `bone_swarm`, proposed `assets/pixel/card_unification_v1/run/bone_swarm.webp`, 448×274. Current fallback art `assets/pixel/ui/combat_expansion_v1/cards/bone_swarm_card.webp`.

**C. `grave_crossfire`:** Combat encounter: EXACTLY two distinct medieval **bow-armed** enemies firing from separate elevations on opposite sides of a graveyard toward a central danger zone. A weathered gravestone and broken wall establish crossfire lines; no guns/muskets, no mirror-image duplicate soldiers or arrows floating without a shooter. Cool midnight blue with a single warm torch glow, clear opposite directions. Runtime key `grave_crossfire`, proposed `assets/pixel/card_unification_v1/run/grave_crossfire.webp`, 448×274. Current fallback `assets/pixel/ui/combat_expansion_v1/cards/grave_crossfire_card.webp`.

## Two separate large event illustrations

**D. `candle_seller`:** A single unsettling old traveling merchant on the left offers three obviously different candles (small amber wax, tall black wax, bone-white dripping wax) from a portable wooden cart in a ruined medieval alley. Their glows selectively illuminate the seller's face, weathered parchment and wet stone. Architectural depth and empty right area for the existing DS2 panel overlay. No clone vendors, no excessive repeated candles, no text. **Full-screen background of real ActChoice event**, NOT automatically replacement of the current table art or another existing approved scene. Desired `assets/pixel/card_unification_v1/event/candle_seller.webp`, 1280×720, fallback `assets/pixel/event/v8/candle_seller.webp`.

**E. `last_camp`:** Empty/sparsely populated final encampment at the edge of a misty ruined castle cemetery: one small embering campfire, one traveler's rolled bedroll, a patched tent corner, a steel sword leaned against a lone moss-covered gravestone; cold blue night, low orange light suggesting fragile shelter before danger. Don't imply a duplicate army, keep landscape atmospheric and legible behind the DS2 choice UI. Desired `assets/pixel/card_unification_v1/event/last_camp.webp`, 1280×720, fallback `assets/pixel/event/v9/last_camp.webp`.

## Workflow and QA

1. **Generate genuinely new compositions only.** Previous image generator output incorrectly showed Knight, Ranger, Mage, Gold chest and Skeletal ruby hand once more. Those are *not* the next five; discard them. Prefer explicit fresh user prompt for one or all five naming every subject rather than ambiguous "continue".
2. Show visually distinct five images to user, ask approve/change. Do **NOT** commit non-approved art.
3. Export run thumbnails from each high-res standalone master to 448×274 and event backgrounds to 1280×720 without stretching low-res sources. Preserve original art fallback and DS2 presentation.
4. After approval, add corresponding id-keyed optional mappings in `scripts/ui/card_unification_v1.gd` (RUN_CARDS for three / EVENTS for two) and commit actual binary WebP source assets via connected GitHub. Be aware `candle_seller` and `last_camp` are already active IDs in `scripts/event/act_choice.gd`; `get_event_art_path` only selects mapped new art if present and valid.
5. Test both 448×274 card appearance and 1280×720 events at live UI size; preserve `gravedigger_shop` approved standalone shop UI and its real transactions. Any old untracked ZIP art can conflict with `git pull`; no separate ZIP needed after binary commit.
6. Update `docs/VISUAL_ASSET_REGISTRY.md`, `docs/PROJECT_STATE.md`, `docs/SESSION_CHECKPOINT.md`, `docs/HANDOFF.md`, `docs/ROADMAP.md` and `CHANGELOG.md` after implementation/approval. Never claim 18/18 delivered until actually verified.

