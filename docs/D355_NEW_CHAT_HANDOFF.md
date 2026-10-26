# D355 — Death Wager artwork handoff

Final user-selected D355 standalone option #3 `стражи_проклятой_крипты.png`: five undead before sealed ossuary doors — an armored skeletal captain with heavy axe, two hooded skeletal archers on raised flanks, and two weaker skeletal fighters at front. Original 1604×981 PNG SHA256 `0e0283c8c94c6f9e708110b3968c7c8d341de3463d14b8122977488bc69a8472`. Exact resized 448×274 WebP quality 86 at `assets/pixel/card_unification_v1/run/death_wager_d355_approved_option3.webp`, SHA256 `4ee5865a55d8dc0ebc35eb49b6572901dbeec24cf1878efbcf199a4add85ba7b`. No crowns, bells, wizards or UI inside painting.

`CardUnificationV1.RUN_CARDS["death_wager"]` selects this approved art; prior Bone Patrol path in `.tres` stays as fallback. D315 native-file approved gallery list is extended to **24** entries and checks strict SHA256, WebP decoding, dimensions 448×274 and catalog pixel equality. No changes to the five-enemy encounter, elite rewards (gold/relic/extra upgrade), balance, DS3, or already approved art.

Native Godot 4.7.2 PR CI **PASS**: [workflow 40325370134](https://github.com/zampolit73/Misdeal/actions/runs/40325370134) includes GUT/D289/D315/D316 and successful Godot screenshot capture and evidence upload. [PR #22](https://github.com/zampolit73/Misdeal/pull/22) merged as `0304f634c434c3ae6c6836b0a17c8344f990a52e`. Local review after merge: `git pull`, F6 `scenes/dev/d315_card_ds3_gallery.tscn`, inspect «СТАВКА НА СМЕРТЬ». Full A1P3 F5 12+XIII manual run still pending. Next D356: new art options-first.

Main before implementation: `065944c95a1086c51a2fdbcd8876f04b378c0409`; branch `art/d355-death-wager-approved-option3`. Merge only with successful native Godot CI. Next D356 options-first. Do not change game design without discussing it.
