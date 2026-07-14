# Data Visualization & Editorial Style Guide

This document defines the visual, typographic, and interaction standards I used throughout this story. Its goal is to create a consistent editorial style of a magazine-inspired layout with accessible data visualization practices.

---

## 1. Typography

Type defines my story's identity and visual hierarchy. I use Playfair Display for narrative content and Inter for interface elements, like navigation, and visualizations.

### Story Type Scale

- **Story title:** Use **Playfair Display** at `clamp(58px, 8vw, 120px)` with a `0.9` line height. The title should feel bold and editorial without overwhelming the page at 100% browser zoom.
- **Chapter titles:** Use **Playfair Display** at `clamp(46px, 6.5vw, 92px)` with a `0.95` line height. Chapter titles should support—not compete with—the main story title.
- **Story subtitle:** Use **Inter** at `clamp(20px, 2.1vw, 30px)` with a `1.3` line height.
- **Body text:** Use **Inter** at `clamp(18px, 1.5vw, 21px)` with a `1.62` line height. (Opening paragraphs use the regular body style; do not apply a separate lead treatment).
- **Navigation & interface text:** Use **Inter** for all navigation, interface controls, and supporting UI.
- **Typography review:** Always review typography at 100% browser zoom on a desktop viewport/display. Don't reduce visualization text to accommodate larger editorial headings.

### Data Visualization Typography

- **Font choice:** Use **Inter** for all text within a data visualization, including titles, subtitles, annotations, axes, labels, legends, notes, sources, and tooltips.
- **Visualization titles:** Every visualization should have a visible title unless there's a specific reason not to. Keep titles consistent at a compact **h5 scale**:
  - **Style:** `700` weight, `clamp(18px, 2vw, 24px)` font size, `1.2` line height.
  - **Letter spacing:** `-0.02em`.
  - **Case:** Sentence-case.
  - _Note: Don't enlarge individual chart titles beyond this h5 scale; chapter and section headings establish the broader page hierarchy._
- **Visualization subtitles:** Always place the subtitle exactly **8px** below the title. Keep supporting text concise and visually subordinate to the title.

### Captions, Notes, and Sources

- **Caption styling:** Image and video captions must be styled consistently using **Inter**, `12px`, regular weight, `#4a4a4a`, and a `1.45` line height.
- **Caption layout:** Write captions as a single, continuous paragraph directly below the media, formatted as: `[Description] Credit: [Publisher]`. Don't split description and credit into separate blocks, or add an extra title above editorial images.
- **Placement:** Place methodology, interpretation notes, and sources directly below the visualization.
- **Source formatting:** Format sources as `Source: [Publisher]; [Publisher]` following any notes.
  - Use descriptive publisher names as the link text.
  - Source links must be blue (`#057dbc`), underlined, and feature a visible underline offset.
  - All external sources must open in a new tab and include `rel="noreferrer"`.

---

## 2. Color Palette

This story has a print-inspired dual-mode of black and white. The data visualizations have a curated, colorful palette to encode meaning and categorize data.

### Editorial & UI Shell Colors

The general site structure uses a strict black-and-white duet with no atmospheric gradients or decorative accents:

- **Primary accent/ink black (`#000000`):** Used for wordmarks, headlines, primary CTAs, and footer fills. Pure black, never softened.
- **Canvas (`#ffffff`):** The default page background.
- **Canvas soft (`#f5f5f5`):** A rare light grey tint reserved for comment backgrounds and search-result hover states.
- **Hairline grey (`#e0e0e0`):** Used for 1px dividers between story rows.
- **Ink soft (`#1a1a1a`):** Near-black variant for caption-strong and footer link emphasis.
- **Body grey (`#757575`):** Secondary metadata, bylines, and timestamps.

### Data Visualization Palette

Use the below color palette for the visualizations. If a chart requires more categories than the 11 palette colors, reuse existing colors instead of introducing unapproved colors.

- **Primary Data Blue:** `#135ae1`
- **Supporting Blue:** `#2197ff`
- **Purple:** `#9852d9`
- **Magenta:** `#f54e8b`
- **Orange:** `#fa6502`
- **Yellow:** `#f2b90f`
- **Teal:** `#058896`
- **Green:** `#09aa64`
- **Red:** `#de2c35`
- **Light Grey:** `#a7abaf`
- **Dark Grey:** `#808080`

### Pacific-Focused Map Colors

For cartographic standards, all Pacific-focused maps must use the following color variables and opacities:

- **Ocean:** `#2197ff` at `12%` opacity
- **Graticule (grid lines):** `#2197ff` at `13%` opacity
- **Background land:** `#a7abaf` at `24%` opacity
- **Pacific land:** `#a7abaf` at `58%` opacity
- **Boundaries:** `#808080`
- **Bubbles / primary map marks:** `#135ae1`

---

## 3. Framing, Layout & Visual Marks

Strong visualizations don't need decorative boxes or drop shadows. Instead, use negative space, layout grids, and flat visual geometry to create structure and guide the reader's eye.

### Visual Marks & 3D Effects

Keep visual marks simple and flat.

- **Flat elements:** Render bubbles, proportional symbols, and other marks as flat, solid-color elements.
- **No simulated 3D:** Don't use gradients, highlights, drop shadows, or other simulated 3D effects unless depth specifically encodes a meaningful dimension of the data.

### Framing & Separation

Let spacing—not borders—define the relationship between graphics and the surrounding story.

- **No borders:** Don't place borders around visualizations.
- **No decorative dividers:** Don't add horizontal rules or divider lines immediately before or after a visualization. This overrides the site's default site-wide 1px hairline divider standard for editorial rows.
- **Use whitespace instead:** Separate visualizations from surrounding content with spacing, alignment, and typography.
- **Keep charts connected to the narrative:** Always use a smaller bottom margin after a visualization than its top margin. This helps the visualization remains connected to the prose that explains it.
- **Avoid oversized gaps in chapter transitions:** Avoid stacking large visualization margins with large chapter padding. On desktop, this can create empty screens between sections.

### Map Projections

All Pacific-focused maps should use a Pacific-centered equirectangular projection to maintain a consistent geographic perspective across the story.

- **Reference viewBox:** `1000 × 590`.
- **Projection settings:** `rotate([-180, 0])`, `center([0, -12])`, and `scale(405)`.
- **Responsiveness:** Scale the SVG responsively to fit the viewport container. Don't zoom out to reveal the full world map.

---

## 4. Interaction & Accessibility

Interactive charts should feel intuitive, accessible, and easy to explore. Every interaction should help readers understand the data without making them lose context.

### Clarifying Interactions

- **Helper copy:** Never assume readers know how a visualization works. Include a short instruction near any interaction that isn't immediately obvious (for example, _"Hover or tap a flow to explore."_) placed near the visualization.

### Legends & Selectors

Organize controls so readers can find what they're looking for quickly.

- **Ordering:** Alphabetize categorical legend items and selector options whenever possible.
- **Exceptions:** If the categories have a meaningful numeric, temporal, geographic, or process sequence, order them to match that logical sequence.
- **Global controls:** Always place universal controls (such as _"All"_) first in the sequence before specific categories.

### Hover, Focus & Tooltips

Interactions should emphasize information without hiding the rest of the visualization.

- **Context preservation:** Hover and focus states must reinforce the selected data point without obscuring or hiding its surrounding context.
- **Tooltip content:** Tooltips must state the selected category or relationship along with its formatted value.
- **Close controls:** Any tooltip, popover, or detail card or panel that can remain open after a click, tap, or keyboard selection must:
  1. Include a visible close button with a descriptive accessible label.
  2. Close immediately when the user presses the `Escape` key.
     _Note: Transient, hover-only tooltips that disappear when the mouse leaves are exempt from this close-button rule._
- **Chart labels:** Every chart must be provided with a meaningful, descriptive accessible label to ensure compatibility with screen readers.

---

## 5. UI Elements & Core Shapes

When styling interactive elements around visualizations (like controls, filters, or buttons), adhere to these rigid geometric guidelines from the story's editorial system:

- **Corners:** Square corners (`rounded: none` / `0px`) for all buttons, inputs, form controls, and cards. The story doesn't move from its rectangular geometry. The only exceptions are circular crops for sharing icons and author avatars (`rounded: full` / `9999px`).
- **Primary buttons:** Solid black background (`#000000`), white text, bold Inter label, 0px border radius.
- **Outline Buttons:** White background, black text, 1px solid black (`#000000`) border, 0px border radius.
- **Form Inputs:** White background, black text, 1px solid black (`#000000`) border, 0px border radius.
- **Shadows:** Don't use drop shadows on cards, inputs, or buttons. Visual hierarchy must be established through surface contrast and hairline borders.

---

## 6. Checklist: Do's and Don'ts

### Do

- **DO** use **Inter** for all text within a visualization (titles, axes, labels, legends, tooltips).
- **DO** keep visualization titles at the compact h5 scale with `-0.02em` letter spacing.
- **DO** draw visualization colors strictly from the 11 approved story palette colors.
- **DO** render visual marks as flat, solid-color shapes.
- **DO** keep Pacific-focused maps anchored to a Pacific-centered equirectangular projection at `rotate([-180, 0])`, `center([0, -12])`, and `scale(405)`.
- **DO** place close buttons and support `Escape` key dismissal on any detail card or popover that can remain open after a user click or tap.
- **DO** keep all interactive buttons, text inputs, and controls completely square (`0px` border radius).

### Don't

- **DON'T** place borders, rules, or decorative divider lines directly around, before, or after a visualization.
- **DON'T** use gradients, drop shadows, highlights, or simulated 3D effects on data marks unless depth encodes a meaningful dimension.
- **DON'T** introduce any unapproved brand colors to a visualization; reuse the existing palette when more categories are needed.
- **DON'T** stack large visualization margins with large chapter padding.
- **DON'T** use drop shadows for UI elevation; use surface contrast or `1px` hairlines instead.
