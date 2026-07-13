<script>
	import { onMount } from "svelte";
	import { format, interpolateNumber, timer } from "d3";

	const target = 2588223;
	const formatNumber = format(",d");
	let value = $state(0);
	let container;
	let hasAnimated = false;

	onMount(() => {
		const reduceMotion = window.matchMedia("(prefers-reduced-motion: reduce)").matches;
		if (reduceMotion) {
			value = target;
			return;
		}

		const observer = new IntersectionObserver(
			([entry]) => {
				if (!entry.isIntersecting || hasAnimated) return;
				hasAnimated = true;
				const interpolate = interpolateNumber(0, target);
				const duration = 2200;
				const animation = timer((elapsed) => {
					const t = Math.min(1, elapsed / duration);
					const eased = 1 - Math.pow(1 - t, 4);
					value = Math.round(interpolate(eased));
					if (t === 1) animation.stop();
				});
				observer.disconnect();
			},
			{ threshold: 0.45 }
		);

		observer.observe(container);
		return () => observer.disconnect();
	});
</script>

<figure class="ticker" bind:this={container} aria-labelledby="ticker-description">
	<div class="number" aria-hidden="true">{formatNumber(value)}</div>
	<figcaption id="ticker-description">
		<strong>{formatNumber(target)}</strong> people were directly affected by disasters in the
		Pacific Islands.
	</figcaption>
	<p class="source">
		Source: <a href="https://pacificdata.org/" target="_blank" rel="noreferrer">Pacific Data Hub</a>,
		Number of directly affected persons attributed to disasters
	</p>
</figure>

<style>
	.ticker {
		margin: clamp(70px, 11vw, 150px) auto;
		padding: clamp(42px, 7vw, 92px) clamp(20px, 5vw, 72px);
		text-align: center;
		background: #fff;
	}

	.number {
		color: #2059df;
		font: 400 clamp(64px, 10vw, 148px)/.95 "Inter", sans-serif;
		font-variant-numeric: tabular-nums;
		letter-spacing: -.055em;
	}

	figcaption {
		max-width: 1100px;
		margin: clamp(24px, 4vw, 52px) auto 0;
		color: #303030;
		font: 400 clamp(38px, 6.3vw, 92px)/1.2 "Inter", sans-serif;
		letter-spacing: -.045em;
	}

	figcaption strong {
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

	.source {
		margin: clamp(34px, 5vw, 58px) auto 0;
		color: #393939;
		font: 400 clamp(12px, 1.4vw, 17px)/1.5 "Inter", sans-serif;
	}

	.source a { color: #057dbc; text-underline-offset: 3px; }
</style>
