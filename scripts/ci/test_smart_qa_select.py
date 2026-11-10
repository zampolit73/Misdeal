import unittest
from smart_qa_select import classify

class SelectorTests(unittest.TestCase):
    def test_final_five_requires_full_release(self):
        for path in ("scripts/event/final_five_events.gd", "scripts/dev/final_five_capture.gd"):
            self.assertEqual(classify([path])["mode"], "release")

    def test_jack_event_requires_complete_native_release(self):
        self.assertEqual(classify(["resources/cards/jack.tres"])["mode"], "release")
        self.assertEqual(classify(["scripts/dev/jack_event_capture.gd"])["mode"], "release")

    def test_docs_do_not_boot_godot(self):
        self.assertEqual(classify(["docs/HANDOFF.md", "CHANGELOG.md"])["mode"], "docs")
        self.assertEqual(classify(["docs/HANDOFF.md"])["tests"], [])

    def test_card_art_requires_native_and_visual(self):
        plan = classify(["assets/pixel/card_unification_v1/run/a.webp"])
        self.assertEqual(plan["mode"], "visual")
        self.assertIn("card-gallery", plan["scenes"])
        self.assertIn("cards", plan["tests"])

    def test_qa_hub_only(self):
        plan = classify(["scripts/dev/qa_hub.gd", "scenes/dev/qa_hub.tscn"])
        self.assertEqual(plan["tests"], ["qa-hub"])
        self.assertEqual(plan["scenes"], ["qa-hub"])

    def test_deep_battle_run_core_suite(self):
        plan = classify(["scripts/battle/battle.gd"])
        self.assertEqual(len(plan["tests"]), 7)
        self.assertEqual(plan["mode"], "visual")
        self.assertIn("firing-square-break", plan["scenes"])
        self.assertIn("firing-square-crossfire", plan["scenes"])

    def test_crossfire_resource_triggers_two_real_screenshots(self):
        plan = classify(["resources/encounters/firing_square.tres"])
        self.assertEqual(plan["mode"], "visual")
        self.assertIn("firing-square-break", plan["scenes"])
        self.assertIn("firing-square-crossfire", plan["scenes"])

    def test_unknown_change_cannot_escape_qa(self):
        plan = classify(["some/unclassified/thing.foo"])
        self.assertEqual(plan["mode"], "visual")
        self.assertEqual(len(plan["tests"]), 8)

    def test_release_is_always_full(self):
        plan = classify(["docs/ROADMAP.md"], "release")
        self.assertEqual(len(plan["tests"]), 8)
        self.assertEqual(len(plan["scenes"]), 10)

    def test_explicit_fast_skips_render(self):
        plan = classify(["assets/pixel/new_card.webp"], "fast")
        self.assertEqual(plan["mode"], "fast")
        self.assertFalse(plan["scenes"])

    def test_gut_unit_tests_are_fast_without_extra_screenshots(self):
        plan = classify(["tests/unit/test_battle_unit.gd"])
        self.assertEqual(plan["mode"], "fast")
        self.assertEqual(plan["scenes"], [])
        self.assertEqual(len(plan["tests"]), 8)

    def test_fate_spread_changes_capture_four_and_eight_card_states(self):
        plan = classify(["scripts/table/fate_spread_overlay.gd"])
        self.assertEqual(plan["mode"], "visual")
        self.assertIn("fate-spread-four", plan["scenes"])
        self.assertIn("fate-spread-eight", plan["scenes"])

    def test_visual_audit_fixture_requires_release_matrix(self):
        plan = classify(["scripts/dev/visual_polish_matrix.gd"])
        self.assertEqual(plan["mode"], "release")
        self.assertIn("battle", plan["tests"])
        self.assertIn("firing-square-crossfire", plan["scenes"])

    def test_ui_is_visual(self):
        plan = classify(["scripts/ui/card_ds3_skin.gd"])
        self.assertEqual(plan["mode"], "visual")
        self.assertIn("reward-upgrade", plan["scenes"])

    def test_reward_layout_gets_real_native_screenshot(self):
        plan = classify(["scripts/reward/reward.gd"])
        self.assertEqual(plan["mode"], "visual")
        self.assertIn("reward-upgrade", plan["scenes"])

if __name__ == "__main__":
    unittest.main()
