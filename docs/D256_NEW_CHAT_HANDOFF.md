# D256 — CURRENT Misdeal new-chat handoff: finish Black Lantern Road (#38) character art

**Checkpoint date:** 2026-10-19. **Repository / branch:** [zampolit73/Misdeal](https://github.com/zampolit73/Misdeal), \`main\`. This note consolidates the *state following committed D255*, not a new sprite-release approval. D255 art/material commit: [7f16688](https://github.com/zampolit73/Misdeal/commit/7f16688c84f18d97c2f82e0127e97ddd37c93250). The assistant has connected GitHub access and should make code/assets/docs commits itself.

## What Misdeal is, and binding working rules

Dark-fantasy **card-driven roguelike** with an evil wizard dealing encounters on a cursed table; compact tactical **autobattler** where party selection/preparation/tactics matter. Godot **4.7.x**, **GDScript**, data-driven .gd/.tscn/.tres. DS2/Fate Spread Variant C UI and the existing style are accepted. Do not change fundamental game design, the 12 Fate resolutions + sealed XIII, the solo/duo/trio progression, or freeze-point **КАРАМБА73** without discussion. Source of truth for implemented code is \`main\`; user videos/screenshots and project dialogue govern visual approvals.

Read \`AGENTS.md\`, \`docs/CONCEPT.md\`, \`docs/PROJECT_STATE.md\`, \`docs/ROADMAP.md\`, \`docs/DECISIONS.md\`, and this handoff. Other useful sources: \`docs/DESIGN_SYSTEM.md\`, \`docs/VISUAL_ASSET_REGISTRY.md\`, \`docs/D255_THREE_RICH_CHARACTER_ATLASES.md\`.

**Animation workflow lock (D238):** 25 ORIGINAL distinct poses per role: **idle4 / walk6 / attack6 / hit3 / death6**, 96×96 cels arranged 6×5 (576×480), five unused cells truly alpha-clear, minimum two transparent margin pixels; both facings are flipped where appropriate. Work the **whole 25-frame pack per character at once**; perform internal visual and technical QA; give the user **one full-pack** test rather than approval prompts for each animation. No generic/duplicated skeleton frames, rigid whole-body rotation, cropped props, or technical placebo art. New *card illustrations* use the separate D168 2–3 options-first rule; this does not mean asking 25 approvals for an established animated enemy design.

## Current release / technical state

- **Act 1 LIVE: 37/45 cards. Card #38 \`black_lantern_road\` ("Дорога чёрных фонарей") NOT in \`RunState.ACT1_CARD_IDS\`.** Do not release or raise to 38/45 from sprite-structure tests alone. Its \`RunState.CARD_PATHS\` entry exists only so isolated QA can look up the card.
- Five UNIQUE Black Lantern skeleton roles already designed. Accepted/staged rich original 25-pose sprites **\`road_sentinel\` (D244)** and **\`lantern_bearer\` (D224)** are the **ONLY** Black Lantern entries in \`scripts/battle/unit_animation_library.gd\`. Their 1v1 real \`BattleUnit\` previews were user-reported OK. Keep them untouched.
- Isolated D249 real AI **3 heroes vs all 5 enemies** on approved D209 forest, with both enemy layouts and D206 lanternlight, passed actual user-native footage **for both formations** at D252; both wins ~9.7s with all three heroes standing. This is an isolated technical/visual smoke, **not final encounter balance**. Large old gray D218 Guide and overlapping hero name/HP labels remained ugly.
- D253 reused existing \`BlackLanternLightController\` in **real Battle** only when encounter ID is \`black_lantern_road\` and all five original enemy visual roles exist; scoped moving light pools grant +16% illuminated enemy attack cadence and stop/restore after fight. **Native normal-route test not yet confirmed.**
- D254 QA-only \`res://scenes/dev/black_lantern_d254_real_battle_route_qa.tscn\` selects 1/2/3 heroes and either layout, launches the genuine \`Battle→Reward→Table\` route with instance-only temporary art for unfinished enemies. **Code committed; full native route and 54-case balanced matrix NOT confirmed.**

## D255: accepted visual *direction* for the last 3 roles — all original assets already in Git

On 2026-10-19 the user asked to **finish all remaining art now**, then reacted **«отлично»** to three generated **transparent** illustration sheets. Interpret as acceptance of the visual **direction**, NOT a claim the 75 frames run flawlessly in Godot.

| Role and locked silhouette | Lossless approved source sheet | QA 25-pose atlas |
|---|---|---|
| \`extinguished_guide\` — tall skeletal leader, burgundy cloak, **rigid iron shoulder yoke + exactly 3 independently chained amber lanterns** (NOT shield-bearer) | \`assets/pixel/units/black_lantern_road_qa/extinguished_guide_d255_approved_original.webp.b64\` | \`.../extinguished_guide_d255_rich25_qa.webp.b64\` |
| \`oil_acolyte\` — skeletal oil carrier with a large fuel tank on back, chained burner, brown cloak (NOT Guide silhouette) | \`assets/pixel/units/black_lantern_road_qa/oil_acolyte_d255_approved_original.webp.b64\` | \`.../oil_acolyte_d255_rich25_qa.webp.b64\` |
| \`lantern_archer\` — skeleton archer, quiver, wrapped bow/banner, hip-mounted amber lantern and credible release pose | \`assets/pixel/units/black_lantern_road_qa/lantern_archer_d255_approved_original.webp.b64\` | \`.../lantern_archer_d255_rich25_qa.webp.b64\` |

The literal prefix \`.../\` in the third column means \`assets/pixel/units/black_lantern_road_qa/\`, not a real shortened filesystem path. All 6 full GitHub blobs have been checked in the D255 commit (source sheets are >1 MB each; GitHub Contents API may return empty \`content\` for these large blobs, so check the git tree/blob **size** rather than claiming they are missing).

- Generator: \`tools/art/author_black_lantern_d255.py\`, input 1374×1145 6×5 transparent art sheets, fixed-role pixel transform without whole-character per-pose size changes, output lossless WebP/Base64 576×480.
- Machine QA: \`docs/qa/D255_THREE_RICH25_QC.json\`. Structural export **PASS**: 25 distinct sprites per enemy (**75 total**), 5 blank cels each (**15** total), 2px outer margins, RGBA decoding and lossless round-trip.
- Unified art-only F6: **\`res://scenes/dev/black_lantern_d255_three_character_art_preview.tscn\`**. Shows all three at enlarged ×2.1 and native ×1, 5 states and both directions. It is *staged* but **not yet verified as a user-native motion PASS**.
- Crucial **ART HOLD**: source panel boundaries cut dangling lanterns, chain flames/cloth/bow portions. The heuristic reports **12 Guide / 13 Acolyte / 9 Archer = 34 source-edge warning frames** (warnings, not necessarily 34 separate visible failures). At least some attack and prop tips visibly crop. Uniform padding around the *cropped* sheet cannot restore missing detail. It is **not safe to register D255 atlases globally or release #38** yet.
- Full rationale and corrections: \`docs/D255_THREE_RICH_CHARACTER_ATLASES.md\`. Earlier D251 Guide candidate was also *internally art-rejected* (background matte, distorted chains, changing scale) and must not be silently restored as final art.

## EXACT next task (start here in new chat)

1. **Inspect all three D255 approved originals and the extraction code/QC**, particularly the 34 source-column-edge warning locations. Repair *whole original posed figures / overlapping props* by locally reconstructing chain/lantern/fire/bow/cape missing across adjacent cells, or truly repainting affected cels; **do not** fake passes by shrinking the whole pose, duplicating frames, blanking edge pixels, or turning Guide into another Bearer.
2. Run internal comparison of all **75 frames** in walking, attack, hit and death at real **×1**, and verify 2px margins, zero lost hand-held props, consistent body size and contact, proper facing and transparent cells. If art still has severe defects, keep as QA-only and continue internal repair.
3. **ONE combined D255 successor Godot F6 review for all three full 25-frame characters**, not 75 mini-approvals. Once the complete art actually passes visually, register all three original roles in the canonical animation library, preserving Sentinel/Bearer, and test real five-character 3v5.
4. Then native test D254 real **Battle→Reward→Table** with solo/duo/trio and both formations, fix any route/engine errors, run **54-case balance matrix**, revisit the observed easy three-hero wins and crowded name/health HUD. Only after all art/native/release gates may \`black_lantern_road\` be added to the 37-card pool (38/45).
5. After substantial implementation update \`docs/PROJECT_STATE.md\`, \`docs/HANDOFF.md\`, \`docs/ROADMAP.md\`, \`docs/DECISIONS.md\` when necessary and \`CHANGELOG.md\`, then meaningful GitHub commits. Communicate in Russian; code and node/file identifiers in English; normally the only user action is \`git pull\` + one specific Godot F6 scene test.

## History / links worth preserving

- Full recent development progression: D243 technical Sentinel rejected → D244 rich art → D245 video → D246 Sentinel actual battle accepted-to-proceed → D247/D248 Bearer accepted-to-proceed → D249 original full-five 3v5 scene → D250/D252 Godot videos (both formations) → D251 rich but cut-out rejected Guide → D253 genuine Battle light hook → D254 real route QA launcher → **D255 3×25 rich visual candidates + art cropping hold**.
- Major status/history: \`docs/PROJECT_STATE.md\` and \`docs/HANDOFF.md\`; older pre-cleanup history in \`docs/archive/2026-10-15-pre-cleanup/\`. Frozen checkpoint: \`docs/checkpoints/KARAMBA73_2026-10-16.md\`. Core concept: \`docs/CONCEPT.md\`.
- Seven specialized DARK FORGE roles were provided as project ZIP materials (Producer, Game Designer, Game Developer, Game Artist, Technical Artist & Animator, UI/UX Designer, QA Engineer). Use their relevant instructions if accessible; do not pretend they are installed as separate system Skills just because archives exist.

**Single-sentence restart brief:** “Continue Misdeal from D255 in GitHub main: fix the 34 flagged source-edge prop cuts across the three user-style-approved 25-frame Black Lantern originals in one internal batch, then one combined native F6; do not change the 37-card live pool or frozen KARAMBA73.”
