<script>
	import { onMount } from "svelte";
	import { format, scaleLinear } from "d3";
	import rows from "$data/drinking_water_long_term_trends.csv";

	const sourceUrl =
		"https://stats.pacificdata.org/vis?lc=en&df[ds]=ds%3ASPC2&df[id]=DF_SDG_06&df[ag]=SPC&df[vs]=3.0&dq=A.SH_H2O_SAFE...._T.....&pd=,&to[TIME_PERIOD]=false";
	const percentFormat = format(".2f");
	const featuredCountries = new Set([
		"Papua New Guinea",
		"Kiribati",
		"Solomon Islands",
		"French Polynesia"
	]);
	const data = rows.map((row) => ({
		country: row.country,
		code: row.country_code,
		firstYear: +row.first_year,
		latestYear: +row.latest_year,
		firstValue: +row.first_safely_managed_drinking_water_percent,
		latestValue: +row.latest_safely_managed_drinking_water_percent,
		change: +row.percentage_point_change
	}));
	const height = 820;
	const plotTop = 72;
	const plotBottom = 774;
	const y = scaleLinear().domain([25, 100]).range([plotBottom, plotTop]);
	const minLabelGap = 25;

	let container;
	let width = $state(960);
	let activeCountry = $state(null);
	let selectedCountry = $state(null);
	let direction = $state("all");
	const visibleData = $derived(
		direction === "all"
			? data
			: data.filter((row) =>
					direction === "increase" ? row.change >= 0 : row.change < 0
				)
	);
	const emphasizedCountry = $derived(selectedCountry ?? activeCountry);
	const compact = $derived(width < 680);
	const leftX = $derived(compact ? 104 : Math.max(285, width * 0.31));
	const rightX = $derived(
		compact ? width - 104 : Math.min(width - 285, width * 0.69)
	);

	function spreadLabels(valueKey, series) {
		const sorted = series
			.map((row) => ({ country: row.country, target: y(row[valueKey]) }))
			.sort((a, b) => a.target - b.target);
		const placed = [];
		for (const item of sorted) {
			placed.push({
				...item,
				y:
					placed.length === 0
						? Math.max(plotTop, item.target)
						: Math.max(item.target, placed.at(-1).y + minLabelGap)
			});
		}
		for (let index = placed.length - 1; index >= 0; index -= 1) {
			const ceiling =
				index === placed.length - 1
					? plotBottom
					: placed[index + 1].y - minLabelGap;
			placed[index].y = Math.min(placed[index].y, ceiling);
		}
		return new Map(placed.map((item) => [item.country, item.y]));
	}

	const leftLabelY = $derived(spreadLabels("firstValue", visibleData));
	const rightLabelY = $derived(spreadLabels("latestValue", visibleData));

	function endpointLabel(row, side) {
		const shortNames = {
			"Micronesia (Federated States of)": "Micronesia (Fed. States)",
			"Northern Mariana Islands": "Northern Mariana Is."
		};
		const country = compact
			? row.code
			: (shortNames[row.country] ?? row.country);
		if (side === "left") {
			return `${country} · ${row.firstYear} · ${percentFormat(row.firstValue)}%`;
		}
		return `${row.latestYear} · ${percentFormat(row.latestValue)}% · ${country}`;
	}

	function selectDirection(nextDirection) {
		direction = nextDirection;
		selectedCountry = null;
		activeCountry = null;
	}

	function selectCountry(country) {
		selectedCountry = selectedCountry === country ? null : country;
	}

	function handleCountryKeydown(event, country) {
		if (event.key === "Enter" || event.key === " ") {
			event.preventDefault();
			selectCountry(country);
		}
	}

	onMount(() => {
		const observer = new ResizeObserver(([entry]) => {
			width = Math.max(320, entry.contentRect.width);
		});
		observer.observe(container);
		function handleEscape(event) {
			if (event.key === "Escape") selectedCountry = null;
		}
		window.addEventListener("keydown", handleEscape);
		return () => {
			observer.disconnect();
			window.removeEventListener("keydown", handleEscape);
		};
	});
</script>

<figure
	class="water-slope"
	aria-labelledby="water-slope-title water-slope-subtitle"
>
	<figcaption>
		<h5 id="water-slope-title">
			Long-term access to safely managed drinking water in the Pacific
		</h5>
		<p id="water-slope-subtitle">
			The first and latest reported prevalence rates for each Pacific country or
			territory. Years vary according to data availability. Filter by direction,
			then hover, focus, or select a country to emphasize its change.
		</p>
	</figcaption>

	<div class="direction-filter" role="group" aria-label="Filter by direction">
		<strong>Direction</strong>
		<button type="button" class:active={direction === "all"} aria-pressed={direction === "all"} onclick={() => selectDirection("all")}>All</button>
		<button type="button" class:active={direction === "increase"} aria-pressed={direction === "increase"} onclick={() => selectDirection("increase")}><i class="up" aria-hidden="true"></i>Increased</button>
		<button type="button" class:active={direction === "decrease"} aria-pressed={direction === "decrease"} onclick={() => selectDirection("decrease")}><i class="down" aria-hidden="true"></i>Decreased</button>
	</div>

	{#if selectedCountry}
		{@const selected = data.find((row) => row.country === selectedCountry)}
		<div class="selected-detail" aria-live="polite">
			<p>
				<strong>{selected.country}</strong> moved from {percentFormat(selected.firstValue)}%
				in {selected.firstYear} to {percentFormat(selected.latestValue)}% in {selected.latestYear}
				— a {selected.change >= 0 ? "gain" : "decline"} of {percentFormat(Math.abs(selected.change))}
				percentage points.
			</p>
			<button type="button" aria-label={`Clear ${selected.country} selection`} onclick={() => (selectedCountry = null)}>Clear</button>
		</div>
	{/if}

	<div class="chart" bind:this={container}>
		<svg
			class="slope-chart"
			viewBox={`0 0 ${width} ${height}`}
			role="img"
			aria-label={`Slope chart comparing first and latest reported percentages of people using safely managed drinking water services for ${direction === "all" ? "all Pacific countries and territories" : `countries where access ${direction === "increase" ? "increased" : "decreased"}`}`}
		>
			<text class="column-title" x={leftX} y="28" text-anchor="middle"
				>First reported value</text
			>
			<text class="column-title" x={rightX} y="28" text-anchor="middle"
				>Latest reported value</text
			>
			<line
				class="column-guide"
				x1={leftX}
				x2={leftX}
				y1={plotTop}
				y2={plotBottom}
			></line>
			<line
				class="column-guide"
				x1={rightX}
				x2={rightX}
				y1={plotTop}
				y2={plotBottom}
			></line>

			{#each visibleData as row (row.country)}
				<g
					class="country-slope"
					class:all-view={direction === "all"}
					class:featured={featuredCountries.has(row.country)}
					class:active={emphasizedCountry === row.country}
					class:muted={emphasizedCountry && emphasizedCountry !== row.country}
					class:increase={row.change >= 0}
					class:decrease={row.change < 0}
					role="button"
					tabindex="0"
					aria-label={`${row.country}: ${percentFormat(row.firstValue)} percent in ${row.firstYear}, ${percentFormat(row.latestValue)} percent in ${row.latestYear}, a ${row.change >= 0 ? "gain" : "decline"} of ${percentFormat(Math.abs(row.change))} percentage points`}
					onpointerenter={() => (activeCountry = row.country)}
					onpointerleave={() => (activeCountry = null)}
					onfocus={() => (activeCountry = row.country)}
					onblur={() => (activeCountry = null)}
					onclick={() => selectCountry(row.country)}
					onkeydown={(event) => handleCountryKeydown(event, row.country)}
				>
					<line
						class="hit-line"
						x1={leftX}
						y1={y(row.firstValue)}
						x2={rightX}
						y2={y(row.latestValue)}
					></line>
					<line
						class="slope"
						x1={leftX}
						y1={y(row.firstValue)}
						x2={rightX}
						y2={y(row.latestValue)}
					></line>
					<line
						class="label-leader"
						x1={leftX}
						y1={y(row.firstValue)}
						x2={leftX - 8}
						y2={leftLabelY.get(row.country)}
					></line>
					<line
						class="label-leader"
						x1={rightX}
						y1={y(row.latestValue)}
						x2={rightX + 8}
						y2={rightLabelY.get(row.country)}
					></line>
					<circle cx={leftX} cy={y(row.firstValue)} r="4.5"></circle>
					<circle cx={rightX} cy={y(row.latestValue)} r="4.5"></circle>
					<text
						class="endpoint-label left"
						x={leftX - 12}
						y={leftLabelY.get(row.country) + 4}
					>
						{endpointLabel(row, "left")}
					</text>
					<text
						class="endpoint-label right"
						x={rightX + 12}
						y={rightLabelY.get(row.country) + 4}
					>
						{endpointLabel(row, "right")}
					</text>
				</g>
			{/each}
		</svg>
	</div>

	<p class="note">
		Values show the proportion of the population using safely managed drinking
		water services. Endpoint years differ where reporting periods vary.
	</p>
	<p class="source">
		Source: <a href={sourceUrl} target="_blank" rel="noreferrer"
			>Pacific Data Hub</a
		>, Proportion of population using safely managed drinking water services.
	</p>
</figure>

<style>
	.water-slope {
		width: min(100%, 1120px);
		margin: clamp(56px, 8vw, 96px) auto clamp(34px, 5vw, 58px);
		font-family: "Inter", sans-serif;
	}
	figcaption {
		margin-bottom: 20px;
	}
	h5 {
		margin: 0;
		font-size: clamp(18px, 2vw, 24px);
		font-weight: 700;
		line-height: 1.2;
		letter-spacing: -0.02em;
	}
	figcaption p {
		max-width: 800px;
		margin: 8px 0 0;
		font-size: 15px;
		line-height: 1.45;
		color: #4a4a4a;
	}
	.direction-filter {
		display: flex;
		flex-wrap: wrap;
		align-items: center;
		gap: 7px;
		font-size: 13px;
	}
	.direction-filter strong { margin-right: 5px; }
	.direction-filter button {
		display: inline-flex;
		align-items: center;
		gap: 6px;
		padding: 8px 11px;
		border: 1px solid #000;
		border-radius: 0;
		background: #fff;
		color: #000;
		font: 700 13px/1 "Inter", sans-serif;
		cursor: pointer;
	}
	.direction-filter button.active { background: #000; color: #fff; }
	.direction-filter i {
		width: 11px;
		height: 11px;
	}
	.direction-filter .up {
		background: #135ae1;
	}
	.direction-filter .down {
		background: #de2c35;
	}
	.selected-detail {
		display: flex;
		align-items: center;
		justify-content: space-between;
		gap: 14px;
		margin-top: 12px;
		padding: 10px 12px;
		background: #f5f5f5;
		color: #000;
		font-size: 13px;
		line-height: 1.4;
	}
	.selected-detail p { margin: 0; }
	.selected-detail button {
		padding: 7px 9px;
		border: 1px solid #000;
		border-radius: 0;
		background: #fff;
		color: #000;
		font: 700 12px/1 "Inter", sans-serif;
		cursor: pointer;
	}
	.note,
	.source {
		font-size: 12px;
		line-height: 1.45;
		color: #4a4a4a;
	}
	.chart {
		width: 100%;
	}
	.slope-chart {
		display: block;
		width: 100%;
		height: auto;
		overflow: visible;
	}
	.slope-chart .column-title {
		fill: #1a1a1a;
		font-size: 13px;
		font-weight: 700;
	}
	.slope-chart .column-guide {
		stroke: #e0e0e0;
		stroke-width: 1;
		stroke-dasharray: 3 4;
	}
	.slope-chart .country-slope {
		color: #135ae1;
		transition: opacity 140ms ease;
	}
	.slope-chart .country-slope.decrease {
		color: #de2c35;
	}
	.slope-chart .country-slope.all-view:not(.featured):not(.active) {
		color: #a7abaf;
		opacity: 0.48;
	}
	.slope-chart .country-slope.muted {
		opacity: 0.1 !important;
	}
	.slope-chart .country-slope.increase.active,
	.slope-chart .country-slope.increase.featured {
		color: #135ae1;
	}
	.slope-chart .country-slope.decrease.active,
	.slope-chart .country-slope.decrease.featured {
		color: #de2c35;
	}
	.slope-chart .country-slope.active {
		opacity: 1 !important;
	}
	.slope-chart .slope,
	.slope-chart .label-leader {
		stroke: currentColor;
		fill: none;
	}
	.slope-chart .slope {
		stroke-width: 2;
	}
	.slope-chart .hit-line {
		stroke: transparent;
		stroke-width: 18;
		cursor: pointer;
	}
	.slope-chart .label-leader {
		stroke-width: 1;
		opacity: 0.55;
	}
	.slope-chart circle {
		fill: currentColor;
		stroke: #fff;
		stroke-width: 1.5;
	}
	.slope-chart .endpoint-label {
		fill: currentColor;
		font-size: 11px;
		font-weight: 700;
	}
	.slope-chart .endpoint-label.left {
		text-anchor: end;
	}
	.slope-chart .endpoint-label.right {
		text-anchor: start;
	}
	.note {
		margin: 7px 0 0;
	}
	.source {
		margin: 4px 0 0;
	}
	.source a {
		color: #057dbc;
		text-decoration: underline;
		text-underline-offset: 2px;
	}
	@media (max-width: 680px) {
		.selected-detail { align-items: flex-start; }
		.slope-chart .column-title {
			font-size: 12px;
		}
		.slope-chart .endpoint-label {
			font-size: 11px;
		}
	}
	@media (prefers-reduced-motion: reduce) {
		.slope-chart .country-slope {
			transition: none;
		}
	}
</style>
