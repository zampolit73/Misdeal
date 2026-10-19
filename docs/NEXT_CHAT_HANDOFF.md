# Misdeal — New Chat Entry Point (CURRENT D259)

**START**: [D259 canonical five-role art and release-prep state](D259_CANONICAL_FIVE_ROLE_RELEASE_PREP.md), [D259 actual new Battle F6](../scenes/dev/black_lantern_d259_real_battle_route_qa.tscn). For prior evidence: [D258 native five-role QA](D258_FIVE_ROLE_GODOT_QA.md), [D257 art source and warnings](D257_THREE_ATLAS_SEAM_RECOVERY_QA.md).

Read [AGENTS.md](../AGENTS.md), [CONCEPT.md](CONCEPT.md), [PROJECT_STATE.md](PROJECT_STATE.md), [ROADMAP.md](ROADMAP.md), [DECISIONS.md](DECISIONS.md), [HANDOFF.md](HANDOFF.md). GitHub main is source of truth; connected direct GitHub write tools available.

**Current:** All five Black Lantern original 25-pose characters are now **staged in canonical shared animation library**, and normal Battle loads them without D258 temporary injection. Godot 4.7.2 preflight PASS, 54-case functional matrix PASS. User says `«все ок»` on D258. Card target path linked, but **38th card is NOT live** (Act1 37/45), and reward-route automation/real difficulty approval remain release gates. Headless SceneTransition needs a QA-only frame signal, under CI evaluation. Do not change frozen KARAMBA73. [Exact implementation and next action](D259_CANONICAL_FIVE_ROLE_RELEASE_PREP.md).
