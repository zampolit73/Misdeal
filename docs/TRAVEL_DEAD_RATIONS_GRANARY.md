# Cinematic Travel Scene05 — The Granary of Dead Rations

`false_weights` alone maps to `resources/travel/dead_rations_granary.tres`. Existing Travel V2 owns the four-second clock, CanvasGroup fade, pause/skip, roles, finish guard, disabled/loading fallback and Table return. No new autoload, save state, event resolver or repeated reward. Approved Scene02–04 production files and D412 atlases unchanged.

## Source and planes

Exact user ZIP1672×941 RGB PNG saved byte-for-byte under `assets/pixel/travel/dead_rations_granary/approved_reference.png`; SHA256 `53322f3f1608f3988d91e48f9253c79dc97e70287234f1611d7fc9b87a545b91`. Full task retained in [requests](requests/2026-11-12-scene05-granary.md). Small built-in image_gen outcome crops are retained for the grain store, spilled grain, ledger leaf, bribe and incidental-coin cleanup, feathered inside strict source-local masks. Original quartermaster, bone hands, rock, straw queue, heraldry and hall remain original pixels. Provenance/hashes/prompt and source masks live beside the assets.

Five V2 plane nodes: Sky contract reserve, unified Midground/hall, Road/aisle, Storage reaction, Foreground. Connected architecture/desk/figures/banners/grille frame and nearer original props move together at1.4px/s; an interior floor mask feathers26 source px over intact backing and drifts2.8px/s. No independent column/banner strips or holes; finite1344×757 overscan at(−32,−18). Sparse cold-beam dust and restrained lamp brightness follow local time; no sound or living straw figures.

## Aftermaths

- `fair`: visibly open stock bay with a torn grain sack, spilled grain trail around the desk onto the floor and an unfolded accounting leaf over the ledger. Existing−12gold/+16HP/ration clue applied by event only.
- `silence`: a readable dull-gold bribe pile sits partly under the ledger; grille stays closed and the rock/straw queue remain unchanged. Existing+18gold/−6HP applied by event only.
- `passed`: closed stock bay without a bribe; tiny chain/pan and rock settling motion, lamp/dust. Hands and face never deform.

Original incidental coins near the scoop are locally cleared in every state so they cannot imply a bribe in passed. Desk state props now draw after the original foreground plate (which previously hid the coins); grain trail shares the floor displacement, with no structural cutouts. [Three same-time native state frames](qa/granary/outcomes/README.md), existing Scene05 GUT2/2,102 assertions.

Existing three narration strings remain byte-identical in catalog. No new notices, clue UI, font changes or market scene.

## Hall perspective

Scene05-only curve starts(1030,635), control offset(15,−75), end(1140,380), incoming offset(−25,55). Rear NE presentation frames/sole data reuse the accepted Scene04 pack without modifying it. Initial baseline3.6 is calibrated against straw-man height, adjacent supplies and aisle width; scale follows actual sole height above hall horizon285. Longitudinal spacing48 and asymmetric lanes−130/+90 keep bodies readable on the right aisle. Reciprocal-depth advance0.55 covers a short plausible section over four seconds, not all the distant arches. Contact shadows/step dust, spacing and opaque depth haze follow feet; nearest filtering, no blur. Foreground supplies occlude as actual art, not a new compositional element.

## Rebuild, F6 and validation

```text
godot --headless --path . --script res://scripts/dev/pack_granary_assets.gd
```

F6 `scenes/dev/dead_rations_granary_playtest.tscn`. Q=fair,W=silence,E=passed;1=Knight,2=Ranger+Mage,3=trio;P=pause,R=replay;normal skip. Production F5: resolve «Неверные гири», continue from result to Scene05 and Table.

Native all three full outcome passes and solo, pause/skip and actual Event→Scene05→Table pass; no repeated effects. [Five real frames and limits](qa/granary/README.md). Existing travel24/24,1,003 assertions; full GUT292/292,72,455 assertions (19 existing warnings); selector18/18. The compact smoke joins existing RELEASE CI; final-head CI is authoritative. Baseline combined-route shutdown diagnostics retained/documented. No new QA framework or broad matrix. **Source approval is not runtime artistic acceptance; leave PR open for user video/F6 review.**
