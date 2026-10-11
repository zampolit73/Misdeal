# Arena Redraw v1

Canonical production set for all twelve active battle arenas.

Each `*.webp.b64` file is a base64-wrapped WebP payload that decodes to a native 1280×720 arena plate. Runtime decoding/mapping is owned by `scripts/battle/authored_backdrop.gd`.

Design contract:
- environment only; no baked combatants or gameplay UI;
- broad quiet center floor for unit readability;
- landmark detail pushed toward the perimeter/background;
- dark-gothic stone, red cloth and fire remain common visual language;
- deployment/combat geometry changes are separate playtest-driven work.
