# D303 — Approved modular painted Battle UI art (2026-10-20)

## Approval

User explicitly confirmed **«отлично утвердили»** after reviewing five separately rendered, empty, transparent UI artworks for Misdeal Battle DS3. This is **approval of the individual art modules**, not yet acceptance of their Godot implementation or the full in-game Battle screenshot. Previous D302 art gate remains open until these components replace the flat UI and a real 1280×720 Godot render is approved.

## Approved modules (exact files in the conversation's packaged source)

| Asset name | Native art | Purpose |
| --- | --- | --- |
| `battle_command_base.png` | 2172×724 | Full lower tactical chest; top title inset, three tactic wells, bottom description inset |
| `battle_fight_panel_base.png` | 1774×887 | Separate right ceremonial Fight chest; small target heading and large button recess |
| `tactic_button_idle.png` | 2172×724 | Inset idle order/button art |
| `tactic_button_selected.png` | 2172×724 | Glowing, selected order/button art |
| `battle_fight_button.png` | 1774×887 | Crimson premium main Fight button background |

Actual source generated assets are accessible in the conversation's generated-file set; a verified conversation ZIP `Misdeal_Battle_DS3_D303_approved_modules.zip` includes all five untouched RGBA PNGs, manifest, and README. They are **not yet physically present in GitHub**; do not falsely assert art uploaded or native implementation completed. When transferring, prefer a connector capable of committing original binary PNG/WebP. The current GitHub connector's contents-file helper accepts UTF-8 source text, so don't silently substitute schematic vector placeholders for approved art.

## Implementation contract

1. **Do not bake dynamic Russian wording, icons, numbers, or character art** into the new skins. All source images are empty decor foundations with alpha. Use actual live `Label` and `Button` nodes.
2. Integrate into `scripts/battle/battle_ds3_pass.gd` and, where relevant, a small module skin helper. Retire earlier D298 SVG bases and D299–D300 ornaments that clash; do not stack frames endlessly.
3. Keep the 1280×720 active viewport, `BottomHudPanel` around (251,575) 691×133, `FightHudPanel` around (949,575) 293×133; however, **art can deliberately protrude above/outside those button hitboxes** (candles, cloth). Control alpha and order; do not uniformly squeeze source art to a 5.2:1 rectangle, which distorts the approved 3:1 chest. Use transparent cropped textures, controlled extension and/or split scalable center fields.
4. Use `StyleBoxTexture` or other proper backgrounds for authentic tactic states so the 3–5 real Buttons remain functional. Keep `_select_tactical_order` and D301 in-panel hover preview. Hover and disabled states can derive from the approved idle art until explicitly illustrated; do not invent a newly approved state.
5. Preserve all Battle encounters, actual units/HP/floor/animations/AI, dynamic progress, 12 Fate cards, target-preview, Fight/Continue/Restart and optional Wizard objective. No changes to `RunState`, unit balance or placement.
6. Test source-image alpha/import, selected/idle visual switching, native hover/click and 3/4/5 available orders. Compare actual **1280×720 screenshot** against approved second reference for material authenticity, usability and intersections.

## QA status

- **Art modules: APPROVED by user.**
- **Runtime integration: PENDING** (not committed).
- **Native Godot import/regression and full Battle visual signoff: PENDING**.
- DS2 full restore point: `checkpoint/ds2-pre-ds3-2026-10-20` at `4cbd206`.
