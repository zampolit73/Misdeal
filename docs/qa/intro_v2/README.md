# Intro V2 native QA

Godot 4.7.2 at 1280×720. Verified the six original runtime WebP files and six PNG masters against the supplied SHA-256 manifest.

- [01 · Opening](frame_01.webp)
- [04 · The cost of changing fate](frame_04.webp)
- [06 · The deal and transition to the hall](frame_06.webp)
- [Existing hero selection after the fade](class_select.webp)

Played 01–06 using clicks, Space and Enter. Each frame loaded its supplied dialogue and waited for the next input. A second immediate input neither skipped a frame nor started a duplicate transition. The visible Skip button, Esc and Tab → Enter each led to hero selection.
