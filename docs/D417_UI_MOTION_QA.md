# D417 — interface motion polish

User requested smooth window entrances, slight card hover lift and pleasant press feedback. Branch follows D416/PR85 so current protagonist art and cleaned table remain intact; stacked PR should target `codex/d416-clean-table-backdrop` until its base merges. D414/PR83 remains separate.

## Behavior

- One barely visible preparation frame allows texture/font work to finish before the real-time entrance clock starts; close cancels this pending phase too. Native alpha samples must include an intermediate visible state, so cold-load pop-in cannot masquerade as a smooth entrance.
- Dossier, Fate Spread and full card reader fade in and rise10px (180/220ms cubic ease-out). Original layouts, artwork and text unchanged. Fate's individual slot reveal remains. Existing scene transitions unchanged.
- Table offer hover:8px/1.018× in160ms, replacing the sharper14px/1.03× effect; deal/select/discard choreography and durations preserved.
- ClassSelect: tweened7px hover/1.022× and3px selected/1.012× replace instantaneous scaling. New hover replaces the old tween; confirmation cancels hover before taking over transforms.
- Reward hover becomes interruptible and slightly gentler1.018×; existing selection takes over after cancelling it. No reward grants/modes changed.
- Explicit action buttons: Table Squad/Fate/Hold/Wager accept/refuse, protagonist Confirm, dossier/Fate/lore Close. Press0.975×/70ms with subtle warm darkening, return130ms; keyboard focus/hover1.012×. Binding is idempotent; disabled restores baseline. No synthetic pressed signals, input delay, global style changes or added dependencies.
- Dossier/Fate close during entrance cancels the entry tween; repeated close is guarded. Deferred dossier entrance cannot restart after close begins. Lore close remains immediate to preserve its callback contract.

## Verification

Local native Godot4.7.2: **215/215 GUT**,49 scripts,47,138 assertions; existing19 warnings. New3 regressions cover disabled/held button reset without actions, close during modal entrance/repeated close, twelve rapid pointer changes, delayed Reward entrance/reset cancellation, and exact return to rest/selection without committing RunState. Import has no script parse/load errors.

`scripts/dev/d417_capture_ui_motion.gd` records actual1280x720 Table hover/press, dossier, Fate Spread and card-reader windows at nominal20fps, checks original offer IDs and no committed card. Frames buffer in memory before PNG encoding so disk writes cannot stall short tweens. `timings.json` stores actual capture intervals. Native PASS is automated runtime evidence, not a claimed human playthrough. Existing Windows certificate-store diagnostic remains.

[Self-contained motion review](qa/d417/motion-preview.html) embeds downsampled640x360 WebP frames with actual timing and pause/replay, produced by Godot `d417_pack_motion_review.gd`; no browser recreation of UI or new dependencies. Native keyframes retained alongside it. Full raw frames remain CI artifacts/local temporary QA, not runtime assets. CI repeats stress GUT and native sequence. No full RELEASE matrix claimed.

Player check: F5 Table → hover between cards repeatedly, press Squad and close immediately/TAB; R opens/closes Fate; RMB opens card text. Start new run and hover/cycle class choices; inspect Reward hover after a fight. Buttons must react without extra clicks; card values, offers and route must remain unchanged. Rollback D417 code only; no saves/resources/art modified.
