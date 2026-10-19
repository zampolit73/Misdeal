# D278 — Painted standalone bronze frame on live tabletop offers

Status: runtime committed `6fcdf1003cba90ed5c605e7c92e0b0897e62c760`; Official Godot 4.7.2 native source WebP hash/alpha-center/two-live-card verification PASS: https://github.com/zampolit73/Misdeal/actions/runs/39296402449. Actual 1280×720 visual user acceptance remains open.

## Artistic source

Newly rendered DS2-aligned dark-fantasy card concept supplied a gold-bronze physical border. Cropped and alpha-isolated just the metallic outer rim, with fully transparent center for the independent live art, Cyrillic text and red Choose surface. This is a NEW art resource, not a full-screen screenshot and not a collection of invented vector UI lines. Final WebP 272×338, size 5088 bytes, SHA256 `94c1991dd4ea421b566bf5e6782fba9c04387cb6b4da97b31f0091754128f6b9`.

## Runtime integration

- `assets/pixel/table/offer_frame_d278_{1..4}.webp.b64` — four 1696-character UTF-8 transport chunks representing ONE WebP alpha asset. Four part blob SHAs: `724ab6c98bdba3821dfa38b2f0ea4033a92489e6`, `c11c870ffc7c6f6f9301b6c6e1e96967ebbdae54`, `8753109701b3e4b37ba502c7f0e350dc7b82f912`, `a9f2fd303ec3d09ecb4e0a88f4da43757862aa3f`.
- `scripts/table/table_offer_frame_asset.gd` reconstructs exact 5088-byte WebP, decodes `Image` at 272×338, validates the central hole and caches `ImageTexture`.
- `scripts/table/table_offer_skin.gd` attaches a `TextureRect` named `IllustratedFrame` onto both live Buttons without stealing mouse input; hides legacy D277 scripted corner ornaments to avoid stacking duplicate decorations, keeping older scripts for rollback.
- `scripts/dev/d274_table_offer_smoke.gd` and the D274-labeled Table smoke workflow now perform D278-specific tests; CI validates bytes before Godot import.

## Locked gameplay and review

Keep 272×338 two-card placements, Hold tabs above cards, actual CardArtCatalog art, separate paper/text/HUD/CTA/mark and LMB Choose / RMB lore exactly as before. No RunState or Fate Spread edits. Act1 39/45 preserved. Native CI PASS does not establish visual approval; after git pull, inspect a normal two-card deal, hover, selected/marked state, longer Cyrillic title, single boss card, RMB inspection and modal close at 1280×720.

Rollback: revert D278 integration commit `6fcdf100` to restore D277 procedure while preserving D277 art material and mechanic.
