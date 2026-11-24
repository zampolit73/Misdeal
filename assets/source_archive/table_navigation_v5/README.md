# Misdeal — Table Interface V5 / Diegetic Navigation

Approved concept: `source/approved_reference.png` (user approved this exact version, with the two books separated from both card piles). `source/production_screenshot_reference.png` is the user's earlier annotated production screenshot. It is evidence, not a runtime texture.

## Runtime artwork

All three objects are transparent cutouts from the approved concept. The plaque lettering has been removed locally; draw all labels as live Godot text. No replacement tabletop painting is provided or intended.

- `runtime/squad_journal.png`: burgundy expedition journal, with blank plaque.
- `runtime/archive_grimoire.png`: black/red sealed Wizard's grimoire, with blank plaque.
- `runtime/memory_window.png`: dark ornamental arch and stained glass, with blank plaque.
- `runtime/memory_glass_light.png`: glass-only brightness layer; alpha follows the count of unlocked memories / 24. It is ornamental and does not reveal specific canonical memory fragments.
- `runtime/memory_window_full.png`: reference maximum illumination, same geometry.
- `runtime/*_focus.png`: transparent contours for hover and keyboard focus. No rectangular controls over props.
- `runtime/layout_1280x720.json`: initial design-pixel positions and local label rectangles. Use the supplied placement, then make small local adjustments only if needed to preserve the actual authored piles, central cards, hands, or backdrop composition.
- `overlay_preview.png`: transparent layout check (example count 8/24), not a native Godot capture.
- `asset_preview.png`: extracted assets inspection sheet.

## Integration contract

1. Copy runtime images to `res://assets/pixel/ui/table_navigation_v5/`; archive source and provenance in the project's existing source archive convention. Retain existing approved Table and card assets. Do not use the concept screenshot as the gameplay background. Preserve logo, wizard, banners outside the local stained-glass area, card geometry, deck/discard labels, deal/discard animation origins and existing Fate Spread. The new window occupies a local upper-right wall area only; fit it into the architecture without redesigning the entire scene. Ensure book silhouettes do not cover either pile even when hovered.
2. Hide or re-skin the old `SquadButton` and `MemoryTable.button` without leaving active invisible old hit targets. Prefer a shared lightweight navigation component with three real Buttons, `mouse_filter=IGNORE` on decorative layers and live captions. Clicking the object or its plaque opens its destination. Bound input areas to the objects. Preserve Tab and M; add A if unused (otherwise choose a conflict-free shortcut and update label consistently). No fixed progress number. Make text clear in 1280x720 and focus visible. The `memory_table.gd` existing `pending` notice and canonical memory profile/viewer are retained; the new ornament follows progress without revealing locked fragments.
3. Keep existing squad status and memory viewer. Archive must open as a modal over the existing Table instance, not a scene-router change that returns to main. Instantiate existing `scenes/archive/wizard_archive.tscn`, support explicit caller-aware close mode, and change the label to `К столу [Esc]` when opened from Table. From main menu preserve normal route and `В меню [Esc]`. Do not duplicate the archive or its four approved tab components.
4. Enforce single modal ownership. Block opening navigation while selection/deal/meddling/wager/camp-stop/scene transition/pause or other modal is active. Block underlying mouse and keyboard actions while Archive is open (including the global RunMenu Esc handler, MemoryTable `_unhandled_key_input`, and Table `_input`). Esc closes top modal once, restores focus and input state, never opens pause or exits to main simultaneously. Freeze card/hold actions and prevent deferred milestone or wager overlays from opening over Archive. Preserve existing autosave semantics; browsing does not alter run or profile data, reroll, consume offers, reset memory or replace Table. Test return to the same exact offers, hold state, gold and counters. Do not globally pause in a way that breaks archive navigation or the existing pause menu.
5. Native review: compare 1280x720 screenshots with the source concept and production Table, check deck/discard unobstructed, correct perspective/contact, keyboard and mouse navigation, modal exclusivity, 0/24 and nonzero memory counter, all four Archive tabs, close from Table and main menu, and a quick card deal after return. Use isolated QA data. No large test matrix. If cutout edges or book contact with tabletop need adjustment, correct local positioning or local contact shadows only; no full background regeneration. Native Godot has not been executed as part of this art package.

## Provenance

Source: the user-approved ChatGPT-generated reference. Book and arch silhouettes extracted with hand-traced masks, plaque lettering removed by localized inpainting, optional focus contours and glass-only light derived from the source. `provenance.json` gives SHA-256 for supplied files. Proposed placements require in-engine visual verification.
