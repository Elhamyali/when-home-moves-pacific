<script>
	import { onMount } from "svelte";
	import {
		extent,
		format,
		geoEquirectangular,
		geoGraticule10,
		geoPath,
		line,
		max,
		range,
		scaleLinear,
		scaleSqrt,
		sum
	} from "d3";
	import { feature } from "topojson-client";
	import world from "world-atlas/countries-50m.json";
	import populationRows from "$data/affected_population_history_chart_data.csv";
	import pointRows from "$data/pacific_country_points.csv";

	const sourceUrl =
		"https://stats.pacificdata.org/vis?lc=en&df[ds]=ds%3ASPC2&df[id]=DF_SDG_11&df[ag]=SPC&df[vs]=3.0&dq=A.VC_DSR_AFFCT.........&pd=,&to[TIME_PERIOD]=false&lb=bt";
	const numberFormat = format(",d");
	const rows = populationRows.map((row) => ({
		country: row.country,
		year: +row.year,
		value: +row.disaster_affected_population || 0
	}));
	const locations = pointRows
		.map((row) => ({
			country: row.country,
			longitude: +row.longitude,
			latitude: +row.latitude
		}))
		.sort((a, b) => a.country.localeCompare(b.country));
	const [firstYear, lastYear] = extent(rows, (row) => row.year);
	const years = range(firstYear, lastYear + 1);
	const values = new Map(
		rows.map((row) => [`${row.country}|${row.year}`, row.value])
	);
	const frames = years.map((year) => {
		const points = locations.map((location) => {
			const annual = values.get(`${location.country}|${year}`) ?? 0;
			const cumulative = sum(
				years.filter((candidate) => candidate <= year),
				(candidate) => values.get(`${location.country}|${candidate}`) ?? 0
			);
			return { ...location, annual, cumulative };
		});
		return { year, points, total: sum(points, (point) => point.cumulative) };
	});
	const finalTotal = frames.at(-1).total;
	const maxCountryTotal = max(frames.at(-1).points, (point) => point.cumulative);
	const countries = feature(world, world.objects.countries).features;
	const pacificFeatureNames = new Set([
		"American Samoa",
		"Cook Is.",
		"Fiji",
		"Fr. Polynesia",
		"Guam",
		"Kiribati",
		"Marshall Is.",
		"Micronesia",
		"N. Mariana Is.",
		"Nauru",
		"New Caledonia",
		"Niue",
		"Palau",
		"Papua New Guinea",
		"Samoa",
		"Solomon Is.",
		"Tonga",
		"Tuvalu",
		"Vanuatu",
		"Wallis and Futuna Is."
	]);
	const pacificLand = countries.filter((country) =>
		pacificFeatureNames.has(country.properties.name)
	);
	const graticule = geoGraticule10();
	const mapWidth = 1000;
	const mapHeight = 590;
	const projection = geoEquirectangular()
		.rotate([-180, 0])
		.center([0, -12])
		.scale(405)
		.translate([mapWidth / 2, mapHeight / 2]);
	const mapPath = geoPath(projection);
	const radiusScale = scaleSqrt()
		.domain([0, maxCountryTotal])
		.range([0, 58]);
	const timelineWidth = 1000;
	const timelineHeight = 118;
	const timelineX = scaleLinear()
		.domain([firstYear, lastYear])
		.range([48, timelineWidth - 22]);
	const timelineY = scaleLinear()
		.domain([0, finalTotal])
		.range([timelineHeight - 32, 12]);
	const timelineLine = line()
		.x((frame) => timelineX(frame.year))
		.y((frame) => timelineY(frame.total));
	const tickYears = years.filter(
		(year) => year === firstYear || year === lastYear || year % 5 === 0
	);

	let yearIndex = $state(0);
	let playing = $state(false);
	let reduceMotion = $state(false);
	let selectedCountry = $state("");
	let hoveredCountry = $state("");
	let intervalId;

	const currentFrame = $derived(frames[yearIndex]);
	const currentYear = $derived(currentFrame.year);
	const activeCountry = $derived(hoveredCountry || selectedCountry);
	const activePoint = $derived(
		currentFrame.points.find((point) => point.country === activeCountry)
	);
	const progressPath = $derived(
		timelineLine(frames.slice(0, yearIndex + 1))
	);

	onMount(() => {
		reduceMotion = window.matchMedia("(prefers-reduced-motion: reduce)").matches;
		return () => {
			stopAnimation();
		};
	});

	function stopAnimation() {
		if (intervalId) window.clearInterval(intervalId);
		intervalId = undefined;
		playing = false;
	}

	function play() {
		if (reduceMotion) {
			yearIndex = years.length - 1;
			return;
		}
		if (yearIndex === years.length - 1) yearIndex = 0;
		if (intervalId) return;
		playing = true;
		intervalId = window.setInterval(() => {
			if (yearIndex >= years.length - 1) {
				stopAnimation();
				return;
			}
			yearIndex += 1;
		}, 650);
	}

	function togglePlay() {
		if (playing) stopAnimation();
		else play();
	}

	function replay() {
		stopAnimation();
		yearIndex = 0;
		play();
	}

	function setYear(event) {
		stopAnimation();
		yearIndex = +event.currentTarget.value;
	}

	function pointRadius(point) {
		return point.cumulative > 0 ? Math.max(3, radiusScale(point.cumulative)) : 2;
	}
</script>

<figure
	class:reduce-motion={reduceMotion}
	class="growing-map"
	aria-labelledby="affected-map-title affected-map-subtitle"
>
	<header class="viz-heading">
		<h5 id="affected-map-title">How disasters affected the Pacific over time</h5>
		<p id="affected-map-subtitle">
			Press play to watch the cumulative number of people directly affected by
			disasters grow across 21 Pacific countries and territories from {firstYear}
			to {lastYear}.
		</p>
	</header>

	<div class="controls">
		<div class="playback" aria-label="Animation controls">
			<button class="primary" type="button" onclick={togglePlay}>
				<span aria-hidden="true">{playing ? "Ⅱ" : "▶"}</span>
				{playing ? "Pause" : "Play"}
			</button>
			<button type="button" onclick={replay}>
				<span aria-hidden="true">↻</span> Replay
			</button>
		</div>
		<label>
			<span>Explore a country</span>
			<select bind:value={selectedCountry}>
				<option value="">All countries</option>
				{#each locations as location}
					<option value={location.country}>{location.country}</option>
				{/each}
			</select>
		</label>
	</div>

	<div class="map-wrap">
		<div class="map-stat" aria-live="polite">
			<span>{currentYear}</span>
			<strong>{numberFormat(currentFrame.total)}</strong>
			<small>people directly affected, cumulative</small>
		</div>
		{#if activePoint}
			<div class="country-stat">
				<strong>{activePoint.country}</strong>
				<span>{numberFormat(activePoint.cumulative)} cumulative</span>
				<small>{numberFormat(activePoint.annual)} reported in {currentYear}</small>
			</div>
		{/if}

		<svg
			class="map"
			viewBox={`0 0 ${mapWidth} ${mapHeight}`}
			role="img"
			aria-label={`Map showing ${numberFormat(currentFrame.total)} people cumulatively affected by disasters through ${currentYear}`}
		>
			<rect class="ocean" width={mapWidth} height={mapHeight}></rect>
			<path class="graticule" d={mapPath(graticule)}></path>
			<g class="world-land">
				{#each countries as country}
					<path d={mapPath(country)}></path>
				{/each}
			</g>
			<g class="pacific-land">
				{#each pacificLand as country}
					<path d={mapPath(country)}></path>
				{/each}
			</g>

			{#each currentFrame.points as point (point.country)}
				{@const position = projection([point.longitude, point.latitude])}
				<circle
					role="img"
					class:muted={activeCountry && activeCountry !== point.country}
					class:active={activeCountry === point.country}
					class="bubble"
					cx={position[0]}
					cy={position[1]}
					r={pointRadius(point)}
					onpointerenter={() => (hoveredCountry = point.country)}
					onpointerleave={() => (hoveredCountry = "")}
				>
					<title>{point.country}: {numberFormat(point.cumulative)} cumulatively affected through {currentYear}; {numberFormat(point.annual)} reported in {currentYear}</title>
				</circle>
			{/each}
		</svg>
	</div>

	<div class="timeline" aria-label="Cumulative affected population timeline">
		<svg viewBox={`0 0 ${timelineWidth} ${timelineHeight}`} aria-hidden="true">
			<path class="timeline-base" d={timelineLine(frames)}></path>
			<path class="timeline-progress" d={progressPath}></path>
			<line
				class="year-rule"
				x1={timelineX(currentYear)}
				x2={timelineX(currentYear)}
				y1="9"
				y2={timelineHeight - 30}
			></line>
			{#each tickYears as year}
				<line
					class="tick"
					x1={timelineX(year)}
					x2={timelineX(year)}
					y1={timelineHeight - 28}
					y2={timelineHeight - 22}
				></line>
				<text x={timelineX(year)} y={timelineHeight - 7}>{year}</text>
			{/each}
		</svg>
		<label class="scrubber">
			<span class="sr-only">Select year</span>
			<input
				type="range"
				min="0"
				max={years.length - 1}
				value={yearIndex}
				oninput={setYear}
				aria-valuetext={`${currentYear}: ${numberFormat(currentFrame.total)} people cumulatively affected`}
			/>
		</label>
	</div>

	<p class="note">
		Circle area represents the cumulative number of people directly affected by
		disasters. Hover over a circle or use the country menu to explore.
	</p>
	<figcaption class="source">
		Source: <a href={sourceUrl} target="_blank" rel="noreferrer">Pacific Data Hub</a>,
		Number of directly affected persons attributed to disasters. Basemap: <a
			href="https://www.naturalearthdata.com/downloads/50m-cultural-vectors/50m-admin-0-countries-2/"
			target="_blank"
			rel="noreferrer">Natural Earth</a
		>. Location coordinates: <a
			href="https://github.com/nvkelso/natural-earth-vector/blob/master/geojson/ne_10m_admin_0_map_units.geojson"
			target="_blank"
			rel="noreferrer">Natural Earth map units</a
		>.
	</figcaption>
</figure>

<style>
	.growing-map {
		width: min(100%, 1120px);
		margin: clamp(72px, 10vw, 132px) auto clamp(54px, 7vw, 92px);
		font-family: "Inter", sans-serif;
	}

	.viz-heading h5 {
		margin: 0;
		font: 700 clamp(18px, 2vw, 24px)/1.2 "Inter", sans-serif;
		letter-spacing: -0.02em;
	}

	.viz-heading p {
		max-width: 800px;
		margin: 8px 0 0;
		color: #4a4a4a;
		font: 400 clamp(15px, 1.6vw, 19px)/1.5 "Inter", sans-serif;
	}

	.controls {
		display: flex;
		align-items: end;
		justify-content: space-between;
		gap: 18px;
		margin: 28px 0 14px;
	}

	.playback {
		display: flex;
		gap: 8px;
	}

	button,
	select {
		min-height: 42px;
		border: 1px solid #000;
		border-radius: 0;
		font: 600 13px/1 "Inter", sans-serif;
	}

	button {
		display: inline-flex;
		align-items: center;
		justify-content: center;
		gap: 8px;
		padding: 0 17px;
		color: #000;
		background: #fff;
		cursor: pointer;
	}

	button.primary,
	button:hover {
		color: #fff;
		background: #000;
	}

	button:focus-visible,
	select:focus-visible,
	input:focus-visible {
		outline: 3px solid #2197ff;
		outline-offset: 2px;
	}

	.controls label {
		display: grid;
		gap: 7px;
		font: 600 11px/1 "Inter", sans-serif;
		letter-spacing: 0.08em;
		text-transform: uppercase;
	}

	select {
		max-width: 270px;
		padding: 0 34px 0 11px;
		color: #000;
		background: #fff;
		text-transform: none;
		letter-spacing: 0;
	}

	.map-wrap {
		position: relative;
		background: #fff;
		overflow: hidden;
	}

	.map {
		display: block;
		width: 100%;
		height: auto;
	}

	.ocean {
		fill: #2197ff;
		fill-opacity: 0.12;
	}
	.graticule {
		fill: none;
		stroke: #2197ff;
		stroke-width: 0.8;
		stroke-opacity: 0.13;
	}
	.world-land path {
		fill: #a7abaf;
		fill-opacity: 0.24;
		stroke: #808080;
		stroke-width: 0.55;
		stroke-opacity: 0.28;
		vector-effect: non-scaling-stroke;
	}
	.pacific-land path {
		fill: #a7abaf;
		fill-opacity: 0.58;
		stroke: #808080;
		stroke-width: 0.7;
		stroke-opacity: 0.52;
		vector-effect: non-scaling-stroke;
	}

	.bubble {
		fill: #135ae1;
		stroke: #135ae1;
		stroke-width: 1.5;
		fill-opacity: 0.82;
		transition: r 500ms ease, fill-opacity 160ms ease;
	}
	.bubble.muted { fill-opacity: 0.3; }
	.bubble.active {
		fill-opacity: 1;
		stroke-width: 4;
	}
	.reduce-motion .bubble { transition: none; }

	.map-stat,
	.country-stat {
		position: absolute;
		z-index: 2;
		display: grid;
		pointer-events: none;
	}

	.map-stat {
		top: clamp(14px, 2.4vw, 28px);
		left: clamp(14px, 2.4vw, 28px);
		color: #000;
	}

	.map-stat span {
		font: 700 12px/1 "Inter", sans-serif;
		letter-spacing: 0.12em;
	}
	.map-stat strong {
		margin-top: 8px;
		font: 700 clamp(30px, 5vw, 58px)/0.95 "Inter", sans-serif;
		letter-spacing: -0.04em;
		font-variant-numeric: tabular-nums;
	}
	.map-stat small,
	.country-stat small,
	.country-stat span {
		margin-top: 6px;
		font: 500 clamp(10px, 1.25vw, 13px)/1.35 "Inter", sans-serif;
	}

	.country-stat {
		right: clamp(14px, 2.4vw, 28px);
		bottom: clamp(14px, 2.4vw, 28px);
		max-width: 280px;
		padding: 13px 15px;
		color: #000;
		background: #fff;
	}
	.country-stat strong { font: 700 14px/1.2 "Inter", sans-serif; }

	.timeline {
		position: relative;
		margin-top: 10px;
	}
	.timeline svg {
		display: block;
		width: 100%;
		height: auto;
		overflow: visible;
	}
	.timeline-base,
	.timeline-progress {
		fill: none;
		stroke-width: 4;
		stroke-linecap: round;
		stroke-linejoin: round;
	}
	.timeline-base { stroke: #a7abaf; }
	.timeline-progress { stroke: #135ae1; }
	.year-rule {
		stroke: #135ae1;
		stroke-width: 2;
	}
	.tick { stroke: #808080; }
	.timeline text {
		fill: #4a4a4a;
		font: 500 15px/1 "Inter", sans-serif;
		text-anchor: middle;
	}

	.scrubber {
		position: absolute;
		inset: 0;
		display: flex;
		align-items: end;
		padding: 0 2.2% 24px 4.8%;
	}
	.scrubber input {
		width: 100%;
		height: 18px;
		opacity: 0;
		cursor: ew-resize;
	}

	.note,
	.source {
		margin: 12px 0 0;
		color: #4a4a4a;
		font: 400 12px/1.45 "Inter", sans-serif;
	}
	.source { margin-top: 4px; }
	.source a {
		color: #057dbc;
		text-underline-offset: 3px;
	}

	.sr-only {
		position: absolute;
		width: 1px;
		height: 1px;
		padding: 0;
		margin: -1px;
		overflow: hidden;
		clip: rect(0, 0, 0, 0);
		white-space: nowrap;
		border: 0;
	}

	@media (max-width: 650px) {
		.controls {
			align-items: stretch;
			flex-direction: column;
		}
		.playback button { flex: 1; }
		select {
			width: 100%;
			max-width: none;
		}
		.map-stat strong { font-size: clamp(27px, 8vw, 42px); }
		.country-stat {
			right: 10px;
			bottom: 10px;
			max-width: 205px;
		}
		.timeline text { font-size: 19px; }
	}
</style>
