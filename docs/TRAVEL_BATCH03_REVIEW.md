# Cinematic Travel Batch 03 · production and QA

Released in `main` at `084c09a` through [PR #119](https://github.com/zampolit73/Misdeal/pull/119). Art package [PR #118](https://github.com/zampolit73/Misdeal/pull/118), frozen source `6ab57186f12b6550be1fa568ab004162efdb5af7`. The production build uses 10 locations, 72 outcomes and 98 runtime plates derived from that package. The large reference sheets, gallery and production sources remain in the art package.

## Review in Godot 4.7.2

Open `scenes/dev/qa_hub.tscn` with F6. Under Travel select **Batch 03 — 72 исхода** or search by the individual location name. Left and right change the outcome, 1/2/3 select a valid party configuration, P pauses and R replays. The launcher displays the resulting party and action. Some outcomes constrain the available party, such as Jack requiring Ranger and recruitment requiring the joining role.

F5 on `main` uses the live Event → Travel → Table path for all ten cards. Verify one rescue (the waiting actor disappears as the active hero joins), Jack (one companion behind Ranger), the Well (coin, gift, or departure), and a Faceless Card outcome. Esc skips the scene.

## Runtime and QA contract

- Events hand the exact committed action to the existing Travel catalog. The normal resolvers remain the authority for prices, artifacts, upgrades, RNG and party recruitment. The Well retains its existing delay and uses the same SceneRouter as the other events.
- Travel V2 owns the clock, caption, skip, pause and route back. Batch 03 adds manifest-driven scenes and uses existing hero walk frames and the Jack atlas. The handoff and copy of party roles are presentation-only. `RunState.has_jack_companion()` gates the recruited walk, dossier card and independent battle plan.
- `python3 scripts/ci/verify_travel_batch03.py` verifies all 98 assets against the frozen artwork and the recorded scale corrections. `scripts/dev/travel_batch03_capture.gd` drives real event buttons for all 72 outcomes and checks rewards, party, saves, skip, pause, reload and transition counts. The graphical CI retains captures at 0.65, 1.15 and 2.50 seconds.

The release tree matches the tested review revision `3558db1`. [RELEASE CI](https://github.com/zampolit73/Misdeal/actions/runs/44551061968) passed the native route and integrity checks for all 72 outcomes and 98 assets. [216 frames on final artwork and route log](https://github.com/zampolit73/Misdeal/actions/runs/44551061968/artifacts/14544286966).

## Scale review

Adult Travel sprites use the scene-specific ground and architecture reference below. The listed height is the adult silhouette at the entry ground plane in a 1280×720 frame. The route's perspective reduces stature with depth.

| Scene | Entry height | Visual reference |
| --- | ---: | --- |
| Black Altar | 232 px | Altar top and landing |
| Chained Prisoner | 224 px | Cell threshold and crouching prisoner |
| Jack | 226 px | Shelter beam and Ranger |
| Whispering Well | 228 px | Well rim and adjacent landing |
| Last Camp | 220 px | Lean-to and low bench |
| Ash Rest | 216 px | Seated Ranger and fire-ring stones |
| Bone Tax | 234 px | Toll counter and skeleton guard |
| Faceless Card | 246 px | Table rim and the floor under it |
| Moon Seal | 234 px | Bowl stand and side table |
| Echo Crypt | 238 px | Sarcophagus lid and doorway |

Jack's walk atlas is staged at 45% of adult height at the same depth. After the recruited handoff he closes the distance to Ranger, then follows on the near edge of the path. His resting or bandaged plate occupies a 114×64 placement on the shelter floor. The Well handoff uses the height implied by its landing while the front rim conceals the lower body. The scale review also resized seated or fallen NPCs, tabletop cards, the seal and crypt props. The resized art is composited from the original transparent cutouts. All ten master backgrounds and combat atlases retain their original hashes.

The frozen runtime art hashes remain under `sha256` and revisions are recorded under `scale_review_sha256` in `provenance.json`. The baseline review revision is [574e117](https://github.com/zampolit73/Misdeal/commit/574e11767feddc0a767375cf347d1bcfc0b42084).

## Initial native preview checkpoint

Windows Godot 4.7.2 / Compatibility passed 72 of 72 real routes in the isolated test checkout, including the remapped well rim and elevated altar exit. The run captured 216 frames. For that local run, five masters use earlier exports of the same compositions and all corresponding PNG overlays match the package. The initial integration revision used the exact 97 art blobs and its graphical CI verified those bytes. The engine emitted the existing root-certificate and shutdown notices.
