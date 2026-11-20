# Event Choice UI VNext

Two production screens share the same event header, illustrated choices and context strip. The header shows current gold, party, development and relics. If the scene text exceeds two lines, «Читать полностью» opens the full quote and description. The decision cards show the action, price, effects and any restriction. A disabled choice keeps its text and art. Mouse hover shows the reason in the context strip. Arrow keys and Tab move among enabled choices, and Enter activates the focused one.

## Coverage

| Production screen | Events |
|---|---|
| ActChoice · recruitment and conditional branches | `ash_rest`, `black_altar`, `chained_prisoner`, `jack`, `last_camp`, `rattling_bridge`, `bone_tax` |
| ActChoice · story, chance and trade-offs | `blood_ledger`, `broken_crown`, `debtor_bones`, `echo_crypt`, `faceless_card`, `lost_purse`, `moon_seal`, `wizard_tithe` |
| ActChoice · merchant and equipment offers | `gravedigger_shop`, `candle_seller`, `curse_forge` |
| ActChoice · Echo of the Siege | `banner_seamstress`, `borrowed_boots`, `false_weights`, `last_signal`, `unsent_letters` |
| WhisperingWell · rescue, relic or development | `whispering_well` |

Total: **24 Act I events, two scene types**. The prototype card scene belongs to a separate development path.

## Implementation

- `scripts/ui/event_choice_presentation.gd` lays out the existing interactive buttons and labels. It handles keyboard focus, D417-style hover feedback, opening the full text, and showing the committed choice and its result. The logical canvas is 1280×720. The project stretch setting also covers 960×540.
- `scripts/event/event_choice_copy.gd` separates authored text into action, price, outcome and restriction. Scene adapters supply live prices and gates, including reputation discounts, party constraints, upgrade limits, rescue scars and Wizard debt. Chance outcomes remain in the outcome field.
- The event scenes still apply each outcome and hand off to the existing Travel path. ActChoice shows «К столу» after a result. The Well still shows its result briefly and then continues automatically. RunState persistence and the approved Cinematic Travel assets are shared as before.
- Existing decision illustrations remain in use. The Well and Gravedigger use their existing location artwork behind the controls. The fourth decision uses the existing event illustration.

## QA

- [Native Godot gallery](qa/event_choice_vnext/README.md) — matched before and after, after-choice results, conditional offers and smaller windows.
- `test_event_choice_vnext.gd` discovers the live event resources, opens solo and trio variants in Godot, and checks illustration availability, text bounds, the Well alternatives and input locking, dynamic Bone Toll, Defiance availability, Wizard debt and both banner effects.
- Release CI captures both window sizes and activates the Well's paid rescue through real Godot keyboard input. The standard Release steps cover the five ordinary Siege event routes, Cinematic Travel outcomes and save/Continue.

To open a live event fixture, run `scenes/dev/qa_hub.tscn` with F6 and select **События → Шепчущий колодец**. Compare a Knight with 24 versus 25 gold. In F5, choose the Knight and take «Шепчущий колодец» when dealt. Select an option, read the result, and follow the scene through Travel back to the Table.
