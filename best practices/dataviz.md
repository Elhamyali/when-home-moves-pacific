# Data visualization standards

Use these conventions for every data visualization in this project unless a specific visualization requires an explicit exception.

## Typography

- Use Inter for all visualization text, including titles, subtitles, annotations, axes, labels, legends, notes, sources, and tooltips.
- Use a clear, bold Inter title and sentence-case wording.
- Keep individual visualization titles compact at an `h5` scale; chapter and section headings provide the larger hierarchy.
- Keep supporting copy readable and visually subordinate to the title.

## Color

- Use colors from the approved project palette:
  - `#135ae1`
  - `#2197ff`
  - `#9852d9`
  - `#f54e8b`
  - `#fa6502`
  - `#f2b90f`
  - `#058896`
  - `#09aa64`
  - `#de2c35`
  - `#a7abaf`
  - `#808080`
- Reuse a palette color when a visualization needs more categories than the palette provides; do not introduce an unapproved color without a deliberate design reason.
- Render bubbles and other proportional symbols as flat, solid-color marks. Do not use gradients, highlights, drop shadows, or other simulated 3D effects unless depth encodes a meaningful data dimension.
- Keep Pacific-focused maps visually consistent with the Chapter 3 map: use `#2197ff` at 12% opacity for the ocean, `#2197ff` at 13% opacity for the graticule, `#a7abaf` at 24% opacity for background land, `#a7abaf` at 58% opacity for Pacific land, `#808080` for boundaries, and `#135ae1` for bubbles or primary map marks.

## Sources and notes

- Place methodology or interpretation notes directly below the visualization.
- Style image captions consistently with the story's video caption: Inter, 12px, regular weight, `#4a4a4a`, and 1.45 line height.
- Write every image and video caption as one continuous paragraph directly below the media: description first, followed immediately by `Credit: [Publisher].` Do not split the description, credit, or source across separate caption blocks or add a title above an editorial image. Allow the paragraph to wrap naturally only when the viewport requires it.
- Place the source immediately after the note.
- Format sources as `Source: [Publisher]; [Publisher].`
- Use descriptive publisher names as link text.
- Source links are blue (`#057dbc`), underlined, and use a visible underline offset.
- Open external sources in a new tab and include `rel="noreferrer"`.

## Framing and layout

- Do not place a border around a visualization.
- Do not add decorative rules or divider lines immediately before or after a visualization.
- Let spacing, alignment, and typography separate a visualization from the surrounding story.
- Use a smaller bottom margin after a visualization than its top margin so the visualization remains visually connected to the prose that follows.
- Avoid stacking large visualization margins with large chapter padding; chapter transitions should remain distinct without creating nearly empty screens.
- Keep layouts responsive and preserve readable labels on narrow screens.
- Frame Pacific-focused maps with the same Pacific-centered equirectangular projection used in Chapter 3. At a `1000 × 590` reference viewBox, use `rotate([-180, 0])`, `center([0, -12])`, and `scale(405)`, then scale the SVG responsively rather than zooming out to the full world.

## Interaction and accessibility

- Explain non-obvious interaction concisely, such as “Hover or tap a flow to explore.”
- Order categorical legend and selector options alphabetically unless they have a meaningful numeric, temporal, geographic, or process sequence. Keep universal controls such as “All” first.
- Provide a meaningful accessible label for charts.
- Make hover and focus states reinforce the selected data without obscuring context.
- Tooltips should state the category or relationship and its formatted value.
