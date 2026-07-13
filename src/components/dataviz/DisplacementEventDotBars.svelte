<script>
	import { onMount } from "svelte";
	import { format } from "d3";
	import events from "$data/internal_displacement_events_processed.csv";

	const colors = {
		Drought: "#135ae1",
		Earthquake: "#2197ff",
		Flood: "#9852d9",
		"Mass Movement": "#f54e8b",
		Storm: "#fa6502",
		"Volcanic activity": "#f2b90f",
		"Wave action": "#058896",
		Wildfire: "#09aa64"
	};
	const hazardTypes = Object.keys(colors);
	const rows = events.map((d, index) => ({
		...d,
		index,
		year: +d.year,
		displacements: +d.disaster_internal_displacements || 0
	}));
	const featuredEvent = rows.find((d) => d.country === "Fiji" && d.year === 2016 && d.event_name.toLowerCase().includes("winston"));
	const years = [Math.min(...rows.map((d) => d.year)), Math.max(...rows.map((d) => d.year))];
	const number = format(",");

	let selected = $state(new Set(hazardTypes));
	let selectedEvent = $state(featuredEvent);
	let tooltip = $state(null);
	let chartWidth = $state(960);
	let container;

	let filtered = $derived(rows.filter((d) => selected.has(d.hazard_type)));
	let countries = $derived.by(() => {
		const grouped = new Map();
		for (const event of filtered) {
			if (!grouped.has(event.country)) grouped.set(event.country, []);
			grouped.get(event.country).push(event);
		}
		return [...grouped].map(([country, countryEvents]) => ({ country, events: countryEvents }))
			.sort((a, b) => b.events.length - a.events.length || a.country.localeCompare(b.country));
	});

	const labelWidth = 205;
	const rowHeight = 42;
	const dotGap = 11;
	const chartHeight = $derived(Math.max(120, countries.length * rowHeight + 38));

	function toggleHazard(hazard) {
		if (selected.size === hazardTypes.length) selected = new Set([hazard]);
		else {
			const next = new Set(selected);
			if (next.has(hazard)) next.delete(hazard);
			else next.add(hazard);
			selected = next.size ? next : new Set(hazardTypes);
		}
		tooltip = null;
		selectedEvent = null;
	}

	function showAll() {
		selected = new Set(hazardTypes);
		tooltip = null;
		selectedEvent = null;
	}

	function showTooltip(event, datum) {
		if (selectedEvent && selectedEvent.index !== datum.index) return;
		const bounds = container.getBoundingClientRect();
		const targetBounds = event.currentTarget?.getBoundingClientRect();
		const clientX = Number.isFinite(event.clientX) ? event.clientX : targetBounds.left + targetBounds.width / 2;
		const clientY = Number.isFinite(event.clientY) ? event.clientY : targetBounds.top;
		tooltip = {
			datum,
			x: Math.max(145, Math.min(bounds.width - 145, clientX - bounds.left)),
			y: clientY - bounds.top,
			below: clientY - bounds.top < 330
		};
	}

	function selectDot(event, datum) {
		if (selectedEvent?.index === datum.index) {
			selectedEvent = null;
			tooltip = null;
			return;
		}
		selectedEvent = datum;
		tooltip = null;
		showTooltip(event, datum);
	}

	$effect(() => {
		countries;
		if (container) {
			const longest = Math.max(0, ...countries.map((d) => d.events.length));
			chartWidth = Math.max(760, container.clientWidth, labelWidth + longest * dotGap + 42);
		}
	});

	onMount(() => {
		const observer = new ResizeObserver(([entry]) => {
			const longest = Math.max(0, ...countries.map((d) => d.events.length));
			chartWidth = Math.max(760, entry.contentRect.width, labelWidth + longest * dotGap + 42);
		});
		observer.observe(container);
		const frame = requestAnimationFrame(() => {
			const dot = container.querySelector(`[data-event-index="${featuredEvent.index}"]`);
			if (!dot) return;
			const bounds = dot.getBoundingClientRect();
			showTooltip({ currentTarget: dot, clientX: bounds.left + bounds.width / 2, clientY: bounds.top + bounds.height / 2 }, featuredEvent);
		});
		return () => {
			cancelAnimationFrame(frame);
			observer.disconnect();
		};
	});
</script>

<figure class="dot-bars">
	<figcaption>
		<h5>A history of disaster displacement events and hazard types</h5>
		<p>Explore every recorded disaster that triggered internal displacement across Pacific countries from {years[0]}–{years[1]}. Hover or tap a dot for event details.</p>
	</figcaption>

	<div class="legend" aria-label="Filter by hazard type">
		<strong>Hazard type</strong>
		<button class:active={selected.size === hazardTypes.length} type="button" onclick={showAll}>All hazards</button>
		{#each hazardTypes as hazard}
			<button class:active={selected.has(hazard)} type="button" onclick={() => toggleHazard(hazard)} aria-pressed={selected.has(hazard)}>
				<span style={`--color:${colors[hazard]}`} aria-hidden="true"></span>{hazard}
			</button>
		{/each}
	</div>

	<div class="chart-scroll" bind:this={container} role="group" aria-label="Interactive displacement event dot bars" onpointerleave={() => { if (!selectedEvent) tooltip = null; }}>
		<svg viewBox={`0 0 ${chartWidth} ${chartHeight}`} role="img" aria-label="Horizontal dot bars showing individual internal displacement events by Pacific country, ordered from the most events to the fewest">
			{#each countries as country, countryIndex}
				<g transform={`translate(0,${countryIndex * rowHeight + 24})`}>
					<text class="country" x={labelWidth - 14} y="4" text-anchor="end">{country.country}</text>
					<line x1={labelWidth} x2={chartWidth - 18} y1="0" y2="0"></line>
					{#each country.events as event, eventIndex}
						<circle
							cx={labelWidth + 7 + eventIndex * dotGap}
							cy="0"
							r="4.5"
							fill={colors[event.hazard_type]}
							data-event-index={event.index}
							tabindex="0"
							role="button"
							class:selected={selectedEvent?.index === event.index}
							class:dimmed={selectedEvent && selectedEvent.index !== event.index}
							aria-label={`${event.country}, ${event.year}, ${event.hazard_type}, ${number(event.displacements)} internal displacements`}
							onpointerenter={(e) => showTooltip(e, event)}
							onpointermove={(e) => showTooltip(e, event)}
							onfocus={(e) => showTooltip(e, event)}
							onclick={(e) => selectDot(e, event)}
							onkeydown={(e) => {
								if (e.key === "Enter" || e.key === " ") {
									e.preventDefault();
									selectDot(e, event);
								}
								if (e.key === "Escape") {
									selectedEvent = null;
									tooltip = null;
								}
							}}
						></circle>
					{/each}
					<text class="count" x={chartWidth - 10} y="4" text-anchor="end">{country.events.length}</text>
				</g>
			{/each}
		</svg>

		{#if tooltip}
			<div class:below={tooltip.below} class="tooltip" style={`left:${tooltip.x}px;top:${tooltip.y}px`}>
				<strong class="tooltip-title" style={`--color:${colors[tooltip.datum.hazard_type]}`}>{tooltip.datum.hazard_type}</strong>
				<dl>
					<div><dt>Country</dt><dd>{tooltip.datum.country}</dd></div>
					<div><dt>Year</dt><dd>{tooltip.datum.year}</dd></div>
					<div><dt>Event name</dt><dd>{tooltip.datum.event_name || "Not reported"}</dd></div>
					<div><dt>Internal displacements</dt><dd>{number(tooltip.datum.displacements)}</dd></div>
					<div><dt>Hazard category</dt><dd>{tooltip.datum.hazard_category}</dd></div>
					<div><dt>Hazard subtype</dt><dd>{tooltip.datum.hazard_subtype || "Not reported"}</dd></div>
				</dl>
				{#if tooltip.datum.displacement_occurred}<p>{tooltip.datum.displacement_occurred}</p>{/if}
			</div>
		{/if}
	</div>

	<p class="note">Each dot represents one recorded disaster event. Country totals update with the selected hazard types.</p>
	<p class="source">Source: <a href="https://stats.pacificdata.org/vis?lc=en&df[ds]=ds%3ASPC2&df[id]=DF_SDG_11&df[ag]=SPC&df[vs]=3.0" target="_blank" rel="noreferrer">Pacific Data Hub</a>; <a href="https://www.internal-displacement.org/" target="_blank" rel="noreferrer">Internal Displacement Monitoring Centre (IDMC)</a>.</p>
</figure>

<style>
	.dot-bars { width: min(100%,1080px); margin: clamp(64px,8vw,104px) auto clamp(42px,5vw,68px); font-family: "Inter",sans-serif; }
	figcaption { max-width: 900px; }
	h5 { margin: 0; font: 700 clamp(18px,2vw,24px)/1.2 "Inter",sans-serif; letter-spacing: -.02em; }
	figcaption p { margin: 8px 0 0; color: #444; font: 400 clamp(15px,1.6vw,19px)/1.45 "Inter",sans-serif; }
	.legend { display: flex; flex-wrap: wrap; align-items: center; gap: 7px 8px; margin: 22px 0 24px; }
	.legend strong { margin-right: 4px; font: 700 13px/1 "Inter",sans-serif; text-transform: uppercase; letter-spacing: .06em; }
	.legend button { display: inline-flex; align-items: center; gap: 6px; min-height: 32px; padding: 5px 8px; border: 1px solid #ccc; border-radius: 3px; color: #555; background: #fff; font: 500 13px/1 "Inter",sans-serif; cursor: pointer; }
	.legend button.active { color: #111; border-color: #111; }
	.legend button:focus-visible { outline: 2px solid #135ae1; outline-offset: 2px; }
	.legend button span { width: 11px; height: 11px; border-radius: 2px; background: var(--color); }
	.chart-scroll { position: relative; width: 100%; overflow-x: auto; }
	svg { display: block; min-width: 760px; width: 100%; height: auto; }
	line { stroke: #e8e8e8; stroke-width: 1; }
	.country { fill: #222; font: 600 12px/1 "Inter",sans-serif; }
	.count { fill: #777; font: 500 10px/1 "Inter",sans-serif; }
	circle { cursor: pointer; stroke: #fff; stroke-width: 1.5; transition: r 100ms ease, opacity 140ms ease; }
	circle:hover,circle:focus { r: 7; stroke: #111; outline: none; }
	circle.selected { r: 7; stroke: #111; stroke-width: 2; opacity: 1; }
	circle.dimmed { opacity: .13; }
	.tooltip { position: absolute; z-index: 5; width: min(310px,calc(100vw - 32px)); padding: 0 14px 14px; transform: translate(-50%,calc(-100% - 13px)); border: 1px solid rgba(0,0,0,.14); background: rgba(255,255,255,.98); box-shadow: 0 12px 32px rgba(0,0,0,.18); pointer-events: none; font: 400 12px/1.4 "Inter",sans-serif; }
	.tooltip.below { transform: translate(-50%,13px); }
	.tooltip-title { display: block; margin: 0 -14px 12px; padding: 10px 14px; border-top: 5px solid var(--color); background: #222; color: #fff; font-size: 14px; }
	dl { display: grid; gap: 8px; margin: 0; }
	dl div { display: grid; grid-template-columns: 112px 1fr; gap: 8px; }
	dt { font-weight: 700; } dd { margin: 0; overflow-wrap: anywhere; }
	.tooltip p { margin: 11px 0 0; padding-top: 10px; border-top: 1px solid #ddd; color: #555; }
	.note,.source { max-width: 820px; margin: 12px 0 0; color: #666; font: 400 12px/1.5 "Inter",sans-serif; }
	.source { margin-top: 5px; }
	.source a { color: #057dbc; text-underline-offset: 3px; }
	@media(max-width:700px){
		.dot-bars { width: calc(100% + 40px); margin-left: -20px; }
		figcaption,.legend,.note,.source { padding-inline: 20px; }
		.legend { gap: 6px; }
		.legend button { font-size: 12px; }
	}
</style>
