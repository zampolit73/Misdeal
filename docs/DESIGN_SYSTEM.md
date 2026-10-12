# Misdeal Design System 2.0 — Fate Spread Canonical Direction

Status: **Art direction approved by user 2026-10-12; implementation phased and opt-in.** The 1.0 component implementation and its local QA caveats remain valid below.

## Canonical visual reference

The user's approved **«MISDEAL — РАСКЛАД СУДЬБЫ» / Fate Spread Variant C tabletop** is the *primary art-direction standard* for every future screen. User explicitly loves its colors, graphical treatment, material texture, illumination and composition. **Do not repaint, recolor, reposition or simplify this original Fate Spread composition** as part of the design-system revision. Do not treat earlier UI critique as a mandate to redesign it.

Source of truth for actual scene and art: existing approved Fate Spread/tabletop assets and code in GitHub. The motivating 1280×720 screenshot was provided in chat on 2026-10-12; this document specifies its direction, not a replacement art asset.

### Material-first visual grammar

1. **Obsidian / blackened wood:** very dark textured ground, near-black stable readability plates; avoid generic smooth gradients.
2. **Blood-red ritual marks:** restrained ominous carved circles, wax, Wizard interference, danger; the occult red of the Fate Spread is a signature identity.
3. **Worn bronze and antique gold:** weathered metallic borders, typographic hierarchy, card fittings, interactive hardware; avoid shiny modern gold.
4. **Aged parchment:** readable warm ivory card faces, ink-dark labels, tarot-like illustration frames; do not flatten cards into contemporary UI panels.
5. **Cold steel-blue moonlight:** environmental contrast and distant shadows, secondary examination tools; class colors remain semantically distinct.
6. **Warm practical light:** candles, ember, flicker and depth, used sparingly without obscuring controls.
7. **Physicality and asymmetry:** cards can tilt and cast subtle shadows, deck/held/discard slots occupy tangible places. Irregularity belongs in authored art, not in the usability of click targets.

### Reference palette — opt-in extension

These are **provisional, art-derived semantic targets**, not sampled/pixel-measured replacement values for existing gameplay components:

| Token (new, opt-in) | Color | Role |
| --- | --- | --- |
| `TABLE_OBSIDIAN` | `#100C0D` | Dark carved table / neutral backing |
| `RITUAL_CRIMSON` | `#62201E` | Wizard mark / occult inlay |
| `AGED_BRONZE` | `#A66636` | Worn metal trims / hardware |
| `PARCHMENT_WARM` | `#DFB77E` | Warm card stock reference / highlighted ink labels |
| `MOONLIT_STEEL` | `#334758` | Cool ambient accents / secondary visual metal |

Keep `GOLD`, `BRONZE`, `EMBER`, `STEEL`, `TEXT` and class/status colors backward-compatible during migration. Contrast, state distinctions, Cyrillic legibility and Godot 1280×720 QA still apply. **No live screen should change automatically by adding the new tokens.**

### Screen adoption contract

- **Freeze original approved Fate Spread** (layout I–XIII, center boss XIII, Held/Rejected placement, illustrations, texture, colors, lighting and current interaction).
- Main/Intro/Class Select: eventually adopt aged material framing and restrained ceremonial accents, preserving authored splash art, silhouettes and text visibility.
- Table and event/choice UI: physical deck/ink/parchment conventions; no new generic flat-card treatment or invented route information.
- Rewards, forge, merchant: tactile inventory, coin, brass and parchment, with strong readable content hierarchy.
- Battle HUD: borrow **material UI** from the table, not its circular composition. Preserve pixel-art battlefields, floor space, tactical buttons and enemy readability.
- Run End / Wizard stake: theatrical wax, ritual crimson and antique gold; significance over decoration.

### Safe implementation stages

- **Stage 0 — approved and recorded (this checkpoint):** document the Fate Spread as canonical, add opt-in palette tokens, record a binding design decision. No live screen restyling.
- **Stage 1 — to review:** draft a single **isolated preview** of a reward/event material surface using opt-in primitives, screenshot it at 1280×720 in Godot and ask user approval.
- **Stage 2 — after sign-off:** migrate one approved live screen at a time via `MisdealUIKit` helpers, verify events, text and click/hover/press/disabled states.
- **Stage 3:** extend to remaining UI only from approved screenshots. No wholesale batch art remakes or changes to cards' meaning, layout, encounter flow, or battle physics.

### Non-negotiables

- Treat the Fate Spread screenshot as a style *anchor*, not as a texture to copy into every scene.
- Do not claim completed 2.0 production migrations until they are actually in GitHub and reviewed in Godot.
- Avoid ornamental noise and excessive glowing borders; the rich texture lives in the art, the UI stays legible.
- New scene-specific art requires separate visual acceptance before switching runtime resources.

---

## Historical Design System 1.0 specification (retained for backwards compatibility)

# Misdeal Design System 1.0 — Foundation (historical implementation baseline)

Status: **Packages 1–3 implemented in a conservative core-screen pass; local Godot review pending** (2026-10-12)  
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

Current rollout:
- **Package 2 — Components (implemented):** shared panel/button/card/tooltip variants, battle StyleBox migration and a live interactive preview (Section 7). **Awaiting local Godot review.**
- **Package 3 — Screen pass (not started):** review battle/table/class-select/menus against actual 1280×720 screenshots, prioritize tactical readability and preserve accepted artwork. Change layout only after approval.

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

## 8. Package 3 — Production Screen Pass (2026-10-12)

**Scope:** selectively connect proven Component Library styles to the **real** `Main`, `Intro`, `ClassSelect`, `Table`, `Battle`, and `RunEnd` scripts without changing their approved `.tscn` positions or art.

The user explicitly requested this package before the earlier local component-gallery gate was reported as passed. Treat code as committed but the **visual gate as still pending**. Do not infer that the Godot runtime has been exercised.

| Production screen | Implemented migration | Explicitly preserved |
| --- | --- | --- |
| Main / splash | `apply_splash_hotspot` for semantic font colors, focus/disabled states | existing fully transparent normal button and painted splash |
| Intro | same hotspot for skip area, `apply_screen_copy` for high-contrast help | original intro images, timings and click handling |
| Class selection | shared copy readability for Wizard line, rules and status | knight/ranger/mage colored cards and character art |
| Table / fate cards | `apply_offer_card_frame` replaces duplicate `StyleBoxFlat` logic; shared HUD text contrast for progress/count labels | artwork, card pivots, deck/deal animations, held/marked/boss frame colors, Wizard speech |
| Tactical battle | `apply_battle_order_choice` highlights **only** current 3–5 selected order using existing button style; shared copy contrast improves hint, description and run metadata | all tactical effects, enemy AI, positions, modular HUD size, floor and fight flow |
| RunEnd | summary and Wizard explanation use shared readable text styling | result conditions, exact data, animations and approved background |

### Screen-pass components

- `apply_screen_copy(label, color, emphatic)`: text color and 1px shadow **only** — keeps every Label's authored font size, position and line wrapping, avoiding accidental UI overflow.
- `apply_splash_hotspot(button)`: **font color overrides only**. Never call `apply_action_button` on a transparent hotspot over a painted splash.
- `apply_offer_card_frame(button, boss, marked, held)`: single semantic card-frame implementation, reproducing the actual original normal/hover/pressed palette and 3px/4px borders. `RunState` stays outside UIKit. The priority remains **boss → wizard marked → held**.
- `apply_battle_order_choice(button, selected, accent)`: preserve compact battle button styling and overlay a more readable selected accent. `toggle_mode`, `button_pressed`, combat order selection and unlocked/order-count rules continue to live entirely in `battle.gd`.

### Required local review

1. `git pull` and Godot 4.7.x: enter normal Main → Intro → ClassSelect → Table → Battle → Results.
2. Main start and intro skip hotspots remain transparently on top of authored illustrations. Mouse hover and keyboard focus continue working.
3. Class selection: all three classes keep their authored accent and click/hover/confirm animations; Russian rule/status text remains legible.
4. Table: check normal, held, Wizard-marked and boss cards (including hover), stakes, cards dealing/returning; verify the new shared card-frame helper preserves old highlights.
5. Battle: choose НАТИСК → ОХОТА → СТРОЙ; where available check ЖЕРТВА and НЕПОВИНОВЕНИЕ. Only selected order should have the persistent accented state. Launch battle, confirm abilities/target preview and rewards unchanged.
6. RunEnd: success and death data display with no clipping/overlap at 1280×720.
7. Open both `scenes/dev/design_system_foundation_preview.tscn` and `scenes/dev/design_system_components_preview.tscn` with F6 if not already locally verified.

No engine executable was present in the connector execution environment, so source-level checks are **not** a substitute for these visual and interaction tests.

### Next after acceptance

Fix any reported local UI visibility or error regression **before** new art passes. Future polishing should be scoped and screenshot-driven (especially dense card text and 5-order battle states), not a fresh wholesale redesign or new UI framework. Keep `MisdealUIKit` the one source of style truth.
