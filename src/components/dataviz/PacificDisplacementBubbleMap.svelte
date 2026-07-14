<script>
	import {
		format,
		geoEquirectangular,
		geoGraticule10,
		geoPath,
		scaleSqrt
	} from "d3";
	import { feature } from "topojson-client";
	import world from "world-atlas/countries-50m.json";
	import recurrence from "$data/internal_displacement_country_recurrence.csv";

	const isoByCountry = {
		"Papua New Guinea": "598",
		Fiji: "242",
		"Solomon Islands": "090",
		Vanuatu: "548",
		Tonga: "776",
		Samoa: "882",
		"French Polynesia": "258",
		"New Caledonia": "540",
		"Marshall Islands": "584",
		"Cook Islands": "184",
		"Northern Mariana Islands": "580",
		Guam: "316",
		Palau: "585",
		"American Samoa": "016",
		"Micronesia (Federated States of)": "583",
		Kiribati: "296"
	};

	const fallbackCoordinates = {
		// Tuvalu is too small to appear in Natural Earth's 1:50m country geometry.
		Tuvalu: [179.2, -8.52]
	};

	const countries = feature(world, world.objects.countries).features;
	const countryByIso = new Map(countries.map((d) => [d.id, d]));
	const pacificIso = new Set(Object.values(isoByCountry));
	const pacificLand = countries.filter((d) => pacificIso.has(d.id));
	const number = format(",");
	// A square-root radius makes circle area directly proportional to the number
	// of distinct years affected. Fifteen is the observed maximum in the data.
	const radius = scaleSqrt().domain([0, 15]).range([0, 40]);
	const sizeKey = [
		{ value: 3, x: 20 },
		{ value: 9, x: 116 },
		{ value: 15, x: 226 }
	];
	const width = 1000;
	const height = 590;
	const projection = geoEquirectangular()
		.rotate([-180, 0])
		.center([0, -12])
		.scale(405)
		.translate([width / 2, height / 2]);
	const path = geoPath(projection);
	const graticule = geoGraticule10();

	const rows = recurrence.map((d) => {
		const iso = isoByCountry[d.country];
		const geometry = iso ? countryByIso.get(iso) : null;
		const coordinates = fallbackCoordinates[d.country] ?? null;
		return {
			...d,
			total_internal_displacements: +d.total_internal_displacements,
			reported_displacement_events: +d.reported_displacement_events,
			years_with_displacement: +d.years_with_displacement,
			coordinates: coordinates || null,
			geometry
		};
	});

	// geoPath.centroid uses the same Pacific-centered projection as the basemap,
	// avoiding ambiguous longitude averages for island groups across the dateline.
	const points = rows.map((d) => ({
		...d,
		point: d.geometry ? path.centroid(d.geometry) : projection(d.coordinates)
	}));
	const selectorPoints = [...points].sort((a, b) =>
		a.country.localeCompare(b.country)
	);

	let tooltip = $state(null);
	let selected = $state(null);
	let zoomLevel = $state(1);
	let container;

	function showTooltip(event, datum) {
		const bounds = container.getBoundingClientRect();
		const target = event.currentTarget.getBoundingClientRect();
		const x = Number.isFinite(event.clientX)
			? event.clientX - bounds.left
			: target.left + target.width / 2 - bounds.left;
		const y = Number.isFinite(event.clientY)
			? event.clientY - bounds.top
			: target.top - bounds.top;
		tooltip = {
			datum,
			x: Math.max(130, Math.min(bounds.width - 130, x)),
			y,
			below: y < 190
		};
	}

	function selectBubble(event, datum) {
		if (selected?.country === datum.country) {
			selected = null;
			tooltip = null;
			return;
		}
		selected = datum;
		showTooltip(event, datum);
	}

	function selectCountry(datum) {
		selected = datum;
		const bounds = container.getBoundingClientRect();
		const scale = bounds.width / width;
		const x = datum.point[0] * scale;
		const y = datum.point[1] * scale;
		tooltip = {
			datum,
			x: Math.max(130, Math.min(bounds.width - 130, x)),
			y,
			below: y < 190
		};
	}

	function resetMap() {
		selected = null;
		tooltip = null;
	}

	function changeZoom(amount) {
		zoomLevel = Math.max(1, Math.min(4, zoomLevel + amount));
		selected = null;
		tooltip = null;
	}
</script>

<svelte:window
	onkeydown={(event) => {
		if (event.key === "Escape" && selected) resetMap();
	}}
/>

<figure class="bubble-map">
	<figcaption>
		<h5>
			How many different years has each Pacific country experienced
			displacement?
		</h5>
		<p>
			Bubble area represents the number of distinct years with recorded disaster
			displacement from 2008 to 2025. Choose a country, or hover or tap a
			bubble, for details.
		</p>
	</figcaption>

	<div
		class="country-selector"
		aria-label="Select a Pacific country or territory"
	>
		<strong>Country or territory</strong>
		<button
			class:active={!selected}
			type="button"
			aria-pressed={!selected}
			onclick={resetMap}>All</button
		>
		{#each selectorPoints as datum}
			<button
				class:active={selected?.country === datum.country}
				type="button"
				aria-pressed={selected?.country === datum.country}
				onclick={() => selectCountry(datum)}>{datum.country}</button
			>
		{/each}
	</div>

	<div
		class="map-wrap"
		bind:this={container}
		role="group"
		aria-label="Interactive Pacific displacement bubble map"
		onpointerleave={() => {
			if (!selected) tooltip = null;
		}}
	>
		<div class="map-zoom" aria-label="Map zoom controls">
			<button
				type="button"
				onclick={() => changeZoom(0.5)}
				disabled={zoomLevel >= 4}
				aria-label="Zoom in map"
				title="Zoom in">+</button
			>
			<button
				type="button"
				onclick={() => changeZoom(-0.5)}
				disabled={zoomLevel <= 1}
				aria-label="Zoom out map"
				title="Zoom out">−</button
			>
		</div>
		<!-- svelte-ignore a11y_click_events_have_key_events (All and Escape provide keyboard-equivalent reset controls.) -->
		<!-- svelte-ignore a11y_no_noninteractive_element_interactions (Map click is an optional pointer shortcut for the All control.) -->
		<svg
			viewBox={`0 0 ${width} ${height}`}
			role="img"
			aria-labelledby="pacific-map-title pacific-map-desc"
			onclick={resetMap}
		>
			<title id="pacific-map-title"
				>Reported disaster displacement events across Pacific Island countries
				and territories</title
			>
			<desc id="pacific-map-desc"
				>A bubble map of 17 Pacific Island countries and territories. Papua New
				Guinea has the most years affected with 15, followed by Fiji with 14 and
				Solomon Islands with 13.</desc
			>
			<rect class="ocean" {width} {height}></rect>
			<g
				class="zoom-layer"
				transform={`translate(${width / 2} ${height / 2}) scale(${zoomLevel}) translate(${-width / 2} ${-height / 2})`}
			>
				<path class="graticule" d={path(graticule)}></path>
				<g class="world-land">
					{#each countries as country}
						<path d={path(country)}></path>
					{/each}
				</g>
				<g class="pacific-land">
					{#each pacificLand as country}
						<path d={path(country)}></path>
					{/each}
				</g>

				{#each points as datum}
					<circle
						class:selected={selected?.country === datum.country}
						class:dimmed={selected && selected.country !== datum.country}
						cx={datum.point[0]}
						cy={datum.point[1]}
						r={radius(datum.years_with_displacement)}
						tabindex="0"
						role="button"
						aria-label={`${datum.country}: displacement recorded in ${datum.years_with_displacement} distinct years, ${datum.reported_displacement_events} reported events, ${number(datum.total_internal_displacements)} internal displacements`}
						onpointerenter={(event) => showTooltip(event, datum)}
						onpointermove={(event) => showTooltip(event, datum)}
						onfocus={(event) => showTooltip(event, datum)}
						onblur={() => {
							if (!selected) tooltip = null;
						}}
						onclick={(event) => {
							event.stopPropagation();
							selectBubble(event, datum);
						}}
						onkeydown={(event) => {
							if (event.key === "Enter" || event.key === " ") {
								event.preventDefault();
								selectBubble(event, datum);
							}
							if (event.key === "Escape") {
								selected = null;
								tooltip = null;
							}
						}}
					></circle>
				{/each}
			</g>
			<g class="size-key" transform="translate(38,447)" aria-hidden="true">
				<text x="0" y="-15">Bubble area = distinct years affected</text>
				{#each sizeKey as item}
					<circle cx={item.x} cy="42" r={radius(item.value)}></circle>
					<text class="key-value" x={item.x} y="100" text-anchor="middle"
						>{item.value}</text
					>
				{/each}
			</g>
		</svg>

		{#if tooltip}
			<div
				class:below={tooltip.below}
				class="tooltip"
				style={`left:${tooltip.x}px;top:${tooltip.y}px`}
				role="group"
				aria-label={`${tooltip.datum.country} displacement details`}
			>
				<div class="tooltip-header">
					<strong>{tooltip.datum.country}</strong>
					<button
						type="button"
						onclick={resetMap}
						aria-label="Close displacement details">×</button
					>
				</div>
				<dl>
					<div>
						<dt>Distinct years affected</dt>
						<dd>{number(tooltip.datum.years_with_displacement)}</dd>
					</div>
					<div>
						<dt>Reported events</dt>
						<dd>{number(tooltip.datum.reported_displacement_events)}</dd>
					</div>
					<div>
						<dt>Internal displacements</dt>
						<dd>{number(tooltip.datum.total_internal_displacements)}</dd>
					</div>
					<div>
						<dt>Recorded period</dt>
						<dd>{tooltip.datum.first_year}–{tooltip.datum.latest_year}</dd>
					</div>
				</dl>
			</div>
		{/if}
	</div>

	<p class="note">
		Each calendar year is counted once, even when multiple displacement events
		were reported during that year. Bubbles mark countries and territories, not
		individual event locations. “Internal displacements” counts movements rather
		than unique people.
	</p>
	<p class="source">
		Source: <a
			href="https://www.internal-displacement.org/database/displacement-data/"
			target="_blank"
			rel="noreferrer">Internal Displacement Monitoring Centre (IDMC)</a
		>. Basemap:
		<a
			href="https://www.naturalearthdata.com/downloads/50m-cultural-vectors/50m-admin-0-countries-2/"
			target="_blank"
			rel="noreferrer">Natural Earth</a
		>.
	</p>
</figure>

<style>
	.bubble-map {
		width: min(100%, 1080px);
		margin: clamp(64px, 8vw, 104px) auto clamp(42px, 5vw, 68px);
		font-family: "Inter", sans-serif;
	}
	figcaption {
		max-width: 900px;
	}
	h5 {
		margin: 0;
		font:
			700 clamp(18px, 2vw, 24px)/1.2 "Inter",
			sans-serif;
		letter-spacing: -0.02em;
	}
	figcaption p {
		margin: 8px 0 22px;
		color: #444;
		font:
			400 clamp(15px, 1.6vw, 19px)/1.45 "Inter",
			sans-serif;
	}
	.country-selector {
		display: flex;
		flex-wrap: wrap;
		align-items: center;
		gap: 7px 8px;
		margin: 0 0 24px;
	}
	.country-selector strong {
		margin-right: 4px;
		font:
			700 13px/1 "Inter",
			sans-serif;
		text-transform: uppercase;
		letter-spacing: 0.06em;
	}
	.country-selector button {
		display: inline-flex;
		align-items: center;
		gap: 6px;
		min-height: 32px;
		padding: 5px 8px;
		border: 1px solid #ccc;
		border-radius: 3px;
		color: #555;
		background: #fff;
		font:
			500 13px/1.2 "Inter",
			sans-serif;
		cursor: pointer;
	}
	.country-selector button.active {
		color: #111;
		border-color: #111;
	}
	.country-selector button:focus-visible {
		outline: 2px solid #135ae1;
		outline-offset: 2px;
	}
	.map-wrap {
		position: relative;
		width: 100%;
	}
	.zoom-layer {
		transition: transform 180ms ease;
	}
	.map-zoom {
		position: absolute;
		top: 14px;
		right: 14px;
		z-index: 5;
		display: flex;
	}
	.map-zoom button {
		display: grid;
		width: 38px;
		height: 38px;
		place-items: center;
		padding: 0;
		border: 1px solid #000;
		border-radius: 0;
		color: #000;
		background: #fff;
		font:
			600 22px/1 "Inter",
			sans-serif;
		cursor: pointer;
	}
	.map-zoom button + button {
		border-left: 0;
	}
	.map-zoom button:hover:not(:disabled) {
		color: #fff;
		background: #000;
	}
	.map-zoom button:focus-visible {
		z-index: 1;
		outline: 3px solid #2197ff;
		outline-offset: 2px;
	}
	.map-zoom button:disabled {
		color: #757575;
		cursor: not-allowed;
	}
	svg {
		display: block;
		width: 100%;
		height: auto;
		overflow: hidden;
	}
	.ocean {
		fill: #2197ff;
		fill-opacity: 0.12;
	}
	.graticule {
		fill: none;
		stroke: #2197ff;
		stroke-opacity: 0.13;
		stroke-width: 0.8;
	}
	.world-land path {
		fill: #a7abaf;
		fill-opacity: 0.24;
		stroke: #808080;
		stroke-opacity: 0.28;
		stroke-width: 0.55;
		vector-effect: non-scaling-stroke;
	}
	.pacific-land path {
		fill: #a7abaf;
		fill-opacity: 0.58;
		stroke: #808080;
		stroke-opacity: 0.52;
		stroke-width: 0.7;
		vector-effect: non-scaling-stroke;
	}
	circle[role="button"] {
		fill: #135ae1;
		fill-opacity: 0.82;
		cursor: pointer;
		stroke: #135ae1;
		stroke-width: 1.5;
		transition:
			opacity 150ms ease,
			stroke-width 100ms ease,
			fill-opacity 100ms ease;
	}
	circle[role="button"]:hover,
	circle[role="button"]:focus,
	.selected {
		outline: none;
		stroke: #135ae1;
		stroke-width: 4;
	}
	circle[role="button"]:hover,
	circle[role="button"]:focus,
	.selected {
		fill-opacity: 1;
	}
	circle.dimmed {
		opacity: 0.3;
	}
	.size-key text {
		fill: #444;
		font:
			600 13px/1 "Inter",
			sans-serif;
	}
	.size-key circle {
		fill: none;
		stroke: #135ae1;
		stroke-width: 1.2;
		filter: none;
	}
	.size-key .key-value {
		fill: #555;
		font-weight: 500;
	}
	.tooltip {
		position: absolute;
		z-index: 4;
		width: min(280px, calc(100vw - 32px));
		padding: 0 14px 14px;
		transform: translate(-50%, calc(-100% - 12px));
		border: 1px solid rgba(0, 0, 0, 0.14);
		background: rgba(255, 255, 255, 0.98);
		box-shadow: 0 12px 32px rgba(0, 0, 0, 0.18);
		font:
			400 12px/1.4 "Inter",
			sans-serif;
	}
	.tooltip.below {
		transform: translate(-50%, 12px);
	}
	.tooltip-header {
		display: flex;
		align-items: center;
		justify-content: space-between;
		gap: 12px;
		margin: 0 -14px 12px;
		padding: 7px 8px 7px 14px;
		border-top: 5px solid #135ae1;
		background: #222;
		color: #fff;
	}
	.tooltip-header strong {
		font-size: 14px;
	}
	.tooltip-header button {
		display: grid;
		width: 30px;
		height: 30px;
		flex: 0 0 auto;
		place-items: center;
		padding: 0;
		border: 0;
		border-radius: 2px;
		color: #fff;
		background: transparent;
		font:
			400 23px/1 "Inter",
			sans-serif;
		cursor: pointer;
	}
	.tooltip-header button:hover {
		background: rgba(255, 255, 255, 0.15);
	}
	.tooltip-header button:focus-visible {
		outline: 2px solid #fff;
		outline-offset: 1px;
	}
	dl {
		display: grid;
		gap: 7px;
		margin: 0;
	}
	dl div {
		display: grid;
		grid-template-columns: 1fr auto;
		gap: 12px;
	}
	dt {
		font-weight: 600;
	}
	dd {
		margin: 0;
		font-variant-numeric: tabular-nums;
	}
	.note,
	.source {
		max-width: 820px;
		margin: 12px 0 0;
		color: #666;
		font:
			400 12px/1.5 "Inter",
			sans-serif;
	}
	.source {
		margin-top: 5px;
	}
	.source a {
		color: #057dbc;
		text-underline-offset: 3px;
	}
	@media (max-width: 700px) {
		.bubble-map {
			width: calc(100% + 40px);
			margin-left: -20px;
		}
		figcaption,
		.country-selector,
		.note,
		.source {
			padding-inline: 20px;
		}
		figcaption p {
			margin-bottom: 14px;
		}
		.country-selector {
			gap: 6px;
		}
		.country-selector button {
			font-size: 12px;
		}
		.size-key {
			transform: translate(28px, 447px);
		}
	}
</style>
