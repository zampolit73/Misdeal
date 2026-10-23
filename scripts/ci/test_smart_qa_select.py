import unittest
from smart_qa_select import classify

class SelectorTests(unittest.TestCase):
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
        self.assertEqual(plan["mode"], "fast")

    def test_unknown_change_cannot_escape_qa(self):
        plan = classify(["some/unclassified/thing.foo"])
        self.assertEqual(plan["mode"], "visual")
        self.assertEqual(len(plan["tests"]), 8)

    def test_release_is_always_full(self):
        plan = classify(["docs/ROADMAP.md"], "release")
        self.assertEqual(len(plan["tests"]), 8)
        self.assertEqual(len(plan["scenes"]), 5)

    def test_explicit_fast_skips_render(self):
        plan = classify(["assets/pixel/new_card.webp"], "fast")
        self.assertEqual(plan["mode"], "fast")
        self.assertFalse(plan["scenes"])

    def test_ui_is_visual(self):
        plan = classify(["scripts/ui/card_ds3_skin.gd"])
        self.assertEqual(plan["mode"], "visual")

if __name__ == "__main__":
    unittest.main()
