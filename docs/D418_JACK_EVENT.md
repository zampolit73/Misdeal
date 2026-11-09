# D418 — Jack, Ranger-bound event and animal companion

Delivery: [PR88](https://github.com/zampolit73/Misdeal/pull/88) · [final-head RELEASE checks](https://github.com/zampolit73/Misdeal/pull/88/checks).

User requested a new event from the supplied dog reference: only with a Ranger, exactly three choices. User selected **option1, ruined gateway** from three actually rendered scenes. Original selected PNG is retained verbatim at assets/pixel/events/jack/approved_source.png (SHA256 ae73dccfb5764cbe11ca6368f4fad1d65ceff568b26922e5a2808090b730b352). Card/backdrop preserve the complete composition and colors, fitting with narrow dark side margins; choice road/token details are crops of that same painting, no unrelated crown or occult card. No baked text/UI. Existing DS2 event presentation and DS3 physical card are reused.

## Actual game behavior

- New ordinary **Tier1** event `jack`, pool **40/45**; same twelve resolutions plus XIII, two offers and mandatory combat windows. Eligible only if Ranger is protagonist OR recruited. Standard tier candidates, fallback candidates, Wizard replacements and final choose guard enforce the condition. Not guaranteed every run; no separate forced deal.
- **Take Jack:**25 gold for treatment. Disabled below25; transaction rechecks eligibility/price and resolves exactly once. Jack joins as a Ranger-bound animal, never a fourth hero in party_roles or a relic/upgrade slot.
- **Walk past:** nothing gained or lost; dog remains at ruins.
- **Take hunting token:** dog remains; Ranger damage ×1.10 until run reset. Exact same modifier in live Battle and effective/dossier stats, compatible with upgrades/relics; other roles unchanged. No inventory-capacity dependency or invented relic rarity.
- Jack has fixed45 HP,6 damage,1s attack interval,38 range,105 speed,16 radius. Uses existing BattleUnit combat/targeting/orders/collision. No hero solo/duo compensation, hero upgrades or relics applied to animal. Hero party-size/enemy compensation unchanged.
- Animal appears at each battle start while bond and Ranger remain in run. Like heroes, each battle starts restored. Falling during a fight is not permanent run loss; dog does not respawn within that fight. A surviving dog cannot replace a defeated hero party or grant solo-animal victory. Hero-only no-critical objective ignores pet damage/death. Existing Last Deal behavior retained.
- Scoped legal-floor placement moves only pet clear of hero silhouettes at preparation/wave break. Existing hero deployment, timing, controls and wave contracts unchanged. Dossier and RunEnd record bond/token.

## Art and complete animation production

Built-in imagegen skill used, no CLI/API fallback. Selected scene prompt: landscape3:2, battered natural black-and-tan floppy-eared hunting dog, burgundy neckcloth, bronze bone token, sore lifted paw, ruined gateway with amber lantern, wet grounded stone, foggy Gothic castle, slate/bronze/burgundy painterly pixel texture, no text/frame/UI. Other options were shrine road and castle stair; only chosen gateway painting shipped.

Animation prompt: complete regular6×5 transparent sheet, same black-and-tan dog/collar/scarf in every cel, right-facing natural quadruped, rich small-scale Gothic pixel language, no text/grid/floor,25 distinct poses: idle4; walk6 alternating grounded paws; bite6 anticipation/lunge/contact/recoil; hit3; death6 ending naturally prone, five unused cells. Original generated source remains at assets/pixel/units/jack/source.png; **not claimed hand-pixel-authored**. Offline `pack_jack_assets.gd` only slices, uniformly downsamples and pads original drawings to96px, sole row90. WebP uses lossy=false ([Godot Image contract](https://docs.godotengine.org/en/stable/classes/class_image.html#class-image-method-save-webp)); visible RGBA equality is tested against the uncompressed packed PNG. Runtime strict576×480 lossless WebP Base64,25 distinct poses and five alpha-clear cells; no old enemy sprite substituted. Source hashes and all original D412 hero tests remain guarded.

## Evidence and QA

Local native Godot4.7.2:231/231 GUT,52 scripts;14 selector tests. Seven new regressions: normal240 sampled role deals/replacements and empty fallback; recruited Ranger unlock; three real choices/repeat-input/reset; insufficient gold; fixed pet/hero stats solo+trio; token live/dossier agreement with upgrade/relic; hero defeat/objective semantics; complete source art/25 poses. Native16-frame observer includes actual ordinary Table offer and button→event→recruit→Table, real pet movement and natural attack, forced QA hit/death, Battle win→Reward, all choices/poor wallet, trio wave break and dossier. Forced damage is explicit QA, no production cheat or changed damage rules. Full RELEASE CI is required before integration, including52-state general matrix and legacy routes.

[Event](qa/d418/event_rich.png) · [table](qa/d418/table_offer.png) · [pet attack](qa/d418/pet_attack.png) · [wave break](qa/d418/trio_wave_break.png) · [dossier](qa/d418/dossier.png) · [manifest](qa/d418/manifest.json). Full16 captures uploaded by CI.

No human full F5 campaign or balance acceptance claimed. Existing19 GUT warnings and Windows certificate/log settings diagnostics remain. Native observer can report3 ObjectDB instances at shutdown; separate from functional PASS, not hidden. New pricing/stats are conservative implementation defaults for player feedback, not immutable balance decisions.

## Local check

F6 `res://scenes/dev/jack_event_playtest.tscn` opens the actual event with Ranger and50 gold. Try all three branches with F6 resets. Normal F5 event may appear in middle tier only with Ranger; keep25 gold to rescue. Check dog size/paws, bite/hit/death and wave deployment; TAB Ranger shows bond/token. Native replay: `godot --path . --script res://scripts/dev/jack_event_capture.gd -- <absolute-output-directory>`.
