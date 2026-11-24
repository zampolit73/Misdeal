# Event Choice Visual V3.1 · palette pilot

Native Godot 4.7.2 captures at 1280×720. Each event starts with the Knight and zero gold.

| Event | Before | V3.1 |
| --- | --- | --- |
| Чужие сапоги | [Before](before_borrowed_boots.webp) | [V3.1](after_borrowed_boots.webp) |
| Кости должника | [Before](before_debtor_bones.webp) | [V3.1](after_debtor_bones.webp) |
| Шепчущий колодец | [Before](before_whispering_well.webp) | [V3.1](after_whispering_well.webp) |

Opened the production scenes and checked the three- and four-choice layouts against the [Table V5.1 Godot capture](../table_interface_v51/table_v51.webp). Boots and Well both showed the insufficient-gold reason and skipped the locked choice during keyboard navigation. Right Arrow moved focus and Enter confirmed an available choice in all three events.

To review locally, open `scenes/dev/qa_hub.tscn` in Godot and press F6. Find the events by title under «События». Set gold to 0 to review the locked choices in Boots and Well. Use the arrow keys and Enter to try the available choices.
