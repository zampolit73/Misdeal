# Camp Rest Visual V2

- [IV · First rest](first-rest-iv.webp) shows a wounded solo Knight and all three choices.
- [XII · Final preparation](final-preparation-xii.webp) shows a trio, the Oath II treatment rate, the Ranger's training offer and a rite blocked by low HP.

The 1280×720 images were captured from the production Table scene in Godot 4.7.2 using isolated profiles. The fixture resolved a card through the existing RunState method to schedule each stop. It checked keyboard activation, mouse selection, the training role and full details, exhausted offers, rite pricing and duplicate actions. It also checked save rollback and feedback, the saved checkpoint, return to the same Table, and a bandage purchase at VIII.

To inspect in the campaign, resolve card IV or XII and return to the table. Use Tab or the arrow keys to move focus, Enter to choose, and hover a card for the full effect.

## Black & Gold V3

Player-reported screenshots showed the old ornate camp cards. Both production stops now share the existing V3 card face; the old plate and approved artwork remain unchanged. Exact art regions and masks live in the existing layout JSON. New text fits the card with overflow-only tooltips; training selector remains independent, and blocked choices expose their reason.

Godot 4.7.2 (headless): 29/29 tests, 572 assertions across camp, shared cards and save suite. New tests cover both rest views, actual art regions, text/action bounds, role selection, disabled states, real CampStop panel and a saved checkpoint, and duplicate activation. Full gameplay_core_smoke via headless on both base and changed trees failed before the changed scene (could not reach Reward); not a verified full-route PASS. Native framebuffer unavailable locally; CI matrix now includes camp_rest_iv and camp_rest_xii at 1280x720. Player visual acceptance pending.
