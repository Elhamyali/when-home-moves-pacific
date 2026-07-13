<script>
	import { format, line, max, scaleLinear } from "d3";
	import rows from "$data/internal_displacement_country_year_chart_data.csv";

	const firstYear = 2008;
	const lastYear = 2025;
	const years = Array.from(
		{ length: lastYear - firstYear + 1 },
		(_, index) => firstYear + index
	);
	const numberFormat = format(",d");
	const compactFormat = format("~s");
	const sourceUrl =
		"https://www.internal-displacement.org/database/displacement-data/";
	const parsedRows = rows.map((row) => ({
		country: row.country,
		year: +row.year,
		displacements: +row.disaster_internal_displacements || 0,
		reportedEvents: +row.reported_displacement_events || 0,
		eventNames: row.event_names
			.split(";")
			.map((event) => event.trim())
			.filter(Boolean),
		hazardTypes: [
			...new Set(
				row.hazard_types
					.split(";")
					.map((hazard) => hazard.trim())
					.filter(Boolean)
			)
		],
		hazardSubtypes: [
			...new Set(
				row.hazard_subtypes
					.split(";")
					.map((hazard) => hazard.trim())
					.filter(Boolean)
			)
		]
	}));
	const countries = [...new Set(parsedRows.map((row) => row.country))].sort(
		(a, b) => a.localeCompare(b)
	);
	const rowByCountryYear = new Map(
		parsedRows.map((row) => [`${row.country}|${row.year}`, row])
	);
	const panels = countries.map((country) => ({
		country,
		values: years.map(
			(year) =>
				rowByCountryYear.get(`${country}|${year}`) ?? {
					country,
					year,
					displacements: 0,
					reportedEvents: 0,
					eventNames: [],
					hazardTypes: [],
					hazardSubtypes: []
				}
		)
	}));
	const plotWidth = 230;
	const plotHeight = 160;
	const margin = { top: 12, right: 10, bottom: 29, left: 39 };
	const yMaximum = Math.ceil(max(parsedRows, (row) => row.displacements) / 10000) * 10000;
	const yTicks = [0, 40000, 80000].filter((tick) => tick <= yMaximum);
	const xTicks = [2010, 2015, 2020, 2025];
	const x = scaleLinear()
		.domain([firstYear, lastYear])
		.range([margin.left, plotWidth - margin.right]);
	const y = scaleLinear()
		.domain([0, yMaximum])
		.range([plotHeight - margin.bottom, margin.top]);
	const seriesLine = line()
		.x((datum) => x(datum.year))
		.y((datum) => y(datum.displacements));

	let grid;
	let selected = $state(null);

	function selectYear(event, datum) {
		if (
			selected?.country === datum.country &&
			selected?.year === datum.year
		) {
			selected = null;
			return;
		}
		const gridBounds = grid.getBoundingClientRect();
		const plotBounds = event.currentTarget.parentElement.getBoundingClientRect();
		const rawX =
			plotBounds.left +
			(x(datum.year) / plotWidth) * plotBounds.width -
			gridBounds.left;
		const rawY =
			plotBounds.top +
			(y(datum.displacements) / plotHeight) * plotBounds.height -
			gridBounds.top;
		selected = {
			...datum,
			x: Math.max(155, Math.min(gridBounds.width - 155, rawX)),
			y: rawY,
			below: rawY < 250
		};
	}

	function clearSelection() {
		selected = null;
	}
</script>

<figure class="small-multiples" aria-labelledby="idmc-lines-subtitle">
	<figcaption>
		<p id="idmc-lines-subtitle">
			Annual disaster-related internal displacement movements varied sharply
			across 17 Pacific countries and territories from {firstYear} to {lastYear}.
			Select any year to see the reported events and hazards.
		</p>
	</figcaption>

	<div class="axis-key" aria-hidden="true">
		<span>Annual internal displacement movements</span>
		<i></i>
	</div>

	<div class="grid-wrap" bind:this={grid}>
		<div class="chart-grid">
			{#each panels as panel}
				<section class="panel" aria-labelledby={`panel-${panel.country.replaceAll(/[^a-zA-Z0-9]/g, "-")}`}>
					<h6 id={`panel-${panel.country.replaceAll(/[^a-zA-Z0-9]/g, "-")}`}>
						{panel.country}
					</h6>
					<div class="plot">
						<svg
							viewBox={`0 0 ${plotWidth} ${plotHeight}`}
							role="img"
							aria-label={`${panel.country} annual internal displacement movements from ${firstYear} to ${lastYear}`}
						>
							{#each yTicks as tick}
								<line
									class="gridline"
									x1={margin.left}
									x2={plotWidth - margin.right}
									y1={y(tick)}
									y2={y(tick)}
								></line>
								<text class="y-label" x={margin.left - 6} y={y(tick) + 4}>
									{tick === 0 ? "0" : compactFormat(tick)}
								</text>
							{/each}

							<path class="series" d={seriesLine(panel.values)}></path>

							{#each xTicks as tick}
								<line
									class="x-tick"
									x1={x(tick)}
									x2={x(tick)}
									y1={plotHeight - margin.bottom}
									y2={plotHeight - margin.bottom + 5}
								></line>
								<text class="x-label" x={x(tick)} y={plotHeight - 7}>{tick}</text>
							{/each}

							{#each panel.values as datum}
								<circle
									class:zero={datum.displacements === 0}
									class:selected={selected?.country === datum.country && selected?.year === datum.year}
									cx={x(datum.year)}
									cy={y(datum.displacements)}
									r={datum.displacements === 0 ? 1.8 : 3.3}
								></circle>
							{/each}
						</svg>

						{#each panel.values as datum}
							<button
								class="year-target"
								type="button"
								aria-pressed={selected?.country === datum.country && selected?.year === datum.year}
								aria-label={`${panel.country}, ${datum.year}: ${numberFormat(datum.displacements)} internal displacement movements, ${numberFormat(datum.reportedEvents)} reported events`}
								style={`left:${(x(datum.year) / plotWidth) * 100}%`}
								onclick={(event) => selectYear(event, datum)}
								onkeydown={(event) => {
									if (event.key === "Escape") clearSelection();
								}}
							></button>
						{/each}
					</div>
				</section>
			{/each}
		</div>

		{#if selected}
			<aside
				class:below={selected.below}
				class="popup"
				style={`left:${selected.x}px;top:${selected.y}px`}
				role="status"
				aria-live="polite"
			>
				<header>
					<div>
						<strong>{selected.country}</strong>
						<span>{selected.year}</span>
					</div>
					<button type="button" onclick={clearSelection} aria-label="Close event details">×</button>
				</header>
				<dl>
					<div>
						<dt>Internal displacement movements</dt>
						<dd>{numberFormat(selected.displacements)}</dd>
					</div>
					<div>
						<dt>Reported events</dt>
						<dd>{numberFormat(selected.reportedEvents)}</dd>
					</div>
					{#if selected.hazardTypes.length}
						<div>
							<dt>Hazards</dt>
							<dd>{selected.hazardTypes.join(", ")}</dd>
						</div>
					{/if}
				</dl>
				<div class="events">
					<strong>Event names</strong>
					{#if selected.eventNames.length}
						<ul>
							{#each selected.eventNames as eventName}
								<li>{eventName}</li>
							{/each}
						</ul>
					{:else}
						<p>No disaster displacement event was reported for this year.</p>
					{/if}
				</div>
			</aside>
		{/if}
	</div>

	<p class="note">
		Years without a reported disaster displacement event are shown as zero.
		Values count displacement movements rather than unique people.
	</p>
	<p class="source">
		Source: <a href={sourceUrl} target="_blank" rel="noreferrer"
			>Internal Displacement Monitoring Centre (IDMC)</a
		>.
	</p>
</figure>

<style>
	.small-multiples {
		width: min(100%, 1120px);
		margin: clamp(72px, 10vw, 132px) auto clamp(52px, 7vw, 88px);
		font-family: "Inter", sans-serif;
	}

	figcaption { max-width: 900px; }
	figcaption p {
		max-width: 820px;
		margin: 0;
		color: #4a4a4a;
		font: 400 clamp(15px, 1.6vw, 19px)/1.5 "Inter", sans-serif;
	}

	.axis-key {
		display: flex;
		align-items: center;
		gap: 10px;
		margin: 26px 0 22px;
		color: #4a4a4a;
		font: 600 11px/1.2 "Inter", sans-serif;
		letter-spacing: 0.05em;
		text-transform: uppercase;
	}
	.axis-key i {
		width: 42px;
		height: 3px;
		background: #135ae1;
	}

	.grid-wrap { position: relative; }
	.chart-grid {
		display: grid;
		grid-template-columns: repeat(4, minmax(0, 1fr));
		gap: clamp(30px, 4vw, 52px) clamp(16px, 2.6vw, 34px);
	}
	.panel { min-width: 0; }
	h6 {
		min-height: 2.5em;
		margin: 0 0 7px;
		font: 700 clamp(14px, 1.45vw, 18px)/1.12 "Inter", sans-serif;
		letter-spacing: -0.015em;
	}
	.plot {
		position: relative;
		width: 100%;
	}
	.plot svg {
		display: block;
		width: 100%;
		height: auto;
		overflow: hidden;
	}

	.gridline {
		stroke: #a7abaf;
		stroke-width: 1;
		stroke-opacity: 0.45;
		vector-effect: non-scaling-stroke;
	}
	.series {
		fill: none;
		stroke: #135ae1;
		stroke-width: 3;
		stroke-linecap: round;
		stroke-linejoin: round;
		vector-effect: non-scaling-stroke;
	}
	circle {
		fill: #135ae1;
		stroke: #fff;
		stroke-width: 1.2;
		vector-effect: non-scaling-stroke;
	}
	circle.zero {
		fill: #fff;
		stroke: #135ae1;
		stroke-width: 1;
		stroke-opacity: 0.45;
	}
	circle.selected {
		fill: #f2b90f;
		stroke: #000;
		stroke-width: 2.5;
	}
	.x-tick { stroke: #808080; stroke-width: 1; }
	.x-label,
	.y-label {
		fill: #4a4a4a;
		font: 500 10px/1 "Inter", sans-serif;
	}
	.x-label { text-anchor: middle; }
	.y-label { text-anchor: end; }

	.year-target {
		position: absolute;
		top: 7.5%;
		width: 4.2%;
		height: 74.4%;
		padding: 0;
		transform: translateX(-50%);
		border: 0;
		border-radius: 0;
		background: transparent;
		cursor: pointer;
	}
	.year-target:hover { background: rgba(19, 90, 225, 0.12); }
	.year-target:focus-visible {
		outline: 2px solid #135ae1;
		outline-offset: 1px;
		background: rgba(19, 90, 225, 0.12);
	}

	.popup {
		position: absolute;
		z-index: 8;
		width: min(330px, calc(100vw - 34px));
		max-height: 430px;
		padding: 0 16px 16px;
		transform: translate(-50%, calc(-100% - 15px));
		border: 1px solid rgba(0, 0, 0, 0.16);
		background: rgba(255, 255, 255, 0.99);
		box-shadow: 0 14px 36px rgba(0, 0, 0, 0.2);
		overflow-y: auto;
		font: 400 12px/1.45 "Inter", sans-serif;
	}
	.popup.below { transform: translate(-50%, 15px); }
	.popup header {
		display: flex;
		align-items: start;
		justify-content: space-between;
		gap: 14px;
		margin: 0 -16px 14px;
		padding: 12px 10px 12px 16px;
		border-top: 6px solid #135ae1;
		color: #fff;
		background: #222;
	}
	.popup header div { display: grid; gap: 3px; }
	.popup header strong { font-size: 14px; }
	.popup header span { color: #a7abaf; font-weight: 600; }
	.popup header button {
		display: grid;
		place-items: center;
		width: 30px;
		height: 30px;
		padding: 0;
		border: 0;
		color: #fff;
		background: transparent;
		font: 400 22px/1 "Inter", sans-serif;
		cursor: pointer;
	}
	.popup header button:hover,
	.popup header button:focus-visible {
		color: #000;
		background: #fff;
		outline: none;
	}
	.popup dl { display: grid; gap: 8px; margin: 0; }
	.popup dl div {
		display: grid;
		grid-template-columns: minmax(0, 1fr) auto;
		gap: 14px;
	}
	.popup dt { font-weight: 600; }
	.popup dd {
		max-width: 150px;
		margin: 0;
		text-align: right;
		font-variant-numeric: tabular-nums;
	}
	.events {
		margin-top: 13px;
		padding-top: 12px;
		border-top: 1px solid #a7abaf;
	}
	.events > strong { font-size: 12px; }
	.events ul {
		display: grid;
		gap: 7px;
		margin: 9px 0 0;
		padding-left: 17px;
	}
	.events p { margin: 8px 0 0; color: #4a4a4a; }

	.note,
	.source {
		max-width: 840px;
		margin: 18px 0 0;
		color: #4a4a4a;
		font: 400 12px/1.45 "Inter", sans-serif;
	}
	.source { margin-top: 4px; }
	.source a {
		color: #057dbc;
		text-underline-offset: 3px;
	}

	@media (max-width: 900px) {
		.chart-grid { grid-template-columns: repeat(3, minmax(0, 1fr)); }
	}
	@media (max-width: 650px) {
		.chart-grid {
			grid-template-columns: repeat(2, minmax(0, 1fr));
			gap: 34px 12px;
		}
		h6 { font-size: 13px; }
		.x-label,
		.y-label { font-size: 11px; }
	}
	@media (max-width: 420px) {
		.chart-grid { grid-template-columns: 1fr; }
		h6 {
			min-height: 0;
			font-size: 16px;
		}
	}
</style>
