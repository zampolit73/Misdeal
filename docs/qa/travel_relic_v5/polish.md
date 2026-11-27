# Relic transaction polish — continuous world (2026-11-28)

Player rejected the first version: the interaction animation looked like a
cut-away from another game. Supersedes the previous insert-based staging.
Review-only; no campaign allowlist or gameplay change.

## Reproduction

Pull main, open `scenes/dev/travel_relic_v5_preview.tscn`, F6.
Z/X scene, arrows outcome, 1/2/3 party size, Q/E composition, J existing
Ranger's Jack, P/R pause/replay, H hide toolbar, M audio.
All three scenes use one human-scale painting, one shared continuous camera
(6.6s), 2.45–4.16s interaction/departure beat, outcome at 3.22s.
No full-frame inserts and no giant close-up on another canvas.
Watch the approach, the hand actually reaching the prop, the effect itself,
the settled visual result and the exit. Pass remains continuous. At native F6
review lighting, NPC/hero transitions, actual Jack and the sound mix.

## Art and motion

- Three newly generated integrated 1280×720 environments using the earlier
  human-scale composition guides; the NPC, fixed table, cloth, candle and
  architecture are painted together, not detached miniatures. Local NPC
  reactions use two separately authored, registered regional cels (140×105 and
  200×141) with feathered perimeter. Other scene pixels retain their identity.
- Twenty independently generated tabletop prop cels in three 192-cell WebP
  atlases. Dice bounce and rotate into resolved face arrangements; winnings
  and safe coins transfer to customer, stake/box show actual result; broken
  dice settle. Chalice receives coins or red liquid, tips on refusal with
  the unsealed scroll. Crown lifts toward hand, breaks or settles into a
  matte trace, without adding a crown to the combat sprites.
- Nine new standing gestures (three each Knight/Ranger/Mage) from the approved
  HD references; same original 96px logical geometry, 288px painted cels,
  normalized sole and scale, no kneeling/defeat pose. Waiting/walking/rear
  sprites and the adult Jack library remain the existing approved assets.
- Scene-local tint, contact shadows, soft damp-floor reflections, local
  candle/cloth/hand motion and continuous camera easing. Preview ambience
  of dungeon or wind uses already registered project OGGs; existing dice,
  coins, bone, metal, cloth and stone cues synchronized to the action.
- Earlier V5 version, original card paintings/V4 and 10 live V5 scenes intact.

## Focused validation

Godot 4.7.2 isolated fixture: **132 contexts / 26,215 checks / 0 failures**.
Exact resolved props for all 12 outcomes, true party and companion,
one visible world and base, three standing gesture phases, HD projection,
soles, NPC patch, wet-floor reflection alignment, path progression,
repeat and F6 controls verified. Import and headless launch completed.
Offline visual sample review uses actual sampled Godot textures,
global transforms, z-order, texture scale/flip, opacity and tint;
reflection mask approximated, shader lighting/liquid effects and audible
mix not captured. Native renderer unavailable in this fixture (X display
creation failed); native player F6 visual/audio review still pending.
No claim of a full campaign or GPU performance test.

[Sampled frame grid](polish_samples.jpg) · [Smoke output](polish_smoke.log)
· [Source receipt](polish_provenance.json) · [Inventory](polish_license_inventory.log).

## Provenance and rollback

Generated plates and props use only pinned Misdeal art references.
Nine gesture poses use the existing approved source-detail hero idle cels.
The corrected gesture sheet removes unwanted altar geometry, keeps only
the actual actors. `scripts/dev/pack_relic_polish.py` registers
and packs selected generated inputs, trims alpha fringes, normalizes foot
pivot and local NPC edges. No third-party images/dependencies introduced.
The runtime plates/atlases, authored shaders and QA sheet are hashed in
THIRD_PARTY_ASSETS.json. Historical source and tool rights review is still a
commercial-release gate, not a claim of clearance. Previous candidate
at `bebc1389ed42555b8495ce0d914efdc6778e606b` remains available.
