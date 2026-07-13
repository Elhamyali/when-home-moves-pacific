<script>
	import practices from "$data/idmc-good-practices-repository.csv";

	let selected = $state(null);

	function closeCard() {
		selected = null;
	}
</script>

<svelte:window
	onkeydown={(event) => {
		if (event.key === "Escape" && selected) closeCard();
	}}
/>

<figure class="good-practices">
	<figcaption>
		<h5>
			List of good practices to reduce the risk, scale, and impacts of internal
			displacement in the Pacific Islands
		</h5>
		<p>Click on a card to learn more about each good practice.</p>
	</figcaption>

	<div class="practice-grid" aria-label="IDMC good practices in the Pacific">
		{#each practices as practice}
			<button
				class="practice-card"
				type="button"
				onclick={() => (selected = practice)}
				aria-label={`Learn more about ${practice.good_practice_name} in ${practice.country}`}
			>
				<img
					src={`/assets/dataviz/good-practices/${practice.image_file}`}
					alt={practice.image}
				/>
				<span class="card-copy">
					<strong>{practice.good_practice_name}</strong>
					<span>{practice.country}</span>
				</span>
			</button>
		{/each}
	</div>

	<p class="note">
		Select a card to turn it over. Select outside the open card or press Escape
		to return to the grid.
	</p>
	<p class="source">
		Source: <a
			href="https://www.internal-displacement.org/good-practices/"
			target="_blank"
			rel="noreferrer">IDMC Global Repository of Good Practices</a
		>.
	</p>
</figure>

{#if selected}
	<button
		class="backdrop"
		type="button"
		onclick={closeCard}
		aria-label="Close good practice details"
	></button>
	<div
		class="card-dialog"
		role="dialog"
		aria-modal="true"
		aria-labelledby="practice-dialog-title"
	>
		<div class="card-inner">
			<article class="card-back">
				<button
					class="close"
					type="button"
					onclick={closeCard}
					aria-label="Close good practice details">×</button
				>
				<p class="eyebrow">{selected.country}</p>
				<h6 id="practice-dialog-title">{selected.good_practice_name}</h6>
				<dl>
					<div>
						<dt>Timeframe</dt>
						<dd>{selected.timeframe}</dd>
					</div>
					<div>
						<dt>Implemented by</dt>
						<dd>{selected.implementing_entity}</dd>
					</div>
				</dl>
				<p class="description">{selected.description}</p>
				<p class="image-credit">Image: {selected.image}</p>
				<a
					class="practice-link"
					href={selected.link_to_good_practice}
					target="_blank"
					rel="noreferrer"
					>Read this good practice at IDMC <span aria-hidden="true">↗</span></a
				>
			</article>
		</div>
	</div>
{/if}

<style>
	.good-practices {
		width: min(100%, 1080px);
		margin: clamp(64px, 8vw, 104px) auto clamp(42px, 5vw, 68px);
		font-family: "Inter", sans-serif;
	}
	figcaption {
		max-width: 900px;
	}
	h5 {
		margin: 0;
		font:
			700 clamp(18px, 2vw, 24px)/1.2 "Inter",
			sans-serif;
		letter-spacing: -0.02em;
	}
	figcaption p {
		margin: 8px 0 0;
		color: #444;
		font:
			400 clamp(15px, 1.6vw, 19px)/1.45 "Inter",
			sans-serif;
	}
	.practice-grid {
		display: grid;
		grid-template-columns: repeat(3, minmax(0, 1fr));
		gap: clamp(14px, 2.2vw, 26px);
		margin-top: 28px;
	}
	.practice-card {
		display: flex;
		min-width: 0;
		padding: 0;
		flex-direction: column;
		overflow: hidden;
		border: 0;
		border-radius: 3px;
		background: #f3f3f3;
		color: #111;
		box-shadow: 0 3px 14px rgba(0, 0, 0, 0.12);
		text-align: left;
		cursor: pointer;
		transition:
			transform 160ms ease,
			box-shadow 160ms ease;
	}
	.practice-card:hover {
		transform: translateY(-4px);
		box-shadow: 0 8px 22px rgba(0, 0, 0, 0.18);
	}
	.practice-card:focus-visible {
		outline: 3px solid #135ae1;
		outline-offset: 3px;
	}
	.practice-card img {
		display: block;
		width: 100%;
		aspect-ratio: 4/3;
		object-fit: cover;
		background: #ddd;
	}
	.card-copy {
		display: flex;
		min-height: 150px;
		padding: 18px;
		flex-direction: column;
		justify-content: space-between;
		gap: 18px;
	}
	.card-copy strong {
		font:
			700 clamp(16px, 1.55vw, 20px)/1.28 "Inter",
			sans-serif;
	}
	.card-copy span {
		color: #606060;
		font:
			500 14px/1.4 "Inter",
			sans-serif;
	}
	.note,
	.source {
		max-width: 820px;
		margin: 14px 0 0;
		color: #666;
		font:
			400 12px/1.5 "Inter",
			sans-serif;
	}
	.source {
		margin-top: 5px;
	}
	.source a,
	.practice-link {
		color: #057dbc;
		text-decoration: underline;
		text-underline-offset: 3px;
	}
	.backdrop {
		position: fixed;
		z-index: 20;
		inset: 0;
		width: 100%;
		height: 100%;
		padding: 0;
		border: 0;
		background: rgba(0, 0, 0, 0.68);
		cursor: zoom-out;
	}
	.card-dialog {
		position: fixed;
		z-index: 21;
		top: 50%;
		left: 50%;
		width: min(620px, calc(100% - 32px));
		max-height: calc(100svh - 32px);
		transform: translate(-50%, -50%);
		perspective: 1400px;
		pointer-events: none;
	}
	.card-inner {
		transform-style: preserve-3d;
		animation: turn-card 420ms cubic-bezier(0.2, 0.75, 0.25, 1) both;
	}
	.card-back {
		position: relative;
		max-height: calc(100svh - 32px);
		padding: clamp(24px, 4vw, 42px);
		overflow-y: auto;
		border-top: 8px solid #135ae1;
		border-radius: 3px;
		background: #fff;
		color: #111;
		box-shadow: 0 24px 70px rgba(0, 0, 0, 0.35);
		pointer-events: auto;
		backface-visibility: hidden;
	}
	.close {
		position: absolute;
		top: 12px;
		right: 14px;
		width: 38px;
		height: 38px;
		padding: 0;
		border: 0;
		background: transparent;
		color: #555;
		font:
			400 30px/1 "Inter",
			sans-serif;
		cursor: pointer;
	}
	.close:focus-visible {
		outline: 2px solid #135ae1;
		outline-offset: 2px;
	}
	.eyebrow {
		margin: 0 42px 8px 0;
		color: #135ae1;
		font:
			700 13px/1.3 "Inter",
			sans-serif;
		letter-spacing: 0.06em;
		text-transform: uppercase;
	}
	h6 {
		margin: 0;
		font:
			700 clamp(20px, 3vw, 30px)/1.2 "Inter",
			sans-serif;
		letter-spacing: -0.02em;
	}
	dl {
		display: grid;
		gap: 10px;
		margin: 24px 0 0;
	}
	dl div {
		display: grid;
		grid-template-columns: 110px 1fr;
		gap: 16px;
	}
	dt {
		color: #666;
		font:
			600 12px/1.45 "Inter",
			sans-serif;
		text-transform: uppercase;
		letter-spacing: 0.04em;
	}
	dd {
		margin: 0;
		font:
			500 14px/1.45 "Inter",
			sans-serif;
	}
	.description {
		margin: 24px 0 0;
		font:
			400 15px/1.6 "Inter",
			sans-serif;
	}
	.image-credit {
		margin: 20px 0 0;
		color: #666;
		font:
			400 12px/1.45 "Inter",
			sans-serif;
	}
	.practice-link {
		display: inline-block;
		margin-top: 22px;
		font:
			600 14px/1.4 "Inter",
			sans-serif;
	}
	@keyframes turn-card {
		from {
			opacity: 0.25;
			transform: translateY(18px) rotateY(90deg);
		}
		to {
			opacity: 1;
			transform: translateY(0) rotateY(0);
		}
	}
	@media (max-width: 760px) {
		.practice-grid {
			grid-template-columns: repeat(2, minmax(0, 1fr));
		}
	}
	@media (max-width: 520px) {
		.good-practices {
			width: calc(100% + 40px);
			margin-left: -20px;
		}
		figcaption,
		.note,
		.source {
			padding-inline: 20px;
		}
		.practice-grid {
			grid-template-columns: 1fr;
			padding-inline: 20px;
		}
		.card-copy {
			min-height: 120px;
		}
		dl div {
			grid-template-columns: 1fr;
			gap: 2px;
		}
	}
	@media (prefers-reduced-motion: reduce) {
		.practice-card {
			transition: none;
		}
		.card-inner {
			animation: none;
		}
	}
</style>
