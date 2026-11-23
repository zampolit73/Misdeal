# Event Choice Visual V2 · native gallery

| Scene | Evidence |
| --- | --- |
| «Кости должника», four live options | [Approved reference](approved_reference.webp) · [Godot 1280×720](debtor_bones.webp) |
| «Знамя на бинты», two options | [Godot 1280×720, QA fixture](banner_seamstress_two_qa.webp) |
| «Шепчущий колодец», three live options and 24 gold | [Godot 1280×720](whispering_well.webp) · [Godot 960×540](whispering_well_960.webp) |
| «Шепчущий колодец», paid rescue | [Godot confirmation](whispering_well_paid.webp) |
| «Кровавая книга», long upgrade text | [Godot expanded parchment](blood_ledger_long.webp) |

The two-option capture uses the live «Знамя на бинты» scene with the third option hidden in the QA fixture. Production keeps all of its original choices.

Godot 4.7.2 rendered the cards at both sizes. Five targeted GUT tests covered all 24 event IDs in solo and trio fixtures, frame geometry, text fit, disabled focus, live prices, and one-time resolution. In the native Well, Right and Enter selected the paid rescue at 25 gold. Repeated Enter spent the price once, the mage joined, and the actual Travel scene led back to the Table.

## Frame source

Built-in ImageGen created the empty frame from the supplied reference. Its export was trimmed and resampled to the approved bands. Only the single card skin enters the runtime asset directory.

<details>
<summary>ImageGen prompt</summary>

> Create a single isolated reusable GAME UI FRAME PNG asset, based on the four IDENTICAL decorative card frames in the reference screenshot. Reproduce the reference framing with as high fidelity as possible, as if the focused fourth card were exported as a blank UI template with the foreground text and art layers turned off. The result is one complete tall orthographic FRONTAL card, aspect ratio of the card itself 340:592, centered tightly on an actually transparent background, full corners and central upper/lower points visible. Keep the exact model of the antique gilt bronze outer frame: clipped straight diagonal corners, thin polished beveled golden outlines, engraved blackened metal inner face, restrained warm highlights, subtle dark red inset cloth, gothic sharp curved decorative tracery on all four corners of the illustration window. Strong dimensional engraved dark gothic metal, never simple outline/vector or modern card. Preserve the original central small pointed fleur at the very top, which slightly protrudes, and prominent centered gothic quatrefoil medal set with a tiny red cabochon at the bottom, with matching mirrored ornament extending along the narrow burgundy footer. The separate key bands from top to bottom as a percentage of the total card height: 0–5% top crest and architecture, 5–14% dark burgundy leather empty heading cartouche, 14–48% precisely rectangular illustration aperture with refined carved overlapping gothic corners, 48–59% separate light warm beige parchment title cartouche in dark bronze, 59–89% large blank lightly worn warm beige parchment description panel with ornate corners and very generous space, 89–100% burgundy footer with quatrefoil emblem. The aperture is blank and uniform solid matte black or transparent for compositing. Preserve the copper-bronze brightness, almost black recesses, thin controlled burnished highlights, red cloth insets, full artwork fidelity and quiet parchment grain of the reference. Both parchment panels blank, original useable parchment tone with subtle texture completely legible behind future black typography. Do not add any letters, names, numerals, words, glyphs resembling text, numbers, scribbles, pricing, dummy content, game illustrations, hands, dice, skulls, scene background, extra cards, pictorial symbols at the center of the aperture, tilted geometry, shadows outside the card, or other objects. Only ONE standalone frame/front asset. Background outside the card is transparent.

</details>
