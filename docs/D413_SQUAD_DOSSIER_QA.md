## Release update — 2026-11-09

User approved D413 and requested integration. PR81 and PR82 are merged; main head after D413 is `3c364bb4bbb108a5b2a8ce6e1cba18e782b487c2`. Subsequent reference polish is documented in [D414 QA](D414_DOSSIER_REFERENCE_QA.md). Original pre-release QA below is historical.

# D413 — squad dossier visual upgrade

[PR82](https://github.com/zampolit73/Misdeal/pull/82), stacked on PR81; [Godot4.7.2 CI SUCCESS](https://github.com/zampolit73/Misdeal/actions/runs/42571523455) for code `778c7796`:211/211 GUT,47 scripts,47,106 assertions; D285 real dossier smoke, actual three-role GPU dossier captures and Battle→Reward→Table route passed. Full RELEASE matrix skipped. Main remains unmerged.

User requested a richer dossier matching their reference, portraits consistent with the approved D412 figurines, and preserved game logic. Implemented on `fix/d413-squad-dossier`, based on the D412 PR branch; main remains unchanged until review/merge. Native player aesthetic acceptance of this newly rendered dossier is pending.

## Visual result

The existing production dossier is reskinned: painted obsidian/antique-bronze nine-slice panels, serif hierarchy with Cyrillic system-font fallbacks, visible selected/focus states, aligned three-column live stats, room for equipped relic effects, real I/II/III progress markers and segmented footer. Original control paths/signals/data getters remain. All text, counts, stat deltas and progress are native Controls; no painted screenshot or baked numbers drive the screen.

Three new portraits use D412's authoritative figures: closed-helmet steel/burgundy sword-and-shield Knight, intact olive hood/leather/bow/quiver Ranger, silver-haired/bearded male Mage with intact violet robe/staff. Knight stays helmeted rather than copying the reference's unhelmeted blue warrior. Mini roster crops use the same new paintings. Class-selection art, combat sprites and animation timing are unchanged.

Native production Table/dossier captures (trio, Executioner upgrade and Dead Man's Shield fixture):

- [Knight](qa/d413/knight.png)
- [Ranger](qa/d413/ranger.png)
- [Mage](qa/d413/mage.png)

## Scope and behavior

- `scripts/ui/squad_dossier_d413.gd`: screen-local art/style overlay, never writes RunState. Existing shared DS2/DS3 helpers unchanged.
- `scripts/ui/squad_dossier_v3.gd`: portrait paths and matching mini crops; existing stat values rendered as a BBCode table using the same formatter/getter.
- `scripts/table/squad_status.gd`: use shared portrait mapping with correct tall aspect; apply overlay and selection state. TAB closes before GUI focus traversal, including focused roster buttons; close disables input during the existing close tween. Original 1/2/3, Escape, button actions, stat/development/relic calculations remain.
- Relic slots now accept hover for their existing real artifact tooltips, without adding an equip action or changing inventory capacity.
- Existing dossier helper/dynamic progression remains responsible for active, unavailable and lost companion presentation, item counts, scars, solo/duo bonuses and upgrade descriptions. Long development/relic collections still scroll.

## Native verification

- Godot4.7.2 Windows/NVIDIA OpenGL at1280x720; all three real dossier screens captured through the actual Table `_toggle_squad_status` path.
- Full local GUT **211/211**,47 scripts,47,106 assertions; no skipped parse-error test. Two added dossier tests cover populated real upgrades/artifacts, all role switches, exact RunState snapshot stability, new portraits/material, unavailable/lost roles and TAB close while roster focus is present.
- Existing `D285_SQUAD_DOSSIER_NATIVE_PASS`: actual solo330HP, role fates, real upgrade/relic widgets, footer and close button passed after the changes.
- Windows certificate-store diagnostic remains environmental; no claim of a warning-free engine startup. Existing19 GUT warnings retained.
- PR CI now includes the dossier smoke and actual GPU capture of all three selected heroes. CI result verified above. Native viewport keyboard injection also confirmed `D413_FOCUSED_TAB_CLOSE=true` while a real roster button had focus.

## Art provenance and rollback

Built-in imagegen produced three portrait paintings plus one empty panel material. Prompt set: tall2:3 single full-body character, exact D412 wardrobe/equipment/identity, readable upper-quarter face/helmet for roster crop, crisp dimensional painterly dark-fantasy materials, coherent cold castle arch/crimson banners/restrained candle amber, no text/frames/UI/statistics. Panel prompt: empty low-contrast obsidian material and thin worn antique-bronze border with nine-slice-safe cornerwork, no text or figures. Inputs were the player's UI reference and the actual D412 role source sheets; Knight portrait served as cross-role lighting/material reference for Ranger/Mage. Sources saved under `assets/pixel/ui/squad_dossier_d413/*_source.png`; no generated file remains only in an external cache.

Full1024x1536 WebPs retain paintings; native loader displays at640x960 without distorting aspect. Mini portraits are640x480 crops at source(220,40). Panel native WebP768x512 is reduced once to384x256 for nine-slice edge scale. All visual decorators ignore input except existing buttons/tooltip slots. Source art is generated painting, not hand-authored portrait pixels or a literal enlarged combat atlas.

Old v7 portraits and D287 ornament art remain tracked. Reverting D413 mapping/overlay restores the previous dossier; no save migration, resource-format or combat-state changes required.

## Review

F6 `res://scenes/dev/d413_squad_dossier_preview.tscn` opens a fixture through the actual Table handler (trio, one Knight upgrade, one relic). Use1/2/3 or roster cards, hover the relic, close with TAB/Escape/X. F5 normal Table → TAB checks the same production screen with the player's real current run. Only the F6 fixture resets its own test process's RunState.
