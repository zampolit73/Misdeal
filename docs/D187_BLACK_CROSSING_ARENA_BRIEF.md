# D187 — Black Crossing combat arena brief (awaiting user choice)

Date: 2026-10-15. Act 1 **36/45**, candidate card #37 (`black_crossing`) still QA-only; character animation gallery **user-reported PASS (D186)**.

Three concept proposals, **not yet accepted**:
- **A — Broken timber pier**: an asymmetrically collapsed old timber landing; wide horizontal center plank floor, black tide below, single lantern on the right, moonlight upper left, ONE distant ruin, few purposeful posts.
- **B — Ruined stone sluice**: decayed stone gate and flooded masonry landing; big empty flat tactical bridge across mid-frame; heavy stone sluice relief on one side and wet steps on the other, no repetitious towers; sparse red cloth as Misdeal color connection.
- **C — Fractured causeway**: elevated mooring ramp with a broken secondary footbridge in the background and tide at its sides; wide open arena center, directional leading lines, no clutter or extraneous fight characters.

Art constraints: actual **1280×720** background, designed for units/HUD drawn later by Godot. Do not generate or integrate characters, labels, drawn hit bars, wave UI, card borders, scripted mechanic marks or action icons as part of backdrop. For readability, keep arena central band (roughly x=220–1070, y=280–565) unoccupied by foreground machinery so 3-vs-3 units have leg-contact and telegraphed hazard strip visibility. Blue-charcoal moonlit Misdeal DS2 palette, muted burgundy, minimal warm amber lantern, original pixel-art environment with plausible construction and varied silhouette, no clone castles/towers or fake infinitesimal detail. Selected card illustration option #3 remains approved and locked, **not** the actual battle arena.

Only after an explicit choice commit the approved exact arena asset and add a `black_crossing` runtime backdrop path; separately implement encounter-only telegraphed wave push/slow and original UnitData/encounter, followed by 54-case native Godot QA and real battle/reward route. No automatic live-card activation.
