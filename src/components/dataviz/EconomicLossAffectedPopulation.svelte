<script>
	import { format, scaleSymlog } from "d3";
	import rows from "$data/economic_loss_affected_population.csv";

	const sourceUrl = "https://stats.pacificdata.org/";
	const width = 960;
	const height = 570;
	const margin = { top: 28, right: 30, bottom: 76, left: 92 };
	const numberFormat = format(",d");
	const moneyFormat = format("$.3~s");
	const tickFormat = (value) => (value === 0 ? "0" : format("~s")(value));
	const data = rows
		.filter((row) => row.affected_population_status === "Reported")
		.map((row) => ({
			country: row.country,
			year: +row.year,
			affected: +row.disaster_affected_population,
			loss: +row.disaster_economic_loss_usd,
			label: row.point_label
		}));
	const countries = [...new Set(data.map((row) => row.country))].sort((a, b) =>
		a.localeCompare(b)
	);
	const xTicks = [0, 10, 100, 1_000, 10_000, 100_000, 1_000_000];
	const yTicks = [
		0, 100_000, 1_000_000, 10_000_000, 100_000_000, 1_000_000_000
	];
	const x = scaleSymlog()
		.constant(10)
		.domain([0, 1_000_000])
		.range([margin.left, width - margin.right]);
	const y = scaleSymlog()
		.constant(100_000)
		.domain([0, 1_000_000_000])
		.range([height - margin.bottom, margin.top]);

	let selectedCountry = $state("All");
	let active = $state(null);
	let chart;

	const visibleData = $derived(
		selectedCountry === "All"
			? data
			: data.filter((row) => row.country === selectedCountry)
	);

	function showDetail(event, datum) {
		const chartBounds = chart.getBoundingClientRect();
		const markBounds = event.currentTarget.getBoundingClientRect();
		const scaledX = markBounds.left + markBounds.width / 2 - chartBounds.left;
		const scaledY = markBounds.top - chartBounds.top;
		active = {
			...datum,
			x: Math.max(112, Math.min(chartBounds.width - 112, scaledX)),
			y: Math.max(8, scaledY - 10)
		};
	}

	function hideDetail() {
		active = null;
	}
</script>

<figure
	class="economic-loss"
	aria-labelledby="economic-loss-title economic-loss-subtitle"
>
	<figcaption>
		<h5 id="economic-loss-title">
			Economic impact of climate disasters in the Pacific
		</h5>
		<p id="economic-loss-subtitle">
			Each data point is a Pacific country-year with both measures reported.
			Hover or click a point for details. Diamonds mark years when zero people
			were reported directly affected.
		</p>
	</figcaption>

	<div class="filters" role="group" aria-label="Filter by country">
		{#each ["All", ...countries] as country}
			<button
				type="button"
				class:active={selectedCountry === country}
				aria-pressed={selectedCountry === country}
				onclick={() => {
					selectedCountry = country;
					active = null;
				}}>{country}</button
			>
		{/each}
	</div>

	<div class="chart" bind:this={chart}>
		<svg
			viewBox={`0 0 ${width} ${height}`}
			role="img"
			aria-label={`Scatter plot of direct disaster economic loss against people directly affected for ${selectedCountry === "All" ? "Pacific countries" : selectedCountry}. Diamonds indicate reported zero affected people.`}
		>
			{#each yTicks as tick}
				<line
					class="gridline"
					x1={margin.left}
					x2={width - margin.right}
					y1={y(tick)}
					y2={y(tick)}
				></line>
				<text class="y-tick" x={margin.left - 12} y={y(tick) + 4}
					>{tickFormat(tick)}</text
				>
			{/each}
			{#each xTicks as tick}
				<line
					class="gridline"
					x1={x(tick)}
					x2={x(tick)}
					y1={margin.top}
					y2={height - margin.bottom}
				></line>
				<text class="x-tick" x={x(tick)} y={height - margin.bottom + 24}
					>{tickFormat(tick)}</text
				>
			{/each}

			<line
				class="axis"
				x1={margin.left}
				x2={width - margin.right}
				y1={height - margin.bottom}
				y2={height - margin.bottom}
			></line>
			<line
				class="axis"
				x1={margin.left}
				x2={margin.left}
				y1={margin.top}
				y2={height - margin.bottom}
			></line>
			<text
				class="axis-title x-title"
				x={(margin.left + width - margin.right) / 2}
				y={height - 18}>People directly affected</text
			>
			<text
				class="axis-title y-title"
				transform={`translate(25 ${(margin.top + height - margin.bottom) / 2}) rotate(-90)`}
				>Direct economic loss (USD)</text
			>

			{#each visibleData as datum (`${datum.country}-${datum.year}`)}
				{#if datum.affected === 0}
					<rect
						class="mark zero"
						class:highlighted={active?.country === datum.country &&
							active?.year === datum.year}
						x={x(datum.affected) - 6}
						y={y(datum.loss) - 6}
						width="12"
						height="12"
						transform={`rotate(45 ${x(datum.affected)} ${y(datum.loss)})`}
						role="button"
						tabindex="0"
						aria-label={`${datum.country}, ${datum.year}: zero people directly affected and ${moneyFormat(datum.loss)} in direct economic loss`}
						onpointerenter={(event) => showDetail(event, datum)}
						onpointerleave={hideDetail}
						onfocus={(event) => showDetail(event, datum)}
						onblur={hideDetail}
					></rect>
				{:else}
					<circle
						class="mark"
						class:highlighted={active?.country === datum.country &&
							active?.year === datum.year}
						cx={x(datum.affected)}
						cy={y(datum.loss)}
						r="6"
						role="button"
						tabindex="0"
						aria-label={`${datum.country}, ${datum.year}: ${numberFormat(datum.affected)} people directly affected and ${moneyFormat(datum.loss)} in direct economic loss`}
						onpointerenter={(event) => showDetail(event, datum)}
						onpointerleave={hideDetail}
						onfocus={(event) => showDetail(event, datum)}
						onblur={hideDetail}
					></circle>
				{/if}
			{/each}
		</svg>

		{#if active}
			<div class="tooltip" style={`left:${active.x}px;top:${active.y}px`}>
				<strong>{active.country}, {active.year}</strong>
				<span>{numberFormat(active.affected)} people directly affected</span>
				<span>{moneyFormat(active.loss)} direct economic loss</span>
			</div>
		{/if}
	</div>

	<div class="notes">
		<p>
			<strong>Note:</strong> A reported zero means disasters can damage land and infrastructure
			without directly affecting people. Country-years without an affected-population
			value are not plotted.
		</p>
		<p>
			Source: <a href={sourceUrl} target="_blank" rel="noreferrer"
				>Pacific Data Hub</a
			>, Number of directly affected persons attributed to disasters and Direct
			disaster economic loss.
		</p>
	</div>
</figure>

<style>
	.economic-loss {
		width: min(100%, 1120px);
		margin: clamp(56px, 8vw, 96px) auto clamp(34px, 5vw, 58px);
		font-family: "Inter", sans-serif;
	}
	figcaption {
		margin-bottom: 24px;
	}
	h5 {
		margin: 0;
		font-size: clamp(18px, 2vw, 24px);
		font-weight: 700;
		line-height: 1.2;
		letter-spacing: -0.02em;
	}
	figcaption p {
		max-width: 760px;
		margin: 8px 0 0;
		font-size: 15px;
		line-height: 1.45;
		color: #4a4a4a;
	}
	.filters {
		display: flex;
		flex-wrap: wrap;
		gap: 7px;
		margin-bottom: 14px;
	}
	.filters button {
		padding: 8px 11px;
		border: 1px solid #000;
		border-radius: 0;
		background: #fff;
		color: #000;
		font:
			700 13px/1.1 "Inter",
			sans-serif;
		cursor: pointer;
	}
	.filters button.active {
		background: #000;
		color: #fff;
	}
	.instruction {
		margin: 0 0 8px;
		font-size: 12px;
		line-height: 1.45;
		color: #4a4a4a;
	}
	.chart {
		position: relative;
		width: 100%;
	}
	svg {
		display: block;
		width: 100%;
		height: auto;
		overflow: visible;
	}
	.gridline {
		stroke: #e0e0e0;
		stroke-width: 1;
	}
	.axis {
		stroke: #808080;
		stroke-width: 1;
	}
	.x-tick,
	.y-tick {
		fill: #4a4a4a;
		font-size: 12px;
	}
	.x-tick {
		text-anchor: middle;
	}
	.y-tick {
		text-anchor: end;
	}
	.axis-title {
		fill: #1a1a1a;
		font-size: 14px;
		font-weight: 700;
		text-anchor: middle;
	}
	.mark {
		fill: #135ae1;
		stroke: #fff;
		stroke-width: 1.5;
		cursor: pointer;
		transition:
			opacity 140ms ease,
			stroke-width 140ms ease;
	}
	.mark:hover,
	.mark:focus,
	.mark.highlighted {
		stroke: #000;
		stroke-width: 3;
		outline: none;
	}
	.zero {
		fill: #fa6502;
	}
	.tooltip {
		position: absolute;
		width: 224px;
		padding: 10px 12px;
		transform: translate(-50%, -100%);
		border: 1px solid #000;
		border-radius: 0;
		background: #fff;
		color: #000;
		font-size: 12px;
		line-height: 1.4;
		pointer-events: none;
		z-index: 2;
	}
	.tooltip strong,
	.tooltip span {
		display: block;
	}
	.notes {
		max-width: 820px;
		margin-top: 10px;
	}
	.notes p {
		margin: 4px 0 0;
		font-size: 12px;
		line-height: 1.45;
		color: #4a4a4a;
	}
	.notes a {
		color: #057dbc;
		text-decoration: underline;
		text-underline-offset: 2px;
	}
	@media (max-width: 640px) {
		.economic-loss {
			margin-top: 48px;
		}
		.filters {
			gap: 5px;
		}
		.filters button {
			padding: 7px 8px;
			font-size: 12px;
		}
		.x-tick,
		.y-tick {
			font-size: 14px;
		}
		.axis-title {
			font-size: 16px;
		}
	}
	@media (prefers-reduced-motion: reduce) {
		.mark {
			transition: none;
		}
	}
</style>
