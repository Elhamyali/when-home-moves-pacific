<script>
	import { format, line, max, scaleLinear } from "d3";
	import rows from "$data/tb_incidence_history.csv";

	const width = 960;
	const height = 540;
	const margin = { top: 24, right: 30, bottom: 62, left: 78 };
	const colors = [
		"#135ae1",
		"#fa6502",
		"#058896",
		"#9852d9",
		"#f54e8b",
		"#09aa64",
		"#f2b90f",
		"#2197ff",
		"#de2c35",
		"#808080",
		"#a7abaf"
	];
	const sourceUrl =
		"https://stats.pacificdata.org/vis?lc=en&df[ds]=ds%3ASPC2&df[id]=DF_SDG_03&df[ag]=SPC&df[vs]=3.0&dq=A.SH_TBS_INCD.........&pd=,&to[TIME_PERIOD]=false";
	const globalIncidence = 131;
	const globalSourceUrl = "https://data.worldbank.org/indicator/SH.TBS.INCD";
	const valueFormat = format(",.3~g");
	const data = rows.map((row) => ({
		country: row.country,
		code: row.country_code,
		year: +row.year,
		value: +row.tb_incidence_per_100k
	}));
	const countries = [...new Set(data.map((row) => row.country))].sort((a, b) =>
		a.localeCompare(b)
	);
	const colorByCountry = new Map(
		countries.map((country, index) => [country, colors[index % colors.length]])
	);
	const seriesByCountry = new Map(
		countries.map((country) => [
			country,
			data
				.filter((row) => row.country === country)
				.sort((a, b) => a.year - b.year)
		])
	);
	const years = [...new Set(data.map((row) => row.year))].sort((a, b) => a - b);
	const xTicks = [2000, 2004, 2008, 2012, 2016, 2020, 2023];
	const x = scaleLinear()
		.domain([years[0], years.at(-1)])
		.range([margin.left, width - margin.right]);

	let selectedCountries = $state(["Marshall Islands", "Kiribati", "Tuvalu"]);
	let query = $state("");
	let searchOpen = $state(false);
	let active = $state(null);
	let chart;

	const matchingCountries = $derived(
		countries.filter(
			(country) =>
				!selectedCountries.includes(country) &&
				country.toLowerCase().includes(query.trim().toLowerCase())
		)
	);
	const selectedSeries = $derived(
		selectedCountries.map((country) => ({
			country,
			color: colorByCountry.get(country),
			values: seriesByCountry.get(country)
		}))
	);
	const yMaximum = $derived(
		Math.max(
			200,
			Math.ceil(
				(max(
					selectedSeries.flatMap((series) => series.values),
					(row) => row.value
				) ?? 100) / 100
			) * 100
		)
	);
	const y = $derived(
		scaleLinear()
			.domain([0, yMaximum])
			.nice(6)
			.range([height - margin.bottom, margin.top])
	);
	const yTicks = $derived(y.ticks(6));
	const seriesLine = $derived(
		line()
			.x((row) => x(row.year))
			.y((row) => y(row.value))
	);

	function addCountry(country) {
		selectedCountries = [...selectedCountries, country];
		query = "";
		searchOpen = false;
	}

	function removeCountry(country) {
		if (selectedCountries.length === 1) return;
		selectedCountries = selectedCountries.filter((item) => item !== country);
		active = null;
	}

	function showDetail(event, datum, color) {
		const chartBounds = chart.getBoundingClientRect();
		const markBounds = event.currentTarget.getBoundingClientRect();
		active = {
			...datum,
			color,
			x: Math.max(
				104,
				Math.min(
					chartBounds.width - 104,
					markBounds.left + markBounds.width / 2 - chartBounds.left
				)
			),
			y: Math.max(8, markBounds.top - chartBounds.top - 10)
		};
	}

	function hideDetail() {
		active = null;
	}

	function handleSearchKeydown(event) {
		if (event.key === "Escape") {
			searchOpen = false;
			query = "";
		}
		if (event.key === "Enter" && matchingCountries.length === 1) {
			addCountry(matchingCountries[0]);
		}
	}
</script>

<figure
	class="tb-history"
	aria-labelledby="tb-history-title tb-history-subtitle"
>
	<figcaption>
		<h5 id="tb-history-title">
			Tuberculosis incidence rates in Pacific Island Nations
		</h5>
		<p id="tb-history-subtitle">
			Annual estimated new and relapse TB cases per 100,000 people, 2000–2023.
			Search to compare places. Hover or click a point for its annual rate.
		</p>
	</figcaption>

	<div class="series-filter">
		<div class="selected-series" aria-label="Selected countries">
			{#each selectedCountries as country}
				<span
					class="series-chip"
					style={`--series-color:${colorByCountry.get(country)}`}
				>
					<i aria-hidden="true"></i>{country}
					<button
						type="button"
						disabled={selectedCountries.length === 1}
						aria-label={`Remove ${country}`}
						onclick={() => removeCountry(country)}>×</button
					>
				</span>
			{/each}
		</div>
		<div class="search-wrap">
			<label for="tb-country-search">Add a country or territory</label>
			<input
				id="tb-country-search"
				type="search"
				placeholder="Search series"
				autocomplete="off"
				bind:value={query}
				onfocus={() => (searchOpen = true)}
				oninput={() => (searchOpen = true)}
				onkeydown={handleSearchKeydown}
			/>
			{#if searchOpen}
				<div class="search-results" id="tb-country-options">
					{#if matchingCountries.length}
						{#each matchingCountries as country}
							<button type="button" onclick={() => addCountry(country)}
								>{country}</button
							>
						{/each}
					{:else}
						<p>{query ? "No matching series" : "All series are selected"}</p>
					{/if}
				</div>
			{/if}
		</div>
	</div>

	<div class="chart" bind:this={chart}>
		<svg
			class="tb-chart"
			viewBox={`0 0 ${width} ${height}`}
			role="img"
			aria-label={`Line chart of tuberculosis incidence from 2000 to 2023 for ${selectedCountries.join(", ")}`}
		>
			{#each yTicks as tick}
				<line
					class="gridline"
					x1={margin.left}
					x2={width - margin.right}
					y1={y(tick)}
					y2={y(tick)}
				></line>
				<text class="y-tick" x={margin.left - 12} y={y(tick) + 4}>{tick}</text>
			{/each}
			{#each xTicks as tick}
				<text class="x-tick" x={x(tick)} y={height - margin.bottom + 25}
					>{tick}</text
				>
			{/each}
			<line
				class="axis"
				x1={margin.left}
				x2={width - margin.right}
				y1={height - margin.bottom}
				y2={height - margin.bottom}
			></line>
			<text
				class="axis-title"
				transform={`translate(21 ${(margin.top + height - margin.bottom) / 2}) rotate(-90)`}
				>Cases per 100,000 people</text
			>
			<line
				class="global-average"
				x1={margin.left}
				x2={width - margin.right}
				y1={y(globalIncidence)}
				y2={y(globalIncidence)}
			></line>
			<text
				class="global-average-label"
				x={width - margin.right - 5}
				y={y(globalIncidence) - 9}
			>
				Global incidence, 2023 · {globalIncidence} cases per 100,000
			</text>

			{#each selectedSeries as series (series.country)}
				<path
					class="series-line"
					d={seriesLine(series.values)}
					style={`--series-color:${series.color}`}
				></path>
				{#each series.values as datum}
					<circle
						class="point-target"
						class:highlighted={active?.country === datum.country &&
							active?.year === datum.year}
						cx={x(datum.year)}
						cy={y(datum.value)}
						r="8"
						style={`--series-color:${series.color}`}
						role="button"
						tabindex="0"
						aria-label={`${datum.country}, ${datum.year}: ${valueFormat(datum.value)} TB cases per 100,000 people`}
						onpointerenter={(event) => showDetail(event, datum, series.color)}
						onpointerleave={hideDetail}
						onfocus={(event) => showDetail(event, datum, series.color)}
						onblur={hideDetail}
					></circle>
				{/each}
			{/each}
		</svg>

		{#if active}
			<div
				class="tooltip"
				style={`left:${active.x}px;top:${active.y}px;--series-color:${active.color}`}
			>
				<strong
					><i aria-hidden="true"></i>{active.country}, {active.year}</strong
				>
				<span>{valueFormat(active.value)} cases per 100,000 people</span>
			</div>
		{/if}
	</div>

	<p class="source">
		Source: <a href={sourceUrl} target="_blank" rel="noreferrer"
			>Pacific Data Hub</a
		>, Tuberculosis incidence per 100,000 population. Global benchmark: <a
			href={globalSourceUrl}
			target="_blank"
			rel="noreferrer">World Bank, Incidence of tuberculosis (per 100,000 people)</a
		>, sourced from the World Health Organization’s <em>Global Tuberculosis Report</em>.
	</p>
</figure>

<style>
	.tb-history {
		width: min(100%, 1120px);
		margin: clamp(56px, 8vw, 96px) auto clamp(34px, 5vw, 58px);
		font-family: "Inter", sans-serif;
	}
	figcaption {
		margin-bottom: 22px;
	}
	h5 {
		margin: 0;
		font-size: clamp(18px, 2vw, 24px);
		font-weight: 700;
		line-height: 1.2;
		letter-spacing: -0.02em;
	}
	figcaption p {
		margin: 8px 0 0;
		font-size: 15px;
		line-height: 1.45;
		color: #4a4a4a;
	}
	.series-filter {
		display: grid;
		grid-template-columns: minmax(0, 1fr) minmax(220px, 320px);
		gap: 14px;
		align-items: end;
	}
	.selected-series {
		display: flex;
		flex-wrap: wrap;
		gap: 7px;
	}
	.series-chip {
		display: inline-flex;
		align-items: center;
		gap: 7px;
		padding: 7px 8px;
		background: #f5f5f5;
		color: #000;
		font-size: 13px;
		font-weight: 700;
	}
	.series-chip i,
	.tooltip i {
		display: inline-block;
		width: 9px;
		height: 9px;
		background: var(--series-color);
	}
	.series-chip button {
		padding: 0 2px;
		border: 0;
		border-radius: 0;
		background: transparent;
		color: #000;
		font:
			700 18px/1 "Inter",
			sans-serif;
		cursor: pointer;
	}
	.series-chip button:disabled {
		cursor: not-allowed;
		opacity: 0.35;
	}
	.search-wrap {
		position: relative;
	}
	.search-wrap label {
		display: block;
		margin-bottom: 5px;
		font-size: 12px;
		font-weight: 700;
	}
	.search-wrap input {
		width: 100%;
		padding: 9px 10px;
		border: 1px solid #000;
		border-radius: 0;
		background: #fff;
		color: #000;
		font:
			400 14px/1.2 "Inter",
			sans-serif;
	}
	.search-results {
		position: absolute;
		top: 100%;
		left: 0;
		right: 0;
		max-height: 220px;
		overflow-y: auto;
		border: 1px solid #000;
		border-top: 0;
		background: #fff;
		z-index: 4;
	}
	.search-results button {
		display: block;
		width: 100%;
		padding: 8px 10px;
		border: 0;
		border-radius: 0;
		background: #fff;
		color: #000;
		font:
			400 13px/1.3 "Inter",
			sans-serif;
		text-align: left;
		cursor: pointer;
	}
	.search-results button:hover,
	.search-results button:focus {
		background: #f5f5f5;
	}
	.search-results p {
		margin: 0;
		padding: 9px 10px;
		font-size: 12px;
		color: #757575;
	}
	.instruction {
		margin: 13px 0 7px;
		font-size: 12px;
		line-height: 1.45;
		color: #4a4a4a;
	}
	.chart {
		position: relative;
		width: 100%;
	}
	.tb-chart {
		display: block;
		width: 100%;
		height: auto;
		overflow: visible;
	}
	.tb-chart .gridline {
		stroke: #e0e0e0;
		stroke-width: 1;
	}
	.tb-chart .axis {
		stroke: #808080;
		stroke-width: 1;
	}
	.tb-chart .x-tick,
	.tb-chart .y-tick {
		fill: #4a4a4a;
		font-size: 12px;
	}
	.tb-chart .x-tick {
		text-anchor: middle;
	}
	.tb-chart .y-tick {
		text-anchor: end;
	}
	.tb-chart .axis-title {
		fill: #1a1a1a;
		font-size: 14px;
		font-weight: 700;
		text-anchor: middle;
	}
	.tb-chart .global-average {
		stroke: #1a1a1a;
		stroke-width: 2;
		stroke-dasharray: 3 5;
	}
	.tb-chart .global-average-label {
		fill: #1a1a1a;
		font-size: 12px;
		font-weight: 700;
		text-anchor: end;
	}
	.tb-chart .series-line {
		fill: none;
		stroke: var(--series-color);
		stroke-width: 3.25;
		stroke-linejoin: round;
		stroke-linecap: round;
		transition: d 240ms ease;
	}
	.tb-chart .point-target {
		fill: transparent;
		stroke: transparent;
		stroke-width: 2;
		cursor: pointer;
	}
	.tb-chart .point-target:hover,
	.tb-chart .point-target:focus,
	.tb-chart .point-target.highlighted {
		fill: #fff;
		stroke: var(--series-color);
		outline: none;
	}
	.tooltip {
		position: absolute;
		width: 208px;
		padding: 10px 12px;
		transform: translate(-50%, -100%);
		border: 1px solid #000;
		border-radius: 0;
		background: #fff;
		color: #000;
		font-size: 12px;
		line-height: 1.45;
		pointer-events: none;
		z-index: 3;
	}
	.tooltip strong,
	.tooltip span {
		display: block;
	}
	.tooltip strong {
		display: flex;
		align-items: center;
		gap: 7px;
	}
	.source {
		margin: 8px 0 0;
		font-size: 12px;
		line-height: 1.45;
		color: #4a4a4a;
	}
	.source a {
		color: #057dbc;
		text-decoration: underline;
		text-underline-offset: 2px;
	}
	@media (max-width: 680px) {
		.series-filter {
			grid-template-columns: 1fr;
		}
		.search-wrap {
			max-width: none;
		}
		.tb-chart .x-tick,
		.tb-chart .y-tick {
			font-size: 14px;
		}
		.tb-chart .axis-title {
			font-size: 16px;
		}
	}
	@media (prefers-reduced-motion: reduce) {
		.tb-chart .series-line {
			transition: none;
		}
	}
</style>
