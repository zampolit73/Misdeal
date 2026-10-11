# Misdeal Design System 1.0 — Foundation

Status: **Foundation + Package 2 Components implemented; full screen migration pending** (2026-10-12)  
Godot: **4.7.x / GDScript**  
Canonical runtime tokens: `scripts/ui/misdeal_ui_kit.gd` (`MisdealUIKit`)  
Review scene: `res://scenes/dev/design_system_foundation_preview.tscn`

## Intent

Make Misdeal feel like **one handmade dark-fantasy game**, not a set of separately generated screens. The cursed table, the Wizard, tarot-like cards and the tactical arena share one material/typographic language. The Foundation records already-accepted values; it **does not** redesign approved scenes or alter the gameplay loop.

The existing `MisdealUIKit` already styles the table and combat interface. We extend it rather than introduce a second incompatible styling framework. All new UI should use its tokens. Old authored `.tscn` dimensions and battle-specific modular HUD chrome remain until a separate reviewed screen pass.

## 1. Color / semantic roles

| Token in `MisdealUIKit` | Color | Purpose |
| --- | --- | --- |
| `VOID` | `#020102` (approx.) | Full-screen backing behind art, never a bright gradient |
| `GOLD` | `#EDAD5C` | Headlines, selectable fate/reward, restrained attention |
| `BRONZE` | `#AB4F30` | Standard panels, quiet card frames and controls |
| `EMBER` | `#E04021` | Critical decision, risk, destructive/wager action |
| `STEEL` | `#6B99B8` | Secondary action, inspection, neutral tactical utility |
| `KNIGHT` | `#619CE0` | Knight class/identity; not generic button blue |
| `RANGER` | `#6BB863` | Ranger class/identity |
| `MAGE` | `#AD6EDB` | Mage class/identity |
| `TEXT` | `#F0D6B3` | Default readable light text |
| `TEXT_ON_DARK` | `#F7EDE0` | High-priority copy over consistently dark surfaces |
| `TEXT_SECONDARY` | `#CCBAA6` | Help, descriptions and supporting information |
| `TEXT_MUTED` | `#7A7373` | Disabled/de-emphasized *nonessential* information only |
| `STATUS_SUCCESS` | `#6BBF75` | Positive state (plus icon/wording) |
| `STATUS_DANGER` | `#E65240` | Hazard/negative state (plus icon/wording) |

Rules:
- Primary text belongs on a dark, steady panel; **never** over a fire, busy banner, high-contrast cobblestone, or animated VFX without a legibility surface.
- Aim for WCAG-like contrast of **4.5:1 for body-sized copy** and **3:1 for large display text** on real textured screenshots. Pixel art has brighter patches than a solid design token, so verify against the actual scene.
- Gold is for hierarchy. Do not make every frame, body label and decorative line gold.
- Team colors, HP bars and enemy red do **not** rely on color alone. Keep silhouettes, icons, value, spacing or positioning.
- Avoid glowing neon borders and infinite ornate microdetails.

## 2. Typography

Use the project's existing Godot-safe font until a dedicated licensed font is selected. **Do not introduce an external font or blindly replace Cyrillic glyphs.** Apply roles with `MisdealUIKit.apply_text_role(label, role, color)` in newly built UI.

| Role | Token | Reference size @ 1280×720 | Typical use |
| --- | --- | --- | --- |
| `display` | `TYPE_DISPLAY` | 36px | Rare major result/act splash |
| `title` | `TYPE_TITLE` | 28px | Encounter title, modal header |
| `section` | `TYPE_SECTION` | 20px | Panel grouping, category headings |
| `body` | `TYPE_BODY` | 16px | Description and decision text |
| `meta` | `TYPE_META` | 14px | Battle metadata, unit labels |
| `caption` | `TYPE_CAPTION` | 12px | Short secondary labels |
| `micro` | `TYPE_MICRO` | 10px | Nonessential dense metadata **only**; not primary instructions |

Rules:
- Prefer one title, one section hierarchy, and short descriptive copy. Never compensate for an overcrowded HUD by shrinking actionable text below caption scale.
- Use 1–2px dark text shadow where necessary for readability, not giant glowing glyphs.
- Russian strings must be checked at full width; do not abbreviate tactical orders. Font assets, if added later, must demonstrably support Cyrillic.
- Existing authored scene sizes are grandfathered in. This document specifies **new and migrated** screens, not a claim that all legacy labels already comply.

## 3. Spacing, dimensions, corners

Base increments: `SPACE_1=4`, `SPACE_2=8`, `SPACE_3=12`, `SPACE_4=16`, `SPACE_6=24`, `SPACE_8=32` (pixels).

- Reference canvas: `BASE_VIEWPORT=1280×720`, matching `project.godot`. Author at native viewport; test window scaling separately.
- Outer HUD safe inset: **24–32px** when possible; intentional full-bleed artwork is exempt.
- Panel internal padding: **16–24px**; separate component groups by **12–24px**.
- Action button minimum: **40px height**, important confirmation: **48px**. Use `apply_button_minimum` for new layouts only.
- Standard controls: `BORDER_NORMAL=2` (pixel style), quiet line `BORDER_HAIRLINE=1`, emphasized `BORDER_STRONG=3`; `CORNER_RADIUS=0`. Prefer restrained squared hardware to glossy modern pills.
- Keep strong touch targets large enough without covering half the battlefield. Battle's existing five-order layout is an explicit content requirement.
- The arena's wide center is **reserved for readable units and floor**; panels must not drift into the tactical playing field.

## 4. UI layering / readability

Advisory UI bands for **new** Control/CanvasLayer screens: `LAYER_WORLD=0`, `LAYER_GAMEPLAY_FEEDBACK=10`, `LAYER_HUD=20`, `LAYER_MODAL=40`, `LAYER_TRANSITION=60`.

These are organizational labels, **not** automatic settings for existing nodes. In the autobattler, `BattleUnit.z_index` still follows world depth and must **not** be overwritten by this global UI table.

- Art/backdrop first, then units + contact shadows, then short-lived gameplay feedback, then deliberate modular HUD, then modal/result and transition screens.
- Deployment hints remain **drag-only** and derived from real legal rectangles; no baked tactical grids on arena illustrations.
- Unit HP/name labels must not overlap other creatures or disappear into high-frequency scenery. Fight HUD must keep order names and the Fight button legible.
- The Wizard's commentary takes priority only when it adds gameplay meaning, not as a permanent large black slab over the environment.
- Physical Fate Spread and approved Variant C tabletop composition stay canonical; UI sits on top of that scene, not a replacement background.

## 5. Motion conventions (targets for later component pass)

- Hover response: **100–160ms**, clear visual contrast rather than scaling all cards wildly.
- Card reveal/selection: **180–320ms** if it does not delay interaction or obscure state.
- Battle impact/feedback remains controlled by battle FX, not shared generic UI animation.
- Respect reduced-motion/fallback requirements when motion settings are later introduced.
- These are guidance, **not an assertion** that timers/settings already exist in current code.

## 6. Implementation and migrations

Already implemented:
1. `MisdealUIKit` contains the existing canonical color palette and new semantic colors, type scale, spacing, stroke, button minimum and advisory layer tokens.
2. `MisdealUIKit.apply_text_role` and `apply_button_minimum` are **opt-in** helpers. Existing `apply_panel`, `apply_action_button`, `apply_card_button`, `apply_title`, and `apply_subtitle` remain compatible.
3. A dedicated **non-gameplay review scene** demonstrates real Godot panels, colors, buttons and type: open `res://scenes/dev/design_system_foundation_preview.tscn` via Godot and run **Current Scene (F6)**. It is not routed from Main/Menu/Table and does not alter combat.

Next:
- **Package 2 — Components:** unify actual button/panel/card/tip states on top of tokens, removing duplicated stylistic implementation (particularly battle-local StyleBox constructors). Review on a visual comparison screen before migrating production.
- **Package 3 — Screen pass:** review battle/table/class-select/menus against actual 1280×720 screenshots, prioritize tactical readability and preserve accepted artwork. Change layout only after approval.

### Smoke check

- Open normal Main → Table → battle: no visual/logic change should be caused by adding Foundation tokens.
- F6 preview scene: should show nine swatches, one title hierarchy, bronze/steel panel examples and primary/secondary/tactical buttons.
- No new fonts, external addons, changes to `project.godot`, combat or art resources.

Design decision: **the shared kit is the one runtime source of design token truth**, not a parallel Figma-only specification or a replacement renderer. See `docs/DECISIONS.md` (Foundation entry).

## 7. Package 2 — live component library (2026-10-12)

Source: `scripts/ui/misdeal_ui_kit.gd` and opt-in `scripts/ui/misdeal_tooltip_button.gd`  
Interactive preview: `res://scenes/dev/design_system_components_preview.tscn` (Godot F6)

The UI kit styles **native Godot Controls**. It is not a disconnected mockup or a replacement component framework. Call the shared helper **once** when the component is initialized (and after relevant state changes); styles are duplicated on each control rather than sharing mutable `StyleBoxFlat` instances.

| Component | Entry point | States, purpose |
| --- | --- | --- |
| Card-decision button | `apply_card_button(button, BRONZE)` | normal / hover / pressed / disabled, existing tactile tabletop card chroming |
| Standard / main action | `apply_action_button(button, accent, strong)` | same four states; risk in `EMBER`, neutral in `STEEL`, rare headline reward in `GOLD` |
| Selected tactical/choice action | `apply_selected_button(button, selected, GOLD)` | optional persistent selected border/fill; **visual only**, does not change `button_pressed` or game state |
| Modular battle panel | `apply_battle_panel(panel, accent, alpha)` | low-opacity original battle HUD surface; retains the approved **2px corner** from the running game |
| Battle action button | `apply_battle_button(button, accent, primary)` | same normal/hover/pressed/disabled values as pre-migration battle code; no gameplay layout changes |
| General panel / compact chip | `apply_panel(control, accent, strong)` / `apply_chip(control, accent)` | existing card/table framing plus slim status chip |
| Inset event/card surface | `apply_card_surface(panel_container, accent, selected)` | 2px/3px frame and 16px insets; no replacement for the hand-painted card artwork |
| Readable tip/description | `apply_tooltip_panel(panel_container, STEEL)` | high-opacity legible short text panel with insets |
| Native hover tooltip | `make_tooltip(message, accent)` | returns a new unattached `PanelContainer` with text; intended for `_make_custom_tooltip` |

To enable **native Godot popup tooltip** on a *new* button, instantiate
`res://scripts/ui/misdeal_tooltip_button.gd` (extends `Button`) and assign `tooltip_text`. Existing buttons intentionally keep their current tooltip behavior until explicitly migrated. Do not parent the newly created tooltip returned by `_make_custom_tooltip`; Godot's popup manager takes ownership.

The live `battle.gd` uses **`MisdealUIKit.apply_battle_panel` and `apply_battle_button`** instead of maintaining 100+ lines of duplicate `StyleBoxFlat` setup. The numeric color/transparency/border/corner rules were copied *verbatim* into shared helpers; changing the module location is not permission to redraw the user's approved modular battle HUD.

### Test scenario (Godot 4.7.x)

1. `git pull`; run `res://scenes/dev/design_system_components_preview.tscn` with **F6** at reference 1280×720.
2. Hover card/action buttons. Check contrast and pressed feedback; disabled action should remain unavailable.
3. Press **НАТИСК / ОХОТА / СТРОЙ**; exactly one retains selected visual highlight, clicking must switch it.
4. Hover **НАВЕДИ НА МЕНЯ**; ensure the native tooltip appears with readable Cyrillic, no clipping.
5. Compare inset card samples and modular battle HUD against actual tabletop and battle screens.
6. Smoke Main → Table → battle: no visual size/position shift, and `БОЙ`, all 3–5 tactics, event cards, stakes and rewards still work.

This preview is a **review gate**: the Godot executable was unavailable during connector-based implementation. No runtime claim is made before the user's local F6 test.

### Next — Package 3 screen pass

Only after visual approval, migrate select widgets and local sizes/spacing on table, battle and menus to these shared helpers. Battle unit positions, art and floor geometry are out of scope. If a shared default causes regressions, preserve the existing screen geometry and fix the variant rather than restyling the entire screen.
