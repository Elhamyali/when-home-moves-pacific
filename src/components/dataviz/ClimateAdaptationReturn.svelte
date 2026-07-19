<script>
	import { onMount } from "svelte";
	import { range } from "d3";

	const benefitUnits = range(10);
	let figure;
	let animationReady = $state(false);
	let revealedUnits = $state(11);
	const displayedReturn = $derived(
		revealedUnits < 11 ? `$${revealedUnits.toFixed(2)}` : "$10.50"
	);

	onMount(() => {
		if (window.matchMedia("(prefers-reduced-motion: reduce)").matches) return;

		animationReady = true;
		revealedUnits = 0;
		let hasPlayed = false;
		const timers = [];
		const observer = new IntersectionObserver(
			([entry]) => {
				if (!entry.isIntersecting || hasPlayed) return;
				hasPlayed = true;
				observer.disconnect();
				for (let step = 1; step <= 11; step += 1) {
					timers.push(
						window.setTimeout(() => {
							revealedUnits = step;
						}, step * 85)
					);
				}
			},
			{ threshold: 0.35 }
		);

		observer.observe(figure);
		return () => {
			observer.disconnect();
			timers.forEach(window.clearTimeout);
		};
	});
</script>

<figure
	bind:this={figure}
	id="climate-adaptation-return"
	class="adaptation-return"
	class:animation-ready={animationReady}
	aria-labelledby="adaptation-return-title adaptation-return-description"
>
	<figcaption>
		<h5 id="adaptation-return-title">
			Climate adaptation solutions pay dividends
		</h5>
		<p id="adaptation-return-description">
			Each 💵 represents US$1 USD; half a banknote represents 50 cents. Benefits
			include avoided losses, economic, social, and environmental gains.
		</p>
	</figcaption>

	<div
		class="comparison"
		role="img"
		aria-label="One US dollar invested in climate adaptation can yield more than 10 dollars and 50 cents in benefits over 10 years."
	>
		<section class="investment" aria-hidden="true">
			<p>Investment</p>
			<strong>$1</strong>
			<div class="unit">💵</div>
		</section>

		<div class="arrow" aria-hidden="true">→</div>

		<section class="benefits" aria-hidden="true">
			<p>Benefits over a 10-year period</p>
			<strong class="return-value">{displayedReturn}</strong>
			<div class="units">
				{#each benefitUnits as unit, index}
					<div class="unit benefit-unit" class:revealed={index < revealedUnits}>
						💵<span class="sr-only">${unit + 1}</span>
					</div>
				{/each}
				<div
					class="unit benefit-unit half"
					class:revealed={revealedUnits === 11}
				>
					💵<span class="sr-only">50 cents</span>
				</div>
			</div>
		</section>
	</div>

	<p class="source">
		Source: <a
			href="https://www.wri.org/research/climate-adaptation-investment-case"
			target="_blank"
			rel="noreferrer">World Resources Institute</a
		>
	</p>
</figure>

<style>
	.adaptation-return {
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
		color: #4a4a4a;
		font-size: 15px;
		line-height: 1.45;
	}

	.comparison {
		display: grid;
		grid-template-columns: minmax(130px, 0.48fr) auto minmax(280px, 1.52fr);
		gap: clamp(22px, 4vw, 54px);
		align-items: start;
	}

	section > p {
		margin: 0 0 8px;
		font:
			500 11px/1.2 "Inter",
			sans-serif;
		letter-spacing: 0.14em;
		text-transform: uppercase;
	}

	section > strong {
		display: block;
		margin-bottom: 22px;
		font:
			500 clamp(48px, 7vw, 86px) / 0.9 "Inter",
			sans-serif;
		letter-spacing: -0.045em;
	}

	.return-value {
		font-variant-numeric: tabular-nums;
	}

	.arrow {
		align-self: center;
		padding-top: 36px;
		color: var(--color-gray-500);
		font-size: clamp(24px, 3vw, 38px);
		line-height: 1;
	}

	.units {
		display: flex;
		flex-wrap: wrap;
		gap: clamp(6px, 1vw, 10px);
	}

	.unit {
		width: clamp(28px, 3.7vw, 44px);
		font-family: "Apple Color Emoji", "Segoe UI Emoji", sans-serif;
		font-size: clamp(25px, 3.3vw, 40px);
		line-height: 1;
	}

	.unit.half {
		clip-path: inset(0 50% 0 0);
	}

	.animation-ready .benefit-unit {
		opacity: 0;
		transform: translateY(4px);
		transition:
			opacity 180ms ease-out,
			transform 180ms ease-out;
	}

	.animation-ready .benefit-unit.revealed {
		opacity: 1;
		transform: translateY(0);
	}

	.source {
		margin: 6px 0 0;
		color: #4a4a4a;
		font-size: 12px;
		line-height: 1.45;
	}

	.source a {
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

	@media (max-width: 620px) {
		.comparison {
			grid-template-columns: 1fr;
			gap: 24px;
		}

		.arrow {
			justify-self: start;
			padding: 0;
			transform: rotate(90deg);
		}

		section > strong {
			margin-bottom: 16px;
		}
	}

	@media (prefers-reduced-motion: reduce) {
		.animation-ready .benefit-unit {
			opacity: 1;
			transform: none;
			transition: none;
		}
	}
</style>
