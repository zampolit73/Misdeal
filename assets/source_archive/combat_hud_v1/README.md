# Combat HUD Visual V1 · source and layout

- `approved_reference.webp`: high-quality WebP archive of the player-approved live-combat concept, 2026-11-26.
- `layout_preview.webp`: offline 1280×720 composition over the approved V4 Grave Bell combat screenshot using the actual panel bounds and source material. The source capture contains QA-only bottom buttons; production navigation is unchanged. This is not a native screenshot.
- The runtime `assets/pixel/ui/combat_hud_v1/orders_frame.webp` is a lossless technical crop/resize of the approved D413/V4 bronze frame: original panel.webp crop (7,8)-(761,505), 377×249. It is used as a 17-pixel nine-sliced frame so solo/duo/trio heights retain corners. The existing D303 red title plate and V4 role-emblem renderer are reused as-is; labels/timers/transition copy are live.
- No combat background, unit art, HP bar, Wizard panel, preparation deck or gameplay asset is replaced. [QA](../../../docs/qa/combat_hud_v1/README.md).
