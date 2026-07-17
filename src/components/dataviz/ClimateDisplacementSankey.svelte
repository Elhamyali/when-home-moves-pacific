<script>
	import { onMount } from "svelte";
	import * as d3 from "d3";
	import { sankey, sankeyJustify, sankeyLinkHorizontal } from "d3-sankey";
	import Scrolly from "$components/helpers/Scrolly.svelte";
	import flows from "$data/climate_disaster_displacement_sankey_flows.csv";

	let container;
	let svg;
	let tooltip;
	let tooltipContent = $state("");
	let tooltipVisible = $state(false);
	let tooltipX = $state(0);
	let tooltipY = $state(0);
	let activeStep = $state(0);
	let redraw = () => {};

	const steps = [
		{
			source: "Climate / weather-related disasters",
			target: "Hazard type: Storm"
		},
		{
			source: "Hazard type: Storm",
			target: "Hazard subtype: Typhoon/Hurricane/Cyclone"
		},
		{
			source: "Hazard type: Storm",
			target: "Hazard subtype: Typhoon/Hurricane/Cyclone"
		},
		{
			source: "Hazard type: Flood",
			target: "Hazard subtype: Flood"
		}
	];

	const format = d3.format(",");
	const sourceUrl = "https://stats.pacificdata.org/vis?lc=en&df[ds]=ds%3ASPC2&df[id]=DF_SDG_11&df[ag]=SPC&df[vs]=3.0&dq=A.VC_DSR_AFFCT.........&pd=,&to[TIME_PERIOD]=false&lb=bt";
	const colors = {
		impact: "#135ae1",
		displacement: "#9852d9",
		geophysical: "#fa6502",
		climate: "#09aa64",
		earthquake: "#f2b90f",
		volcanic: "#808080",
		drought: "#f2b90f",
		flood: "#2197ff",
		mass: "#a7abaf",
		storm: "#f54e8b",
		wave: "#058896",
		wildfire: "#de2c35"
	};

	function group(name) {
		if (name.startsWith("Climate-driven")) return "impact";
		if (name.startsWith("907,531")) return "displacement";
		if (name === "Geophysical disasters") return "geophysical";
		if (name === "Climate / weather-related disasters") return "climate";
		if (name.includes("Earthquake")) return "earthquake";
		if (name.includes("Volcanic")) return "volcanic";
		if (name.includes("Drought")) return "drought";
		if (name.includes("Flood")) return "flood";
		if (name.includes("Mass Movement") || name.includes("Landslide")) return "mass";
		if (name.includes("Storm") || name.includes("Typhoon")) return "storm";
		if (name.includes("Wave")) return "wave";
		if (name.includes("Wildfire")) return "wildfire";
		return "displacement";
	}

	function label(name) {
		if (name.startsWith("Climate-driven")) return "People affected by disasters";
		if (name.startsWith("907,531")) return "Internal displacement movements";
		return name.replace("Hazard type: ", "").replace("Hazard subtype: ", "");
	}

	function valueLabel(node) {
		if (node.name.startsWith("Climate-driven")) return "2,588,223 people";
		if (node.name.startsWith("907,531")) return "907,531 movements";
		return node.value >= 5_000 ? `${format(Math.round(node.value))} movements` : "";
	}

	function wrap(selection, width) {
		selection.each(function () {
			const text = d3.select(this);
			const words = text.text().split(/\s+/);
			const x = text.attr("x");
			const y = text.attr("y");
			let line = [];
			let lineNumber = 0;
			let tspan = text.text(null).append("tspan").attr("x", x).attr("y", y);
			for (const word of words) {
				line.push(word);
				tspan.text(line.join(" "));
				if (tspan.node().getComputedTextLength() > width && line.length > 1) {
					line.pop();
					tspan.text(line.join(" "));
					line = [word];
					tspan = text.append("tspan").attr("x", x).attr("y", y).attr("dy", `${++lineNumber * 1.16}em`).text(word);
				}
			}
		});
	}

	function showTooltip(event, html) {
		const bounds = container.getBoundingClientRect();
		tooltipContent = html;
		tooltipX = Math.max(118, Math.min(bounds.width - 118, event.clientX - bounds.left));
		tooltipY = Math.max(92, event.clientY - bounds.top);
		tooltipVisible = true;
	}

	function render() {
		const width = Math.max(320, container.clientWidth);
		const compact = width < 720;
		const height = compact ? 850 : 720;
		const margin = compact
			? { top: 58, right: 88, bottom: 28, left: 88 }
			: { top: 70, right: 180, bottom: 34, left: 180 };
		const links = flows.map((d) => ({ source: d.source, target: d.target, value: +d.value }));
		const names = [...new Set(links.flatMap((d) => [d.source, d.target]))];
		const graph = {
			nodes: names.map((name) => ({ name, group: group(name) })),
			links
		};

		const layout = sankey()
			.nodeId((d) => d.name)
			.nodeWidth(compact ? 10 : 14)
			.nodePadding(compact ? 12 : 16)
			.nodeAlign(sankeyJustify)
			.extent([[margin.left, margin.top], [width - margin.right, height - margin.bottom]]);
		layout(graph);

		const chart = d3.select(svg).attr("viewBox", `0 0 ${width} ${height}`);
		chart.selectAll("*").remove();

		const columns = [
			["Impact", (d) => d.name.startsWith("Climate-driven")],
			["Displacement", (d) => d.name.startsWith("907,531")],
			["Hazard family", (d) => d.name.endsWith("disasters") && !d.name.startsWith("Climate-driven")],
			["Hazard type", (d) => d.name.startsWith("Hazard type:")],
			["Hazard subtype", (d) => d.name.startsWith("Hazard subtype:")]
		].map(([text, match]) => ({ text, x: d3.mean(graph.nodes.filter(match), (d) => d.x0) }));

		chart.append("g").selectAll("text").data(columns).join("text")
			.attr("class", "column-label").attr("x", (d) => d.x).attr("y", 25)
			.attr("text-anchor", "middle").text((d) => d.text);

		const link = chart.append("g").attr("fill", "none").selectAll("path").data(graph.links).join("path")
			.attr("class", "flow").attr("d", sankeyLinkHorizontal())
			.attr("stroke", (d) => colors[group(d.target.name)]).attr("stroke-width", (d) => Math.max(1, d.width))
			.attr("stroke-opacity", 0.34);

		const node = chart.append("g").selectAll("g").data(graph.nodes).join("g").attr("class", "node");
		node.append("rect").attr("x", (d) => d.x0).attr("y", (d) => d.y0)
			.attr("width", (d) => d.x1 - d.x0).attr("height", (d) => Math.max(1, d.y1 - d.y0))
			.attr("fill", (d) => colors[d.group]).attr("stroke", (d) => d3.color(colors[d.group]).darker(0.45));

		function labelX(d) { return d.x0 < width / 2 ? d.x0 - 8 : d.x1 + 8; }
		function anchor(d) { return d.x0 < width / 2 ? "end" : "start"; }
		const labels = node.append("text").attr("class", "node-label").attr("x", labelX)
			.attr("y", (d) => (d.y0 + d.y1) / 2 - 7).attr("text-anchor", anchor).text((d) => label(d.name));
		labels.call(wrap, compact ? 76 : 150);
		node.append("text").attr("class", "node-value").attr("x", labelX)
			.attr("y", (d) => (d.y0 + d.y1) / 2 + 17).attr("text-anchor", anchor).text(valueLabel);

		function applyStep() {
			if ((activeStep ?? 0) === 0) {
				link.attr("stroke-opacity", 0.34);
				node.attr("opacity", 1);
				return;
			}
			const step = steps[(activeStep ?? 1) - 1] ?? steps[0];
			const activeLink = graph.links.find((d) => d.source.name === step.source && d.target.name === step.target);
			if (!activeLink) return;
			link.attr("stroke-opacity", (d) => d === activeLink ? 0.82 : 0.075);
			node.attr("opacity", (d) => d === activeLink.source || d === activeLink.target ? 1 : 0.16);
		}

		redraw = applyStep;
		applyStep();

		link.on("pointerenter", function (event, d) {
			link.attr("stroke-opacity", (item) => item === d ? 0.78 : 0.06);
			node.attr("opacity", (item) => item === d.source || item === d.target ? 1 : 0.2);
			showTooltip(event, `<strong>${label(d.source.name)} → ${label(d.target.name)}</strong><span>${format(d.value)} displacement movements</span>`);
		}).on("pointermove", (event, d) => showTooltip(event, `<strong>${label(d.source.name)} → ${label(d.target.name)}</strong><span>${format(d.value)} displacement movements</span>`));

		node.on("pointerenter", function (event, d) {
			const related = new Set([...d.sourceLinks, ...d.targetLinks]);
			link.attr("stroke-opacity", (item) => related.has(item) ? 0.72 : 0.06);
			node.attr("opacity", (item) => item === d || related.has(item.sourceLinks?.[0]) || related.has(item.targetLinks?.[0]) ? 1 : 0.24);
			showTooltip(event, `<strong>${label(d.name)}</strong><span>${format(Math.round(d.value))} displacement movements</span>`);
		}).on("pointermove", (event, d) => showTooltip(event, `<strong>${label(d.name)}</strong><span>${format(Math.round(d.value))} displacement movements</span>`));

		chart.on("pointerleave", () => {
			applyStep();
			tooltipVisible = false;
		});
	}

	$effect(() => {
		activeStep;
		redraw();
	});

	onMount(() => {
		const observer = new ResizeObserver(render);
		observer.observe(container);
		render();
		return () => observer.disconnect();
	});
</script>

<figure class="sankey-figure">
	<figcaption>
		<h5>The disasters driving displacement movements</h5>
		<p class="dek">Follow 907,531 recorded internal displacement movements through hazard families, types, and subtypes. Scroll to explore.</p>
	</figcaption>
	<div class="scrolly">
		<div class="chart" bind:this={container}>
			<svg bind:this={svg} role="img" aria-label="Sankey diagram tracing Pacific disaster displacement movements from disaster impact through hazard families, types, and subtypes"></svg>
			<div bind:this={tooltip} class:visible={tooltipVisible} class="tooltip" style={`left:${tooltipX}px;top:${tooltipY}px`} aria-hidden={!tooltipVisible}>
				{@html tooltipContent}
			</div>
		</div>
		<div class="steps">
			<Scrolly bind:value={activeStep} top={120} bottom={120}>
				<section class="graph-intro" aria-label="Full Sankey diagram">
					<p>Scroll to explore the pathways</p>
				</section>
				<section class="step" class:active={activeStep === 1} aria-label="Step 1 of 4">
					<div class="step-card"><p>Between 2018 and 2025, storms caused significantly more flight than floods or earthquakes.</p></div>
				</section>
				<section class="step" class:active={activeStep === 2} aria-label="Step 2 of 4">
					<div class="step-card"><p>Within this category, typhoons, hurricanes, and cyclones form the leading hazard subtype for displacements. Tropical cyclones dominate the flow through nearly every country in the region.</p></div>
				</section>
				<section class="step" class:active={activeStep === 3} aria-label="Step 3 of 4">
					<div class="step-card"><p>A few catastrophic cyclones account for a disproportionate share of this total, most notably Cyclone Winston in Fiji in 2016.</p></div>
				</section>
				<section class="step" class:active={activeStep === 4} aria-label="Step 4 of 4">
					<div class="step-card"><p>Floods, the second-leading driver, caused 227,226 movements across 71 events. They leave a lingering aftermath of contaminated freshwater supplies, destroyed crops, and waterlogged soils.</p></div>
				</section>
			</Scrolly>
		</div>
	</div>
	<p class="note">The disaster affected-population total and displacement total measure different things: displacement data count movements, not unique people.</p>
	<p class="source">Source: <a href={sourceUrl} target="_blank" rel="noreferrer">Pacific Data Hub</a>; <a href="https://www.internal-displacement.org/" target="_blank" rel="noreferrer">Internal Displacement Monitoring Centre (IDMC)</a>.</p>
</figure>

<style>
	.sankey-figure { width: min(1400px, calc(100vw - clamp(32px,6vw,96px))); max-width: none; margin: clamp(64px,8vw,104px) 0 clamp(42px,5vw,68px); margin-left: 50%; padding: clamp(24px,3vw,44px); transform: translateX(calc(-50% - 36px)); background: #fff; font-family: "Inter",sans-serif; }
	figcaption { width: min(calc(100% - 360px),760px); margin: 0 0 34px 180px; }
	h5 { margin: 0; font: 700 clamp(18px,2vw,24px)/1.2 "Inter",sans-serif; letter-spacing: -.02em; }
	.dek { max-width: 650px; margin: 16px 0 0; color: #555; font: 400 15px/1.55 "Inter",sans-serif; }
	.scrolly { position: relative; }
	.steps { position: relative; z-index: 2; margin-top: -90vh; pointer-events: none; }
	.graph-intro { display: flex; align-items: flex-end; justify-content: center; min-height: 112vh; padding-bottom: 12vh; }
	.graph-intro p { margin: 0; padding: 9px 13px; color: #666; background: rgba(255,255,255,.9); font: 600 11px/1 "Inter",sans-serif; letter-spacing: .08em; text-transform: uppercase; }
	.step { display: flex; align-items: center; justify-content: center; min-height: 92vh; opacity: .42; transition: opacity 220ms ease; }
	.step.active { opacity: 1; }
	.step-card { width: min(100% - 32px,560px); padding: clamp(22px,3vw,34px); border: 1px solid rgba(0,0,0,.14); border-radius: 10px; background: rgba(255,255,255,.96); box-shadow: 0 14px 42px rgba(0,0,0,.16); transition: opacity 220ms ease; pointer-events: auto; }
	.step-card span { display: block; margin-bottom: 14px; color: #777; font: 700 10px/1 "Inter",sans-serif; letter-spacing: .14em; }
	.step-card p { margin: 0; text-align: center; font: 500 clamp(17px,1.7vw,23px)/1.48 "Inter",sans-serif; letter-spacing: -.012em; }
	.step-card strong { font-weight: 700; }
	.step-card a { color: #057dbc; text-underline-offset: 3px; }
	.chart { position: sticky; z-index: 0; top: 5vh; width: 100%; min-width: 0; height: 90vh; overflow: hidden; }
	svg { display: block; width: 100%; min-height: 720px; overflow: visible; }
	:global(.column-label) { fill: #777; font: 700 9px/1 "Inter",sans-serif; letter-spacing: .12em; text-transform: uppercase; }
	:global(.flow) { cursor: pointer; mix-blend-mode: multiply; transition: stroke-opacity 140ms ease; }
	:global(.node) { cursor: pointer; transition: opacity 140ms ease; }
	:global(.node rect) { stroke-width: .8px; }
	:global(.node-label) { fill: #111; font: 600 11px/1 "Inter",sans-serif; pointer-events: none; }
	:global(.node-value) { fill: #777; font: 500 9px/1 "Inter",sans-serif; pointer-events: none; }
	.tooltip { position: absolute; z-index: 2; width: min(250px,calc(100% - 20px)); padding: 11px 13px; transform: translate(-50%,calc(-100% - 12px)); border: 1px solid #111; background: rgba(255,255,255,.97); box-shadow: 0 12px 30px rgba(0,0,0,.12); opacity: 0; pointer-events: none; font: 500 12px/1.4 "Inter",sans-serif; }
	.tooltip.visible { opacity: 1; }
	:global(.tooltip strong), :global(.tooltip span) { display: block; }
	:global(.tooltip span) { margin-top: 4px; color: #666; }
	.note,.source { width: min(calc(100% - 360px),760px); margin: 16px 0 0 180px; color: #666; font: 400 12px/1.5 "Inter",sans-serif; }
	.source { margin-top: 6px; }
	.source a { color: #057dbc; text-underline-offset: 3px; }
	@media(max-width:700px){
		.sankey-figure { width: 100vw; margin-left: 50%; padding-inline: 12px; transform: translateX(-50%); }
		figcaption { width: calc(100% - 32px); margin-left: 16px; padding: 0; }
		.chart { position: sticky; z-index: 0; top: 8vh; width: 100%; height: 84vh; }
		.steps { position: relative; z-index: 2; margin-top: -84vh; pointer-events: none; }
		.graph-intro { min-height: 105vh; padding-bottom: 10vh; }
		.step { min-height: 88vh; padding: 0 8px; opacity: 1; }
		.step-card { width: min(100%,430px); margin: 0 auto; padding: 20px; border-radius: 8px; background: rgba(255,255,255,.96); box-shadow: 0 10px 30px rgba(0,0,0,.15); pointer-events: auto; }
		.step-card p { font-size: 16px; line-height: 1.5; }
		svg { min-height: 760px; }
		:global(.column-label) { font-size: 7px; letter-spacing: .05em; }
		:global(.node-label) { font-size: 8px; }
		:global(.node-value) { font-size: 7px; }
		.note,.source { width: calc(100% - 32px); margin-left: 16px; }
	}
	@media(prefers-reduced-motion:reduce){.step,.step-card{transition:none}}
</style>
