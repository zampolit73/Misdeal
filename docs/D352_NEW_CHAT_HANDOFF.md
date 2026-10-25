## D352 — VERIFIED released to main; native Godot 4.7.2 CI PASS (2026-10-26)

[PR #19](https://github.com/zampolit73/Misdeal/pull/19) squash-merged to `main` at `a5290fae6dd33f37b715b74aeeb13eadfaf7e4b9` after [real GitHub Actions run 40237209321](https://github.com/zampolit73/Misdeal/actions/runs/40237209321) **PASS** on PR head `6796e8e`: 48/48 authentic GUT tests, D289 Table, D315 21-image Gallery exact SHA/decode/size/pixel check, D316 Card Surfaces, and two genuine 1280×720 Godot screenshots (Table and Gallery). Installed final user-approved `wizard_tithe` hooded altar artwork without any crown, not the prior crowned concept, as 448×274 WebP SHA256 `3a7e29e7c519f2b3411afa552b725f51731cd08909f83912172c718c6affa746`. No gameplay/DS3/previous art changes. User: `git pull`, F6 `scenes/dev/d315_card_ds3_gallery.tscn`, inspect «ДЕСЯТИНА ВОЛШЕБНИКА» (local visual review not substituted by CI). A1P3 full normal F5 12+XIII human playtest remains pending. Next artistic task D353: 2–3 different actual scene images BEFORE any artwork replacement.

# D352 — Wizard Tithe final approved art — release gate (2026-10-26)

## D352 — Wizard Tithe approved crownless ritual integrated; native CI pending (2026-10-26)

User chose #2 «Алтарь десятины», then explicitly requested removal of the wizard's crown and approved the final single image «мрачный_ритуал_под_готическими_сводами.png» with «отлично, внедряй». Only the final **uncrowned wizard in a burgundy hood** is authorized, NOT the previous crowned render or skeletal tollkeeper. Original PNG 1536×1024 SHA256 `6f35ec7ccf215085d75aec08e5481e8a1ba7fe88df8ae3a2878797460c7adca6`. His hands are raised behind the blood-filled ritual chalice; gold coins and a sealed scroll sit on the stone table amid gothic arches and red banners. Exported WebP full-width crop (0,42)–(1536,981), 448×274 Q86 SHA256 `3a7e29e7c519f2b3411afa552b725f51731cd08909f83912172c718c6affa746`; Git path `assets/pixel/card_unification_v1/run/wizard_tithe_d352_approved_hooded_ritual.webp`. `CardUnificationV1.RUN_CARDS["wizard_tithe"]` overrides former Gallows Volley fallback, D315 checks exact SHA256, WebP decode, 448×274 dimensions and CardArtCatalog pixel equality for the **21st** user-approved scene. No gameplay, card Resource, DS3, previous locked art or wizard dialogue changes. This implementation requires separate native PR Godot 4.7.x CI and user F6 visual validation. A1P3 full human F5 12+XIII run remains pending. [Handoff](D352_NEW_CHAT_HANDOFF.md).


## Exact production changes

- `assets/pixel/card_unification_v1/run/wizard_tithe_d352_approved_hooded_ritual.webp` direct Git blob for exact approved WebP (448×274 SHA256 `3a7e29e7c519f2b3411afa552b725f51731cd08909f83912172c718c6affa746`).
- `scripts/ui/card_unification_v1.gd`: new `RUN_CARDS["wizard_tithe"]` maps to this binary, old `resources/cards/wizard_tithe.tres` remains unchanged as emergency fallback.
- `scripts/dev/d315_card_ds3_smoke.gd`: 21st accepted art, strict SHA/decoding/dimensions/pixel equality.
- Document updates in PROJECT_STATE, ROADMAP, DECISIONS, HANDOFF, VISUAL_ASSET_REGISTRY, CHANGELOG.

## Next actions

1. Check GitHub PR native Godot 4.7.x CI with 48/48 GUT + D289/D315/D316 smoke + screenshots. Don't infer success before inspection.
2. Merge green PR to main and record CI URL / merge SHA in PROJECT_STATE, ROADMAP, HANDOFF and CHANGELOG.
3. User `git pull`; F6 `scenes/dev/d315_card_ds3_gallery.tscn`; check «ДЕСЯТИНА ВОЛШЕБНИКА» and compare to hooded, crownless source.
4. A1P3 complete human F5 first-act 12+XIII is separate and still pending. D353 next unapproved-art 2–3 variants before any new visual modifications.
