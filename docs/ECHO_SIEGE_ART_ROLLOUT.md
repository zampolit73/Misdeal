# Echo of the Siege — approved art rollout (2026-11-10)

Five artistic options are now user-approved. **This is a planning/handoff record, not a claim that new images are in GitHub.** Exact originals are in the user's ChatGPT Library folder /Misdeal/approved_art/. A downloadable package was created in the project conversation (misdeal_echo_siege_approved_pack.zip) containing exact 5 PNG sources and 10 converted game WebPs, with a checksummed manifest.

| Event ID | Event | Source PNG in Library | SHA256 |
| --- | --- | --- | --- |
| banner_seamstress | Знамя на бинты | banner_seamstress_echo_siege_approved_2026-11-10.png | be70f5375c703fc9ad4c5a1f5cfb57eea5f499ac849526348fa842ee483e39b2 |
| unsent_letters | Запертая почта | unsent_letters_echo_siege_approved_2026-11-10.png | 3e84b66a1109af5867126e6a3d87dd480d28f6fe3641fef137ef8becfabb5e0f |
| borrowed_boots | Чужие сапоги | borrowed_boots_echo_siege_approved_2026-11-10.png | 7cf1d2d0fa0cd813bdc0017b49d920f0fbd5692b0013f6d90cc716cb0120e88b |
| false_weights | Неверные гири | false_weights_echo_siege_approved_2026-11-10.png | 6d1c166f5587a68f366f68b210e3f6cae748d8a35a77cadc2bab605d399e95d6 |
| last_signal | Погасший сигнал | last_signal_echo_siege_approved_2026-11-10.png | 2a53828e4fec3105605502fe5a4aa05610c5af46f5f8d61e35fc79cde7854026 |

## Fifth selected composition

The user chose option 1, NOT the telescope nor the handheld lantern image. Approved last_signal source: a_dramatic_cinematic_dark_fantasy_concept_art_sce.png, 1536x1024. An armored skeletal watchman stands on a cold ruined moonlit tower, holding a **dead/unlit brazier on a long pole**. The canonical aged-gold crosswheel banner is adjacent. Empty distant castle ruins and mist, muted blue-black moonlit palette. Image is locked; no unrequested redraw.

Other user-approved locks are in docs/DECISIONS.md: exactly ONE skeletal pigeon for unsent_letters, scarecrow audience rather than living soldiers for false_weights, and approved actual illustration instead of variants for borrowed_boots.

## Packaging and reproducibility

Image placement exactly mirrors the current Godot recipe in scripts/dev/pack_final_five_assets.gd: contain-fit original source into a 448x274 card and a 1280x720 backdrop; Lanczos resample, center on #100e0e; no crop. User-facing ZIP contains assets/pixel/events/final_five/sources/echo_siege_approved/<id>/approved_source.png, assets/pixel/events/final_five/<id>/card.webp and backdrop.webp plus per-file hashes. Converted WebPs were made at quality 94 with Pillow, so lossiness may vary from native Godot encoding.

CRITICAL: The original assets/pixel/events/final_five/manifest.json still selects OLD image candidates 2/3/2/3/3; the old pack_final_five_assets.gd reads that manifest. **When the new image bytes are finally committed, update the packer to use the new approved source PNGs** or add a deterministic dedicated packer. Otherwise a later pack command will overwrite these new images with the old options. Update manifest file hashes accordingly. Preserve original source candidates and files in Git history.

## Completion checklist

- Commit all 5 approved original PNGs and 10 game WebPs under the intended asset paths, not just a documentation entry.
- Keep all choices, stat/economy effects, DS3, scene scripts and save system unchanged.
- Verify SHA256 provenance, actual 448x274 and 1280x720 geometry, no text or frames painted in art.
- Run GUT / Godot 4.7.x and F6 scenes/dev/final_five_playtest.tscn; inspect all five card front frames, event backdrops and outcome/return paths on native 1280x720.
- After binary integration, update PROJECT_STATE, HANDOFF, VISUAL_ASSET_REGISTRY, CHANGELOG and GitHub CI evidence. Never mark the rollout implemented before this has happened.

