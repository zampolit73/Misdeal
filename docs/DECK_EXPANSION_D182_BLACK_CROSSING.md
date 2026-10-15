# D182 — Чёрная переправа / Black Crossing (card #37 candidate)

Date: 2026-10-15  
Status: **concept selected and image option 3 user-approved; NOT live, no battle implementation, native QA pending.**

## What the user selected

- Of three **gameplay** proposals for card #37, user selected **option 1: «Чёрная переправа»**.
- Of the three *rendered card-art* concepts, user selected **option 3**, a deliberately **diagonal old pier** scene: an imposing dark ferryman with iron hook/bagor on the **right**, two drowned skeletal victims emerging from dark water in the **left/front**, moonlit broken quay, one distant ruin silhouette and a restrained orange lantern. User replied «ок» after selection.
- **IMPORTANT file mismatch in prior chat:** The next assistant message accidentally cited `мрачный_перевозчик_в_туманном_болоте.png`, the first composition, despite the explicit request for **third**. The actual third image from the image-generation result is `лунная_переправа_мертвецов.png` (1604×981, conversation file ID `file_00000000ffb081f5a8c40af34fc03493`). **Do not substitute the first composition just because the assistant gave its filename.** If further doubt arises, show the 3rd composition visually rather than inferring from filenames.
- Art must retain D167 scene-first dark-fantasy illustration, no baked card/UI labels, no repetitive castles/micro-detail, target 448×274. Separate 1280×720 playable arena later, showing usable central ground and telegraphed tidal danger.

## Newly proposed authored encounter (not implemented yet)

- ID `black_crossing`; Tier1 combat. Working player-facing card title `ЧЁРНАЯ ПЕРЕПРАВА`.
- Three **genuinely original** enemies (D143): one `drowned_ferryman` (huge decayed ferryman with a long hooked **boat pole**, hanging rags, no bell/crown), two `drowned_hand` (water-logged drowned undead in torn clothes, asymmetric emerging/wet movement; distinct from bone marionettes, homunculi and legacy skeletons).
- **Water surge mechanic**, localized to the `black_crossing` encounter: periodically mark **one specific predictable cross-lane strip** on the pier; give a readable wind-up; on surge push/slow units caught in it, rather than permanent damage/poison areas. Should be visual, tactical and readable at small scale. Keep player agency through placement/orders, avoid unavoidable chain stuns for solo and overload of effects. Exact timing/parameters require isolated QA.
- Deployments: two authored enemy formations with same roster; own arena `black_crossing`. No alternative/reused enemies and no dynamic substitutions.
- **Do not** activate new card or new enemies in production RunState or generic Battle until original `.tres`, approved 25-frame atlases (where needed), original arena, QA matrix and real battle→reward→table are validated. Existing Act1 stays **36/45**, and D153 remains untouched.

## Image export and GitHub transfer state (be explicit)

The selected original file `/mnt/data/лунная_переправа_мертвецов.png` exists in the current conversation Python environment. A **448×274 RGB WebP** preview was generated locally as `/mnt/data/d182_black_ferry_approved_v1.webp` with decoded-WebP SHA-256 `dfb77dd9c153ee2f9254a3b4469a2a7b8b132d44ae7169cbf75db643e889472b` (quality 76, Lanczos). Its Base64 export is `/mnt/data/d182_black_ferry_approved_v1.webp.b64`. These local paths are **not** a guarantee they persist to a new container or that GitHub contains the image. The image still needs a reliable transfer to `assets/pixel/card_unification_v1/run/black_crossing_approved_v1.webp.b64` via connected Github before wiring the runtime art catalog; do not falsely claim deployment. Do not ask user to manually copy images while access is available; solve the transfer as part of next implementation.

## Next authorized integration

1. Safely send the **exact option-3** WebP to GitHub, verify 448×274/base64 and image subject, add isolated preview scene and card catalog branch; preserve other cards.
2. Show user preview in native Godot (`git pull`, F6), then produce original monster silhouettes/atlases and the **separate** arena, taking art approval gates seriously.
3. Integrate scoped surge mechanic in battle, test solo/duo/trio 54-case and real reward→table. Only then release as #37 and increase live pool 36→37/45.

The existing D182 candidate card `resources/cards/black_crossing.tres` is **not registered** in `RunState.CARD_PATHS` or `ACT1_CARD_IDS`, and its target path is a future string path, not yet a real encounter.
