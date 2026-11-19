# Cinematic Travel Batch 03 · native review

Review branch `review/cinematic-travel-batch-03`. Art package [PR #118](https://github.com/zampolit73/Misdeal/pull/118), frozen source `6ab57186f12b6550be1fa568ab004162efdb5af7`. The review build uses 10 locations, 72 outcomes and 97 runtime plates from that package. The large reference sheets, gallery and production sources remain in the art package.

## Review in Godot 4.7.2

Open `scenes/dev/qa_hub.tscn` with F6. Under Travel select **Batch 03 — 72 исхода** or search by the individual location name. Left and right change the outcome, 1/2/3 select a valid party configuration, P pauses and R replays. The launcher displays the resulting party and action. Some outcomes constrain the available party, such as Jack requiring Ranger and recruitment requiring the joining role.

F5 on this review branch also uses the live Event → Travel → Table path for all ten cards. Verify one rescue (the waiting actor disappears as the active hero joins), Jack (one companion behind Ranger), the Well (coin, gift, or departure), and a Faceless Card outcome. Esc skips the scene.

## Runtime and QA contract

- Events hand the exact committed action to the existing Travel catalog. The normal resolvers remain the authority for prices, artifacts, upgrades, RNG and party recruitment. The Well retains its existing delay and uses the same SceneRouter as the other events.
- Travel V2 owns the clock, caption, skip, pause and route back. Batch 03 adds manifest-driven scenes and uses existing hero walk frames and the Jack atlas. The handoff, copy of party roles, and Jack display are presentation-only.
- `python3 scripts/ci/verify_travel_batch03.py` verifies every byte against the art commit. `scripts/dev/travel_batch03_capture.gd` drives real event buttons for all 72 outcomes and checks rewards, party, saves, skip, pause, reload and transition counts. The graphical CI retains captures at 0.65, 1.15 and 2.50 seconds.

Production approval is pending. Resume review with the exact head and its CI evidence from the integration PR.

## Native preview checkpoint

Windows Godot 4.7.2 / Compatibility passed 72 of 72 real routes in the isolated test checkout, including the remapped well rim and elevated altar exit. The run captured 216 frames. For that local run, five masters use earlier exports of the same compositions and all corresponding PNG overlays match the package. The integration PR uses the exact 97 art blobs and its graphical CI verifies and captures those bytes. The engine emitted the existing root-certificate and shutdown notices.
