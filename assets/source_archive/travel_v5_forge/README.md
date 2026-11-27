# Curse Forge — Cinematic Travel V5 candidate

New art is a QA-only candidate, not a replacement of any accepted Travel V4/card image.
- ImageGen scene plate: based on the original approved `assets/pixel/travel/batch_02/curse_forge/layers/base_1280.png`; new wide, empty staging with an anvil, three empty display mounts and real walking foreground. Runtime plate resized to 1280×720 WebP.
- `smith_source.webp`: six independently drawn, complete hammer motion poses based on the original half-skeletal smith identity, transparent source at 1536×1024. Player-requested HD runtime sheet `smith_atlas_hd.webp` preserves the native source pixels losslessly in six 576×576 cells (444-px standing body, sole y=534, stable foot midpoint). Linear filtering renders only the smith at the same world size; source poses are not upscaled or redrawn. The original 96×96 cels (74-px body, sole y=89) remain as rollback art.
- The exact candidate background supplies the foreground anvil occluder; original hot sword pixels are extracted from the approved plate; all three original transparent release props and D412 hero atlases remain unchanged.
- Authoring source is outside runtime import through .gdignore; the accepted V4 files are untouched and are the live fallback.
