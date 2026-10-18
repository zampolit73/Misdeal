# D245 — Actual user-recorded Godot D244 25-pose character gallery QA

Date: 2026-10-19. Video: attached 21.38s H.264/1920×1080 screen recording, user's filename references "Список навыков проекта - Google Chrome - 19 October 2026.mp4" but footage after the first second actually shows `Misdeal (DEBUG)` running D244 preview. User-private MP4 is **not** committed; findings only.

## Evidenced directly by recorded native Godot display

- Native D244 QA preview launches with exact accepted D209 night-forest arena. ×3 enlargement and ×1 in-world Sentinel coexist with visible armor, separate long pointed spear, burgundy cloak and amber lantern attached to the gauntlet.
- LEFT: walk loop ~2–4s; death ~4.0–4.7s; hit ~5–7s; attack ~7.4–7.9s; walk again ~8.5–13s. RIGHT selected ~13s: walk ~13–14s; attack ~14.5–14.85s; hit ~15.5–16.1s; death ~16.1–17s; idle ~17.5–18.3s; walk ~18.5–21s. Times approximate; state labels and frames inspected with denser temporal sampling.
- Six-pose **horizontal spear attack** is genuinely visible in both facings for approximately 0.1–0.2s around its contact poses; spear returns to raised guard. Unlike D241, the illustrated attacker is not simply shuffled under a near-vertical spear.
- Fall is an identifiable sequence of buckling to knees → lowering → horizontal grounded body; lantern/armor/cape remain identifiable. No standing-poster rotation or late-stage red smear like rejected D241.
- Both directions use correct flipped orientation; there is no visually evident disappearing frame or missing sprite in those excerpts. Single current QA footage demonstrates displayed state playback, **not verified every underlying individual frame** at temporal resolution; static 25 unique atlas QC is still D244's separate evidence.

## Quality assessment and release gate

- **Native scene display and state-route: PASS (recorded).** User has in fact performed the requested ONE full-pack F6 run, so do not ask for repeated per-state approvals or claim F6 remains pending.
- **Motion-art evaluation: materially improved; user final aesthetic approval NOT YET STATED.** Walk currently reads as stepping but weight shift is more subtle than attack; actual ×1 leg motion is hard to judge fully against complex ground. Spear impact is short (D244 preview attack speed 16fps, six frames ~0.375s); this makes the contact easy to miss on a sparse frame sample, though it exists. No FPS-only disguise or reflexive tempo changes without a concrete defect.
- **Production battle/full encounter: NOT TESTED** by this screen capture. No #38 card release and no actual Battle→Reward→Table, matrix balance or five-role cross-composition was shown.
- No user text accompanying the upload explicitly says accepted/rejected. An uploaded demonstration is not itself carte-blanche to register a sprite in `MisdealUnitAnimationLibrary`.

## Next

Solicit at most **one overall artwork verdict**: is the complete D244 Road Sentinel visually acceptable now, or is a specific defect blocking it? If accepted, proceed to the four other bespoke skeleton roles under the existing D238 one-full-pack-per-character workflow; only after all five and real battle QA consider #38 release. If concrete art concerns remain, revise *one full pack* rather than reopening micro-approvals. Preserve actual full D244 art and D235 locked character design.

Live pool 37/45. Approved D200/D209, DS2, sealed XIII and frozen `backups/KARAMBA73-2026-10-16` unchanged.
