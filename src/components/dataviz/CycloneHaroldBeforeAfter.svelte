<script>
	import { base } from "$app/paths";
	import { onMount } from "svelte";
	import { drag, select } from "d3";

	let comparison;
	let position = $state(50);

	function setPosition(x) {
		position = Math.max(0, Math.min(100, (x / comparison.clientWidth) * 100));
	}

	function handleKeydown(event) {
		const amount = event.shiftKey ? 10 : 2;
		if (event.key === "ArrowLeft") {
			event.preventDefault();
			position = Math.max(0, position - amount);
		}
		if (event.key === "ArrowRight") {
			event.preventDefault();
			position = Math.min(100, position + amount);
		}
		if (event.key === "Home") position = 0;
		if (event.key === "End") position = 100;
	}

	onMount(() => {
		const dragBehavior = drag().container(() => comparison).on("start drag", (event) => setPosition(event.x));
		select(comparison).selectAll(".interaction-surface, .handle").call(dragBehavior);
	});
</script>

<figure class="before-after">
	<figcaption>
		<h5>Extensive damage on Tongatapu and 'Eua coastlines caused by Severe Tropical Cyclone Harold in 2020</h5>
		<p>Before and after satellite images. Drag the handle, or focus it and use the arrow keys, to compare the images.</p>
	</figcaption>

	<div class="comparison" bind:this={comparison} style={`--position:${position}%`}>
		<img class="after" src={`${base}/assets/dataviz/cyclone-harold/after.avif`} alt="After Severe Tropical Cyclone Harold: eroded coastline, storm-surge extent, debris and a potentially damaged building" />
		<img class="before" src={`${base}/assets/dataviz/cyclone-harold/before.avif`} alt="Before Severe Tropical Cyclone Harold: intact vegetation, buildings and coastline" />
		<div class="divider" aria-hidden="true"></div>
		<button
			class="handle"
			type="button"
			role="slider"
			aria-label="Reveal before and after satellite imagery"
			aria-valuemin="0"
			aria-valuemax="100"
			aria-valuenow={Math.round(position)}
			onkeydown={handleKeydown}
		>
			<span aria-hidden="true">‹ ›</span>
		</button>
		<div class="interaction-surface" aria-hidden="true"></div>
	</div>

	<p class="source">Source: <a href="https://matangitonga.to/2020/04/15/satellite-tc-harold" target="_blank" rel="noreferrer">Matangi Tonga</a>; <a href="https://unosat.org/products/2824" target="_blank" rel="noreferrer">UNITAR / UNOSAT</a>.</p>
</figure>

<style>
	.before-after { width: min(100%,820px); margin: clamp(64px,8vw,104px) auto clamp(42px,5vw,68px); font-family: "Inter",sans-serif; }
	figcaption { margin-bottom: 24px; }
	h5 { max-width: 900px; margin: 0; font: 700 clamp(18px,2vw,24px)/1.25 "Inter",sans-serif; letter-spacing: -.02em; }
	figcaption p { margin: 8px 0 0; color: #444; font: 400 clamp(15px,1.6vw,19px)/1.4 "Inter",sans-serif; }
	.comparison { position: relative; width: 100%; aspect-ratio: 956/964; overflow: hidden; background: #eee; touch-action: none; user-select: none; }
	.comparison img { position: absolute; inset: 0; width: 100%; height: 100%; object-fit: cover; object-position: center; }
	.comparison .before { z-index: 1; clip-path: inset(0 calc(100% - var(--position)) 0 0); }
	.divider { position: absolute; z-index: 2; top: 0; bottom: 0; left: var(--position); width: 4px; transform: translateX(-50%); background: #fff; box-shadow: 0 0 0 1px rgba(0,0,0,.12); pointer-events: none; }
	.handle { position: absolute; z-index: 4; top: 50%; left: var(--position); display: grid; place-items: center; width: 58px; height: 58px; padding: 0; transform: translate(-50%,-50%); border: 1px solid rgba(0,0,0,.16); border-radius: 50%; color: #333; background: #fff; box-shadow: 0 5px 18px rgba(0,0,0,.2); font: 700 24px/1 "Inter",sans-serif; cursor: ew-resize; }
	.handle:focus-visible { outline: 3px solid #135ae1; outline-offset: 3px; }
	.interaction-surface { position: absolute; z-index: 3; inset: 0; cursor: ew-resize; }
	.source { margin: 10px 0 0; color: #666; font: 400 12px/1.5 "Inter",sans-serif; }
	.source a { color: #057dbc; text-underline-offset: 3px; }
	@media(max-width:700px){
		.before-after { width: calc(100% + 40px); margin-left: -20px; }
		figcaption,.source { padding-inline: 20px; }
		.handle { width: 50px; height: 50px; font-size: 21px; }
	}
</style>
