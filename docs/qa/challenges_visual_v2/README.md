# Challenges Visual V2

**Approved:** the player tested and accepted the production result on 2026-11-24. PR #142 is merged into `main`; all four Archive tabs are approved.

On `main`, open **F5 → Архив Волшебника → Испытания**. Click a seal or press Down to enter the cabinet, then use the arrow keys and Enter. Esc returns to the main menu.

| Native Godot 4.7.2 at 1280×720 | Capture |
| --- | --- |
| Empty profile, locked Blood Oath | [0/12](challenges_00.webp) |
| First victory, opened Blood Oath | [4/12](challenges_04.webp) |
| Oath V available after winning on IV | [8/12, oath V](challenges_08_oath_v.webp) |
| Defeat on V leaves the victory achievement locked | [8/12, achievement](challenges_08_achievement.webp) |
| Oath V won | [12/12, oath V](challenges_12_oath_v.webp) |
| Victory on V completes the achievement | [12/12, achievement](challenges_12_achievement.webp) |

The supplied [plate and layout](../../../assets/pixel/ui/wizard_challenges_v2/) are used by the live tab. The [approved concept, master and SHA-256 manifest](../../../assets/source_archive/wizard_challenges_v2/) are archived separately. The four archive tabs share the same header and navigation.

Native QA compared the captures with the supplied plate and concept. Four isolated profiles were written and read through the existing archive interface using fixture results. The run checked selection of all 12 seals, navigation, conditions and full effect text, exact artwork states, tabs and Esc. Profile bytes matched before and after browsing. Godot reported the environment's Windows certificate-store diagnostic.

Styles use `style_unlocked(role)` and `RunCharter.STYLES`. Achievements retain their original win predicates. Oath availability follows `highest_oath()`. An oath's completed status and the final-oath achievement require a recorded victory on that rank. No rules or profile fields were changed.
