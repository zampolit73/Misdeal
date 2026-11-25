# MISDEAL — Run End Visual V2 / Wizard's Verdict

Approved concept adaptation, 1280 × 720. This is an art and layout package, not a Godot implementation. The original landscape victory concept is the shared layout reference; the approved two-panel concept supplies the defeat mood. A new text-free defeat illustration was produced as a standalone screen. Both result states now use the same layout, with matching muted bronze, bone, aged parchment and burgundy. The left-side victory painting is extracted from the approved landscape concept. No original game assets or code were changed by this package.

## Files and integration

- `runtime/victory_plate.webp`, `runtime/defeat_plate.webp`: clean 1280×720 plates; no baked title, counts, portraits, relics or button caption. The XIII marking on the fallen Warden is part of the painting, not a statistic.
- `runtime/*.png`: independent decorative components (including the normal action plate), derived from the concept and existing archive materials. The full plates already include these frames; do NOT stack duplicate frames. Use only the button state texture overlay as needed.
- `runtime/states/`: hover / pressed action art. These textures replace the normal action at its layout rectangle.
- `layout_1280x720.json`: integer logical coordinates in [x,y,width,height] format. Fit the 1280×720 logical canvas with the project's usual aspect-preserving scaling. Real labels and hit targets must remain interactive controls.
- `*_layout_preview.webp`: illustrative layout checks ONLY, not runtime assets or Godot captures. Figures, portraits, relic illustrations and outcomes shown there are examples; do not import them as gameplay data or character art.
- `source/`: approved references and generated text-free defeat master. Keep originals separate from runtime imports.

## Data contract (current main)

Read `scripts/run_end/run_end.gd`, `scenes/run_end/run_end.tscn`, `RunState` and the existing save flow. Preserve its existing win/loss routing, checkpoint write and New Run action. Determine the end state from the existing terminal predicates, never from the displayed illustration.

- Stats: `cards_resolved / ACT_CARD_TARGET`, `deals_survived`, `gold` (remaining, not lifetime earnings).
- Quote: preserve the current victory line and the actual `run_end_reason` / existing defeat fallback.
- Heroes: use approved production portrait resources, role labels and the actual protagonist/companion state. Companion fates use `get_companion_fate(role)` and `FATE_JOINED`, `FATE_LOST`, otherwise not encountered. Do not equate run defeat with all heroes dead, or surviving membership with an unverified HP status. Show the protagonist explicitly. No invented character levels.
- Relics: `artifact_ids`, `ArtifactArtCatalog`, actual titles/effects from the resources. Thirteen slots are visual capacity; empty slots are not unknown relics. No unlock-state mutations. For a zero-relic run show an honest empty state.
- Development: retain `get_hero_upgrade_titles_text()`, `party_hp_bonus`, `party_damage_bonus`, Jack and the hunting-token event outcome (when applicable). The upgrade region may be a short scrollable region, with accessible tooltip/full text; adapt locally for long labels without shrinking to illegibility.
- Last Deal: use `last_deal_used`, `last_deal_payment_text` and existing fallback. Wrap long payment/reason copy. Do not introduce a second attempt action at terminal RunEnd.
- New Run: preserve the existing button handler and reset / class-select routing. No extra continue-act button, fake currency earned, fictitious kills, total events, times or levels. No changes to saves, unlocks, difficulty, rewards or the active run.

## Acceptance

Native Godot 4.7.x at 1280×720: victory, defeat, zero and full relic collections, different party fates, long outcome/Last Deal/upgrade strings, the Jack/token path where applicable, and the real New Run transition. Use isolated profiles. One small focused QA pass and native screenshots are enough; no mass testing. Preserve the accepted table, events and archive.

## Provenance

User-approved concept images generated in the current Misdeal design discussion. Defeat clean master generated as an adaptation. Runtime plates and components are deterministic crops, clean-texture replacements and compositing of those sources and previously approved Chronicle material. The preview images are illustrative mockups only. No third-party fonts are bundled.
