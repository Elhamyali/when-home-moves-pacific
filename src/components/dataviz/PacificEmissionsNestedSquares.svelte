<script>
	import { format, scaleSqrt, sum } from "d3";
	import emissionsRows from "$data/pacific_and_major_emitters_2023.csv";

	const sourceUrl = "https://www.climatewatchdata.org/";
	const colors = {
		China: "#135ae1",
		"United States": "#2197ff",
		Australia: "#09aa64",
		"New Zealand": "#f2b90f",
		"Pacific islands": "#f54e8b",
		Fiji: "#058896",
		Kiribati: "#fa6502",
		Tuvalu: "#9852d9"
	};
	const rows = emissionsRows
		.map((row) => ({
			country: row.country,
			value: +row.emissions_mtco2e,
			share: +row.global_share_pct
		}))
		.sort((a, b) => b.value - a.value);
	const pacificNames = new Set(["Fiji", "Kiribati", "Tuvalu"]);
	const pacificRows = rows.filter((row) => pacificNames.has(row.country));
	const pacificTotal = {
		country: "Pacific islands",
		value: sum(pacificRows, (row) => row.value),
		share: sum(pacificRows, (row) => row.share)
	};
	const comparisonRows = [
		...rows.filter((row) => !pacificNames.has(row.country)),
		pacificTotal
	];
	const mainSize = 520;
	const detailSize = 250;
	const mainSide = scaleSqrt()
		.domain([0, comparisonRows[0].value])
		.range([0, mainSize]);
	const detailSide = scaleSqrt()
		.domain([0, pacificRows[0].value])
		.range([0, detailSize]);
	const valueFormat = format(",.2f");

	function displayValue(value) {
		return `${valueFormat(value)} MtCO₂e`;
	}
</script>

<figure
	id="pacific-emissions-comparison"
	class="emissions-viz"
	aria-labelledby="emissions-title emissions-subtitle"
>
	<header class="viz-heading">
		<h5 id="emissions-title">
			How do Pacific Island emissions compare with major emitters?
		</h5>
		<p id="emissions-subtitle">
			Greenhouse gas emissions in 2023, in million tonnes of CO₂ equivalent.
			Square area represents emissions; the Pacific detail is enlarged.
		</p>
	</header>

	<div class="chart-grid">
		<section class="panel main-panel" aria-label="Emissions comparison">
			<svg
				viewBox="0 0 760 560"
				role="img"
				aria-label="Nested squares compare emissions from China, the United States, Australia, New Zealand, and the combined total for Fiji, Kiribati, and Tuvalu."
			>
				{#each comparisonRows as row, index}
					{@const side = mainSide(row.value)}
					{@const y = 24 + mainSize - side}
					<rect
						x="16"
						{y}
						width={side}
						height={side}
						fill={colors[row.country]}
						stroke={row.country === "Pacific islands" ? "#111" : "#fff"}
						stroke-width={row.country === "Pacific islands" ? 1.5 : 1}
					>
						<title>{row.country}: {displayValue(row.value)}</title>
					</rect>
					{#if index < 2}
						<text
							x="30"
							y={y + 27}
							class:light-label={index < 2}
							class="square-label">{row.country}</text
						>
						<text
							x={16 + side - 14}
							y={y + 27}
							text-anchor="end"
							class:light-label={index < 2}
							class="square-value">{displayValue(row.value)}</text
						>
					{/if}
				{/each}

				<line x1="131" y1="430" x2="560" y2="348" class="callout-line" />
				<text x="575" y="336" class="callout-country">Australia</text>
				<text x="575" y="358" class="callout-value">651.66 MtCO₂e</text>

				<line x1="55" y1="514" x2="560" y2="430" class="callout-line" />
				<circle cx="55" cy="514" r="4" fill={colors["New Zealand"]} />
				<text x="575" y="418" class="callout-country">New Zealand</text>
				<text x="575" y="440" class="callout-value">69.96 MtCO₂e</text>

				<line x1="18" y1="541" x2="560" y2="500" class="callout-line" />
				<circle cx="18" cy="541" r="3.5" fill={colors["Pacific islands"]} />
				<text x="575" y="488" class="callout-country">Pacific islands</text>
				<text x="575" y="510" class="callout-value">0.63 MtCO₂e combined</text>
			</svg>
			<ul class="main-key" aria-label="Emissions comparison values">
				{#each comparisonRows as row}
					<li>
						<span style:background={colors[row.country]}></span>
						<strong>{row.country}</strong>
						<em>{valueFormat(row.value)} MtCO₂e</em>
					</li>
				{/each}
			</ul>
		</section>

		<section class="panel detail-panel" aria-labelledby="pacific-detail-label">
			<div class="panel-heading">
				<h6 id="pacific-detail-label">Pacific detail</h6>
				<p>Enlarged view of Fiji, Kiribati and Tuvalu.</p>
			</div>
			<svg
				viewBox="0 0 320 340"
				role="img"
				aria-label="Enlarged nested squares compare emissions from Fiji, Kiribati, and Tuvalu."
			>
				{#each pacificRows as row, index}
					{@const side = detailSide(row.value)}
					{@const y = 20 + detailSize - side}
					<rect
						x="20"
						{y}
						width={side}
						height={side}
						fill={colors[row.country]}
						stroke="#fff"
						stroke-width="1"
					>
						<title>{row.country}: {displayValue(row.value)}</title>
					</rect>
					{#if index < 2}
						<text
							x="30"
							y={y + 25}
							class:light-label={index === 0}
							class="detail-country">{row.country}</text
						>
						<text
							x={20 + side - 10}
							y={y + 25}
							text-anchor="end"
							class:light-label={index === 0}
							class="detail-value">{valueFormat(row.value)}</text
						>
					{/if}
				{/each}
			</svg>
			<ul class="detail-key" aria-label="Pacific emissions values">
				{#each pacificRows as row}
					<li>
						<span style:background={colors[row.country]}></span>
						<strong>{row.country}</strong>
						<em>{valueFormat(row.value)} MtCO₂e</em>
					</li>
				{/each}
			</ul>
		</section>
	</div>

	<table class="sr-only">
		<caption>Greenhouse gas emissions in 2023</caption>
		<thead>
			<tr><th>Country</th><th>Million tonnes CO₂ equivalent</th></tr>
		</thead>
		<tbody>
			{#each rows as row}
				<tr><th>{row.country}</th><td>{valueFormat(row.value)}</td></tr>
			{/each}
		</tbody>
	</table>

	<figcaption>
		Source: <a href={sourceUrl} target="_blank" rel="noreferrer"
			>Climate Watch</a
		>.
	</figcaption>
</figure>

<style>
	.emissions-viz {
		width: min(1120px, calc(100% - 48px));
		margin: clamp(52px, 8vw, 96px) auto;
		font-family: "Inter", sans-serif;
		color: #111;
	}

	.viz-heading h5 {
		margin: 0;
		font:
			700 clamp(18px, 2vw, 24px) / 1.2 "Inter",
			sans-serif;
		letter-spacing: -0.02em;
	}

	.viz-heading p {
		max-width: 880px;
		margin: 8px 0 0;
		font-size: clamp(14px, 1.4vw, 17px);
		line-height: 1.55;
		color: #555;
	}

	.chart-grid {
		display: grid;
		grid-template-columns: minmax(0, 2fr) minmax(250px, 0.9fr);
		gap: 32px;
		align-items: start;
		margin-top: 32px;
	}

	.panel-heading h6 {
		margin: 0;
		font-size: 13px;
		line-height: 1.2;
		letter-spacing: 0.1em;
		text-transform: uppercase;
	}

	.panel-heading p {
		margin: 5px 0 14px;
		font-size: 12px;
		line-height: 1.4;
		color: #666;
	}

	.main-panel {
		padding-top: 49px;
	}

	svg {
		display: block;
		width: 100%;
		height: auto;
		overflow: visible;
	}

	text {
		font-family: "Inter", sans-serif;
		fill: #111;
	}

	.square-label,
	.square-value {
		font-size: 15px;
		font-weight: 700;
	}

	.light-label {
		fill: #fff;
	}

	.callout-line {
		stroke: #111;
		stroke-width: 1;
	}

	.callout-country {
		font-size: 16px;
		font-weight: 700;
	}

	.callout-value {
		font-size: 14px;
		fill: #555;
	}

	.detail-country,
	.detail-value {
		font-size: 13px;
		font-weight: 700;
	}

	.main-key,
	.detail-key {
		display: grid;
		gap: 7px;
		margin: -4px 0 0;
		padding: 0;
		list-style: none;
		font-size: 12px;
	}

	.main-key {
		display: none;
	}

	.main-key li,
	.detail-key li {
		display: grid;
		grid-template-columns: 10px 1fr auto;
		gap: 7px;
		align-items: center;
	}

	.main-key span,
	.detail-key span {
		width: 10px;
		height: 10px;
	}

	.main-key strong,
	.detail-key strong {
		font-weight: 600;
	}

	.main-key em,
	.detail-key em {
		font-style: normal;
		color: #555;
	}

	figcaption {
		margin-top: 18px;
		font-size: 12px;
		line-height: 1.45;
		color: #555;
	}

	figcaption a {
		color: #057dbc;
		text-decoration: underline;
		text-underline-offset: 2px;
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

	@media (max-width: 760px) {
		.emissions-viz {
			width: min(100% - 28px, 620px);
		}

		.chart-grid {
			grid-template-columns: 1fr;
			gap: 34px;
		}

		.detail-panel {
			width: min(100%, 420px);
		}

		.main-panel {
			padding-top: 0;
		}

		.main-key {
			display: grid;
			margin-top: 12px;
		}
	}
</style>
